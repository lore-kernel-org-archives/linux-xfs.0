Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:59134 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388297AbfEWWcC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 May 2019 18:32:02 -0400
Date: Fri, 24 May 2019 08:31:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 02/20] xfs: remove the never used _XBF_COMPOUND flag
Message-ID: <20190523223158.GO29573@dread.disaster.area>
References: <20190523173742.15551-1-hch@lst.de>
 <20190523173742.15551-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190523173742.15551-3-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, May 23, 2019 at 07:37:24PM +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_buf.h | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index d0b96e071cec..4f2c2bc43003 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -49,7 +49,6 @@ typedef enum {
>  #define _XBF_PAGES	 (1 << 20)/* backed by refcounted pages */
>  #define _XBF_KMEM	 (1 << 21)/* backed by heap memory */
>  #define _XBF_DELWRI_Q	 (1 << 22)/* buffer on a delwri queue */
> -#define _XBF_COMPOUND	 (1 << 23)/* compound buffer */
>  
>  typedef unsigned int xfs_buf_flags_t;
>  
> @@ -69,8 +68,7 @@ typedef unsigned int xfs_buf_flags_t;
>  	{ XBF_UNMAPPED,		"UNMAPPED" },	/* ditto */\
>  	{ _XBF_PAGES,		"PAGES" }, \
>  	{ _XBF_KMEM,		"KMEM" }, \
> -	{ _XBF_DELWRI_Q,	"DELWRI_Q" }, \
> -	{ _XBF_COMPOUND,	"COMPOUND" }
> +	{ _XBF_DELWRI_Q,	"DELWRI_Q" }

Guess I forgot to remove that long ago....

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
