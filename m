Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:53370 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752069AbdDKLKS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2017 07:10:18 -0400
Received: from 212095007090.public.telering.at ([212.95.7.90] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cxtgc-0004nz-6q
        for linux-xfs@vger.kernel.org; Tue, 11 Apr 2017 11:10:17 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: split the reflink remap from the block allocation path V2
Date: Tue, 11 Apr 2017 13:10:05 +0200
Message-Id: <20170411111011.9437-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

We've run into various problems due to the fact that the reflink remap
code reuses the xfs_bmapi_write codepath for setting up the extent list
entries and abuses the firstblock field for that purpose.

This series fixes this by creating an entirely separate xfs_bmapi_remap
path that is much simpler than xfs_bmapi_write and does not need to
overload the firstblock field.

Changes since V1:
 - warn when encountering invalid forks in bmap item recovery
 - tidy up the xfs_bmap_add_extent_hole_real declaration
 - trivial indentation change in xfs_bmapi_remap
