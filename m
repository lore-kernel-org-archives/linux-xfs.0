Return-Path: <SRS0=IY5l=AV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1360C433EA
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Jul 2020 16:11:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1472207F9
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Jul 2020 16:11:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UQztSnJ7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727098AbgGJQLR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jul 2020 12:11:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728142AbgGJQLM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jul 2020 12:11:12 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BA90C08C5DC
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jul 2020 09:11:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=RIKJi+zzyFRqND9drgV1QzclG78uOH8v+TTTjTC3zm4=; b=UQztSnJ7qcfQlkOy9+o29D706G
        r/XIETDGQrKXpX4wYmyl2+4eiD3Z5c6mgi9TmWlMEPrdJ+VTeaAnCpT3wJEDzfjxxiKthI+rxbWkn
        e5LKsdDHHg7DnKEOBbXVAoEY4gSpf78kbCxatWlQ4163arYMmUtXrI19eK+2OB9IZYOhdLxposGpZ
        3D0XX8nMFCovOmicRJ3NSIJTXHuTREzfxfVJRM6SfYtE7fPMQw38odtTbJDHZM9oSyWhdb6horddr
        PKyFs6kJynXk8jOwZ2GECVd4QrusicZVkVT90IS2ZiZFyL1VElt46K1/ZUckN+ilYcAFr020XnBgP
        nXSHuPoQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jtvcF-00039B-5v; Fri, 10 Jul 2020 16:11:11 +0000
Date:   Fri, 10 Jul 2020 17:11:11 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: Remove xfs_da_state_alloc() helper
Message-ID: <20200710161111.GE10364@infradead.org>
References: <20200710091536.95828-1-cmaiolino@redhat.com>
 <20200710091536.95828-6-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200710091536.95828-6-cmaiolino@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 10, 2020 at 11:15:36AM +0200, Carlos Maiolino wrote:
> xfs_da_state_alloc() can simply be replaced by kmem_cache_zalloc()
> calls directly. No need to keep this helper around.

Wouldn't it be nicer to keep the helper, and also make it setup
->args and ->mp?
