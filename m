Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:50725 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751200AbdIOOy1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Sep 2017 10:54:27 -0400
Received: from [8.25.222.2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dss0g-0003Ha-R1
        for linux-xfs@vger.kernel.org; Fri, 15 Sep 2017 14:54:26 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: refactor extent manipulation V2
Date: Fri, 15 Sep 2017 07:54:08 -0700
Message-Id: <20170915145426.26194-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

this series refactor the extent manipulation routines so that they are
isolated from the nitty gritty details of the extent list implementation.
It is the first step towards a more scalable extent list data structure.

Changes since V1:
 - use better fitting XFS_BMAP_* constant in xfs_bmap_del_extent_*
 - various fixes and cleanups in xfs_bmap_add_extent_delay_real
