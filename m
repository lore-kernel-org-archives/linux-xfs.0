Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3C21C768C
	for <linux-xfs@vger.kernel.org>; Tue,  3 Sep 2024 12:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725367575; cv=none; b=s9NhO+wWRDcEiwzOzRNDT/mQLSxs9I5lH7Bq5hxS3FnSBi7oCR8jMoDJ8YSwQh0Bielwy7ssdwQ59MtwaqbYlAWESEXGyfjL7L0EQyqHCv/u0mopfS9lvefmR19R+kd9XXiK/A6J2QPtO/630LnJ/b11tHLjp0KIKQqPCV9mekk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725367575; c=relaxed/simple;
	bh=64qcQixzSB1Znefv0PPuJQ4gIb79gOpJPbBBVfRI12Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Em5cgF4xdxNI0Q2EfMppaWcu2jF8RAhebKhNiC7faOakJD1Y4dP6n9Fs0BJUfE1el35JbUpdgLK6Jm58VnIROLKoWM9Qs0fQ9AKik3i+eg/BGcIZaPzhXDXxsTP3em5zycn0LOqCmZ0pHZe1svqZjs8UYOqnUZR/z+IdA+ADwTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V0ads+mJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V0ads+mJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725367573;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=9Ils5CYVA3v1cZjwb1+0hMgYDvxMeZ3OsdSeWPbFJE4=;
	b=V0ads+mJAWZrckhF/9GulV70y0T1pwBlqtEgoG/VAaK4FvGVtxMMt439bK4Xdu5zlqBP7m
	KK7G6jNYKsCg5yBXsezbLGM6WpeU6/yexKZOtYeMis9usrVARs5tc75kTCNc2KA77TVQ3P
	oTGe5d2zFbMX2+yjcM3t9Ux16UhaLGc=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-311-zXaEtTZaP4S7SCFhb4hL9Q-1; Tue,
 03 Sep 2024 08:46:11 -0400
X-MC-Unique: zXaEtTZaP4S7SCFhb4hL9Q-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 659541954B2D;
	Tue,  3 Sep 2024 12:46:10 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.16.69])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BC1A33003B5E;
	Tue,  3 Sep 2024 12:46:09 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: Darrick Wong <djwong@kernel.org>
Subject: [PATCH v2] xfs: skip background cowblock trims on inodes open for write
Date: Tue,  3 Sep 2024 08:47:13 -0400
Message-ID: <20240903124713.23289-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

The background blockgc scanner runs on a 5m interval by default and
trims preallocation (post-eof and cow fork) from inodes that are
otherwise idle. Idle effectively means that iolock can be acquired
without blocking and that the inode has no dirty pagecache or I/O in
flight.

This simple mechanism and heuristic has worked fairly well for
post-eof speculative preallocations. Support for reflink and COW
fork preallocations came sometime later and plugged into the same
mechanism, with similar heuristics. Some recent testing has shown
that COW fork preallocation may be notably more sensitive to blockgc
processing than post-eof preallocation, however.

For example, consider an 8GB reflinked file with a COW extent size
hint of 1MB. A worst case fully randomized overwrite of this file
results in ~8k extents of an average size of ~1MB. If the same
workload is interrupted a couple times for blockgc processing
(assuming the file goes idle), the resulting extent count explodes
to over 100k extents with an average size <100kB. This is
significantly worse than ideal and essentially defeats the COW
extent size hint mechanism.

While this particular test is instrumented, it reflects a fairly
reasonable pattern in practice where random I/Os might spread out
over a large period of time with varying periods of (in)activity.
For example, consider a cloned disk image file for a VM or container
with long uptime and variable and bursty usage. A background blockgc
scan that races and processes the image file when it happens to be
clean and idle can have a significant effect on the future
fragmentation level of the file, even when still in use.

To help combat this, update the heuristic to skip cowblocks inodes
that are currently opened for write access during non-sync blockgc
scans. This allows COW fork preallocations to persist for as long as
possible unless otherwise needed for functional purposes (i.e. a
sync scan), the file is idle and closed, or the inode is being
evicted from cache. While here, update the comments to help
distinguish performance oriented heuristics from the logic that
exists to maintain functional correctness.

Suggested-by: Darrick Wong <djwong@kernel.org>
Signed-off-by: Brian Foster <bfoster@redhat.com>
---

v2:
- Reorder logic and update comments in xfs_prep_free_cowblocks().
v1: https://lore.kernel.org/linux-xfs/20240214165231.84925-1-bfoster@redhat.com/

 fs/xfs/xfs_icache.c | 31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index cf629302d48e..900a6277d931 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1241,14 +1241,17 @@ xfs_inode_clear_eofblocks_tag(
 }
 
 /*
- * Set ourselves up to free CoW blocks from this file.  If it's already clean
- * then we can bail out quickly, but otherwise we must back off if the file
- * is undergoing some kind of write.
+ * Prepare to free COW fork blocks from an inode.
  */
 static bool
 xfs_prep_free_cowblocks(
-	struct xfs_inode	*ip)
+	struct xfs_inode	*ip,
+	struct xfs_icwalk	*icw)
 {
+	bool			sync;
+
+	sync = icw && (icw->icw_flags & XFS_ICWALK_FLAG_SYNC);
+
 	/*
 	 * Just clear the tag if we have an empty cow fork or none at all. It's
 	 * possible the inode was fully unshared since it was originally tagged.
@@ -1260,9 +1263,21 @@ xfs_prep_free_cowblocks(
 	}
 
 	/*
-	 * If the mapping is dirty or under writeback we cannot touch the
-	 * CoW fork.  Leave it alone if we're in the midst of a directio.
+	 * A cowblocks trim of an inode can have a significant effect on
+	 * fragmentation even when a reasonable COW extent size hint is set.
+	 * Therefore, we prefer to not process cowblocks unless they are clean
+	 * and idle. We can never process a cowblocks inode that is dirty or has
+	 * in-flight I/O under any circumstances, because outstanding writeback
+	 * or dio expects targeted COW fork blocks exist through write
+	 * completion where they can be remapped into the data fork.
+	 *
+	 * Therefore, the heuristic used here is to never process inodes
+	 * currently opened for write from background (i.e. non-sync) scans. For
+	 * sync scans, use the pagecache/dio state of the inode to ensure we
+	 * never free COW fork blocks out from under pending I/O.
 	 */
+	if (!sync && inode_is_open_for_write(VFS_I(ip)))
+		return false;
 	if ((VFS_I(ip)->i_state & I_DIRTY_PAGES) ||
 	    mapping_tagged(VFS_I(ip)->i_mapping, PAGECACHE_TAG_DIRTY) ||
 	    mapping_tagged(VFS_I(ip)->i_mapping, PAGECACHE_TAG_WRITEBACK) ||
@@ -1298,7 +1313,7 @@ xfs_inode_free_cowblocks(
 	if (!xfs_iflags_test(ip, XFS_ICOWBLOCKS))
 		return 0;
 
-	if (!xfs_prep_free_cowblocks(ip))
+	if (!xfs_prep_free_cowblocks(ip, icw))
 		return 0;
 
 	if (!xfs_icwalk_match(ip, icw))
@@ -1327,7 +1342,7 @@ xfs_inode_free_cowblocks(
 	 * Check again, nobody else should be able to dirty blocks or change
 	 * the reflink iflag now that we have the first two locks held.
 	 */
-	if (xfs_prep_free_cowblocks(ip))
+	if (xfs_prep_free_cowblocks(ip, icw))
 		ret = xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF, false);
 	return ret;
 }
-- 
2.45.0

