Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11D94C4363A
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 15:04:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A03A620838
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 15:04:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YYaMXgNo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727933AbgJ2PES (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Oct 2020 11:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727865AbgJ2PES (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 11:04:18 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D52F6C0613D2;
        Thu, 29 Oct 2020 08:04:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=YYaMXgNoEN7XqnFXpLFDPHc1Xt
        eJf9c6TO3UBvtt3qh6Zojzhuh6n0aVYUCjP8493O8KIE5UfFlr2ggam7kDV9xnMRTaXKWB7qavRKL
        cNtqVshnVANfKUCJuTcKI6o2QyKnNlFtjU9DeDCcPwMFyFwm8PQPfgSODWqSEPFZHRDpJ5plqaj3j
        TB4o8RUCknrPFKRfvuJ/Ux6Ms6hVDLzEggkPMDb1CbxhZWcALYE7hxHKO80zYI59eB8vl4blnN1dd
        c4GeI17UFwef7h+TIpnjs1qNKEOdtDC2hUeK2jVVCiOZz+vz/dh2O7mbIdnP34YaJZQ+Kvp190ZZ4
        ic0++f6w==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kY9TL-0005cg-7I; Thu, 29 Oct 2020 15:04:15 +0000
Date:   Thu, 29 Oct 2020 15:04:15 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 1/3] xfs: flush new eof page on truncate to avoid
 post-eof corruption
Message-ID: <20201029150415.GA21018@infradead.org>
References: <20201029132325.1663790-1-bfoster@redhat.com>
 <20201029132325.1663790-2-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201029132325.1663790-2-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
