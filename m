Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757205AbdLPNtu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 16 Dec 2017 08:49:50 -0500
Message-ID: <1513432186.3428.6.camel@kernel.org>
Subject: Re: [PATCH v2 05/19] afs: convert to new i_version API
From: Jeff Layton <jlayton@kernel.org>
Date: Sat, 16 Dec 2017 08:49:46 -0500
In-Reply-To: <20171216134656.15561-6-jlayton@kernel.org>
References: <20171216134656.15561-1-jlayton@kernel.org>
         <20171216134656.15561-6-jlayton@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-nfs@vger.kernel.org, bfields@fieldses.org, neilb@suse.de, jack@suse.de, linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, david@fromorbit.com, linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-integrity@vger.kernel.org, zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com, linux-afs@lists.infradead.org, dhowells@redhat.com

On Sat, 2017-12-16 at 08:46 -0500, Jeff Layton wrote:
> From: Jeff Layton <jlayton@redhat.com>
> 
> For AFS, it's generally treated as an opaque value, so we use the
> *_raw variants of the API here.
> 
> Note that AFS has quite a different definition for this counter. AFS
> only increments it on changes to the data, not for the metadata. We'll
> need to reconcile that somehow if we ever want to present this to
> userspace via statx.
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> ---
>  fs/afs/fsclient.c | 2 +-
>  fs/afs/inode.c    | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/afs/fsclient.c b/fs/afs/fsclient.c
> index b90ef39ae914..67ed9bb5fe31 100644
> --- a/fs/afs/fsclient.c
> +++ b/fs/afs/fsclient.c
> @@ -124,7 +124,7 @@ static void xdr_decode_AFSFetchStatus(const __be32 **_bp,
>  		vnode->vfs_inode.i_ctime.tv_sec	= status->mtime_client;
>  		vnode->vfs_inode.i_mtime	= vnode->vfs_inode.i_ctime;
>  		vnode->vfs_inode.i_atime	= vnode->vfs_inode.i_ctime;
> -		vnode->vfs_inode.i_version	= data_version;
> +		inode_set_iversion_raw(&vnode->vfs_inode, data_version);
>  	}
>  
>  	expected_version = status->data_version;
> diff --git a/fs/afs/inode.c b/fs/afs/inode.c
> index 3415eb7484f6..af9577210a46 100644
> --- a/fs/afs/inode.c
> +++ b/fs/afs/inode.c
> @@ -89,7 +89,7 @@ static int afs_inode_map_status(struct afs_vnode *vnode, struct key *key)
>  	inode->i_atime		= inode->i_mtime = inode->i_ctime;
>  	inode->i_blocks		= 0;
>  	inode->i_generation	= vnode->fid.unique;
> -	inode->i_version	= vnode->status.data_version;
> +	inode_set_iversion_raw(inode, vnode->status.data_version);
>  	inode->i_mapping->a_ops	= &afs_fs_aops;
>  
>  	read_sequnlock_excl(&vnode->cb_lock);
> @@ -218,7 +218,7 @@ struct inode *afs_iget_autocell(struct inode *dir, const char *dev_name,
>  	inode->i_ctime.tv_nsec	= 0;
>  	inode->i_atime		= inode->i_mtime = inode->i_ctime;
>  	inode->i_blocks		= 0;
> -	inode->i_version	= 0;
> +	inode_set_iversion_raw(inode, 0);
>  	inode->i_generation	= 0;
>  
>  	set_bit(AFS_VNODE_PSEUDODIR, &vnode->flags);

TBH, we could just remove the i_version handling here. Nothing ever
looks at the i_version field in AFS inodes.
-- 
Jeff Layton <jlayton@kernel.org>
