Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27465 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751018AbcI0FYR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Sep 2016 01:24:17 -0400
Date: Mon, 26 Sep 2016 22:23:44 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: XFS reflink and development tip git trees updated
Message-ID: <20160927052344.GD3059@birch.djwong.org>
References: <20160905053317.GA15302@birch.djwong.org>
 <20160919161100.GA19849@infradead.org>
 <20160920043942.GE10172@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160920043942.GE10172@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org, xfs@oss.sgi.com, amir73il@gmail.com

Ok, here's this week's for-4.9 branch:

https://github.com/djwong/linux/tree/for-dave-for-4.9-5
https://github.com/djwong/xfsprogs/tree/for-dave-for-4.9-5

The kernel tree includes Christoph's fixes for copy-on-write,
refactoring of a refcount btree function to use _btree_query_range (and
inclusion of the required diff_two_keys/init_high_key helpers), and
removal of the (totally broken) always_cow debug switch.  It also
contains a new error injection point to make reflink fail with ENOSPC.

The xfsprogs tree incorporates the libxfs changes in the kernel tree
but is largely the same as last week's for-4.9-2 branch.  The only
change in userspace programs is that xfs_io can trigger the
above-mentioned error injection point.

---

The WTF trees have been rebased to 4.8-rc8 and xfsprogs for-next:
https://github.com/djwong/linux/tree/djwong-wtf
https://github.com/djwong/xfsprogs/tree/djwong-wtf

These two trees contain all the changes noted above as well as in-kernel
scrubbing of directory and extended attribute data.  xfs_scrub has been
modified to take advantage of them, and can now fall back a little more
gracefully when kernel scrubbing is unavailable.

(Note that the WTF tree doesn't reflect the iomap rework that's in the
4.9 for-next tree; I'll rebase WTF against 4.9 after the merge window
closes.  Unfortunately that's the only way to pick up scrub or realtime
rmap support.)

--D
