Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:39352 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751237AbdH2Rsk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 13:48:40 -0400
Received: from clnet-p099-196.ikbnet.co.at ([83.175.99.196] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dmkcx-0007eb-CZ
        for linux-xfs@vger.kernel.org; Tue, 29 Aug 2017 17:48:39 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: a few extent lookup cleanups
Date: Tue, 29 Aug 2017 19:48:27 +0200
Message-Id: <20170829174835.2218-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

this series contains some relatively minor refactoring to hide
details of the extent list implementation.  With it the raw extent
records aren't exposed outside the actual implementation and the
low-level add/del extent routines.
