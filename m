Return-Path: linux-xfs-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:43310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727048AbfAaSJd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 Jan 2019 13:09:33 -0500
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 05/10] xfs: fix shared extent data corruption due to missing cow reservation
Date: Thu, 31 Jan 2019 10:09:14 -0800
Message-Id: <20190131180919.2500-6-mcgrof@kernel.org>
In-Reply-To: <20190131180919.2500-1-mcgrof@kernel.org>
References: <20190131180919.2500-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
To: linux-xfs@vger.kernel.org, gregkh@linuxfoundation.org, Alexander.Levin@microsoft.com
Cc: amir73il@gmail.com, hch@infradead.org, Brian Foster <bfoster@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Luis Chamberlain <mcgrof@kernel.org>

From: Brian Foster <bfoster@redhat.com>

Page writeback indirectly handles shared extents via the existence
of overlapping COW fork blocks. If COW fork blocks exist, writeback
always performs the associated copy-on-write regardless if the
underlying blocks are actually shared. If the blocks are shared,
then overlapping COW fork blocks must always exist.

fstests shared/010 reproduces a case where a buffered write occurs
over a shared block without performing the requisite COW fork
reservation.  This ultimately causes writeback to the shared extent
and data corruption that is detected across md5 checks of the
filesystem across a mount cycle.

The problem occurs when a buffered write lands over a shared extent
that crosses an extent size hint boundary and that also happens to
have a partial COW reservation that doesn't cover the start and end
blocks of the data fork extent.

For example, a buffered write occurs across the file offset (in FSB
units) range of [29, 57]. A shared extent exists at blocks [29, 35]
and COW reservation already exists at blocks [32, 34]. After
accommodating a COW extent size hint of 32 blocks and the existing
reservation at offset 32, xfs_reflink_reserve_cow() allocates 32
blocks of reservation at offset 0 and returns with COW reservation
across the range of [0, 34]. The associated data fork extent is
still [29, 35], however, which isn't fully covered by the COW
reservation.

This leads to a buffered write at file offset 35 over a shared
extent without associated COW reservation. Writeback eventually
kicks in, performs an overwrite of the underlying shared block and
causes the associated data corruption.

Update xfs_reflink_reserve_cow() to accommodate the fact that a
delalloc allocation request may not fully cover the extent in the
data fork. Trim the data fork extent appropriately, just as is done
for shared extent boundaries and/or existing COW reservations that
happen to overlap the start of the data fork extent. This prevents
shared/010 failures due to data corruption on reflink enabled
filesystems.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 fs/xfs/xfs_reflink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 42ea7bab9144..7088f44c0c59 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -302,6 +302,7 @@ xfs_reflink_reserve_cow(
 	if (error)
 		return error;
 
+	xfs_trim_extent(imap, got.br_startoff, got.br_blockcount);
 	trace_xfs_reflink_cow_alloc(ip, &got);
 	return 0;
 }
-- 
2.18.0
