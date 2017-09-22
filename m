Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:53752 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751979AbdIVN7q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Sep 2017 09:59:46 -0400
Received: from ip-64-134-232-11.public.wayport.net ([64.134.232.11] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dvOUc-000196-CS
        for linux-xfs@vger.kernel.org; Fri, 22 Sep 2017 13:59:46 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: refactor extent manipulation V4
Date: Fri, 22 Sep 2017 06:59:26 -0700
Message-Id: <20170922135945.31574-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

this series refactor the extent manipulation routines so that they are
isolated from the nitty gritty details of the extent list implementation.
It is the first step towards a more scalable extent list data structure.

Changes since V3:
 - fix xfs_bmap_add_extent_delay_real once again
 - trivial indentation fixup

Changes since V2:
 - fix xfs_bmap_add_extent_delay_real again
 - new patch to refactor delalloc accouting in xfs_bmap_add_extent_delay_real

Changes since V1:
 - use better fitting XFS_BMAP_* constant in xfs_bmap_del_extent_*
 - various fixes and cleanups in xfs_bmap_add_extent_delay_real
