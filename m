Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:36131 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752325AbdIRPYX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Sep 2017 11:24:23 -0400
Received: from [107.17.164.65] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dtxuJ-0005D0-2h
        for linux-xfs@vger.kernel.org; Mon, 18 Sep 2017 15:24:23 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: refactor extent manipulation V3
Date: Mon, 18 Sep 2017 08:24:03 -0700
Message-Id: <20170918152422.24345-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

this series refactor the extent manipulation routines so that they are
isolated from the nitty gritty details of the extent list implementation.
It is the first step towards a more scalable extent list data structure.

Changes since V2:
 - fix xfs_bmap_add_extent_delay_real again
 - new patch to refactor delalloc accouting in xfs_bmap_add_extent_delay_real

Changes since V1:
 - use better fitting XFS_BMAP_* constant in xfs_bmap_del_extent_*
 - various fixes and cleanups in xfs_bmap_add_extent_delay_real
