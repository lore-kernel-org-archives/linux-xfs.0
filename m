Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33068 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727332AbeKTAKF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Nov 2018 19:10:05 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/9] xfs: fix shared extent data corruption due to missing cow reservation
Date: Mon, 19 Nov 2018 14:46:11 +0100
Message-Id: <20181119134619.16812-2-hch@lst.de>
In-Reply-To: <20181119134619.16812-1-hch@lst.de>
References: <20181119134619.16812-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Brian Foster <bfoster@redhat.com>

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
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_reflink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index bd9135afe3f4..bfa489c8799f 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -296,6 +296,7 @@ xfs_reflink_reserve_cow(
 	if (error)
 		return error;
 
+	xfs_trim_extent(imap, got.br_startoff, got.br_blockcount);
 	trace_xfs_reflink_cow_alloc(ip, &got);
 	return 0;
 }
-- 
2.19.1
