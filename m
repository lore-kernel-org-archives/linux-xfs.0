Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B850E34D389
	for <linux-xfs@vger.kernel.org>; Tue,  1 Sep 2026 05:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788241462; cv=none; b=hKP2rsdfHM4TPrBnj7O/PGfTXbhQJZT9LAb8kkXbGGMSpG65pp7qyiVN5gmdrheOs9ITEGSyT6aJEO27XMYy/v0TR6HUcrWF4pu+pHTZW1WBUBXfcnhWmn9/PRrfOxtaMgu3nql7sDpVewL0jm5032Q0JVXqW/fRaR8WQB7epd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788241462; c=relaxed/simple;
	bh=sE0zQ67z33iVQctRUGZblUC9POnIRK6BFjZb+4qq2aA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=iNFYftx+cZK04RsJsJdOOkQLW1qUmZd8Ny3qQKF+dab7V6dDZAMbbwSPy4EPaOHFeq8pkHx+4Yvf7PSsE5rdV2TAzMgVd18dtrR44wIck3GQuI0LXX5gszhw3ywFquyFIVddMmT34wqSwbxGB3U95fR0Rtu9I0uUfxo5+n53RSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=gm4F+S1W; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="gm4F+S1W"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260901054418epoutp023cebaf230c75025efd650579b62d87aa~RHCHL7tGP2344223442epoutp02d
	for <linux-xfs@vger.kernel.org>; Tue,  1 Sep 2026 05:44:18 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260901054418epoutp023cebaf230c75025efd650579b62d87aa~RHCHL7tGP2344223442epoutp02d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1788241458;
	bh=T+0OqII1y5b1bRgsTJF+0/N0DB63yEf2utvhQcUva5I=;
	h=From:To:Cc:Subject:Date:References:From;
	b=gm4F+S1WI59rheJeHXAfi9wV/HP6Y3EofZZL/ryidCVolN+W8sqLeHB5LRqb+JU7d
	 tH8UzURW+24xrehXD6mqyTz7AtSYQH9KT7nEN3DdyJZvCwTwD15NMXaKNOXJ4XnpxH
	 eh4AOGU6CouhdoR+r3uYWruZMxeeJuKeEIk/37jE=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20260901054417epcas5p1cf6b3e896606ab9de3a3286db07229e3~RHCGit4og1394513945epcas5p1P;
	Tue,  1 Sep 2026 05:44:17 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.93]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4hYvtn0hCTz6B9mD; Tue,  1 Sep
	2026 05:44:17 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20260901054416epcas5p13e8b9a5e5e8ebe10715f735c82ded916~RHCFcZPpr0936309363epcas5p18;
	Tue,  1 Sep 2026 05:44:16 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260901054415epsmtip206f33e2d6caebf96b84c3b33bbb42ce1~RHCEapGWh2450824508epsmtip2P;
	Tue,  1 Sep 2026 05:44:15 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: djwong@kernel.org, hch@lst.de, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>,
	stable@vger.kernel.org, Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH v2] xfs: release alleged child inode on metapath unlink
 error
Date: Tue,  1 Sep 2026 11:13:48 +0530
Message-Id: <20260901054348.808571-1-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260901054416epcas5p13e8b9a5e5e8ebe10715f735c82ded916
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260901054416epcas5p13e8b9a5e5e8ebe10715f735c82ded916
References: <CGME20260901054416epcas5p13e8b9a5e5e8ebe10715f735c82ded916@epcas5p1.samsung.com>

If xchk_metapath_ilock_parent_and_child() fails after xchk_iget()
succeeds, release the inode reference before returning.

Fixes: 0d2c636e489c ("xfs: repair metadata directory file path connectivity")
Cc: <stable@vger.kernel.org> # v6.13
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/scrub/metapath.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/scrub/metapath.c b/fs/xfs/scrub/metapath.c
index ff1ff762b300..3492f171a049 100644
--- a/fs/xfs/scrub/metapath.c
+++ b/fs/xfs/scrub/metapath.c
@@ -556,6 +556,8 @@ xrep_metapath_try_unlink(
 	error = xchk_metapath_ilock_parent_and_child(mpath, ip);
 	if (error) {
 		xchk_trans_cancel(sc);
+		if (ip)
+			xchk_irele(sc, ip);
 		return error;
 	}
 	xfs_trans_ijoin(sc->tp, mpath->dp, 0);
-- 
2.25.1

