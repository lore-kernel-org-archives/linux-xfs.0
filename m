Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793275806;
	b=oHQI+FR/v/+sfz8sMTnM9Gd2ub1TdXS8KFfavwazhxbwkC0nQKUwSCRH6rPhRiFemygs
	 jB2QTMzAu1gy/QpTocbBxk/D8Lwfy8SxLMN1ILoHYIpwkZkjN3YHGUXO/c4x1tVFOYpYJ
	 +LD0dZ1GvCW1gplrOY0zE4y6S4kmAaLvp+scZLVhy3Uv6XXEJEpYlApFWnCYbduzaDIK6
	 sFiSS1/K0NvZsgA4kh4B0pn20fr7hdlOgH6kGQWjYC0ubFJypiHwbfiG60luiyrGuIvBR
	 KVCSt/HtScd4/SfV7Mz2E4UxOeWg2OMr8+wgR6GJA/JdNLz0BnF/cZY67bUukb0mtyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793275806;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=OyEuLUlv+Psfsjb+wsIoeV+6QCa2Vk8RrQnXvyeIQeg=;
	b=serOc9QzjeGZnss/6AcR0LhO4+dWHlPO+dz7yY16jkGfQF3dIbBGJTUsW/K6wYlz6c98
	 zJdg+V/M/nxvwPt2PEkkwlC4ePSjFwgpriCyfyppDuVzi7dfmKUt3gJVkQCoNiGKsjKld
	 Z3OXeMob706uMiihZL8NxH/a4nnJEsI9T0W56mitIrKD34VMYdeWQiaZG//Nuo0ZJOD9X
	 3qOxS+WeuWrF8ULa6pVK4RPO/0jjqC8uWs4r8MDt9mzfGVtOb0PoY92wY2XwE62S2st75
	 wrMSaREL4n5HSIkCXuiNyJmT9/7X28zkAizQdGZeIt/yx1J884QbYuKWnggAiZhsnHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bm+KiyfQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A1E606A31A
	for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2026 12:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bm+KiyfQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B071F01829;
	Thu, 29 Oct 2026 12:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793275806;
	bh=OyEuLUlv+Psfsjb+wsIoeV+6QCa2Vk8RrQnXvyeIQeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bm+KiyfQxRwc28x8yvF4SXJmNH9YCCf5tF4mRU6wrsalWi+3Dsvl9OeRb1/ZQ994B
	 e8Cc5rtnpsnzOrLS5G1zFHKgwywPZGyackqgQ/4R6Y/c6NPA+O6SvTdt3nEJuT++X7
	 lQmoCbD/Af6K05h780j3XchxYjO7IjMYbN2inJqB0dmm/OaPZyew66diIbm3+wwI5b
	 O11L7+MR8InBxQ1XcBt6IdWOBV29W5+qoyKAIxLkc/bA4M2xrqvuLJFWw1cuvD9Oxr
	 pi0jWj5H671YZPsoOmIczkDIPFvXrMIr8FpFWG6AKFBv2bY5BucXWY7btvpMM5OsjS
	 cvk7zkcEC1gZg==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	cihan.cihan@gmail.com,
	cmaiolino@redhat.com,
	dchinner@redhat.com,
	dgc@kernel.org,
	djwong@kernel.org,
	floss@jetm.me,
	hch@lst.de,
	hemanth.selam@gmail.com,
	jiapenglin@tencent.com,
	johannes.thumshirn@wdc.com,
	kees+treewide@kernel.org,
	norbert@doyensec.com,
	syzbot+837bcd54843dd6262f2f@syzkaller.appspotmail.com,
	yijiangshan@kylinos.cn,
	yun.zhou@windriver.com,
	zenghongling@kylinos.cn
Subject: [PATCH 10/28] treewide: refresh kmalloc_obj() conversions
Date: Thu, 29 Oct 2026 13:06:07 +0100
Message-ID: <20261029120631.803074-11-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261029120631.803074-1-aalbersh@kernel.org>
References: <20261029120631.803074-1-aalbersh@kernel.org>
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

From: Kees Cook <kees+treewide@kernel.org>

Source kernel commit: 3a2c4d55e32ad65efebdb6de44eef3bfa08bb49d

This is another run of the Coccinelle script for converting kmalloc()
family of allocations to kmalloc_obj() via the existing rules in
scripts/coccinelle/api/kmalloc_objs.cocci

This catches both the set of kmalloc() uses added since the first
kmalloc_obj() conversions in v7.0 and adds a large group missed in the
first pass due to Coccinelle not interacting well with the cleanup.h
scoped_...() family of macros[1]. I worked around this with spatch's
"--macro-file" argument to a file with all the scoped_...() macros mapped
to Coccinelle's YACFE_ITERATOR[2] as that was the closest viable control
flow indicator I could find.

Build tested allmodconfig on x86, arm64, arm, loongarch, mips, powerpc,
riscv, and s390 with no new warnings.

Link: https://lore.kernel.org/lkml/202609021314.8A9C0B8@keescook/ [1]
Link: https://github.com/coccinelle/coccinelle/blob/master/standard.h [2]
Signed-off-by: Kees Cook <kees+treewide@kernel.org>
---
 include/kmem.h        | 2 ++
 libxfs/xfs_da_btree.c | 4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/kmem.h b/include/kmem.h
index 4363601ff682..c6c7b7ed37d1 100644
--- a/include/kmem.h
+++ b/include/kmem.h
@@ -108,6 +108,8 @@ static inline size_t __must_check size_mul(size_t factor1, size_t factor2)
 
 #define kzalloc_obj(P, ...) \
 	__alloc_objs(kzalloc, default_gfp(__VA_ARGS__), typeof(P), 1)
+#define kzalloc_objs(P, COUNT, ...) \
+	__alloc_objs(kzalloc, default_gfp(__VA_ARGS__), typeof(P), COUNT)
 #define kmalloc_obj(VAR_OR_TYPE, ...) \
 	__alloc_objs(kmalloc, default_gfp(__VA_ARGS__), typeof(VAR_OR_TYPE), 1)
 
diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index f190c088591b..7938d2324e87 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -2746,8 +2746,8 @@ xfs_dabuf_map(
 	 * larger one that needs to be free by the caller.
 	 */
 	if (nirecs > 1) {
-		map = kcalloc(nirecs, sizeof(struct xfs_buf_map),
-			      GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
+		map = kzalloc_objs(struct xfs_buf_map, nirecs,
+				   GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
 		*mapp = map;
 	}
 
-- 
2.54.0

