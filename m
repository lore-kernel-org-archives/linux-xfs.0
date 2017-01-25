Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:43230 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751363AbdAYJOg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Jan 2017 04:14:36 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: avoid running out of space during finobt insertation
Date: Wed, 25 Jan 2017 10:14:25 +0100
Message-Id: <1485335667-22435-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: bfoster@redhat.com, linux-xfs@vger.kernel.org

Another repost, now down to mostly cosmetic changes.  Hopefully
we can still make it for 4.10..

Changes since V3:
  - set m_inotbt_nores more aggresively
  - fix a comment typo
  - undo whitespace churn

Changes since V2:
  - improve error handling in __xfs_ag_resv_init
  - improve mount time warning

Changes since V1:
  - reduce the size of the reservation
  - warn and fall back to the old somewhat buggy code if we can't
    get the reservation at mount time
  - read the AGF before asserting based on values in it
