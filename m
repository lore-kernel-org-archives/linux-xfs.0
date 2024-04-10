Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB55D160785
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 14:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712758085; cv=none; b=a+WT94onmOtzBsiWGTKeCg7fg9cJJj4k58KM/S821hg5JBLjRHm6gh6ITICyu/1Gw0ZMjvuoU3JrbRlK8mTUzhF2j0bW4dpotzqjsjYb/snKbCZfvfS40MZue21TU56fa0VUWUrflBq+i1Nk2kOg/Zty5CmA0LGTB+dtaWy10zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712758085; c=relaxed/simple;
	bh=ri5AZA4mbK3RIJnux+Xf8d/Y9xH374dYBYnYZywZ0dE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t4nmeZCqsJ+XncfmWHGsJ8vhSMOuDi6KJyIdYXk3B+3vCaw5qKt/Jke5lyacDH7UdosguXA1auGP01YECkaXgOTbvqQaUjkIGecUwPc5NWqYjm3cIPlwe0WYWoS9UXYfSSWF+YvRgtvaZl94AMVv5dfrVEDUs8PSyL0A4pKETbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YRiqbFKz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YRiqbFKz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712758082;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mu5jpb4jGfIz7UjQi3xXez8XnkOyJKaDfm8FXlXtXds=;
	b=YRiqbFKzSm4QSE+Np0qXHxBdfYABH/65Eq+ZmBuCHCrVUE0i7ssyEvjz5Aovru1QjIDavq
	c4VZ4E2OLEhTMc/Hx/52nUpDCLP4goaknOnsBdEE9OMIlUEExGLdEqAqtuEO2Hzt5GN2YJ
	WQ0a3mQbgXqZJhUMvLSZFjArjsUVlYo=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-547-PiWRkjjbPPmh-1ttc0oBHQ-1; Wed,
 10 Apr 2024 10:07:59 -0400
X-MC-Unique: PiWRkjjbPPmh-1ttc0oBHQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 96E1A385A185;
	Wed, 10 Apr 2024 14:07:58 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.16.57])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6ACC81C060D1;
	Wed, 10 Apr 2024 14:07:58 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-bcachefs@vger.kernel.org,
	linux-xfs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH RFC 3/3] xfs: add nodataio mount option to skip all data I/O
Date: Wed, 10 Apr 2024 10:09:56 -0400
Message-ID: <20240410140956.1186563-4-bfoster@redhat.com>
In-Reply-To: <20240410140956.1186563-1-bfoster@redhat.com>
References: <20240410140956.1186563-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

When mounted with nodataio, add the NOSUBMIT iomap flag to all data
mappings passed into the iomap layer. This causes iomap to skip all
data I/O submission and thus facilitates metadata only performance
testing.

For experimental use only. Only tested insofar as fsstress runs for
a few minutes without blowing up.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_iomap.c | 3 +++
 fs/xfs/xfs_mount.h | 2 ++
 fs/xfs/xfs_super.c | 6 +++++-
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 4087af7f3c9f..9b71a649e106 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -101,6 +101,9 @@ xfs_bmbt_to_iomap(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_buftarg	*target = xfs_inode_buftarg(ip);
 
+	if (xfs_has_nodataio(mp))
+		iomap_flags |= IOMAP_F_NOSUBMIT;
+
 	if (unlikely(!xfs_valid_startblock(ip, imap->br_startblock))) {
 		xfs_bmap_mark_sick(ip, XFS_DATA_FORK);
 		return xfs_alert_fsblock_zero(ip, imap);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index e880aa48de68..fd8a5b46d449 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -294,6 +294,7 @@ typedef struct xfs_mount {
 #define XFS_FEAT_NREXT64	(1ULL << 26)	/* large extent counters */
 
 /* Mount features */
+#define XFS_FEAT_NODATAIO	(1ULL << 47)	/* skip all data I/O */
 #define XFS_FEAT_NOATTR2	(1ULL << 48)	/* disable attr2 creation */
 #define XFS_FEAT_NOALIGN	(1ULL << 49)	/* ignore alignment */
 #define XFS_FEAT_ALLOCSIZE	(1ULL << 50)	/* user specified allocation size */
@@ -363,6 +364,7 @@ __XFS_HAS_FEAT(large_extent_counts, NREXT64)
  * bit inodes and read-only state, are kept as operational state rather than
  * features.
  */
+__XFS_HAS_FEAT(nodataio, NODATAIO)
 __XFS_HAS_FEAT(noattr2, NOATTR2)
 __XFS_HAS_FEAT(noalign, NOALIGN)
 __XFS_HAS_FEAT(allocsize, ALLOCSIZE)
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index bce020374c5e..1fb24b5ba684 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -103,7 +103,7 @@ enum {
 	Opt_filestreams, Opt_quota, Opt_noquota, Opt_usrquota, Opt_grpquota,
 	Opt_prjquota, Opt_uquota, Opt_gquota, Opt_pquota,
 	Opt_uqnoenforce, Opt_gqnoenforce, Opt_pqnoenforce, Opt_qnoenforce,
-	Opt_discard, Opt_nodiscard, Opt_dax, Opt_dax_enum,
+	Opt_discard, Opt_nodiscard, Opt_dax, Opt_dax_enum, Opt_nodataio,
 };
 
 static const struct fs_parameter_spec xfs_fs_parameters[] = {
@@ -148,6 +148,7 @@ static const struct fs_parameter_spec xfs_fs_parameters[] = {
 	fsparam_flag("nodiscard",	Opt_nodiscard),
 	fsparam_flag("dax",		Opt_dax),
 	fsparam_enum("dax",		Opt_dax_enum, dax_param_enums),
+	fsparam_flag("nodataio",	Opt_nodataio),
 	{}
 };
 
@@ -1385,6 +1386,9 @@ xfs_fs_parse_param(
 		xfs_fs_warn_deprecated(fc, param, XFS_FEAT_NOATTR2, true);
 		parsing_mp->m_features |= XFS_FEAT_NOATTR2;
 		return 0;
+	case Opt_nodataio:
+		parsing_mp->m_features |= XFS_FEAT_NODATAIO;
+		return 0;
 	default:
 		xfs_warn(parsing_mp, "unknown mount option [%s].", param->key);
 		return -EINVAL;
-- 
2.44.0

