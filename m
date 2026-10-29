Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793275855;
	b=B1rEa8ImVE7GEuLNMyq0b3ho1VpAq+ZuDm4x4DY3xit5ryd1i5SNJfbYgNhrpuECO+w8
	 Rxoy2LnA9XCwUHaSBUpeQYlkY6PTlU4lXBsYt7LudwI9kE8lrq4CX8ld9Aj31PhEch9vw
	 vePjSmYnPjnqL8HCyPnf+nlA0DoJJuk4M1Z7RNvjibRusaHqOCZo29XGtGItTlOB4u27z
	 dzeL4E4/4hPpuTHZ9btxLROVAXdZtgI4KPBh2nmCH9taBf0gLe+mDDkJpdXUFSu+JAqkI
	 0EfoVOxA5CFtpKDfz6SW3s4qmXuf4Ka9zB6yih5kCTMWbwh5TP30NWSi3soi3Gj+3Aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793275855;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=tdHEikSOUqtPZwfOH0+eMO6MjOYi4ZQt4f0ubmGDlD0=;
	b=x8vmBulGBjubRvYbZfBOMxjWknHePo6ZXF9ZZvrgAss9tqZ+DXcpgQi4iRCsoTma/CU5
	 Xqps4H/n0/bnNtsc5E9SXZrbMa1f5v6FwIWSgzqORtJ2pIGsCm2WcKL3MKi69DCtVgnKI
	 t7W8ILT2ZVn3gmJv6rt3r6GADfuPvsCAy7tyJ4lRCfZoupzLMJDjkBJhW7JHKG4SeICWX
	 WvefF4ndmXKgXBtLVl2Y0/0kL/844UCBfJD3XivAMYkTZ857rSHbCOiIZ94hCkj/Zg7wK
	 lMhBrhtF2ViS1VkWQuoqlSs8ryL6PyC3jOwcHspppv4uXu7yVcFnfR9u4cIQaj2/0Qw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TnpmXM6b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A49606A31A
	for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2026 12:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TnpmXM6b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA7A61F01825;
	Thu, 29 Oct 2026 12:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793275854;
	bh=tdHEikSOUqtPZwfOH0+eMO6MjOYi4ZQt4f0ubmGDlD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TnpmXM6b7zhbScdPoMNxqTJLk2BebQeDhycJfgTPKXgUh1K4U0zTEa44pc+t7AFoX
	 pP8AsRRmijWGqaZ6l44II7mUnWJABd7PiK2izQUi3rBCRreGF2zqyZew/1sfJbx13w
	 dBhZgJGzbe+31QCER4oAtDCrxNjVCcywH6Gw2H0muuDLFkbU6dqcd9cEjXbbp/oSkv
	 7cFmS8CMPP07e1eYxbE4BWKCuu6W1Zuo/E3HjpQcD3DFJq6fF8rKjRFwOhisp1b3Aq
	 n5ERfASm2uDU/OLfmsFIMLz5xAGcuDwD8qDQ3xM90LLmV50v2SSS+72hazGpeINKJZ
	 zdfaG5iTA6yQw==
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
Subject: [PATCH 21/28] xfs: don't leak new_bp if xfs_btree_bload_drop_buf fails
Date: Thu, 29 Oct 2026 13:06:18 +0100
Message-ID: <20261029120631.803074-22-aalbersh@kernel.org>
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

Source kernel commit: f1930bc578095409c2dcfca6e4e898b24f0f0de6

LOLLM observes that in xfs_btree_bload_prep_block,
xfs_btree_bload_drop_buf can hit an IO error if writing the delwri
buffer list to disk fails.  In this case, we fail to release new_bp,
which means we lose a locked buffer.  Fix that.

Fixes: e069d549705e49 ("xfs: constrain dirty buffers while formatting a staged btree")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_btree_staging.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/libxfs/xfs_btree_staging.c b/libxfs/xfs_btree_staging.c
index 7314dab4bcfb..561fd2c2e950 100644
--- a/libxfs/xfs_btree_staging.c
+++ b/libxfs/xfs_btree_staging.c
@@ -336,8 +336,10 @@ xfs_btree_bload_prep_block(
 		xfs_btree_set_sibling(cur, *blockp, &new_ptr, XFS_BB_RIGHTSIB);
 
 	ret = xfs_btree_bload_drop_buf(bbl, buffers_list, bpp);
-	if (ret)
+	if (ret) {
+		xfs_buf_relse(new_bp);
 		return ret;
+	}
 
 	/* Initialize the new btree block. */
 	xfs_btree_init_block_cur(cur, new_bp, level, nr_this_block);
-- 
2.54.0

