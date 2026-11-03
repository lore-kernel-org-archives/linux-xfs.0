Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.227.129
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793716914;
	b=Wxi1EJLTqrO5tE8el7ucxYKtRSVqMpCw2YgTMvakm1lA3WhvdbKXkpVTttYN4nvD9qKw
	 o2juydKmUiQWYE63Wm/RTmyCoVaHDAbIKpEbiDIkfXLHp5sEmhkJHumNCaX7ZnDZ4Ucl2
	 920WLzy/gWfNpxwTPs21gHvxYewneYUIAVwornRf1e7PnPKxcVnGluL64LcRtRxAWfSKh
	 /PGIHTW6y1HN7CTCFGIV+F+WplmJ658kvwP/tdyH7Ok3bD5RcOHCXlqAO1v6Pi1+E8Pz7
	 TqrFTscq4I2oAixiS/tZUtooNuPV3Y5O7kyV80xgM5gjVTvsh9Sbj7847qZrmraSWcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793716914;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=wAZrtUg1BsyNyokf7QV/XjN8JssSgTHPtRi+FaZ4x5k=;
	b=D3vP/LuaJKdBEsXLpLw666l6eM8tAdEJbBc/TKXnNAp3tS6VISg4YLhbmrKYripfQoqD
	 yQOiRVcP3uLhawcJy/4XESEgKRNn8iZ5f/SdwsSEcep/X0ymF5cxsdKP9gwH+fpHS9Tao
	 GpuGoXCEaObWqiLS486ajET2EYwjxYrdweVNXoKp4kvJNIRsc/3F9lblP5PptttnqUxdR
	 v8K/1ljIqkK/m3itJuU8aPh/H05bewvCrrY3rLKn6vfwr6zkX3MMxeVi33o/g/v1aWq2U
	 bIpDps8CrjgJO4hseNvVwHtg5nvOW6MC4jHxLoUz2KELrl2S6SsN2rs/S4WsG9UOOfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EcmgInj2;
	arc=none smtp.remote-ip=74.125.227.129
Received: from mail-pj2-f1.google.com (mail-pj2-f1.google.com [74.125.227.129])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C77F606A326
	for <linux-xfs@vger.kernel.org>; Tue,  3 Nov 2026 14:41:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4C77F606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EcmgInj2
Received: by mail-pj2-f1.google.com with SMTP id 98e67ed59e1d1-3ab37ea4798so111210a91.0
        for <linux-xfs@vger.kernel.org>; Tue, 03 Nov 2026 06:41:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793716913; x=1794321713; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=wAZrtUg1BsyNyokf7QV/XjN8JssSgTHPtRi+FaZ4x5k=;
        b=EcmgInj28Z/xNpXnXxOAon2wrmz0QcoPVbtbQ+dQ/l1NrXqh4Jt+hVHNv/Tq10DxEa
         0rs6/T+PYEbYVQ/O/13R8nO2zv7Ta3OCcaXdg0sH/i8rWZDINWSu0X5oXNl39Mx4TJXQ
         As+s+MyHC4cr6xfWL/B6dVsNW48MlIqxaa0sJlXoKkj1cspZTkMiPSJv73sF1bRx2L/8
         hAct1/B3l2XjJgTIgnfdCxzQcHrlXDe6VAlY+JKXxtU1LZ/IFRTOQ8uxVlQj6mbKCK+V
         wP7cBPxIeuvcP7XK09bxQK/2VbivpumqkWm+gg8r5UcZdiElfM8Bpi43DVGmD6USUxvh
         2BRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793716913; x=1794321713;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wAZrtUg1BsyNyokf7QV/XjN8JssSgTHPtRi+FaZ4x5k=;
        b=CeZmbMEAS4c9m8swCTI3r+IDzr237snJNaxt99I1JIj9vgcxoV80NBc9q5MmTUN3xz
         I6x4hJ6xlGyTlm0PVlWDPSc4BMI1DQ+5YTyQ2qIgvCus821Zc7Enc3pJmEqPSPegRrBr
         gwdjvyqWbRL5kAbtCYP75/VGYk4A3J9u8QT0mtVtIn7YiC2zjZX3gNYDJJPHSvx0Ehdy
         tnBJJoiVBzZm8I02xR69rBqN2yReRCmlwwApYIBA21VsAarrdDPhZyFziX/yMDE3/lsE
         yUfZhBG6MWKdP+hrwJYU4DsKhS7Q8vBRbF9lArfE37Mysi3jZ6IvOFs0t7FwbDIh9rl/
         lCuQ==
X-Forwarded-Encrypted: i=1; AKwUvBz7YfP+5dKyQPV8AR6f0NK9rCIcRAV5EbSnzMYbjAJd9N1Rc93hvZdCs+5qclaSyvu+XiqSbXaMGPU=@vger.kernel.org
X-Gm-Message-State: APuU4Z+bfL3omU5uTV3K4APsDRnQ53LL5WlgytRUn4y74OwR3W6h+3Jp
	yjUrlPgPkEstnml1Z+kv+Ux7iAvyeKr1EI1OTgOHS/c4uYL8kDwSJk8l
X-Gm-Gg: AYBFou2RRkKcVVEeccCCz5tDgCTJh9NGiNmexh3YMBRXgApwoygKyqiiKZHcs2zA2yU
	vycQlf5438k5lZ76u6g56ZyFabqFNtMn76DqmYtShm2vJbWUbfHT8Y4JoX5Zf8W5Ha+IjtzV9+u
	3GwrNAyE65eAArZM9JvVRLYEvoe+jt9UEfmOaPaywbDAH7EX9XD27EHy+kdMLxIf6+64h2nEQeT
	c28wjU2w3WOS6eoOF2nPrlxBBnxQd7EvZIU2sH0MZOpx9kMIoYGXJizM9VnjRbBL6uTeZ/0KIax
	RhOpcxy8hHVN4bQoTonHg7eePi++sd0C+Cbgx88DjQ+ASs8t0Qsgv3oIuPytl3I6hfJRO39PPE7
	8D7tMX/ewaKxbzjlwonK/78GvV11ezKrR3eUVA+BoYpz21Xc/Qd6BcNtuypvBNyYTjWnDiiKxR5
	pUcjpsW+RQoffg3HHrGN/6WWMzdpccorvDy17+K0CHCCkhLm0NoQ0ansWGCS6ChrSXqZlkA7zE/
	VEFsXhfgybICj/oLD25GwDU3FVs7bGijLc+XKvwloPlT3WkhooTObwfKlSODvyEouqCZn0TiHKp
	ma3ceoxXzTO2UH6De8F+vNxlpputCGWktqlwobyIos8i7g6io0Arrz7PxqcwZKvB/1kzRWjkjFf
	RXE7E7A8CM16uelWTEEgJs3+W6j8pMNElpeYrGEzIW3ppWqOS8JP3hH/1tX7r9oCFQQ==
X-Received: by 2002:a17:90b:1c87:b0:3a8:195f:186 with SMTP id 98e67ed59e1d1-3ae897ee656mr9705547a91.42.1793716912532;
        Tue, 03 Nov 2026 06:41:52 -0800 (PST)
Received: from localhost (ec2-18-182-19-4.ap-northeast-1.compute.amazonaws.com. [18.182.19.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae87f99899sm11006962a91.2.2026.11.03.06.41.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 06:41:51 -0800 (PST)
From: jianyungao89@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Jianyun Gao <jianyungao89@gmail.com>,
	stable@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Eric Sandeen <sandeen@redhat.com>,
	Mykyta Yatsenko <mykyta.yatsenko5@gmail.com>,
	Yuzuki Ishiyama <ishiyama@hpc.is.uec.ac.jp>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org (open list:XFS FILESYSTEM)
Subject: [PATCH] xfs: fix spurious len double-counting in rmap three-way merge check
Date: Tue,  3 Nov 2026 22:41:44 +0800
Message-Id: <20261103144148.14430-1-jianyungao89@gmail.com>
X-Mailer: git-send-email 2.34.1
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jianyun Gao <jianyungao89@gmail.com>

In xfs_rmap_map, the left-edge merge path already executes
ltrec.rm_blockcount += len at line 1119 before checking whether the
right record is also contiguous and can be merged.  The subsequent
overflow guard therefore must compare the already-incremented
ltrec.rm_blockcount plus gtrec.rm_blockcount against XFS_RMAP_LEN_MAX,
but it incorrectly adds len a second time:

(unsigned long)ltrec.rm_blockcount + len +
   gtrec.rm_blockcount <= XFS_RMAP_LEN_MAX

The extra len makes the check too strict: when the real merged length
does not overflow but the inflated value exceeds XFS_RMAP_LEN_MAX, the
three-way merge is rejected and the code falls back to a two-way merge,
leaving the right record unmerged.  This produces rmap btree
fragmentation but does not corrupt on-disk metadata.

Remove the spurious len from the overflow check.

Fixes: 0a1b0b3855cf7 ("xfs: add an extent to the rmap btree")
Cc: <stable@vger.kernel.org>
Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>
---
 fs/xfs/libxfs/xfs_rmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 14aef87837a9..c2b2f8e7502d 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -1120,7 +1120,7 @@ xfs_rmap_map(
 		if (have_gt &&
 		    bno + len == gtrec.rm_startblock &&
 		    (ignore_off || offset + len == gtrec.rm_offset) &&
-		    (unsigned long)ltrec.rm_blockcount + len +
+		    (unsigned long)ltrec.rm_blockcount +
 				gtrec.rm_blockcount <= XFS_RMAP_LEN_MAX) {
 			/*
 			 * right edge also contiguous, delete right record
-- 
2.34.1

