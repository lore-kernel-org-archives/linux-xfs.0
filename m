Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF611156668
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 02:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711333493; cv=none; b=enErpvxCk9DH3nX3tXLug/M5ulTdY3sx5h2IMvD8VLqviC0uV+Lst9VyKgOBlT5LH3TviWbDtomiYzKQfAFSG9Nn6G9GaPQUP0UNAowMYMjmrNFZvj13YXS1rt5HeDguliqdXGeqSmYq6Y59f51xVC9Cc0dCkxvjJqy47VYt1fM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711333493; c=relaxed/simple;
	bh=s2I9JY9MNe0QPKdR8c6U1lWRb+300HwrOTpyWM3+p8A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bTEvS96TTDuDc7O52ONxaso4wqu7xV0sU5Jtus5gXDKgU3en8JwNmddopW3ljxPMH6nu4D+V36Ue1MhSlR8DUKmqkLImW6fGbcn+aREZBOEj/ZOqeWcRyaMdNCNn6wDLqJNdUTk28mfhPhckpEkkl9Mm7go1osyk+LpH1WaCOh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Xw4lePib; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Xw4lePib"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=zLdngUe6q01oYEWnzpWSFc/SAvVi06etsYFJEbZPeZg=; b=Xw4lePibFAgCgPSbca9mSKPGI0
	VdKeTI0ShmiQvZzA9URvRfcTrqniDsnb1Ypvr7tlhiNto3DP2f7m1WQtg17/phsZi3fOUyepMtJU3
	+hNkNCGZ0yUHqIjyUyPR6NsFHMgHUeSA1RGvgFJAh25TVfH19iZGb5OKkLHRGGQ/XEIZMDlunkxi2
	UtT/RDXDv6M2TlmFNQirMI/umflnBDhF73Iv+79eenW/tE0WBgspxVlKlX8Wcnj2tXyh+On623P9w
	KhrDHToCIHZfBzaxRxBavX1T7+6w66/eajZPEXG4Q+9ivpG/G4skqS0nT07EsUHlU+4DrpWq/Rklc
	J36wXRqQ==;
Received: from [210.13.83.2] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1roa14-0000000EeYv-3zM2;
	Mon, 25 Mar 2024 02:24:51 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 10/11] xfs: stop the steal (of data blocks for RT indirect blocks)
Date: Mon, 25 Mar 2024 10:24:10 +0800
Message-Id: <20240325022411.2045794-11-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240325022411.2045794-1-hch@lst.de>
References: <20240325022411.2045794-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

When xfs_bmap_del_extent_delay has to split an indirect block it tries
to steal blocks from the the part that gets unmapped to increase the
indirect block reservation that now needs to cover for two extents
instead of one.

This works perfectly fine on the data device, where the data and
indirect blocks come from the same pool.  It has no chance of working
when the inode sits on the RT device.  To support re-enabling delalloc
for inodes on the RT device, make this behavior conditional on not
beeing for rt extents.

Note that split of delalloc extents should only happen on writeback
failure, as for other kinds of hole punching we first write back all
data and thus convert the delalloc reservations covering the hole to
a real allocation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index dda25a21100836..16b0d76efd46ea 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4981,9 +4981,14 @@ xfs_bmap_del_extent_delay(
 		/*
 		 * Steal as many blocks as we can to try and satisfy the worst
 		 * case indlen for both new extents.
+		 *
+		 * However, we can't just steal reservations from the data
+		 * blocks if this is an RT inodes as the data and metadata
+		 * blocks come from different pools.  We'll have to live with
+		 * under-filled indirect reservation in this case.
 		 */
 		da_new = got_indlen + new_indlen;
-		if (da_new > da_old) {
+		if (da_new > da_old && !isrt) {
 			stolen = XFS_FILBLKS_MIN(da_new - da_old,
 						 new.br_blockcount);
 			da_old += stolen;
-- 
2.39.2

