Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C2AEC4338F
	for <linux-xfs@archiver.kernel.org>; Sun, 15 Aug 2021 08:58:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 569EC61042
	for <linux-xfs@archiver.kernel.org>; Sun, 15 Aug 2021 08:58:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbhHOI7X (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 15 Aug 2021 04:59:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbhHOI7W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 Aug 2021 04:59:22 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57526C061764
        for <linux-xfs@vger.kernel.org>; Sun, 15 Aug 2021 01:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=jmh2P4EkKsSxzVZYfDiflPEfYF
        Bva7AwVo9F8G11RQvivhj8RmoE+j1p24JxVCrrcQHs0NGpAkNiE8ESOggU/rBLRA46e2cRQWjRxoM
        n4L3bgRWkKnUyKAww1cinZ92LEwOr3klo5yOkuJePNJeZ37s4dvE6Ovn8jluiZbLzckPu4PlHCsrL
        HRmIYbA7w/jC3FTIamohIB3Pa4Gef6q6J3ioJCGU19CD1B/docKvYiIKy0yLebeWh7isqpZu+iWn8
        ej1b6hM3H+KzI+8Ct+meyo7VvSrGiRFfzeUXq23D4fJqejwOqigK44Pe/YhfSJOH6iCdsFAWIfIbR
        Pdee0Yvg==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mFByK-00HZOv-OZ; Sun, 15 Aug 2021 08:58:38 +0000
Date:   Sun, 15 Aug 2021 09:58:24 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/10] xfs: make the key parameters to all btree key
 comparison functions const
Message-ID: <YRjXMIsN+VTRY1fo@infradead.org>
References: <162881108307.1695493.3416792932772498160.stgit@magnolia>
 <162881108892.1695493.3056744650016025435.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162881108892.1695493.3056744650016025435.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
