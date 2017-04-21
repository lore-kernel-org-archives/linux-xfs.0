Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39505 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1425181AbdDUTd1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Apr 2017 15:33:27 -0400
Date: Fri, 21 Apr 2017 12:33:21 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 5/6] xfs: don't use bool values in trace buffers
Message-ID: <20170421193321.GJ23371@birch.djwong.org>
References: <20170421152123.11316-1-hch@lst.de>
 <20170421152123.11316-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170421152123.11316-6-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Fri, Apr 21, 2017 at 05:21:22PM +0200, Christoph Hellwig wrote:
> Using bool values produces sparse warnings of this form:
> 
> fs/xfs/./xfs_trace.h:2252:1: warning: odd constant _Bool cast (ffffffffffffffff becomes 1)
> fs/xfs/./xfs_trace.h:2252:1: warning: odd constant _Bool cast (ffffffffffffffff becomes 1)
> fs/xfs/./xfs_trace.h:2278:1: warning: odd constant _Bool cast (ffffffffffffffff becomes 1)
> fs/xfs/./xfs_trace.h:2278:1: warning: odd constant _Bool cast (ffffffffffffffff becomes 1)
> fs/xfs/./xfs_trace.h:2307:1: warning: odd constant _Bool cast (ffffffffffffffff becomes 1)
> 
> Just use a char instead to fix those up.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

/me wonders what version of sparse produces this?

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_trace.h | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 4f96dc953fbe..250d08b7cfba 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -2255,8 +2255,8 @@ DECLARE_EVENT_CLASS(xfs_defer_class,
>  	TP_STRUCT__entry(
>  		__field(dev_t, dev)
>  		__field(void *, dop)
> -		__field(bool, committed)
> -		__field(bool, low)
> +		__field(char, committed)
> +		__field(char, low)
>  	),
>  	TP_fast_assign(
>  		__entry->dev = mp ? mp->m_super->s_dev : 0;
> @@ -2281,8 +2281,8 @@ DECLARE_EVENT_CLASS(xfs_defer_error_class,
>  	TP_STRUCT__entry(
>  		__field(dev_t, dev)
>  		__field(void *, dop)
> -		__field(bool, committed)
> -		__field(bool, low)
> +		__field(char, committed)
> +		__field(char, low)
>  		__field(int, error)
>  	),
>  	TP_fast_assign(
> @@ -2311,7 +2311,7 @@ DECLARE_EVENT_CLASS(xfs_defer_pending_class,
>  		__field(dev_t, dev)
>  		__field(int, type)
>  		__field(void *, intent)
> -		__field(bool, committed)
> +		__field(char, committed)
>  		__field(int, nr)
>  	),
>  	TP_fast_assign(
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
