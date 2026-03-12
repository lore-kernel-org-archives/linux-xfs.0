Received: from smtpbgjp3.qq.com (smtpbgjp3.qq.com [54.92.39.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906E237F00B;
	Thu, 12 Mar 2026 07:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.92.39.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773300313; cv=none; b=mtmX+JiqtLMf+ZPR/jqK8fICLUrMvmZ/xQaVGbwaC3K4UC5MMKZtX+1wnIewSKsmXpEV83MyZaAy3eUbnnEKE9EyLz1jSh9O3qwZpA28N5aG4iFiUCOTJVfP6O/3Pz4XWwVmfFY6uwShStT1zU3P5eLwf2WzbgF8qI2ww52RIWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773300313; c=relaxed/simple;
	bh=YqJI3ZKHcmMDUHXUkAmA2+28Na5c6ZdPLLxnw6GNcIk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ApXjC857PpqRux5TgW8DXmCPMLrWKEylHzfqE4VzRYg1AVjJJ/5q2VmAdSb3p2UpJ4YjF5eHmcf+wt2GZS20gPBaHqtlMk0kob934Zdxixn60zxN+PiBb7KXIeTC01n1Ct0I79g+TyROeCT9TtVgwV86kXoVr12Fz02sCk+8E8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=VObwK2p0; arc=none smtp.client-ip=54.92.39.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="VObwK2p0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1773300173;
	bh=uE1qAgtDAGSa1NPskOkVNYL2f9OL7kBhgBuoDsOfrRk=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=VObwK2p0kZlUuiig85oR2uO/Gj+cBBFQposJb4uc2T5iHiY+RZar1Xw7MYA5JBd54
	 W5YP8iIA7EvsMy4ctop1F6tC7Tlq6gFG5nfhK5TeterTM28ci8r5klC9vZrUCZ1Z0S
	 Jz02aQ/OvleZYyRtuyV5nUPvs9khzgJ5+48QMPcY=
X-QQ-mid: zesmtpip3t1773300147tc9ef238a
X-QQ-Originating-IP: QDhBwvxszLKHKKGxKLU8mWe9rf+MrZWkRmN9//j+Gi8=
Received: from uos-PC ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 12 Mar 2026 15:22:25 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 10054979261313954186
EX-QQ-RecipientCnt: 9
From: Morduan Zang <zhangdandan@uniontech.com>
To: cem@kernel.org
Cc: zhanjun@uniontech.com,
	hch@lst.de,
	dchinner@redhat.com,
	stable@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Morduan Zang <zhangdandan@uniontech.com>,
	syzbot+d78ace33ad4ee69329d5@syzkaller.appspotmail.com
Subject: [PATCH] xfs: use GFP_NOFS in __xfs_trans_alloc
Date: Thu, 12 Mar 2026 15:22:14 +0800
Message-ID: <24B50BB66059E3C8+20260312072214.475115-1-zhangdandan@uniontech.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz6b-0
X-QQ-XMAILINFO: NuZvjORXcxgLFndWgHwWwMYYXa0pACmFx/XmdfELtY/1tCUOb3kBVkw8
	XAYA/YosconkoYbVW7I0TMoCNmqlgMGmlxr/ExDSo2j+RxB9sEBxj77PXlFVzSVff9TtzEm
	/beGyx8MvVT1lne71h+OkQDEOPP/z3hId2fbI7THKIfl5ZN4F6HzkPixJ+jrbMpe5i4tA0U
	3gNtfSefI1M+liYy0NsqIEi1DFOMpzsDR9NIaj+nYe09cwL+2mRN7EmNTYr5sCjTY7xOZOE
	CBLP248qdewZi4kP+0PvdLYlCIw31I0+0KUkLDVlXxuVw41FW6jHPEQCWNgK3J/mZetnEue
	Qq1LPteh3LD8fdwXdhqym2ld40jhZoRTfPiAyF9M65IALR9nUl2uwMcZLFq4RRtzWpGau+y
	l7JZev9sjPG0XS2ANZdM5TelcnTESPuXuU2TezJuCzRX3bFQkegxz1EPOdsdjpH4EseI2rK
	Oy3a9wrE6Bugpja9TtAlUn+yDtFKOfT8jT8V9CRsiD6OtZJ0ETT70Xe0k/q4zVQWikprxfK
	tSlTuPkMd5nh1wp+XWf3swsEsyIsoLieRjxWJez83UcLakLjiUsJqndU2VxnaKibUGLiAJ5
	U1YZKn6oUrwQVYQZ7kQcwjpWuRYkAnH5alZoURP6kh8cVkDQm9qpKHb98x9owgbdBNZQS2Q
	u1PIUXWKn3Trtfcv2tlOiGuc11RWa/PYSifCycTcLtLnbZqajdm+r5G+Ug3qaPPYbT8wvlL
	eh662o7rlcWsOqUg/DXkj/Iiejw1cqhiCl8NexrcCXLu9kGK/vJ81D1KnNNiIYZl1tvxToY
	nWp5goLMVt5ZIQtQ0b220PbcpY8UC6Jp4/XNFxY/hzSfW6+kqXdNDqaTa1FsjymdAD1dFb6
	UjGczN6/TkmeYQazUmP+vY9aYxHFC79Xzae6MZXoBqAjgfsc9Jvlu2JyKM0Xaf35F/yrWNH
	6QDxdYucMTWKJsKVyuWacE68wcviBI7t5QjlzgC/Hr8VtucRBhRJmJRy049EhUYzGiaccN0
	eNfuK47TBaF+p476kOGYYcAX7nRQjIs9+FcSF5leiGnrmKkeH/qEiB3vHFVnw=
X-QQ-XMRINFO: NI4Ajvh11aEjEMj13RCX7UuhPEoou2bs1g==
X-QQ-RECHKSPAM: 0

__xfs_trans_alloc() allocates the transaction structure before
xfs_trans_set_context() establishes the nofs context. If memory reclaim
enters XFS through xfs_vn_sync_lazytime(), this GFP_KERNEL allocation can
trigger a warning from the reclaim path.

Use GFP_NOFS for the transaction allocation to avoid filesystem reclaim
recursion before the nofs context is set.

Link: https://syzkaller.appspot.com/bug?extid=d78ace33ad4ee69329d5
Fixes: 83a80e95e797 ("xfs: decouple xfs_trans_alloc_empty from xfs_trans_alloc")
Reported-by: syzbot+d78ace33ad4ee69329d5@syzkaller.appspotmail.com

Signed-off-by: Zhan Jun <zhanjun@uniontech.com>
Signed-off-by: Morduan Zang <zhangdandan@uniontech.com>
---
 fs/xfs/xfs_trans.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index bcc470f56e46..0d347cff7317 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -217,7 +217,7 @@ __xfs_trans_alloc(
 
 	ASSERT(!(flags & XFS_TRANS_RES_FDBLKS) || xfs_has_lazysbcount(mp));
 
-	tp = kmem_cache_zalloc(xfs_trans_cache, GFP_KERNEL | __GFP_NOFAIL);
+	tp = kmem_cache_zalloc(xfs_trans_cache, GFP_NOFS | __GFP_NOFAIL);
 	if (!(flags & XFS_TRANS_NO_WRITECOUNT))
 		sb_start_intwrite(mp->m_super);
 	xfs_trans_set_context(tp);
-- 
2.50.1

