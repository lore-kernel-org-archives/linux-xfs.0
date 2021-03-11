Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE8CAC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 13:06:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74CA064FC3
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 13:06:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233194AbhCKNGT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Mar 2021 08:06:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233188AbhCKNFs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Mar 2021 08:05:48 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E1F1C061574
        for <linux-xfs@vger.kernel.org>; Thu, 11 Mar 2021 05:05:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5dAVrmT25pCOA37nGGHfTXlf8gRpjlmNpkc6zUEh18g=; b=mJMW/9UWGB5wBw642Gyb54c7h1
        7jYSbLQID3BWEUcZnLc6qL2dSNPRlsEP6U2cwatCkE9wOG+OzqE2JyH0AC4Svd76vGpIXNk14JIGq
        mXDOomNT66wpp08pQgLfnXkjqGFlkEJoQofrRVtVwFAm21lKLLEke2GnliyrMXuEE7s6OqIMqAnqf
        RM8Ch33KnGLXaX3y2cvL4lLeiL/Lkizv5EBoY95158CXS3A6wLBZRMJL1TFioTIMFyoj46oLnIkGT
        Mfqeys0Wy/ry0gYzQUFUptnc+SoxD7c7/igh1oUDIROOg/9YO4A7hPHdohhksGCH72VfzkXGrSeNZ
        wqrpGI1Q==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lKL0I-007Kz6-Oh; Thu, 11 Mar 2021 13:05:31 +0000
Date:   Thu, 11 Mar 2021 13:05:26 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/11] xfs: prevent metadata files from being inactivated
Message-ID: <20210311130526.GH1742851@infradead.org>
References: <161543194009.1947934.9910987247994410125.stgit@magnolia>
 <161543194600.1947934.584103655060069020.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161543194600.1947934.584103655060069020.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

Although at some point we really need to sort out the header mess..
