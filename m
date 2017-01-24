Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:51612 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750766AbdAXURC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Jan 2017 15:17:02 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: avoid running out of space during finobt insertation
Date: Tue, 24 Jan 2017 21:16:18 +0100
Message-Id: <1485288980-17075-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: bfoster@redhat.com, linux-xfs@vger.kernel.org

Now growing into a series..

Changes since V2:
  - improve error handling in __xfs_ag_resv_init
  - improve mount time warning

Changes since V1:
  - reduce the size of the reservation
  - warn and fall back to the old somewhat buggy code if we can't
    get the reservation at mount time
  - read the AGF before asserting based on values in it
