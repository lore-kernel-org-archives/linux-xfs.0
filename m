Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D9C396D19
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 22:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789425024; cv=none; b=nEmaPf4IBmsxD9RxBeFmA4uMIwzVonSv961Bmkz3jF9J1MPyP1sAK43leVn0n+M4BSCJqsG4ChL6mW6xeG5Cq9dNjkCJYRuhuy4VXb8SU5XH1A77XbfqJEIAvHXwgFZ4QBa9ey7V+r42xfFgUmW63XER3JVyH6V9YRKEsMIGVcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789425024; c=relaxed/simple;
	bh=BiAnJeKw2QwRcDtp1z4Uz0jCBgEpTgyfqDNACBGK2Fc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H3AkCIjk2s2h02hpTha/9NqqlRVbbwbwG3ZgY0EvWL0RE8WRG6N9mtGfOjim4ZixaJOtxXZ8fJVGgARDB1nOf1NX8bRzn/fS7eGDx2xCm3KLms5ZaCH7dJeAj0K+ykQNs/vflAxL0zZucG4ppKTyqPkjIZvWtoo/JXrx2In3ooo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a2/3X27l; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=hjo572rS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a2/3X27l";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="hjo572rS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789425021;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yAOp7XKALD0CClNk5gXeMpaXQmoGGavTz5udWZ4Q7Ls=;
	b=a2/3X27l8cqoBaWcebxmgKgXUpbj8vcj3RdSvIHmP0nkerh+e9WNSLJJ2uHj0o0utYP55V
	Qo6JQY3g0Ke3UbpCYNPl2VUfvVhAxyUKJHh+i9To7jR12jUfQW+1lF7rHjJGmJpZgT/mCA
	8A4ep5SRwDsSsqltGOFkc5EMxtHNYu0=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-343-6ADxwt2VMq6bP6cMxV3qLg-1; Mon, 14 Sep 2026 18:30:20 -0400
X-MC-Unique: 6ADxwt2VMq6bP6cMxV3qLg-1
X-Mimecast-MFC-AGG-ID: 6ADxwt2VMq6bP6cMxV3qLg_1789425020
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-91064f6e75bso118342476d6.3
        for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 15:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789425020; x=1790029820; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yAOp7XKALD0CClNk5gXeMpaXQmoGGavTz5udWZ4Q7Ls=;
        b=hjo572rSHO3VuBz734jc7MO7qpHP3Fs7S1AH6TDNiw4WDNkWIBHyiuxlPqyvn0mEW1
         lKd8Dk8suKhmIAGZ9veDoZ3C2lpXlN+J1wm71MLAIOHR3KGvco+OQKTpsXkNbXqz4ji5
         IZVTlXide9XLH5b/5kN+AvO6JNhMOu5CLd6xQQhfyEGOWkTmv9ZGCGzXmhM1yZepNcrs
         TXX3Abxo1wXzbZysiTu59KidpM5QYSVAnGbNyryZYm3aXSGxwmH1k/5SsvWFl3KKCVyH
         Gaa9wgheSroU56eRySaSd9PHr0bm4A7Z0t6RkFFJQVsgXl7Fn/jZtJJiTRni4WyqRfvf
         /GPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789425020; x=1790029820;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=yAOp7XKALD0CClNk5gXeMpaXQmoGGavTz5udWZ4Q7Ls=;
        b=PEhLENKvOgu7yTNUQ4u1Bj5OCQZCTVnmqkIxnRgmJGlYGQs6cKWMzi8lUiV/kbZg5V
         rZU45zN+UnpEyxq4aTwsos3qjFmgX/YdP8f26H9B35Qo0nKOUBEFDd/OQaq3+Ffi8kPU
         UC/o+64RqPgNLu93gukQn49q2qj4B+xqGR44yFYEVwGTi8XxmFNQGA2ILygyj4ZsoNCH
         2MuPmBbBgQZmYdY8g3mGMbTiL1c6PzrZsf/Tg8begD0GSj3ERTl73S1yc2ICo/cX1s8w
         ejAVTPZwud1J6f1Cp0MNyFRbW34g0HBsGPenLRPUKYyX+k5HYC0mhwA/yF4VuGE5iEFJ
         Z6LQ==
X-Gm-Message-State: AFuF++lgWe54QMtpJiQdBo+H6LhfyB9JpK01oAcqSKX/14t0hBraWfvW
	GH5RGjzyNr9vLCtrT1Q0zm9+mSFMDV1lbK2vT1rvKe6wJgeBZGd/H8YdR9FfP0ig0fHPOX+HM+L
	gNNt7PtkCpIV5rINxYMGFEFmhxQO7GRCXBFVc1zOP26j89TEIPCUYlZ4iEoWCZHi+xDKT9Ft/Zf
	1D/iNBruaavykBsSwpiM+O8uh6kgo9Va0LIjqGQb9rZOu+BBE=
X-Gm-Gg: AYBFou21H9PUaVJR6tEK43+n+5v86mCXx+eetMDJV70/AnAe/saN5zaU00+ZHV3bqSe
	uKlamiBG5Ywn+kpdHxrS+VFHlTVeVpwf15YhvGwED8Z8QTgRUHHbJ7kCJSyQXF7zH5BDoPEQFFc
	VBm95MKT9YUsVxP1Ui7WdC5Z1k/WYoRyFwBkQf70IXfwaeXRniJ+cnCW4zeT6v8NdTReCpckmo0
	HMKr99bfFpKRlnbMdm6LfrvBhkPeCX7jPM3ZQnCcEmJ0HGWPq4lG+tjCOpowBigJohO49V4mfAn
	mmpsi/4Ntb9a0EpZH9j4YKxucYACYC3Yw9gYYaK2jMxTjPvYEzQ+8iqoZXWgJWJX6RchrXaWHSx
	racQKGK0BVNmgRtOy2KEP3GtsintslAOxKhsBww==
X-Received: by 2002:ac8:7d56:0:b0:527:7a5b:ca67 with SMTP id d75a77b69052e-5310cf40942mr70486611cf.20.1789425014985;
        Mon, 14 Sep 2026 15:30:14 -0700 (PDT)
X-Received: by 2002:ac8:7d56:0:b0:527:7a5b:ca67 with SMTP id d75a77b69052e-5310cf40942mr70485471cf.20.1789425014181;
        Mon, 14 Sep 2026 15:30:14 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-530fa03dc30sm56084041cf.15.2026.09.14.15.30.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 15:30:13 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH V2 05/14] xfs: remove unused mp argument from xfs_inobt_rec_check_count()
Date: Mon, 14 Sep 2026 17:28:51 -0500
Message-ID: <20260914223007.1587017-6-sandeen@redhat.com>
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
 fs/xfs/libxfs/xfs_ialloc.c       | 2 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c | 1 -
 fs/xfs/libxfs/xfs_ialloc_btree.h | 5 ++---
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 58dac4d505ba..19b513b11692 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -615,7 +615,7 @@ xfs_inobt_insert_sprec(
 
 	trace_xfs_irec_merge_post(pag, nrec);
 
-	error = xfs_inobt_rec_check_count(mp, nrec);
+	error = xfs_inobt_rec_check_count(nrec);
 	if (error)
 		goto error;
 
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 1376e8630449..1f0bace2f144 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -687,7 +687,6 @@ xfs_inobt_irec_to_allocmask(
  */
 int
 xfs_inobt_rec_check_count(
-	struct xfs_mount		*mp,
 	struct xfs_inobt_rec_incore	*rec)
 {
 	int				inocount = 0;
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.h b/fs/xfs/libxfs/xfs_ialloc_btree.h
index 300edf5bc009..e04c63c66f39 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.h
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.h
@@ -57,10 +57,9 @@ unsigned int xfs_inobt_maxrecs(struct xfs_mount *mp, unsigned int blocklen,
 uint64_t xfs_inobt_irec_to_allocmask(const struct xfs_inobt_rec_incore *irec);
 
 #if defined(DEBUG) || defined(XFS_WARN)
-int xfs_inobt_rec_check_count(struct xfs_mount *,
-			      struct xfs_inobt_rec_incore *);
+int xfs_inobt_rec_check_count(struct xfs_inobt_rec_incore *);
 #else
-#define xfs_inobt_rec_check_count(mp, rec)	0
+#define xfs_inobt_rec_check_count(rec)	0
 #endif	/* DEBUG */
 
 int xfs_finobt_calc_reserves(struct xfs_perag *perag, struct xfs_trans *tp,
-- 
2.55.0

