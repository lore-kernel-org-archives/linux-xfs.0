Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:45313 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751565AbdEEH5b (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 May 2017 03:57:31 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: XFS UUID cleanups
Date: Fri,  5 May 2017 09:57:22 +0200
Message-Id: <20170505075725.19597-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: amir73il@gmail.com

This series cleans up uuid usage in XFS a bit, inspired by the series from
Amir yesterday (from which the first patch is taken as-is).  This should
be seen as a precursor to more uuid work, so it might make sense to have
in in an immutable separate branch if we're able to get to agreement for
more kernel-wide uuid work.

