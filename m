Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:2996 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726902AbeH0I0j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Aug 2018 04:26:39 -0400
Date: Mon, 27 Aug 2018 14:41:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: verify size-vs-format for symlinks & dirs
Message-ID: <20180827044140.GG2234@dastard>
References: <b0919ac0-deb3-4a0c-f755-309dd65c3206@redhat.com>
 <20180827014314.GF2234@dastard>
 <02c044f4-a1d9-b911-2b41-74d6d49f9242@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02c044f4-a1d9-b911-2b41-74d6d49f9242@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, "Xu, Wen" <wen.xu@gatech.edu>

On Sun, Aug 26, 2018 at 09:19:19PM -0500, Eric Sandeen wrote:
> On 8/26/18 8:43 PM, Dave Chinner wrote:
> > Now, size checks - if a directory inode data fork is in extent or
> > btree format, then it must be at least in block form and so it's
> > size must be equal to or larger than the directory block size.
> > Hence the above check misses a whole range on invalid directory
> > sizes for extent/btree forms. I think we should check directories
> > against against the directory block size, so avoid needing to trust
> > any other inode fields at all.
> > 
> > Symlinks, though, aren't so nice. Even a short symlink can be pushed
> > into extent form if enough attributes are created, and the size
> > remains the same even though it now consumes entire blocks, so I
> > think we can only check against XFS_IFORK_DSIZE - there's nothing
> > else we can verify against.
> > 
> > so maybe something like this? 
> 
> I like this structure better, yes.
> 
> > 	if (ip->i_d.di_format != XFS_DINODE_FMT_LOCAL) {
> > 		/*
> > 		 * types that can be in local form need size checks
> > 		 * to ensure they have the right amount of data in
> > 		 * them to be in non-local form
> > 		 */
> > 		switch (mode & S_IFMT) {
> > 		case S_IFDIR:
> > 			if (ip->i_d.di_size < mp->m_dir_geo->blksize)
> > 				return __this_address;
> > 			break;
> 
> TBH, I wasn't working from first principles, just looking at
> process_check_inode_sizes():
> 
>         xfs_fsize_t     size = be64_to_cpu(dino->di_size);
> 
>         switch (type)  {
> 
>         case XR_INO_DIR:
>                 if (size <= XFS_DFORK_DSIZE(dino, mp) &&
>                                 dino->di_format != XFS_DINODE_FMT_LOCAL) {
>                         do_warn(
> _("mismatch between format (%d) and size (%" PRId64 ") in directory ino %" PRIu64 "\n"),
>                                 dino->di_format, size, lino);
>                         return 1;
>                 }
> 
> and it's checking dir size against XFS_DFORK_DSIZE not blocksize in repair...?

Sure, but you made me think about it without looking at the repair
code. Yes, the repair code may catch the specific corruption, but
we know that the reapir doesn't always catch everything as well as
it could...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
