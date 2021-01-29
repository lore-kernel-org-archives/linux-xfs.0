Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C421C433DB
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Jan 2021 06:02:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6896264DFF
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Jan 2021 06:02:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbhA2GCC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 29 Jan 2021 01:02:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232036AbhA2GCB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 Jan 2021 01:02:01 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 132A2C061573
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jan 2021 22:01:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=qUB8JIukGPr+td2Ollzs9nggeu
        DUuSgWZIXRqDHxnuvf4mLyP0JHrreWyGDo9Dm68ywYDw48WdH5djXbfsmH190s/Kd6xINWplxK/xN
        /JIHsGR/5HWR/VB3NmMXK0nIrUl/KxooI5+DnvotjAUlcmarGqAnI+nUFh01FZclDKHw5+V9ODMlb
        2I695gklVLtumDJCeNAjnUjm1GmE02L/bX+/csIzyIwLyGEt5axvU7hyVSWbvx8O3gdJos8xClQu3
        3El648Uy+Ci/XHGQ6qqw4TChYEz5vaaDaAgqyjMqPLHJ64UL9kQYjFYBWiBcE46uZaWc/AMr1sI9o
        h4CWB0rg==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l5MqI-009SKO-8u; Fri, 29 Jan 2021 06:01:14 +0000
Date:   Fri, 29 Jan 2021 06:01:14 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 11/13] xfs: refactor inode creation
 transaction/inode/quota allocation idiom
Message-ID: <20210129060114.GB2253112@infradead.org>
References: <161188658869.1943645.4527151504893870676.stgit@magnolia>
 <161188665259.1943645.11392737598873084213.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161188665259.1943645.11392737598873084213.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
