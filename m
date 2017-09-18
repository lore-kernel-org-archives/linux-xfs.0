Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:46332 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752156AbdIRP0a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Sep 2017 11:26:30 -0400
Received: from [107.17.164.65] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dtxwM-0006bf-KH
        for linux-xfs@vger.kernel.org; Mon, 18 Sep 2017 15:26:30 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: getbmap refactor V2
Date: Mon, 18 Sep 2017 08:26:28 -0700
Message-Id: <20170918152630.24592-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

this series refactors the getbmap support to not sit on top of xfs_bmapi_read,
and to remove the callbacks for formatting the userspace buffers.

Changes since V1:
 - fix setting of BMV_OF_LAST
