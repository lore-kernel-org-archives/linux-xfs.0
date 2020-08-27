Return-Path: <SRS0=R4OI=CF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78419C433E1
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 06:43:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 527BA22B47
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 06:43:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bpTWmeJm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbgH0Gn6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Aug 2020 02:43:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726266AbgH0Gn4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Aug 2020 02:43:56 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14C9DC061263
        for <linux-xfs@vger.kernel.org>; Wed, 26 Aug 2020 23:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=bpTWmeJmdkC8CAa0HBuKKTbaYW
        dLQE9Dmz3skRc/bCSaOt6FbelDSS+YBrvtSrLrbLcXgRb0MOyeDdLfJtaqY6XPvsSq1s3f75sU/SZ
        ITZPemtbyR6lEasN6DwLSpJsqiTUIiziFLClk24Y3JIVr+tEr0S7lLCI1OdS4oZjGI/p17qwd/U0I
        4dQQd1rSI7GuVBlOn1cvTh4iPMXkkzdXbNo6uZSscTkksNyJmj75RCYe9wNX/JX3SrUgtp+GD+tl8
        x0M1SqiQv1FuGJ2mGA56eJ3q/82DOms0GV+WLg3ggM+fKwniGrMwPI4SPn/gWiUPQrPOeIpGlcJsd
        UPBwxM/w==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kBBda-0004Fn-5f; Thu, 27 Aug 2020 06:43:54 +0000
Date:   Thu, 27 Aug 2020 07:43:54 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     david@fromorbit.com, hch@infradead.org, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, sandeen@sandeen.net
Subject: Re: [PATCH 02/11] xfs: refactor quota expiration timer modification
Message-ID: <20200827064354.GC14944@infradead.org>
References: <159847949739.2601708.16579235017313836378.stgit@magnolia>
 <159847951097.2601708.4996467759505702991.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159847951097.2601708.4996467759505702991.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
