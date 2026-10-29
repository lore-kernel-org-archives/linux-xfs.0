Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793275837;
	b=Vs2L8dMSYimTyMlU5HwA+Gcd8rDrCUF2xRQHDVYNrYzZwEVaSK68JhWE6tyxIZdy909S
	 3/ku9Lu8hGflEJCcIn4AzVNVXDlnkOJr9bgh4MSXhsG9IT+iMPLzYYHIwJnwD9veQDQ0Z
	 LiyYuYdafjUb3u1KOV0rfMTjDAiK7MWM4Aqo03/VJjBT2aCoJ50tT/SvZozaHJfIyGGOx
	 7e36PaB/IxWIweXQQkoKI3Xa+Ok4kx3whKFgdKIO/mUGVvYzw4qZoPZkHSU7bUYNlmd3C
	 9f+IBsuLZc0uRNIQFJnBA7Zot2+yxht2eYN8EL2K53Wjm6q8/86o6OlGKtkmQgLQoFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793275837;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=JQhvdZghCcHfBWpfxy7p2oAh9t3EBH2m+GtF2U59laE=;
	b=MXQiGJDBKXj76aEzMYEUrnYTfSBTsrBjwUqMu+tSJHoJrVfw7tnvB+XZohl1t6L1Zoqg
	 FOlovBlTIBRqvmMlwStosdJDHJ8PWHFL2FMyNBrBFJkCVpIEFGfuD/vIROUGePqcrNk2h
	 NdB9gGkvC3JBrxOQgVou4LOboWhT4IyCFXMkculaCHhSkcjXpSLXnxZ/wpU7eTaEn3I1F
	 HTb5vLL4PpOKlFkOJu87RgmWvVx7UMKl9PFKbAusg+cBMVJUsFBaU1LG0i0G9u6tjWuZq
	 a/x5PtDFXwhoxVKN8PRZsMqp31zWlRgzxjhhqTpzvKg+o2M1GEWr0Cd39sBcJlOn/Rg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bj+qaQlN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 991CE606A31A
	for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2026 12:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bj+qaQlN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EB721F01828;
	Thu, 29 Oct 2026 12:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793275837;
	bh=JQhvdZghCcHfBWpfxy7p2oAh9t3EBH2m+GtF2U59laE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bj+qaQlNzG7sItaJvhRBJyc6UBq8sVZn3jBbIX/SMD5so5DEuSSA6tgSWOrYEzxsu
	 0VpUohU5mrtknZmwQ47V73R0vgY5ncYdXwxYK8ab2mdqhhAY6tkUUxG7t/T3Dier0s
	 7IBznBAF7sT3M1cEB6EYGxN93GMLY3/sW6Ye2wpBQJ/jyjbwEif5G5q25JaHe3Cj94
	 bwT7clqTmncISRyiOE6KLHaItA+kSmG2g/ow7OmjjRn1vyAglBHJksgS0h/HspbCoH
	 4MeCEU2KoAJ+Qj6iMSBPed9RDIf8Mcj8l2PnFp+SJWdNXtABs790FbFNbNvPiEjBC5
	 keugexoTZC21A==
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
Subject: [PATCH 17/28] xfs: assert the reservation covers each da fork growth
Date: Thu, 29 Oct 2026 13:06:14 +0100
Message-ID: <20261029120631.803074-18-aalbersh@kernel.org>
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

Source kernel commit: 0fe77e57588b989450d668f7c978bb0264c5c340

xfs_da_grow_inode_int() subtracts the blocks it just allocated from
args->total, the caller's remaining block reservation.  The subtraction
is unsigned, so a caller that reaches it with too small a total wraps
the field instead of failing, and every allocation afterwards runs with
a bogus reservation.  Assert the remaining reservation still covers the
step, so an under-reserved or uninitialised total trips in debug builds
instead of silently wrapping.

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Javier Tia <floss@jetm.me>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_da_btree.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index 7938d2324e87..8cbdd6574755 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -2384,6 +2384,7 @@ xfs_da_grow_inode_int(
 	}
 
 	/* account for newly allocated blocks in reserved blocks total */
+	ASSERT(args->total >= dp->i_nblocks - nblks);
 	args->total -= dp->i_nblocks - nblks;
 
 out_free_map:
-- 
2.54.0

