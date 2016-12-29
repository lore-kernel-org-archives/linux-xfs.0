Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52041 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751686AbcL2IYU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Dec 2016 03:24:20 -0500
Received: from 178.114.99.23.wireless.dyn.drei.com ([178.114.99.23] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1cMVzm-0004Ky-Mx
        for linux-xfs@vger.kernel.org; Thu, 29 Dec 2016 08:23:31 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: make log force warnings less annoying
Date: Thu, 29 Dec 2016 09:23:18 +0100
Message-Id: <1482999799-11776-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

I've recently had various issues root causing customer bug reports
due to xfs_log_force spamming the log with EIO warnings that are not
helpful at all.  This patch just removes them as they add no value.

I'd love to see this patch go into the next 4.10-rc and 4.9-stable
so that I can improve the quality of bug reports.

