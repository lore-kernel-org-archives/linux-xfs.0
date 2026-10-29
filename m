Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793275833;
	b=rCgLAHwmuiABh1H2P22uUPCV+y72OJCL/vhyRmETSkGC8gaZsfT119O/6njRneAjnGFE
	 1IB7g+m/8EDMP8FTsYxBy6AqxxNHBxW8m1Ry468XAfNB066pG6mKPjlJ3tp1E7nODTgo2
	 9VzB7dj7DhWFwB6BAKVS2tLKjQ6uHFEHJ/3q2IALGl6Ma26uLFu5DQrW7iRAAZEttMf2v
	 6atZPZk5avDlDkEuRUSutpsvBncoTiSNdlxcqu6yxfqvORWni9Z0EKe60fW7srJhNhGOo
	 BR2MTmsEy2eodnDNp7SqaJ9TygjffPWm1sFFBAhl4rfjWE/h8Gufg/ZmQNJhRhAs6FQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793275833;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=lr9nMqAnounU6voTUYVKVlhcaFmu7qPrtk+99DK3LN0=;
	b=cwgw940FOJCnnq6e4XX4+ANtD87xNtgGZJKHeBOZ1KoNtLgoJsOFDHhz8xz9Sfr9l6aQ
	 SWRAIIOKZjFiD1QG2Bp2fQZecrr4bNoF1BFVleXYAAoVknuqRim95SMgJN4R+9EJUgsC0
	 aGHYiDy3kYgsGb7sLwRqP+U12LwyAVGt/zASKSz/E3qCj7FRiWwWMZ5m6BWXqwTERoeDn
	 pQAKLEj5Se3BOIAhbTHrBicEcqUnd/8irHnxZ/sTADqeK0HLKZGOHvHzXei1lkW2e/YCF
	 1C7lZchQwRDTjnCDmigahZNMte59eDskPhxcEE8Xuhf8LnEjq21/E3nPL7QSrL6bVEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aEgf9cDr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA2D606A31A
	for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2026 12:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aEgf9cDr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 100D61F031E6;
	Thu, 29 Oct 2026 12:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793275833;
	bh=lr9nMqAnounU6voTUYVKVlhcaFmu7qPrtk+99DK3LN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aEgf9cDreU0NIEg98ZlfakSmASJrSSrzK0qNwpqAvWSH+MA5HVTEdfi/iu5acKDdq
	 gaHxUDP+tYzCLDJy9QkABFBfgM6VrZuVvdYo8LLjMIiEaEUrAQC13c4fu9D64sJ6SK
	 eDy5DCpRhbj2tSoXfGPp+pdeZxJ6DtftFxd0yT6TmUl9JMMMHNv9hGZJCHB8Qj4U63
	 o8wTrh1xVLauAHBtYiFx8DA33g2EkRLKKArPCE5A6lxOcNBSln9ALYE9VJO9bVBkgs
	 E2JcM1saWUYWAUiWgp6m8kGN0VveUp2Fu8qMNJhO896MfsUH4J9oi8qAiaXVqVmZDt
	 km0WCY5M9pjPw==
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
	zenghongling@kylinos.cn,
	Javier Tia <javier@peridio.com>
Subject: [PATCH 16/28] xfs: initialise args->total for parent pointer updates
Date: Thu, 29 Oct 2026 13:06:13 +0100
Message-ID: <20261029120631.803074-17-aalbersh@kernel.org>
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

From: Javier Tia <javier@peridio.com>

Source kernel commit: 8e4ebb6afaa34bd2e8ce52da231003d24111c2d6

xfs_parent_da_args_init() builds an xfs_da_args from a zeroed
xfs_parent_args (kmem_cache_zalloc), leaving args->total == 0.
xfs_da_grow_inode_int() treats that field as a running block reservation
and subtracts from it; because it is an xfs_extlen_t (uint32_t), the
first attr-fork growth wraps it to ~0U.  That defeats the free-space
check in xfs_alloc_space_available(), and when it coincides with an AG
that has exactly zero available blocks the allocation is clamped to
maxlen 0 and returns -ENOSPC, which xfs_defer_finish_noroll() escalates
to a filesystem shutdown.

Set args->total the way the log recovery path does
(xfs_attri_recover_work(), xfs_attr_item.c:706), in the add and replace
paths that can grow the fork.  Removals and lookups never grow it, so
they leave the field alone, matching that switch.

Fixes: b7c62d90c12c ("xfs: parent pointer attribute creation")
Signed-off-by: Javier Tia <floss@jetm.me>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_parent.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/libxfs/xfs_parent.c b/libxfs/xfs_parent.c
index 992263f810f8..0576424ed8f1 100644
--- a/libxfs/xfs_parent.c
+++ b/libxfs/xfs_parent.c
@@ -192,7 +192,7 @@ xfs_parent_addname(
 	const struct xfs_name	*parent_name,
 	struct xfs_inode	*child)
 {
-	int			error;
+	int			error, local;
 
 	error = xfs_parent_iread_extents(tp, child);
 	if (error)
@@ -202,6 +202,10 @@ xfs_parent_addname(
 	xfs_parent_da_args_init(&ppargs->args, tp, &ppargs->rec, child,
 			I_INO(child), parent_name);
 
+	/* Growing the attr fork needs a real reservation in args->total. */
+	ppargs->args.total = xfs_attr_calc_size(&ppargs->args, &local);
+	ASSERT(local);
+
 	return xfs_attr_setname(&ppargs->args, 0);
 }
 
@@ -238,7 +242,7 @@ xfs_parent_replacename(
 	const struct xfs_name	*new_name,
 	struct xfs_inode	*child)
 {
-	int			error;
+	int			error, local;
 
 	error = xfs_parent_iread_extents(tp, child);
 	if (error)
@@ -248,6 +252,10 @@ xfs_parent_replacename(
 	xfs_parent_da_args_init(&ppargs->args, tp, &ppargs->rec, child,
 			I_INO(child), old_name);
 
+	/* Growing the attr fork needs a real reservation in args->total. */
+	ppargs->args.total = xfs_attr_calc_size(&ppargs->args, &local);
+	ASSERT(local);
+
 	xfs_inode_to_parent_rec(&ppargs->new_rec, new_dp);
 
 	ppargs->args.new_name = new_name->name;
-- 
2.54.0

