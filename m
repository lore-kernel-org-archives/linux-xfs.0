Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A5E134BC;
	Wed, 27 Mar 2024 00:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711498391; cv=fail; b=dqLsV0GdHKaz9R606hw4OxnwnF+oDIxP4cd+/aozwQnfzUgI4acnB266ycW+173nNR6Y8ZFrRfa/g9qKErex85aMXPwpD1s9dXX6QeQ3J/KGMuyA5uTKmFUpTLBR7HCG3nD3C20Yi1bBni8O7JKax7dsWpKG+JKDb19W9Q8PtL8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711498391; c=relaxed/simple;
	bh=X4k2P3lm3XL2Yf95xt1yA8uWUajrIW3XiZg7fLnbt0g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=u4jOjiAEGspblmD17XWJgPlTGgRdVRTpAXfJE/7iLHpSzEq+qIbQjw1Mc3stofRIxkJAog9520VLvWjOaguSRQdnNjxxBgZTpRwCrJphi1eys32G5hh4JTc1bJXu9vS4WZiby8tzy1u+2lMwIH58Ul9mQAvXVHWFutxqOPwO4RU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fsuwpiF9; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=HCZR325G; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fsuwpiF9";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="HCZR325G"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42QLkgbr021513;
	Wed, 27 Mar 2024 00:13:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=Hp4XfHXjuaFPH2SVMc06n+relXQUy17reKlpu3oGGC8=;
 b=fsuwpiF9q8Mn51CocIzftqkI/kuo+sEEgE3EGhed+x7+4ygWkMMvBK8/5H6TdfMmNBl4
 3iGu/p/j4l68oH8Yc17TscURObDTBmTUXnWaF3zl9EJR0mVVswu+60F/NiGgEiu8ILEi
 BdI4vqNBjkbkdQtRvLHKhMNnh/sS7wEW5xoGn/IFFN21l9NHToQQYOHueKejxEuBhWMX
 hDdydoeA/n8munc7SJcUv0sYi9JjGfyioILV5L31wgJNp/MpvNVu3GhNvPb2N/cIoOT7
 k5UbBq2dCIO6m19u9DPi3potK75xK93yZzhCLBbGcwmYUZF3JY6Cjj7YMguzbRyVwQ9Y TQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x1np2ecbu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 00:13:08 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42R03jNe012586;
	Wed, 27 Mar 2024 00:13:07 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2040.outbound.protection.outlook.com [104.47.51.40])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nhe1rdn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 00:13:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WCA8BfHCaYUXrrV2ODa323CZcSVLGsuAhqRClkdRgYuUnaiI1zsImX4Wx6ksPykVhI+qjxDNy0R1pF2kbONFqsTfadRopYhrPeF0lfgPJPwD5Z49xTpnkMfsLhNP76Lpt1eLKciglTDR07ES5TosdXUz+/W8pdJe79fHldWCFpX7lBkoP5mis9z9Vk0BJg8A37hqHjAI7nemk+HY+Y3QnFXhVohTE2BrpVSfYqnMtPKcIe/VFxCwcvPo2kMHl4M+FsTjCch4417P4Wqv27uKTTWTVbUaBhDPfh1yCG998qWRSPRYrKZWt/z+SLRwx8WX4v9nxChnSGKVvccGphcOtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hp4XfHXjuaFPH2SVMc06n+relXQUy17reKlpu3oGGC8=;
 b=MtrHvNYnfVNkIjFzYvpDxXOqU+zQte0QwScoVtL6Hwrd3L7OkcapWU3fTcPg4YySxI+yJeob8ZDDq8zbwY7I85lJ0U8IsD6pp9V2MZgK+cCMPUfj6S1YGmdPbGRDC4O8b4WWxJP/CiEuYJj0DhaOiUztzph03xfzbYLLGUMIuyWJ78VfIvqtGqfFD1SrsxKHRQZqcZ3p0XFjy+4X4Ch/RRqQZxu2QEuZGZ3AKzukj7D6ILbtGvwws02HAx5vkfFy8Jj8JvPZZ2QbWGis1V1yO4+aBHYDk76XpxiuLuC0cKIQw8jT+rbPXm1FhOj+2HJVUFXDUWMam19DeeaC0IuOtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hp4XfHXjuaFPH2SVMc06n+relXQUy17reKlpu3oGGC8=;
 b=HCZR325G2+AXNE3tTOcJy8Cn6UBx5ggDF+cYTkCln2q3ED5ILm8WtfVVgySJ/oTHON94r5Z/BHOnkd9Ge6L6qpqsXlV48VzHigyKGFfZCYWzi/emiQ3Wr/vPtPjM0+W8Iw0XoK9ZsGRf+d7tLcvJtXeWfao3NJt6MwmHzt2NVr4=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BLAPR10MB4897.namprd10.prod.outlook.com (2603:10b6:208:30f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Wed, 27 Mar
 2024 00:13:05 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a%4]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 00:13:05 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 11/24] xfs: make xchk_iget safer in the presence of corrupt inode btrees
Date: Tue, 26 Mar 2024 17:12:20 -0700
Message-Id: <20240327001233.51675-12-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240327001233.51675-1-catherine.hoang@oracle.com>
References: <20240327001233.51675-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR13CA0027.namprd13.prod.outlook.com
 (2603:10b6:a03:180::40) To BLAPR10MB5316.namprd10.prod.outlook.com
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
	x73OzcPuBOZcb3vA5Mhpl9E5NDQ98A86BsEYDrX9/z64GLTa/uZlxtjT6CZxYbD1935cLW40YDL8JuxWZ9ll0hpSfSAwwzih2aQ200Z+/51lYy5gFCtRThSLYe7udaXiqLEQbDAT+krHkFOryBexc/lSYE2SciwQ5WVGM6Ukkcd+HgC4gXHeJtFtZc5ldQKcIq99dQ68w7+kQgbTdI8xTzdHSzuoKZLuhYCIORyGofrw44jGIVVn+CNsD9OG0XtZ36bafWm6rpj9vT+cWy3HI+5a/lm2u65mHKWCwy87ofIE65vVnd+XFwvwrXiV1OIe7PmWmtDi54aY/yt+pMC/gDHjct/Zsty9ByLwbRSSYM8IVzBgdGsaVbAPCU2uzu7ELLL3Wj09VHMROtHRkr202GWmdIdX3giR7eU0Ws0U1jKkrTvAP/bCZvBuszMOFQwhRNnOcbfjG7Xrw58TPBQmlRSkMHA0cE5Zr0HqV776ewDpgBAEkbXpYP34VupjyED4es0yOX9RLGDx8OC0BwlxlyxYjVs347V+Z/n7oqOINpiFP1QwmwCexHE16nRlnJkR6ixTKVBbBGeUSEdzniEcisC22wiJ7V6RV1ruutWztqR1ofGcZQ5kTHIusTBG7cX+odt7IjX91aGzHUKfawFycJ8tDxtG3N3p2cKXRxgA7io=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?Yqy25pSKUxtET083c+va01Ap6UFty6+8F28hZ9yq3JrPLHH7HsWXv7PFYHMU?=
 =?us-ascii?Q?cig6jPqRQoI5Pge55IIX69SQokuQH6WT3zUMEHKd2fj5TU4ah5zsjH9zjzQQ?=
 =?us-ascii?Q?nMukbhXp2dOud3Qa0+R8/x+V/tIJLysS9DJjxH4zrcUF9bTfIg1ZquFgfF+T?=
 =?us-ascii?Q?2Qe4dlketjsCQ3BIJ0K/ZuFaRMtsn1MNUPl4P7fTgTrX6HtH6z7AS7BWskDy?=
 =?us-ascii?Q?QxWBlY5ieByMrjzEZyrx7L6z9arGlqUFj6rzt1wyk4FeBPJnUxfpdwGWbW0B?=
 =?us-ascii?Q?a184Vn2QLdqmzwuf/e/Ik1j1IaMch6AmGNL3lMJtwJgDnn/oljvzfDsrH087?=
 =?us-ascii?Q?x0myPvo1C02zIQ2LbGB9ohowB5gI4XPRANnKfLmxRjBKB6t8gQfoq6Lg2oxR?=
 =?us-ascii?Q?UzuiMuEavBvI9OwmemXZ5Gmr78oDIWX8ucV5jpFzTqiXsFiBTGr8C+pVxwTb?=
 =?us-ascii?Q?yWKmeTup02VCyKoYzwf3Dipb8qhB68Qh68g2dGoU9ZUZCrHX7QJggMjv5ICS?=
 =?us-ascii?Q?KhjiyspGTqCHqBc2l9amYUGY+Hw7sh3fCHz2XErQKQwkpyfjudw4/AqzYBo7?=
 =?us-ascii?Q?Ep8JaUU8UEhf78t2QJA0/lXQGoOlC5ncgyKT1vVc1vDuJpBNTpmyeLcBooFp?=
 =?us-ascii?Q?oojgskXSPM6OruuvHmwKX3PmCoSxE73ESOPUz6tGwdtkkTKrHzA5ofVqq6OU?=
 =?us-ascii?Q?zb6ytMEoBJWfUfNuVwHzDlRjBe6XOieFYC9Q7PSRV36Wv3ySN7HwS7l1GA4I?=
 =?us-ascii?Q?suTOuGXm4BfKhFu6BA6rEcJ2I4z6UH9ZLop5ra1lbLi1YYGR7E3V6QZhCRh8?=
 =?us-ascii?Q?vfGMwXhWoWVRsQSwj+F7ibyBh0AdQXQL/eJE4Ou0gG7NPGSwEZjEb1cANcBy?=
 =?us-ascii?Q?EHGHumm7TPEx+7RUBpZ5HvfVY8KlKUtc93aG7kT6rfexyWtM+2G5V7jfrevN?=
 =?us-ascii?Q?Y3M+xNw6yd8eVVqt9NW6AxriONxb+KNS0C9M4R9O0jhyre5IWUA7TlpiucVC?=
 =?us-ascii?Q?WzT6U+xErYEefBGhOEMANbM1HKLixBc/LvEREbzw568f207cUC9bGlQFs1pb?=
 =?us-ascii?Q?sV96PatJ0CUEzHDV6VsI4fCGiOUiwtgNukaNNPY2vzyCOtvnDInZy7yXytGU?=
 =?us-ascii?Q?Oxsd/Il++zw+3JBwZS20CCSlECWVVtkSozlgKjQb45CJQrVsaoVcxuQ6dgw9?=
 =?us-ascii?Q?jgRnsVjDNBH7j+YwDVQocVR5z7scuBYjz7uPkE8DMoEqIYnrIwDGrLr9SRUn?=
 =?us-ascii?Q?ABkdjpchVyan+kBmRw9iyTpwP2Ixn7ax81dwn7Kx01rmRRMlB0ykxzR8R37U?=
 =?us-ascii?Q?wVNU2/U7BnJFM1NuD8x3na4F1yoWN3gliUcDHy/hjYa5ODjL0GEfaXfEwaXn?=
 =?us-ascii?Q?ibdjeyMycSW3Nq4kJi7pbh/BABUeE4Yf7IcM4A68ClHkGblwAn1yPr5vl3Rd?=
 =?us-ascii?Q?v9oMV8mWN0TN9Kvue3zjhpR+ESgKgq9VqQEbCxdMMe7mCbb6n7zZmpZav+2C?=
 =?us-ascii?Q?C2JM9EsPTmEHk0Ax6WvhdqO/R0f1vk8WUak1e5oNOa7FpTRi9H6E7JsDZPru?=
 =?us-ascii?Q?fcQhEO92NQ/2ON5fSGMy/xGuRiA7MCFixGAJju+Pxy6Web9ax99za/1Y9ruv?=
 =?us-ascii?Q?8SogqKNmcp+0ZiNKleQGIVEgjs9RFkGYDIs1zS6kWaqSDFhcdRw1ak+4yQz2?=
 =?us-ascii?Q?/AXpqA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	q1LOGNbfu+Mi2pGktsOA4bt5fqPRMFwgWQDpEh7Ur8CYVmRIZ+f1JD6v2Cb1ORCCOkE9FYxP0DW2pwdK6Zkf+t6ivSxpQKX1PEsEPmwstQmqibnBCCDSiYt1wScOxnpYQcHlRSvHiDnEbbSja3ExQqQvwSskyNloUUd1eZYd+Xfgj+t8CGJm9mdqbm0xiEUnQXIGSL15viAWmt0+CqFTXV5uLXJsLLyaM+LWIVbfroIIKeBipSbQ1ap5ILoM8m41gFKwGbLluJ10Gd+OOUmHPymJPnDaDYNtwhQaZ8Ry3XVlV4FcSO9eJoFDtdsSg6QuwEoA9pUGXPbSHYi4qiKa3x2HFqLt+yA9s8vTEMJ1O5ZN2k0pRBTJJHF7hGQN/k559E2gPQ3ng120JKGuYQ8L4qYrQpnjHWM+srQ+OWCzFCRwaOX0OFCYhDtXiVJPAfmWmOrHB/wGNncYHebmZMAPkZsUk6HQE2+0THeMfH3Ck+cEaNeSwPTzLk+gg5+GOH+I6bdL23ZwyfQ+is4DadRMb9d2dZ/vTznA+VCzzV+2un8wJT/vaGwhQOWDb86J5aKCY17Z3QHqzVR9gt47PHhCuxj4/E3kYA4yB5PLFucn6oA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c58a381e-d100-4894-ee57-08dc4df2acb5
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 00:13:05.6126
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JneTGRq4bh6gRvZeZu7aV75k9UCm+eXfC33GMBPMtClEn+ay0gwGAsTgOnsFPKmPtmAwpLQVZjsM5nOAC8rZseDPAf3zmisdlawMLzs0aoo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4897
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-26_10,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 mlxscore=0 phishscore=0 malwarescore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403270000
X-Proofpoint-GUID: DGptdXMuSUhOSdN8jL7SpgQ27dk9J3Y8
X-Proofpoint-ORIG-GUID: DGptdXMuSUhOSdN8jL7SpgQ27dk9J3Y8

From: "Darrick J. Wong" <djwong@kernel.org>

commit 3f113c2739b1b068854c7ffed635c2bd790d1492 upstream.

When scrub is trying to iget an inode, ensure that it won't end up
deadlocked on a cycle in the inode btree by using an empty transaction
to store all the buffers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/common.c |  6 ++++--
 fs/xfs/scrub/common.h | 25 +++++++++++++++++++++++++
 fs/xfs/scrub/inode.c  |  4 ++--
 3 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index de24532fe083..23944fcc1a6c 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -733,6 +733,8 @@ xchk_iget(
 	xfs_ino_t		inum,
 	struct xfs_inode	**ipp)
 {
+	ASSERT(sc->tp != NULL);
+
 	return xfs_iget(sc->mp, sc->tp, inum, XFS_IGET_UNTRUSTED, 0, ipp);
 }
 
@@ -882,8 +884,8 @@ xchk_iget_for_scrubbing(
 	if (!xfs_verify_ino(sc->mp, sc->sm->sm_ino))
 		return -ENOENT;
 
-	/* Try a regular untrusted iget. */
-	error = xchk_iget(sc, sc->sm->sm_ino, &ip);
+	/* Try a safe untrusted iget. */
+	error = xchk_iget_safe(sc, sc->sm->sm_ino, &ip);
 	if (!error)
 		return xchk_install_handle_inode(sc, ip);
 	if (error == -ENOENT)
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index cabdc0e16838..c83cf9e5b55f 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -151,12 +151,37 @@ void xchk_iunlock(struct xfs_scrub *sc, unsigned int ilock_flags);
 
 void xchk_buffer_recheck(struct xfs_scrub *sc, struct xfs_buf *bp);
 
+/*
+ * Grab the inode at @inum.  The caller must have created a scrub transaction
+ * so that we can confirm the inumber by walking the inobt and not deadlock on
+ * a loop in the inobt.
+ */
 int xchk_iget(struct xfs_scrub *sc, xfs_ino_t inum, struct xfs_inode **ipp);
 int xchk_iget_agi(struct xfs_scrub *sc, xfs_ino_t inum,
 		struct xfs_buf **agi_bpp, struct xfs_inode **ipp);
 void xchk_irele(struct xfs_scrub *sc, struct xfs_inode *ip);
 int xchk_install_handle_inode(struct xfs_scrub *sc, struct xfs_inode *ip);
 
+/*
+ * Safe version of (untrusted) xchk_iget that uses an empty transaction to
+ * avoid deadlocking on loops in the inobt.  This should only be used in a
+ * scrub or repair setup routine, and only prior to grabbing a transaction.
+ */
+static inline int
+xchk_iget_safe(struct xfs_scrub *sc, xfs_ino_t inum, struct xfs_inode **ipp)
+{
+	int	error;
+
+	ASSERT(sc->tp == NULL);
+
+	error = xchk_trans_alloc(sc, 0);
+	if (error)
+		return error;
+	error = xchk_iget(sc, inum, ipp);
+	xchk_trans_cancel(sc);
+	return error;
+}
+
 /*
  * Don't bother cross-referencing if we already found corruption or cross
  * referencing discrepancies.
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 59d7912fb75f..74b1ebb40a4c 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -94,8 +94,8 @@ xchk_setup_inode(
 	if (!xfs_verify_ino(sc->mp, sc->sm->sm_ino))
 		return -ENOENT;
 
-	/* Try a regular untrusted iget. */
-	error = xchk_iget(sc, sc->sm->sm_ino, &ip);
+	/* Try a safe untrusted iget. */
+	error = xchk_iget_safe(sc, sc->sm->sm_ino, &ip);
 	if (!error)
 		return xchk_install_handle_iscrub(sc, ip);
 	if (error == -ENOENT)
-- 
2.39.3

