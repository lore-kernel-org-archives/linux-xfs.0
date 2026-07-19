Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3522C390231
	for <linux-xfs@vger.kernel.org>; Sun, 19 Jul 2026 11:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784460627; cv=none; b=fOD53GODiRlyJtibGUkXz74smVSOqTk2ac5bEZKfgA4LpA4t0Vlfq+xx+J0Z6QT1/b+3MNitmumw/8i9RkdPBo2EirNHDRp4koc1xPEYwuK242tEOipk4MP/Pc6+VoC57ZSBa+QPDbpbRXRtW0hhXxJiE1BCGHqobMbwus5Lm48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784460627; c=relaxed/simple;
	bh=SYxC6gHeEKBUkXnFInBtIwW4Ohq6RLaRXfHMhOvNkAY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=M0g6cghBDrZ8fRZ3QDwKoNyLPkiafBoTpcsgj9msBOFOYyRsW5gdFSV4hXcXwbrSS8TIrF1HHSnWbkkHsM7AoxJUYyXVbpbMncv5auELGWYjRoQ6qJhwpIyqRmrYsxrdtDDc6rRDKy/slAzGgrVbeGlHuBlxARUSys2DC4W3OZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EcesRRev; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EcesRRev"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-38e4beb7cc0so2027399a91.3
        for <linux-xfs@vger.kernel.org>; Sun, 19 Jul 2026 04:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784460623; x=1785065423; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=2ymuw3BJTwSkDAfye/S4U8tel+GPGU10HeEPToWWu4Q=;
        b=EcesRRevc1EV45kD6tGMjX1GhjRGgBe7AXL0lNAJmFZpVDjdmGLYMq5dKc/XS6WrMs
         RuNmEyzgi+dySgcLtPcDpX7qNEXqRrGdZ82MuoWao3/WzDdDrDpzpmkUFCANCf5BvstF
         Vzr1Zfue8O2CmDXT8nNlla/wS/hUvrVZOWdaLXxKx56akovPPIVwLa31cJ+6VQr3r2Mq
         4NK0OeTk48r8xoxd3FMTS+iLqLaUHZFUhMgRAzoe1g1Dle4x4l8KpInemq148Wgn1pk/
         z0y7lmuuqadW/F9Tu6tg5C8BbRcU/FB2O5V5OeuMJvr00Lc1E4Cz2QowknNtYuYLYmTY
         PRvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784460623; x=1785065423;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2ymuw3BJTwSkDAfye/S4U8tel+GPGU10HeEPToWWu4Q=;
        b=UgU1KiH/+dhsHJKgjVa1zfAG5QvghxYl+L3+e1tjmg1B+9Xytja0tNjGYybeWNna25
         STt+2vptmSwu+9vq8Icf1XkXlmIlhIbKXHs0xWAiNGRKwjiyc16wglVdVEvG8iHOSZJq
         XdjL4/t2Js2H58f3zfdYfAvROX+cGpTMT0Uyp+kHwL1z82OT2a6tcZ39qe2PbrtoAMyz
         ++uL9X6iVpzgCbXy97YQ+44AfXS1sfg6+VZX9piezKxnGlcg0aajhFoauCm8up8O2pAW
         VkYkjKqa5N9eEH69Fnt3f5u/pEEBf/TNE7ht60erd1W5/dNZUvri1oloqLJ7JkfM0fdg
         Y+IA==
X-Gm-Message-State: AOJu0YwphHLvTh+TKw5XQQRD6l3WNUVah9MNmVSb8w+RPJob2vPQ2srS
	/MF5cKHhf3/glu55q87kCt+m6iiplM/4h6sPu/vq7MNil8T1hl6kM7QV
X-Gm-Gg: AfdE7cmkE7FNigec/12vMwycAX1rCzQhD8nNfLBy18B85KmRxGBYEo7+hNbCXxgBcgT
	Ye1aAFRJ2MtacFoR2SvNRxk5fyfitLouoef2NIjR9LbvQZK2xqtHL0FFRe0fEHCOo2hRD9gJalV
	f3n1B/Ma1JTFz8Dhvx+i0H9BlKnw8QZB0vDRGjfd8hxvZPyi0JgKZ/lPpqVgYNNsqZA4PoGVBEo
	FBthp/pJhp9qcSFZ0pabIXk0yb1gbcb2bRWRBhBS39gj1V3e6/HjfCvLsEopSAaNwcpip+s76FU
	sK7crYDKpnEgI9gKIfET275EHsYQdBUUCMaSVuEBMwgo3aD1Rer6n043y7h8pvreWovlU4l3Bs3
	IUT5Hh7tNFVnwJ+NMK6LxmhlXhqn8hx3NIylXkrfH6V2hAaH0+tAWR+BqO6MgUF+2R8dMr8JJ4D
	7MatQUSqf782LnAZ0QdcijlDg4OvVUr0hbY17CNl6YUkqkN5YHn9YyZX6HjA==
X-Received: by 2002:a17:90b:510c:b0:38e:bfe:81e9 with SMTP id 98e67ed59e1d1-38e4b41fc48mr10046443a91.1.1784460622647;
        Sun, 19 Jul 2026 04:30:22 -0700 (PDT)
Received: from fx.tailc0aff1.ts.net ([206.206.192.132])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13ce2ddfb35sm22035031c88.14.2026.07.19.04.30.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2026 04:30:21 -0700 (PDT)
From: Weiming Shi <bestswngs@gmail.com>
To: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	xmei5@asu.edu,
	Weiming Shi <bestswngs@gmail.com>
Subject: [PATCH v3 0/3] xfs: add a log item verification layer to recovery
Date: Sun, 19 Jul 2026 04:29:20 -0700
Message-ID: <20260719112923.226550-1-bestswngs@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Log recovery rebuilds each log item from the ophdr regions in the journal
and then casts those regions back to their format structures to drive
replay. The region layout it trusts to do this - the item type, the region
count, and the region sizes - all come from the log, so a crafted or
corrupt image can present a malformed item that recovery dereferences.
The reported case is an XFS_LI_INODE item that declares two regions but
logs only one, leaving ri_buf[1] NULL and faulting mount-time recovery in
xlog_recover_inode_commit_pass2().

v2 rejected an item whose logged region count did not reach the declared
count with a single check in xlog_recover_commit_trans(). As Dave pointed
out, that only found the one missing check and left the comprehensive
verification of the recovered item structure undone, at the wrong layer.
v3 instead verifies each item where it is first decoded from the log, in
xlog_recover_add_to_trans(), before that data is used to size, build,
decode or replay anything:

  - When an item header is decoded, resolve the item type and bound the
    region count it declares within the minimum and maximum a log item of
    that type is formatted with. The upper bound keeps the region array
    from being oversized; the lower bound stops an item that declares fewer
    regions than its replay code indexes, e.g. a dquot with qlf_size == 1
    that still reaches ri_buf[1]. Reject a continuation that has no region
    to extend.

  - When an item is fully decoded (the next item's header arrives, or the
    commit record does), confirm it received all its declared regions and
    run the item type's verifier, if it has one.

  - Add the first per-type verifier, for inode items, and drop the
    equivalent open-coded checks that were scattered through the inode
    pass2 path.

The generic checks bound and complete the region layout - the item type,
the region count within a per-type [min, max], and that every declared
region arrived - for every item type. The per-region size and structure
checks are type-specific and live in the ->verify method; this series adds
the inode verifier, and the other types can grow their own the same way.

Not addressed here are the ->verify checks for the remaining types,
including the non-header region size checks and the content-driven indices
that the region count alone does not bound. Two such cases are known: the
btree-root fork formats convert from a larger in-core form on replay, so
their region size does not bound bb_numrecs in xfs_bmbt_to_bmdr() and the
rt converters; and buffer replay walks ri_buf[] by the blf_data_map bit
runs rather than by the region count. A buffer ->verify and a bb_numrecs
clamp are left as follow-ups.

v3:
  - Reworked from the single completeness check in
    xlog_recover_commit_trans() into a verification layer at the
    region-assembly boundary in xlog_recover_add_to_trans(), as Dave
    suggested: a header check at decode time (item type known, region count
    within [min, max]) and a completeness/structure check when the item is
    fully decoded, with per-type verifiers hanging off
    xlog_recover_item_ops. Added the inode verifier and a continuation
    underflow guard.

v2:
  - Dropped the piecemeal per-check validation in the inode pass2 path.

Weiming Shi (3):
  xfs: verify log item headers when they are decoded during recovery
  xfs: verify recovered log items are complete before replaying them
  xfs: add an inode log item recovery verifier

 fs/xfs/libxfs/xfs_log_recover.h |  17 +++++
 fs/xfs/xfs_attr_item.c          |   4 ++
 fs/xfs/xfs_bmap_item.c          |   4 ++
 fs/xfs/xfs_dquot_item_recover.c |   4 ++
 fs/xfs/xfs_exchmaps_item.c      |   4 ++
 fs/xfs/xfs_extfree_item.c       |   8 +++
 fs/xfs/xfs_icreate_item.c       |   2 +
 fs/xfs/xfs_inode_item_recover.c |  89 ++++++++++++++++++-----
 fs/xfs/xfs_log_recover.c        | 121 +++++++++++++++++++++++---------
 fs/xfs/xfs_refcount_item.c      |   8 +++
 fs/xfs/xfs_rmap_item.c          |   8 +++
 11 files changed, 221 insertions(+), 48 deletions(-)


base-commit: 8c13415c8a4383447c21ec832b20b3b283f0e01a
-- 
2.43.0

