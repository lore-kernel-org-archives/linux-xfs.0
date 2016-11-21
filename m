Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57894 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753695AbcKUQjA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Nov 2016 11:39:00 -0500
Received: from 80-109-146-114.cable.dynamic.surfer.at ([80.109.146.114] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1c8rcS-0001Gx-0j
        for linux-xfs@vger.kernel.org; Mon, 21 Nov 2016 16:39:00 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: new helpers to clean up extent tree lookups V2
Date: Mon, 21 Nov 2016 17:38:42 +0100
Message-Id: <1479746336-10986-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Now that Eric send out xfs_iext_count before I could get to it I need
to get my other iext helpers out ASAP before running into another
rebase :)

This series adds two new helpers that make iterating the extent list
a lot cleaner.  They are the first step towards better abstracting out
access to the extent list and thus allowing us to experiment with
better data structures for it.  The next step is the manipulations
in xfs_bmap_{add,del}_extent*, which will be more work than these
helpers, but I have some of that in progress.

Changes since V1:
 - incorporate review feedback from Brian (various minor items)
