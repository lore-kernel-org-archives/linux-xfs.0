Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43C5604AC
	for <linux-xfs@vger.kernel.org>; Wed, 14 Feb 2024 16:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707929458; cv=none; b=j3wrhVQi7FF04s/oLIZtY/nuyCXrssbF/1XBXZ5BLTDUNC5BurVjw8hHLI+rVJqGcQ6NJRdP7vOkgpjfhhmKlOSNRCBN3hFkI/20GIyhJL356Rdl3OusSr6v7Ykg/n5UFS0RohKWPBn06SGyLZzUFPVXLBmRZLWVv2nU5TECLm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707929458; c=relaxed/simple;
	bh=P19pZ6alDv9I652YcyaCdM/mvFIEEvOgXljGSYogQ3w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=LqDDMKQo1uShym5Mh/nfmkg1GTdWsZuaLm8zSZ4Y6Z1CjoUjtkeHP2Sre/4XmP+nFf+7B2e234yK/JmpbW0oxc2M/M47//p+PrQFYa3rYGpCip+Rw5Fr7cb1i2bpbCTqlM6K4aepNSyRovFmhrXbBbQIyMuZnAuZEiM/vxfU6OE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cpzTy2B4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cpzTy2B4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707929455;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=N9gyAXFl2/xBNA9wne5c8TTViljFSIBIulJ5TdKjSuc=;
	b=cpzTy2B484hFIwoC3nCe/TA2GRZKGHVoh1VgklKRFA+G17SqSOE1gCpCM5abd4IJqsqqMV
	2daRRZTuo9QIljWGsd2qK4sLzZEB27qqS6zvDvPEfhW0+Ux7UhrP79QuBR9wct6XD0f0aS
	I6Ok/EBWdP0fKXiLpoEOc9G8KgZGfmo=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-193-rmgKyyWcOvmePpvDS50oyg-1; Wed,
 14 Feb 2024 11:50:53 -0500
X-MC-Unique: rmgKyyWcOvmePpvDS50oyg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 43B6728EC10B;
	Wed, 14 Feb 2024 16:50:53 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.16.56])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 215661C060B1;
	Wed, 14 Feb 2024 16:50:53 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org
Subject: [PATCH] xfs: skip background cowblock trims on inodes open for write
Date: Wed, 14 Feb 2024 11:52:31 -0500
Message-ID: <20240214165231.84925-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

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
evicted from cache.

Suggested-by: Darrick Wong <djwong@kernel.org>
Signed-off-by: Brian Foster <bfoster@redhat.com>
---

This fell out of some of the discussion on a prospective freeze time
blockgc scan. I ran this through the same random write test described in
that thread and it prevented all cowblocks trimming until the file is
released.

Brian

[1] https://lore.kernel.org/linux-xfs/ZcutUN5B2ZCuJfXr@bfoster/

 fs/xfs/xfs_icache.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index dba514a2c84d..d7c54e45043a 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1240,8 +1240,13 @@ xfs_inode_clear_eofblocks_tag(
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
@@ -1262,6 +1267,15 @@ xfs_prep_free_cowblocks(
 	    atomic_read(&VFS_I(ip)->i_dio_count))
 		return false;
 
+	/*
+	 * A full cowblocks trim of an inode can have a significant effect on
+	 * fragmentation even when a reasonable COW extent size hint is set.
+	 * Skip cowblocks inodes currently open for write on opportunistic
+	 * blockgc scans.
+	 */
+	if (!sync && inode_is_open_for_write(VFS_I(ip)))
+		return false;
+
 	return true;
 }
 
@@ -1291,7 +1305,7 @@ xfs_inode_free_cowblocks(
 	if (!xfs_iflags_test(ip, XFS_ICOWBLOCKS))
 		return 0;
 
-	if (!xfs_prep_free_cowblocks(ip))
+	if (!xfs_prep_free_cowblocks(ip, icw))
 		return 0;
 
 	if (!xfs_icwalk_match(ip, icw))
@@ -1320,7 +1334,7 @@ xfs_inode_free_cowblocks(
 	 * Check again, nobody else should be able to dirty blocks or change
 	 * the reflink iflag now that we have the first two locks held.
 	 */
-	if (xfs_prep_free_cowblocks(ip))
+	if (xfs_prep_free_cowblocks(ip, icw))
 		ret = xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF, false);
 	return ret;
 }
-- 
2.42.0

