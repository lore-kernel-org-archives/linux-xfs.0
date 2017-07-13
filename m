Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:43960 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751280AbdGMLdK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jul 2017 07:33:10 -0400
Received: from clnet-p099-196.ikbnet.co.at ([83.175.99.196] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dVcMn-0001o9-Hn
        for linux-xfs@vger.kernel.org; Thu, 13 Jul 2017 11:33:09 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: fixups for the changes in 4.13
Date: Thu, 13 Jul 2017 13:33:00 +0200
Message-Id: <20170713113304.8079-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

fix docs and assert locks for _ilocked helpers.  Rever the quota
change that does locking conditional on a flag, as that's never
the right way to do things.

