Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C6831F9B4
	for <linux-xfs@vger.kernel.org>; Tue,  7 Jul 2026 18:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783447378; cv=none; b=dPD3Z4oMh2IOWIRf5IQXGgVINvNPfRVGGyW8wfCQLqZxFrI4abuY7JN3ys8eLW+B9xne1XXoJ1Q2pNnHiRPMtk5BRaGbB+SHFvO8UcUNd2mNqB2/sSe/DEqjNtOKc/ACJPbH42vU9gXoV3TzvUFwEfC5sfWRSQyvOnxH6cEM8Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783447378; c=relaxed/simple;
	bh=ciAoel1O+HvyWV3G/BL2s+jwL5JjfElEXWANvEXcVoE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fGs+apPPU3FrDF3VanovQD7X5479aUp35PfGmRl+TFOqb6em4SfhOf+Uz0p7j17jG973dQ++hxY7cwf2c2/1SutUe7pAGcdqF8a883TFJQ2xv5UI/qgTAIDZvj9NZ4jeAPMPbe8FyIv/iOWqgnqYLG2a165IyQ2hW712W2ncH/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JWCNfA9a; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JWCNfA9a"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-c966b9ee9cbso2159787a12.1
        for <linux-xfs@vger.kernel.org>; Tue, 07 Jul 2026 11:02:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783447377; x=1784052177; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xbQWo2Jw7nEFsOrQm6lAp74HBAcbYUyqspC1ko1fdco=;
        b=JWCNfA9aC6xXHTW1/Useek21UOE8tVayhNGHFdRuUkENQ4ld6H4IaQqZwwnOzQHM/N
         uyCNq3cgjjRI96nUD9i0KMy5zf1aOIQ+PzvYTQJ7Fk4l6WMrPkEVzumEv0YgRGblXNOX
         5Y/548hcJMpNALKnfMR+XDen6kg1HplZqzxQz1Xga0oTlEheCiPPdGFFNg05xLc0GNru
         mBzYRauHe83mHt4DG4cLHXb5jTl7IkP82wiUvRsDXTUGVfPeuXIOmJBxszl5swz80Rak
         P53XJIG91h2Nh38AZAC8UvGlQXim92FMvZO8L/rV92vGd1nlTczHlKSaFtCT4MOV98ZQ
         2u8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783447377; x=1784052177;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xbQWo2Jw7nEFsOrQm6lAp74HBAcbYUyqspC1ko1fdco=;
        b=pvdQhYtYsdPln+LXx8dyJ8c2KKBntmCONnFPF+SeulofU17sSrYQlMAsNXruxu1sxi
         OFRFV6mqRNgpXKIGgy0oZRYIXKMHDVaXb8VTetOQj1QXv+EmuYLBtpl+/TcnvfgrUjUm
         /tjOM286LOzH4IYd+sVZEl1eQarFKF0Me0RCH8WwH53qWPfSvTl5zPSxjuZwebLcQDrV
         hOpC8vW0BqLNZfZlYB+rpnw+b4Sy4YrBF7psX4+yQOkLGaeDYS8bY4dk+04B1O09Par3
         lZ41rRi2QKh3h53S30TGWu/nYyVZkqXFzvjm6grQtTpEqeAQ2fWR3o3VcCjuGarmEt8U
         IRpQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp7/hSQ0kRwHRvg3dE9/wNCQqHNvGzcbGIg4HKLiPvSY/f8Vg7ABeZds+fwoC29TKIBmtpw1ac8v6Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YxB8Ql1ygl2NWxRvDtdnOSzXgh4/I5HWywmcxfqj0iAhk4iDES+
	bTIvD45OsgmKskHWsCXUpERRXL09t78E8JGohbnZTOPmfg39aSdEayp2O9TUnicTy0Q=
X-Gm-Gg: AfdE7clXqLiVyuUBw4pBIqG+Re7nDkRQQvOCFDfs6Gx24dfsnPlqmN3kGN622gV+4Lg
	Oi+VutIxN/DIB/nfMGzRgMd1ELM4/il8jzGFqTuprleA0T7IMxGRwws0j7x2ZoaGfnoPpd/f1gl
	Pj7TvG+bTJJcwbUyUIXRv8qIZb57USaZuUTMlCjBu+5oJaYN9GRVks6mj2s/jjSJFnh0J4ACvc1
	2npu+sBoZNz/G8zEOrGM0HjN0xC5iUMQLl2DcTQaJ6mIuoGs/oyQ1yw5e/+eodTQGj087/r8adA
	saJuT1tWvWwGPam5anHmrSEsg0iZjOe9UzW9DXWrPjv3DHb4NX4+zjYxuH9ju2QH7YtogpU7GSH
	JxEvGK32KITGlVrzFKn8pQtqe0MWEFCg4ZUppGw18s+XdSTuP6NA5TTMaM0qaXGulVvAOGwM0HW
	tNthz3wlqAzVdu9uATE0hFz2X3gF6LXkI4Kmv3aHHDHBYPtNR7ENrYqV2jfg==
X-Received: by 2002:a05:6a21:6e46:b0:39b:d937:8020 with SMTP id adf61e73a8af0-3c08eed0254mr6855077637.42.1783447376468;
        Tue, 07 Jul 2026 11:02:56 -0700 (PDT)
Received: from fx.tailc0aff1.ts.net ([206.206.192.132])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13b659d8da9sm16299294c88.14.2026.07.07.11.02.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 11:02:55 -0700 (PDT)
From: Weiming Shi <bestswngs@gmail.com>
To: Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Brian Foster <bfoster@redhat.com>,
	Xiang Mei <xmei5@asu.edu>,
	linux-kernel@vger.kernel.org,
	Weiming Shi <bestswngs@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] xfs: reject attr leaf blocks with inconsistent usedbytes
Date: Tue,  7 Jul 2026 11:02:38 -0700
Message-ID: <20260707180235.1142581-4-bestswngs@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xfs_attr3_leaf_verify() checks each attr leaf entry on its own, but never
checks that the entries' nameval regions are disjoint. A crafted leaf can
point several entries at overlapping offsets: every entry passes the
per-entry check, yet the summed entry sizes far exceed the nameval region.

ichdr.usedbytes is kept as the exact sum of the entries'
xfs_attr_leaf_entsize() (see xfs_attr3_leaf_add()), so for such a leaf the
real sum no longer matches usedbytes. When the leaf is later repacked,
xfs_attr3_leaf_compact() resets firstused to blksize and calls
xfs_attr3_leaf_moveents(), which subtracts each entry size from firstused;
the oversized sum underflows the 32-bit firstused and the following memmove
writes out of bounds. The same repack runs from xfs_attr3_leaf_rebalance()
and xfs_attr3_leaf_unbalance(). The only guard is an ASSERT, which is
compiled out on production kernels.

A single setxattr() on a file with such a leaf, after mounting a crafted
image, triggers the write:

  BUG: KASAN: use-after-free in xfs_attr3_leaf_moveents (fs/xfs/libxfs/xfs_attr_leaf.c:2788)
  Write of size 400 at addr ffff88802b187f98 by task exploit
   xfs_attr3_leaf_moveents (fs/xfs/libxfs/xfs_attr_leaf.c:2788)
   xfs_attr3_leaf_compact (fs/xfs/libxfs/xfs_attr_leaf.c:1790)
   xfs_attr3_leaf_add (fs/xfs/libxfs/xfs_attr_leaf.c:1563)
   xfs_attr_set_iter (fs/xfs/libxfs/xfs_attr.c:556)
   xfs_attr_set (fs/xfs/libxfs/xfs_attr.c:1244)
   xfs_xattr_set (fs/xfs/xfs_xattr.c:186)
   __vfs_setxattr (fs/xattr.c:218)
   vfs_setxattr (fs/xattr.c:339)
   __x64_sys_fsetxattr (fs/xattr.c:774)

Sum the entry sizes while verifying and reject the leaf unless the sum
equals usedbytes (so the on-disk usedbytes can be trusted) and that
usedbytes fits in the nameval region [firstused, blksize) (so the trusted
value cannot drive firstused below zero).  Both checks are required: the
first alone can be bypassed by forging usedbytes to equal the real sum, and
the second alone by forging a small usedbytes, so only together do they
bound the actual summed entry size against the nameval region and prevent
the underflow.

Fixes: c84760659dcf ("xfs: check attribute leaf block structure")
Reported-by: Xiang Mei <xmei5@asu.edu>
Assisted-by: Claude:claude-opus-4-8
Cc: stable@vger.kernel.org
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
---
v2: drop the inaccurate scrubber reference; explain why both checks are
    needed. No code change.

 fs/xfs/libxfs/xfs_attr_leaf.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 86c5c09a5db4..9814dcfbd7ac 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -300,7 +300,8 @@ xfs_attr3_leaf_verify_entry(
 	struct xfs_attr3_icleaf_hdr		*leafhdr,
 	struct xfs_attr_leaf_entry		*ent,
 	int					idx,
-	__u32					*last_hashval)
+	__u32					*last_hashval,
+	unsigned int				*usedbytes)
 {
 	struct xfs_attr_leaf_name_local		*lentry;
 	struct xfs_attr_leaf_name_remote	*rentry;
@@ -344,6 +345,7 @@ xfs_attr3_leaf_verify_entry(
 	if (name_end > buf_end)
 		return __this_address;
 
+	*usedbytes += namesize;
 	return NULL;
 }
 
@@ -376,6 +378,7 @@ xfs_attr3_leaf_verify(
 	char				*buf_end;
 	uint32_t			end;	/* must be 32bit - see below */
 	__u32				last_hashval = 0;
+	unsigned int			usedbytes = 0;
 	int				i;
 	xfs_failaddr_t			fa;
 
@@ -410,11 +413,21 @@ xfs_attr3_leaf_verify(
 	buf_end = (char *)bp->b_addr + mp->m_attr_geo->blksize;
 	for (i = 0, ent = entries; i < ichdr.count; ent++, i++) {
 		fa = xfs_attr3_leaf_verify_entry(mp, buf_end, leaf, &ichdr,
-				ent, i, &last_hashval);
+				ent, i, &last_hashval, &usedbytes);
 		if (fa)
 			return fa;
 	}
 
+	/*
+	 * usedbytes must equal the summed entry sizes and fit in the
+	 * nameval region; otherwise a later repack underflows firstused
+	 * in xfs_attr3_leaf_moveents().
+	 */
+	if (usedbytes != ichdr.usedbytes)
+		return __this_address;
+	if (ichdr.usedbytes > mp->m_attr_geo->blksize - ichdr.firstused)
+		return __this_address;
+
 	/*
 	 * Quickly check the freemap information.  Attribute data has to be
 	 * aligned to 4-byte boundaries, and likewise for the free space.
-- 
2.43.0

