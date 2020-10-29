Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4D0FC2D0A3
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 09:52:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 435C520735
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 09:52:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tZ2gEbsH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbgJ2Jwj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Oct 2020 05:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726063AbgJ2Jwj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 05:52:39 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCBEFC0613D7
        for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2020 02:52:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=tZ2gEbsH01+Iwussz8vujxrgzy
        b3u5O1c/k6xjYMtY4gAKSCxFKhwcbjTvWOSYorgYHeWF9xX6YSRfSzMsORXm7drOZGnMTjy0gLY3F
        OHplCfPcnV0cfSnr74dnp19urfHAtqoCPm9iNtN7Cn49kbCB+ezSUEmDLTKc9+tooeX9ywcAehAey
        abJSLY0UzXBFPAkKtQXPAJbZkzLmVnBlFjX1Sn+B2IktGa83ud6XKarYuLGJ5D4bnCE8Zf4Gb+ryO
        zg2NQMdgfX6c/wgdulRB5pb5Pb78qCG/AKTPhsijBR7SAPFKX//2WJNXPCksuvhF9uKYclhuH6hEa
        b3t2sU+g==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kY4bY-0001qB-GK; Thu, 29 Oct 2020 09:52:24 +0000
Date:   Thu, 29 Oct 2020 09:52:24 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 25/26] mkfs: format bigtime filesystems
Message-ID: <20201029095224.GT2091@infradead.org>
References: <160375524618.881414.16347303401529121282.stgit@magnolia>
 <160375540688.881414.887151161169932986.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160375540688.881414.887151161169932986.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
