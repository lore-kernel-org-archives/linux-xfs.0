Return-Path: <SRS0=IYS1=XL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82E4DC49ED7
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Sep 2019 17:14:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D88A21852
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Sep 2019 17:14:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729337AbfIPROn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Sep 2019 13:14:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55052 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729297AbfIPROn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 16 Sep 2019 13:14:43 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D7DF718CB8F6;
        Mon, 16 Sep 2019 17:14:42 +0000 (UTC)
Received: from localhost (dhcp-12-102.nay.redhat.com [10.66.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4DB6A60BF7;
        Mon, 16 Sep 2019 17:14:42 +0000 (UTC)
Date:   Tue, 17 Sep 2019 01:22:03 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] [RFC] xfs: fix inode fork extent count overflow
Message-ID: <20190916172202.GJ7239@dhcp-12-102.nay.redhat.com>
References: <20190911012107.26553-1-david@fromorbit.com>
 <20190916162005.GX2229799@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190916162005.GX2229799@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.63]); Mon, 16 Sep 2019 17:14:42 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 16, 2019 at 09:20:05AM -0700, Darrick J. Wong wrote:
> On Wed, Sep 11, 2019 at 11:21:07AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > [commit message is verbose for discussion purposes - will trim it
> > down later. Some questions about implementation details at the end.]
> > 
> > Zorro Lang recently ran a new test to stress single inode extent
> > counts now that they are no longer limited by memory allocation.
> > The test was simply:
> > 
> > # xfs_io -f -c "falloc 0 40t" /mnt/scratch/big-file
> > # ~/src/xfstests-dev/punch-alternating /mnt/scratch/big-file
> > 
> > This test uncovered a problem where the hole punching operation
> > appeared to finish with no error, but apparently only created 268M
> > extents instead of the 10 billion it was supposed to.
> > 
> > Further, trying to punch out extents that should have been present
> > resulted in success, but no change in the extent count. It looked
> > like a silent failure.
> > 
> > While running the test and observing the behaviour in real time,
> > I observed the extent coutn growing at ~2M extents/minute, and saw
> > this after about an hour:
> > 
> > # xfs_io -f -c "stat" /mnt/scratch/big-file |grep next ; \
> > > sleep 60 ; \
> > > xfs_io -f -c "stat" /mnt/scratch/big-file |grep next
> > fsxattr.nextents = 127657993
> > fsxattr.nextents = 129683339
> > #
> > 
> > And a few minutes later this:
> > 
> > # xfs_io -f -c "stat" /mnt/scratch/big-file |grep next
> > fsxattr.nextents = 4177861124
> > #
> > 
> > Ah, what? Where did that 4 billion extra extents suddenly come from?
> > 
> > Stop the workload, unmount, mount:
> > 
> > # xfs_io -f -c "stat" /mnt/scratch/big-file |grep next
> > fsxattr.nextents = 166044375
> > #
> > 
> > And it's back at the expected number. i.e. the extent count is
> > correct on disk, but it's screwed up in memory. I loaded up the
> > extent list, and immediately:
> > 
> > # xfs_io -f -c "stat" /mnt/scratch/big-file |grep next
> > fsxattr.nextents = 4192576215
> > #
> > 
> > It's bad again. So, where does that number come from?
> > xfs_fill_fsxattr():
> > 
> >                 if (ip->i_df.if_flags & XFS_IFEXTENTS)
> >                         fa->fsx_nextents = xfs_iext_count(&ip->i_df);
> >                 else
> >                         fa->fsx_nextents = ip->i_d.di_nextents;
> > 
> > And that's the behaviour I just saw in a nutshell. The on disk count
> > is correct, but once the tree is loaded into memory, it goes whacky.
> > Clearly there's something wrong with xfs_iext_count():
> > 
> > inline xfs_extnum_t xfs_iext_count(struct xfs_ifork *ifp)
> > {
> >         return ifp->if_bytes / sizeof(struct xfs_iext_rec);
> > }
> > 
> > Simple enough, but 134M extents is 2**27, and that's right about
> 
> On the plus side, 2^27 is way better than the last time anyone tried to
> create an egregious number of extents.
> 
> > where things went wrong. A struct xfs_iext_rec is 16 bytes in size,
> > which means 2**27 * 2**4 = 2**31 and we're right on target for an
> > integer overflow. And, sure enough:
> > 
> > struct xfs_ifork {
> >         int                     if_bytes;       /* bytes in if_u1 */
> > ....
> > 
> > Once we get 2**27 extents in a file, we overflow if_bytes and the
> > in-core extent count goes wrong. And when we reach 2**28 extents,
> > if_bytes wraps back to zero and things really start to go wrong
> > there. This is where the silent failure comes from - only the first
> > 2**28 extents can be looked up directly due to the overflow, all the
> > extents above this index wrap back to somewhere in the first 2**28
> > extents. Hence with a regular pattern, trying to punch a hole in the
> > range that didn't have holes mapped to a hole in the first 2**28
> > extents and so "succeeded" without changing anything. Hence "silent
> > failure"...
> > 
> > Fix this by converting if_bytes to a int64_t and converting all the
> > index variables and size calculations to use int64_t types to avoid
> > overflows in future. Signed integers are still used to enable easy
> > detection of extent count underflows. This enables scalability of
> > extent counts to the limits of the on-disk format - MAXEXTNUM
> > (2**31) extents.
> > 
> > Current testing is at over 500M extents and still going:
> > 
> > fsxattr.nextents = 517310478
> > 
> > Reported-by: Zorro Lang <zlang@redhat.com>
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> Looks reasonable to me; did Zorro retest w/ this patch?

After merging this patch, currently I've gotten:

# xfs_io -c stat /mnt/500Test/2nd-40t-file
fd.path = "/mnt/500Test/2nd-40t-file"
fd.flags = non-sync,non-direct,read-write
stat.ino = 132
stat.type = regular file
stat.size = 43980465111040
stat.blocks = 79880689352
fsxattr.xflags = 0x80000002 [-p--------------]
fsxattr.projid = 0
fsxattr.extsize = 0
fsxattr.cowextsize = 0
fsxattr.nextents = 755358063
fsxattr.naextents = 0
dioattr.mem = 0x200
dioattr.miniosz = 512
dioattr.maxiosz = 2147483136

And the *nextents* is still increasing. So I think this patch works as it
expects. But I haven't gotten enough time to hit the MAX extents limitation.
I'll let the test keep running, to see what'll happen.

I'll do more test after you merge this patch into xfs-linux.

Thanks,
Zorro


> 
> If so,
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> --D
> 
> > ---
> >  fs/xfs/libxfs/xfs_attr_leaf.c  | 18 ++++++++++--------
> >  fs/xfs/libxfs/xfs_dir2_sf.c    |  2 +-
> >  fs/xfs/libxfs/xfs_iext_tree.c  |  2 +-
> >  fs/xfs/libxfs/xfs_inode_fork.c |  8 ++++----
> >  fs/xfs/libxfs/xfs_inode_fork.h | 14 ++++++++------
> >  5 files changed, 24 insertions(+), 20 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> > index b9f019603d0b..0bfb1ba919e2 100644
> > --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> > +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> > @@ -453,13 +453,15 @@ xfs_attr_copy_value(
> >   * special case for dev/uuid inodes, they have fixed size data forks.
> >   */
> >  int
> > -xfs_attr_shortform_bytesfit(xfs_inode_t *dp, int bytes)
> > +xfs_attr_shortform_bytesfit(
> > +	struct xfs_inode	*dp,
> > +	int			bytes)
> >  {
> > -	int offset;
> > -	int minforkoff;	/* lower limit on valid forkoff locations */
> > -	int maxforkoff;	/* upper limit on valid forkoff locations */
> > -	int dsize;
> > -	xfs_mount_t *mp = dp->i_mount;
> > +	struct xfs_mount	*mp = dp->i_mount;
> > +	int64_t			dsize;
> > +	int			minforkoff;
> > +	int			maxforkoff;
> > +	int			offset;
> >  
> >  	/* rounded down */
> >  	offset = (XFS_LITINO(mp, dp->i_d.di_version) - bytes) >> 3;
> > @@ -525,7 +527,7 @@ xfs_attr_shortform_bytesfit(xfs_inode_t *dp, int bytes)
> >  	 * A data fork btree root must have space for at least
> >  	 * MINDBTPTRS key/ptr pairs if the data fork is small or empty.
> >  	 */
> > -	minforkoff = max(dsize, XFS_BMDR_SPACE_CALC(MINDBTPTRS));
> > +	minforkoff = max_t(int64_t, dsize, XFS_BMDR_SPACE_CALC(MINDBTPTRS));
> >  	minforkoff = roundup(minforkoff, 8) >> 3;
> >  
> >  	/* attr fork btree root can have at least this many key/ptr pairs */
> > @@ -939,7 +941,7 @@ xfs_attr_shortform_verify(
> >  	char				*endp;
> >  	struct xfs_ifork		*ifp;
> >  	int				i;
> > -	int				size;
> > +	int64_t				size;
> >  
> >  	ASSERT(ip->i_d.di_aformat == XFS_DINODE_FMT_LOCAL);
> >  	ifp = XFS_IFORK_PTR(ip, XFS_ATTR_FORK);
> > diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
> > index 85f14fc2a8da..ae16ca7c422a 100644
> > --- a/fs/xfs/libxfs/xfs_dir2_sf.c
> > +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
> > @@ -628,7 +628,7 @@ xfs_dir2_sf_verify(
> >  	int				i;
> >  	int				i8count;
> >  	int				offset;
> > -	int				size;
> > +	int64_t				size;
> >  	int				error;
> >  	uint8_t				filetype;
> >  
> > diff --git a/fs/xfs/libxfs/xfs_iext_tree.c b/fs/xfs/libxfs/xfs_iext_tree.c
> > index 7bc87408f1a0..52451809c478 100644
> > --- a/fs/xfs/libxfs/xfs_iext_tree.c
> > +++ b/fs/xfs/libxfs/xfs_iext_tree.c
> > @@ -596,7 +596,7 @@ xfs_iext_realloc_root(
> >  	struct xfs_ifork	*ifp,
> >  	struct xfs_iext_cursor	*cur)
> >  {
> > -	size_t new_size = ifp->if_bytes + sizeof(struct xfs_iext_rec);
> > +	int64_t new_size = ifp->if_bytes + sizeof(struct xfs_iext_rec);
> >  	void *new;
> >  
> >  	/* account for the prev/next pointers */
> > diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> > index c643beeb5a24..8fdd0424070e 100644
> > --- a/fs/xfs/libxfs/xfs_inode_fork.c
> > +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> > @@ -129,7 +129,7 @@ xfs_init_local_fork(
> >  	struct xfs_inode	*ip,
> >  	int			whichfork,
> >  	const void		*data,
> > -	int			size)
> > +	int64_t			size)
> >  {
> >  	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
> >  	int			mem_size = size, real_size = 0;
> > @@ -467,11 +467,11 @@ xfs_iroot_realloc(
> >  void
> >  xfs_idata_realloc(
> >  	struct xfs_inode	*ip,
> > -	int			byte_diff,
> > +	int64_t			byte_diff,
> >  	int			whichfork)
> >  {
> >  	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
> > -	int			new_size = (int)ifp->if_bytes + byte_diff;
> > +	int64_t			new_size = ifp->if_bytes + byte_diff;
> >  
> >  	ASSERT(new_size >= 0);
> >  	ASSERT(new_size <= XFS_IFORK_SIZE(ip, whichfork));
> > @@ -552,7 +552,7 @@ xfs_iextents_copy(
> >  	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
> >  	struct xfs_iext_cursor	icur;
> >  	struct xfs_bmbt_irec	rec;
> > -	int			copied = 0;
> > +	int64_t			copied = 0;
> >  
> >  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL | XFS_ILOCK_SHARED));
> >  	ASSERT(ifp->if_bytes > 0);
> > diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> > index 00c62ce170d0..7b845c052fb4 100644
> > --- a/fs/xfs/libxfs/xfs_inode_fork.h
> > +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> > @@ -13,16 +13,16 @@ struct xfs_dinode;
> >   * File incore extent information, present for each of data & attr forks.
> >   */
> >  struct xfs_ifork {
> > -	int			if_bytes;	/* bytes in if_u1 */
> > -	unsigned int		if_seq;		/* fork mod counter */
> > +	int64_t			if_bytes;	/* bytes in if_u1 */
> >  	struct xfs_btree_block	*if_broot;	/* file's incore btree root */
> > -	short			if_broot_bytes;	/* bytes allocated for root */
> > -	unsigned char		if_flags;	/* per-fork flags */
> > +	unsigned int		if_seq;		/* fork mod counter */
> >  	int			if_height;	/* height of the extent tree */
> >  	union {
> >  		void		*if_root;	/* extent tree root */
> >  		char		*if_data;	/* inline file data */
> >  	} if_u1;
> > +	short			if_broot_bytes;	/* bytes allocated for root */
> > +	unsigned char		if_flags;	/* per-fork flags */
> >  };
> >  
> >  /*
> > @@ -93,12 +93,14 @@ int		xfs_iformat_fork(struct xfs_inode *, struct xfs_dinode *);
> >  void		xfs_iflush_fork(struct xfs_inode *, struct xfs_dinode *,
> >  				struct xfs_inode_log_item *, int);
> >  void		xfs_idestroy_fork(struct xfs_inode *, int);
> > -void		xfs_idata_realloc(struct xfs_inode *, int, int);
> > +void		xfs_idata_realloc(struct xfs_inode *ip, int64_t byte_diff,
> > +				int whichfork);
> >  void		xfs_iroot_realloc(struct xfs_inode *, int, int);
> >  int		xfs_iread_extents(struct xfs_trans *, struct xfs_inode *, int);
> >  int		xfs_iextents_copy(struct xfs_inode *, struct xfs_bmbt_rec *,
> >  				  int);
> > -void		xfs_init_local_fork(struct xfs_inode *, int, const void *, int);
> > +void		xfs_init_local_fork(struct xfs_inode *ip, int whichfork,
> > +				const void *data, int64_t size);
> >  
> >  xfs_extnum_t	xfs_iext_count(struct xfs_ifork *ifp);
> >  void		xfs_iext_insert(struct xfs_inode *, struct xfs_iext_cursor *cur,
> > -- 
> > 2.23.0.rc1
> > 
