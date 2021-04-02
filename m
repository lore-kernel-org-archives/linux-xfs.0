Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E9E5C433ED
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 06:43:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D11F6610E7
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 06:43:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbhDBGnS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Apr 2021 02:43:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbhDBGnS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Apr 2021 02:43:18 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9394C0613E6
        for <linux-xfs@vger.kernel.org>; Thu,  1 Apr 2021 23:43:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Gu0K69iHQ5ZqM+u0U8HXBEaSG9uCJh50Qzi77tJxCIk=; b=g4In+zy8UA+GcoOi2URCCl9AQE
        yWjA57Shtl49qFXjBuEQNfqUWlbeDtD6aOCPaV+a7erNPb5sd7qtCtGJ0DdGEIGecwvi9SpOBUMRJ
        Cy6j5gh7vURmglkp64XLR6dot7UGLIz8+Md3TvXFXkIBUN2OcWIo3r9W8W7egBYiGPFQP51XtiQv2
        uv30jXlAHoBaYt8dyF2L3W9IbL68V91m6z2xrRAq97CjdcCZh+E1a6ex0FwjWdxZ67DUIMXbsTCyr
        W2kUKFZQkpKia7wVL1hRA9QhxmoG6Y/FeeNHD6CjQ9HqMcxzsIkXTSqvz/QuW+WipATQH9WYscaAq
        QhIVGtHQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lSDWS-007IVT-4q; Fri, 02 Apr 2021 06:43:14 +0000
Date:   Fri, 2 Apr 2021 07:43:12 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: Use struct xfs_bmdr_block instead of struct
 xfs_btree_block to calculate root node size
Message-ID: <20210402064312.GA1739272@infradead.org>
References: <20210401164525.8638-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210401164525.8638-1-chandanrlinux@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 01, 2021 at 10:15:25PM +0530, Chandan Babu R wrote:
> @@ -927,13 +927,16 @@ xfs_bmap_add_attrfork_btree(
>  	xfs_inode_t		*ip,		/* incore inode pointer */
>  	int			*flags)		/* inode logging flags */
>  {
> +	struct xfs_btree_block	*block;
>  	xfs_btree_cur_t		*cur;		/* btree cursor */
>  	int			error;		/* error return value */
>  	xfs_mount_t		*mp;		/* file system mount struct */
>  	int			stat;		/* newroot status */
>  
>  	mp = ip->i_mount;
> -	if (ip->i_df.if_broot_bytes <= XFS_IFORK_DSIZE(ip))
> +	block = ip->i_df.if_broot;

Just initializing block o nthe line it is declared would read a little
easier.  Other than that this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

