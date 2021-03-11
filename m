Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F758C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 12:57:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1820864FE9
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 12:57:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233243AbhCKM5P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Mar 2021 07:57:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233151AbhCKM4u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Mar 2021 07:56:50 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DE80C061574;
        Thu, 11 Mar 2021 04:56:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1jJxFSoWuLPDTet+HWCh0fqGUmXgDLQLf1gfPj3iIww=; b=wJY/0IjG/ULSj7JsJ9vdx2l7h/
        sDoHMxkwRNn6HlhGlLH34AQZ73wweRgVpRv7kq8hTos8jCgoje4fa7Rf9g6u8WM5D9fVQTRVQB5Ms
        wmt1b14b/EFeZx1f1oLiazimgFjrSXkEcq0+mq6MZEbDuJt6gsH71vPPSn8rQkT8RiFmLcNYwmZly
        FNSsxQKnK1JzkcwoJG4YVB9VFZMxjUY/99dPGayqufdiZJBpn/PCYZtOqsVPiP1c3Nu17ockMB5E4
        Qg9Df7xhaQ6eCQiejmYDyAO9R2D0VDJrzLUDX4zN+Npob7i0oDfbDWWvhJJTymPqTR6EPHgoDAVOL
        MFHdYaVA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lKKrY-007KQm-VD; Thu, 11 Mar 2021 12:56:28 +0000
Date:   Thu, 11 Mar 2021 12:56:24 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCHSET 0/2] fstests: remove obsolete DMAPI tests
Message-ID: <20210311125624.GD1742851@infradead.org>
References: <161526478158.1213071.11274238322406050241.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161526478158.1213071.11274238322406050241.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

I also did not get patch 1.

But I'm all for removing this cruft, so even without looking at the
details:

Acked-by: Christoph Hellwig <hch@lst.de>
