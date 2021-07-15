Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18662C1B08C
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Jul 2021 05:34:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E67B9610A7
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Jul 2021 05:34:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236792AbhGOFhX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Jul 2021 01:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231200AbhGOFhX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Jul 2021 01:37:23 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0377C06175F;
        Wed, 14 Jul 2021 22:34:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=DC5Eh3ICp+637a9ge9SI65OcEnP2EsbO9/6k0F6Sgyo=; b=ssuBxLrkcke6QEUF9zH2hgbXA1
        y7okFhxIsChImf1rSg9jUIYalWZZIwasr/oCpCgvr2n07/8yiVUGpz+RdCCTWl4jpys/SMFo8GVT8
        i8QCARwdH5TnOT10ci/SXxNdUOIQg2LIdK5Kt71PNIQrIYxV73q+wCSBUtwmzR3h30OGmEr5tBmDX
        4mVxf26L6X2xlX6Irt8OzOY5NW1R0a4uu5VRWfb0EWZvXTQlPmcYKJw7IQgNBy74vm4JqkqxWRAcD
        iAJOcVT7aogVRh8Eshppb4psqGxZ4eFc18ljzz9N9uKEBihvevIOTURiw9HYAgLohfdWqaL18As+/
        Use01zsg==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m3tzm-0031Vk-5O; Thu, 15 Jul 2021 05:33:24 +0000
Date:   Thu, 15 Jul 2021 06:33:14 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Chen, Rong A" <rong.a.chen@intel.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH v4][next] xfs: Replace one-element arrays with
 flexible-array members
Message-ID: <YO/Imho08THZXIX4@infradead.org>
References: <20210412135611.GA183224@embeddedor>
 <20210412152906.GA1075717@infradead.org>
 <20210412154808.GA1670408@magnolia>
 <20210413165313.GA1430582@infradead.org>
 <f074c562-774d-fb35-b6a2-01c3873bb6ec@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f074c562-774d-fb35-b6a2-01c3873bb6ec@intel.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

I'll repost the series eventually as it requires some deeper changes.
