Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C120FC433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 12:25:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AA3A64E94
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 12:25:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbhBAMZ1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Feb 2021 07:25:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbhBAMZ0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Feb 2021 07:25:26 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DBF1C061756
        for <linux-xfs@vger.kernel.org>; Mon,  1 Feb 2021 04:24:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=CNzGeLfokY+WZDs6+l5y1OyaJO
        UdnbROJO9QMfNab0ljq4Qat3UVAzoA0f4RXoMq4kbIna56OZP61xePWLQ6ury+v4PyLaMxKhHlY0E
        +Ja8Ecc/cl9EGKdnIpphZ+HnKmDDUUXcntHyA1MpcgDpQxwqYB307kMZOh352GllMCA+IHlxJMg64
        82E1K7PeKiqlsPhI3BWqteWiR6KnqjBJX4tfnV3oqPkly21Ps4mZVN6d5gjHhx5qSDZoFMC+Jhy1w
        KAWsO/m3Cju121IMvIhgUw8M0Ktj/oMLk/7W5wwC0qHsyBaCSYJssF+SzEIM+pdniSOsECAZ9L3et
        C3JuGfqw==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l6YG0-00DknZ-Sf; Mon, 01 Feb 2021 12:24:41 +0000
Date:   Mon, 1 Feb 2021 12:24:40 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 06/12] xfs: try worst case space reservation upfront in
 xfs_reflink_remap_extent
Message-ID: <20210201122440.GA3277943@infradead.org>
References: <161214512641.140945.11651856181122264773.stgit@magnolia>
 <161214516033.140945.16191685638325519980.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161214516033.140945.16191685638325519980.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
