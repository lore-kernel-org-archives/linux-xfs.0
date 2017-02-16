Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:35672 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932975AbdBPVVP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2017 16:21:15 -0500
Received: from clnet-p099-196.ikbnet.co.at ([83.175.99.196] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1ceTUI-0007fz-Az
        for linux-xfs@vger.kernel.org; Thu, 16 Feb 2017 21:21:14 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: two small allocator cleanups
Date: Thu, 16 Feb 2017 22:21:08 +0100
Message-Id: <20170216212110.4370-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Simplify the high-level RT allocator a bit, and drop two unused
allocation types.

