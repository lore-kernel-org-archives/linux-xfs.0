Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EA1FC433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Jan 2021 08:04:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 195D1230FC
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Jan 2021 08:04:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbhAVIED (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 Jan 2021 03:04:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726351AbhAVIEC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Jan 2021 03:04:02 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1C00C06174A;
        Fri, 22 Jan 2021 00:03:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=gWjyUBA6XfbMVq+y8dYzlCUixc
        ullYjxHObSRMZi4B/y2uH8LP+vN4mLqOPPKjJy14QNHA1ZNqJYfUwXdwTEcY523BpTTEW2vfpJHxl
        oEGFg5+IecippOsHaGeKf30zGy40CThc04liYPIuY2on6S9ngWMbFVKjDi2CJYpGQx1n8SOASkOuN
        xoLENcz7Y4wjrjLSay598SgvDT+TQi/Rls6ApBF3OTlH6jbwLy/UHm8flUUCk+qipX9qEOQG8xSPJ
        /NkBw0BtbOoBij/VjzTaji9RnSi+Qs6VPDkizLYqj5JzbWIRkHijOvAL5Esf+zTjDvKt2kyrnB/jM
        i34GXDfA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l2rP6-000UMi-OQ; Fri, 22 Jan 2021 08:03:12 +0000
Date:   Fri, 22 Jan 2021 08:02:48 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Jeffrey Mitchell <jeffrey.mitchell@starlab.io>
Cc:     "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: set inode size after creating symlink
Message-ID: <20210122080248.GB113908@infradead.org>
References: <20210121151912.4429-1-jeffrey.mitchell@starlab.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210121151912.4429-1-jeffrey.mitchell@starlab.io>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
