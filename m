Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 911E61C10;
	Wed, 27 Mar 2024 00:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711498416; cv=fail; b=BmCpuQr07T/+4BRp5TIGZvK9TgJ7VVpsbIs4Ril9PgaB8dBrsiCJs505B3mUcWZbHeP+DUF2NREpoIjKesBBrTNhAs7QxzXmIUsjLlPpuNVptQutGh2DByJzviZq2QifMxq7a3nQHO9JEwZ7dDHnKNme2SAs2tv5oskRKr0BrbA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711498416; c=relaxed/simple;
	bh=DNSarES2y5yOecbp6OK7DsfHtlTAV8qg8UT/Ejzq7SA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=N0kMnIpZmNDZEg/MyTCnMHTd7z3oRzR8SR5ZImRJgMFvV50VrdmC0pvDREBdtEFC9pyIeJ++XYQpLYJQY2jqNzRixO+vh+m1EyEp5Kc9ACcFRdG4YrEzh6g16sUgSyCkhjxUdElc6fvdvEd/lQ3HeUdVvs8UrVFiYBbEdngGGB4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kLacjjiz; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nioDQq4z; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kLacjjiz";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nioDQq4z"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42QLkkwU021636;
	Wed, 27 Mar 2024 00:13:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=bShdDwvHsGs2NR3HsXWe6RilurHwTjdSm+vsM7SPlsQ=;
 b=kLacjjiz9BLuTP1G2QJ5aqF7LMSyqTx3kllZkdl1EBDqBDGCGWuGjucd9bPpoRbGbPW/
 8sCCttzimNOD0sjKTUnxI1DaDPlNkvLmgX5702FYhLeIFZ1E2rLWffxUGlGhs6Khj5Pg
 WlwUdCbwhnyOZbiGypCm9oCNisLNGOrisn9YDlwaAZOTg5HHkcZ2BdzdxMoJs8OwJBGq
 fNWZHKJT/Wf5A9b0TUQ1SLvHMQIb9eDbFe0aTYc1h5DoCapuJcAtPe+fuq7rA+wcXt9L
 Uy7lJYRs4QbxNJu5bBH4kQ4ikDm4QBEp77QFLoCP8ZmED5jWjnBvEJVTFRrc2B5/NlK/ AQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x1np2ecc8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 00:13:33 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42R00VYJ021951;
	Wed, 27 Mar 2024 00:13:33 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2040.outbound.protection.outlook.com [104.47.51.40])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nh80xnk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 00:13:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R0e01peIQBf47sTrVxf6y5wgz9P4THFI5xvCRBCKfsFqtmvMUwxPnkd7bjzfmx5lLxtpNKxPq3abXed8WlyRfxqPIXGqC2MtzDLsOxu21SvbJAZzLow388TriOQ6K5SZxlk8C64oiHhltxCtWypEFMl72eeNvybSkkH2kUACOCKt3dCZNK9UStbu2jfXXIRXD7ZRFtcjitW58ihpNo+oOO5zeAGT8L20bPTMlbAcZqebL6x+GP260P9D+dk9Sx3G8OfH/YQP4dn5x2rJKyRbf+J7p2driP/aohOvr4G7VXl+5s5B3JvxVFC4FUhTHXj6RjPwkXi6dx0bF1/+auGFZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bShdDwvHsGs2NR3HsXWe6RilurHwTjdSm+vsM7SPlsQ=;
 b=lRcrXsULRV9XeqhnmbsEJtlMVrUdJ3JQfrM4Yk5NOl87mByXAibzpXjEr4moZDacERhXfXgun1KPCibU6uofEOi3ck6w3sLXHgwQFURaqLkddbzzYp5isrb/JwEIDNYwoVrpF7RaD3sDR85/Du/TDEVb4FpQg90+XTC/+p2FsWMxLhOJVQV+mmLl6vrb1VUU8AflUPxFpMrfRUmHcek7bd4zZZyFgNYP9ErnzF7isP1GlnpC2/XzPiMQTrWyv3b5LQ2G/Yslv0wSN7Eo3XigiuH1N/pzNMJlFEBkxqOuW1SA4OrOCVfIQtHNu/iC1p7Fewp0c8aFWd52PB+z8mpwYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bShdDwvHsGs2NR3HsXWe6RilurHwTjdSm+vsM7SPlsQ=;
 b=nioDQq4zmO3yU9/69abGLXg3ifGe41ifKoMBBEvBzRoW2Br4uPFOpN6xm7EfAA78qOHCIxwn+unc9XUqzV5g/8D2teCL/KOIPTyfRiTsrC5a7OYTyu1x5lOGVNCTblvbbM7Twvoyj4fH+wuEQCqAviTqMDZhC8oDZYU+mvCsn9s=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BLAPR10MB4897.namprd10.prod.outlook.com (2603:10b6:208:30f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Wed, 27 Mar
 2024 00:13:29 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a%4]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 00:13:29 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 23/24] xfs: reset XFS_ATTR_INCOMPLETE filter on node removal
Date: Tue, 26 Mar 2024 17:12:32 -0700
Message-Id: <20240327001233.51675-24-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240327001233.51675-1-catherine.hoang@oracle.com>
References: <20240327001233.51675-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0209.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::34) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|BLAPR10MB4897:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	vD9bQ8FcAymzAQcaKpbrpf/aJlVfjowR4JnOymkwVf4PSzvLuaiMUF75F21yYn6Hwgs82jeOwQln5MSF3rCYsRW6v8/JXF0lCBmfmqggx6JxJLTReOm70BCAZzVYplQiwYPT5s+a+UkECe3zOa8n9uopi0UGrbBvDchE7h28yg85En1MpxBeWDAga9gX5A/ZQBk5FrM4HMupkCLr6eB6z32/Q3PYNxaRCWGKNkbZ7Uhmz795WtWRA3y7lSl0AtWrRo4ujuR82ZwB/k6+QXBNBSO+hj6rOJLuw5I8rsS8ZPi1qYi3yfTepVg22c8TZhjwrh6yzdK7I8faWynqZtODonxkVKWKzSstLJVYuRbqz4zz7Dvo+1s7vqEzNTXeLJiXRuH/lLHKpaR8EDgxbjJzWRARfxexToBMnQ4nUzD2uueQTSKcaf/aXFSXHCQz4NlcsWBxRl3PxW+QlBJLexeCceoMYxERa8Vf6QNt3sSH0+XInls8gL245poqyVKphrFJlWStpKcD2c0JP23TLktZ2H7eeCiB6CuTj/zL20jz4I/7hpwUIuAf2yf1qGD2A26QKVGHXMqErkqm0yd4W0v3H87NeApxd1Iao4wdB9LS50+x8B4qnRroez+D/wJPQerezp1C84egDfo7k8ZAXkj8m2ueRtLq1QVWoPi1ofXbUS8=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?NSjpJBLbWQ/gIFvn1aIIvkji9w4ZiMiG7xgmxHAHRaFCgKsN0uG86ulgWu65?=
 =?us-ascii?Q?PiGAfjMAU7MAvU8l6brO9DzHs7qjV0yXGyTiKEPaAPqddBayzrdMFXkOmjpr?=
 =?us-ascii?Q?MhvXgWrY17ysJI5s0uUEt9qkFwa01yU3jbSQKNTLA/jRJG4pd+4I3JrCvfkK?=
 =?us-ascii?Q?gEPRAp71L132KDVQY2FDbuXis2rffy+AXQJUf+/5QfUA9VmonuXx+ppM/7wT?=
 =?us-ascii?Q?8YKKU2HfI7sbxiaISxMWj+WzREa3z7bN2m81mWmvxFhKj+GrjD/z/2h7yIcX?=
 =?us-ascii?Q?ET54+XfGqpdWqzzjJZ+Czg0QBg+JNuMJOMy1XVfmZc16uTTlYm07WcOACvo4?=
 =?us-ascii?Q?jGiap6wtydnvPTMRFgLHmkzocFOvtj4chlSGgoqrNAlsPPSk2oiDGCFL2WRC?=
 =?us-ascii?Q?eQsyOy4ioC4C5OmXI0yrEAEGCFstILvKWeWB7ayrq/sRf7Hc+1iIalwfflxU?=
 =?us-ascii?Q?iQLe8XE5EoOWFR9PniLdCbjOykIXTrzROLJ91qd5P/ty5zA0FaGBG3QimnVM?=
 =?us-ascii?Q?ReA1xnO+lLl6BDB3rHIXweYgPnYQqWjCGtFy1gz36OnsbW67q3vXyRPnM0Vn?=
 =?us-ascii?Q?10lGFpfA7SF1HixAOMmi1tTHl0BEn56G4ZW6nyLfIp3aUiAQSbYWAmmfS0KT?=
 =?us-ascii?Q?X+qellwO5pVxF0ZtFOtdLhEZ3IBKz8T6y5VkOloIr6xcDXsYO8hKNv0d557U?=
 =?us-ascii?Q?CZ7tpePJEgRUEJK5D8/CumoLx/uXdU0JD/oMjL9xn7O3N9TaH4X/FkyMoaXg?=
 =?us-ascii?Q?AlOXiKrAAB8iTwYKF1kxAI/5/Mi8Qks4Tjl7GD7O33vnPDikSi+YLWWSy8cq?=
 =?us-ascii?Q?olSPAsv1c3FpxwkMbCRKEVYE/uYqVmp/pady/1W7rI2UO0Yi/LpWCKQVsXnR?=
 =?us-ascii?Q?+8N/FpUmEYv+go29fvZBv4iJkNPH5zJChZIwZq0p8We+zUDM7y6g8jAyOFkt?=
 =?us-ascii?Q?qCWbzEtH78bPIHKFfVfQ47WojoO8L/w3y4lFQq4aNIwVbbie5SZFXSKiNBZ8?=
 =?us-ascii?Q?ANaTuJNLQxVvlbE6qKNmOKaPO7maZfHpUZMIHgyrn3PzekcahOS+UgNQUzAA?=
 =?us-ascii?Q?OgTUQi+7keZIF1hZupJcv9YctWB6JRWmEGdFZ9n5QXjKH8x7yUy1leudCyrg?=
 =?us-ascii?Q?K5Eeop0EEj96kZYp0OuZp945Ob1hyIHmDOP0fY2zbAoKw/ngm+tOlUR5xanh?=
 =?us-ascii?Q?/kxlrHjnw0kOGDcBuiO15WUOi/5Ymv+7kWtYswNYC0lXRAVm3Ea/wF3hH5qP?=
 =?us-ascii?Q?R/F6GI2zDFHlGxTlGVKsxdaBAVLByOlxK59z+jorqvCO2nco8GOWrBrsliZG?=
 =?us-ascii?Q?1/2vetCT8wnflGCUaRadQ5BpCWZDMmsxZcrMZq/gfp1heEVqdCYFQcp3dUgr?=
 =?us-ascii?Q?FK+5sye4EacnC8LJgfmn0Gq/qHFJ0idsvfnzBcefnQgtu62hy7+463D/TkBc?=
 =?us-ascii?Q?GL87qGVdNYAqUwXRNhLrqnUZQHFLNg8bNNhxgLDhyhfnmT0TOHn1HvXQGtg/?=
 =?us-ascii?Q?GR561iwGbyAw0FKOfni8wHJsQFpq8S4AmtAZJmcA/MkaOKitgzPEqiPeCzf/?=
 =?us-ascii?Q?aHcwUpGaBgoM2pLGIfBb5nFA6swsp1AjZo6jTOyDqtXKQydZ2S0nT1MPqauZ?=
 =?us-ascii?Q?BWAvlhVJxr2u100zHqMtB3w/cnOzZfQolW9TCgxkEMJYgfe0QHlzpayn8UPJ?=
 =?us-ascii?Q?n9XUxA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	/UY5dsj93uoUDlfeASbWpyu8lEIPchgpeOKEpagfehIJuPdpOqfQJJjvVmm16hBRDLoGEfL06GMSmEDN+zj/UdBIw2FHtv534ZcowolbxI/HD3uBUxu19m2vOCCI9aV2kG9UmGOAdtOtEGeiwj/dBptwtILFFlS8Na0LLQbGLjuJKJbaQdS1OaMJH4xAtcHxmbvPoYamQqlQNvoKnh2ozXwRM0LvkVymRh3P/i+itwsP0EXn/ESp+WA5eg63WvfdEKicrE2pBc4V3/qKwqt8UDqHrMrFFBSnvQliwUU4HkMYjul/qWa9Ayg48x/tEn0mzaJq/fBYpPcNzqfxmGBg+0Yi/r9jommYErH3/kIdOQVm1zCUz7hwFGruTYksiXQBoV9AYG9XXB8uNk+jj5dmq1t7jY+Of2gdbHbrGjJ58Vd/BZa50Nm7M5xBOQ58P6SXSvO8XO9R7JTrOpfieGt5pKX/rnSR2L0wEsa2CorMQJmWPfqYVlK/u7CRYRMqFY401SsOnHvOrhfrxAhnSYHD47LTWA50OdhQkeMnqNxAw4/V6NbJj7L4bTzm++fv4xEwHU6+c9CEj+/1mX41IHZBasQreZK9xOS7VBr3upLFeoE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ea3e890-da45-4deb-3118-08dc4df2baf5
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 00:13:29.5535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g/eW+mT1OvUE1s8qgGuKTkwACfOElO/ONr10mlS8YFDUs72fNsk2W4T6lIJhxRARnlY5yfxOIYfyG7PAnfAwQdObdCiuijkpJZCq0iXnPR0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4897
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-26_10,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 bulkscore=0 spamscore=0 adultscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403270000
X-Proofpoint-GUID: 0rgsKcrao-vjJAG_GrjRDXu7wwzuLTCn
X-Proofpoint-ORIG-GUID: 0rgsKcrao-vjJAG_GrjRDXu7wwzuLTCn

From: Andrey Albershteyn <aalbersh@redhat.com>

commit 82ef1a5356572219f41f9123ca047259a77bd67b upstream.

In XFS_DAS_NODE_REMOVE_ATTR case, xfs_attr_mode_remove_attr() sets
filter to XFS_ATTR_INCOMPLETE. The filter is then reset in
xfs_attr_complete_op() if XFS_DA_OP_REPLACE operation is performed.

The filter is not reset though if XFS just removes the attribute
(args->value == NULL) with xfs_attr_defer_remove(). attr code goes
to XFS_DAS_DONE state.

Fix this by always resetting XFS_ATTR_INCOMPLETE filter. The replace
operation already resets this filter in anyway and others are
completed at this step hence don't need it.

Fixes: fdaf1bb3cafc ("xfs: ATTR_REPLACE algorithm with LARP enabled needs rework")
Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index e28d93d232de..32d350e97e0f 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -421,10 +421,10 @@ xfs_attr_complete_op(
 	bool			do_replace = args->op_flags & XFS_DA_OP_REPLACE;
 
 	args->op_flags &= ~XFS_DA_OP_REPLACE;
-	if (do_replace) {
-		args->attr_filter &= ~XFS_ATTR_INCOMPLETE;
+	args->attr_filter &= ~XFS_ATTR_INCOMPLETE;
+	if (do_replace)
 		return replace_state;
-	}
+
 	return XFS_DAS_DONE;
 }
 
-- 
2.39.3

