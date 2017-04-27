Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22538 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967434AbdD0Tbd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Apr 2017 15:31:33 -0400
Date: Thu, 27 Apr 2017 12:31:18 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: publish UUID in struct super_block
Message-ID: <20170427193118.GH23371@birch.djwong.org>
References: <1493279911-2936-1-git-send-email-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1493279911-2936-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Miklos Szeredi <miklos@szeredi.hu>, Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Thu, Apr 27, 2017 at 10:58:31AM +0300, Amir Goldstein wrote:
> Unless mounted with nouuid, copy the uuid of the filesystem to
> struct super block s_uuid field, as several other filesystems do.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/xfs/xfs_mount.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> Darrick,
> 
> The VFS sb->s_uuid field is needed for a new overlay feature
> 'constant inode numbers' [1].
> 
> We store the filesystem uuid along with encoded file handles, so that
> we can verify later that we are encoding file handles from the same
> filesystem from which the handles were encoded.
>
> At least the following filesystems set sb->s_uuid: ext4, f2fs, jfs, ocfs2.

I dug into the history of s_uuid and discovered that originally it was a
way to export the fs uuid via mountinfo in /proc, but that usage went
away quickly, so now the only users are cleancache, evm, and ima.  The
last two will use s_uuid if the administrator (I think?) tells it to,
and it doesn't seem to care about the uniqueness.

To me that sounds like the semantics of s_uuid are to fill it in if the
fs wants to, but that the fs doesn't make any guarantees about the
contents.

> Specifically, btrfs does not set sb->s_uuid, I think because it has many
> uuid's per super_block struct.
> 
> I see no obvious reason for xfs not to set sb->s_uuid so here goes.
> 
> I made a choice not to set sb->s_uuid in case xfs was mounted with nouuid,
> to maintain a self inflicted rule that sb->s_uuid is unique in a system
> for an xfs super_block.  This is an arbitrary decision so others may not
> agree with it.
>
> My reasoning in the context of verifying file handles is this -
> If a file handle was exported from one copy of an xfs filesystem, I rather
> it was not decoded from another copy of the filesystem (i.e. LVM snapshot),
> at least not while both copies are mounted on the same system.

I disagree.  ext4, f2fs, gfs2, ocfs2, and ubifs all set s_uuid
unconditionally, even if that means there are multiple struct
superblocks floating around with the same s_uuid.  Now, I surmise that
for overlayfs copy-up you want to be able to store (sb_uuid, fh) as an
xattr to keep track of the original inode, and for that you really /do/
want sb_uuid to be unique.

But therein lies a problem -- if another ext4 fs shows up with the same
uuid and the overlayfs accidentally gets paired with the second ext4,
your stored xattr is toast because you can't tell that this is the wrong
filesystem... unless you already detect this situation?

I suppose since this xattr thing is an optimization(?) you /could/
actually keep track of whether or not there are mounted fses with the
same s_uuid and therefore know whether or not it's safe to use it.

I don't have an objection to XFS filling out s_uuid unconditionally like
the other filesystems do.  If we want to change the meaning of that
field, let's change all of the fses at once.

> I tested the patch is working correctly with and without nouuid with my
> overlayfs constant inode tests. I do have xfstests that check overlay
> constant inodes, but they are of little use to you without the overlayfs
> patches.
> 
> Here is what it looks like when running constant inode verification test
> for overlayfs above xfs mounted with nouuid:
> ~/unionmount-testsuite# ./run --ov=0 --samefs hard-link
> ...
> XFS (vdf): Ending clean mount
> overlayfs: lower fs needs to report s_uuid.
>  ./run --link /mnt/a/foo100 /mnt/a/no_foo100
> sh (2748): drop_caches: 3
> overlayfs: lower fs needs to report s_uuid.
> /mnt/a/no_foo100: inode number wrong (got 442, want 137)
> 
> The same test passes with overlayfs over ext4 and with overlay over xfs

What happens if you create two ext4 filesystems with the same uuid,
mount an overlay with one ext4, make some changes, then unmount the
overlay and mount it with the other ext4?

--D

> mounted without nouuid (and with this patch applied naturally).
> 
> I'd appreciate if you could queue this simple patch for v4.12.
> 
> Thanks,
> Amir.
> 
> [1] https://marc.info/?l=linux-unionfs&m=149324252301397&w=2
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 450bde6..29e45a0 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -100,6 +100,9 @@ xfs_uuid_mount(
>  	xfs_uuid_table[hole] = *uuid;
>  	mutex_unlock(&xfs_uuid_table_mutex);
>  
> +	/* Publish UUID in struct super_block */
> +	BUILD_BUG_ON(sizeof(mp->m_super->s_uuid) != sizeof(uuid_t));
> +	memcpy(&mp->m_super->s_uuid, uuid, sizeof(uuid_t));
>  	return 0;
>  
>   out_duplicate:
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
