Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60898 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941726AbcJSOVL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Oct 2016 10:21:11 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: fix locking for the reflink operation V2
Date: Wed, 19 Oct 2016 14:47:23 +0200
Message-Id: <1476881248-18669-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com

When creating a reflink we need to take the iolock much earlier, as
various early checks done in xfs_file_share_range currently are racy
without it.  Patches 1-3 sort that out in a minimal invasive way,
but I think we should just merge xfs_file_share_range and
xfs_reflink_remap_range, which is what patch 5 does.

Patches 1-3 are something I'd like to see in 4.9, patch 4 and 4might not
fully qualify, but just getting it in might make everyones life easier.

Changes since V1:
 - Added Reviewed-by: tag for patches 1-3
 - New patch to remove xfs_file_wait_for_io
 - Keep the xfs_reflink_remap_range name instead of xfs_file_share_range
 - Remove a double semicolon
