Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793275811;
	b=MhHtzTPf536+JXkocCfvtKFjTcfdkx3a+LYn94LWoXeIq/uTz0FhveZFao1J3pc1aXrP
	 SMGvZegTyMtZzEKLxB75mftfDQkrhbuc7OAjD3lwlA+LCiuodZhOsGCWMlTfhLvn6W2gk
	 szbjLp3UWqbwl5HZTFPzXgNj1UIBps3grL9FxUNT956wZErC3zxcxzBeolrT6pYiXSvn4
	 hj+BHYeX/VXpUAlsk1P8UKyRvoxK7aMMqpwmyBPJpBiBeapLmoLK5dKN8UhdFxGgWw3pY
	 gYKoczzLyjBiqTfKfkcb7m1dY43j3I9cSfqg9s2M7U0FW17YmanLkginV4EDe+nrwkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793275811;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=fbjoUH2K4cHOEWaYgoXX91067fzbLhg4ar25XH9BJ00=;
	b=Ne6dj0pt9ffkrc/oY/n8w7BjR/T1BzJO7Rxc2U69aPjMh2bg1iOTU3Fkr6NwZCUZDkiJ
	 qZTlQcabJtQmbTRNGvf1HMesNqdwq0JMdOwMbOp2k9xeMCcmskJZSY+Zprd+GHXMEbP44
	 9cUP743cu4S5zs4Ypuvl2xD/rtLfV3Nfl/LEsLvIeoqOHd1BVSgD1DsUqnWGBC5lMS7Te
	 cVzT1QtQoxyr/RpTlO+meX2HcyTmMzmM1crCY/sSFM0JlTyg4g1Sx+NxtGJJKX7rQ3+M4
	 KsDJ/6V2xjdxGNSiYpu9g1n8gYaz99CLkpDr/QNe6AGuqkYEtbFHsCu1ZJZy4SJH9Kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="OF1rL/jn";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25AEC606A325
	for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2026 12:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OF1rL/jn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7E921F01825;
	Thu, 29 Oct 2026 12:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793275810;
	bh=fbjoUH2K4cHOEWaYgoXX91067fzbLhg4ar25XH9BJ00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OF1rL/jn5kNWGtIhueGtwokqoxZ6wGZVUv1k9wI4j+wdFM6SnHUi196AzR0fjLx9W
	 VHdlIAEgIm9vkJBLfmO2cLPUFm4FUUto+UYii+s2o+o//6LpcxzvOuXqlBkHOzT3cl
	 /48ReLIROCDMURSkgOozgksTIg5Uy64jA++Dk4X1AszHeJoa7K9HrwrqWOTYSrSBsn
	 mJY0tctwmimBXRsvNa47vxlGM2zgLw1IJYVxbBLrwphFPn+76k9U1v6uPS5Ej9TtDe
	 29xEFAYSoHG7HDFq8Zg/IUjM25l0gCq+sXz0n/8rRMFmOMcQOKG46xTeGT8nskIQW4
	 z8XctgHdedDhw==
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
	Lin Jiapeng <ljp1205831794@gmail.com>
Subject: [PATCH 11/28] xfs: fix exchange-range reflink flag clearing issue with INO1_WRITTEN
Date: Thu, 29 Oct 2026 13:06:08 +0100
Message-ID: <20261029120631.803074-12-aalbersh@kernel.org>
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

From: Lin Jiapeng <ljp1205831794@gmail.com>

Source kernel commit: a23eca88448e52eb1a81549862df7adce794fafb

When exchanging two full-file ranges, xmi_can_exchange_reflink_flags()
can move the reflink inode flag from the file that currently has it to
the other file, as long as exactly one side is marked.  This assumes
that the file contents, and therefore all shared extents, are exchanged.

That assumption is not true when XFS_EXCHMAPS_INO1_WRITTEN is set.
xfs_exchmaps_can_skip_mapping() can skip hole and unwritten mappings
from file1, so an exchange can complete without moving every mapping
that the earlier flag-swap decision accounted for.  In that case the
post-operation cleanup can clear the reflink flag from an inode that
still owns shared written extents.  Later writes then take the
non-reflink write path and may update blocks that should still have
been protected by CoW, which shows up as data corruption between
reflink-related files.

Fix this by disabling the reflink flag exchange whenever
XFS_EXCHMAPS_INO1_WRITTEN is requested.  The contents exchange can still
proceed; the conservative outcome is that both inodes keep the reflink
flag.  The regular reflink flag cleanup path can drop the extra flag
later once the inode no longer has shared extents.

Reported-by: Lin Jiapeng (TencentOS Red Team) <jiapenglin@tencent.com>
Fixes: 966ceafc7a43 ("xfs: create deferred log items for file mapping exchanges")
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Lin Jiapeng <jiapenglin@tencent.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_exchmaps.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/libxfs/xfs_exchmaps.c b/libxfs/xfs_exchmaps.c
index 114463c101d6..5380927a4abe 100644
--- a/libxfs/xfs_exchmaps.c
+++ b/libxfs/xfs_exchmaps.c
@@ -958,6 +958,16 @@ xmi_can_exchange_reflink_flags(
 {
 	struct xfs_mount		*mp = req->ip1->i_mount;
 
+	/*
+	 * The INO1_WRITTEN optimization can skip exchanging hole and
+	 * unwritten mappings, which means we cannot guarantee that all
+	 * shared extents actually moved to the other file.  Clearing the
+	 * reflink flag of an inode that still holds shared extents breaks
+	 * the CoW write path, so refuse to exchange the flags in that case.
+	 */
+	if (req->flags & XFS_EXCHMAPS_INO1_WRITTEN)
+		return false;
+
 	/*
 	 * The INO1_WRITTEN optimization can skip exchanging hole and
 	 * unwritten mappings, which means we cannot guarantee that all
-- 
2.54.0

