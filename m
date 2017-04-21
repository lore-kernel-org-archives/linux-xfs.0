Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28667 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1424386AbdDUTFl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Apr 2017 15:05:41 -0400
Date: Fri, 21 Apr 2017 12:05:36 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/6] xfs: corruption needs to respect endianess too!
Message-ID: <20170421190536.GH23371@birch.djwong.org>
References: <20170421152123.11316-1-hch@lst.de>
 <20170421152123.11316-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170421152123.11316-4-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Fri, Apr 21, 2017 at 05:21:20PM +0200, Christoph Hellwig wrote:
> At least if we want to be able to recognize the pattern.  Add a missing
> byte swap to the corruption injection case in xlog_sync.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_log.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index bb58cd1873c9..3731f13f63e9 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1852,7 +1852,7 @@ xlog_sync(
>  	 */
>  	if (log->l_badcrc_factor &&
>  	    (prandom_u32() % log->l_badcrc_factor == 0)) {
> -		iclog->ic_header.h_crc &= 0xAAAAAAAA;
> +		iclog->ic_header.h_crc &= cpu_to_le32(0xAAAAAAAA);
>  		iclog->ic_state |= XLOG_STATE_IOABORT;
>  		xfs_warn(log->l_mp,
>  	"Intentionally corrupted log record at LSN 0x%llx. Shutdown imminent.",
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
