Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAC2A3EB11C
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 20:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789419156; cv=none; b=mZZesvnTGFIZrQb97F+W8phR+J47qpqCLjKsjTEByFgzE/kC6aHPiCJiFpaj5jNmV4WGrXdjoXqdR50raVWyyPryy+hMOpU0PI8qvFPHDcHco4FDjLNWDffyyhCjhCHMosFkE5I17CKCJ3Glydoz7d7TRIvkRniI4L4COWvMPR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789419156; c=relaxed/simple;
	bh=b60YzEB2H/rbdcE72wxmPmelhWRKxWNgAZElpkpDyjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IHwgV/AMDPfRRib3XsMSbt5HGDbYoswdfMcSgvbGSSyzc3pxgPLwU3IEXgHGa/Pnpoqqube6c9BWkwbFaGo7ImdVzMlO9tvq79GHhrYVZrAjqQHtoNr1riW0cFYGp2WwTBh+08s+kHQeaYPu+keyzDHE6e0VHWsBhArRW4nTC7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XBDOcDQ/; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=lxOE5Blr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XBDOcDQ/";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="lxOE5Blr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789419153;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5LWE/FCt72EyvG3VPp7sUnuuARvoCHfcap6Prz6l09Q=;
	b=XBDOcDQ/elVMiODFAF/4YRRlJ7hE1IkhSTc1epDXE315Eb13sZzz8nDvGRIWuk6j12cGiI
	TePRYPUCuco65QtPDfIpJQYo2q6Om2Lk/3XAatMSPY/xnSUikzP7/Grj1p/9b46dxWaYNC
	9TGFmnEmyx9R3aZBVAzN1thA/e3VdPg=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-690-U8jakA3EPk-gW5eDwjKuUQ-1; Mon, 14 Sep 2026 16:52:32 -0400
X-MC-Unique: U8jakA3EPk-gW5eDwjKuUQ-1
X-Mimecast-MFC-AGG-ID: U8jakA3EPk-gW5eDwjKuUQ_1789419152
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-93a0c7126e7so369630785a.2
        for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 13:52:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789419152; x=1790023952; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5LWE/FCt72EyvG3VPp7sUnuuARvoCHfcap6Prz6l09Q=;
        b=lxOE5BlrAkq93jRoPA+Ht9Xhsf5hMLUVHQs7+v/HtCvL7sv1KZxWAk/9HRchT72HP7
         8XalKq5qLTdtWgHsULO8ovCmis5WsYe4GEqywm1Dv+B2o1S/A29tMpXPl8c4juL+RWGy
         WYDYmdtDkpXRz6B4psQnZ/tJlIOvi1KWsbfBeEeP8WLmiV0tF2dxOUKRRDieATTaA/Hg
         mphfDbvrdJIHx7kB1KMPvVtvrySRCmqCdyT1fNoavFsJ0b89otjurfi1HVDWtXeCvli5
         5cDa+nby7AtJI9bBC61HgF5MfIJEMnPxWT+g7LaG9cZhasvgFo0R0iGHPYxmJC+4Pf4T
         O9+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789419152; x=1790023952;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5LWE/FCt72EyvG3VPp7sUnuuARvoCHfcap6Prz6l09Q=;
        b=FoRIdW6Xm2J088UMi1OmgwgO3KKRyh5bSWLv2naN/am7LW52yqiknm+8DRhWSv8BFn
         JXzFwRJJdfJQpOpieTSAW8cS/t7PsCrzXZYM4fDFnu3PRCwf/R3iE85l81d0sLm+Vv1x
         hIRGL9MeezrqhucFSE1vscTHUbEXPUQOf19k2kj+Bd9p38s5pcY+1NyMSBf9z3pZp7yp
         ZcR1oGI83FauzkFGHrNNaek+DFVF685KLV1GtIB7bPNcB0lAFLnuTrQe0fvHluGWKSdX
         k3KL9eimxJTFhTg1bDjUL0+Iqd+kh/ZsY9YIU0Zui3rtq/7osyV7CIdKnCBY309ERUV5
         fhKg==
X-Gm-Message-State: AFuF++liJ9Ef3ZQocTact9Qopron9saSXM6WfP7Ds946F2cKiSe9khu4
	Qvoivtcgx0rM3GirYLdSzMKJOJXcHmPwIrSZCbmT5wri6+4zqAIgGaxruKl6dJ/sWEwr3gPy7xz
	UWC1JEwyU/Blc2LD8t+f+lm4sZjOktmSeTY71CGq9KyqXHuBDxvMYarFDrLnOqR3vvFJ/ucWk5L
	1FjW7NrO4rIJFMP3j7hUXDVo0sJSpQX0sFW2O1/FxcDGAL6VY=
X-Gm-Gg: AYBFou17gYV+zv0kZ/ddXeCTyJxCooRsr77L56b40JTL4+mGIR8qEC8JulsNlkhMbHq
	fUNlfViEFKHzU8pc+agDaZLVoi+NCGjNRumZVbhmbSHpAlezlp+baWCBsEUVJ8uu/jZjHA5JUSW
	XuP7KA92D3Ph9Qk8XwnkIZPFC35uU/213KJTZlw6KEkjnAyZ28dbKieBq3uW2yzTFa1MSu6g/eE
	xemQ6gP7VHFAuCl8anAbsrla1XwzBw0IM4Y7HR06pya7mW7uv2rC+vY4ENZ1T22RQ9OMlb4AS80
	EWS7fofhYMXt7TNGdT1vu2b0YbHsNQ+HCgg5goJgmhsaPGnvc+p371qmg55vb1fU2ScKhbTlMXG
	O5m5WIKP7qY2afDlylG8II7uZwAw5T0AEjh02WA==
X-Received: by 2002:a05:620a:2a03:b0:93a:1048:7d2f with SMTP id af79cd13be357-93a29a19943mr628198485a.41.1789419151499;
        Mon, 14 Sep 2026 13:52:31 -0700 (PDT)
X-Received: by 2002:a05:620a:2a03:b0:93a:1048:7d2f with SMTP id af79cd13be357-93a29a19943mr628181385a.41.1789419150126;
        Mon, 14 Sep 2026 13:52:30 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-939e7f1da12sm1099236785a.9.2026.09.14.13.52.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 13:52:29 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 07/14] xfs: remove unused tp argument from xfs_rmap_update_hook()
Date: Mon, 14 Sep 2026 15:46:12 -0500
Message-ID: <20260914205221.1516254-8-sandeen@redhat.com>
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

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/libxfs/xfs_rmap.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 34d218de21a9..37780a0526d8 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -904,7 +904,6 @@ xfs_rmap_hook_enable(void)
 /* Call downstream hooks for a reverse mapping update. */
 static inline void
 xfs_rmap_update_hook(
-	struct xfs_trans		*tp,
 	struct xfs_group		*xg,
 	enum xfs_rmap_intent_type	op,
 	xfs_agblock_t			startblock,
@@ -952,7 +951,7 @@ xfs_rmap_hook_setup(
 	xfs_hook_setup(&hook->rmap_hook, mod_fn);
 }
 #else
-# define xfs_rmap_update_hook(t, p, o, s, b, u, oi)	do { } while (0)
+# define xfs_rmap_update_hook(p, o, s, b, u, oi)	do { } while (0)
 #endif /* CONFIG_XFS_LIVE_HOOKS */
 
 /*
@@ -975,7 +974,7 @@ xfs_rmap_free(
 		return 0;
 
 	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, pag);
-	xfs_rmap_update_hook(tp, pag_group(pag), XFS_RMAP_UNMAP, bno, len,
+	xfs_rmap_update_hook(pag_group(pag), XFS_RMAP_UNMAP, bno, len,
 			false, oinfo);
 	error = xfs_rmap_unmap(cur, bno, len, false, oinfo);
 
@@ -1220,7 +1219,7 @@ xfs_rmap_alloc(
 		return 0;
 
 	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, pag);
-	xfs_rmap_update_hook(tp, pag_group(pag), XFS_RMAP_MAP, bno, len, false,
+	xfs_rmap_update_hook(pag_group(pag), XFS_RMAP_MAP, bno, len, false,
 			oinfo);
 	error = xfs_rmap_map(cur, bno, len, false, oinfo);
 
@@ -2721,7 +2720,7 @@ xfs_rmap_finish_one(
 	if (error)
 		return error;
 
-	xfs_rmap_update_hook(tp, ri->ri_group, ri->ri_type, bno,
+	xfs_rmap_update_hook(ri->ri_group, ri->ri_type, bno,
 			ri->ri_bmap.br_blockcount, unwritten, &oinfo);
 	return 0;
 }
-- 
2.55.0

