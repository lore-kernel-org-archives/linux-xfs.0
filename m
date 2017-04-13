Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:34810 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751382AbdDMIF0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Apr 2017 04:05:26 -0400
Received: from 212095007060.public.telering.at ([212.95.7.60] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cyZkm-0007W5-JX
        for linux-xfs@vger.kernel.org; Thu, 13 Apr 2017 08:05:21 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: fix space reservations underneath xfs_bmapi_write
Date: Thu, 13 Apr 2017 10:05:07 +0200
Message-Id: <20170413080517.12564-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This series fixes the way xfs_bmapi_write deals with space reservations,
and as result gets rid of the low space allocator mode which could lead
to file system shutdowns due to ignoring the AG space allocation
constraints.
