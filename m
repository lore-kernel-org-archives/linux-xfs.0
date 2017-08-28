Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37397 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751198AbdH1Qdb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Aug 2017 12:33:31 -0400
Date: Mon, 28 Aug 2017 09:33:20 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/2] iomap: return VM_FAULT_* codes from
 iomap_page_mkwrite
Message-ID: <20170828163320.GB4757@magnolia>
References: <20170828063659.21045-1-hch@lst.de>
 <20170828063659.21045-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170828063659.21045-2-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, jack@suse.cz

On Mon, Aug 28, 2017 at 08:36:58AM +0200, Christoph Hellwig wrote:
> All callers will need the VM_FAULT_* flags, so convert in the helper.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/iomap.c        | 4 ++--
>  fs/xfs/xfs_file.c | 1 -
>  2 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/iomap.c b/fs/iomap.c
> index 59cc98ad7577..8554a8d75281 100644
> --- a/fs/iomap.c
> +++ b/fs/iomap.c
> @@ -477,10 +477,10 @@ int iomap_page_mkwrite(struct vm_fault *vmf, const struct iomap_ops *ops)
>  
>  	set_page_dirty(page);
>  	wait_for_stable_page(page);
> -	return 0;
> +	return VM_FAULT_LOCKED;
>  out_unlock:
>  	unlock_page(page);
> -	return ret;
> +	return block_page_mkwrite_return(ret);
>  }
>  EXPORT_SYMBOL_GPL(iomap_page_mkwrite);
>  
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index c4893e226fd8..8b0181c6d2a6 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1035,7 +1035,6 @@ xfs_filemap_page_mkwrite(
>  		ret = dax_iomap_fault(vmf, PE_SIZE_PTE, &xfs_iomap_ops);
>  	} else {
>  		ret = iomap_page_mkwrite(vmf, &xfs_iomap_ops);
> -		ret = block_page_mkwrite_return(ret);
>  	}
>  
>  	xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
