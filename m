Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4838773176
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711404508; cv=fail; b=QvoonFcoknSUL2Q+xQQ7KMxOGg4vUvhXaMgGhT3JMRZE1fmAtSz9fFS2d1ykNM5wujpMlpntt6V1El/tUPuMCJREcycLJfUtv4wLiAW9yfADGE5hJC4bjbrkwWTdlCGtlWm2x628EMF6rtNFOG+RFnK0WJo4obbFKJmNvU4A++I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711404508; c=relaxed/simple;
	bh=dBvFsPU9LZOa7JSMC8tXX2PgUZl/NYk3JBDOEIv4uzI=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=X/sqZ4Nc85+OzUPhCspVbFo40Sf3AzOCUNXW4pJ6o9Vmh8qnMH5Y5CsMzsuLXINZ0GzsX6I1Av4MRLR8N0cKPGUTljs9AboiI6o+lal1AJaHHeYJ9qLdnZJibC+NtJip5YAAJQXbYy54CikqH0C4Binuzd550jRt8ldtzgdPZ/w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NhR/ttUy; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=OGlkuHf8; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NhR/ttUy";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="OGlkuHf8"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42PLG1DG019826
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=yqIcAbglghBJ+pfX5YTKyp4+TeWsViNtfnORR6iyoTo=;
 b=NhR/ttUyIm+lc71AxOWtbGP9yUgWWkHVTEa7xmSKJ0dQfn1EZSOoD1g8yzOTBOS7hKWx
 18n/2RuQRbdRTVP6CvP8G0FvqOuvIYpaKVZzGGKjNwYujk+joQKxiFwj7MgbeZm3s+Q2
 Y/LO3Hz+wpNoLcLvZlfy/EnXCncfA4ooSqX1lzMASTVOAuHP0kfYBhaKTI2pdMSQ7Ood
 7F+B1wY5nTVrrecaCIJRlEV/uO0tYw+phfbsXFOnq1UmYvSYKgWiIOiKSjbl4lRMtaMZ
 92R/Jya86nTXNzRdhtUM3YAmuDRpnjkAfN/4+Nx4MCgRK1mnFrf356676x35Oi4YdcBY +w== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x28ct32gw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:25 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42PKPhAG015960
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:23 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nh64raq-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hQF9hyHU7ufCVYXr4e0fFCd+85AIbOkHMBuf6mjBI+/81CsZYC08jzaYiUxlbe6GRL0N6lBiBx3aMXjbcoRa5i4lRJCkJznlCmka7c6xePUgtsY9e57JysGZynAteGZ5MPP0zvC93EXnf619UF72MJESCBKUYrEKDT1l7DQJKH8su2Lh1gpjdwfppvCo9tUGGGEaoeKbuxP+lOkh/e7MhiZGnIYaDXSMYy/NyxgC/iJOay7efSCHeQODXso77FSGuptmPAh0cOc+YK0fW0p8fihsmiudPQZakkY/m3DTZFCnT1f3uTXpq9KUlSqm8w5My8HcnZ88gOaC2R0Js11iOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yqIcAbglghBJ+pfX5YTKyp4+TeWsViNtfnORR6iyoTo=;
 b=UXpaFsp0dCM/9FWclrD5ntB9F545ZG7kbSzKkbqoCUAoHFjbGfWpMu4yP4koL0ynmXNK5CJZkv8378pyGSVoiLMEsIxoyt6CntI035KPior6FcfnzCwOHkIqkuNR7uAKyQZWM6uD09htRrhklisS9zUPK1SyeLiqgygxvglqS89sos5kYxdHNM+rQhd4lh7YFUI13yBzNOBbNtBq+LlkovZPRAT3Xsk7ZdS39os3bFnXepdjMPb/afVcyepyR6jRYV2/cn5nHcgDFxLgplgkM6Xq6ePU/sPwL8vsBSw7Yyr/hfOxVKCkdfTB93ptjwxAKt6XoRMhSmTnNBd04LCH6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yqIcAbglghBJ+pfX5YTKyp4+TeWsViNtfnORR6iyoTo=;
 b=OGlkuHf8iILk8Wdn4QST3V5hlO3wE+ZNxWuFZxAZtBR+O0WpNtltm1yxjnQVNNk3CiVEkl3NamSXreQyPhfMif3dXAWzsryDmnglcyCz4hBchppzhgT8WjUsIV7RjhqWVIsLsEtqAuTA2mTrAF2HmgS50S03A2UnBE8IrXy8r1M=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DS7PR10MB5005.namprd10.prod.outlook.com (2603:10b6:5:3ac::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Mon, 25 Mar
 2024 22:08:08 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a%4]) with mapi id 15.20.7409.031; Mon, 25 Mar 2024
 22:08:08 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 18/24] xfs: short circuit xfs_growfs_data_private() if delta is zero
Date: Mon, 25 Mar 2024 15:07:18 -0700
Message-Id: <20240325220724.42216-19-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240325220724.42216-1-catherine.hoang@oracle.com>
References: <20240325220724.42216-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR03CA0025.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::38) To BLAPR10MB5316.namprd10.prod.outlook.com
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
	Osx2mGE1jgHL/cJJSIlels2ItJrJ/SraneF1RrhcsZc4NDEQ8SFZeHuKna06GjGkNlmC5JlERURG1zcj6DS5JZ0qpCWwfIJYRU2XCa3y+4IcjUEHfdhbKkBGD4XytMod1RBCQ4+jpSBxlCw1GTSlAe5TNriPYMKsVC4IqPTFA7r2gKEFFJjjOQ89ZzfNXIy9Yolu5lQCNifFiLxyoYXSUjp1QXZCAW5dn9/3VfQJQJj38pxRZYkU13jCydDE3cbOtlh00ZRdsLxxCFsu//Z1T3Ce63C3PZ3qNb19m00+yoE+T7IHgznEdvI8MW7HIxuZShN+FFuzauE51NWGHJ7T22/vpbeNzWvFXZ96RL8Zwx7BugQLk2hqhu93LnI4v6K3zPnoQtjs2NIsgDnAKeZRspLJhjMhPEJ6gD7/zvgQce5nwgQ+9RDcEBZczwC+BV87ANdBNSYsezSS9y0gSZqqBzWIl47tU3uMh/Jvh6OjQx2ZSUp6k1T6Rfj51sIOc+OKcyF78iX0m3YT+aaclb72QaiY1Ogf4fUowuesHQp6flga/36irKj//IqagMWCTBMWjfSONmxWNfJUt61lO/153k24ctuVhagxzSkHRgeiCxuutbtMK80JQiEXwISXJ0DNGgVtZ7eaOc2jKACPDZFEPMBgKJFmCMEflFLyY+ZshIQ=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?ZuCHx88SrgJtFuU229me1/RqicctRVGNTx0LU8MhUs3MWuPnrfjoM3k1g0x1?=
 =?us-ascii?Q?mBIWRoubC7Ib8QIeuoUiwJ8eFSHl4iiRHblj016WR8enahkwzlgMk2t+oY6R?=
 =?us-ascii?Q?iVJPSf3aFLnlCrOMPstXbjAsjsLXG/IHnHU1j51jyoIN23uICPc/Y3fHFqyI?=
 =?us-ascii?Q?rP0BiepYHkIGRpq4PVCqDmtrFjW2C0RIJy9JZsO/tbfVPLYE7oqzqsx3QHLO?=
 =?us-ascii?Q?+RW5RonUHQyqY0iIVr+kHdwboChCmYmYA1EbRChbxem69WAtoJSwlQUMEOpa?=
 =?us-ascii?Q?Ba8cp0eygplJIYb5XGoTAdtFUkLP6doP/FvLwcu/M1AqaX/SlimQWagB3TgS?=
 =?us-ascii?Q?Mz4tmGuxgsvABOQxLE7goOT/K5bRubVJ2DMEv1zGzC/nmjBD3T2YhJin7/yS?=
 =?us-ascii?Q?XRZaqNNvhRMe+gRwacys2KV+srmw2n743lHYbGXVCq8D+ctosIReYoFWry3H?=
 =?us-ascii?Q?Fooe6QslIq+ardyJpTpg0fiARVPnTtDxo4n2MqSyLtLQpfxXFRFwDzkiNZ6c?=
 =?us-ascii?Q?ixumG3CyDu0HTjPtievydKRQ0NngBAn+sOA8Btb3AIcZxGv0mxEVg60YuRgY?=
 =?us-ascii?Q?xF/RzTZ18FcadlXd/5jclFAFEarCC69kaImLxkD/f86VH67ohWr63krNoLIi?=
 =?us-ascii?Q?F55R72Ux4lj1rdVFuAxK1uvFKnZgjRYa2hPTii7O3UM/ECBv8x5TM4w5HANN?=
 =?us-ascii?Q?hsMq++GxeKQYyfohZIBAFxtG9+whF43WL4IcXEEdamsKu1UGuVAqerUPqk43?=
 =?us-ascii?Q?60M+wQCiBdzL8iGuVuKiPys3fPRgjrBtpbD/d1yjYM99G2/5cYg6Vi4TzgiM?=
 =?us-ascii?Q?7MtaNQQ8Et+LDQ06xTNZqTHoE8GpsNJ5P/8ewParWNzWzjzsjEKKXXXeLbGe?=
 =?us-ascii?Q?PxqSK2OUc6DUeu/VxKbXhXUqvAyxS/83zC4kYJ4xgJUVpQ9UNn1uNBhykuc2?=
 =?us-ascii?Q?9h/ps47YxAMwKYRIcQ7aMrwWrhZ+U7Tved68alL5AmyptFbamY/aiZdtyJ/m?=
 =?us-ascii?Q?wc0rSMIEX6cKq/GxdgYpN/CJUtQbby837JZXCNcD6QLMHCaenzfzjGcrXZ9v?=
 =?us-ascii?Q?uOZj2ATgPBVSNeTccmkgntrjUFuVQn05E5W02DbrXs5Nl1+aTKwcjFxwmFlp?=
 =?us-ascii?Q?x2yn8TsX4WAgwONfXO7CQnGMS5lgk+bUDNyURPx1zMqDkEHSfJhIeA56MmkU?=
 =?us-ascii?Q?I+wgi7zufmCWWD9rJ3+dWzzkh++sWhOpYgah13wD1hYoaVMOXe7u/uTAjYNp?=
 =?us-ascii?Q?tZtfg45EdiyDZc/DxXL6mr0vUXZdKFogS+jDYuMAElKWwDi2GsWBreKg3uRd?=
 =?us-ascii?Q?dZ7M6sz1U6h81IDtG7w/k7S/LJ++Ds+nf2ckcuYuBH66fw/o5zWYZ/LRI9CK?=
 =?us-ascii?Q?JX2t+4+vbmyVTk6c55cPBPlXlmQ4UnVUorCUKdKjqsDjm8fGwgL4bnidRyXn?=
 =?us-ascii?Q?OkUAWNtwYgWaoiFg7Qx1uQuWHdJGa/5q+AIdWRJ10fRB6OMd/DHi3xDhBDRA?=
 =?us-ascii?Q?nSAM9/KlyJWEakI45SV8IriRe0jg5kpHGQzk+aoLaV9TUpPtI58eAavTaFap?=
 =?us-ascii?Q?4vjEHaHNhE9D7YFKwIW3WT6K6LAVvq3ib3N3034I+M9/M3T8zPhH20QsW/41?=
 =?us-ascii?Q?9gNVdb2BRG3WGxxFtFHvmRHAMibD/9WbOYiXncUHsuQVI5z4zASZeWzoLq7C?=
 =?us-ascii?Q?gnv4Ag=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	VOgY/M5S9/F/ja0UY+r/vHfbdPOSZkFnmXTujdIBadG0LGZZzoCp9caiiLS4qdbZv9cJj94X3K/iAGhTsGT7QjAatAwJ35JclqH9se34ODW5mVcUj/ODyK/f8nz2jluHcYaX+roN+g1SOEtCp6rQu6tZZx4y0d+rtQmxO4zCsP7NBlR8ySov52q0C6veGa4knGR6RsCCPGJm5vbF1Uax/arvGRuQVFkW8Urmh53q/ZoZ5kM1RKubZTkU8y22gix3Ib5/Fow++FYUFai6oe58pUCAH/FKpnRCqnST6mY0EVhxuKT+WmsFbHcJUzwsHSS4wzfBozr3wn8i7KfVsOj8xXXN+QagqxmyeyT+HyLzKuejV1dNzg2r80HlthhhJbrVm+H788LiDWOroxfBOtqLuDEdHhHUCnmfHjBYlHKJxlRdyIcbGDNs3dDNKgn+rIXiRT8DgbDhvI254VNK/K5F4bv13v6PGSOyyXjgwcK3EOtxZFiiBZRN6+y43QuNsSEFuLNmMBB2xEJzB1P/9yLc8nyB89GiBpg5dUpvsWWZNWlR8vIznY3ZpHVUZ35EJn/tW6GSg/l7nvGrOUq0p3i/djBMNB4itHZHqnyatZs3UAc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9abe7f0-dd6f-4f81-ac20-08dc4d180de1
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2024 22:08:08.8957
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qyoONRhuEcZjCyhYJ2sYECcYcTE7uTlGroLjbvxAMEU3dBloYUUBRivMnoL4/qIi2sANVudIICJwvIGNhQYvVgHeYxfJzP/v0N7sUPJqiOQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5005
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-25_22,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 mlxscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403250138
X-Proofpoint-GUID: T8_Mazg1sutv6I3NxYKtPE-9cWAcvJD4
X-Proofpoint-ORIG-GUID: T8_Mazg1sutv6I3NxYKtPE-9cWAcvJD4

From: Eric Sandeen <sandeen@redhat.com>

commit 84712492e6dab803bf595fb8494d11098b74a652 upstream.

Although xfs_growfs_data() doesn't call xfs_growfs_data_private()
if in->newblocks == mp->m_sb.sb_dblocks, xfs_growfs_data_private()
further massages the new block count so that we don't i.e. try
to create a too-small new AG.

This may lead to a delta of "0" in xfs_growfs_data_private(), so
we end up in the shrink case and emit the EXPERIMENTAL warning
even if we're not changing anything at all.

Fix this by returning straightaway if the block delta is zero.

(nb: in older kernels, the result of entering the shrink case
with delta == 0 may actually let an -ENOSPC escape to userspace,
which is confusing for users.)

Fixes: fb2fc1720185 ("xfs: support shrinking unused space in the last AG")
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_fsops.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 7cb75cb6b8e9..80811d16dde0 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -134,6 +134,10 @@ xfs_growfs_data_private(
 	if (delta < 0 && nagcount < 2)
 		return -EINVAL;
 
+	/* No work to do */
+	if (delta == 0)
+		return 0;
+
 	oagcount = mp->m_sb.sb_agcount;
 	/* allocate the new per-ag structures */
 	if (nagcount > oagcount) {
-- 
2.39.3

