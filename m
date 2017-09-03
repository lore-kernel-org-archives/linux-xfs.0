Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:45073 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751196AbdICHaA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Sep 2017 03:30:00 -0400
Received: from [91.114.64.3] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1doPM0-0005iO-4A
        for linux-xfs@vger.kernel.org; Sun, 03 Sep 2017 07:30:00 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: refactor extent manipulation
Date: Sun,  3 Sep 2017 09:29:39 +0200
Message-Id: <20170903072956.3175-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

this series refactor the extent manipulation routines so that they are
isolated from the nitty gritty details of the extent list implementation.
It is the first step towards a more scalable extent list data structure.
