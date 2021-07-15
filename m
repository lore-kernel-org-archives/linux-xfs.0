Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2692FC07E96
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Jul 2021 06:07:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06D3661360
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Jul 2021 06:07:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbhGOGKa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Jul 2021 02:10:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbhGOGKa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Jul 2021 02:10:30 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C9F3C06175F
        for <linux-xfs@vger.kernel.org>; Wed, 14 Jul 2021 23:07:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=dULxkJe2afYf3d2nF3FAloKkF+
        87SDBTlqHLU7pq7fY0fX5d3bWTuZCbKn9aP7qd6vms39v2/NWmnmJ/RNto06DlJrsbdHUOgE/8n5K
        GHRPeT8JD0qtWxtIstkb7vGqBKUFkJcZgoGToQjwWoGYRlAFnixrJA5FRcmlQY57s0UxDZawQru8R
        PPA4Mi2+NkNEJR/bIhUG5cLstjGdxxpDEvrMfYZeuaAElQKoPUIZKcuRGI0DKtmSx7Al/n4BPv1lO
        3M/PT8eAdkqkGj0AbNGRpiqexy6HPD/XfMZi4QuzfHBOrth/Kn1qeuCGwcNRMEePMgUs/8TBt9EaZ
        6xt/sgjg==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m3uVs-0032oy-0E; Thu, 15 Jul 2021 06:06:37 +0000
Date:   Thu, 15 Jul 2021 07:06:23 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     david@fromorbit.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: fix an integer overflow error in xfs_growfs_rt
Message-ID: <YO/QX+dTmA0iQCvB@infradead.org>
References: <162629791767.487242.2747879614157558075.stgit@magnolia>
 <162629792874.487242.7435632593936391745.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162629792874.487242.7435632593936391745.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
