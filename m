Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D474E92705
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Oct 2023 14:34:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbjJEOev (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Oct 2023 10:34:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234149AbjJEOc2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Oct 2023 10:32:28 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4171E21D0C
        for <linux-xfs@vger.kernel.org>; Thu,  5 Oct 2023 02:45:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=pw4g6SCq7rkNaSCMSwQpqWoYb2D0JwrR76BWla5uhoA=; b=kJJ5oDjkHidZUzf3sMPMU8Ollm
        XctSPjYUlxzrr6wfxc3t5v30hiOiX8J/9FufgsiAdJXtxEZmR2LirhzZN+sW6VlC1wkmyIrrCV0qo
        pcMXna78ZhpxZHTvSKFBe3jHejxoHQXTYO491ilwu7KXoZqtpwPfH0loSzo1vTeM5HWYig03RRyhl
        5h0W03tRxmPE8aH9uc0JRYzCb3wp8f142mM8wzRskGLeMPx6RoUE8WqA2eUBhVPf1WokpNeHahF/z
        K6qYHINt1W9pLniLiP8Edva7dWIjWAX95p2kNjiIBqSUOB5USlSZm/QPYtg767cz/Qk4ZF3ohKhCD
        6kM17v9A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qoKv1-001n0p-02;
        Thu, 05 Oct 2023 09:45:19 +0000
Date:   Thu, 5 Oct 2023 02:45:18 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, john.g.garry@oracle.com
Subject: Re: [PATCH 3/9] xfs: select the AG with the largest contiguous space
Message-ID: <ZR6FrrizBjfRn9Yv@infradead.org>
References: <20231004001943.349265-1-david@fromorbit.com>
 <20231004001943.349265-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231004001943.349265-4-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +	if (max_blen > *blen) {
> +		if (max_blen_agno != startag) {
> +			ap->blkno = XFS_AGB_TO_FSB(mp, max_blen_agno, 0);
> +			ap->aeof = false;
> +		}
> +		*blen = max_blen;
> +	}

A comment based on the commit message on why we do this would be nice
here.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

