Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634A723BD03
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 20:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789419165; cv=none; b=FmtomrtHGlozODw/9NANe7d/RWixx0lyV9w3uXnGFJ6XtbSZEO7R63IVD2DxFZgVbBJftfiKDtUrcePqykuPGC5H40U0XgnuaqEFZ4NFtp2Dhc41a46EEqD5LccG8z+4AauTloGTeYPoNpusXjyJ61NsxP/Gl8AcQn8lHHz+Zgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789419165; c=relaxed/simple;
	bh=mW0M7rcKa0oK0EMO4yxO1Zru1I5sk7H0VYyfHIia10w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o3Jc6SgcKi7ZCZFqF5DuE6KbbtGgR8wF4ta4fgjZVAG44+eRYH8Tn72gafUihdD5Nb1uOx7eugHGCQh0sAwPO0hqddTk9WEUG3gnMCOeB9r2q74AmW8w9xQQSui0CPFoB2hqTe1XNWHby24rGEvykBkaLjvO1F3cZjHFaJyoDIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BQPgBYG5; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=XlOYrTP0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BQPgBYG5";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="XlOYrTP0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789419163;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TCosvyquo7rD7yt+jeD+OlEreAVvh8VWC1XYC5Bbi/Y=;
	b=BQPgBYG5/64wVV/yRza3cCy7n/jLXhRSm9FE6WB3wg1NENDQKDBNS6/wjAUSHgz71ymqln
	tRIsad9iR/THLaJ3GuYLOEjMS66X2m0otYGh7XEZTqMHWehHrYyj9LKEYMzTuDinJ84ty0
	nxJzcHWxeWnGh8e3lQ+mcv/BtC4I58I=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-153-EX6jp4idPPOnc1sy1VErXQ-1; Mon, 14 Sep 2026 16:52:42 -0400
X-MC-Unique: EX6jp4idPPOnc1sy1VErXQ-1
X-Mimecast-MFC-AGG-ID: EX6jp4idPPOnc1sy1VErXQ_1789419162
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-93a0c7126e7so369809885a.2
        for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 13:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789419162; x=1790023962; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TCosvyquo7rD7yt+jeD+OlEreAVvh8VWC1XYC5Bbi/Y=;
        b=XlOYrTP0wFNocBNgu/GRDTSdqsSsKGNSjGqmnH2zGtWhjimUD3IUqe67QaGhSyLU0w
         4Mv6zIFUUNlon59zpHhDJi7hIBLy1le66pOE8GJ8FY2FGh9xc7h0+DReiPBIFEyaiUxJ
         Az3qott6WRJoxoqRC5C2Uxe2T3lAhiRBacZWf6141McDR0qk2W8Rcs5dtaE5bGKnSBvF
         Yxw9wA36vCs4BFLblHZORrNRWOjHXrkYT+zAEerOmBqzjFK++KCH3HuImNjGSx3yVGJ9
         WJcf7aykBEXhUQ5kGtgknQLNOj+RzpN++3ptDxpk3ZnvO8fRvVK36oIs6gXuLAhQIgQc
         NMmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789419162; x=1790023962;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TCosvyquo7rD7yt+jeD+OlEreAVvh8VWC1XYC5Bbi/Y=;
        b=EYIxuqw1cSceUnDRLFmXQZXRXgHlo7QGiFi3801sqoaG/b2EWOSanGwd+SbiCHtGol
         8JcWesWRn3FCbfxnQK99Z+nVkiG8+5BqExOxyxkn3YcPbSR9iAPNjbrJmAWiIs2p0bsc
         /+RG1AqoSMaqVWOSwA/h8U2MjXmSR/oH4LahqB0CEYFj+qjXbB0y2naKnJuRAIwYoC9/
         jtZ6IGnaWecP7j8DkKs3VMOVNNynyZr92NsOYB8nDI2ddzqkDa6qYyNmW/vfEchxacy2
         /aPM42RawB3ymyrM5dAHhONpN6YtUbvvLaTnTwI1/FGo1xxWNw1BToY0YlW4B7/eBgDY
         kQwg==
X-Gm-Message-State: AFuF++lHSOahzToNigAMijPFiIiLE7sc/lbhsH2SIoWcJ76axGRCT7J/
	py3IdJT4ZG0ork1lBPH5CODqKGpDDb6VNhfOD42nB/85MHyb3ZTXSSkzfDl/7krwBKBRd14QHlx
	vRkgtZVz18tiaeEXMiJMm/6giJkGpYcD6Oq15kjU1oCuUkCf1I8I/xFIpXQaIOak7/wZesXa0yA
	4T6JDFykQDTrPgAIoYskB2DM6HadtP5RvnRBTtHa3mzJkGMZw=
X-Gm-Gg: AYBFou3aWt5q+E33cH9BaOZBIqx8Wr8vu++8flDnKL4sSth+BjGUmYGZgfVd8LPzuhu
	K8YpEHjKnUrs6FrMMIw7C92sPgTrhKpXRqGdhQTCYD6yhR5BY9YwZCwNFQl/s9HIxI110A8bvPm
	bdStWJ7HzEWW+hiUYyjvfY2D9GmlJDwaIt/TeMdyC5Bm57Lctcm1NrmvqCCTkf6u/qFYs3ayjtP
	b2tExyG5krKxGbgDFBnT8vXtA55e/EfXBFDkz+xLaxMuR+vvjoX7ECp8onoBHeg6t0bNA+DQ7UE
	EZxXFKMZ5qrCWDqR30DE7ikhZK2iX0qSzWRehvMI61eHj2VZfAr1couy8ZvqZnBWkppMFl+C47k
	z+IPCDcxNs3PraHNkSdggQ8EYSkEZ8MllXNrvYw==
X-Received: by 2002:a05:620a:90c4:10b0:93a:2bd8:93e1 with SMTP id af79cd13be357-93a2bd8995bmr411546485a.17.1789419161664;
        Mon, 14 Sep 2026 13:52:41 -0700 (PDT)
X-Received: by 2002:a05:620a:90c4:10b0:93a:2bd8:93e1 with SMTP id af79cd13be357-93a2bd8995bmr411524285a.17.1789419156380;
        Mon, 14 Sep 2026 13:52:36 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-939e7f1da12sm1099236785a.9.2026.09.14.13.52.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 13:52:35 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 14/14] xfs: remove unused mp argument from xfs_verify_fileext()
Date: Mon, 14 Sep 2026 15:46:19 -0500
Message-ID: <20260914205221.1516254-15-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260914205221.1516254-1-sandeen@redhat.com>
References: <20260914205221.1516254-1-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

(Follows from last patch)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c   | 2 +-
 fs/xfs/libxfs/xfs_rmap.c   | 4 ++--
 fs/xfs/libxfs/xfs_types.c  | 1 -
 fs/xfs/libxfs/xfs_types.h  | 3 +--
 fs/xfs/scrub/bmap.c        | 4 ++--
 fs/xfs/scrub/bmap_repair.c | 4 ++--
 fs/xfs/xfs_bmap_item.c     | 2 +-
 fs/xfs/xfs_exchmaps_item.c | 4 ++--
 fs/xfs/xfs_rmap_item.c     | 2 +-
 9 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index ca147dfaed05..ae91f63455c5 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6087,7 +6087,7 @@ xfs_bmap_validate_extent_raw(
 	int			whichfork,
 	struct xfs_bmbt_irec	*irec)
 {
-	if (!xfs_verify_fileext(mp, irec->br_startoff, irec->br_blockcount))
+	if (!xfs_verify_fileext(irec->br_startoff, irec->br_blockcount))
 		return __this_address;
 
 	if (rtfile && whichfork == XFS_DATA_FORK) {
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 37780a0526d8..14aef87837a9 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -260,7 +260,7 @@ xfs_rmap_check_irec(
 
 	/* Check for a valid fork offset, if applicable. */
 	if (is_inode && !is_bmbt &&
-	    !xfs_verify_fileext(mp, irec->rm_offset, irec->rm_blockcount))
+	    !xfs_verify_fileext(irec->rm_offset, irec->rm_blockcount))
 		return __this_address;
 
 	return NULL;
@@ -310,7 +310,7 @@ xfs_rtrmap_check_inode_irec(
 		return __this_address;
 	if (!xfs_verify_rgbext(rtg, irec->rm_startblock, irec->rm_blockcount))
 		return __this_address;
-	if (!xfs_verify_fileext(mp, irec->rm_offset, irec->rm_blockcount))
+	if (!xfs_verify_fileext(irec->rm_offset, irec->rm_blockcount))
 		return __this_address;
 	return NULL;
 }
diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
index 32e6c0aaf467..f195a04dbf66 100644
--- a/fs/xfs/libxfs/xfs_types.c
+++ b/fs/xfs/libxfs/xfs_types.c
@@ -240,7 +240,6 @@ xfs_verify_fileoff(
 /* Check that a range of file block offsets do not exceed the maximum. */
 bool
 xfs_verify_fileext(
-	struct xfs_mount	*mp,
 	xfs_fileoff_t		off,
 	xfs_fileoff_t		len)
 {
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index adae81149680..19dd5e7c8b12 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -281,7 +281,6 @@ bool xfs_verify_dablk(xfs_fileoff_t off);
 void xfs_icount_range(struct xfs_mount *mp, unsigned long long *min,
 		unsigned long long *max);
 bool xfs_verify_fileoff(xfs_fileoff_t off);
-bool xfs_verify_fileext(struct xfs_mount *mp, xfs_fileoff_t off,
-		xfs_fileoff_t len);
+bool xfs_verify_fileext(xfs_fileoff_t off, xfs_fileoff_t len);
 
 #endif	/* __XFS_TYPES_H__ */
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index dff2329649a4..b56a63c73595 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -485,7 +485,7 @@ xchk_bmap_iextent(
 		xchk_fblock_set_corrupt(info->sc, info->whichfork,
 				irec->br_startoff);
 
-	if (!xfs_verify_fileext(mp, irec->br_startoff, irec->br_blockcount))
+	if (!xfs_verify_fileext(irec->br_startoff, irec->br_blockcount))
 		xchk_fblock_set_corrupt(info->sc, info->whichfork,
 				irec->br_startoff);
 
@@ -887,7 +887,7 @@ xchk_bmap_iextent_delalloc(
 		xchk_fblock_set_corrupt(info->sc, info->whichfork,
 				irec->br_startoff);
 
-	if (!xfs_verify_fileext(mp, irec->br_startoff, irec->br_blockcount))
+	if (!xfs_verify_fileext(irec->br_startoff, irec->br_blockcount))
 		xchk_fblock_set_corrupt(info->sc, info->whichfork,
 				irec->br_startoff);
 
diff --git a/fs/xfs/scrub/bmap_repair.c b/fs/xfs/scrub/bmap_repair.c
index eabffba47776..03af6cb92fcf 100644
--- a/fs/xfs/scrub/bmap_repair.c
+++ b/fs/xfs/scrub/bmap_repair.c
@@ -211,7 +211,7 @@ xrep_bmap_check_fork_rmap(
 
 	/* Check the file offset range. */
 	if (!(rec->rm_flags & XFS_RMAP_BMBT_BLOCK) &&
-	    !xfs_verify_fileext(sc->mp, rec->rm_offset, rec->rm_blockcount))
+	    !xfs_verify_fileext(rec->rm_offset, rec->rm_blockcount))
 		return -EFSCORRUPTED;
 
 	/* No contradictory flags. */
@@ -389,7 +389,7 @@ xrep_bmap_check_rtfork_rmap(
 		return -EFSCORRUPTED;
 
 	/* Check the file offsets and physical extents. */
-	if (!xfs_verify_fileext(sc->mp, rec->rm_offset, rec->rm_blockcount))
+	if (!xfs_verify_fileext(rec->rm_offset, rec->rm_blockcount))
 		return -EFSCORRUPTED;
 
 	/* Check that this is within the rtgroup. */
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 89f6e79a955f..782dc24df3a0 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -442,7 +442,7 @@ xfs_bui_validate(
 	if (!xfs_verify_ino(mp, map->me_owner))
 		return false;
 
-	if (!xfs_verify_fileext(mp, map->me_startoff, map->me_len))
+	if (!xfs_verify_fileext(map->me_startoff, map->me_len))
 		return false;
 
 	if (map->me_flags & XFS_BMAP_EXTENT_REALTIME)
diff --git a/fs/xfs/xfs_exchmaps_item.c b/fs/xfs/xfs_exchmaps_item.c
index c3745d33e54e..85955467d249 100644
--- a/fs/xfs/xfs_exchmaps_item.c
+++ b/fs/xfs/xfs_exchmaps_item.c
@@ -341,10 +341,10 @@ xfs_xmi_validate(
 	    !xfs_verify_ino(mp, xlf->xmi_inode2))
 		return false;
 
-	if (!xfs_verify_fileext(mp, xlf->xmi_startoff1, xlf->xmi_blockcount))
+	if (!xfs_verify_fileext(xlf->xmi_startoff1, xlf->xmi_blockcount))
 		return false;
 
-	return xfs_verify_fileext(mp, xlf->xmi_startoff2, xlf->xmi_blockcount);
+	return xfs_verify_fileext(xlf->xmi_startoff2, xlf->xmi_blockcount);
 }
 
 /*
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 2a3a73a8566d..0066983bc452 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -494,7 +494,7 @@ xfs_rui_validate_map(
 	    !xfs_verify_ino(mp, map->me_owner))
 		return false;
 
-	if (!xfs_verify_fileext(mp, map->me_startoff, map->me_len))
+	if (!xfs_verify_fileext(map->me_startoff, map->me_len))
 		return false;
 
 	if (isrt)
-- 
2.55.0

