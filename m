Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E9F7173A
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711404479; cv=fail; b=arKCA1Qhbi7CAIefvvMsO2PbFscWaFNli3AZ0IVHur8oktwp95Od02YoJtcoplxvDxMCKiu+5yYxzeWVG+wn9QYWMdpEtO9c4UFMIAME5zjpeoSC+yDARTdwPSMEiAVEkFBu+7hVUMYZ1PNKmDgXc5djPZvEdpy1pmS8ZdKVKl4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711404479; c=relaxed/simple;
	bh=GvjbvZfi6qFOYlt16BG9AW0gCpK/2+12aXAwe5R0DlM=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BkaKz69e2wS9bqhC7uJkL26252wpECkZ1U/4YG02PU7W8BFuOOZftTa8//5Ol6Ff+PNuvuNseb5jLY2i/Dmo03PcFruUv+jyRyGP7BWGQFqmuK+meonAksDKETHUz0+l/Z6jGwsVQq3jiPWvpCf3jR17urAEzeDlngeGKG+rkBY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ARNQu/sW; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=lXtisDH5; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ARNQu/sW";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="lXtisDH5"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42PLFshB027120
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:07:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=kti3WkbrH1jNkALXvyRGKYjKNRrEMaVRnA96YSVvpmE=;
 b=ARNQu/sW1rxLdNi2+9XOO11ro7ZazBGVhm5uxjPpRtBd78vfufYei/IyKMEXeK7UB8if
 Z11FM9efuQIcZjzB79zynBHaMvqX2BjB5A8LPMHQXuiHWD/dSIjqlnmnKYeuBNfr0eCy
 LKXS4Ch3/b7rUPCG6z90JRLzGA0oVZY9hanlzx52FXnHcjcMb0bNTvgDQWpJbv4diWgt
 tWA86sF9DGzqotHIz084yxe3tHaALKmmOS+HrmPvJ71npaVVBUXvQjIjSpMpYAXk4N2c
 qZ/B4L/o3g+65ayPM2Tv+XcUbpfxCtnzzpxWCFOt/JOGSeRBNM2C4Ml9uzd/Wg2X4GwL 0A== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x1pybkqj6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:07:56 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42PK8sKn020253
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:07:56 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nh64b3e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:07:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U1YoTe8OPWz0LLsxzzAuS3MFFgc1p6sy6Pi3V0Q9XRye72bRJzXwB6yqi7HxcSLXUtRhdje6/CryLEnGUDmeMjrAS+wOKLTWk+Z5sfz920adtRVN51qyfQ8PLEy/BNyFjlZoxpGMSxoP0o1jElMaBmaIflj6FYOgayXepAZpM0L4eCaQO6waRDlMUOXPe40NdlVP+4vzrH0CiGsgv3aCCW/gpxUoMTOEWQul124+vPt6gMiM/rA/pqbbuOu1axnTMNA/pP4zAGaA8y9DItbIFnIH9tNN3QEm7s9XK0t18CKKRoj+KsNL7Wf5ddYMH8IkCvpU+m7O1ypN5bZ+7S/FFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kti3WkbrH1jNkALXvyRGKYjKNRrEMaVRnA96YSVvpmE=;
 b=X/OBTJK4dqR750IGkyufEXUpSTzC1nKOuzsTuqcvIJQO+RgdZViLBUkvEQn3bhSzNggT8kXd9QqJOyyGDs4OL4PTGC5G+MgqvqAgIXe9ileVjg3HhnZ4g5RJB8f8JcOWtA/Lcz1g4B1O74N29jjtLzjeM2URaGi6KM2EkjCPLLXFus1MlC59bzsDKUOvPXLKhx32K25jB+VAmZisLxxEvVxVHrqJMjW9ZpVVoM11DmNm2AIRRNvRNGnKTRqgVkvc+5VSz75pjuj1NL36AZE0zw19n6XCPcPVxGvZ3ZWl+MsEqfDuTcvdQEzdZ25YBd4fDJQc1mPUlK1hUKKxvf0XJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kti3WkbrH1jNkALXvyRGKYjKNRrEMaVRnA96YSVvpmE=;
 b=lXtisDH5Uwm9FzmlvR/B+jF77NTQ48P8PH+sy/H3WJu8AxyEYFOP3Nl+Gf+qNHnmC7VwVfgTFPHb+enkVyeLmwZF1QTBgGy2loe9Aod1Mz46bEsQdaZUYP0BHfPBKabGiUSUmFBo0396O+AHzwgsZAf5GJYuzRGlfqPEPX/KsHs=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DS7PR10MB5005.namprd10.prod.outlook.com (2603:10b6:5:3ac::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Mon, 25 Mar
 2024 22:07:54 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a%4]) with mapi id 15.20.7409.031; Mon, 25 Mar 2024
 22:07:54 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 10/24] xfs: don't allow overly small or large realtime volumes
Date: Mon, 25 Mar 2024 15:07:10 -0700
Message-Id: <20240325220724.42216-11-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240325220724.42216-1-catherine.hoang@oracle.com>
References: <20240325220724.42216-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0149.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::34) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|DS7PR10MB5005:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	XOtIR8MhFM/NySwPTUcYRQgRgsmEhoKAwTwjL0C81mZCwPYZTHyJV5bBRg1e7uXMe6vRklrviv1ZfeUew67kqvBiCy/jKf9z22LOz9Cu3E+2HL3aXdluKynNeXfMgRw8ddNajbXTnOSdrAvaDa8Kg7fDs12ubLaHOarjD/bkajBv5AdC12cgDbScqdPl0z2mMyv3I07qOHpCQ7Q4HcD+smqSuzphpGw9gm17moUEhedj5PGc1rhDm1TqDYN/ag90zwc78+c94c+fWio5phcRNURC+IKBNYtP6JjE557l1BO432Z3qTbfdugLqtiAKNwkYFLxOAI54G9k6USOJusp9TuFoHaAXWg1Q6b+zivwrOKcmNEsf5uZ0OXaTuitL8WQkN6BqMyFHjEEYA5VJ3RnbfXYji7jITnIJO9fcTVTzl4ClcwkqMchRUZlfGNJ2RgZZrg+D8txRslLWS90pfqSQC2Nr+s/q/t3D6iFHnve5HGpmyWcbtOuV2NrzX7uWGJywT4KOTRqccFh4zdM0PLvAsUxEhqlMGkcnRwsLjbbfnmTnHvJ8WA68wDSzeDbvHPO6SVyEovoF1Ace44v2Lc5O7m5umm+UJleRLMb/5LcDR7PoDltPaN0y7wnb6w8kjX96ukGNPKRDUQFrPMZ/Q7e6dvGrjFZcgfQJ8RHdSgzW7o=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?IK4j+l8XWWD7+gTMZ34DYuSifedB0cEm8ef0n2HvnpjJSL8USCmuR4Y9e/t7?=
 =?us-ascii?Q?Ygq0dAutpebGiA91MCqAfJQHXOJ3+E9cVXXmLcwDK5cIYkKwCLO6boZxeAnj?=
 =?us-ascii?Q?B1QI9PSTgyWhGtxy9NEkwCQvfr2d/8SogwmxpKDc447vyNh3j2r9XtLR4zX6?=
 =?us-ascii?Q?/9+NX67YyRz2B3HpKQwqoBzO6S/eZMq1PYNXq0lQHOnUgrGeFDIWCFJB64Ht?=
 =?us-ascii?Q?ur6ziXdfOPptakEHQSNHP9oBiZgxaRfR2PUfCraarRRilMYBLr0VoxdyYJ5I?=
 =?us-ascii?Q?q/5zLJ+D/zPB+JSi1X3BBf/snmbdOjZzJa+L0pcHKXVPWg180OPOsqD7pPlw?=
 =?us-ascii?Q?az587GcDd1aBWZzAXlDhefkRnupWfJGIUPC2F3/KY2jZXMXxE5206oXPSSqY?=
 =?us-ascii?Q?pOBHJ7BVsSUCcVzBpRbqi8kmtVJOA8i3HalMyH+a5VL5/QNyR2cjkX9ahtXF?=
 =?us-ascii?Q?+bIISmCel3/Nryi+AZ7EGPvF5yuTvhx4LfWybWtx+WCe6K4feARE9X9lZYJ7?=
 =?us-ascii?Q?RJ/FXpYo6eVyWF3IYNmwua7N18HbC2oZUIMhmoNPxasA95zu/noDwjCmUA0A?=
 =?us-ascii?Q?TJ3EU3/2l+m4Kxe1QPX7Zwh7MWBwu6+pikjlijcqO/dFWmgTi+E/plbnMrE4?=
 =?us-ascii?Q?Ep6s9hGmMb5jPGNA+oj5ZVmixxXwJd0Of0YAqwp9oFg89PBHFLz4CsFQBMbK?=
 =?us-ascii?Q?2rUXNRuEOEBVkN2XJBzXtcftUazGsF/gM7oLyn+kfGm+FEuEWAQ9bXWY0jyt?=
 =?us-ascii?Q?Ld0RfaFIySeRyhpCOb+Txse2+rbUiQqkjYji//G/UNEzeinkzZqyMZnVKpIo?=
 =?us-ascii?Q?vVyPUH7mrWoXi51KRwEYPvSl7u3c7SSzdCOBwbKerae7TFbx1bD1xn9cyFba?=
 =?us-ascii?Q?atmPlzpThQha8rcwi6SD63lKKsHov2BoQl8nYmsGilk52Q6SqFdDcS/zm0dK?=
 =?us-ascii?Q?mWadfogGC0M5wFUJOo5aQTyjgqVtjOTKvyNXbAskVEh97Up+jyxyq0upI02Q?=
 =?us-ascii?Q?jp3E/L2fDdt6yfqt+ONz+XgaJPSv8bfBzJ/T/fzHIhzuTIKMTnmUiG1rAiHN?=
 =?us-ascii?Q?0sheoyT66gw6iROscYpLpQ1oFdCRcvSa8HbynvgwVKT67KayE/mE7wj34i47?=
 =?us-ascii?Q?OxQ9WbD2O7BoK40f7s7WQbzK3TP9RHxC5wUwn1ma3DB2SlSx+eD5HmS/b0ok?=
 =?us-ascii?Q?2s+zcbIzch4M7AzNdMqx7asXuOvjOfh9Mazj7jg9Nhc8lMp6BihgbkabqDaa?=
 =?us-ascii?Q?kRoJkkPfxQ3tpJrd1KWeFY9ud5gZjdFfWNkoxuDa2qgoEkFzygLUa4xV+u2z?=
 =?us-ascii?Q?PzRHVKf45TIYbDFwH3PGnU8CX1I4gQoJ/2t4/u7OH6SNT8bGN6j0pg9/jIKA?=
 =?us-ascii?Q?wBmvKhoFqKKgN01L1s6PlIpYTnqX3fiHhYkUjHMeK7pwEpJdPP7aOTmTCe5N?=
 =?us-ascii?Q?uYCLc36e6txKautnoAq7XzViuthOGLCG85gB9WC8sG1QHMEbh9DVWo1wTEli?=
 =?us-ascii?Q?Og5xDGZT82ORKcuJ49TOf5Z9z/4tlY/hcwfBkFCmZkHavX/2j4wub5W8Jgsm?=
 =?us-ascii?Q?aZI0dGhgQnq5559GF5I5kWXMZ1v15I1Yv3GQ3ymxEfMs0d+cDoGpgoQBWIvI?=
 =?us-ascii?Q?1QQe9dS/8IpXkok11YZ1gU1cuz2rMTH7HsGiS3q+ReD1YMErWg+enddyW0fq?=
 =?us-ascii?Q?DY3j5A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	lgrVpPNH0GVg0EbJBp9byUuHbf1t5beTWZ/RhPQGDQtUwiEd/2LOeEchHRcUEn9v182tLI9eMeyK0Hosa+DqzCu/xsSAHACxbefc5bLvYvTODt0QTtpHytTbh/bxbPVa8NiEwUEcI1MF/6ko9WP1uVZe42cMweV8BnNKCfQuTP/rIzXSZ4Wr6C3lfU746cEbHHpt/CTmuR/ewqnahaSvhLVs4/2T6WTHiX10FWY34dg8Hc9tgfzr2sbbLLrloMOVt26RiZHGOnoZc7PO75s9DwOsrccdWwD/I9uGAex/mlJOCP4XE40DZb1U9grB3wM1bHotvwwMSg9iv0jHjKHI4ndX0hd+cEUZ96aBtgidsldeOzU2sX0CrL0f/fkFEXa8kG/2gSWbJQlMpr2IS14h8nhsaMwLQB2ZHbUKeyOidCFyuKbbcl7CcCWLNwHOC/jy8Tdkjhx30w2lXY5ct/U4O7KnuIf+olFDVWGKnSb0E1QMU9DcQ721sm8KvZ/jTwqkj5oJRAUT3sn3hD/PMSLqFv7nlO5me6nbSasse2QdReaLfZoUQbROrq06cRDzyMtBwr6ye6l3o7iPRLnam5LGntDrJwxD+630bcZ4f1JKedw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e82aad7f-484e-4275-bd4e-08dc4d18054c
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2024 22:07:54.3986
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0BKmfPqJFMVfcllQHqU3pc9dKfZkiT6W4eKkz3F9Kb8qCVwDnIlpjE/Rn0SPi/xiQf9lBi9grFW0USCQoJgi6DY5q0fsE2zOtjRDsbYCWis=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5005
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-25_21,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 mlxscore=0 spamscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403250137
X-Proofpoint-GUID: dd46icfNXh3eMIsKG0M0mm6D6t70tWuc
X-Proofpoint-ORIG-GUID: dd46icfNXh3eMIsKG0M0mm6D6t70tWuc

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

