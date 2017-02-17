Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:48316 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933462AbdBQMtO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Feb 2017 07:49:14 -0500
Received: from 80-109-146-114.cable.dynamic.surfer.at ([80.109.146.114] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cehyL-0005Lo-EJ
        for linux-xfs@vger.kernel.org; Fri, 17 Feb 2017 12:49:14 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: two small allocator cleanups V2
Date: Fri, 17 Feb 2017 13:49:09 +0100
Message-Id: <20170217124911.11669-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Simplify the high-level RT allocator a bit, and drop two unused
allocation types.

Changes since V1:
  - restore accidentally removed error handling
  - fix a whitespace error
