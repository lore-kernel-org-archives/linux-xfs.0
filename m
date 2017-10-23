Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:36100 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751083AbdJWGaV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Oct 2017 02:30:21 -0400
Received: from [46.125.250.114] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1e6WFh-0002iN-1P
        for linux-xfs@vger.kernel.org; Mon, 23 Oct 2017 06:30:21 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: even more extent mapping cleanups
Date: Mon, 23 Oct 2017 08:30:13 +0200
Message-Id: <20171023063017.11520-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

This series contains yey another round of extent map related cleanups
to prepare for the new incore extent list.

The first one adds the additional asserts requested by Darrick, and
the rest are cleanups that bubbled to the front of my local queue
during a rebase over the weekend.

Because it is based on a huge number of outstanding (and reviewed)
patches it might be a good idea to pull in the git tree for testing
or detailed review:

	git://git.infradead.org/users/hch/xfs.git xfs-bmbt-cleanup.3

Gitweb:

	http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xfs-bmbt-cleanup.3
