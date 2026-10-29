Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793275850;
	b=nw3iR/0qeGdci1bfZwSk7S+T6Jhhz6r10B5LizpPC81nt6t4igW2sRgfDL+pPlWTzrPc
	 XoYth7lsO+o2rfVW8+fjv41ekUkwO0mwUHlHoh0/bjMK0MoFTyy2h2+EP/FT386AchJSa
	 IR4oMa/Mg94IeOeBRC7eCSTN0Uwu6B4essEwtFAfGgbcT548RnBpPHcRSLySzoMa0k3SH
	 MP/ocoP69p+ODA1ITr99cjd75i+WdnsQ1njmUKYism9MJP9LqN3CULjzf3bDL0ZZ+VXnw
	 Ie5vRce2q1lPrPWuZMenb5V3JkzgkYoBnAOqH79hNWRxGe/UNaR2rGHUjqGGuFUaNug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793275850;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=WbzGkvYD/N28v+SM3Y756esiZR7JNIAzOSne/9MZI2Q=;
	b=zOHiFE1UcK4yJS3IP3gZN2iRG0ZakU9PiCtgf4Zc1plbOQibgkS3RgBPcVoVXp6EbShG
	 4AzgV7ZwdwyQI/t6WdauliVKUoq8W19JhEVTD7ZAtHZyRW5oaUw2CDf7vCF9IIDTruaap
	 IbA9TTRmppuZ39PyIZq8L6pjGgojWBNhvsbeuec+IQOcMPt5OhnUQNIbEDwhnbb0BYnHf
	 zMS+ISsS7mRkK2A81OKOxnIIgQ/8rTb85fnsJE+3VmOTBTAX/rmfx9OEk+c/vDv8+Xqxn
	 wiTgcLi6QkNpgNys9gPiDTSoAXUkOTbj9KIsRsoaQ23zkjuGs5jERqYCsnmPP7Zmc4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=edPelj+H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86AA2606A31A
	for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2026 12:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=edPelj+H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C1CA1F01829;
	Thu, 29 Oct 2026 12:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793275850;
	bh=WbzGkvYD/N28v+SM3Y756esiZR7JNIAzOSne/9MZI2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=edPelj+Hg/umBZ9jFlN05WPw2fjcLslFi07lUGej8+6zxAvgVJcaJaGkqBRhNbLPn
	 yyQkCIPz2YmBvmb3w1w3FWpvdJuqWakrU3r0G+k5qUGbXNTHgRLdwERh6beWVEbbCj
	 r9MlmTqybkIVsDwuZ9U/6/nNLsgo8JoI0HgtYcbVDJOumwO3QNqsXJAUMPuj3Sts8s
	 ypGrCVJG9+1bTVqKtWSdOCCtZBYYDvMR6iNBNai/RBjjfCs6qbpbKRJVEivV9t2gMB
	 8DAFDRUtuc0fAsGApGJG4U8QDyMQHLHJAFO0BsGKUn3rsgthACENyJZov8k8Oh6F75
	 0P7JGfTV2e9CA==
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
Subject: [PATCH 20/28] xfs: preserve owner on in-memory btree creation
Date: Thu, 29 Oct 2026 13:06:17 +0100
Message-ID: <20261029120631.803074-21-aalbersh@kernel.org>
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

From: "Darrick J. Wong" <djwong@kernel.org>

Source kernel commit: 5287e56cba3be4a64bff9f73bce5964fda2590dc

LOLLM points out a minor bug where a higher level function creating an
in-memory btree is required to pass in an owner number, but the creation
function erases that.  In-memory btrees are ephemeral so this really
doesn't matter except for debugging.  But let's fix this papercut.

Fixes: a095686a238352 ("xfs: support in-memory btrees")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_btree_mem.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/libxfs/xfs_btree_mem.c b/libxfs/xfs_btree_mem.c
index 37136a70e56d..1d83a4251cee 100644
--- a/libxfs/xfs_btree_mem.c
+++ b/libxfs/xfs_btree_mem.c
@@ -117,6 +117,7 @@ xfbtree_init(
 	struct xfs_buftarg		*btp,
 	const struct xfs_btree_ops	*ops)
 {
+	unsigned long long		owner = xfbt->owner;
 	unsigned int			blocklen = xfbtree_rec_bytes(mp, ops);
 	unsigned int			keyptr_len;
 	int				error;
@@ -133,6 +134,7 @@ xfbtree_init(
 
 	memset(xfbt, 0, sizeof(*xfbt));
 	xfbt->target = btp;
+	xfbt->owner = owner;
 
 	/* Set up min/maxrecs for this btree. */
 	keyptr_len = ops->key_len + sizeof(__be64);
-- 
2.54.0

