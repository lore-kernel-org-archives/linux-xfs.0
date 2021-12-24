Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CAFDC433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Dec 2021 07:17:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351781AbhLXHRG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Dec 2021 02:17:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351780AbhLXHRF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Dec 2021 02:17:05 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D121C061401
        for <linux-xfs@vger.kernel.org>; Thu, 23 Dec 2021 23:17:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=f6wzqGXmCNdju5lrZGVyI02pML
        IMPb2GTwTYR0ni0oLFOZIQKTVVpGGtmwe8vrKIA4BruNWWKqV0tvEBk6ChD18gig7NllwJY2ajofS
        1Bn0JFCLdVFIA5DPvO4imD9XlbajD1GJLs8eeefblO2V4kY28sbjLIym7tusO8OrrfenAPDwPohvH
        KViGIB5ZWvazEKBR+EKONtkxAvoCp5g3xVErwhdjbUmcwR12TXCpZUbYFnzk8Djqlo6IlZAkqnXsi
        mvIly6i4gP48490BpI0dB08ZBxd7Oe+bFziDMX3EPMGHbEtKMhqn2skJfhwpdJdMXFxmAw3NmE7L2
        NrG33Uwg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n0ep7-00Dpsq-8Z; Fri, 24 Dec 2021 07:17:05 +0000
Date:   Thu, 23 Dec 2021 23:17:05 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/7] xfs: fix a bug in the online fsck directory leaf1
 bestcount check
Message-ID: <YcVz8a8QsFTxisnV@infradead.org>
References: <163961695502.3129691.3496134437073533141.stgit@magnolia>
 <163961697197.3129691.1911552605195534271.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163961697197.3129691.1911552605195534271.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
