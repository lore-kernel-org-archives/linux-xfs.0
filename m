Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.225
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795521797;
	b=RxdL/ZihEPEN31IsX4HQG0ibfkhym5VlMfFdsD4QTsgWBLEmyOr6S6yVudBnnV4/5+ho
	 EYjbr3chqE4+r3eZozxEjUsxR5cBIy6u/pbOy/h+1jRpgmB86x/F4U7eecHJaXrW5ZMPr
	 kz0pORo3z51/JPr6Kgp4qArvKeXJwM3xygucmekR/YCtIoCGgdjsMm0v0wq1YYFhrVhea
	 M+W7XvsDPMdKE+NYX0t866T4vW1hGqLQPVdOepgw+eHYxqoV9i7K7HY99jZRbXhWw8SJG
	 yMcrdfMbNEBpgfmoPr9jfQvIbM0qdIY6qieSk8UMhdt63yGnerTYp8FLjII6A7UANmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795521797;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=hMdf2J5zwkK8XNU82T8mFtRVr+Q6/urPpQsh62Rkq5o=;
	b=y1bxPL1fUkpXMn2kiMzoAWgLpBZOq1pN5KofGu5WJUAaWOzu1KXp0jhTn6xySDtONlKi
	 cJZQmgsfVoxaG3tbDDemzE6j6UQLI3cMhVvcqt4VwljgWiLerjoEq2qfd6thCPfH6cJYt
	 FE23OuZ0xmX7P07T1Dv5k6R6cH2qLQwIubTSeL9hryqlMhRmhjPgwxx2YCW0Otkrn8L53
	 2UDRM4IsZ3/aHYQRPrrc6SqVCwZv/8R9RWp+a2ynDoffHEuh036uhZElvwWemn2vNss0w
	 xxNgGakfa6tsLNgt59UthP5TQ4NYggAo8zt5p4XEH/oFIcAoZZP2e3vifv9msJwroUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b="pa/Zj2po";
	arc=none smtp.remote-ip=113.46.200.225
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A3E606A33B
	for <linux-xfs@vger.kernel.org>; Tue, 24 Nov 2026 12:03:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 31A3E606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=pa/Zj2po
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=hMdf2J5zwkK8XNU82T8mFtRVr+Q6/urPpQsh62Rkq5o=;
	b=pa/Zj2porz4iAxgxVl8afFHbNJTqvklbqLADw+ho2ag3ESWC37xicTTQwTUi+r+etgcCvw0dz
	r00zX6fsO/jrPMyjJi5hkRYfcOWVRzw58j9z0mPwD+cP3qcMBMD14X6wyXw69YSwdc7nSypU4FY
	wn3KmjhM5HDLt/aFV3jVSRQ=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4jYhJv124Yz1K9Cr;
	Tue, 24 Nov 2026 20:02:55 +0800 (CST)
Received: from dggpemr200001.china.huawei.com (unknown [7.185.36.96])
	by mail.maildlp.com (Postfix) with ESMTPS id 92ADF4057A;
	Tue, 24 Nov 2026 20:03:12 +0800 (CST)
Received: from huawei.com (10.50.85.155) by dggpemr200001.china.huawei.com
 (7.185.36.96) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 24 Nov
 2026 20:03:11 +0800
From: Ran Hongyun <ranhongyun1@huawei.com>
To: <cem@kernel.org>, <djwong@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <ranhongyun1@huawei.com>,
	<chengzhihao1@huawei.com>, <yangerkun@huawei.com>, <yi.zhang@huawei.com>,
	<wozizhi@huawei.com>
Subject: [PATCH 1/2] xfs: set link count when reconnecting zero-link metadir files
Date: Tue, 24 Nov 2026 19:53:51 +0800
Message-ID: <20261124115351.2301316-1-ranhongyun1@huawei.com>
X-Mailer: git-send-email 2.52.0
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
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemr200001.china.huawei.com (7.185.36.96)

The metapath repair code can find a metadata file that is on the
unlinked list, with a zero link count.  It removes the inode from the
unlinked list and adds a directory entry to the metadata directory, but
then calls xfs_bumplink() to transition the link count from zero to
one.  VFS inc_nlink() does not allow that transition unless the inode
is marked I_LINKABLE, so repair trips the warning.

Reconnecting a zero-link inode is a repair operation that sets the
link count, not a normal link creation.  Set the link count directly
with set_nlink(), which also fixes up s_remove_count, and log the core
inode.

Fixes: 9dd6cc92a736 ("xfs: handle reconnecting metadir subdirectories")
Signed-off-by: Ran Hongyun <ranhongyun1@huawei.com>
---
 fs/xfs/scrub/metapath.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/metapath.c b/fs/xfs/scrub/metapath.c
index eb987f8c994d..76b48c443a41 100644
--- a/fs/xfs/scrub/metapath.c
+++ b/fs/xfs/scrub/metapath.c
@@ -400,7 +400,13 @@ xrep_metadir_add_child(
 
 	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
 
-	xfs_bumplink(tp, ip);
+	if (VFS_I(ip)->i_nlink == 0) {
+		xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
+		set_nlink(VFS_I(ip), 1);
+		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	} else {
+		xfs_bumplink(tp, ip);
+	}
 
 	/* update dotdot entry in child */
 	if (S_ISDIR(VFS_I(ip)->i_mode)) {
-- 
2.52.0

