Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:38426 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728933AbfFXNnS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jun 2019 09:43:18 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: xfs cgroup writeback support
Date: Mon, 24 Jun 2019 15:43:13 +0200
Message-Id: <20190624134315.21307-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>

Hi all,

this small series adds cgroup writeback support to XFS.  Unlike
the previous iteration of the support a few years ago it also
ensures that that trailing bios in an ioend inherit the right
cgroup.  It has been tested with the shared/011 xfstests test
that was written to test this functionality in all file systems,
and manually by Stefan Priebe.

This work was funded by Profihost AG.

Note that the first patch was also in my series to move the xfs
writepage code to iomap.c and the second one will conflict with
it.  We'll need to sort out which series to merge first, but given
how simple this one I would suggest to go for this one.
