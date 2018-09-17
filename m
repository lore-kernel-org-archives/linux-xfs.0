Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:41258 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727329AbeIRCW6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Sep 2018 22:22:58 -0400
Received: from 089144198037.atnat0007.highway.a1.net ([89.144.198.37] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1g20Wr-0005vI-Ck
        for linux-xfs@vger.kernel.org; Mon, 17 Sep 2018 20:53:57 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: delalloc and reflink fixes & tweaks
Date: Mon, 17 Sep 2018 22:53:44 +0200
Message-Id: <20180917205354.15401-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

this series starts with a for-4.19 fix originally from Dave, and then
has various tweaks, including a fix for a potential uninitialized data
exposure that are 4.20 material.
