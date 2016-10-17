Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38208 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932436AbcJQMGp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Oct 2016 08:06:45 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: fix locking for the reflink operation
Date: Mon, 17 Oct 2016 14:05:16 +0200
Message-Id: <1476705920-32493-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com

When creating a reflink we need to take the iolock much earlier, as
various early checks done in xfs_file_share_range currently are racy
without it.  Patches 1-3 sort that out in a minimal invasive way,
but I think we should just merge xfs_file_share_range and
xfs_reflink_remap_range, which is what patch 4 does.

Patches 1-3 are something I'd like to see in 4.9, patch 4 might not
fully qualify, but just getting it in might make everyones life easier.

