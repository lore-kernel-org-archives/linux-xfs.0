Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:46086 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751921AbdDLKaQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Apr 2017 06:30:16 -0400
Received: from clnet-p099-196.ikbnet.co.at ([83.175.99.196] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cyFXU-0004j7-1H
        for linux-xfs@vger.kernel.org; Wed, 12 Apr 2017 10:30:16 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: split the reflink remap from the block allocation path V3
Date: Wed, 12 Apr 2017 12:30:07 +0200
Message-Id: <20170412103013.9355-1-hch@lst.de>
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

Changes since V2:
 - add a missing call to xfs_iread_extents

Changes since V1:
 - warn when encountering invalid forks in bmap item recovery
 - tidy up the xfs_bmap_add_extent_hole_real declaration
 - trivial indentation change in xfs_bmapi_remap
