Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55630 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751161AbcI3Iqk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Sep 2016 04:46:40 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: fix struct file use after free in the AIO read path
Date: Fri, 30 Sep 2016 10:46:32 +0200
Message-Id: <1475225194-3702-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org

We can't use struct file after we have submitted I/O because aio_complete
might have done the final fput on it already.  Fix this by updating the
atime before performing I/O.

