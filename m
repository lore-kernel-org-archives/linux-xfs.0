Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78EEE4BAB5
	for <linux-xfs@vger.kernel.org>; Mon,  5 Feb 2024 22:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707171629; cv=fail; b=lzydvXguUeC0M8PnafGUmDYMTJ5abTDBsfBvYzkknp5S9/lz/bTa2iMeRhT9ArGxW98Py5mmfN9NctP6020Q6987tKbOXtKxCEU9fA/rU0yqN6kkBqTSmfWzzLevUHzufjWIgnmoOpetwhPKiHp3A5EAleTF8eiV4a+aWwBxUaE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707171629; c=relaxed/simple;
	bh=i+1JGwJaKHqdSpsJNQ6q5hCvxCJ7PtgDkodPTImMvSw=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=P1Fc+t5SVpuhE1hFjayHB8kJkkAxq5e7xgHGkbnNOZN7XSia1IJmY2tBGmvW+tIlIWTY6KJYh8EzrHUPPNgXrDLEiAyxDzMyKLNsupKgAbSAKCN8V2bk2l6KblPGG0vbsDWjsJ8PS7AFf8pXfcGHeT0tIi9beS+MKUVzwsKKZiY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=K5t1uYcc; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=VypijyJc; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="K5t1uYcc";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="VypijyJc"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 415LDxLe016031
	for <linux-xfs@vger.kernel.org>; Mon, 5 Feb 2024 22:20:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=f7Bu3MvX9LhBVIkRjUNtHCxnPNOa/OTWO7jZnSkwAuU=;
 b=K5t1uYccezr3koQTA3PmWBOXPpvHC51NFmFRlFDJ9BC94fBfKmQh543Bd1nmfae53z2Z
 r5ilPyc6xiNKTbSKIa7C/V8e/EAJR4f6OE11Dw/PvP64vLwxDbk48WjsPMlLT4HDo5BA
 x5BqeRlLl8XnFpkvN+EM30ODn5eWLolJbleGVUtGMmKXvrCtqrfme+z5E3lqNRN0jLmB
 Dll7FktR3au5Rn2LZxDm/MBrPTRqVc5yRjzHVRpapTaB16ED8VxKnG0TukNKo3WGTUu9
 x1Bd3PY5TOsatNvRj+eIgK9zMbHzLExfo9vjZfxPFnDA83EPiZmw5MYXp4pmnyhSot0m BQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w1c93wb3m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 05 Feb 2024 22:20:26 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 415LBaFR007074
	for <linux-xfs@vger.kernel.org>; Mon, 5 Feb 2024 22:20:25 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3w1bx6k59j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 05 Feb 2024 22:20:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IVvFBCWEGJPzla/Jyc+YvXq1g6P0SBjIytmon3DWGRzZ1FgTJjggWjjeSVg1WNfn1+Sp0Z8ImaJtmI0nRmcsLWYNEQUlr0wQGzZwvGxHFNw/+qgTuv+jcG2P+u3IG4/RdjdZCdtbPwFa4KEe4Nvwlr0N0/81Bb4Vtt7TPxmn1ZtTL47FEDzNQ7BpuQSkerxXyogTNchLG6r8ysftNsQWSzFmU6d2xKX1i5vulzhfk8ikSm2K5sBOnB4L8S1VD59UB0Es38UpFlPkLBVqz2t7Xk35oXjsswyQxg45oi/XD44QCTTzzKuycqu2kyv6r181+v0XamuFeuvmS9Wt2f6UXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f7Bu3MvX9LhBVIkRjUNtHCxnPNOa/OTWO7jZnSkwAuU=;
 b=oNlk7EzOohOHR8JXpaP6aDaTAMKJ9i2YAASRhvM0tkoR0en1IX1GlNForXvRattOoDZwL9Au3WLKbG2cTXM5TJpbnAXcPV62OKtXeJqmy8pKDkzoeXClzJjdf2xhQZtWl8qwRAymz7NpSbDnhEih4k6k6ig+H01PrNTh0RcpKLe5J3uPm1ah3COw0vbsUPnhgN5nAGBk9GWtDUkFQsmMIIVt7P73l3vtAXerbuispEuf8n059xoOhJ44jLbKhZk/zxt8CTV97aDkoBYdGVPnT1jc4f1T3xHpuD1Yn42AaokpIz5KNh/JBC8Yrdyopa3x/uLoEQjbcpph9KHRFfclRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f7Bu3MvX9LhBVIkRjUNtHCxnPNOa/OTWO7jZnSkwAuU=;
 b=VypijyJc5B5O6fQhQZgjpUCcHyPA+pdP4Lbhskh6+meriokI7/p3kUmWHWB14Mx1om50ttQYyHZHeK88MVmqLnYpiS8y5pzLTfj5Le0U7LCslkuk4++1a21ltcTPabCA5L9neZI1YBl8UmNTQRz7n7euH9v59ZpgugCjOfli+4Q=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH7PR10MB6402.namprd10.prod.outlook.com (2603:10b6:510:1ac::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.34; Mon, 5 Feb
 2024 22:20:18 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f%4]) with mapi id 15.20.7249.035; Mon, 5 Feb 2024
 22:20:17 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v2 01/21] MAINTAINERS: add Catherine as xfs maintainer for 6.6.y
Date: Mon,  5 Feb 2024 14:19:51 -0800
Message-Id: <20240205222011.95476-2-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240205222011.95476-1-catherine.hoang@oracle.com>
References: <20240205222011.95476-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0103.namprd05.prod.outlook.com
 (2603:10b6:a03:334::18) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|PH7PR10MB6402:EE_
X-MS-Office365-Filtering-Correlation-Id: f27eaea7-95fc-404c-07fe-08dc2698a1bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	8nmZn3srHWMy3szYjlDK1LI5izlLvV/dEjZ4cdLdzBItIoGOna6f83ftzah2isU0kVNWE6xFSRoIupmMHFW6Q0zcHa3PyRHNnw/Fx3C2RShzbpy/PBo4Jhzake48Vysb2CPFS0Q7dSHF85fnPsfos5GK7JeuNmM0z3i9AzvMxTlezBtNFOVQ02ar7h+rWcHtzQA0QISwxJFv2hJX8SaALjGWV5Yj7A/fJglXpKbpP4Btj0IIB6D08iwsZ0/39TzI/NeXumMkz0wS7aJSi3Kcv/1kqkV1hpqHNUWrsmHJhvmgYB7yp6QMEtQATC7Zxpxi2ntzzT1rcnHWWawX127Q/D09brqm+QK4WDTg4stiRlAB48ewFDAkHE/saWG0+UDgyOIYgc/6i0Spl3x7MzPMDaZoB5UMgdncRBrHW46WYTVEWgdSvPvoOICMR70mnHF2JxB7K+Ol+opcW3RoxGO5xmVHSMSWloPdadUvqs/v5LWVctdq1vHBJ+CZyQhjBZ/aIfY3bHHkwY9N3Hrzu6CtMM1bZLH9Jgri8TUNN1zoANf7VFzEX7g4mhIpflGVey0K
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(136003)(39860400002)(396003)(366004)(230922051799003)(1800799012)(64100799003)(186009)(451199024)(41300700001)(6666004)(316002)(36756003)(8676002)(8936002)(6486002)(66476007)(66946007)(6916009)(66556008)(44832011)(5660300002)(2906002)(38100700002)(6512007)(86362001)(2616005)(4744005)(478600001)(6506007)(83380400001)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?Dkgh1229RvWg7UhWyY4j/YZ2bT47gEgC9egGoYAZQCh+EJDxxEPOE+JHzFLN?=
 =?us-ascii?Q?xmq1DkODWMdPWi3cS63/t3jMrRo7k4dpeNdJ0Ae9xp4Mr5FOt5JQ8BpjUmkt?=
 =?us-ascii?Q?Ri4Ta/sOpG/7bm3v9jXKee9sE0kHhJMMKNH1pzPgE4kZTxdevL60osG6wmaA?=
 =?us-ascii?Q?j/ioBL1WOfIc2FH73cciqvzo3YfPzvwdTbMGTByFUwJmaHNgUbgz3PqFVA1D?=
 =?us-ascii?Q?S4xgo2js0dJnfYDCn3t9115OD2z1by6zwFnCV75qsIHU7kGR6HL/zJiESANh?=
 =?us-ascii?Q?b9zSdkaRZG+54WofcIzZl3U60I+hamOr+O6cZk6jYLqrXmxY2WTLsbkvx+hP?=
 =?us-ascii?Q?6P5/RQCivxot/WD5ZugCf/fTfcmx+GcVMPUnIc0kQ1mT3L/YQ6yNfpHZckVD?=
 =?us-ascii?Q?zMXhxDkt2nS0y0+7kFEs+IxCtgWweIaxIJIWdiJS6nYCfZITzG34aStojKQK?=
 =?us-ascii?Q?GvIJaEmQsD2p+jWZIpKOrnL1FLw0DrnKImk4EX9KazDx0cV4VYcMHOSM9s/B?=
 =?us-ascii?Q?U7UrbjRk7SW1xk2GbA4Dm2M27M5qcIvfTMBzixPFnmzMvX42Pu0xp6IcA7XM?=
 =?us-ascii?Q?QngIQgE5YWcjFzq1ltxyxNjBVyerNBqARIhr8V81rwYs75CNlFpGRABSRf2S?=
 =?us-ascii?Q?QoA+DWdI82sT3BWzIURPfNXw3/tZUivd6qjRTQ/AEZFyeyn3D+rF45mv57q4?=
 =?us-ascii?Q?nfJ/4LNUqSzRfBG2QNK7iGeTPlTj7Gxu3+mVSLV2ilkzqRJGpCClNYtsob3E?=
 =?us-ascii?Q?YIeW7HqgPHpwQquNWH0FNnQ+5G5Q4Fp0ctSB7EFbKa4T+95PGxZ9mKoSVkHD?=
 =?us-ascii?Q?OuKDndmeNSEaN4df+7tPtkwyex8QKtDJEpaWXsHQIoEvxmzjxPupe8TNTvS6?=
 =?us-ascii?Q?gOCKbQ1pPnylVo2hsq8yaMvK9KSguweKmJV00jeGtQxu6hVHOgduupThXd6A?=
 =?us-ascii?Q?qb0aNNC10XZ3iV1mjk7ZXb1aU6h+mQf3WgFyNMUm08O3JAPvIAViX0UkWXKM?=
 =?us-ascii?Q?HXy9UrmyRrAxbZpAAyVWZ97Rw3FbezdZyyUoJmVmb0aXdVyJVbObP7xwMPPw?=
 =?us-ascii?Q?OwMOLP9SyFBp57JKtTi7RXOPTyOHklqWGFACPmxPYvPQJlmqo04F9RgKvw4y?=
 =?us-ascii?Q?vXhA6xpUS8Hqg9KKt0FdqIWmkq8uQNJ9p93xDBXFjF7yd/s2deo24vFebBxY?=
 =?us-ascii?Q?xtWCqlfBLsQVfoNw/DbPrzLhXQDO/nnqSDs9VjP0X1olYxlYSBvroEiqM3Q/?=
 =?us-ascii?Q?/X+djvSzfT58327HvDZnw2j8c3pzfeLTTi5rg4DiF0+CF/jgMtcr6Qkbf8VX?=
 =?us-ascii?Q?6LmREMGo6IBZa4zgDctyNDydjgZ2CpViVPp0OPPFpox8hwicoBMvoFQJTgRs?=
 =?us-ascii?Q?eKRUoWrzaERwQZSSZyjCRe5a208VHfYGW1LeXxtUCx6Yz9nqmAPE9oeY1YUj?=
 =?us-ascii?Q?hoxWa2ClCL37GmIbKm8LeJr5m0HqJj9L2amMbtsTWmx/Dj1B/cE2iGHSGZiB?=
 =?us-ascii?Q?suKTy30VHAVdMQkzzWeqctPjzT80S59ojqkBX5/rNT6fSXM0Y2MLE4XF2ZNR?=
 =?us-ascii?Q?KQAOtRhQCj8SGImHsQ/sDSB5y8g5n4H6mtmL4233tc5rxNz714UDzT75m+7C?=
 =?us-ascii?Q?a7DdoYIZcDzoPQWizfztCIaDGPh2Cr3B1kFO0F2nIeZXssmwOey2GlD1aXKG?=
 =?us-ascii?Q?sgSf5g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	+9el9dJ8S+wTlK7W6uSQsTYPQe/c2GO/+cJOY74sdxyk0h7fOMM7GcBqrVTChd0eZIgndg9/I1aM0TodT+tvDpCx79HmnaeVzyLt8ADtocE4A23HsgQQMQry/lY4qc8RvOeY/roJnxfxs2htBXb/JE3CUVMF1KHGhXNiAgkVr2YSDiDxyGR7yAlHeiukKRrKpMQus5FzXaKmfdKRyRlJdYMMNuUXEafmh8iTLtk11KBiiPZxzY2O0BLHh2b6c5KC976ds+v9hM1MrAJZ2vOrsCFM8us47wtTszB/zpt1zBNZbTmlbYhW5agnRK7CQ1gLiJqPCfDd7GaM3Hs+CP1aRkGQtoZWj7H7Rw1+Nq4Ju5ST5SV6PQ0CPtCsuHxUaedk8H4RpjPTp+M0nepQKVSEepJD4rGdvVBgdpgvF7jpWXdo/bqpk0aMWXK9Y0Dh+tD+dLhGOi5Fv6zhCLVBKNISeRBoSIF9MPS++8g52nzJKxsg3mtQ6MS7UZ8cyADpiWBBhM85sXwF6qiJuODTQrUqvqwpL+YYO2M2j6/83Asb0LQofNYhdF9pfM1I5VTXRcAcWEN3J17Toa4b2It4T3RKvfG7/uPNFK1A2SfOAHXZB7E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f27eaea7-95fc-404c-07fe-08dc2698a1bc
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2024 22:20:17.2503
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 39HblOGXchx3xLtmII2BFwQmmAcwCAcDfA7zbqB4X4qOVshpROW1lDG2yBhD+mfcb9UeD/wgUpqVjFN8qH2UZd2dzgUXggFGSGwxg0wZxmE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6402
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-05_16,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402050168
X-Proofpoint-ORIG-GUID: DehMsdfpgZmFGRseNtsUbge140rFFQ2L
X-Proofpoint-GUID: DehMsdfpgZmFGRseNtsUbge140rFFQ2L

This is an attempt to direct the bots and humans that are testing
LTS 6.6.y towards the maintainer of xfs in the 6.6.y tree.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index dd5de540ec0b..40312bb550f0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -23630,6 +23630,7 @@ F:	include/xen/arm/swiotlb-xen.h
 F:	include/xen/swiotlb-xen.h
 
 XFS FILESYSTEM
+M:	Catherine Hoang <catherine.hoang@oracle.com>
 M:	Chandan Babu R <chandan.babu@oracle.com>
 R:	Darrick J. Wong <djwong@kernel.org>
 L:	linux-xfs@vger.kernel.org
-- 
2.39.3

