Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26181 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751554AbdF2E75 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Jun 2017 00:59:57 -0400
Date: Wed, 28 Jun 2017 21:59:40 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] fs: ext4: inode->i_generation not assigned 0.
Message-ID: <20170629045940.GB5865@birch.djwong.org>
References: <c9f7090b2a58364998ad4a49cfdac379b905c7e9.1498687302.git.kkc6196@fb.com>
 <20A40B3C-E179-432B-B56F-BDAAF0CD2E1F@dilger.ca>
 <7CD38230-D961-428F-B2E9-2C0E28CAF442@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7CD38230-D961-428F-B2E9-2C0E28CAF442@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: William Koh <kkc6196@fb.com>
Cc: Andreas Dilger <adilger@dilger.ca>, Theodore Ts'o <tytso@mit.edu>, linux-ext4 <linux-ext4@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, "J. Bruce Fields" <bfields@fieldses.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, xfs <linux-xfs@vger.kernel.org>

[add linux-xfs to cc]

On Thu, Jun 29, 2017 at 04:37:14AM +0000, William Koh wrote:
> On 6/28/17, 7:32 PM, "Andreas Dilger" <adilger@dilger.ca> wrote:
> 
>     On Jun 28, 2017, at 4:06 PM, Kyungchan Koh <kkc6196@fb.com> wrote:
>     > 
>     > In fs/ext4/super.c, the function ext4_nfs_get_inode takes as input
>     > "generation" that can be used to specify the generation of the inode to
>     > be returned. When 0 is given as input, then inodes of any generation can
>     > be returned. Therefore, generation 0 is a special case that should be
>     > avoided when assigning generation to inodes.
>     
>     I'd agree with this change to avoid assigning generation == 0 to real inodes.
>     
>     Also, the separate question arises about whether we need to allow file handle
>     lookup with generation == 0?  That allows FID guessing easily, while requiring
>     a non-zero generation makes that a lot harder.
>     
>     What are the cases where generation == 0 are used?
> 
> Honestly, I’m not too sure. I just noticed that generation 0 was a special
> case from reading the code.
> 
>     > A new inline function, ext4_inode_set_gen, will take care of the
>     > problem.  Now, inodes cannot have a generation of 0, so this patch fixes
>     > the issue.
>     > 
>     > Signed-off-by: Kyungchan Koh <kkc6196@fb.com>
>     > 
>     > diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>     > index 3219154..74c6677 100644
>     > --- a/fs/ext4/ext4.h
>     > +++ b/fs/ext4/ext4.h
>     > @@ -1549,6 +1549,14 @@ static inline int ext4_valid_inum(struct super_block *sb, unsigned long ino)
>     > 		 ino <= le32_to_cpu(EXT4_SB(sb)->s_es->s_inodes_count));
>     > }
>     > 
>     > +static inline void ext4_inode_set_gen(struct inode *inode,
>     > +				      struct ext4_sb_info *sbi)
>     > +{
>     > +	inode->i_generation = sbi->s_next_generation++;
>     > +	if (!inode->i_generation)
>     
>     This should be marked "unlikely()" since it happens at most once every 4B
>     file creations (though likely even less since it is unlikely that so many
>     files will be created in a single mount).
> 
> Got it.
>     
>     > +		inode->i_generation = sbi->s_next_generation++;
>     > +}
>     > +
>     > 
>     > diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
>     > index 98ac2f1..d33f6f0 100644
>     > --- a/fs/ext4/ialloc.c
>     > +++ b/fs/ext4/ialloc.c
>     > @@ -1072,7 +1072,7 @@ struct inode *__ext4_new_inode(handle_t *handle, struct inode	}
>     > 	spin_lock(&sbi->s_next_gen_lock);
>     > -	inode->i_generation = sbi->s_next_generation++;
>     > +	ext4_inode_set_gen(inode, sbi);
>     > 	spin_unlock(&sbi->s_next_gen_lock);
>     > 
>     > diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
>     > index 0c21e22..d52a467 100644
>     > --- a/fs/ext4/ioctl.c
>     > +++ b/fs/ext4/ioctl.c
>     > @@ -160,8 +160,8 @@ static long swap_inode_boot_loader(struct super_block *sb,
>     > 
>     > 	spin_lock(&sbi->s_next_gen_lock);
>     > -	inode->i_generation = sbi->s_next_generation++;
>     > -	inode_bl->i_generation = sbi->s_next_generation++;
>     > +	ext4_inode_set_gen(inode, sbi);
>     > +	ext4_inode_set_gen(inode_bl, sbi);
>     > 	spin_unlock(&sbi->s_next_gen_lock);
>     > 
>     
>     
>     Cheers, Andreas
> 
> This is applicable to many fs, including ext2, ext4, exofs, jfs, and f2fs.
> Therefore, a shared helper in linux/fs.h will allow for easy changes
> in all fs. Is there any reason that might be a bad idea?

AFAICT, i_generation == 0 in XFS and btrfs is just as valid as any other
number.  There is no special casing of zero in either filesystem.

So now, my curiosity intrigued, I surveyed all the Linux filesystems
that can export to NFS.  I see that there are actually quite a few fs
(ext[2-4], exofs, efs, fat, jfs, f2fs, isofs, nilfs2, reiserfs, udf,
ufs) that treat zero as a special value meaning "ignore generation
check"; others (xfs, btrfs, fuse, ntfs, ocfs2) that don't consider zero
special and always require a match; and still others (affs, befs, ceph,
gfs2, jffs2, squashfs) that don't check at all.

That to mean strongly suggests that more research is necessary to figure
out why some of the filesystems that support i_generation reserve zero
as a special value to disable generation checks and why others always
require an exact match.  Until we can recapture why things are they way
they are, it doesn't make much sense to have a helper that only applies
to half the filesystems.

Granted, the contents of a file handle are generally left up to the
individual filesystem, and the behaviors are very different, so I also
don't see that much value in hoisting i_generation updates to the VFS
level.

I guess it wouldn't really matter if XFS stopped writing i_generation =
0 onto disk, but I'm too curious about this odd difference in behavior
to let it go just yet. :)

--D

> 
> Best,
> Kyungchan Koh 
>     
>     
>     
>     
> 
