Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51372 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938908AbcLWPzh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Dec 2016 10:55:37 -0500
Received: from hch by bombadil.infradead.org with local (Exim 4.85_2 #1 (Red Hat Linux))
        id 1cKSC0-0007rI-N0
        for linux-xfs@vger.kernel.org; Fri, 23 Dec 2016 15:55:36 +0000
Date: Fri, 23 Dec 2016 07:55:36 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: RFC: 4.9-stable backports for xfs
Message-ID: <20161223155536.GA24297@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Given that 4.9 is a long-term stable release, and the first release
with reflink support I'm going to plan backporting fixes for 4.9-stable.
At least for the 4.10 timeframe I plan to backport relatively
agressively, that is everything that could be considered a fix, as well
as infrastructure required for the fixes to apply as-is.  Further down
the road the criterial will become stricter and stricter.

Here is my current tree based on the patches in the 4.10 merge window
so far:

	http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xfs-stable-4.9

It's been doing fine with xfstests so far, and I plan to send it to Greg
next week unless I hear negative feedback.
