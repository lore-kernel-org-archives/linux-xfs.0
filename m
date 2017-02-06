Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:60299 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750950AbdBFHro (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Feb 2017 02:47:44 -0500
Received: from 212095007106.public.telering.at ([212.95.7.106] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cae1W-00042Y-Qb
        for linux-xfs@vger.kernel.org; Mon, 06 Feb 2017 07:47:43 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: reflink direct I/O improvements V3
Date: Mon,  6 Feb 2017 08:47:34 +0100
Message-Id: <20170206074738.13978-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This series improves the reflink direct I/O path, by avoiding a pointless
detour through delayed allocations and doing the allocations directly
from the iomap code.

Changes since V2:
 - handle the new scheme to use unwritten extents for preallocation
   properly
 - fix up tracing for bounced dio writes

Changes since V1:
 - align the alignment code with the regular direct I/O path
 - rebase on top the patches from Darrick to use unwritten extents
   in the direct I/O COW path
