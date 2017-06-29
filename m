Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43940 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752369AbdF2ROP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Jun 2017 13:14:15 -0400
Date: Thu, 29 Jun 2017 10:13:26 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v8 17/18] xfs: minimal conversion to errseq_t writeback
 error reporting
Message-ID: <20170629171326.GF5874@birch.djwong.org>
References: <20170629131954.28733-1-jlayton@kernel.org>
 <20170629131954.28733-18-jlayton@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170629131954.28733-18-jlayton@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: jlayton@kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>, tytso@mit.edu, axboe@kernel.dk, mawilcox@microsoft.com, ross.zwisler@linux.intel.com, corbet@lwn.net, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>, Carlos Maiolino <cmaiolino@redhat.com>, Eryu Guan <eguan@redhat.com>, David Howells <dhowells@redhat.com>, Christoph Hellwig <hch@infradead.org>, Liu Bo <bo.li.liu@oracle.com>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org

On Thu, Jun 29, 2017 at 09:19:53AM -0400, jlayton@kernel.org wrote:
> From: Jeff Layton <jlayton@redhat.com>
> 
> Just check and advance the data errseq_t in struct file before
> before returning from fsync on normal files. Internal filemap_*
> callers are left as-is.
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_file.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 5fb5a0958a14..6600b264b0b6 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -140,7 +140,7 @@ xfs_file_fsync(
>  
>  	trace_xfs_file_fsync(ip);
>  
> -	error = filemap_write_and_wait_range(inode->i_mapping, start, end);
> +	error = file_write_and_wait_range(file, start, end);
>  	if (error)
>  		return error;
>  
> -- 
> 2.13.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
