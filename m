Return-Path: <SRS0=A2Vo=7C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 519DBC433E1
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 17:36:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2794820709
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 17:36:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GE9Pq2Bl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbgETRg1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 May 2020 13:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726891AbgETRg0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 May 2020 13:36:26 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF19EC061A0E
        for <linux-xfs@vger.kernel.org>; Wed, 20 May 2020 10:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Xm9AFA9DMn7bYb4TPzmtxArPab+GWDhOW9QAIm5VtHU=; b=GE9Pq2Blh63uBvKFYou/YgEACQ
        Va1y/zDa5e3hPpST6yLQJnLmg41LVuuJtUfaN7iGdWo1ffWbPOEdLt7UIt3J69tizOJ2P9dciVHsx
        hC1kTtdiF3XXBWmhWxJ1aaGKDIZCQt1V/zaWLV6cvwzrOQaOM5ApVNIRoSjTATNmFshBwV0MMFq9q
        iUsR2mkSqi08aYTlL+AANOUmQ7yRHpWjsKnmkzi6PCrMngNUGYsdSIUXIgVpR5SBFTXRv1QpIdONn
        TVLiLsZm4EKgWJnP2CZ62JE8Kv1L1tH/RZwuTCrsOFA6tNhROHDBegmrK6JMf3qwhCAxRNrB9dgwk
        tmnDRrBQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbSdk-0003S8-0q; Wed, 20 May 2020 17:36:24 +0000
Date:   Wed, 20 May 2020 10:36:23 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs_db: don't crash if el_gets returns null
Message-ID: <20200520173623.GA1713@infradead.org>
References: <158984953155.623441.15225705949586714685.stgit@magnolia>
 <158984953767.623441.453227281468842512.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158984953767.623441.453227281468842512.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 18, 2020 at 05:52:17PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> el_gets returns NULL if it fails to read any characters (due to EOF or
> errors occurred).  strdup will crash if it is fed a NULL string, so
> check the return value to avoid segfaulting.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

And I'm pretty sure I've reviewed this before..
