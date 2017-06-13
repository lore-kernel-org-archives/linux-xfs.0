Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:16639 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751871AbdFMEb3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Jun 2017 00:31:29 -0400
Date: Mon, 12 Jun 2017 21:30:56 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v6 19/20] xfs: minimal conversion to errseq_t writeback
 error reporting
Message-ID: <20170613043056.GO4530@birch.djwong.org>
References: <20170612122316.13244-1-jlayton@redhat.com>
 <20170612122316.13244-24-jlayton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170612122316.13244-24-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>, tytso@mit.edu, axboe@kernel.dk, mawilcox@microsoft.com, ross.zwisler@linux.intel.com, corbet@lwn.net, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org

On Mon, Jun 12, 2017 at 08:23:15AM -0400, Jeff Layton wrote:
> Just set the FS_WB_ERRSEQ flag to indicate that we want to use errseq_t
> based error reporting. Internal filemap_* calls are left as-is for now.
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> ---
>  fs/xfs/xfs_super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 455a575f101d..28d3be187025 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1758,7 +1758,7 @@ static struct file_system_type xfs_fs_type = {
>  	.name			= "xfs",
>  	.mount			= xfs_fs_mount,
>  	.kill_sb		= kill_block_super,
> -	.fs_flags		= FS_REQUIRES_DEV,
> +	.fs_flags		= FS_REQUIRES_DEV | FS_WB_ERRSEQ,

Huh?  Why are there two patches with the same subject line?  And this
same bit of code too?  Or ... 11/13, 11/20?  What's going on here?

<confused>

--D

>  };
>  MODULE_ALIAS_FS("xfs");
>  
> -- 
> 2.13.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
