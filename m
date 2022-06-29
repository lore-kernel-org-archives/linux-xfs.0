Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 782ECC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 07:08:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232350AbiF2HIi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 03:08:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232763AbiF2HIg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 03:08:36 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86485E0E3
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 00:08:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=yPWUAf7h4mGXmepPnDFd9Waob/QzXok+3Ss78/snsuM=; b=gGI1uTBBgdbLiCF//C+m20loqS
        PwVk97gtoPSJFNvHJYVJq4oVpv50v5MkqmoPn1sZAP6XKdYeChjWHvwSVJyEsN/AlcD5gDWQgJDKN
        dOhytWe2Ucm5M/7RnZoHy8ORrfaW6ayKFKPipVy6Az6rWhfejxjSzQ6dWxpP6gcNOoiKY37B9N/0u
        N2ygsjesAtkhR8d4iLt0tvNC8xI2v4r7mxgt+hVggzPX3mQMBWfHNxjseSZ8TnX7dkiWobLg2X2fy
        SiISzOPdoVQ0KnVuXAT1yi/9nzSfpzLCsaETd3a932iVuTiKiskbpk5BIndBpC5Gt0GmcrTrzAAhT
        yUQvVCGA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o6RoP-00A0M5-UH; Wed, 29 Jun 2022 07:08:33 +0000
Date:   Wed, 29 Jun 2022 00:08:33 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] xfs: track the iunlink list pointer in the xfs_inode
Message-ID: <Yrv6ce8SlU9gWXtW@infradead.org>
References: <20220627004336.217366-1-david@fromorbit.com>
 <20220627004336.217366-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627004336.217366-3-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 27, 2022 at 10:43:29AM +1000, Dave Chinner wrote:
> @@ -68,6 +68,9 @@ typedef struct xfs_inode {
>  	uint64_t		i_diflags2;	/* XFS_DIFLAG2_... */
>  	struct timespec64	i_crtime;	/* time created */
>  
> +	/* unlinked list pointers */
> +	xfs_agino_t		i_next_unlinked;

The placement here seems unfortunate as it grows the inode vs just
filling holes.  I think placing it before i_ioend_lock might work
better, but a little pahole evaluation might be a good idea.

