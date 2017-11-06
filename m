Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:47585 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752315AbdKFOfB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2017 09:35:01 -0500
Received: from clnet-p099-196.ikbnet.co.at ([83.175.99.196] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1eBiUO-0000qc-LQ
        for linux-xfs@vger.kernel.org; Mon, 06 Nov 2017 14:35:01 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: sparse fixes
Date: Mon,  6 Nov 2017 15:34:48 +0100
Message-Id: <20171106143456.13567-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

the first patch changes how STATIC is defined for debug builds to
make sparse checks for debug builds work without a lot of noise.

The rest fixes up various trivial sparse warnings.  After that we
have 5 warnings left, out of one which is in the new scrube code
and looks serious.  I'll try to find some time to look into it.

