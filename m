Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED806C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jul 2022 04:15:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbiGKEPP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jul 2022 00:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiGKEPO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jul 2022 00:15:14 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53BD5183A8;
        Sun, 10 Jul 2022 21:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=BDOTeFOO/FY7pwwFSR0eN21wouhgtH3k9FnygVND/RY=; b=NJMKpxLIc4Unlnzp8VLN/dGfEz
        ko2Hr/tYVCVUEvdT2Clsd1+57jBAkeDzHcTvjxCZ4KwnSqsYMitSRULRDCpJcirQtbdKP9t+uH92X
        ZRdmMs9avfqNDT2H3vM3kNg3wsmSo8g5IMb3ZORiUVvKJv5D7kjpa/sCeAvU6gW+SY/bP4v9aqF/L
        hxcHY+U7vYGNPl9Z2RSkdd5PlJK3KOSeLBs95zWpoQFWYlpYmoXPvwv/Qt/aXPU7lW6TKS8+/tAdH
        kbkYQhvoRUWys1O5pdX+HF/OMcx/rYmyTwLZjn/3PORAF1r//5sWuksgnVAzVkbCKRxM6HFQMAafA
        A7nMtxqQ==;
Received: from 089144197153.atnat0006.highway.a1.net ([89.144.197.153] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oAkp4-00FpvP-G0; Mon, 11 Jul 2022 04:15:02 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Naohiro Aota <naohiro.aota@wdc.com>
Cc:     Johannes Thumshirn <jth@kernel.org>, cluster-devel@redhat.com,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: remove iomap_writepage
Date:   Mon, 11 Jul 2022 06:14:55 +0200
Message-Id: <20220711041459.1062583-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

this series removes iomap_writepage and it's callers, following what xfs
has been doing for a long time.

Diffstat:
 fs/gfs2/aops.c         |   26 --------------------------
 fs/gfs2/log.c          |    2 +-
 fs/iomap/buffered-io.c |   15 ---------------
 fs/zonefs/super.c      |    8 --------
 include/linux/iomap.h  |    3 ---
 5 files changed, 1 insertion(+), 53 deletions(-)
