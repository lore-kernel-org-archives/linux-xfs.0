Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37712 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750989AbeEKVMV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 11 May 2018 17:12:21 -0400
Date: Fri, 11 May 2018 23:12:18 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC v2 3/4] ext4: add verifier check for symlink with
 append/immutable flags
Message-ID: <20180511211218.rs365ftuw53c4qj2@quack2.suse.cz>
References: <20180510231359.16899-1-mcgrof@kernel.org>
 <20180510231359.16899-4-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180510231359.16899-4-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: viro@zeniv.linux.org.uk, darrick.wong@oracle.com, tytso@mit.edu, adilger.kernel@dilger.ca, clm@fb.com, jbacik@fb.com, dsterba@suse.com, sandeen@sandeen.net, dhowells@redhat.com, fliu@suse.com, jack@suse.cz, jeffm@suse.com, nborisov@suse.com, jake.norris@suse.com, mtk.manpages@gmail.com, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu 10-05-18 16:13:58, Luis R. Rodriguez wrote:
> The Linux VFS does not allow a way to set append/immuttable
> attributes to symlinks, this is just not possible. If this is
> detected inform the user as the filesystem must be corrupted.
> 
> Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>

Looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/inode.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 37a2f7a2b66a..6acf0dd6b6e6 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4947,6 +4947,13 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
>  		inode->i_op = &ext4_dir_inode_operations;
>  		inode->i_fop = &ext4_dir_operations;
>  	} else if (S_ISLNK(inode->i_mode)) {
> +		/* VFS does not allow setting these so must be corruption */
> +		if (IS_APPEND(inode) || IS_IMMUTABLE(inode)) {
> +			EXT4_ERROR_INODE(inode,
> +			  "immutable or append flags not allowed on symlinks");
> +			ret = -EFSCORRUPTED;
> +			goto bad_inode;
> +		}
>  		if (ext4_encrypted_inode(inode)) {
>  			inode->i_op = &ext4_encrypted_symlink_inode_operations;
>  			ext4_set_aops(inode);
> -- 
> 2.17.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
