Return-Path: <SRS0=4QIy=6W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1505C38A2A
	for <linux-xfs@archiver.kernel.org>; Fri,  8 May 2020 12:08:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B230120725
	for <linux-xfs@archiver.kernel.org>; Fri,  8 May 2020 12:08:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Gf16PjYj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbgEHMIE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 May 2020 08:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726616AbgEHMID (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 May 2020 08:08:03 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81459C05BD0A
        for <linux-xfs@vger.kernel.org>; Fri,  8 May 2020 05:08:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=sfz+/XzFNEJX/VQR+SV6ru/JVWSHqFRnNIZuzmVQhyM=; b=Gf16PjYjQ+7LE26BpDq3yniJaZ
        L3K6/v0ZRFMsFAMnN1ZwhijYpHJ2WYwxknYu4o5x9SKJubJ9tFvrdwKG8raa4awkPGPHQBHVPd25R
        abbjzfwj23PDspP+c1p7IADjhucEDtMsWoXHWM9bcRREezn+mi0cl1RWfJbsbwhjeOmsQC59R9q8A
        rgdSvr6kap8h2K/gNv9KFDDJNieD8s+ANIami2SBx4V4Bty5FrgB+Tm2A6Mk2DGQs0vfJuLB8veJh
        +yvodL5fMgspIvJI5Kwzlt27ep51+L6ev5yavF7OAwHKT4o9wRsCxMjiF2LlhFfidY20px8bcbarc
        5FPyvvuA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jX1nP-0001Ba-Ab; Fri, 08 May 2020 12:08:03 +0000
Date:   Fri, 8 May 2020 05:08:03 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: fix unused variable warning in buffer completion on
 !DEBUG
Message-ID: <20200508120803.GA4309@infradead.org>
References: <20200508111518.27b22640@canb.auug.org.au>
 <20200508105559.27037-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200508105559.27037-1-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 08, 2020 at 06:55:59AM -0400, Brian Foster wrote:
> The random buffer write failure errortag patch introduced a local
> mount pointer variable for the test macro, but the macro is compiled
> out on !DEBUG kernels. This results in an unused variable warning.
> 
> Access the mount structure through the buffer pointer and remove the
> local mount pointer to address the warning.
> 
> Fixes: 7376d745473 ("xfs: random buffer write failure errortag")
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
