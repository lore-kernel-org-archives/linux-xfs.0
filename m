Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:50204 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751248AbeDRAhb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 20:37:31 -0400
Date: Tue, 17 Apr 2018 17:37:12 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: trace ATTR flags in xattr tracepoints
Message-ID: <20180418003712.GJ24738@magnolia>
References: <67a92fac-3e86-03c1-759e-af192d35e06b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67a92fac-3e86-03c1-759e-af192d35e06b@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Apr 17, 2018 at 03:03:32PM -0500, Eric Sandeen wrote:
> This will trace i.e. the ATTR_SECURE/ATTR_CREATE/ATTR_REPLACE
> flags as well as the OP_FLAGS.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok, will pick up for 4.18.
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 8955254..b03a0f4 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -1750,6 +1750,7 @@
>  		__field(int, namelen)
>  		__field(int, valuelen)
>  		__field(xfs_dahash_t, hashval)
> +		__field(int, flags)
>  		__field(int, op_flags)
>  	),
>  	TP_fast_assign(
> @@ -1760,10 +1761,11 @@
>  		__entry->namelen = args->namelen;
>  		__entry->valuelen = args->valuelen;
>  		__entry->hashval = args->hashval;
> +		__entry->flags = args->flags;
>  		__entry->op_flags = args->op_flags;
>  	),
>  	TP_printk("dev %d:%d ino 0x%llx name %.*s namelen %d valuelen %d "
> -		  "hashval 0x%x op_flags %s",
> +		  "hashval 0x%x flags %s op_flags %s",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->ino,
>  		  __entry->namelen,
> @@ -1771,6 +1773,7 @@
>  		  __entry->namelen,
>  		  __entry->valuelen,
>  		  __entry->hashval,
> +		  __print_flags(__entry->flags, "|", XFS_ATTR_FLAGS),
>  		  __print_flags(__entry->op_flags, "|", XFS_DA_OP_FLAGS))
>  )
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
