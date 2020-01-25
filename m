Return-Path: <SRS0=/U9k=3O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AACAC35242
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Jan 2020 23:16:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F308D20704
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Jan 2020 23:16:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="E67fagrp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727601AbgAYXQV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Jan 2020 18:16:21 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:47188 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727496AbgAYXQV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Jan 2020 18:16:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=E67fagrpks++zbsK4Otze5qP5
        eg0VpRlBe43aCGzusTWUQAGlvkYQyiwRGw8p6CUweV36caY750iEhnG5rLh3ATeoFd5aCQGaua3EL
        QNd9ixWJLpDtjkw/ZUsETJ76FyDQsHy4Ux0p9gOg03pxkN8j5CREfcvSMqkgEwCinOhhuqwOXfGev
        eYJoN5X24x43m9nKrFH8fwxeS7HB03DwjyFexl3eW0pRvA5G9BHUhW6YXZNM/fuzchqfq3FtqNs1L
        gHT9VR1yP8ExulboUYVina7LtrHtV6wdBw6pEFjFleYEqpnoHcbhj5ISGtyQf3hdSLO379g0IG6QZ
        Iz/7mpH3g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ivUf6-0006gB-FO; Sat, 25 Jan 2020 23:16:20 +0000
Date:   Sat, 25 Jan 2020 15:16:20 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/8] man: document the xfs_db btheight command
Message-ID: <20200125231620.GF15222@infradead.org>
References: <157982499185.2765410.18206322669640988643.stgit@magnolia>
 <157982500443.2765410.17401149852075835578.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157982500443.2765410.17401149852075835578.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
