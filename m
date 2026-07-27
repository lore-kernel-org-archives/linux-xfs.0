Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36971391E73
	for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2026 02:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785120499; cv=none; b=iMSxovKwXwNx1dFKly/EbD6qswAMU0YQmbEwt4UTdZJIf/UjPq1UrsfyGCouU0aae/Y08zcEi7y6/VvKbm+s6hHloWkUHDYkA84LIYQJPniqJRe6RKWjm5D4C69GRRMs9OLrBujVyl5LvI/oJr6jhoqKSgGuBzLO/E5MDTOEhGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785120499; c=relaxed/simple;
	bh=Hpqe2SxBRfADWIfuCHLwYfQtHgpcFZezGlrcaUMzzZs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lF0120tUHqUsZHG28qNEy3lVrHMT7IF3uwE4CaGsM8zt7UOLpfUkImo0uA6rP0ClHqM0i33RD1Lx4o0eLMgJpRLnQlsVKeER9lR8h9zCPkB56vis5tjel+a+nsUDe1LbJWUHZUJUbu7UW0RA4h1v7bYoBUjJv8nAb1Kk3ZYTdIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=Ta2VSvAg; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="Ta2VSvAg"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=9VU/8ikGqnsH1VHsUcjZ/+vUcQ1HkQu1RJqBSdGfVaU=;
	b=Ta2VSvAgU1x/APYyR82yqmytYZpwZ9wqR39m13ryzgVbLVpTPogCOKzYyvxV/KmoDdAyhwGdc
	YkHTZs3VrqHKzVDDYrLoseYcGVgpVt6YaR87uHOe0RfSPXA8bIS+/V4eKGkPcv7TyHkfwMQsj7a
	IMDUSStK6U6n2vvo4Qg0OJs=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4h7jT75dH0z1prLg;
	Mon, 27 Jul 2026 10:38:35 +0800 (CST)
Received: from whupemo200016.china.huawei.com (unknown [7.152.184.223])
	by mail.maildlp.com (Postfix) with ESMTPS id 6E11940537;
	Mon, 27 Jul 2026 10:48:03 +0800 (CST)
Received: from huawei.com (10.50.85.155) by whupemo200016.china.huawei.com
 (7.152.184.223) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 27 Jul
 2026 10:48:02 +0800
From: Long Li <leo.lilong@huawei.com>
To: <djwong@kernel.org>, <cem@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <david@fromorbit.com>, <yi.zhang@huawei.com>,
	<houtao1@huawei.com>, <leo.lilong@huawei.com>, <yangerkun@huawei.com>,
	<lonuxli.64@gmail.com>
Subject: [PATCH 2/2] xfs: don't swallow dquot recovery verification errors
Date: Mon, 27 Jul 2026 10:38:49 +0800
Message-ID: <20260727023849.3247961-2-leo.lilong@huawei.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260727023849.3247961-1-leo.lilong@huawei.com>
References: <20260727023849.3247961-1-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 whupemo200016.china.huawei.com (7.152.184.223)

xlog_recover_dquot_commit_pass2() validates the recovered dquot with
xfs_dqblk_verify() and, on failure, sets error = -EFSCORRUPTED and jumps
to out_release.  But out_release unconditionally returns 0, so the
corruption error is discarded: the caller xlog_recover_items_pass2()
sees success, log recovery proceeds as if the dquot were valid, and the
corrupt quota buffer can be written back to disk.

Fixes: 9c235dfc3d3f ("xfs: dquot recovery does not validate the recovered dquot")
Cc: <stable@vger.kernel.org> # v6.8
Signed-off-by: Long Li <leo.lilong@huawei.com>
---
 fs/xfs/xfs_dquot_item_recover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_dquot_item_recover.c b/fs/xfs/xfs_dquot_item_recover.c
index fe419b28de22..63bc9ab7d947 100644
--- a/fs/xfs/xfs_dquot_item_recover.c
+++ b/fs/xfs/xfs_dquot_item_recover.c
@@ -173,7 +173,7 @@ xlog_recover_dquot_commit_pass2(
 
 out_release:
 	xfs_buf_relse(bp);
-	return 0;
+	return error;
 }
 
 const struct xlog_recover_item_ops xlog_dquot_item_ops = {
-- 
2.52.0

