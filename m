Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:57614 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933811AbeAKThK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Jan 2018 14:37:10 -0500
Date: Thu, 11 Jan 2018 11:30:32 -0800
From: Liu Bo <bo.li.liu@oracle.com>
Subject: Re: [PATCH v5 18/19] btrfs: only dirty the inode in
 btrfs_update_time if something was changed
Message-ID: <20180111193031.GA12421@dhcp-10-159-141-29.vpn.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <20180109141059.25929-1-jlayton@kernel.org>
 <20180109141059.25929-19-jlayton@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180109141059.25929-19-jlayton@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-nfs@vger.kernel.org, bfields@fieldses.org, neilb@suse.de, jack@suse.de, linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, david@fromorbit.com, linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-integrity@vger.kernel.org, zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com, linux-afs@lists.infradead.org, dhowells@redhat.com, jaltman@auristor.com, krzk@kernel.org

Hi Jeff,

On Tue, Jan 09, 2018 at 09:10:58AM -0500, Jeff Layton wrote:
> From: Jeff Layton <jlayton@redhat.com>
> 
> At this point, we know that "now" and the file times may differ, and we
> suspect that the i_version has been flagged to be bumped. Attempt to
> bump the i_version, and only mark the inode dirty if that actually
> occurred or if one of the times was updated.
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> Acked-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/inode.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index ac8692849a81..76245323a7c8 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -6107,19 +6107,20 @@ static int btrfs_update_time(struct inode *inode, struct timespec *now,
>  			     int flags)
>  {
>  	struct btrfs_root *root = BTRFS_I(inode)->root;
> +	bool dirty = flags & ~S_VERSION;
>  
>  	if (btrfs_root_readonly(root))
>  		return -EROFS;
>  
>  	if (flags & S_VERSION)
> -		inode_inc_iversion(inode);
> +		dirty |= inode_maybe_inc_iversion(inode, dirty);
>  	if (flags & S_CTIME)
>  		inode->i_ctime = *now;
>  	if (flags & S_MTIME)
>  		inode->i_mtime = *now;
>  	if (flags & S_ATIME)
>  		inode->i_atime = *now;
> -	return btrfs_dirty_inode(inode);
> +	return dirty ? btrfs_dirty_inode(inode) : 0;
>  }
>  

In order to have a easier error handling for ENOSPC, btrfs has split
file_update_time() into 2-step work,
- step 1 is to update time/iversion of in-memory inode in
  update_time_for_write(),
- step 2 is to update the time/iversion of on-disk inode in
  btrfs_update_inode()->fill_inode_item().

I think update_time_for_write() also needs to be updated to use the
new iversion API.

With that,

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
>  /*
> -- 
> 2.14.3
> 
