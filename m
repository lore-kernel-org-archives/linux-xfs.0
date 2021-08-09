Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E1EAC4338F
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Aug 2021 14:57:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8593461019
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Aug 2021 14:57:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233910AbhHIO6O (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Aug 2021 10:58:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234075AbhHIO6O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Aug 2021 10:58:14 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF2F3C061796
        for <linux-xfs@vger.kernel.org>; Mon,  9 Aug 2021 07:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=VcYAi0866a6Vl9nWWgZct/ZeA+
        uk7aH6v8SZF/b3qyuLsFqKudAwXhXpiBJGjKXaAldFs7ZYvrGGxxj7pLtarCwOE20FfdeQwRUGXBE
        4QdUET8TMR4Smsa0coFbPUoNwtNNkNe+UrB36ODG5W/3yhD9scXX4MAevY+9PPQUgh6RGucYNuwxK
        CDsWbKwiSV2q87a+Hv07Y5EIEINqeFmFEjM7mVmz/Lh/17tT6K0Tf5WQ+F/8aLzUllUQRRjj0gS3v
        hYDuUcBcpl6n9yWMULluVpSN+MFqt45hd2l4xb+xqjFDmUv6BYJaWrXtViXKCvFbhFUa6OtxhDHsY
        TQt0Lmag==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mD6h1-00B5wa-QV; Mon, 09 Aug 2021 14:56:41 +0000
Date:   Mon, 9 Aug 2021 15:55:55 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: dump log intent items that cannot be recovered
 due to corruption
Message-ID: <YRFB+xkjIrhaT/fw@infradead.org>
References: <162814684332.2777088.14593133806068529811.stgit@magnolia>
 <162814687097.2777088.3937845877884086271.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162814687097.2777088.3937845877884086271.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
