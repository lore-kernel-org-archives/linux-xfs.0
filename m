Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:60864 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934462AbeB1Rp6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Feb 2018 12:45:58 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: iomap fixes
Date: Wed, 28 Feb 2018 09:45:49 -0800
Message-Id: <20180228174552.31919-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: david@fromorbit.com

A few iomap fixes for 4.16-rc and -stable:

 - don't allocate blocks for zeroing holes or unwritten extents on files
   with the reflink bit set
 - don't take the exlusive ilock when no needed in iomap_begin
 - don't block on the ilock for RWF_NOWAIT

