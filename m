Return-Path: <SRS0=zOuE=3S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFC33C2D0DB
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jan 2020 23:20:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99B6420678
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jan 2020 23:20:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbgA2XUK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jan 2020 18:20:10 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:42232 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726618AbgA2XUK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jan 2020 18:20:10 -0500
Received: from dread.disaster.area (pa49-195-111-217.pa.nsw.optusnet.com.au [49.195.111.217])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id D0F2D3A15D4;
        Thu, 30 Jan 2020 10:20:06 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iwwcv-0005MF-M1; Thu, 30 Jan 2020 10:20:05 +1100
Date:   Thu, 30 Jan 2020 10:20:05 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Pavel Reichl <preichl@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: change xfs_isilocked() to always use lockdep()
Message-ID: <20200129232005.GP18610@dread.disaster.area>
References: <20200128145528.2093039-1-preichl@redhat.com>
 <20200128145528.2093039-2-preichl@redhat.com>
 <20200129221819.GO18610@dread.disaster.area>
 <20200129222532.GW3447196@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200129222532.GW3447196@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=0OveGI8p3fsTA6FL6ss4ZQ==:117 a=0OveGI8p3fsTA6FL6ss4ZQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=Jdjhy38mL1oA:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=2v7RYwIjjYj12rUPZWoA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 29, 2020 at 02:25:32PM -0800, Darrick J. Wong wrote:
> On Thu, Jan 30, 2020 at 09:18:19AM +1100, Dave Chinner wrote:
> > On Tue, Jan 28, 2020 at 03:55:25PM +0100, Pavel Reichl wrote:
> > > mr_writer is obsolete and the information it contains is accesible
> > > from mr_lock.
> > > 
> > > Signed-off-by: Pavel Reichl <preichl@redhat.com>
> > > ---
> > >  fs/xfs/xfs_inode.c | 8 ++++++--
> > >  1 file changed, 6 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > > index c5077e6326c7..32fac6152dc3 100644
> > > --- a/fs/xfs/xfs_inode.c
> > > +++ b/fs/xfs/xfs_inode.c
> > > @@ -352,13 +352,17 @@ xfs_isilocked(
> > >  {
> > >  	if (lock_flags & (XFS_ILOCK_EXCL|XFS_ILOCK_SHARED)) {
> > >  		if (!(lock_flags & XFS_ILOCK_SHARED))
> > > -			return !!ip->i_lock.mr_writer;
> > > +			return !debug_locks ||
> > > +				lockdep_is_held_type(&ip->i_lock.mr_lock, 0);
> > >  		return rwsem_is_locked(&ip->i_lock.mr_lock);
> > >  	}
> > >  
> > >  	if (lock_flags & (XFS_MMAPLOCK_EXCL|XFS_MMAPLOCK_SHARED)) {
> > >  		if (!(lock_flags & XFS_MMAPLOCK_SHARED))
> > > -			return !!ip->i_mmaplock.mr_writer;
> > > +			return !debug_locks ||
> > > +				lockdep_is_held_type(
> > > +					&ip->i_mmaplock.mr_lock,
> > > +					0);
> > >  		return rwsem_is_locked(&ip->i_mmaplock.mr_lock);
> > >  	}
> > 
> > Ok, so this code is only called from ASSERT() statements, which
> > means this turns off write lock checking for XFS debug kernels if
> > lockdep is not enabled. Hence I think these checks need to be
> > restructured to be based around rwsem_is_locked() first and lockdep
> > second.
> > 
> > That is:
> > 
> > /* In all implementations count != 0 means locked */
> > static inline int rwsem_is_locked(struct rw_semaphore *sem)
> > {
> >         return atomic_long_read(&sem->count) != 0;
> > }
> > 
> > This captures both read and write locks on the rwsem, and doesn't
> > discriminate at all. Now we don't have explicit writer lock checking
> > in CONFIG_XFS_DEBUG=y kernels, I think we need to at least check
> > that the rwsem is locked in all cases to catch cases where we are
> > calling a function without the lock held. That will ctach most
> > programming mistakes, and then lockdep will provide the
> > read-vs-write discrimination to catch the "hold the wrong lock type"
> > mistakes.
> > 
> > Hence I think this code should end up looking like this:
> > 
> > 	if (lock_flags & (XFS_ILOCK_EXCL|XFS_ILOCK_SHARED)) {
> > 		bool locked = false;
> > 
> > 		if (!rwsem_is_locked(&ip->i_lock))
> > 			return false;
> > 		if (!debug_locks)
> > 			return true;
> > 		if (lock_flags & XFS_ILOCK_EXCL)
> > 			locked = lockdep_is_held_type(&ip->i_lock, 0);
> > 		if (lock_flags & XFS_ILOCK_SHARED)
> > 			locked |= lockdep_is_held_type(&ip->i_lock, 1);
> > 		return locked;
> > 	}
> > 
> > Thoughts?
> 
> I like that a lot better, though perhaps the if body should be factored
> into a separate static inline so we don't repeat that 3x.

Yup, I had thoughts along those lines, too, but each lock type uses
different flags and that makes it more verbose than it could be.
Maybe something like this?

static inline bool
__xfs_is_ilocked(
	struct rwsem	*rwsem,
	bool		shared,
	bool		excl)
{
	bool locked = false;

	if (!rwsem_is_locked(rwsem))
		return false;
	if (!debug_locks)
		return true;
	if (shared)
		locked = lockdep_is_held_type(&ip->i_lock, 0);
	if (excl)
		locked |= lockdep_is_held_type(&ip->i_lock, 1);
	return locked;
}

bool
xfs_isilocked(
	struct xfs_inode	*ip,
	int			lock_flags)
{
	if (lock_flags & (XFS_ILOCK_EXCL|XFS_ILOCK_SHARED))
		return __xfs_is_ilocked(&ip->i_lock,
				(lock_flags & XFS_ILOCK_SHARED),
				(lock_flags & XFS_ILOCK_EXCL));

	if (lock_flags & (XFS_MMAPLOCK_EXCL|XFS_MMAPLOCK_SHARED))
		return __xfs_is_ilocked(&ip->i_mmaplock,
				(lock_flags & XFS_MMAPLOCK_SHARED),
				(lock_flags & XFS_MMAPLOCK_EXCL));

	if (lock_flags & (XFS_IOLOCK_EXCL|XFS_IOLOCK_SHARED))
		return __xfs_is_ilocked(&VFS_I(ip)->i_rwsem,
				(lock_flags & XFS_IOLOCK_SHARED),
				(lock_flags & XFS_IOLOCK_EXCL));

	ASSERT(0);
	return false;
}

At which point I wonder if it would simply be better to have:

bool
xfs_is_ilocked(
	struct xfs_inode	*ip,
	int			lock_flags)
{
	return __xfs_is_ilocked(&ip->i_lock, (lock_flags & XFS_ILOCK_SHARED),
				(lock_flags & XFS_ILOCK_EXCL));
}

bool
xfs_is_mmaplocked(
	struct xfs_inode	*ip,
	int			lock_flags)
{
	return __xfs_is_ilocked(&ip->i_mmaplock,
				(lock_flags & XFS_MMAPLOCK_SHARED),
				(lock_flags & XFS_MMAPLOCK_EXCL));
}

bool
xfs_is_iolocked(
	struct xfs_inode	*ip,
	int			lock_flags)
{
	return __xfs_is_ilocked(&VFS_I(ip)->i_rwsem,
				(lock_flags & XFS_IOLOCK_SHARED),
				(lock_flags & XFS_IOLOCK_EXCL));
}

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
