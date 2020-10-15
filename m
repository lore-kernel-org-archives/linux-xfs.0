Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1B8BC433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 08:26:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 834972225F
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 08:26:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jBu/bNpE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727494AbgJOI0c (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 04:26:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725959AbgJOI0c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 04:26:32 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6433BC061755
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 01:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=jBu/bNpEBoacPsfQJElI7nMQfQ
        UoEt+qF69DJ+qnSJAKQUVEd49pKX9WKz5EqZJDIVA0XIw7p8Hm5V5NKUYyG/Q+F7FYdpjz4+AVhVz
        KleipxEmeD7kY0Q9g9azCJd6fTe4e9kH1CEbJ3srT8s0ub2gcAJjMR7ZO1WtZ+XKjqYBmV7EKyamG
        qfRZ+hZDbjubIsRIVMSz228AkbuGP8z6WaaRJ0cCEpuFWBWpDYI0XBe7ppdYm533oBCTrWa8dQiLa
        BtwhxHTsdSfOh/JDG93J5LlkNrUFsu9UBw/zxEU75xKAXAr7lSBCr89puE1rgUW5o9YADWOHpf9qD
        bOW4YbEA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kSyai-0001De-AG; Thu, 15 Oct 2020 08:26:28 +0000
Date:   Thu, 15 Oct 2020 09:26:28 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] libfrog: fix a potential null pointer dereference
Message-ID: <20201015082628.GB4450@infradead.org>
References: <20201008035732.GA6535@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201008035732.GA6535@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
