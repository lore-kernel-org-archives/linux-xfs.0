Return-Path: <SRS0=Q7ae=6N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EAE1C83000
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 15:05:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2692921973
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 15:05:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PyXyB+vh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbgD2PFQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Apr 2020 11:05:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbgD2PFQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Apr 2020 11:05:16 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BE6AC03C1AD
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 08:05:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=aYkywvY3skdh5FNlKpHdQKueHWh7ugnEU21iqOXn6K4=; b=PyXyB+vhO4lzCknj4TSteCyIZe
        CoN5wUPXiRUxWJL1MTLUVPaXruxJzofXhhYbMfRCOMLxuDo7Damj5Mm88PUqZ8IO4j3yyqpa6P6PL
        DsKFLhEvh3NXCGD1yPFYkzuHDLuv4XalxzeHEUa9rFpBIb4cfKxOQ1Hj+ZoDI7L6zsadutbzlQzuq
        juNSndGWrcgFKIcG6E7epgu64tQkM1gTmOsg+6gk8h/yMykuoMOExXx4rSC3oMk+HVk9KDUDfMU/b
        T5LA2B3XHbFU31pzdfafA3cp6ITQCCB6f3Zr4vGb+j2jzALBpR7ybJkLHOVptcXhgWpDyXYykw7od
        dtplkJWQ==;
Received: from [2001:4bb8:184:1b25:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jToGx-00008E-Qw
        for linux-xfs@vger.kernel.org; Wed, 29 Apr 2020 15:05:16 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: deferred operations cleanup
Date:   Wed, 29 Apr 2020 17:05:00 +0200
Message-Id: <20200429150511.2191150-1-hch@lst.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

this series cleans up the deferred operations code by merging a few
methods, and using more type safe types.
