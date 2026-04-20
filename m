Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41CE5392C3C
	for <linux-xfs@vger.kernel.org>; Mon, 20 Apr 2026 10:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776679609; cv=none; b=CAI6D2eIOJIX+Ux+zRhKC7/g9TlRnGRtRbqeBni9ge0eP194AWkySlBiXuEa3hyHQTPp71TzSi/NyVydlojR2bl1s8040QiKaHAEr6Aoj2xePsLIWyHHbNWFElOTapG+YOVVEE5FT1t0ZUGRIUmyXQ5PMPojJidMVJ7QElhS9XA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776679609; c=relaxed/simple;
	bh=qJIM3jxOWQuyl4KxyZW5vyAnvUOthNi6voO6ikcpLqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NullQzuut4VIGszGTv8aV9Pl8lp6XKvBow6q1vu7vnYzUV+xjAzq8xG3fWUKEm7GCMYQkBboY0W0nWTF0tjn23oaL3OMJBf7ANw5jW5ldCFY6hIwVDCudSyXRmnUTDmREciet+v800HFtNrha7r0Ftv5XIvi5Kpqw0hW64jbQ5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eu1t7Ako; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=i6TIXHe7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eu1t7Ako";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="i6TIXHe7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776679607;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dEGLFj4ClIrjd7MZC91OS4EkTEnUoAhP7Kztkq+Ge68=;
	b=eu1t7AkopnTXjIn0lwEThdZ9J3bCL88d5z4OLhTs3I1m3BDJ2TibVkG844D8dITcXgqRDj
	8aPMaVDxzLw6Vx1RIllXAIPbIVKTuHNM2IdVcZu+xELdtczoqdQ/fquj1D+Zi7JI5hyKZh
	/EgprRmbyqZ1wbtOpU7CLAXH2l/v2ow=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-252-BWJCrDb6MHydFgHwr45Rnw-1; Mon, 20 Apr 2026 06:06:46 -0400
X-MC-Unique: BWJCrDb6MHydFgHwr45Rnw-1
X-Mimecast-MFC-AGG-ID: BWJCrDb6MHydFgHwr45Rnw_1776679606
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-8eb04352972so107618185a.2
        for <linux-xfs@vger.kernel.org>; Mon, 20 Apr 2026 03:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1776679605; x=1777284405; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dEGLFj4ClIrjd7MZC91OS4EkTEnUoAhP7Kztkq+Ge68=;
        b=i6TIXHe7qdX/nXBIJQoWThlr15RoKL0CdjCfrjHLSTu6DrqX8GBdV6oVNBuQJ0StwH
         sJzWX0GM2kf6jQoFt2n/TgDTQkt3pFgwHHzgLPWxXRwCAJTzWaf1U/U9zDipdAQEzRhq
         dIlvNhP3nj4XY71ciqdGMCfZD/cZ+3zLKURqQ28OsnPDwWRkLFPFmfvk9rcANMaShKR8
         VHUHcViNU4TjCwP4skzOgvSdhepN5v9xInksml+w+tgVk7h2pwW6tPi09JKO0ZdQBlgQ
         RNJTv/l5tp7IepduK31lnd5GW8oMg06AJxE/XAmccd1aKVbnPY4P92MasM+B38lDtkCN
         LAbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776679605; x=1777284405;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dEGLFj4ClIrjd7MZC91OS4EkTEnUoAhP7Kztkq+Ge68=;
        b=LwlTjRe8NB09zhxOySbAzEE1lXp/Vj4PO0jaxjGJh6FZyJE891GoCo2Znm/CNWKuxO
         TQJ2/lIdhldi5LcflkypKWWCC1HOZzrxxPwiLynqytzMMgfAzr3nh7QnVnWo7fWN318y
         OiDIfF9v2mn9TXWVCEtyy//09Fmn/F3Pl2W+8iPijGzlhNqo3KpoaQymgrrC+HMSYnvg
         nGgGzkyi6KQNVUKcVgyaCFyP4J/qSNNugujM68UYjaX6df4b49npk9KmCyYbnAzLjdhC
         DjTaS8yhNaYixIazybwIjgnvQ388NLapKsjSXDf67hcxd+3al+Cbn0tgu/QvD55M5A62
         34fQ==
X-Gm-Message-State: AOJu0Yxqo6gRfu8lLx009CwjhS1dNmJBwGNmlhAS51yqyHMZ1g4QfE83
	joDoTW1dDqQujTnj72wq7oE/n5zbqYVJbSXnwrlrDEwU6lwSdpgTv6MOyUK8uFlViA2aSVzoUHU
	YTKv6wobtFy9DMPbk1og9ihtm5ukdzLsNXAHkxF4Vbv5IRHOX+rrrmRO5ivpQU0BB9rb/0UOF/X
	ol5kgJqIN0xJkRFel5zqux8glfTbUoGHdMiHyMMio2fthe0A==
X-Gm-Gg: AeBDiesH+B/UprJzZNEHifn6QFEBBYK4jE9mPVdRyXSG7rUUpY4xKXucEODiC4oWBMr
	v7z4N2omKr6db/XjUgJyNnNgsXTjccb0P2F9Yd8nzIau56aJTmAnJodpqaldk0fwgLUx5A6coBc
	NNPvUyL4jKVL757tSs9m0G4hU75UHKWLAQ0biq0z/3PvH77SsYF0R8WnUGyCuIsD0LF4mNavg/F
	LXFgKcFiYHK9+pXsB8MrNTDVWcQbRjeV44RArF/dalXdtVI+KVHvbuAes93xB0cDWu0r2cpnOAu
	+OgY6TrfhyhIpx7qWQSX/TkI2FAEqFnwlDGuhenLIycCuAmIXESKE9L/Sbscfky2VYDkgPMOQsC
	O4BboWOX5AtWkloJsNYGzF8uthL6W1cqUEtz0tfpYI9Cf2A==
X-Received: by 2002:a05:620a:27c1:b0:8ea:aa10:7b3f with SMTP id af79cd13be357-8eaaa107d0amr556256985a.1.1776679605165;
        Mon, 20 Apr 2026 03:06:45 -0700 (PDT)
X-Received: by 2002:a05:620a:27c1:b0:8ea:aa10:7b3f with SMTP id af79cd13be357-8eaaa107d0amr556252385a.1.1776679604523;
        Mon, 20 Apr 2026 03:06:44 -0700 (PDT)
Received: from fedora43-upstream-dev ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8eb19632130sm247061485a.41.2026.04.20.03.06.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 03:06:44 -0700 (PDT)
From: Ravi Singh <ravising@redhat.com>
To: linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Cc: djwong@kernel.org,
	dchinner@redhat.com,
	esandeen@redhat.com,
	cem@kernel.org
Subject: [PATCH v2] xfs: flush delalloc blocks on ENOSPC in xfs_trans_alloc_icreate
Date: Mon, 20 Apr 2026 10:06:37 +0000
Message-ID: <20260420100637.3584-1-ravising@redhat.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <aeBv_xvDTmuzEhV1@infradead.org>
References: <aeBv_xvDTmuzEhV1@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xfs_trans_alloc_icreate() can fail with ENOSPC when delalloc
reservations have consumed most of the available block count
(fdblocks).  xfs_trans_alloc() already retries internally with
xfs_blockgc_flush_all(), but that only trims post-EOF speculative
preallocation and may not free enough space for the transaction
reservation.

Add a retry with xfs_flush_inodes() when xfs_trans_alloc() returns
ENOSPC.  This forces writeback of all dirty inodes via
sync_inodes_sb(), converting delalloc reservations to real
allocations and freeing the over-reserved portion back to fdblocks.

This fixes all callers of xfs_trans_alloc_icreate() and removes
the existing caller-level retry from xfs_create(), which is now
handled centrally.

Signed-off-by: Ravi Singh <ravising@redhat.com>
---

v2:
 - Moved xfs_flush_inodes() retry into xfs_trans_alloc_icreate()
   instead of xfs_symlink() (Christoph)
 - Removed caller-level retry from xfs_create()
 - All callers now covered: xfs_create, xfs_symlink,
   xfs_create_tmpfile, xcrep_tempfile_create

 fs/xfs/xfs_inode.c | 6 ------
 fs/xfs/xfs_trans.c | 9 +++++++++
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index beaa26ec62da..9978ac1422fc 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -699,12 +699,6 @@ xfs_create(
 	 */
 	error = xfs_trans_alloc_icreate(mp, tres, udqp, gdqp, pdqp, resblks,
 			&tp);
-	if (error == -ENOSPC) {
-		/* flush outstanding delalloc blocks and retry */
-		xfs_flush_inodes(mp);
-		error = xfs_trans_alloc_icreate(mp, tres, udqp, gdqp, pdqp,
-				resblks, &tp);
-	}
 	if (error)
 		goto out_parent;
 
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index bcc470f56e46..2796634b7d2b 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1186,6 +1186,9 @@ xfs_trans_reserve_more_inode(
 /*
  * Allocate an transaction in preparation for inode creation by reserving quota
  * against the given dquots.  Callers are not required to hold any inode locks.
+ * If the block reservation fails with ENOSPC, flush all delalloc blocks to
+ * reclaim space from speculative preallocation and retry.  This is similar to
+ * the quota retry but targets FS-wide ENOSPC.
  */
 int
 xfs_trans_alloc_icreate(
@@ -1199,10 +1202,16 @@ xfs_trans_alloc_icreate(
 {
 	struct xfs_trans	*tp;
 	bool			retried = false;
+	bool			flushed = false;
 	int			error;
 
 retry:
 	error = xfs_trans_alloc(mp, resv, dblocks, 0, 0, &tp);
+	if (error == -ENOSPC && !flushed) {
+		xfs_flush_inodes(mp);
+		flushed = true;
+		goto retry;
+	}
 	if (error)
 		return error;
 
-- 
2.53.0

