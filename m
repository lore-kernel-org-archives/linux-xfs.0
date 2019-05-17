Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:44026 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727361AbfEQHcI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 May 2019 03:32:08 -0400
Received: from 089144210233.atnat0019.highway.a1.net ([89.144.210.233] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hRXLc-0000ht-3L
        for linux-xfs@vger.kernel.org; Fri, 17 May 2019 07:32:08 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: misc log item related cleanups
Date: Fri, 17 May 2019 09:30:59 +0200
Message-Id: <20190517073119.30178-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

I've recently been trying to debug issue related to latencies related to
locked buffers and went all over our log item lifecycles for that.

It turns out a lot of code in that area is rather obsfucated and
redundant.  This series is almost entirely cleanups, but there are lots
of it.  The only exception is a fix for systematic memory leaks which
appears entirely theoretical.
