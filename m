Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0385C4756DF
	for <linux-xfs@vger.kernel.org>; Fri,  4 Sep 2026 11:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788521364; cv=none; b=QuwHab6jKpegVwfw1AUtb5jpxVyTCC1pPGEkT6YS5j1P1kgs3p9ZJAC8lvP707q3D1dPrXh+zzhEu+QIQsPIPVb8RrS5STkH+9Gl4Zk+Cyv+47NP7ydFzf4HkwKNW5H1COed5N1ahZGEwXTm/puKBnXV0qOccglxmv+SfWNjpJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788521364; c=relaxed/simple;
	bh=Lj1PD2f9pz9Ij9feSfZgUHW3PElHqmhNb8Lh8E2bENM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d/1QL3XhCYBWKb9Boe7o8IVfYqa1y4eTwhvkybREozSkdMaSK+KSVrs3yJrDNzOrQ0H9Rjh+SXqC3NScfaMzuQAE+G0kKxwmq4MSEf59uA06nG6QvCayG/X8zowrAx0W4Ae6W4Z8QTA9onZmBacIJ/VbrB75eelOleaiF/VUA4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iCVLi3Kx; arc=none smtp.client-ip=209.85.210.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iCVLi3Kx"
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-7eb6573bd52so934468a34.3
        for <linux-xfs@vger.kernel.org>; Fri, 04 Sep 2026 04:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788521362; x=1789126162; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tveKHrh1E9a3s6wI0Ntl0PNo6E2y3iS+apLHkE6dGO8=;
        b=iCVLi3KxtwLY0huIxj3w4ZkcrZ4tvFlnEIBQA5LH3CxwBkEIO8e1tnQljW3eV7L/tQ
         b3mgLi48UEfE7inKX6R0djNVCDvjIN0ozdd1T1BWo4ktcq/r+LMKOiNedTe8gl2Vh3oQ
         FC11Rk56n98xfeUUBHVDpJsvh8hUkWzg1MgPUVZde99m9mvunqd+B+d4eeVO3+EsNGff
         ISnRYLahy5DKRMGhZOk+VmpL0KGjW+dGXdKOERlFeejsFTN/75C7+t8JjezFj0JUI1s1
         DCC7Yw5y8n9DhSXuDEYsa/DSjVNHmPmDwaQ5/GM1bRXDhDDrULFlbTAovT+yn9D8ozJe
         IPYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788521362; x=1789126162;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tveKHrh1E9a3s6wI0Ntl0PNo6E2y3iS+apLHkE6dGO8=;
        b=Kur10Zr8otmcaNVMEVokMr80u7uiqeCWAjvsLEKE61ScRhJfDJKjeKarGk6oXQcsSK
         n2Ndsesocx77LhDTTFiGTtJuI24bwNHXFghQ82N7lN444inmYMmHIsx4dIsieT5cTS1d
         spshdc4Gm8aAgQNi7Fld1ahd1M1+jFv3YDPjYWjASGCW54Kodeh1L+JYZqjKqfAOoBwr
         Dreblvo3KxnqxXBJA3GtN3ISiNNEb5IwMDY9Sxl/i1qQpy91/qgx8QQKbxCRgIkn/AFH
         6JODD5bFvHlPa44eWPDgbgdJeTKpedalWsqivUHWEEvfD/aSmac/VxVlCMWQtYvPW1Xw
         WW1Q==
X-Forwarded-Encrypted: i=1; AKwUvBwl46h/o7VpZMFYKPcL6zCcH4BiljvX+42aGupdg27jbb4dF5rs8pKNCM6Fl0asBJbJqXQcFGbeqpQ=@vger.kernel.org
X-Gm-Message-State: AFuF++mdchzF2ase8SDeYAOZIVDfDDdCX9Ifx6h4evJyDmpVbPrz6xI0
	pgTyB7XMPGBTm2hY0W8spDYVDDZIS8TcSvoH5XI+QqRai04ud/XqGHmZ
X-Gm-Gg: AYBFou1KuWbD19bdLsUtAx+YhHPWDdJTgx7GUVBtHojMdbVVhGpodEsMPFj/l+rZeJH
	HD2ZJM/GUfvjM7exMxXlldyOiehsjnv4Lu+Lk44js11d6KjrECMJEVC7stahA2SpUo0GoCesx+R
	js+wcxXdT1Lk6xkNbTlX2VDqorPjdJbGWkKrsDgf34xin0BJT9aWYS0WsyReImp1WsWQCxSeKA8
	yu2WQcrYi8MlMQ3vJ32rtEU9KWwoM4BdGwzz8RA3YQl0V5SIDZk5S8UWOfa/cJgRibhmAA2Tdfm
	nY+tgVtouSUIXLkCOqIh2IqhR4oX1a+1kKKzFJN5446iEApFhUYLhFtJsNJdt0XySwClJF6IXr2
	Vq/i8Pnbka5h5mzufv6bC5D2xiNCusEDefIWbeMhCieqFigoiAch0SNZoQLE0xHPcfogvTHlp/t
	oEF+btPbosHKOVuQZAd9Ud82pyxPvx91Nlc8ZMp+gCy/0sl1yiI8NrFoSVlrpSYZzpWHNWk9Wgk
	ePICuxI9rcqPiKh2jbFQYWQbw==
X-Received: by 2002:a05:6820:188d:b0:6b3:6658:cb02 with SMTP id 006d021491bc7-6b6fdac57d8mr3533484eaf.33.1788521361804;
        Fri, 04 Sep 2026 04:29:21 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1432435648esm7443259c88.5.2026.09.04.04.29.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 04:29:21 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs: fix repeated words in comments
Date: Fri,  4 Sep 2026 16:59:04 +0530
Message-ID: <20260904112909.8197-3-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260904112909.8197-1-hemanth.selam@gmail.com>
References: <20260904112909.8197-1-hemanth.selam@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Drop words accidentally written twice, reported by checkpatch.pl as a
possible repeated word.  Only touches comments, no code changes.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
 fs/xfs/libxfs/xfs_exchmaps.c   | 2 +-
 fs/xfs/libxfs/xfs_inode_buf.c  | 2 +-
 fs/xfs/scrub/agheader_repair.c | 2 +-
 fs/xfs/scrub/alloc_repair.c    | 2 +-
 fs/xfs/scrub/reap.c            | 2 +-
 fs/xfs/xfs_bmap_item.c         | 2 +-
 fs/xfs/xfs_zone_alloc.c        | 2 +-
 fs/xfs/xfs_zone_gc.c           | 2 +-
 8 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_exchmaps.c b/fs/xfs/libxfs/xfs_exchmaps.c
index 3efed37cb98a..6a66b6075e0a 100644
--- a/fs/xfs/libxfs/xfs_exchmaps.c
+++ b/fs/xfs/libxfs/xfs_exchmaps.c
@@ -395,7 +395,7 @@ xfs_exchmaps_one_step(
 	/*
 	 * Re-add both mappings.  We exchange the file offsets between the two
 	 * maps and add the opposite map, which has the effect of filling the
-	 * logical offsets we just unmapped, but with with the physical mapping
+	 * logical offsets we just unmapped, but with the physical mapping
 	 * information exchanged.
 	 */
 	swap(irec1->br_startoff, irec2->br_startoff);
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index e4c3f7b24e95..0340e2189921 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -626,7 +626,7 @@ xfs_dinode_verify(
 	 * have di_nlink track the link count, even if the actual filesystem
 	 * only supported V1 inodes (i.e. di_onlink).  When writing out the
 	 * ondisk inode, it would set both the ondisk di_nlink and di_onlink to
-	 * the the incore di_nlink value, which is why we cannot check for
+	 * the incore di_nlink value, which is why we cannot check for
 	 * di_nlink==0 on a V1 inode.  V2/3 inodes would get written out with
 	 * di_onlink==0, so we can check that.
 	 */
diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 2104512f1ee1..493efa2b2f0d 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -1352,7 +1352,7 @@ xrep_iunlink_mark_ondisk(
 
 /*
  * Walk an iunlink bucket's inode list.  For each inode that should be on this
- * chain, clear its entry in in iunlink_bmp because it's ok and we don't need
+ * chain, clear its entry in iunlink_bmp because it's ok and we don't need
  * to touch it further.
  */
 STATIC int
diff --git a/fs/xfs/scrub/alloc_repair.c b/fs/xfs/scrub/alloc_repair.c
index dce6ab0429dc..84ae88ca027a 100644
--- a/fs/xfs/scrub/alloc_repair.c
+++ b/fs/xfs/scrub/alloc_repair.c
@@ -338,7 +338,7 @@ xrep_cntbt_extent_cmp(
 }
 
 /*
- * Sort the free extents by length so so that we can put the records into the
+ * Sort the free extents by length so that we can put the records into the
  * cntbt in the correct order.  Don't let userspace kill us if we're resorting
  * after allocating btree blocks.
  */
diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index fcd14c1703ea..d1f4b7159af2 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -172,7 +172,7 @@ static inline bool xreap_is_dirty(const struct xreap_state *rs)
 }
 
 /*
- * Decide if we need to roll the transaction to clear out the the log
+ * Decide if we need to roll the transaction to clear out the log
  * reservation that we allocated to buffer invalidations.
  */
 static inline bool xreap_want_binval_roll(const struct xreap_state *rs)
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 89f6e79a955f..aa5b41629747 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -339,7 +339,7 @@ xfs_bmap_update_get_group(
 
 	/*
 	 * Bump the intent count on behalf of the deferred rmap and refcount
-	 * intent items that that we can queue when we finish this bmap work.
+	 * intent items that we can queue when we finish this bmap work.
 	 * This new intent item will bump the intent count before the bmap
 	 * intent drops the intent count, ensuring that the intent count
 	 * remains nonzero across the transaction roll.
diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index bdbb60cc5d5b..f678015457c9 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -826,7 +826,7 @@ xfs_get_cached_zone(
 }
 
 /*
- * Stash our zone in the inode so that is is reused for future allocations.
+ * Stash our zone in the inode so that is reused for future allocations.
  *
  * The open_zone structure will be pinned until either the inode is freed or
  * until the cached open zone is replaced with a different one because the
diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index 5fdcf98a2133..54b70ed2922f 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -46,7 +46,7 @@
  * before remapping.
  *
  * Once a zone does not contain any valid data, be that through GC or user
- * block removal, it is queued for for a zone reset.  The reset operation
+ * block removal, it is queued for a zone reset.  The reset operation
  * carefully ensures that the RT device cache is flushed and all transactions
  * referencing the rmap have been committed to disk.
  */
-- 
2.48.1

