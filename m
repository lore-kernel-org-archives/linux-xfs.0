Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 06 Nov 2008 08:05:02 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mA6G4n4U020233
	for <xfs@oss.sgi.com>; Thu, 6 Nov 2008 08:04:49 -0800
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8DA76590151
	for <xfs@oss.sgi.com>; Thu,  6 Nov 2008 08:04:53 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id i0w1o1tSErJTJwgj for <xfs@oss.sgi.com>; Thu, 06 Nov 2008 08:04:53 -0800 (PST)
Date: Thu, 6 Nov 2008 11:04:52 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: XFS status update for October 2008
Message-ID: <20081106160452.GA28042@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, linux-kernel@vger.kernel.org

Linux 2.6.27 released with all the bits covered in last month's report.  It
did however miss two important fixes for regressions that a few people hit.
2.6.27.3 or later are recommended for use with XFS.

In the meantime the generic btree implementation, the sync reorganization
and after a lot of merge pain the XFS and VFS inode unification hit the
development tree during the time allocated for the merge window.  No XFS
updates other than the two regression fixes also in 2.6.27.3 have made it
into mainline as of 2.6.28-rc3.

The only new feature on the list in October is support for the fiemap
interface that has been added to the VFS during the 2.6.28 merge window.
However there was lot of patch traffic consisting of fixes and respun
versions of previously known patches.  There still is a large backlog of
patches on the list that is not applied to the development tree yet.
