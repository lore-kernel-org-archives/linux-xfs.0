Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDCD93655EE
	for <linux-xfs@vger.kernel.org>; Fri,  9 Oct 2026 23:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791589695; cv=none; b=pfxqr/7zuBBNM4cya47XgTt1ua1C3VJxcF1KOQxSwPQuzHFxN1SvhTjnbLUPRVaNnawriR6aQJju0mRH67eA174TykcAQYE/dMx7HEVKTjcpd5kLs0uGoA7UV9MYdVnkCoNpQmiuYZ4hqoAex1VjRzsQ31gm103n4KEHyPgmfsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791589695; c=relaxed/simple;
	bh=E1l2wJPy9VwhchTBYrc+JJYoactPYjcWkeU6K2Sd26M=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CapeSxCaSsI+bApOMrHHenI7vgYv82LrzxmyJ+YFgHzqAre4xFZUtGtfHskzaoeKpDGYFbRX+fGZD9Q8e2OBT/W4qrE9K/tHbKp3BS1c9zfJCPvaDwt4XK1xcdq/oNNwEX7bVy/M4jdGQo7adZYZ3GApRYBP2l/2y2Ru193wrXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BDy21lSu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BDy21lSu"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A4F231F000FF;
	Fri,  9 Oct 2026 23:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791589694;
	bh=mvBVEfMNm/uqrPQ9QVXi4NG0Wt5gB1K8hnQrg/neX2M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=BDy21lSuXytNXam5SwRZj8WdOHNm0UqX1tpssKHhWhePhS2P80IN58MVlJttrOmHb
	 XHfcXhDSnUWdLKFQ02XhcrpbvSNny31dJS64iiaziYgvyBzqxxHjxMYxKwSj6qyujB
	 qaI1Z7j22Lvj+1aBUCF613MmGZFp2+crxJmttTJk3V3+R5hqERzCp8lm5Jerybovk6
	 zXrroYWa8H5YgPVX9REQlRSRZABT/w5lZP+kV+ueMYFNqOzivWIDNnyR97MITwK5++
	 R6bLfex+ptJ/OKGoeZBuNxqXkk9dGj6i0opaD0c68RYOhDaNEswv4bF9rCfWV5JdI9
	 RX0R3q+WLFk2w==
Date: Fri, 09 Oct 2026 16:48:14 -0700
Subject: [PATCH 10/26] treewide: refresh kmalloc_obj() conversions
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: kees+treewide@kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179158947549.3719791.14375885689814422600.stgit@frogsfrogsfrogs>
In-Reply-To: <179158947238.3719791.8405495844046466765.stgit@frogsfrogsfrogs>
References: <179158947238.3719791.8405495844046466765.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

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
 include/kmem.h        |    2 ++
 libxfs/xfs_da_btree.c |    4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)


diff --git a/include/kmem.h b/include/kmem.h
index 4363601ff6820f..c6c7b7ed37d1a2 100644
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
index b1cdb0ebece92c..50eb44f486ed8a 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -2744,8 +2744,8 @@ xfs_dabuf_map(
 	 * larger one that needs to be free by the caller.
 	 */
 	if (nirecs > 1) {
-		map = kcalloc(nirecs, sizeof(struct xfs_buf_map),
-			      GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
+		map = kzalloc_objs(struct xfs_buf_map, nirecs,
+				   GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
 		*mapp = map;
 	}
 

