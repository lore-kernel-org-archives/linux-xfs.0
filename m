Return-Path: <SRS0=xOwi=4F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F34AC34022
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 21:51:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E084B20836
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 21:51:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729141AbgBQVv3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Feb 2020 16:51:29 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:51820 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729047AbgBQVv3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Feb 2020 16:51:29 -0500
Received: from dread.disaster.area (pa49-179-138-28.pa.nsw.optusnet.com.au [49.179.138.28])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id ADFDD3A16C9;
        Tue, 18 Feb 2020 08:51:24 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j3oIW-0003Fh-47; Tue, 18 Feb 2020 08:51:24 +1100
Date:   Tue, 18 Feb 2020 08:51:24 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 02/31] xfs: remove the ATTR_INCOMPLETE flag
Message-ID: <20200217215124.GG10776@dread.disaster.area>
References: <20200217125957.263434-1-hch@lst.de>
 <20200217125957.263434-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200217125957.263434-3-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=zAxSp4fFY/GQY8/esVNjqw==:117 a=zAxSp4fFY/GQY8/esVNjqw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=6Um8Ty4ZZWow14UeOhUA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 17, 2020 at 01:59:28PM +0100, Christoph Hellwig wrote:
> Replace the ATTR_INCOMPLETE flag with a new boolean field in struct
> xfs_attr_list_context.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

looks fine. Minor nit below, otherwise

Reviewed-by: Dave Chinner <dchinner@redhat.com>

> ---
>  fs/xfs/libxfs/xfs_attr.h | 5 ++---
>  fs/xfs/scrub/attr.c      | 2 +-
>  fs/xfs/xfs_attr_list.c   | 6 +-----
>  3 files changed, 4 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 4243b2272642..71bcf1298e4c 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -36,11 +36,10 @@ struct xfs_attr_list_context;
>  #define ATTR_KERNOTIME	0x1000	/* [kernel] don't update inode timestamps */
>  #define ATTR_KERNOVAL	0x2000	/* [kernel] get attr size only, not value */
>  
> -#define ATTR_INCOMPLETE	0x4000	/* [kernel] return INCOMPLETE attr keys */
>  #define ATTR_ALLOC	0x8000	/* [kernel] allocate xattr buffer on demand */
>  
>  #define ATTR_KERNEL_FLAGS \
> -	(ATTR_KERNOTIME | ATTR_KERNOVAL | ATTR_INCOMPLETE | ATTR_ALLOC)
> +	(ATTR_KERNOTIME | ATTR_KERNOVAL | ATTR_ALLOC)
>  
>  #define XFS_ATTR_FLAGS \
>  	{ ATTR_DONTFOLLOW, 	"DONTFOLLOW" }, \
> @@ -51,7 +50,6 @@ struct xfs_attr_list_context;
>  	{ ATTR_REPLACE,		"REPLACE" }, \
>  	{ ATTR_KERNOTIME,	"KERNOTIME" }, \
>  	{ ATTR_KERNOVAL,	"KERNOVAL" }, \
> -	{ ATTR_INCOMPLETE,	"INCOMPLETE" }, \
>  	{ ATTR_ALLOC,		"ALLOC" }
>  
>  /*
> @@ -123,6 +121,7 @@ typedef struct xfs_attr_list_context {
>  	 * error values to the xfs_attr_list caller.
>  	 */
>  	int				seen_enough;
> +	bool				allow_incomplete;
>  
>  	ssize_t				count;		/* num used entries */
>  	int				dupcnt;		/* count dup hashvals seen */
> diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
> index d9f0dd444b80..d804558cdbca 100644
> --- a/fs/xfs/scrub/attr.c
> +++ b/fs/xfs/scrub/attr.c
> @@ -497,7 +497,7 @@ xchk_xattr(
>  	sx.context.resynch = 1;
>  	sx.context.put_listent = xchk_xattr_listent;
>  	sx.context.tp = sc->tp;
> -	sx.context.flags = ATTR_INCOMPLETE;
> +	sx.context.allow_incomplete = true;
>  	sx.sc = sc;
>  
>  	/*
> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> index d37743bdf274..5139ef983cd6 100644
> --- a/fs/xfs/xfs_attr_list.c
> +++ b/fs/xfs/xfs_attr_list.c
> @@ -452,7 +452,7 @@ xfs_attr3_leaf_list_int(
>  		}
>  
>  		if ((entry->flags & XFS_ATTR_INCOMPLETE) &&
> -		    !(context->flags & ATTR_INCOMPLETE))
> +		    !context->allow_incomplete)
>  			continue;		/* skip incomplete entries */

While touching this code, can you fix the trailing comment here to
be a normal one before the if() statement, or remove it because it's
largely redundant?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
