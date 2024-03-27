Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5D3F9C8;
	Wed, 27 Mar 2024 00:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711498389; cv=fail; b=E58RNZFgu/Aeh4aZ86jmeD3H0d6d79FIYDwDg8vd1GZG+bs4mEq6VbfvjPXLjPHGB9E/WoHRiB0SJ6ytkAGxKP2qUM5NWQ7l55EkZ88OJdhd+sc5A7WTKR7TdvYf0oIAGiTE8kAhbrPSlnRfany0QHOd7gxo9BrU5MX0TCzdlUU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711498389; c=relaxed/simple;
	bh=eW/fM1BRxUoFWolCdq5Uoc+/hvCLzUk8J3qghlIXm9U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=auXmCUucU6VKKUco+Pdc+BKIG1UuWHcNRE0+tUBg33SAP1KyybNvGw8jS/X8Z/91/00dgfGZLJUVNY2T5IkMKbJFVRgQWsHQoU/6xX9oSoa+QVgT7UKY9UY9XJ/328EtHRjSq+nlFytTTVD4JFrvzzsnPzjRSMWIdpgwJkCX+X0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=iH241eCA; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=FuVOnqo5; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iH241eCA";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FuVOnqo5"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42QLiWlp026019;
	Wed, 27 Mar 2024 00:13:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=NUTQZolmMoIMDz0pvbI5oaGu1Wew48Jfs/dazUAGPQY=;
 b=iH241eCAabMRNAMApStGRDnqJV66WczFEG/CIQNEfmLvTCxoVg/wCzzvkHsDU40z+lFz
 QSbhUlLYzpLyJrFndAzFRugf9CYp3Gyb7BVNaXvLQDkys3U56pfd839LXMYp60tklLZm
 MwktKp4EHzBwZpL0/myoKgTsyJX7iVlHmefmo6JHbXr76CHBZX0/Fz3+UbE2C6C32xcV
 ZYj8kyCt3iQYxmPVLCm8mPHEiy6dE2NU9IVNpoJL3hmqCqLHmiJakKlOl6/vWC/T5+r0
 3FO8sJjB0DMWbFD8WPmptACDAB6BcY9mcI1JLI3kIgpJ7NnQJhWVjT0CDls/hCJFgkjR wQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x2s9gvscw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 00:13:06 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42R00UOX012409;
	Wed, 27 Mar 2024 00:13:05 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2041.outbound.protection.outlook.com [104.47.51.41])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nhe1rd3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 00:13:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ipieLre1V3D9YZ+1MInlcHDJh0z3saUfgGtcoYc0dXrdyb2LjGxlsgGw+c/2j2RE2EbTcEG1+dY/7Pvw492C/NX9RhqRzuAcUSM9qyWazlm7hIkZAoWIlZfIw4DjEXxVrfvX0Fg6SSpsQjx46SpJAJhytdEeZopKY5diH04ECoxEHUj95/xH7K8hE0dLuibf/7z9QRyOUvEG6arvOvNWOZncAyIpxaadd3yNeHo7wMLzX9qy3PgpGAjnxTRyvpQQrXNUAaQbf/q/9/luQhWtSzIe1DR13S319oULnA3ha6g9PZxbiC1n85KB8nxxXKnNDfc5cI/NkTc/Hmsu5gJIJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NUTQZolmMoIMDz0pvbI5oaGu1Wew48Jfs/dazUAGPQY=;
 b=A+dMDgqx3x+R8UmTUUxhdVAxFS7xO3Lrrw8AwmtLoEU9esW2z5wmPNmBxAp/sHSytYOTUbMJY5/hAO+Z4S3QzSCBLs6qWpksrqxwPhWiTgN2cAIyJ45dBkMKxceiis8858cODD78Zf6eivlTWTn4UBxcP6RsIZdM8SEyeXZCpgtNvZV+rXhuX51t9POO1hvUrRDAJUvzqaoa0DMel//T7Fx+vEHN6qc3i1dakSH2yPGsVx0kZRmuYFmNIxTWpULsR7cWxFWhAlT1trP7gbiqW6zRQlUVfyiMoctQjjWAszErd/qjlg4BYqwlTCeJdS4bjXTtqo0FhlIDeSxECkyj1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NUTQZolmMoIMDz0pvbI5oaGu1Wew48Jfs/dazUAGPQY=;
 b=FuVOnqo5KbElFo1mEt+LrgxugsXzHqP4hUpBpH1rAQyeTGtNjzMtxlS+8B0QFS7Nu1fLJ8jyo8nmi6+PpuXOSXnSEl1yTVRurcl5mp/AoayYePUmqU2MRVsOCBXRHJFsy4hayLLSZuizpcaAPha61y1nhs4V8/YH78YHUFLIQJI=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BLAPR10MB4897.namprd10.prod.outlook.com (2603:10b6:208:30f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Wed, 27 Mar
 2024 00:13:04 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a%4]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 00:13:04 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 10/24] xfs: don't allow overly small or large realtime volumes
Date: Tue, 26 Mar 2024 17:12:19 -0700
Message-Id: <20240327001233.51675-11-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240327001233.51675-1-catherine.hoang@oracle.com>
References: <20240327001233.51675-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR13CA0022.namprd13.prod.outlook.com
 (2603:10b6:a03:180::35) To BLAPR10MB5316.namprd10.prod.outlook.com
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
	QDhJcwusUPOhnIj8QuJaXSLWqYnpigIzfuT7sMPocuylmJJ22jFQxZ3CZJ/uR8dZllWByEB/lWxjjQ4ovWmbi0QZiSKzHSIM2vuv9cuKzwYGNC4GBhAj3+IC6YOUtOwyDkSdAsL2GtsOBZuMQJgURqDsy3YZ0tgmv2Fz8JK8frRzO95iLfrin5xRvLgeLpCySufdxXsXA1bOFhTtyKjVyTyR733uCDFBJOlp3NZCf3kSLj9gTt2y8kVCMRCh4avG3DqpDHAtIs8U8tGuhULghD7i7o64CAHoH2J3IyeJy+6EwBzDv7jVbG73+AATDtILAcXrMg3ZRzmmNxmKO1jmjnDlWLhhHLRHwiQGHwik0MHZxrKcRdF+7p6ujv2gzoOmVvbW/TOTHLlmX2hZi8zadZ7IGuETP/1o0SviwWo2PlBK310XrVu6dqGusRiZSdJA/IeFEdvQEAA9Ie0VCViIdmB096KKskGlvxC+eM35+8jFVL6wvCk1JG5kaIldYI4EW6HP0N4w0PNyVrkPHpcG3RG96dfIQ3cxe3pyX7Ckvz7hSa8EbIEJtnd/qAiuxzSS6pPBLolbPDNN6HgxLXDqL1KC6oMs39SAOfBfijVnpp7q2J7jy2TkA7g8MNNmB3MJ2jtDxEQDOOSkeB6qbc67aYwV7jVWajrcJCzZhAYwsqE=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?zpcXQIIN0ZVEycvmQMBdWGAxrnaALfrhh4n9b6j7GD/bC29VBRLAZB5IC6kj?=
 =?us-ascii?Q?nvkUmzrOfL84IDGhszVytFOKAKzXTIaV3Dks8ArSz3kowLXfAnz3ZdgZffDf?=
 =?us-ascii?Q?UkwNw7MklI4XjCecYcaB3ZNguCTZSaDldljOkZ+zuDoQduBQFzX2SI2uDAKZ?=
 =?us-ascii?Q?lSbSR5qDh3683hOW4GnGXIUR0Sbr9bJLL7GE+c4JvSBfdc+kGPgPBOiCQpyE?=
 =?us-ascii?Q?vD5FdlUPlk1ujPzfTyBjSSWAteCV6heDDFaf5y44uPdV71GDpstK0fUkH3ug?=
 =?us-ascii?Q?ZwoJVniNle9eWZgue+sIXNyu3mmDy1qGZub4XJgTWnCQnB+A/ECrvLcfWVXs?=
 =?us-ascii?Q?B59VkzucCAkPP0jp0veljzFRMalzXJWIXgbaLghHHPRtU8nNXg9FaW0yCt9e?=
 =?us-ascii?Q?4/+FYh01GdEFbc1vBTkr4+o6FpdeKA2z5kDkCOYvcIIpMfYz9yzgFVnUKmRS?=
 =?us-ascii?Q?VKihAzfamARnBW6oGmkKEaDKMQOWGG7Yupl5thlhIK0sfMeHNCZImVapPHiZ?=
 =?us-ascii?Q?mDAlZnrl6Y//0ajjCs1ixC9hS/vpJPYGJpD2n/+EA2NTvyCDmuCI+V2aS8D9?=
 =?us-ascii?Q?SPyzoD8RHFkA8tKvQqDM+LO9yGPnp3+/ozvmrAs8QYMO1ndUFNqdiXZ9Wj42?=
 =?us-ascii?Q?Qc2cAo8eHq0yz/d/CCVxGVF28NrlN/fQZHVdDr99cRj/tbKEo5lQH9CZpnkz?=
 =?us-ascii?Q?zxCVeDMAtfX5oRLSqWioV0INjoveLtLFWoufOe4IGYo9uh0iggYnuSWtC+T8?=
 =?us-ascii?Q?rRL8/Ne7fHUaZcCx/ei4PYf3fuKyKxDeBfpIUrAxrqscirM+RwImqAAm+vau?=
 =?us-ascii?Q?lMsjaweqmWNmlFgMrNz9trrc5ktFPZ+1dPzfta8jBeNhANLi9MHOyRGxtT4D?=
 =?us-ascii?Q?3Yl7cgtS3qu7ZfYqbw6jjT36ix8N8I/ePz7hEqOSzIPymMfnfSCzErB2Mmkx?=
 =?us-ascii?Q?8XH06BdwwSLDvQS1DRwnGrLQRNEQkWWjKtB7nXl/S1kwfu5G7MsHX4k6/2A5?=
 =?us-ascii?Q?rYoBkFkbc/8ArdGERnazTQE3p+v3Pnk3I6WoHAB/V3TyCldQPDwkcpXb20Wq?=
 =?us-ascii?Q?YbeaQEALqHwNQDxoFy8IFMhQ1vuUk2e2wT6b/7shnMytcJjZ1hWG4tR6QMEk?=
 =?us-ascii?Q?8RlYA9y1slTCyOmZWcTBPTNuCusKUEHKjTVqrjLfksewJDo7+BCvTgZ9aJ1u?=
 =?us-ascii?Q?dezSvuJR9wQGEjnj5gIm8ikAw9tXsVwTBSo1Xwaeo9MJbmklB0QJT22jKW52?=
 =?us-ascii?Q?3fofPYmBESX6NjfiBRDOMmmx2C6RtPVgKlSuHGHev4o0QS86hmyvM1Ga/s8Q?=
 =?us-ascii?Q?pDKSuCaLpsjDPy65vK0qeOZ3nucplBkeDydKML72azmxTjDSvsbbVP1t9g13?=
 =?us-ascii?Q?i7L2afiXT3Vgucey9NFKGmKeQ6YJTlqu4xW83NGjKUguxikd4KfduuHQ+S1s?=
 =?us-ascii?Q?f94N4nZ6ZorR4YBrQsgQjhXNxZrZcrL0GTmbz/RnIv+ntzL43sV6ZaB4bvWG?=
 =?us-ascii?Q?fckk+3EHb4KtZ5O1Zr40BEYtwwl+AIRINCX6kBbsZlQPZ2KEi1J12hNiPmFw?=
 =?us-ascii?Q?iGl/O2z5GDv3Nm36KWzYH8DhCoo82LMdLlZIgxd3gegLihTxYIiVrB5EHbFN?=
 =?us-ascii?Q?B6L5pNpXsZP/keEFuwuAx4kfu0vPGGH0KJw3RQQxDeo3qCXoXy3zRQAxyN+N?=
 =?us-ascii?Q?kSXDKw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	Voff00Vi5z1zMkstdihGZ4p50aWuEmjdjEGlh0PIDH1PyHypYOaKyeT5S8eRDvScgHFXSGqsV1HHPLMXlfiaaK7TYi+4MVdr02nqyzGt3XB49YeG692Vd2Vsav6SsyMHx+zdHk4sJoy+ZtWSyl3I3LySGyVn+g+M9qaT7zPt6+3QjEen0UWcbDG/plPosSXHvGpUAI7cuL8i2u0Y1hf2xhgdlfd+bK1Vbrcc/ghHgBjXUEnqss1WRCZn/HlDZkI5OxbVG2BOO5af2KX6f89ful9qqlzenNiWLivPVuEdZ18fCDawqHLeDg/c4EX0mPfxMNf0CCikSWl4TT6I3DlcEq5P2YUADVKWV2FJ2CEbDpiCXLbRNGufMbULQLfkzt/RqCUoX8+iJLWSrMq8R/239kBOT8zuvVyrxIMLQA/MhwhySakvQ7kjqO2AgK9XBFmC1Bh+buiJkBS7pT4yY56wBMp0omkpO+gYkm7A8SwN0jDQsDURHHBntLwRefmkPCcA98EfjhrYeJufc//I6OxpwfvXmEdZ5NYihR8CIK1kiqFzsI0gGuqs8qZen5PJwQz5LSuZs5cMreRvYlRxJ59zGgkLUOxd2z5r1y+ZuIobo6M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aad81866-e988-4b83-6e54-08dc4df2ab9c
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 00:13:04.0419
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lVOBfeAp3CvJGOSqm1u0Q52RMh4U8oVChzGOtl2wIG6L7GuhkUZDNuu1ziI6Jo2mdqqZaiHtaNeVec6h4GtHWw/TiacHS1pMgtfVXEV7qTU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4897
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-26_10,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 mlxscore=0 phishscore=0 malwarescore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403270000
X-Proofpoint-GUID: CyveLpdauz8MDeGOfe2dx8cG0LcECPBC
X-Proofpoint-ORIG-GUID: CyveLpdauz8MDeGOfe2dx8cG0LcECPBC

From: "Darrick J. Wong" <djwong@kernel.org>

commit e14293803f4e84eb23a417b462b56251033b5a66 upstream.

[backport: resolve merge conflicts due to refactoring rtbitmap/summary
macros and accessors]

Don't allow realtime volumes that are less than one rt extent long.
This has been broken across 4 LTS kernels with nobody noticing, so let's
just disable it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtbitmap.h | 13 +++++++++++++
 fs/xfs/libxfs/xfs_sb.c       |  3 ++-
 fs/xfs/xfs_rtalloc.c         |  2 ++
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index 6becdc7a48ed..4e49aadf0955 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -73,6 +73,18 @@ int xfs_rtfree_blocks(struct xfs_trans *tp, xfs_fsblock_t rtbno,
 
 uint8_t xfs_compute_rextslog(xfs_rtbxlen_t rtextents);
 
+/* Do we support an rt volume having this number of rtextents? */
+static inline bool
+xfs_validate_rtextents(
+	xfs_rtbxlen_t		rtextents)
+{
+	/* No runt rt volumes */
+	if (rtextents == 0)
+		return false;
+
+	return true;
+}
+
 #else /* CONFIG_XFS_RT */
 # define xfs_rtfree_extent(t,b,l)			(-ENOSYS)
 # define xfs_rtfree_blocks(t,rb,rl)			(-ENOSYS)
@@ -81,6 +93,7 @@ uint8_t xfs_compute_rextslog(xfs_rtbxlen_t rtextents);
 # define xfs_rtbuf_get(m,t,b,i,p)			(-ENOSYS)
 # define xfs_rtalloc_extent_is_free(m,t,s,l,i)		(-ENOSYS)
 # define xfs_compute_rextslog(rtx)			(0)
+# define xfs_validate_rtextents(rtx)			(false)
 #endif /* CONFIG_XFS_RT */
 
 #endif /* __XFS_RTBITMAP_H__ */
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 25eec54f9bb2..acba0694abf4 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -509,7 +509,8 @@ xfs_validate_sb_common(
 		rbmblocks = howmany_64(sbp->sb_rextents,
 				       NBBY * sbp->sb_blocksize);
 
-		if (sbp->sb_rextents != rexts ||
+		if (!xfs_validate_rtextents(rexts) ||
+		    sbp->sb_rextents != rexts ||
 		    sbp->sb_rextslog != xfs_compute_rextslog(rexts) ||
 		    sbp->sb_rbmblocks != rbmblocks) {
 			xfs_notice(mp,
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 5fbe5e33c425..e5d6031d47bb 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -998,6 +998,8 @@ xfs_growfs_rt(
 	 */
 	nrextents = nrblocks;
 	do_div(nrextents, in->extsize);
+	if (!xfs_validate_rtextents(nrextents))
+		return -EINVAL;
 	nrbmblocks = howmany_64(nrextents, NBBY * sbp->sb_blocksize);
 	nrextslog = xfs_compute_rextslog(nrextents);
 	nrsumlevels = nrextslog + 1;
-- 
2.39.3

