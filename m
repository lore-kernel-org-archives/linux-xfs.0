Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:38652 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751311AbeE3KCM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 May 2018 06:02:12 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: iomap SEEK_HOLE / SEEK_DATA cleanups and generalization
Date: Wed, 30 May 2018 12:02:05 +0200
Message-Id: <20180530100208.31490-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Andreas Gruenbacher <agruenba@redhat.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

Refactor the seek pagecache helpers to work independent of buffer_heads,
and clean up a few lose bits.

This is needed for the small blocksize buffered I/O support in iomap.
