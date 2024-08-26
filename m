Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A300329402;
	Mon, 26 Aug 2024 03:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724642105; cv=none; b=UExXDLWGeM7DcFT+kKTb7pg6eykiZSnVlcoSobM1yib514vyO1ovlBZKObYZzBpbzfawR5Pao2T3R+6UyiuzteHQ5A3RxjOdcZids5EYZlnbaWNE8mCIHISl+niSaqZu4kG0rEX8UVzWjTpW93j72ZXAN/BfXmA1pqhvXZ1NSyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724642105; c=relaxed/simple;
	bh=UOnEWI2vYehTIUFlA0YPaT6gpPjpP1D3Tu02J2koLME=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=slWbkzd94ScwcBeg/lY1jbsoBnV6/YC/iDE54Y/z2o/RV2fdvYJxLCaTn5m6oOfh4BxL5QchSWyKX3cU/HKh7ZjMkFmCnl4eGSLhwHfLgzJygjgYZ1RYZ8eC2/TGhENeAUJWA28f8a2xk2fHwYk9Izj5lXQ9lannUfaDswB+Y2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4WsbMt35R1zhYRj;
	Mon, 26 Aug 2024 11:12:58 +0800 (CST)
Received: from kwepemf100017.china.huawei.com (unknown [7.202.181.16])
	by mail.maildlp.com (Postfix) with ESMTPS id 36C811800D0;
	Mon, 26 Aug 2024 11:15:01 +0800 (CST)
Received: from localhost.localdomain (10.175.104.67) by
 kwepemf100017.china.huawei.com (7.202.181.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 26 Aug 2024 11:15:00 +0800
From: Zizhi Wo <wozizhi@huawei.com>
To: <chandan.babu@oracle.com>, <djwong@kernel.org>, <dchinner@redhat.com>,
	<osandov@fb.com>, <john.g.garry@oracle.com>
CC: <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<wozizhi@huawei.com>, <yangerkun@huawei.com>
Subject: [PATCH 1/2] xfs: Fix missing block calculations in xfs datadev fsmap
Date: Mon, 26 Aug 2024 11:10:04 +0800
Message-ID: <20240826031005.2493150-2-wozizhi@huawei.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240826031005.2493150-1-wozizhi@huawei.com>
References: <20240826031005.2493150-1-wozizhi@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemf100017.china.huawei.com (7.202.181.16)

In xfs datadev fsmap query, I noticed a missing block calculation problem:
[root@fedora ~]# xfs_db -r -c "sb 0" -c "p" /dev/vdb
magicnum = 0x58465342
blocksize = 4096
dblocks = 5242880
......
[root@fedora ~]# xfs_io -c 'fsmap -vvvv' /mnt
...
30: 253:16 [31457384..41943031]: free space            3  (104..10485751)    10485648

(41943031 + 1) / 8 = 5242879 != 5242880
We missed one block in our fsmap calculation!

The root cause of the problem lies in __xfs_getfsmap_datadev(), where the
calculation of "end_fsb" requires a classification discussion. If "end_fsb"
is calculated based on "eofs", we need to add an extra sentinel node for
subsequent length calculations. Otherwise, one block will be missed. If
"end_fsb" is calculated based on "keys[1]", then there is no need to add an
extra node. Because "keys[1]" itself is unreachable, it cancels out one of
the additions. The diagram below illustrates this:

|0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|-----eofs
|---------------|---------------------|
a       n       b         n+1         c

Assume that eofs is 16, the start address of the previous query is block n,
sector 0, and the length is 1, so the "info->next" is at point b, sector 8.
In the last query, suppose the "rm_startblock" calculated based on
"eofs - 1" is the last block n+1 at point b. All we get is the starting
address of the block, not the end. Therefore, an additional sentinel node
needs to be added to move it to point c. After that, subtracting one from
the other will yield the remaining 1.

Although we can now calculate the exact last query using "info->end_daddr",
we will still get an incorrect value if the device at this point is not the
boundary device specified by "keys[1]", as "end_daddr" is still the initial
value. Therefore, the eofs situation here needs to be corrected. The issue
is resolved by adding a sentinel node.

Fixes: e89c041338ed ("xfs: implement the GETFSMAP ioctl")
Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
---
 fs/xfs/xfs_fsmap.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 85dbb46452ca..8a2dfe96dae7 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -596,12 +596,27 @@ __xfs_getfsmap_datadev(
 	xfs_agnumber_t			end_ag;
 	uint64_t			eofs;
 	int				error = 0;
+	int				sentinel = 0;
 
 	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
 	if (keys[0].fmr_physical >= eofs)
 		return 0;
 	start_fsb = XFS_DADDR_TO_FSB(mp, keys[0].fmr_physical);
-	end_fsb = XFS_DADDR_TO_FSB(mp, min(eofs - 1, keys[1].fmr_physical));
+	/*
+	 * For the case of eofs, we need to add a sentinel node;
+	 * otherwise, one block will be missed when calculating the length
+	 * in the last query.
+	 * For the case of key[1], there is no need to add a sentinel node
+	 * because it already represents a value that cannot be reached.
+	 * For the case where key[1] after shifting is within the same
+	 * block as the starting address, it is resolved using end_daddr.
+	 */
+	if (keys[1].fmr_physical > eofs - 1) {
+		sentinel = 1;
+		end_fsb = XFS_DADDR_TO_FSB(mp, eofs - 1);
+	} else {
+		end_fsb = XFS_DADDR_TO_FSB(mp, keys[1].fmr_physical);
+	}
 
 	/*
 	 * Convert the fsmap low/high keys to AG based keys.  Initialize
@@ -649,7 +664,7 @@ __xfs_getfsmap_datadev(
 		info->pag = pag;
 		if (pag->pag_agno == end_ag) {
 			info->high.rm_startblock = XFS_FSB_TO_AGBNO(mp,
-					end_fsb);
+					end_fsb) + sentinel;
 			info->high.rm_offset = XFS_BB_TO_FSBT(mp,
 					keys[1].fmr_offset);
 			error = xfs_fsmap_owner_to_rmap(&info->high, &keys[1]);
-- 
2.39.2

