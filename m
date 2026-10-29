Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793275876;
	b=GY+wlRaH009F/yyiwu9IEnYD1UjlKAoSow8qX4p9ge+6oSstqJPPg3mv3J4KD2lraRJv
	 llCuc8JmeILF4f6U7mBBmx4/fNPttxkt573kWYZzBzNqxSWTn96qfPNJa7AAqYWqJAQQ3
	 vJJ30eXLSvf4m6kPaM2PCS7k1KSff5ymFzfqJHpPReNpgU25Rj38ozKwmufGMcy+bMhJs
	 9OWVnZ0WjTYnGViQL6IimVIBpjdWtltfCi+Gb8Q9HpNwgJIqNl1ZE68rZb5PXk+0PWwJd
	 egkB3JgbkuwQiqvLnqywKdIEcY6ce6QPqjieg5hu8/ad0jK+2ODljrD1IOvyl+bA8HA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793275876;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=V4YaAt+9VinEbL9NCM38rn2VCdC47DYTw480WaHbBDM=;
	b=YoTGZYPTspkxcFHvp3QgpvGzlRm+mGqOSRYiW+TAmmT3uK8W9+QsIsOXEJDehG2yj3Tn
	 Jbq7TajcSuTf5/5CnngEdS7K/uGxchO958CUcfzsLzvWGyAeAQaBrRphHRukAMrE2U1Mg
	 Thg/cEEqy3u9JXW+fzh9ZpwKso2xxS3kJX60zH0KRkBLjUZq3cX9HPiMKEP4Uu+O/C4gv
	 VfhdohajN01I8Jz1oq3rBKk5VuhyDT7EJIMucuvUlfRxc5gCJm4m6CIbyzm7eY7qetDQn
	 dLtnSfa7qWHMbZenXmpk4md9QaYeq0Xa+c8RdWcCIQoN9TKm0ZyoeJIy2egU6IhR4bQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z0a1IqNh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 220FE606A326
	for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2026 12:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z0a1IqNh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33F6E1F01825;
	Thu, 29 Oct 2026 12:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793275876;
	bh=V4YaAt+9VinEbL9NCM38rn2VCdC47DYTw480WaHbBDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z0a1IqNhncg9vvLJeIeqWJOpLzbg6GFx6wTMk9ea0afjfce1kJOy6QMa3jo7ci3fw
	 MO+YDoovgSj6mGXKqBwvrY59boO0crs2f5YmTIzR4ZIao7nxtOKRP57l4Zqr5ziyvn
	 akZX4tUnLwrJF7HbaXheMumHN1+I+okEDIu9L5zQj3Nur871JbF+pj1pnF7aw09NYN
	 M05BS2kpYDwSMEemGdioAOYxtXjeoSoX9CEr74ZvifC30gNcKiABUuhg1Q09KeDJid
	 2q+ObUEZCdfJDV+27yPo1t2UBI2rkZxMySJrGL/3q3lPQwJkFUF6BwSf+lBilVgyjF
	 oQ/kZ+nCngx2w==
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
Subject: [PATCH 26/28] xfs: fix wild memcpy access when formatting ondisk rtrefcount btree roots
Date: Thu, 29 Oct 2026 13:06:23 +0100
Message-ID: <20261029120631.803074-27-aalbersh@kernel.org>
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

Source kernel commit: fe2f9135df43db849e74f03956d322ac20b59af7

LOLLM noticed that the inode btree root formatting methods copy too many
bytes -- there's only one set of keys in node blocks, not two.  This
causes memory corruption of whatever's beyond the buffers.

Fixes: f0415af60f482a ("xfs: wire up a new metafile type for the realtime refcount")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_rtrefcount_btree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libxfs/xfs_rtrefcount_btree.c b/libxfs/xfs_rtrefcount_btree.c
index e2950dbe2068..dcc89b8e149b 100644
--- a/libxfs/xfs_rtrefcount_btree.c
+++ b/libxfs/xfs_rtrefcount_btree.c
@@ -617,7 +617,7 @@ xfs_rtrefcountbt_from_disk(
 		fpp = xfs_rtrefcount_droot_ptr_addr(dblock, 1, maxrecs);
 		tpp = xfs_rtrefcount_broot_ptr_addr(mp, rblock, 1, rblocklen);
 		numrecs = be16_to_cpu(dblock->bb_numrecs);
-		memcpy(tkp, fkp, 2 * sizeof(*fkp) * numrecs);
+		memcpy(tkp, fkp, sizeof(*fkp) * numrecs);
 		memcpy(tpp, fpp, sizeof(*fpp) * numrecs);
 	} else {
 		frp = xfs_rtrefcount_droot_rec_addr(dblock, 1);
@@ -703,7 +703,7 @@ xfs_rtrefcountbt_to_disk(
 		fpp = xfs_rtrefcount_broot_ptr_addr(mp, rblock, 1, rblocklen);
 		tpp = xfs_rtrefcount_droot_ptr_addr(dblock, 1, maxrecs);
 		numrecs = be16_to_cpu(rblock->bb_numrecs);
-		memcpy(tkp, fkp, 2 * sizeof(*fkp) * numrecs);
+		memcpy(tkp, fkp, sizeof(*fkp) * numrecs);
 		memcpy(tpp, fpp, sizeof(*fpp) * numrecs);
 	} else {
 		frp = xfs_rtrefcount_rec_addr(rblock, 1);
-- 
2.54.0

