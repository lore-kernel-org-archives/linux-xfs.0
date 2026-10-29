Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793275829;
	b=MH0qp8LMjIqfsmautzzEAvYZQ2pViPWUaSBMLcD67Wjx9cuQk+cd66foUfUvg0qPpoxO
	 G+79tlav1Bo+k3NbzUgTAuE0GTEwIkTkmjD5OoUVzQSLsewI8gOXiLYwgiO0HrZN2U9c6
	 ZPh3gfOw2XGJN/QQh6A26RKQbcfzHWOUUXKQBVCXPx0ulAFyNacDBfzXUs2RJ878v1Kjq
	 oh9zY3PjboRC74NkqLhm5Pc/pPN89z7cUlWdphyY/UKKSKeKCVvXOOTtyzg2hn/99uujq
	 zl4cev/oOdKHy4Jgihq8MQYE9znsSR2pBJ/eCiPxm3NsaVuCCW31n60ABmi+UQlWCGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793275829;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=jCCGn2m3nm9DYnXtdFv3Pyd1fGgOwMTKCBSF96S9lCo=;
	b=v9XovG/ksQgR+eOWwrqPzw+MZGwcmvqDuqFp0idFgx9sAo9/lQSsF0EIs0dkf1YnGIKM
	 H7gZ0/4+EzzSYY8Rn50eJ9dyTuSJof8FQko5vDkURiC/nACR4vBJ3WF7jM1GS3F2yoq5/
	 59LJrd5u3VtrNRzT6SwVKeGQIxrLY8qolDAR8y3B/dAXhcIrDLIakfCL5oGNnYZci1ntS
	 e/vhQ3tED97RGqKXPhdlbP1z8Cl9gM7R9uHmcJYQnTams59wJms8WDh80DZlI0ZIGBC3L
	 hyfgbiXp2LQhPgxUnlxeQ3KQt7kID8DnkxL1QZDder0JUH8wXIxQD81tq9fhNvGx/QA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oN09Vx6U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F3A606A325
	for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2026 12:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oN09Vx6U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 972FE1F031E0;
	Thu, 29 Oct 2026 12:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793275828;
	bh=jCCGn2m3nm9DYnXtdFv3Pyd1fGgOwMTKCBSF96S9lCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oN09Vx6UHSA8uNuoKekCyNU7wKtkx1XG00QChK5XMbT2Wb8mnP+Wvn+j0TMRCp84Z
	 WTYlDM+4pXvND7RSnLnYs00qwl1+CoPpLj6OwMlsDZHBxZ6giphUPo5z4rylgemamW
	 YUNAh9DFW4BvvTes2U+2dZIHyNBOIVuFqCK3GzT2LGd1B6AR/U5HYlVoRRc6/JKmDu
	 buPzwhrkidEJBts/SpsRW33CYFZk2iXxSag29AbW/wbMs6SSxAVU8O7nxWrUvm43IH
	 AV1mPaGQjXclZB67LdPH5ugA96xRCyPQD+qHg7p9IwOW+UIFVo6HA26rjsNAn1CqFR
	 rKzqHIuJSvB/A==
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
Subject: [PATCH 15/28] xfs: correct the parent pointer space reservation comment
Date: Thu, 29 Oct 2026 13:06:12 +0100
Message-ID: <20261029120631.803074-16-aalbersh@kernel.org>
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

Source kernel commit: 6c0fc3cb4e879927b338b4fcb6de6a25c0a67608

The comment on xfs_parent_calc_space_res() claims parent pointers are
"always the first attr in an attr tree".  They are not: a parent pointer
is recorded per dirent, so by the Nth hardlink the attr fork is already
in leaf or node format.  The reservation is still correct, because
XFS_DAENTER_SPACE_RES() covers a split at every level of a maximum-depth
attr dabtree whatever format the fork is in, but anyone auditing a
shortfall here is led by the comment to look for a bug that is not
there.

Rewrite the comment to state what actually bounds the result, and record
why the double split allowance and the extent-add term differ from
xfs_attr_calc_size().

Signed-off-by: Javier Tia <floss@jetm.me>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_trans_space.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/libxfs/xfs_trans_space.c b/libxfs/xfs_trans_space.c
index 9b8f495c9049..c4cd547033e5 100644
--- a/libxfs/xfs_trans_space.c
+++ b/libxfs/xfs_trans_space.c
@@ -22,8 +22,23 @@ xfs_parent_calc_space_res(
 	unsigned int		namelen)
 {
 	/*
-	 * Parent pointers are always the first attr in an attr tree, and never
-	 * larger than a block
+	 * A parent pointer is recorded per dirent, so an inode with N links
+	 * carries N of them and the attr fork can already be in leaf or node
+	 * format when one is added.  That does not affect the reservation:
+	 * XFS_DAENTER_SPACE_RES covers a split at every level of a
+	 * maximum-depth attr dabtree, whatever format the fork is in now.
+	 *
+	 * The name is a dirent name and the value is a struct xfs_parent_rec,
+	 * so the leaf entry is always local and never exceeds 272 bytes.
+	 * Parent pointers require V5, hence a 1k minimum block size, so the
+	 * entry always stays under half a block and this needs none of the
+	 * double split allowance that xfs_attr_calc_size() makes.
+	 *
+	 * The second term hands a byte count to a macro whose parameter counts
+	 * mappings, so it asks for more extent-add allowance than the single
+	 * mapping a parent pointer adds - how much more depends on the block
+	 * size.  It over-reserves either way, which is why it is left alone:
+	 * correcting the unit would shrink a reservation that is only generous.
 	 */
 	return XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK) +
 	       XFS_NEXTENTADD_SPACE_RES(mp, namelen, XFS_ATTR_FORK);
-- 
2.54.0

