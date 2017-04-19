Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:42126 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S939122AbdDSUAC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 19 Apr 2017 16:00:02 -0400
Subject: Re: [PATCH 2/3] xfs: remove unused values from xfs_exntst_t
References: <20170419192904.22203-1-hch@lst.de>
 <20170419192904.22203-3-hch@lst.de>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <e694b28c-428b-f86f-6c5e-cb5bd3cc61f2@sandeen.net>
Date: Wed, 19 Apr 2017 14:59:51 -0500
MIME-Version: 1.0
In-Reply-To: <20170419192904.22203-3-hch@lst.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On 4/19/17 2:29 PM, Christoph Hellwig wrote:
> We only ever use the normal and unwritten states.  And the actual
> ondisk format (this enum isn't despite being in xfs_format.h) only
> has space for the unwritten bit anyway.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/xfs/libxfs/xfs_format.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index d114ed80a076..8425884668a8 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -1588,7 +1588,6 @@ typedef enum {
>   */
>  typedef enum {
>  	XFS_EXT_NORM, XFS_EXT_UNWRITTEN,
> -	XFS_EXT_DMAPI_OFFLINE, XFS_EXT_INVALID
>  } xfs_exntst_t;
>  
>  /*
> 
