Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:36130 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730984AbeITU0M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Sep 2018 16:26:12 -0400
Received: from 089144198037.atnat0007.highway.a1.net ([89.144.198.37] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1g309v-0006fe-T3
        for linux-xfs@vger.kernel.org; Thu, 20 Sep 2018 14:42:24 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: more reflink fixes & debug
Date: Thu, 20 Sep 2018 16:42:15 +0200
Message-Id: <20180920144220.2181-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

this series starts adds more reflink fixes on top of the series
from two days ago, plus two new debug patches to dump leftover
delalloc extents and a debug-only always_cow mode.
