Return-Path: <SRS0=zOU/=7G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1D85C433DF
	for <linux-xfs@archiver.kernel.org>; Sun, 24 May 2020 09:14:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DBD02076C
	for <linux-xfs@archiver.kernel.org>; Sun, 24 May 2020 09:14:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DRe7Ofx2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728502AbgEXJOv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 24 May 2020 05:14:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728252AbgEXJOu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 May 2020 05:14:50 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF4BDC061A0E
        for <linux-xfs@vger.kernel.org>; Sun, 24 May 2020 02:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=0suoN58l+n6zl8GgJxH7sNgdT4plcdYfoCNw/daCG+A=; b=DRe7Ofx26xU9VngXY2+L0nnP8x
        8pcnq5M+rwhvPXjzMfLmCubDYNcz5G0d0ibndcyqYavGlke5bbxalaJUCU5xmvLrlU02ncDA8G6Fx
        BeW2oIgW+Poan8GXxxPBNNgFJA8iGoJ0j8NrhhqganXPrgplLzOEAj3Hg2kKL9sXEz+sS4VhCZL8b
        sQg2pgIt43JxcdYk1HHoXruk1JWYEILiB2HqIKq5YOPL/91RIJCYRKQ5E2eycG4fDHr7nCXg5tcIn
        o1u9vM6JwF5YDdcZ7uwbqHRldn9O11Xhe0hKpKsnSM7XJpRfMKiti4WrckA1mczDkU1GM4rxb4XsO
        RB3PD0Kg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jcmiU-00024V-D4; Sun, 24 May 2020 09:14:46 +0000
Date:   Sun, 24 May 2020 02:14:46 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, bfoster@redhat.com
Subject: Re: [PATCH 2/4] xfs: measure all contiguous previous extents for
 prealloc size
Message-ID: <20200524091446.GA6703@infradead.org>
References: <159025257178.493629.12621189512718182426.stgit@magnolia>
 <159025258515.493629.3176219395358340970.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159025258515.493629.3176219395358340970.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

I really, really hate the pointless use of shits where the
multiplication makes it obvious what is going on, and still allows
the compiler to opimize it in whatever way it wants.
