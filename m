Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4B90C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Sep 2021 08:45:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DDDD61131
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Sep 2021 08:45:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231239AbhIUIrC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Sep 2021 04:47:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbhIUIrB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Sep 2021 04:47:01 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB7DCC061574
        for <linux-xfs@vger.kernel.org>; Tue, 21 Sep 2021 01:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=nBGNq1lYM3KgT6aZsH50woPIOz
        vVqYT7DLPJ0InjyzzdHasyXSs+ZGZU9+h0T0qCGuigF5PLQ57NQpOp6qD4Jy7jWy7gp5EzVVOs8Gy
        we0B8DjW47s4lR7yuhKqso3ninoE6E/+E7ZKjHXfqwyc1Yc5aUVVlzlUlq2sIDfbUk3o5qndFLWOC
        e5CTba93F01NR8fFsA6q3L27RR+V/1NjkbpSexaefrDgvKPlEtgHo/wvGp4iVX5OpshmmL5tnOLvr
        rWBPusUC3KPA7/ZqV6Vpa/O224VjRFzejokv/KHiyYjZpZ9QC6X72qaPvm3hCFwrGAeu/KErxlKEr
        sq1i6gYw==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mSbOP-003e7d-8F; Tue, 21 Sep 2021 08:44:57 +0000
Date:   Tue, 21 Sep 2021 09:44:45 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     chandan.babu@oracle.com, chandanrlinux@gmail.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/14] xfs: check that bc_nlevels never overflows
Message-ID: <YUmbfX/U5taBO9eN@infradead.org>
References: <163192854958.416199.3396890438240296942.stgit@magnolia>
 <163192858276.416199.6204001049315596078.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163192858276.416199.6204001049315596078.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
