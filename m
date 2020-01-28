Return-Path: <SRS0=UJS8=3R=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97276C2D0DB
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jan 2020 23:02:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72AB02087F
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jan 2020 23:02:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726389AbgA1XCp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jan 2020 18:02:45 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:54582 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726303AbgA1XCp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jan 2020 18:02:45 -0500
Received: from dread.disaster.area (pa49-195-111-217.pa.nsw.optusnet.com.au [49.195.111.217])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 9858A43FF60;
        Wed, 29 Jan 2020 10:02:43 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iwZsY-0005HK-Vi; Wed, 29 Jan 2020 10:02:42 +1100
Date:   Wed, 29 Jan 2020 10:02:42 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Pavel Reichl <preichl@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: change xfs_isilocked() to always use lockdep()
Message-ID: <20200128230242.GF18610@dread.disaster.area>
References: <20200128145528.2093039-1-preichl@redhat.com>
 <20200128145528.2093039-2-preichl@redhat.com>
 <20200128164200.GP3447196@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200128164200.GP3447196@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=0OveGI8p3fsTA6FL6ss4ZQ==:117 a=0OveGI8p3fsTA6FL6ss4ZQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=Jdjhy38mL1oA:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=3ili6qVZdwNxBR0x5tUA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 28, 2020 at 08:42:00AM -0800, Darrick J. Wong wrote:
> On Tue, Jan 28, 2020 at 03:55:25PM +0100, Pavel Reichl wrote:
> > mr_writer is obsolete and the information it contains is accesible
> > from mr_lock.
> > 
> > Signed-off-by: Pavel Reichl <preichl@redhat.com>
> > ---
> >  fs/xfs/xfs_inode.c | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index c5077e6326c7..32fac6152dc3 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -352,13 +352,17 @@ xfs_isilocked(
> >  {
> >  	if (lock_flags & (XFS_ILOCK_EXCL|XFS_ILOCK_SHARED)) {
> >  		if (!(lock_flags & XFS_ILOCK_SHARED))
> > -			return !!ip->i_lock.mr_writer;
> > +			return !debug_locks ||
> > +				lockdep_is_held_type(&ip->i_lock.mr_lock, 0);
> 
> Why do we reference debug_locks here directly?  It looks as though that
> variable exists to shut up lockdep assertions WARN_ONs, but
> xfs_isilocked is a predicate (and not itself an assertion), so why can't
> we 'return lockdep_is_held_type(...);' directly?

It's because that's the way lockdep is structured. That is, lockdep
turns off when the first error is reported, and debug_locks is the
variable used to turn lockdep warnings/checking off once an error
has occurred.

It is normally wrapped in lockdep_assert...() macros so you don't
see it, but it is not referenced at all inside the lockdep functions
that do the actual lock state checking. Hence to replicate lockdep
behaviour, we have to check it, too.

The lockdep code now has these wrappers for rwsems:

#define lockdep_assert_held_write(l)    do {                    \
                WARN_ON(debug_locks && !lockdep_is_held_type(l, 0));    \
        } while (0)

#define lockdep_assert_held_read(l)     do {                            \
                WARN_ON(debug_locks && !lockdep_is_held_type(l, 1));    \
        } while (0)

But xfs_isilocked() is called from within ASSERT() calls, so we
don't want WARN_ON() calls within the ASSERT() calls which provide
their own WARN/BUG handling.

IOWs, we essentially open coded lockdep_assert_held_read (and now
_write) to fit into our own framework of lock checking.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
