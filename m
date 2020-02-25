Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98942C4BA04
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 23:55:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C2262075D
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 23:55:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728865AbgBYXz5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 18:55:57 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:54058 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727880AbgBYXz4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 18:55:56 -0500
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id B61063A2667;
        Wed, 26 Feb 2020 10:55:54 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j6k3N-0004ve-Gq; Wed, 26 Feb 2020 10:55:53 +1100
Date:   Wed, 26 Feb 2020 10:55:53 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 09/30] xfs: turn xfs_da_args.value into a void pointer
Message-ID: <20200225235553.GR10776@dread.disaster.area>
References: <20200225231012.735245-1-hch@lst.de>
 <20200225231012.735245-10-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200225231012.735245-10-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=2DlvNspEA4UdbF-36qYA:9
        a=ymFyuTk9eOLyOXF9:21 a=KW57PRokO6uurKGy:21 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 25, 2020 at 03:09:51PM -0800, Christoph Hellwig wrote:
> The xattr values are blobs and should not be typed.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_da_btree.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
> index 0f4fbb0889ff..0967d1bd3ceb 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.h
> +++ b/fs/xfs/libxfs/xfs_da_btree.h
> @@ -57,7 +57,7 @@ typedef struct xfs_da_args {
>  	const uint8_t		*name;		/* string (maybe not NULL terminated) */
>  	int		namelen;	/* length of string (maybe no NULL) */
>  	uint8_t		filetype;	/* filetype of inode for directories */
> -	uint8_t		*value;		/* set of bytes (maybe contain NULLs) */
> +	void		*value;		/* set of bytes (maybe contain NULLs) */
>  	int		valuelen;	/* length of value */
>  	int		flags;		/* argument flags (eg: ATTR_NOCREATE) */
>  	xfs_dahash_t	hashval;	/* hash value of name */

*nod*

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
