Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEEF64229D9
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 22:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789425037; cv=none; b=lYsRhvcAbOtLNfV5kjYkxBo1ot5U6Ds4YzlsFgXeXaoy8QfFXdubO0MTJHdDx6CNA1jOM8+msUnHhiPwm9Tp7CZn5jh7Pkd8SRyqE4aJmIzc/+7MS14fh0h0m5sHXbbFinXDp6fpOG+DFhnXt8t1tWwTjaxYTJqmpET19Zwer6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789425037; c=relaxed/simple;
	bh=vAH3wZMJb/r0yZi+AnBHs/jiREeLoEeOf2E+ZAypNbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dYfaWFhLIT1n6j8LNdsTgR/eEJbfqMzgMFA3sJKxLDmcDuiSWnzuM+2CqgiLk+AoUcL32vKtW6RBMRYpsex2q2XeWH1JSFj2jsR/nEqMrZxxLWBfkP7MyRGCoBSK6hHOYh93AKAT3KX+loM+4L/rKKyiet6xZXxhKa1PpPQOlvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QNRO3Wd+; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=VUZesbE7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QNRO3Wd+";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="VUZesbE7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789425034;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g5SB4ZlKK8a9tR7A1i9GsnDOkxJA603j+moArBOUwpw=;
	b=QNRO3Wd+nXoIgkO0nuqB8YDHlU/NBmDVNyU6Or9C6w38gwEUIeJuIvXnWujcH4miLHKJWd
	o21GRJjiCyQISeggPz56TkTTjV5gPf3kYN5v+1lOVxvKRMRyKksNHeAWuTCZS3yo+pU+LD
	mlVdqFMbGC0MnsQXWq5ke9L4WP8VWlA=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-568-ZVeymoMTPa6jZP_-xIp9bQ-1; Mon, 14 Sep 2026 18:30:25 -0400
X-MC-Unique: ZVeymoMTPa6jZP_-xIp9bQ-1
X-Mimecast-MFC-AGG-ID: ZVeymoMTPa6jZP_-xIp9bQ_1789425022
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-530f65ddee1so44474761cf.2
        for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 15:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789425022; x=1790029822; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=g5SB4ZlKK8a9tR7A1i9GsnDOkxJA603j+moArBOUwpw=;
        b=VUZesbE7DiLu9fvBsDuEHCx/nzlQGcm1csa45f06McIX8Ks5rEGxy87d8MrxdLs00W
         xGMG5f5XpJVzW4Tv7mmtqV/NJydPERbGVqBgZy6ueM6lJ0mBuBWTRuAQwD6wlbwrL+Oz
         ubS3PfnUAC5EjKKt4W+G31qVpFne7f513rf4g/zpSR6L11mMVNVuT8ULRk3KLMpZeg0r
         TziDxUh0oMqmcZy4Ho2Nh8HzKBY748JM0/Z2xHMybSSUQCXQLhvzGniX67rU6loViDRW
         BC78kN16vlqUhNvY59qN1tzXDCDAlq0rR0u4KXIP88b+gG2B03HLsbHOa3D4QGaUf0p9
         jwjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789425022; x=1790029822;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=g5SB4ZlKK8a9tR7A1i9GsnDOkxJA603j+moArBOUwpw=;
        b=k3KZtOKxEcRxUq+sWNUByOP2JK96fn5WE/jMmqIRYnamX8gCr6h+flJ7BR2R8WAW82
         wbSlbIVjMBX0IHVm9vK38kvAawBTol8+gxOXqDerUQiAXAhKFKQLCe9LCHV9B23JRrCM
         FU/T7XY9nZfyJXvV++ZLmSjymvZlI9u0l58JTX4muUBBCNCBCmlHrJKVIOjsnaNznA8v
         ezZ7hxPjDB5+9mMpmT3iwpM7hsew0HC/JGBnM67k+WZFRpYWTWgGiaJU3+eoumYzrHrd
         it5fntcenundbGaN8RKlBbAWyphIjkjRyZ96MHDwaYuT69TJ8ZIYiA3fKaEITTezj/qW
         xgBw==
X-Gm-Message-State: AFuF++lgNIstdnErZZH/wDMFagUt6nBMSZyM/0HSWtcmbgW7Ua/7BQUx
	qBekIE5PKWSrdmrkWSbnVMtbwlFRjxr9r7d1Wod5QQQYfSFHj7gF+yAFxFEalipuQDfeUxpph4C
	J9p6jVe07imZLS9fc3duuVvyCATuVf14pd8iyucJDVt9Nxslp7U20w9RpnF7FZZcdr0h59+ZQKa
	7VYQ8OyOrUuT5GGStPOTJCjQgpf6GA5g6gwi2vZzD0enearss=
X-Gm-Gg: AYBFou3yCdmO3pAUDxPt6aJCH3kePTL8rHprq6leg4s3lPukYcDmYeN0jK4He016i4H
	VQqGkBao2g++9JI1qPdIPrwK7/mcDMDuHOP/8iwmZSeN7rY08YR9E3s8OT7/NfVuKIMqqD/N8uR
	7Uylsk2OvkudaDt6iqcnVMd85POGSeDT0+d37zoLJt2yl3XxGKIwbc19rOvvQAp+iNK/7JdfWjo
	DbwN1mguGKltpnbMvPcMrShdTAz79rCo2MDlqgn9sITmEi3oc+jbx+Gv08AoWPUeQbzhT0wloal
	mIMAJN0plflJtL0XBMBOgjE0OQHcaXsWAlsR940JlSlGDzWiAsULXN54FL1UlN7z9j2+XR2Pw3k
	b/l4L4jN5qiwB/loknIQF5bqktZPjX3Ybu+uRig==
X-Received: by 2002:a05:622a:309:b0:530:f959:a7a6 with SMTP id d75a77b69052e-5310d086067mr68866571cf.52.1789425021719;
        Mon, 14 Sep 2026 15:30:21 -0700 (PDT)
X-Received: by 2002:a05:622a:309:b0:530:f959:a7a6 with SMTP id d75a77b69052e-5310d086067mr68860171cf.52.1789425017573;
        Mon, 14 Sep 2026 15:30:17 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-530fa03dc30sm56084041cf.15.2026.09.14.15.30.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 15:30:17 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH V2 08/14] xfs: remove unused mp argument from xfs_rtrefcount_broot_space_calc()
Date: Mon, 14 Sep 2026 17:28:54 -0500
Message-ID: <20260914223007.1587017-9-sandeen@redhat.com>
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
 fs/xfs/libxfs/xfs_rtrefcount_btree.c | 6 +++---
 fs/xfs/libxfs/xfs_rtrefcount_btree.h | 3 +--
 fs/xfs/scrub/rtrefcount_repair.c     | 3 +--
 3 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_rtrefcount_btree.c b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
index e2950dbe2068..1983c8408442 100644
--- a/fs/xfs/libxfs/xfs_rtrefcount_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
@@ -311,7 +311,7 @@ xfs_rtrefcountbt_broot_realloc(
 	unsigned int		old_size = ifp->if_broot_bytes;
 	const unsigned int	level = cur->bc_nlevels - 1;
 
-	new_size = xfs_rtrefcount_broot_space_calc(mp, level, new_numrecs);
+	new_size = xfs_rtrefcount_broot_space_calc(level, new_numrecs);
 
 	/* Handle the nop case quietly. */
 	if (new_size == old_size)
@@ -661,7 +661,7 @@ xfs_iformat_rtrefcount(
 	}
 
 	broot = xfs_broot_alloc(xfs_ifork_ptr(ip, XFS_DATA_FORK),
-			xfs_rtrefcount_broot_space_calc(mp, level, numrecs));
+			xfs_rtrefcount_broot_space_calc(level, numrecs));
 	if (broot)
 		xfs_rtrefcountbt_from_disk(ip, dfp, dsize, broot);
 	return 0;
@@ -751,7 +751,7 @@ xfs_rtrefcountbt_create(
 
 	/* Initialize the empty incore btree root. */
 	broot = xfs_broot_realloc(ifp,
-			xfs_rtrefcount_broot_space_calc(mp, 0, 0));
+			xfs_rtrefcount_broot_space_calc(0, 0));
 	if (broot)
 		xfs_btree_init_block(mp, broot, &xfs_rtrefcountbt_ops, 0, 0,
 				I_INO(ip));
diff --git a/fs/xfs/libxfs/xfs_rtrefcount_btree.h b/fs/xfs/libxfs/xfs_rtrefcount_btree.h
index a99b7a8aec86..aeef004ffdc9 100644
--- a/fs/xfs/libxfs/xfs_rtrefcount_btree.h
+++ b/fs/xfs/libxfs/xfs_rtrefcount_btree.h
@@ -129,7 +129,6 @@ xfs_rtrefcount_broot_ptr_addr(
  */
 static inline size_t
 xfs_rtrefcount_broot_space_calc(
-	struct xfs_mount	*mp,
 	unsigned int		level,
 	unsigned int		nrecs)
 {
@@ -148,7 +147,7 @@ xfs_rtrefcount_broot_space_calc(
 static inline size_t
 xfs_rtrefcount_broot_space(struct xfs_mount *mp, struct xfs_rtrefcount_root *bb)
 {
-	return xfs_rtrefcount_broot_space_calc(mp, be16_to_cpu(bb->bb_level),
+	return xfs_rtrefcount_broot_space_calc(be16_to_cpu(bb->bb_level),
 			be16_to_cpu(bb->bb_numrecs));
 }
 
diff --git a/fs/xfs/scrub/rtrefcount_repair.c b/fs/xfs/scrub/rtrefcount_repair.c
index 2b939960c7dd..c78a6d2990c5 100644
--- a/fs/xfs/scrub/rtrefcount_repair.c
+++ b/fs/xfs/scrub/rtrefcount_repair.c
@@ -596,8 +596,7 @@ xrep_rtrefc_iroot_size(
 	unsigned int		nr_this_level,
 	void			*priv)
 {
-	return xfs_rtrefcount_broot_space_calc(cur->bc_mp, level,
-			nr_this_level);
+	return xfs_rtrefcount_broot_space_calc(level, nr_this_level);
 }
 
 /*
-- 
2.55.0

