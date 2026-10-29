Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793275785;
	b=IAjUzlGUYUmz+h8Bbw5tsdf17kX9Bb9d4+vlQBAzBNIk2Owv0aBVixK5YmLFiYYZ9myu
	 1bn3AzBdEY6BaD3WRWoQ1J3l4jKrc3Gg87pFaCNne1i+4mKQsQiPLYwU0/oCxAiA7utUo
	 tC3gM80ppYvVP/Uq9Rq7eOjlWdYwJxRu4ggGux3Wytdn9ZlRf999yXzyG9JdXLBiL1US+
	 Mw16K3q9GAAvgrv6Fj8Wih+W7By2pYr9p7HJfd1XyVJQf77xe8A1QqNJCtpR8D55bZlne
	 1rI/X+SMEGg4vwt3iVf7TesNwZZAueTrrd+zu6bVM2N9HoyzgrglT77Cj15Z+WbqlPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793275785;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=nUSVwGLnybOI6qBBDuiUnOhqHtaU0ap4iFyOaFzvBws=;
	b=yz0qDjgFg+twvI+pj9AsRiibRrImJgO8j79tYMooi5NI4e9z7vzX7yjvNxfnYUaniiwI
	 271ZqTlvFfFFA1esdu7bfHyzMUYtq+qmuQVUMMk68EbjHbX2hBGdtDgK9uznbM6Rr8SGC
	 9LIjNsSCl9ap7dJ/ZwdL0H6cnclkba3qmjKXB5OEMc2MLXRjeq+mMloEWFQXM2Q3mGxUr
	 2Kkp0tjC8WWtmMitwymuBlvECbSn+FjRgg66I2+BdJc9d7J8am5FljqsFU8JFQM0XvsDE
	 0+4+9KXrxY1JR4RFfr6I446n8/I2e4bI1SDk3APErvBl+C4arFy7X8ATT0w1cVaaQDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="BAGN94/H";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F17FE606A31A
	for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2026 12:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BAGN94/H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3D9A1F01828;
	Thu, 29 Oct 2026 12:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793275784;
	bh=nUSVwGLnybOI6qBBDuiUnOhqHtaU0ap4iFyOaFzvBws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BAGN94/HrcmvqMDbDg9p1vwnVZyLA1YzYssIYJ+4NrNKIExt+t7JnNNAS0MPfJnZh
	 /oKFa1GAruRBQuQwq/F1gQf47NJx0NdDTqQIYGz/M5A+fzNj65GIbDfVxDNU3tsLxi
	 QbkKXgQNic+6XRKRTSF1TFqKXWkl92paQOFd75SD6cmRJaTCpDQFStATW4rfk+hzYS
	 /RhgT3+RhlIl3pkLkUxl5su0sIa4NgDRLE0S77AV5kmcQoYdI54squYfGP+lUOMuw7
	 zpSZziMDl+e/abHGRk3C65X6ykq47qwjzaLOnX2aWN31JkKBPxPZpUBRViwzZFhgWR
	 67pb4gDgKNovA==
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
Subject: [PATCH 05/28] xfs: use kmalloc_objs() instead of kmalloc() in xfs_da_grow_inode_int
Date: Thu, 29 Oct 2026 13:06:02 +0100
Message-ID: <20261029120631.803074-6-aalbersh@kernel.org>
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

From: Cihan Karadag <cihan.cihan@gmail.com>

Source kernel commit: 56aa9ef3c413cb13a373226f91a19358cd9f1266

Convert open-coded kmalloc() multiplication to the modern kmalloc_objs()
interface to improve type safety and prevent potential integer
overflows.

No functional changes are intended.

Signed-off-by: Cihan Karadag <cihan.cihan@gmail.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 include/kmem.h        | 12 ++++++++++++
 libxfs/xfs_da_btree.c |  3 +--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/include/kmem.h b/include/kmem.h
index 2c276e929c48..4363601ff682 100644
--- a/include/kmem.h
+++ b/include/kmem.h
@@ -138,4 +138,16 @@ static inline void *kmemdup(const void *src, size_t len, gfp_t gfp)
 	return p;
 }
 
+/**
+ * kmalloc_objs - Allocate an array of the given type
+ * @VAR_OR_TYPE: Variable or type to allocate an array of.
+ * @COUNT: How many elements in the array.
+ * @...: optional GFP flags for the allocation (GFP_KERNEL when not specified).
+ *
+ * Returns: newly allocated pointer to array of @VAR_OR_TYPE on success,
+ * or NULL on failure.
+ */
+#define kmalloc_objs(VAR_OR_TYPE, COUNT, ...) \
+	__alloc_objs(kmalloc, default_gfp(__VA_ARGS__), typeof(VAR_OR_TYPE), COUNT)
+
 #endif
diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index 9debb95d86fa..f190c088591b 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -2354,8 +2354,7 @@ xfs_da_grow_inode_int(
 		 * If we didn't get it and the block might work if fragmented,
 		 * try without the CONTIG flag.  Loop until we get it all.
 		 */
-		mapp = kmalloc(sizeof(*mapp) * count,
-				GFP_KERNEL | __GFP_NOFAIL);
+		mapp = kmalloc_objs(*mapp, count, GFP_KERNEL | __GFP_NOFAIL);
 		for (b = *bno, mapi = 0; b < *bno + count; ) {
 			c = (int)(*bno + count - b);
 			nmap = min(XFS_BMAP_MAX_NMAP, c);
-- 
2.54.0

