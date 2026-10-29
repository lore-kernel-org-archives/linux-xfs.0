Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793275872;
	b=Bv/1wpsOXcs9VmGTPIIDTycWg4sPlO42H5JrOj88SD3Zi0aF+sHzlY73WatronvUdefJ
	 BpC1LGlBFEv4shVn3heSlsaBAQJduVg/7u2HNl2wIpsF+5h5m3MI9RdHMDqgRyfz8Sm0W
	 9ShKvZBJRgFP3UpzrMXDgYnS4kBgcTNLYZ4fOIiPIU6TcfD8CpG75bTTHwlUt0WV50uoi
	 Xgu6bkgZf1DfraSnil6BkLcSBXn2gkfMf/YyJeE+QFupTickJ42706dqGOnOgNEidYbjg
	 mTwbtCb1M5XHjKk3/uKhiJpIH+IMGTo2BjiSscRWT6efeu1/q+d1VGARLLvv2dUtTTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793275872;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=FxdHmZ/RTYGLESa0zhPDL8K0ZRE9rtasj1MgC9o/0Aw=;
	b=I+enYfU4RCtkRv/XATaZHCUtHC18MmyiP7qHxy5jKv9I/rZD5Of95mtwCJMiit+xx5FQ
	 WraA63rJfko75jzT3YjP1faGY9cD/VGe6+efZf/Iw9wuf0vu/FtrALQp+trX3ptTuWkcE
	 2L5mH8ta4qbfjFeRtn0iSaUzHmQUq36jgdPo9iqzo2ykCUfcvv+VokQTBITHMkjL50l6Q
	 q9ylLbH+r2vFBBr8LClQScJsttk7ooNddvTdbvPFL0CBS42DUK/yDkXQs8uGvBO6Ew3Gt
	 T9JlFfKXISr01K+uj/G7vKPWQBztC0w/nStyLTdE+/nsebG220l7SQGF0BfQ+bkRjig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FCjNBkZP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5DD5606A31A
	for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2026 12:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FCjNBkZP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E58F11F01828;
	Thu, 29 Oct 2026 12:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793275871;
	bh=FxdHmZ/RTYGLESa0zhPDL8K0ZRE9rtasj1MgC9o/0Aw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FCjNBkZP8qnwO3X8FDh6YVtYn9R2z4ONegLmVt/8FDeYD3xgRL7eAYHyt9psGfxbz
	 QPWULs5pggUta4VYnVWsqW0RBrRuZgTnIs9t0mp/ryIIDfHVMkEJoxJA4dXKpJLlPu
	 Q+pNbvKaFWJz8hh6qJpFjNjUu42f7T1UhXD2U/g5Ik6QJqvxCfB5yGcdnw126aGOGn
	 o/sHPi1bwPF/Nl9InZ/l3gClLOIoWNL2TaNBJG+16Lnl/XTByp7cTIwz8UbYT11/hz
	 /3lJv+C6E6VmgkrG2Ah5nLeOQcA80qSYMNyHoIgswgMDtzNhrcaqdOdnZFo9/5kxDt
	 RGwcLcsYYUUjg==
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
Subject: [PATCH 25/28] xfs: don't let hidden_space go negative in xfs_metafile_resv_init
Date: Thu, 29 Oct 2026 13:06:22 +0100
Message-ID: <20261029120631.803074-26-aalbersh@kernel.org>
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

Source kernel commit: 476582d754cdc5110f806001417fea6c77824c13

LOLLM points out that if the amount of fdblocks that we can reserve for
a metadata btree file goes below the space already used by that file,
then the hidden_space subtraction can underflow, causing
xfs_dec_fdblocks to subtract a huge amount of space.  We never want the
target to be less than the used sapce, so fix the logic that adjusts
dblocks_avail downwards.

Also fix an error in the adjacent comment.

Fixes: 1df8d75030b787 ("xfs: make metabtree reservations global")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_metafile.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/libxfs/xfs_metafile.c b/libxfs/xfs_metafile.c
index 71f004e9dc64..1f54d39003c2 100644
--- a/libxfs/xfs_metafile.c
+++ b/libxfs/xfs_metafile.c
@@ -297,14 +297,14 @@ xfs_metafile_resv_init(
 		goto out_unlock;
 
 	/*
-	 * Space taken by the per-AG metadata btrees are accounted on-disk as
-	 * used space.  We therefore only hide the space that is reserved but
-	 * not used by the trees.
+	 * Space taken by metadata btrees are accounted on-disk as used space.
+	 * We therefore only hide the space that is reserved but not used by
+	 * the trees.
 	 */
 	if (used > target)
 		target = used;
 	else if (target > dblocks_avail)
-		target = dblocks_avail;
+		target = max(dblocks_avail, used);
 	hidden_space = target - used;
 
 	error = xfs_dec_fdblocks(mp, hidden_space, true);
-- 
2.54.0

