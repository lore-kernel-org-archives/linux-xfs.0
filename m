Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:52581 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755116AbdBGRPW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Feb 2017 12:15:22 -0500
Received: from 80-109-146-114.cable.dynamic.surfer.at ([80.109.146.114] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cb9M8-0006Oi-4Q
        for linux-xfs@vger.kernel.org; Tue, 07 Feb 2017 17:15:12 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: improve busy extent handling and add async discard support V3
Date: Tue,  7 Feb 2017 18:14:56 +0100
Message-Id: <20170207171501.4268-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This series improves the busy extent handling so hat we don't break
the guarantee of being able to complete an allocation after fixing
the freelist, and once this is sorted out adds support for submitting
discard requests without blocking the log commit handler, which
significantly stresses the busy extent handling.

Changes since V2:
 - make sure all busy extents are gone at umount time
 - document the busy_gen handling

Changes since V1:
 - address various feedback from Brian
