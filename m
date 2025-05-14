Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9211F4285
	for <linux-xfs@vger.kernel.org>; Wed, 14 May 2025 04:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747197896; cv=none; b=f3ldtV9bs+lVfgOt5B3PGRqlcOK9JrS0AcxTV3TRzMXi/7ypZL7JqVh8gV4mWQGPNPVRB2NtLWq2yrAEQ87AfKlhlaOCSkPOY4GlpBkhMlYBO4iPKq7xlgoMps3Fr7Zh8vcqLn/3I3Z4W7ghhAg11yl0QuAxgByKnJwj9oGTG88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747197896; c=relaxed/simple;
	bh=3otIe27QTk8qJPQkA/JyaSRTN4ZbNnhe8V1rSCaL+w4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bpgin8NRSG8BQhXKIVddN5mR8mgLOdQ4M+e731ytjXiOA/nMBhO1bcegNdQNmfPFd6mgAIqebgNZs2HqDwVLCPzxHmXfpUFk9//h+lu8C2UPkF6yM2Ax+Wx+JRc0sgq5usTecMaZN2PF+lr7uDbeDDg9sLP+YLClTeXnbFnNjOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Drkuuqvr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Drkuuqvr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=+bvh8pYzq9N8dO6lfkzhxZ0Y2FlTfXTgKZPNZUUUnFQ=; b=DrkuuqvrHI/1fDWBePQYQG3K49
	PjYHjeWtTJt1HpcviLbwYp8uhmkl17jO4YeZ5J0ZuxWeyPRBJfGXRwk0EekXhUCvRf3555EzmSCsd
	blTMolpz60fjeSfiQnQbDH3L9bAKSonbccwpU/InIfq/5XJ6GHwYxb0Qb2+QH0nYboSwvaPY7jKPT
	b9CXoRlqU0j7odST5vJhLok5yfRQm8h1CH92loCK+3+wRx7oTUKTq0FmZ8wMngCg/F8lMmEVKlz0F
	VSyHOyyXUwBvwEcqFh0cXXiY21BHXRIvQEHRMvjMxbeqswQR8Tb50KfpTYBBCCE+BpQiO6Th0Fram
	Q1Dc6rgA==;
Received: from 2a02-8389-2341-5b80-f6ef-2f59-bb46-6670.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:f6ef:2f59:bb46:6670] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uF3zB-0000000E1A7-3QCC;
	Wed, 14 May 2025 04:44:54 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: djwong@kernel.org,
	linux-xfs@vger.kernel.org,
	Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH v2] xfs: remove the EXPERIMENTAL warning for pNFS
Date: Wed, 14 May 2025 06:44:20 +0200
Message-ID: <20250514044450.1023153-1-hch@lst.de>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The pNFS layout support has been around for 10 years without major
issues, drop the EXPERIMENTAL warning.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---

Changes since v1:
 - rebased on top of v2 of xfs: remove some EXPERIMENTAL warnings
 - also remove the opstate

 fs/xfs/xfs_message.c | 4 ----
 fs/xfs/xfs_message.h | 1 -
 fs/xfs/xfs_mount.h   | 2 --
 fs/xfs/xfs_pnfs.c    | 2 --
 4 files changed, 9 deletions(-)

diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
index 54fc5ada519c..19aba2c3d525 100644
--- a/fs/xfs/xfs_message.c
+++ b/fs/xfs/xfs_message.c
@@ -141,10 +141,6 @@ xfs_warn_experimental(
 		const char		*name;
 		long			opstate;
 	} features[] = {
-		[XFS_EXPERIMENTAL_PNFS] = {
-			.opstate	= XFS_OPSTATE_WARNED_PNFS,
-			.name		= "pNFS",
-		},
 		[XFS_EXPERIMENTAL_SHRINK] = {
 			.opstate	= XFS_OPSTATE_WARNED_SHRINK,
 			.name		= "online shrink",
diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
index bce9942f394a..d68e72379f9d 100644
--- a/fs/xfs/xfs_message.h
+++ b/fs/xfs/xfs_message.h
@@ -91,7 +91,6 @@ void xfs_buf_alert_ratelimited(struct xfs_buf *bp, const char *rlmsg,
 			       const char *fmt, ...);
 
 enum xfs_experimental_feat {
-	XFS_EXPERIMENTAL_PNFS,
 	XFS_EXPERIMENTAL_SHRINK,
 	XFS_EXPERIMENTAL_LARP,
 	XFS_EXPERIMENTAL_LBS,
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 466303630ef9..1bf71d7a4906 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -543,8 +543,6 @@ __XFS_HAS_FEAT(nouuid, NOUUID)
  */
 #define XFS_OPSTATE_BLOCKGC_ENABLED	6
 
-/* Kernel has logged a warning about pNFS being used on this fs. */
-#define XFS_OPSTATE_WARNED_PNFS		7
 /* Kernel has logged a warning about shrink being used on this fs. */
 #define XFS_OPSTATE_WARNED_SHRINK	9
 /* Kernel has logged a warning about logged xattr updates being used. */
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index 6f4479deac6d..afe7497012d4 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -58,8 +58,6 @@ xfs_fs_get_uuid(
 {
 	struct xfs_mount	*mp = XFS_M(sb);
 
-	xfs_warn_experimental(mp, XFS_EXPERIMENTAL_PNFS);
-
 	if (*len < sizeof(uuid_t))
 		return -EINVAL;
 
-- 
2.47.2

