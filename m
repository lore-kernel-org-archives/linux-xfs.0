Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48259 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753628AbcKNRMz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Nov 2016 12:12:55 -0500
Received: from [83.175.99.196] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1c6KoQ-000527-5W
        for linux-xfs@vger.kernel.org; Mon, 14 Nov 2016 17:12:54 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: new helpers to clean up extent tree lookups
Date: Mon, 14 Nov 2016 18:12:31 +0100
Message-Id: <1479143565-30615-1-git-send-email-hch@lst.de>
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
