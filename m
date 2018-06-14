Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33820 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755147AbeFNMFD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Jun 2018 08:05:03 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: iomap preparations for GFS2 v2
Date: Thu, 14 Jun 2018 14:04:51 +0200
Message-Id: <20180614120457.28285-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>, linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com, linux-ext4@vger.kernel.org

Hi all,

this is a slight rework of the patches from Andreas to prepare for gfs2
using the iomap code.

Note: I'd like to start with an immutable branch for iomap patches in either
the XFS tree or a tree of mine at the beginning of the merge window so that
we have a common base for the GFS2 and XFS iomap work.

Changes since v1:
 - move code to a different spot in iomap.c to prefer for readpages
   inline data support
 - add a forward declaration for struct page to iomap.h
 - fix a typo in the dax_dev/bdev unioning
 - fix a comment typo
