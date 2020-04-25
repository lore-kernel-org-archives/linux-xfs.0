Return-Path: <SRS0=0X6r=6J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4EC3C54FCB
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Apr 2020 17:26:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D3162071E
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Apr 2020 17:26:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="I96/IAFJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbgDYR0i (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Apr 2020 13:26:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726145AbgDYR0h (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Apr 2020 13:26:37 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8959C09B04D
        for <linux-xfs@vger.kernel.org>; Sat, 25 Apr 2020 10:26:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=vDHD1q6t76SH1wtRrIMc6kmInlVBYNA/yQzh45oPLXY=; b=I96/IAFJuHB7D+fGhAQSlhSfP0
        VJF8ez69HlhfiDMbnSrfaZOTnDkPmhTp4+rk55HPhCDoTq5X0/tZ+/O4ETk8x086DTx80yOHgxYr9
        G6FTCsueGCzlDmxj0awnr5KNcqJF+loOVRktPnjdx8nvVKwMhdUW8RvmNVCE3q9mhHadzj+LyzdV5
        YQHaEKhPHjx9uTsBADYOfbspgeTsdugbsKR8Pvf3ojI2Si6gifRbD/eAWNAuCR/B2oFT1siIzfZ8S
        qYyTn/xYS7BDCegeKmMOfN7ai0csn0kcJbPBBPGUGUDtoqGEnMCtuPQnXhSQDuvEu0xAcSiuI7J8p
        HMO50C5g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jSOZZ-0005X2-29; Sat, 25 Apr 2020 17:26:37 +0000
Date:   Sat, 25 Apr 2020 10:26:37 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 03/13] xfs: fallthru to buffer attach on error and
 simplify error handling
Message-ID: <20200425172637.GC30534@infradead.org>
References: <20200422175429.38957-1-bfoster@redhat.com>
 <20200422175429.38957-4-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422175429.38957-4-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

I agree with Dave that the subject sounds rather odd.  The actual change
looks good to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
