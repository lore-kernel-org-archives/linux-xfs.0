Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 125C2C07E96
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Jul 2021 06:05:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1D7E611AB
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Jul 2021 06:05:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231402AbhGOGIA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Jul 2021 02:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbhGOGIA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Jul 2021 02:08:00 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67C39C06175F
        for <linux-xfs@vger.kernel.org>; Wed, 14 Jul 2021 23:05:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=0iAssYI3WU/1tjUpM3X70XKQhztmRr0b1ONQh+SFEOw=; b=IlYnROQX07yfk8Ai++7Add/AlW
        Ajz99Ksku2brvtw52C6x9xpyWu0ALCtSeEsFEttjMQF9KzpvWhK1geAVE0YdmqmZmJG6sUgl4RCQK
        R3GECxuq+nCKODIF+gq+pncFdnbMZVhyGDssA5XI071qbl4HGBSiU1H9uVCJEeFDJNPRrqHhloGlZ
        UkhbuKn+ZQ/Sb7DwP32zESkem80Oh88vqPg74zLJKgoJYuWOrrQQodPK+uq0b8nHqz58i2kn8DtTA
        fA47Jd+KnSmQElhT+M+x4qMIcG7gHbJRpFCifySDXAgm32DmCs4kQNKPRGRvJp6zMlDjKheZsZXmS
        7Mk+60JA==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m3uTC-0032iH-3L; Thu, 15 Jul 2021 06:03:57 +0000
Date:   Thu, 15 Jul 2021 07:03:38 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     david@fromorbit.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: improve FSGROWFSRT precondition checking
Message-ID: <YO/PulIEt+LR912Y@infradead.org>
References: <162629791767.487242.2747879614157558075.stgit@magnolia>
 <162629792325.487242.1728593976863145148.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162629792325.487242.1728593976863145148.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 14, 2021 at 02:25:23PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Improve the checking at the start of a realtime grow operation so that
> we avoid accidentally set a new extent size that is too large and avoid
> adding an rt volume to a filesystem with rmap or reflink because we
> don't support rt rmap or reflink yet.
> 
> While we're at it, separate the checks so that we're only testing one
> aspect at a time.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
