Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50624 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966328AbcLVUA0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Dec 2016 15:00:26 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: minleft fixes V2
Date: Thu, 22 Dec 2016 21:00:17 +0100
Message-Id: <1482436822-31546-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: eguan@redhat.com, darrick.wong@oracle.com

his is my attempt to fix the problems with rmap and reflink file system
running out of space during delayed extent conversions.  It turns out
the way minleft has been handled has always been bogus, but the rmap
enablement made it even worse..

This has survived xfstests xfs/109 on a 2k fs for a couple hours now
but Eryu was much better than me at reproducing the problems, so it could
use some further testing.

Changes since V1:
 - new patch to fix the noalign case in xfs_bmap_btalloc
 - new patch to fix xfs_alloc_set_aside
 - dropped the patch to increase the minleft value for bmap allocations,
   we only need the current minimal values as we only allocate one
   extent per call
 - minor style fixes per review of the last round
