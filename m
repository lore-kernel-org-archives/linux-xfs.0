Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 01 Oct 2008 13:38:38 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m91KcYEI007460
	for <xfs@oss.sgi.com>; Wed, 1 Oct 2008 13:38:35 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9D569134E545
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2008 13:40:10 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id G3pYvTgjHpzbC9TN for <xfs@oss.sgi.com>; Wed, 01 Oct 2008 13:40:10 -0700 (PDT)
Date: Wed, 1 Oct 2008 22:40:09 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: XFS status update for September 2008
Message-ID: <20081001204009.GA4259@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, linux-kernel@vger.kernel.org


With Linux 2.6.27 still not released but only making slow progress from
2.6.27-rc5 to 2.6.27-rc8 XFS changes in mainline have been minimal in
September with only about half a dozen bug fixes patches.

In the meantime the generic btree patch set has been committed to the
development tree, but not many other updates yet.  On the user space side
xfsprogs 2.10.1 has been released on September 5th with a number of
important bug fixes.  Following the release of xfsprogs 2.10.1 open season
for development of the user space code has started.  The first full update
of the shared kernel / user space code in libxfs since 2005 has been
committed.  In addition to that the number of headers installed for the
regular devel package has been reduced to the required minimum and support
for checking the source code for endianess errors using sparse has been
added.

The patch sets to unify the XFS and Linux inode structures, and rewrite
various bits of the sync code have seen various iterations on the XFS
list, but haven't been committed yet.   A first set of patches implementing
CRCs for various metadata structures has been posted to the list.
