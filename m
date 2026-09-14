Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA263349CD6
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 22:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789425025; cv=none; b=hgQmYuRuZSzKQuhyZEGKhRA/Iol+6WWJfrdTLZX2EEVoecqW0ph8X7arLFvptC4dv3Y8APpW6oQm6oAR4plb1o6NLsPD++cH7CNdhjbFBhiZwphLsA079ZL+H/Sygen6pBM1VqMvFS9cGOAhKi43YQzbT3SoIDqmZquLimlRqk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789425025; c=relaxed/simple;
	bh=Rzx4qJ/r5dINuTXK9ilGHpwG+fHxoKKJobLOnUn6zC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ampzxYjPbJKr1LPKz6p6YztVtgGBGvo+sZIvD/7hZGY8NINy/8u9kxtamBuu4J3X1mav4cgkjMmH+SVvnGrwR4sMssCAOVnHtUvjyBryO92YHQsIBQiRttBUJ64MkY8g5/IWOX80DGWprLTgv9nDbcBYpbdfqFtDYOX/HakPVdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HNN6yQsA; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=kghweFnR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HNN6yQsA";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="kghweFnR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789425022;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BSt4Sz9uyX7xqplaYOPg9sYH9VxohzSZ0qcWE5TWrSg=;
	b=HNN6yQsAKwPw7/zIGTgKs80CeLLJFKzUa70jqrzALX3lppAPqbtF0s7Ms4oo7e6MQRw07/
	hKwYc3koE5b9nhiM3KQffEabHD2zF6zvaYlPsxdET00a9jw7Z34QIYf96dP10OBfTmgo5R
	h4mN6FioU0mN4UHoW+5wyHmifazj0aQ=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-110-doQuYnSUOW-xg4PVDb5aqw-1; Mon, 14 Sep 2026 18:30:21 -0400
X-MC-Unique: doQuYnSUOW-xg4PVDb5aqw-1
X-Mimecast-MFC-AGG-ID: doQuYnSUOW-xg4PVDb5aqw_1789425020
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-9104eedb5b0so80960586d6.0
        for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 15:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789425020; x=1790029820; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BSt4Sz9uyX7xqplaYOPg9sYH9VxohzSZ0qcWE5TWrSg=;
        b=kghweFnRFNcvaviWp5ta8x/P0Oaji51irkmfYpjRAu2USSfB17tJuE8tDu/pxO7hsx
         cpPhAlMLUqPv2AkVrMhqIFYwnTeUN+xcY+U2xlJjuO3aLvsGgPyNGcxDbvG8POLyrLSL
         E8uPJazKf3JLT6hXHrpk3JeQ+vPyy9kvJ2oazidbE3VlJ1c2GJGNxVGKM4yPCES8EBF4
         Q6byQIDCRSurlzgpyes2k0ZzJ4qWhE/c2cNdJRDGPlh0as0p7gw88QA4dADlz+r3hlGn
         yRepcZpM/b4f7byi5A9gjdEc9A2ehP5uzgQkmQgGhw2DBxShMdVcRoiNto87JdwdVHFt
         IueQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789425020; x=1790029820;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BSt4Sz9uyX7xqplaYOPg9sYH9VxohzSZ0qcWE5TWrSg=;
        b=tWg/RR0ynbXrozewvd02Y8N4BdpgDG3p6LbpmJPzDRg7222ZLTmLDEC5NL9V7KhlD9
         u9WDF7s6VvtcFZIqY8yylR1S/IIkJKyBrO+2jQKsXCL2WFkKWz4FDxiqO73ZPOk4ZkIq
         pTCIv9JWHuL422RkepM1GhDvjkH3G5rAvedHh6WjIo5YhqqTCLouh0tO1gCCtgUgeu+V
         1TAzumnPvIciQct3egUFQMmYNyCci1JoOXHOqd0fB3n+mh3l248kd9v9v/DsVcz8MBSF
         nd5N1wvbSonHshiwWU5En4ypz98CSr3af/oxlMHJXPqF/6ocUMzfQVUm1rvdV/lutA5j
         3ETA==
X-Gm-Message-State: AFuF++kQy2A2JkmCqdOZXPDnnzDg5cq013HpuVGsvZGtiQqOd2U/E0YQ
	rARlA3VlzY+YAgM84hSbIxaymBU7aeTRHW1ngBGi4sb5ffAgXf7L7TSQpyHRcCn1cdW1kBC2zI2
	u8AMgP6WkgDn1F09Cr5sLe/gj5o4KC3BBWUBqAj/4vBNAheC9+EzfN6E6IJ0cniKHiV/h124ZiN
	YA61LyRiIvhFtr+V22mgbCyx29w1pBhKdjlQ99KWljEK71hvw=
X-Gm-Gg: AYBFou23UZzYXktNG9c89Tf/FUhnrcBHs+R5A/c9qXqZV4otgXnmvZ9DGhXBpO0Up/q
	b9e/vle1S+4i9SIovYm1PZm7OLyloyIXsbuyzm4qjQ8moC/se/mETiCD4jm0wEfOiO+kWbij5u7
	2GptYm1EMrQd55AcrK4QcfvmcJmjaOp2dq04Wx1W4IFgTcMVD1KOZkV9DtIVXzBV1b8jJRRsT20
	IL09r0VyD4tumSwGk0uEa+89V9TH3AIZZBz8adpVOLB1Xn57HpO0PUQjpd7lGw/M/aQSviPDFDC
	XDwK0Z/PKjILrpdq4LpP+t2Do/HtSgDcYCBZUEJ+7C7AOXYyuvYwZCQZTGe5Nbw/6gJqNYQGcjc
	QjtsC5pbALypyedosOIKafR2Qekuuikfvz2qFLA==
X-Received: by 2002:a05:622a:e0d4:20b0:531:12c5:fcf5 with SMTP id d75a77b69052e-53112c5fec4mr38662581cf.1.1789425020035;
        Mon, 14 Sep 2026 15:30:20 -0700 (PDT)
X-Received: by 2002:a05:622a:e0d4:20b0:531:12c5:fcf5 with SMTP id d75a77b69052e-53112c5fec4mr38661851cf.1.1789425019403;
        Mon, 14 Sep 2026 15:30:19 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-530fa03dc30sm56084041cf.15.2026.09.14.15.30.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 15:30:18 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH V2 10/14] xfs: remove unused mp argument from xfs_rtrmap_broot_space_calc()
Date: Mon, 14 Sep 2026 17:28:56 -0500
Message-ID: <20260914223007.1587017-11-sandeen@redhat.com>
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

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/libxfs/xfs_rtrmap_btree.c | 6 +++---
 fs/xfs/libxfs/xfs_rtrmap_btree.h | 3 +--
 fs/xfs/scrub/rtrmap_repair.c     | 2 +-
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.c b/fs/xfs/libxfs/xfs_rtrmap_btree.c
index a15e460a1ec7..5901d7efd3f6 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.c
@@ -412,7 +412,7 @@ xfs_rtrmapbt_broot_realloc(
 	unsigned int		old_size = ifp->if_broot_bytes;
 	const unsigned int	level = cur->bc_nlevels - 1;
 
-	new_size = xfs_rtrmap_broot_space_calc(mp, level, new_numrecs);
+	new_size = xfs_rtrmap_broot_space_calc(level, new_numrecs);
 
 	/* Handle the nop case quietly. */
 	if (new_size == old_size)
@@ -895,7 +895,7 @@ xfs_iformat_rtrmap(
 	}
 
 	broot = xfs_broot_alloc(xfs_ifork_ptr(ip, XFS_DATA_FORK),
-			xfs_rtrmap_broot_space_calc(mp, level, numrecs));
+			xfs_rtrmap_broot_space_calc(level, numrecs));
 	if (broot)
 		xfs_rtrmapbt_from_disk(ip, dfp, dsize, broot);
 	return 0;
@@ -980,7 +980,7 @@ xfs_rtrmapbt_create(
 	ASSERT(ifp->if_bytes == 0);
 
 	/* Initialize the empty incore btree root. */
-	broot = xfs_broot_realloc(ifp, xfs_rtrmap_broot_space_calc(mp, 0, 0));
+	broot = xfs_broot_realloc(ifp, xfs_rtrmap_broot_space_calc(0, 0));
 	if (broot)
 		xfs_btree_init_block(mp, broot, &xfs_rtrmapbt_ops, 0, 0,
 				I_INO(ip));
diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.h b/fs/xfs/libxfs/xfs_rtrmap_btree.h
index e328fd62a149..c59a144b4bbf 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.h
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.h
@@ -140,7 +140,6 @@ xfs_rtrmap_broot_ptr_addr(
  */
 static inline size_t
 xfs_rtrmap_broot_space_calc(
-	struct xfs_mount	*mp,
 	unsigned int		level,
 	unsigned int		nrecs)
 {
@@ -159,7 +158,7 @@ xfs_rtrmap_broot_space_calc(
 static inline size_t
 xfs_rtrmap_broot_space(struct xfs_mount *mp, struct xfs_rtrmap_root *bb)
 {
-	return xfs_rtrmap_broot_space_calc(mp, be16_to_cpu(bb->bb_level),
+	return xfs_rtrmap_broot_space_calc(be16_to_cpu(bb->bb_level),
 			be16_to_cpu(bb->bb_numrecs));
 }
 
diff --git a/fs/xfs/scrub/rtrmap_repair.c b/fs/xfs/scrub/rtrmap_repair.c
index a2b72e61edf5..5cfa4470c57c 100644
--- a/fs/xfs/scrub/rtrmap_repair.c
+++ b/fs/xfs/scrub/rtrmap_repair.c
@@ -693,7 +693,7 @@ xrep_rtrmap_iroot_size(
 	unsigned int		nr_this_level,
 	void			*priv)
 {
-	return xfs_rtrmap_broot_space_calc(cur->bc_mp, level, nr_this_level);
+	return xfs_rtrmap_broot_space_calc(level, nr_this_level);
 }
 
 /*
-- 
2.55.0

