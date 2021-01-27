Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC860C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jan 2021 17:06:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9090564DC3
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jan 2021 17:06:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235397AbhA0RGM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Jan 2021 12:06:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232970AbhA0RBx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Jan 2021 12:01:53 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 896F6C061786
        for <linux-xfs@vger.kernel.org>; Wed, 27 Jan 2021 09:01:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ADz11yBaa5CatZjGOZu1q3sWLZNFThgolBCTuKLKht0=; b=Ws07W0jJJBgJHVbmHITXHYWZkb
        PJ4vCR+63AqsEu9VnQ8y6Uyp/9oWX4TibOR+h3A4bzr4HG75edRRPBC4hWyhtE1oI2+OOARPM3RjH
        75qHItpUpN1zsroYBFYJgnesAMhgz8BXuvBXVx385j+zlbT47hMFM7qg4i7eTUdXZ+iTBN8OWTT+W
        mu9WYgK/s4SEAz1GrrDgPsKduxKPsgu6E4r9KsaptoAgiALV0a3xd1A/55lRba6Bn7Sc98KKA991W
        q71TnEvEX/qTxJmFTZl+fOa2me2jWOYwXd+QZmS4EJ2Qc05MYZBdi5HlKAuxLDGsqcTSYH5eq503G
        E/jSfMwQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l4oAh-007GBL-Ik; Wed, 27 Jan 2021 17:00:17 +0000
Date:   Wed, 27 Jan 2021 16:59:59 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH v4.1 05/11] xfs: pass flags and return gc errors from
 xfs_blockgc_free_quota
Message-ID: <20210127165959.GB1730140@infradead.org>
References: <161142791950.2171939.3320927557987463636.stgit@magnolia>
 <161142794741.2171939.10175775024910240954.stgit@magnolia>
 <20210126045237.GM7698@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210126045237.GM7698@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

I'm a little lost what these v4.1 patches right in the middle of a
deep thread area..
