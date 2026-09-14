Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C356384CD4
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 22:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789425034; cv=none; b=gaVMiW6QDu9gz6cBhUGmrUzYyl1W+jrjtTQsFQWPvSbS3ONHfwhTfY3SfyPtHhqEd7T+Tm1VJA8F5Ou8z/MMrc8Fg/ZluJhsr1hHfljEJ8/36+Hd2KD34wG000FutWZKXuEm6b59z8NwaflkC8b2wi10C9G9SaZQfzhvQ4Q83BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789425034; c=relaxed/simple;
	bh=Co2M0THose6UEz9d9YcvEMoIjMujeUZyPcMbvSkRG+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aQlEFDGt9I6C93vMuB6Ca0VWlog0FDBlYvmP3aqflOqZRriPNvbhlBJe+y0CdGGRvPYlIbhb4WWqlUjEOV+/FMXQ11niPYjwz/ipaVCyXT1mA4QcvtHaaWkJbXEmN7bITFCUfsI5NzmVTji+zouF/Vz91Anivs3fRU6alXVEibQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BK5c4WpH; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=bys60UYH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BK5c4WpH";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="bys60UYH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789425032;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ud79ACH49htELTlRduL2TT0miiRnR0gCNNRd4A2Za9I=;
	b=BK5c4WpHkxWIV5uiKs0SRIW9ESOD8uVOpXDSOJz1879wewH54rygoO3gh7cqa2Lge9AKdw
	TKGZXU6vtxpdPM7kamjKxpIeimoH1JVAjmh+MTIGc8qE+HTT/HT/pf2mfv36AdJcGKXWGc
	Ze3AfnT4Jo5e+DRzj3+W7z1qkPWYPmI=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-161-Y7j55SJXNymde33X17s91A-1; Mon, 14 Sep 2026 18:30:31 -0400
X-MC-Unique: Y7j55SJXNymde33X17s91A-1
X-Mimecast-MFC-AGG-ID: Y7j55SJXNymde33X17s91A_1789425031
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-530d206e2b4so77062491cf.2
        for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 15:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789425031; x=1790029831; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ud79ACH49htELTlRduL2TT0miiRnR0gCNNRd4A2Za9I=;
        b=bys60UYHfMZDKdyCEOnizCagX9YmD4raZRbTN9W7Q+R1MuUhRgLiz7huEaRu+j5Mdu
         Mt4y1FkpNgonN/a1zTwcxxizjGn6gA844t15y4cM1Y158ELxsxTCVeFKYn4GYZr8NQ0K
         ZnWP1gUH/vwTD/cG+4xYl6F/E2Rf7HnhHdoj1TjFqbIFfRR/oKZv1px24R7DXjyaWq4s
         rGofsf+mBFFggQ2ogb8je/RoqGG1pjnfpoD6d60++33iZNk/hdDSH0wwDJEQVJTjZ991
         pPo7sJ4eqWgwNl8bhAneqb+1l0do/W6lKsaqjMULrtGTISe9m01iTAcSUHUVaD2JqqQr
         eWZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789425031; x=1790029831;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ud79ACH49htELTlRduL2TT0miiRnR0gCNNRd4A2Za9I=;
        b=AhgMENHi5E2grO35LIO5J+sTr78c4q1x5x74sz/Kjkc2lFeT+rY4zY1cCfhBwp78zd
         XEepIo7mmiIScMhZeuFgmJU/ZbKr8VtpDg5OMzk2a77YqNaXEWfJuoCBDh7KMLAo61ww
         Jh051zA/1GkScwE55qOsLwG2+r7J5zwxpXoVMCxbKpJDvSBf/li+DLCG6VexwL4sF392
         lRbInKd7RamKAQogBoG6RxMIsJNqrWhFw8SwbYJurR/mMMWea6AZzWUh8wYsY4L9PshH
         Dd7o7vFn5QL9XNoMROXiGsckskZIHaTWXg5Hg7eYNQK4BBIs6dlov/rBAZEbvw8UPgHb
         MNoA==
X-Gm-Message-State: AFuF++mCUHeU2kTio24sfK43uLRkP6ojr7qZbYkrsGd3AmA3JWKu3Otg
	Y7r1EUJtmFa+TvsVVPFpqA8b4fgKoJGDSwuE/TnQnp/awiV567dIT14M3462LBSefZYGMWWh/MH
	mc1gzaCXsY7d5rMxH7ROuDcUhfw7cl2YCN7Qb1Q+kMLspjOlI6R+6JYmLwDKd7ijTdhZc8nlAYs
	5bBqRZg/JA46Oz2Na5CP4uH5kl2Z0W+b2VibeEzK1A9ocbvkU=
X-Gm-Gg: AYBFou16IJaRZBbQvrP3J1hZwzlj7pSNYls2LkcXot8DRSpkBZCQXYUCRyzjPJBOQIc
	IC4cnRbpGw/h9SVVifoHvLew855W4wkOHFE6va5g6mcubu56hJQ9iMUpbozkVm8h0sfMlFvFlIP
	3b/mSyeI2EioY4oUSaEVc38w64gRUjSy4vtciRpFMILdjgBNkOmMZNCieETTT6R3IQTObHN+H6o
	kDBHmYlJEiwkGQThqQHaR0fBmHZvV/0lVojKswS/4z+gk18bX6No2kn5JQ2ojflyXFdHH7/5UTr
	va4R6jsTnkNKOUhyAprJiQgJSecEypE/73oDWsztOEj+6lqxnkc1mNaOK1SA4Am4OKEcnjtYAvQ
	GR6V7dZWQd5FZFFdMYLTJPJE4BVkLf9Gdtz8lfg==
X-Received: by 2002:a05:622a:c04:b0:530:e52a:8ef1 with SMTP id d75a77b69052e-5310cf6783emr68103391cf.26.1789425030193;
        Mon, 14 Sep 2026 15:30:30 -0700 (PDT)
X-Received: by 2002:a05:622a:c04:b0:530:e52a:8ef1 with SMTP id d75a77b69052e-5310cf6783emr68094881cf.26.1789425024233;
        Mon, 14 Sep 2026 15:30:24 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-530fa03dc30sm56084041cf.15.2026.09.14.15.30.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 15:30:23 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH V2 14/14] xfs: remove unused mp argument from xfs_verify_fileext()
Date: Mon, 14 Sep 2026 17:29:00 -0500
Message-ID: <20260914223007.1587017-15-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260914223007.1587017-1-sandeen@redhat.com>
References: <20260914223007.1587017-1-sandeen@redhat.com>
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
 fs/xfs/scrub/bmap.c        | 6 ++----
 fs/xfs/scrub/bmap_repair.c | 4 ++--
 fs/xfs/xfs_bmap_item.c     | 2 +-
 fs/xfs/xfs_exchmaps_item.c | 4 ++--
 fs/xfs/xfs_rmap_item.c     | 2 +-
 9 files changed, 12 insertions(+), 16 deletions(-)

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
index 868f502a44f2..c190590bc562 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -485,7 +485,7 @@ xchk_bmap_iextent(
 		xchk_fblock_set_corrupt(info->sc, info->whichfork,
 				irec->br_startoff);
 
-	if (!xfs_verify_fileext(mp, irec->br_startoff, irec->br_blockcount))
+	if (!xfs_verify_fileext(irec->br_startoff, irec->br_blockcount))
 		xchk_fblock_set_corrupt(info->sc, info->whichfork,
 				irec->br_startoff);
 
@@ -876,8 +876,6 @@ xchk_bmap_iextent_delalloc(
 	struct xchk_bmap_info	*info,
 	struct xfs_bmbt_irec	*irec)
 {
-	struct xfs_mount	*mp = info->sc->mp;
-
 	/*
 	 * Check for out-of-order extents.  This record could have come
 	 * from the incore list, for which there is no ordering check.
@@ -887,7 +885,7 @@ xchk_bmap_iextent_delalloc(
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
index dd5d92ca1010..dd104bf778ba 100644
--- a/fs/xfs/xfs_exchmaps_item.c
+++ b/fs/xfs/xfs_exchmaps_item.c
@@ -341,10 +341,10 @@ xfs_xmi_validate(
 	    !xfs_verify_ino(mp, xlf->xmi_inode2))
 		return false;
 
-	if (!xfs_verify_fileext(mp, xlf->xmi_startoff1, xlf->xmi_blockcount))
+	if (!xfs_verify_fileext(xlf->xmi_startoff1, xlf->xmi_blockcount))
 		return false;
 
-	if (!xfs_verify_fileext(mp, xlf->xmi_startoff2, xlf->xmi_blockcount))
+	if (!xfs_verify_fileext(xlf->xmi_startoff2, xlf->xmi_blockcount))
 		return false;
 
 	if (xlf->xmi_flags & XFS_EXCHMAPS_SET_SIZES) {
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

