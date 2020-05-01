Return-Path: <SRS0=3WhG=6P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84D5FC47253
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 10:17:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DE682184D
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 10:17:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hWW/ZUmZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728268AbgEAKRX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 May 2020 06:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728119AbgEAKRX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 06:17:23 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57BCAC08E859
        for <linux-xfs@vger.kernel.org>; Fri,  1 May 2020 03:17:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ZQ6I8ntCz6KxWCftzIND48gNcppRZMp8qAgMcj/vSAE=; b=hWW/ZUmZ16YroT5oujd5Fen7Bm
        9N7U5YcxNqg/dDMzc0OwKbk3rtZrwdsU5uz1Lyr3ye++emX5onMWb4GE2oMFUfljrt8PSy7E0bRnK
        NrIR9G/Xgnv9SRFQIhq+N62nn0dIeP57oV6rTlXMBoSDkexumATp5BR8p/ytoTQ08KSu9hffhejsu
        vUE01RTQFzoqn/xdFhxr8omEgvzw6LSdltfe/lY3+PKAFy2xcGVU7bEGe6PgL2qrKhIhf1qvUkR13
        wk/gP4wv/5YNY9kHbeEYCVth/jE7bnMt9ndwD+WmcOsANqiqu945DSAjBHbUG8CbFc+RrOJQyuQ3W
        8Z0s9IJg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jUSjR-0000Cc-Ql; Fri, 01 May 2020 10:17:21 +0000
Date:   Fri, 1 May 2020 03:17:21 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 03/17] xfs: simplify inode flush error handling
Message-ID: <20200501101721.GA625@infradead.org>
References: <20200429172153.41680-1-bfoster@redhat.com>
 <20200429172153.41680-4-bfoster@redhat.com>
 <20200430183703.GD6742@magnolia>
 <20200501091730.GA20187@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501091730.GA20187@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Oh, and forgot one thing - can we remove the weird _fn postfixes in
the recovery method names?
