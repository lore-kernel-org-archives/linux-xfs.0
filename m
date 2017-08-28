Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:55716 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750735AbdH1GhF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Aug 2017 02:37:05 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: cleanup the page faul path
Date: Mon, 28 Aug 2017 08:36:57 +0200
Message-Id: <20170828063659.21045-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: jack@suse.cz

Hi alļ,

these two patches simplify the xfs/iomap page fault path.  They came up in
the context of MAP_SYNC support, but are useful on their own, and might be
good to get into 4.14 before the real MAP_SYNC work starts hitting the
tree in some form.

