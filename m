Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:36790 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751488AbdBERLp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 5 Feb 2017 12:11:45 -0500
Received: from clnet-p099-196.ikbnet.co.at ([83.175.99.196] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1caQLn-0003DR-Nx
        for linux-xfs@vger.kernel.org; Sun, 05 Feb 2017 17:11:44 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: improve busy extent handling and add async discard support V2
Date: Sun,  5 Feb 2017 18:11:37 +0100
Message-Id: <20170205171141.6066-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This series improves the busy extent handling so hat we don't break
the guarantee of being able to complete an allocation after fixing
the freelist, and once this is sorted out adds support for submitting
discard requests without blocking the log commit handler, which
significantly stresses the busy extent handling.

Changes since V1:
 - address various feedback from Brian
