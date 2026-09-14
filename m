Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A47413EB11C
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 20:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789419158; cv=none; b=tmJjmiFrslIpXu5Y5j2v4gAjW5QUx2uz8Y0HKl0LHDpyuGCfnpsk708wamIJCOeE1TjcT4+7CwdfZYtgQV79FmrlAlJ2pFv4129j38MAR++PEcDq8TJe8jGr8+/Ex3RtmcMbCI511z+7ycGiEevGtuy2QUUSUc2dYWyefB5Swe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789419158; c=relaxed/simple;
	bh=h1T96Rz00sOEJK+vo+oGi37gwToB1c7jpL8EHJbrTV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lglpQ3vjtrbatMgZ7lDvca40/sGCkCWklMmpgnKvbgKFsCATnensBqrqJ3bgEC0VLv8Hzaycps2f9fowRQh1ZZtEWOH8+MZCuBxf1fjxn6IFF+soPFKtAQLqxC4kGQTJQ1YiSOUIRlSmk6oXJyj3NNmwBD3m5omhap+NQFdD9Cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fMf5+1dv; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=VKNAoxr6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fMf5+1dv";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="VKNAoxr6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789419155;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2GliKk2zr4NT38HDE7I6nNlex4SLQk71EyjnlXvEMUU=;
	b=fMf5+1dvduIYFowYmoE6eGcwXju6e80go17i9Ckdds32CIOFSAcXsGZylPTw4T7S15/gzK
	dGryeDUFSdCnj1tp3cxdtWfjScFZ9Kal+6M9yj+Hy2Kk2o130iJnCFQJvx9eyjrIU3abti
	aWfKC3mAWpuZPGzhnduddsxgYemOoRM=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-85-T1Yt3e3nPhWciNsrdo7hFg-1; Mon, 14 Sep 2026 16:52:34 -0400
X-MC-Unique: T1Yt3e3nPhWciNsrdo7hFg-1
X-Mimecast-MFC-AGG-ID: T1Yt3e3nPhWciNsrdo7hFg_1789419154
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-93a05d645acso581691985a.2
        for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 13:52:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789419154; x=1790023954; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2GliKk2zr4NT38HDE7I6nNlex4SLQk71EyjnlXvEMUU=;
        b=VKNAoxr6Hdpw3yCXC3FYh04amI2sVzmGbXCp+8WGbAw889fTtl3Tqhe3fE+EtU2Dl+
         8Qf3Cg7KSOUeC/+iMSDzunXKGTE713+I4wCPJ9LjKtBpT4NvTbimbnfFB/zudTw9L+lb
         Z9u8kXYHfMoDXDtyz5J68M8xFw8Wvpaor8+tVS1AwbPs2wBePV61ANpWRgbwIcTMNCMs
         8hzg+4xpEISF0xX1DBih6PWY3U0Jrc2GhvQ6hEUa5w10oE+DJ8bM/aNbyB4A3tokxttp
         9Uheo8JSQhMB4RSIJPyOB9OYBnDz+/4GzevzfKyUEjeJwv/UygYR+PiGTfCZ8arkXyup
         Jw+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789419154; x=1790023954;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2GliKk2zr4NT38HDE7I6nNlex4SLQk71EyjnlXvEMUU=;
        b=kK7lnjDSu95+Wqdh70Qo9hMXLrT6KXr4tr4lfPVtk6taC3VpdYNTPZV9Kzgw5/XfI1
         KTTvKiDfmlE8uMKDcn/i5qy90TxCYEJXQw4/iIj+WCJY0d3LJE8g2gjVGq12zANGy441
         fBau03yEWONz7v3dLl+JW/bWz8a2Tkcp1SpQYXINcKy41mG6fAl6PvaLcLKZaulbX3LO
         k1WIwTtvAOQ/QtLflzVy+cbIXnjLznAwPUENT569xJMMYofqgbbukwoT3dwvpO88bUBd
         45RZZXj/UQc27S87CYK5IeHGEUq1ZZEf2lDCTZcXa0livqw46iluNXP/83oGEaxV0a5G
         OGwQ==
X-Gm-Message-State: AFuF++lv/nUIhYypjYQRRUiiIWPqcjI/J1vLe7Ptd+BkDIrF0uyjVQl2
	tO27ngUOLVBtMvWGBWvxvIyu9uKmHa6RIXzwq8JIv1Gvbfj6melNMRS+YFtJ7GC265WnKTp9XAu
	OtIHfjNBB9jqbzzhKSXei5yflCaP5BVk2ss6Tc1t4mId8BSSJ0GhXXK75aWcUdsFtkIGGvJ7mxr
	jh29EkgdXZTwWuJvJY4KnYbIRrS3N5syOBfhM6AEyZO+UB73Q=
X-Gm-Gg: AYBFou2tQm5ut2aYYUo1I2Gy5awOmU5sKFlqId7c5eLo7CjKqGClMxHDLv+BrrsRmFP
	jvZZaqq2jZVWe0d8egrAkXakebkCCYd00RIBahKmcAmp2zTh4lpqbYc2vzM833iXsyQ5dMIisVL
	R3P3F3A2HCvriUjhWnwIb6RxnVvWHW5SYMA+JWbK+R4mfdxSGLPc0Oxx1ZxPYrHTFYj0d+cqyJS
	bd5C5HfaGOdC2ltHep5Hwus5BRhAeBFrdPLgDpY22pwSxBFO6A0yEjupU1uKP/JOJa3Nbj8wSDe
	OY6s9NVWlhIqQFe/UDtQMjlgPSs5rWhZSvlpdi7Cu/cuZ3eFWJ+F3I2x9PAmvkT5x3MunKap6u2
	2RpeqYFQAK0KszxMfLP8bqnKBLg9qLceLuEMppQ==
X-Received: by 2002:a05:620a:6886:b0:939:9b1c:ea4c with SMTP id af79cd13be357-93a29975ae2mr764015485a.28.1789419153810;
        Mon, 14 Sep 2026 13:52:33 -0700 (PDT)
X-Received: by 2002:a05:620a:6886:b0:939:9b1c:ea4c with SMTP id af79cd13be357-93a29975ae2mr764009085a.28.1789419153326;
        Mon, 14 Sep 2026 13:52:33 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-939e7f1da12sm1099236785a.9.2026.09.14.13.52.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 13:52:32 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 10/14] xfs: remove unused mp argument from xfs_rtrmap_broot_space_calc()
Date: Mon, 14 Sep 2026 15:46:15 -0500
Message-ID: <20260914205221.1516254-11-sandeen@redhat.com>
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
 fs/xfs/libxfs/xfs_rtrmap_btree.c | 6 +++---
 fs/xfs/libxfs/xfs_rtrmap_btree.h | 3 +--
 fs/xfs/scrub/rtrmap_repair.c     | 2 +-
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.c b/fs/xfs/libxfs/xfs_rtrmap_btree.c
index c264bc5651c0..e36c2e006c5d 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.c
@@ -412,7 +412,7 @@ xfs_rtrmapbt_broot_realloc(
 	unsigned int		old_size = ifp->if_broot_bytes;
 	const unsigned int	level = cur->bc_nlevels - 1;
 
-	new_size = xfs_rtrmap_broot_space_calc(mp, level, new_numrecs);
+	new_size = xfs_rtrmap_broot_space_calc(level, new_numrecs);
 
 	/* Handle the nop case quietly. */
 	if (new_size == old_size)
@@ -893,7 +893,7 @@ xfs_iformat_rtrmap(
 	}
 
 	broot = xfs_broot_alloc(xfs_ifork_ptr(ip, XFS_DATA_FORK),
-			xfs_rtrmap_broot_space_calc(mp, level, numrecs));
+			xfs_rtrmap_broot_space_calc(level, numrecs));
 	if (broot)
 		xfs_rtrmapbt_from_disk(ip, dfp, dsize, broot);
 	return 0;
@@ -978,7 +978,7 @@ xfs_rtrmapbt_create(
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

