Return-Path: <SRS0=jPpR=BA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2BCFC433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jul 2020 14:56:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DFF020729
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jul 2020 14:56:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HH1ghE2D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728342AbgGUO4E (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jul 2020 10:56:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbgGUO4D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jul 2020 10:56:03 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 449B1C061794
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 07:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=cbU0aZccU6WiebLEurluXhYLJMgWUb7gS1CqF4SCG2c=; b=HH1ghE2D1sDDQtI7QkOOyg6KxZ
        5AVxUD5EAdfnX2Bjgn1tUpY2LlnvuikaE3wckdWL5yuLp6JTZmbXl4B9H8wAkTvOYJ3/BFkPmzl1W
        eqGQSsd8UAYyDA47XemrPf45/d3+PJKa9/RY+Fr68QNIi35xOXZ6Zn6TJe/ByvcPpfalbF4z83YFX
        efNoaIIHPbj37J/lmhy2TWet0LlTOflhCmjgP4RymPAR2xWRW+H8MQCVJCuDF9dsOCyYoaFYklCLQ
        jG4DSvTui35z47LU8kjpIpIpOsGmcr3sCCCibS24gBJNHABrN8fMgzBMqcOHgtMloql0fYmkB1enN
        0WJ0hnVQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jxtgX-0001mz-HG; Tue, 21 Jul 2020 14:56:01 +0000
Date:   Tue, 21 Jul 2020 15:56:01 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/11] xfs: refactor quota type testing
Message-ID: <20200721145601.GE6208@infradead.org>
References: <159488191927.3813063.6443979621452250872.stgit@magnolia>
 <159488195153.3813063.7311387972463609613.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159488195153.3813063.7311387972463609613.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 15, 2020 at 11:45:51PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Certain functions can only act upon one quota type, so refactor those
> functions to use switch statements, in keeping with all the other high
> level xfs quota api calls.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
