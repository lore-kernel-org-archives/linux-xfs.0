Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:58176 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750950AbeGJGFf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Jul 2018 02:05:35 -0400
Received: from 213-225-34-75.nat.highway.a1.net ([213.225.34.75] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1fclmI-00055m-Jc
        for linux-xfs@vger.kernel.org; Tue, 10 Jul 2018 06:05:35 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: reduce lookups in the COW extent tree
Date: Tue, 10 Jul 2018 08:05:22 +0200
Message-Id: <20180710060528.4071-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This series (on top of the iomap series) reduce the number of lookups we
do in the COW tree by adding a sequence number that counts modifications
to the extent tree.
