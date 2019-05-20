Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:34986 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387964AbfETQOm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 12:14:42 -0400
Received: from 089144206147.atnat0015.highway.bob.at ([89.144.206.147] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hSkvw-0005G8-DZ
        for linux-xfs@vger.kernel.org; Mon, 20 May 2019 16:14:40 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: use bios directly in the log code
Date: Mon, 20 May 2019 18:13:30 +0200
Message-Id: <20190520161347.3044-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

this series switches the log writing and log recovery code to use bios
directly, and remove various special cases from the buffer cache code.
Note that I have developed it on top of the previous series of log item
related cleanups, so if you don't have that applied there is a small
conflict.  To make life easier I have pushed out a git branche here:

    git://git.infradead.org/users/hch/xfs.git xfs-log-bio

Gitweb:

    http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xfs-log-bio
