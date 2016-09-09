Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51167 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750796AbcIIFYu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Sep 2016 01:24:50 -0400
Date: Thu, 8 Sep 2016 22:24:13 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: XFS reflink and getfsmap/scrub development git trees updated again
Message-ID: <20160909052413.GD9314@birch.djwong.org>
References: <20160905053317.GA15302@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160905053317.GA15302@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, Brian Foster <bfoster@redhat.com>, Theodore Ts'o <tytso@mit.edu>
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com, linux-ext4 <linux-ext4@vger.kernel.org>

Hi everyone,

I've just rebased the reflink patches against kernel 4.8-rc5 and the xfsprogs
dev branch:

https://github.com/djwong/linux/tree/for-dave-for-4.9-2
https://github.com/djwong/xfsprogs/tree/for-dave-for-4.9-2

These branches should contain /only/ the patches needed to get reflink working:
no fsmap ioctl, no online scrub, and no realtime rmapbt.  I'm publishing these
branches in the hopes of getting wider testing prior to the merge window.  I
haven't heard any complaints for several weeks now.  The only changes since
4.9-1 are to take care of all the comments that Christoph has sent up to
this point.

-----------

For the latest development branch, check out the djwong-wtf branches on github:
https://github.com/djwong/linux/tree/djwong-wtf
https://github.com/djwong/xfsprogs/tree/djwong-wtf

This contains all the latest reflink patches, the reworked GETFSMAP ioctl,
and the latest online scrubbing code.  The scraggly deadlock avoidance fixes
I mentioned in the last posting are now integrated properly into the patch
series.  Also, btree left/right sibling pointer checks have been implemented.

(Adding Ted and the ext4 list because Ted expressed interest in GETFSMAP.)

--D
