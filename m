Return-Path: <SRS0=/U9k=3O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DF6EC35242
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Jan 2020 23:17:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2E8E20704
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Jan 2020 23:17:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qTS5Wu5m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728026AbgAYXRb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Jan 2020 18:17:31 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:47226 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727966AbgAYXRb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Jan 2020 18:17:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=qTS5Wu5mAF8YiUhEp1nFsIkGU
        8VBVaBhllOyoUq0NhWVZhQsA30/EIQPIfw25ImDYBtMIArW6IHAAH4T5NtWz4l9nXxjh6c1r01iaQ
        jlovEkDGkuU6gwAISPGxDf7pMhrM8lDyOXMuVO3Aff/Ji/Z1MTGuvXi7TFo9dJTjH+j4FYc/TkkZk
        8AoYNl9geISLrlDpYgheWb3ccT0miOvXujKaSoS5EP3P+VKY2lztEBly1J5O4eMVBsCDAAa8GkhKD
        vlDZK/UecFT9NGb0yoeVmg53/canGzefV+/deE8vSkfABTFJY43VGvojQTLC4JuKf6qINkkWQZkh8
        aCM/G0w/A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ivUgE-0006jc-Ad; Sat, 25 Jan 2020 23:17:30 +0000
Date:   Sat, 25 Jan 2020 15:17:30 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/8] xfs_db: dump per-AG reservations
Message-ID: <20200125231730.GI15222@infradead.org>
References: <157982499185.2765410.18206322669640988643.stgit@magnolia>
 <157982502518.2765410.15232492114026905479.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157982502518.2765410.15232492114026905479.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
