Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50622 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754655AbdAITxq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Jan 2017 14:53:46 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: minleft fixes V3
Date: Mon,  9 Jan 2017 20:53:38 +0100
Message-Id: <1483991622-2339-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: eguan@redhat.com, darrick.wong@oracle.com, bfoster@redhat.com

his is my attempt to fix the problems with rmap and reflink file system
running out of space during delayed extent conversions.  It turns out
the way minleft has been handled has always been bogus, but the rmap
enablement made it even worse.

Changes since V2:
 - dropped "xfs: fix the alignment fallback in xfs_bmap_btalloc"
 - added a maxlen >= minlen assert
 - a few commit log improvements

Changes since V1:
 - new patch to fix the noalign case in xfs_bmap_btalloc
 - new patch to fix xfs_alloc_set_aside
 - dropped the patch to increase the minleft value for bmap allocations,
   we only need the current minimal values as we only allocate one
   extent per call
 - minor style fixes per review of the last round
