Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFD62C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jul 2022 04:13:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236654AbiGSEN2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Jul 2022 00:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234366AbiGSEN1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jul 2022 00:13:27 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E524B3AB08;
        Mon, 18 Jul 2022 21:13:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=NAYRW9cmU0Gy9t9nmn9DB0kww6qAExdpRdtfRCJHOto=; b=gK4x7Tfdr+V63eRT0KCyoBr6lU
        u6RKBoqqiIeNirZJeJ1urKU+EozDj575HkK5j1G7aa6RFUQjNmZAllQbj5LkuqyW6V/rCCy1rxM9Y
        mUPOUAl5RAGJO1diArR0waUd2xnKpgj+fRJfEOJJ5e7a309LHbeSEUaUm9iRwF3RxIccoYB3RTeLS
        nBiYaKPvkLR+x9UtKH3MibnEeWIaea5uCXTzB3pObZLkPuL3z/v99Z7lIoAWmjYtbBBSWWIQsOkyu
        HoaA1uq/F0k62K4IKm2qQFb97nva+wXZqnF9xCIqpJ9az/z2hLxar6W4ueyuilB+7n50aEN9u8PQR
        g47l/NsQ==;
Received: from 089144198117.atnat0007.highway.a1.net ([89.144.198.117] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oDebh-004jS8-PN; Tue, 19 Jul 2022 04:13:14 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Naohiro Aota <naohiro.aota@wdc.com>
Cc:     Johannes Thumshirn <jth@kernel.org>, cluster-devel@redhat.com,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: remove iomap_writepage v2
Date:   Tue, 19 Jul 2022 06:13:07 +0200
Message-Id: <20220719041311.709250-1-hch@lst.de>
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

Changes since v1:
 - clean up a printk in gfs2

Diffstat:
 fs/gfs2/aops.c         |   26 --------------------------
 fs/gfs2/log.c          |    5 ++---
 fs/iomap/buffered-io.c |   15 ---------------
 fs/zonefs/super.c      |    8 --------
 include/linux/iomap.h  |    3 ---
 5 files changed, 2 insertions(+), 55 deletions(-)
