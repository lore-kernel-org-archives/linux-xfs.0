Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:58488 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751580AbdJSG7t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2017 02:59:49 -0400
Received: from 212095007233.public.telering.at ([212.95.7.233] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1e54o0-00045u-Hy
        for linux-xfs@vger.kernel.org; Thu, 19 Oct 2017 06:59:49 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: more extent mapping cleanups
Date: Thu, 19 Oct 2017 08:59:27 +0200
Message-Id: <20171019065942.18813-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

This series contains another round of extent map related cleanups
to prepare for the new incore extent list.

Because it is based on a huge number of outstanding (and reviewed)
patches it might be a good idea to pull in the git tree for testing
or detailed review:

	git://git.infradead.org/users/hch/xfs.git xfs-bmbt-cleanup.2

Gitweb:

	http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xfs-bmbt-cleanup.2
