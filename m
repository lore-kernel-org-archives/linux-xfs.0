Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771D52701B6;
	Wed, 22 Jul 2026 04:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784694549; cv=none; b=dBh6bKbKwtF+nxVnuXsR6IOo9a9Cy8j+wTohKLjYsAUkuDiv3iAfkVP9WV0JvmVu6MQ9bnoZt8u83tVIMWt1WmUb4pF6QbLftZfzfpHl4xceJ2TKEozPs/y91SlGXMq08gUMl/jgohGzZe1ujPhabAhEJRH8jz1S7LzBLTdlCAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784694549; c=relaxed/simple;
	bh=OaAvI1aS10q4a30xisrOHUHvH+ZSQ8OVoNVGWuHfQYY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=SvT/fzhK9AotHdaNQLgHSn+acOs5ouEHwuxdzHJsCOvZ1I5g9QcK9QVNgteGvmmOcyLEaaJPDcJl/VarK01v+yZSGnERWtQONvMiluwHDnUp8k5tp6vvvFbLFSd+V7qJPZOpMbPSx/+WkAjnAGDHptWFAGuXCxlRur9riPlBEYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=MiBk3SBZ; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="MiBk3SBZ"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66M43IBt225720;
	Wed, 22 Jul 2026 04:28:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=PPS06212021; bh=deUZzoc6E
	B6tb3MnrId6PE49GQddM0CnaEmbrC1ZrGk=; b=MiBk3SBZLol4Pq1ucvTTSpyn+
	Ss2bzz9+7N5TjZQ47fOIPbU92ZS00WVrOQJbUxKzqR9i1wqKSJteFlDQKOCWd2oR
	3EhEX2uHwgsZKxW5fVIWJmVBA1Kodc+VWz1HRN2hT942YE5umr5fU0hyI0dzsFgZ
	M6+YItItH8U9puSB07P92M1VZsCgaLJEITCG5rVukipS+5HG+dEXZyA2WagHvDIq
	hS7HOJuH697ov0JjgD0m2j/0d4pB7UwKB0LZNyU+UcMKGYN5pn7wNfyHKvRVwju9
	xnhtf4+rMGEvMijmdx/juzXx6wrxsKtjTpSsVBeVSb8NUagplpMCSas6RVs/Q==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [128.224.246.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4fga8x6y91-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 22 Jul 2026 04:28:45 +0000 (GMT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Tue, 21 Jul 2026 21:28:44 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Tue, 21 Jul 2026 21:28:42 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <cem@kernel.org>
CC: <djwong@kernel.org>, <hch@infradead.org>, <linux-xfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] xfs: fix compilation warnings in xfs_sync_sb_buf when CONFIG_XFS_RT=n
Date: Wed, 22 Jul 2026 12:28:41 +0800
Message-ID: <20260722042841.220534-1-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIyMDAzOSBTYWx0ZWRfX6Ay1/njHepLN
 jxGxEVaGGQCELHDHQOj8zUtvgVjvjJh0bCyzkx/ryD4Lct8eKQYh4YKXeYLk0tg0E7V2D+3tGt2
 adNjKhq6Ine7gScMYvmeI14xmytSNuas6WyWfkMxuHqZk852uTSu
X-Proofpoint-GUID: QyDiTmeJ8ahmv0rsZCvbkwQWdHOrRvYe
X-Proofpoint-ORIG-GUID: QyDiTmeJ8ahmv0rsZCvbkwQWdHOrRvYe
X-Authority-Analysis: v=2.4 cv=XdO5Co55 c=1 sm=1 tr=0 ts=6a6046fd cx=c_pps
 a=AbJuCvi4Y3V6hpbCNWx0WA==:117 a=AbJuCvi4Y3V6hpbCNWx0WA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=klDOsUkWDRETUCZYPvoE:22 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=t7CeM3EgAAAA:8
 a=eF1V7g6Ew9qzYuUyCr4A:9 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIyMDAzOSBTYWx0ZWRfX0IdWGQcTTSzo
 pjcne3ZD3HA93NRg29brNWw1KxNV0e5kmFZ3mJKCqoFAhuunRlINnUg1a8/MPWiCeiLLQsSTGsT
 mYkFqebMACqYAlK1aVrNlLH2bXFoZ3tj7YQjWpB8MBcMktJNCcV/1guSBDlz9pdQgVS7HJ8xtOe
 61B/JEXLd6O59I4ZN0u3anIDcoaz5aVubmUSTxJBjKqMU/W9p+2H5Ta48XBQsQMipI6qcSu1b6X
 t25waA8yRohihpO6ihlcxB4XDQcyABEJWdfD3R08lyt9etciw9q0dpsjPTcl68BUguJ/029H2TD
 Qw2NFJ6ub55P2nI/Ld0cbmzcuCGrxNl9eEwwgDNIuEXpv7JLC9bBrsB+R31yzjAeuf7Mw8O/G7q
 lMI6h0PWFQcg1K9X6YrHMH+IiIH7zp6d5oEDva6Db6oGDj9SOe2/vo88A9S91p7Et5L/J06xYcw
 2HqF4B4gUrvu/TzCmtA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-22_01,2026-07-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 lowpriorityscore=0 suspectscore=0 bulkscore=0
 malwarescore=0 clxscore=1015 phishscore=0 adultscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607220039

When CONFIG_XFS_RT is disabled, xfs_log_rtsb() is a macro expanding to
(NULL), causing 'statement with no effect' and 'variable set but not
used' warnings.

Fix by removing the bp variable and passing xfs_trans_getsb(tp) directly
to xfs_log_rtsb().  This is safe because xfs_log_sb() already joins the
sb buffer to the transaction internally.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202607212237.Pzw1sr5k-lkp@intel.com/
Fixes: b9ad0b9891dd ("xfs: don't hold buffer locks across sync transaction commit in xfs_sync_sb_buf")
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
---
 fs/xfs/libxfs/xfs_sb.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index fbb4505b1e9e..c4fa7fb0e39a 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1470,17 +1470,15 @@ xfs_sync_sb_buf(
 	bool			update_rtsb)
 {
 	struct xfs_trans	*tp;
-	struct xfs_buf		*bp;
 	int			error;
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_sb, 0, 0, 0, &tp);
 	if (error)
 		return error;
 
-	bp = xfs_trans_getsb(tp);
 	xfs_log_sb(tp);
 	if (update_rtsb)
-		xfs_log_rtsb(tp, bp);
+		(void)xfs_log_rtsb(tp, xfs_trans_getsb(tp));
 	xfs_trans_set_sync(tp);
 	error = xfs_trans_commit(tp);
 	if (error)
-- 
2.43.0

