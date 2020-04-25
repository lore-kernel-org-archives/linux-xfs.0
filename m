Return-Path: <SRS0=0X6r=6J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47BD9C54FCB
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Apr 2020 18:36:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 257E820728
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Apr 2020 18:36:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kLF3goMC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726232AbgDYSgo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Apr 2020 14:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726145AbgDYSgo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Apr 2020 14:36:44 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B93AC09B04D
        for <linux-xfs@vger.kernel.org>; Sat, 25 Apr 2020 11:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=HQVoESMOTpNV6q0vUVh8NBQW/ZNG7wHlHmx+MJfJFj8=; b=kLF3goMCw7lPHBhPIl2y45D0s0
        kzE3gmFvVwZKBmvyF8jn+j8sXO5WdM0CcY8+DCuSP+XH/sZ1yMEGpaZ/NLuL6C8SKgpdGfIareObm
        EdbmXPfthjUH4U0T7KmJXuFATN2Zohwgv7hbrAAGXt4z+ZBID80nM8iNdyTcJwzzzoPAaFSSHkAHb
        hk/0Ddh3jtqXJ5QETy4To7w6rwQ+Mva185/wgbinEYVXB/XcLSMUuKZr5hfJn60D0c+s2E1tRkBpf
        PH42A4/Faw+IOjjHYDP8AnO/xvH2nl+7ipD62H5K+S9gO9FvgEfHrjSCZy3L7jiGQTAkCUaaNOyZk
        JzdNnpXQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jSPfQ-0003na-AS; Sat, 25 Apr 2020 18:36:44 +0000
Date:   Sat, 25 Apr 2020 11:36:44 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 19/19] xfs: move xlog_recover_intent_pass2 up in the file
Message-ID: <20200425183644.GJ16698@infradead.org>
References: <158752116283.2140829.12265815455525398097.stgit@magnolia>
 <158752128537.2140829.17923623833043582709.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158752128537.2140829.17923623833043582709.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 21, 2020 at 07:08:05PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move xlog_recover_intent_pass2 up in the file so that we don't have to
> have a forward declaration of a static function.

FYI, I'd expect IS_INTENT and IS_INTENT_DONE to simply be flags in the
xlog_recover_item_type structure.
