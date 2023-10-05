Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2B1CE92716
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Oct 2023 16:13:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235616AbjJEQN3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Oct 2023 12:13:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240941AbjJEQMS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Oct 2023 12:12:18 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69F082573A
        for <linux-xfs@vger.kernel.org>; Thu,  5 Oct 2023 04:59:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=pSPr3pXcSxKJuX7/RPo0otlLSAy10+fB0mEx0Y++h64=; b=dYToxfBATWzM6CvzkKxzTS/3Nf
        2UD0D1P2St720vvzIKoMmHWwQ9QcdPh/1/VOwfUhRonO4jl8SSjY+F547bwe+ZYh3LDhAMJAlHa5Z
        0Pm0WFTpG0cQabvsk3wluMMcnW8lKK9NnqIL566HKQxSXOryLQpAfSPSqCh5RF6z1sz7Wu39VOVuE
        3pGtk1Npdy1muEpeDJ2EeRk9EfO2aLPcnGbSfwn2VkAx2nWuoU8O3XzcY0LZ0VETF3evKyhUZQmiX
        j+z62p2SbimP20ilOUnRrfitUzmYf3qi4sb33p3UGPqBl2KLTiN7NgRGinQ3WPmQF10J/vw44rqfH
        fZBb6b4A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qoN1G-002XLs-02;
        Thu, 05 Oct 2023 11:59:54 +0000
Date:   Thu, 5 Oct 2023 04:59:53 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, john.g.garry@oracle.com
Subject: Re: [PATCH 5/9] xfs: aligned EOF allocations don't need to scan AGs
 anymore
Message-ID: <ZR6lOVXZ5j0LW1CM@infradead.org>
References: <20231004001943.349265-1-david@fromorbit.com>
 <20231004001943.349265-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231004001943.349265-6-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> -	if (ap->aeof && ap->offset) {
> +	if (ap->aeof && ap->offset)
>  		error = xfs_bmap_btalloc_at_eof(ap, args, blen, stripe_align);
> -	}
> +
> +	if (error || args->fsbno != NULLFSBLOCK)
> +		goto out_perag_rele;

Maybe just personal preference, but I find it much easier to read
if the error handling is indented and sits in a block with the
condition that can cause it, i.e.

	if (ap->aeof && ap->offset) {
 		error = xfs_bmap_btalloc_at_eof(ap, args, blen, stripe_align);
		if (error || args->fsbno != NULLFSBLOCK)
			goto out_perag_rele;
	}

but except for that nipicks this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
