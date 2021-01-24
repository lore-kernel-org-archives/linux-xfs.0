Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFE65C433DB
	for <linux-xfs@archiver.kernel.org>; Sun, 24 Jan 2021 09:35:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92F0E227BF
	for <linux-xfs@archiver.kernel.org>; Sun, 24 Jan 2021 09:35:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbhAXJfI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 24 Jan 2021 04:35:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726555AbhAXJfG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 Jan 2021 04:35:06 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7C17C061573
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jan 2021 01:34:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=YEBypyHITlbLGS3fetIRnsNTIb
        r4VILU+59DFXyoV0OGKfGmj5NlcIjJx1BSJTnjrdhCNPlgZZ3LASzCff6ih72GPhTMwOvCUOhQB6Q
        ajr1cYwf8paoi0ba3b5LfrotENfyBQU9EdY3dm2k5Ecn27a8oJeLTmUVuyTMtmhd9DWxaCQYxwHLH
        d5MHp3Od/brZvg5NiGZO+gDBmxVtgG8bWnyUxQtMnPks5WwPKnoADW8MJh5srznStbUJi4o3ftC+O
        cf+ieeOf+cfUuE0BD+8UziWk39jPq7dgsETi9OovCD2jVxVYIep3ClQb85P5luDHDrJg1o90TIKby
        M/Iw6bLg==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l3bmo-002oby-VP; Sun, 24 Jan 2021 09:34:23 +0000
Date:   Sun, 24 Jan 2021 09:34:22 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 05/11] xfs: pass flags and return gc errors from
 xfs_blockgc_free_quota
Message-ID: <20210124093422.GB670331@infradead.org>
References: <161142791950.2171939.3320927557987463636.stgit@magnolia>
 <161142794741.2171939.10175775024910240954.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161142794741.2171939.10175775024910240954.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
