Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 521E9C2D0A3
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 09:44:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E51472076E
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 09:44:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="svdFVVS0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726212AbgJ2Job (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Oct 2020 05:44:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbgJ2Job (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 05:44:31 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C1E0C0613CF
        for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2020 02:44:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=svdFVVS0o3xu+9tGnvy4AX3U15
        rULuAYj947aBVdpvft7qARyTtlOF24CJRVJnAhjLpoyjRqA+YoqouJXeifrbKwYuynkrOjj8Axhdq
        Y9Lq0gckaHGTFqUlr1k0mn3HFXpOwTVroFFia4ES97V/djssJPRroXS5ceC7TG8aJltFq8M7dNdVb
        DSq+5hN7Jrw8uOQm9iOlrnSHlv07UBp1++021SMLvpIA9+TfUEZZKEMnG+8PIQTCPGJFNJp2KAWZ4
        fl7GBtPiiaYx6tisIythjeKF0yO8hS1D9LT55TVhIzS2vB5TjTWR6bsmn+P2FfOuZ7UhOHYEqnAV6
        qojebfhg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kY4Tr-0001Hk-9q; Thu, 29 Oct 2020 09:44:27 +0000
Date:   Thu, 29 Oct 2020 09:44:27 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, Amir Goldstein <amir73il@gmail.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/26] libxfs: refactor NSEC_PER_SEC
Message-ID: <20201029094427.GE2091@infradead.org>
References: <160375524618.881414.16347303401529121282.stgit@magnolia>
 <160375525913.881414.1818734123140314548.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160375525913.881414.1818734123140314548.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
