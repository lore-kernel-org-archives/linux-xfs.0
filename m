Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:60690 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751034AbdA2Sov (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 29 Jan 2017 13:44:51 -0500
Received: from clnet-p099-196.ikbnet.co.at ([83.175.99.196] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cXuRz-00019V-RD
        for linux-xfs@vger.kernel.org; Sun, 29 Jan 2017 18:43:44 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: improve busy extent handling and add async discard support
Date: Sun, 29 Jan 2017 19:43:37 +0100
Message-Id: <1485715421-17182-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This series improves the busy extent handling so hat we don't break
the guarantee of being able to complete an allocation after fixing
the freelist, and once this is sorted out adds support for submitting
discard requests without blocking the log commit handler, which
significantly stresses the busy extent handling.
