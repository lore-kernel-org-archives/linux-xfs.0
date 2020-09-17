Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45D32C43461
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 07:55:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB3B620658
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 07:55:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tcO1BaFd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbgIQHz3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 03:55:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbgIQHyx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 03:54:53 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 002D4C06174A;
        Thu, 17 Sep 2020 00:54:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=tcO1BaFdIRpXL65fUIP8RLqiiw
        u6R3dLHggmEIR+sWUmuYXArpqmYHQ3GYqhFAnDVR2xId3TFYjeNv94qBjGqa7Q6mT15SZ8C/oNMSJ
        HdxG3SlPJuK26ApUxM0Unp1+C1Prop/RLyxSn7/Xqcg5uFc0p3eBdMIOgHS1bXEuM6dHupSeUZJFd
        Y6wrOqg6QdVaNW9Ig3qtdTaT5454JsZP3pjuEPkIxTgq59JKnpxSCvjljE9KAd4dFgmvtQ+rD7i59
        7BC1Ph7j9jvIexMz5euJnFTmyJ+qEDkETucxECC6yPlRgtU7w759M9jFUPSYq7XXKP6HdNNN4aTSo
        kFQVALmA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIoka-0007C8-4w; Thu, 17 Sep 2020 07:54:40 +0000
Date:   Thu, 17 Sep 2020 08:54:40 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 07/24] xfs/{111,137}: replace open-coded calls to repair
 with _scratch_xfs_repair
Message-ID: <20200917075440.GG26262@infradead.org>
References: <160013417420.2923511.6825722200699287884.stgit@magnolia>
 <160013422059.2923511.8441653519485642397.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160013422059.2923511.8441653519485642397.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
