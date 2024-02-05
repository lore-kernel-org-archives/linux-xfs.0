Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD9A4C3AA
	for <linux-xfs@vger.kernel.org>; Mon,  5 Feb 2024 22:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707171639; cv=fail; b=aEObSWkq39zu0jDPKV3J+YC3yToE66CCK4MdUfUDP+X8nXYQTQZLayTDryn/19bweYQzDNRGLLKHlTZuiExQKAdi3n393zQRiJ4UpqSGG3Y12i21aypmInU50ErHyHrafpkdUvTCmqy8rH3v6Wdx4XirOmiQsWWHPKSKTFuN70w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707171639; c=relaxed/simple;
	bh=eewdmrWtAg5TmPJgfEXbBidlK+HhDAzwFomIK7rVKtY=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bGEYT5nhS6yiC0LHBsbsYop/Q3FBhVOYvtdJfIb8OmjWaqZ184cc2N7Xwazr17BGT7UKindW8XEuGpkOJNgsF4Aua/3Y9DRgfgV4gYTkJy/gwXXNtHY5rZCQM4oi3tPpLBIxiGssUiwFou1FYcLNFd22cdHEEWmOjncXxi+LmY8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JDSMQNX/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=lSg3bYqW; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JDSMQNX/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="lSg3bYqW"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 415LG403020835
	for <linux-xfs@vger.kernel.org>; Mon, 5 Feb 2024 22:20:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=uv9qbbhytKoXIro/SeVixN45gQ8NSEid7dbusNjE0lA=;
 b=JDSMQNX/gUfkJvkj9PYYAnsekEhwguph3Z9M1lATqI02aC8mv1RtSmt2R0GeWwn4ife5
 SYYHclIXZGGTTfpuxKmipa0/WbR+vtmn+1DtXXHNLseAoDaYt58X/BtceoHDrG9bPZPV
 AINOSWHJG2XvxZq6oAr8YuOFrs7xv8m+biwL59YhxjlXLCbZOpMVrryz2Qftw9A6BdIE
 4NNewQOt7u6YMla+JNoFEObPRMG3G1sfxAz1fqhjKDLu6zsa/EReDs5T2rQFnJyPGhlj
 OpPQ4nwFnljQgGv8v8oB7X3bEUECCzAg0JBJqNQmqQxnAALyQHkbu94gH3k2+m03OCv9 bw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w1dcbd5aw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 05 Feb 2024 22:20:36 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 415MKPwH038466
	for <linux-xfs@vger.kernel.org>; Mon, 5 Feb 2024 22:20:35 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3w1bx66vn0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 05 Feb 2024 22:20:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LIAjrGAubE9nl1Ps/5CJc6RW4QagdWcwy+OR/fjvj2OsqYyboL/h8ai/RmULfMbgLsrcTnphOR/Px3k9o6kZ9sWHRbpIf0zBKSHN3qwXjQObM7xZq1GvrxGeaxqe1+jw68ms4UIluVqN5sFh7QcJcSPsoKH4X89gNnQAiUus00guzogkZ3YGnVd4t2iRe9+Wl7cxV3jfj9SYm8ks8er3lSjE3rfryPG0++7uT1EUQ6dFI2r7QIqOhzqL0P+kYydOGTdojXo+UV/6fqHJJYEtqQN73iP3XRDwUTKmNK0ms2k+gZAYKMiW71HBcnlw9azd+SQ/8zICyWuxkSSKy4iljw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uv9qbbhytKoXIro/SeVixN45gQ8NSEid7dbusNjE0lA=;
 b=lgiYk77C9+Ar8USFr83gj9mMZa/Ri2vPef0MUBxAYlzZ7a2a9WpEb6afDPov0ijdtBE9OaLHiAENlPVEeBG98dkHqOGBW7ObHqeZpntI57LSX87Mm5AUOOTP54M+jp3aE1GUq8bpAXJeghiwQ+qADJK1ecJbrlL64FokqW4rpyECzIAy2TBNi2L4K4Kg5t0l40rMIzyl362yy/ppXjIR8b+EuhT9ETRPvNXUYez7w6TifO5Gu17GojUrh0WDPOSNbNWTvO2BzTANn03+4BeSLs9TgPFLSSmp4u8qmqDgH8JvdQJmSFCX0IPavm26Gj1kGrvtwodDs6eKUnZHoP0tCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uv9qbbhytKoXIro/SeVixN45gQ8NSEid7dbusNjE0lA=;
 b=lSg3bYqWIJdSA5vZsdE6VgHbD4ysO4YOm5uRIRdnJxO67AfaV9zm16YgDKxd02aATJk55YCTt34DgTRxYJZMKHcPvWnh/z9GI3hdZrZmmDRsoFsw1QEMCyzhSTON+Bsfj3iqw4NrgJTKDROf1VTTxe6/h1oCJS4C7Vzmhhzgroc=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BY5PR10MB4164.namprd10.prod.outlook.com (2603:10b6:a03:210::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.34; Mon, 5 Feb
 2024 22:20:33 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f%4]) with mapi id 15.20.7249.035; Mon, 5 Feb 2024
 22:20:33 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v2 08/21] xfs: introduce protection for drop nlink
Date: Mon,  5 Feb 2024 14:19:58 -0800
Message-Id: <20240205222011.95476-9-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240205222011.95476-1-catherine.hoang@oracle.com>
References: <20240205222011.95476-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0225.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::20) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|BY5PR10MB4164:EE_
X-MS-Office365-Filtering-Correlation-Id: 59cd1a8b-27d7-4d8c-26d7-08dc2698ab95
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	nPmNn6ukhAsMCi3EOuZWOs8Hk/knLwvNcoJBvwMDwzN8v0y+03N4CSoY7wmkgEKcusljcDQxdZ7cWTBeK1Id00EmVQhqff0TheQoOzef3HHXUR0cHzqbfsHn+PLNcyaZG6DEX7EOGRD0h+Lq1ZQe8Jd7F8Sphp8LemLDE/o40HaBAzumKYZWsMLvG66QNhvs54nYCwSNSze8owNzqQqlG4KXHdZybttMoz9qOQxiduOCnGZlPmzBp6HNmfFYlMMkM7eG0salYRx/BCnI4k86+J+kT/ySlIFqjBky8LGj92F08qtAm/HZFW/I3L1pc/+8qUd3wljHHGKKqOUfhS2H5EmlbTmDOnjdnlg8Cxuh/hEP/Hdo5ItTJxzt/gWun0AWnWkAjex+ZgKHJ5Gv3cMFOy1eH+1TsB7oWWdD6+97fKgwUn2qRzXCWVy+QKkIR2YHtor8U6Z6ocB8Pl8+HHKrkkkXvl0HKYSor9Cb69c2q7bZH0FQf4bmjwVBmK/14PzU+OsQ3ssqaoRKkil1GcsqS5oae7us6+cYX7uUXSCR/Nix7QzyQUfiEe9JCjNPupgj
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(346002)(396003)(39860400002)(376002)(230922051799003)(186009)(451199024)(1800799012)(64100799003)(41300700001)(316002)(66556008)(66946007)(6916009)(66476007)(86362001)(6506007)(36756003)(6666004)(478600001)(6486002)(44832011)(8676002)(83380400001)(38100700002)(8936002)(1076003)(2616005)(6512007)(2906002)(5660300002)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?+OoD6JfYaUiavbucv20lv2+o6wkirXFKhEztF5NCS6qsnYjTB8z6wcvx4Zb+?=
 =?us-ascii?Q?ClvtLz23bDswcNx5DDg52PMScibOM+UUyeFqe5TmOsJUjVz/grm7xjcjjWvm?=
 =?us-ascii?Q?tDQxhDJ5iHXG8uI8Z+JuW9hbJOT+rm2dDU3gsHJT3XveMJBaLYksWSCwF59e?=
 =?us-ascii?Q?nFMjxfL52NMOPRNs9QTAJIX/8VS3zhyqnaRwTD8i5+vjtRCH0X+u2uUDaODV?=
 =?us-ascii?Q?h3ZTGXZkmgs3yyKWE6eQostZJMR/GG3MDdoiWrC3jppMsDNQTvP/ncWMq87S?=
 =?us-ascii?Q?Wm9mi/H8bpW+oA0VZ58pBiuDyLyOSqz44rkLxjypu258J/Qi5AOyZnxsvx5d?=
 =?us-ascii?Q?fEWdoh0vZqT4uBk3Od+1XWWnh5OT5TH9xuAFYBH2HwOLvOSgnqqhHXZTg28x?=
 =?us-ascii?Q?I5QXbzFeCeZ9ilL6yQwXG1sLzy0LQRnV21chUL+pgbgz1QkrymYc75kZQaQh?=
 =?us-ascii?Q?PWaFtT33xp1FiFnDKWjQH/45vwqchqxCa7Sg0yTex6L4rM2TKMOj7IdK0Q/K?=
 =?us-ascii?Q?Ule7GLrg4uTKbwsa/6yUNwjgv2l0mV7fvzsGJ9EAnsX4GRpNYUwZ+KzFWS32?=
 =?us-ascii?Q?2T49OTfDhqXvIKX7195mMpPsFm4eXb3DXHNk/QiB/ARkS+aeKRb57o2Yfw1c?=
 =?us-ascii?Q?xRgITm/6ZF4Ttuia0WvG3ZC58z1hnUvwruG5nCaYIJcJLJ6Lf4eOvVWmmSYx?=
 =?us-ascii?Q?8ciPWBRDkz5EkdUfPqhnX0LBtHGTsRDo3gLxwmqdNTpgD5tLLLjgrVwbx4o7?=
 =?us-ascii?Q?pHklGTarlXJQxLcDfmRV6Im+HijyBvsqOtv/zNn2Qr64azGmpGBs8crJZt6m?=
 =?us-ascii?Q?Unddc9wyi4p7SDSCXDMpwFETYHaFkHtVFWirCon1Hz9XDU45A0kKaAv02hmG?=
 =?us-ascii?Q?VFDx35vGUWXnT+UvgTFJ/BJMNG5Hdz8xYNMESu6nRFaGQ1dkm5Gem7+avaiF?=
 =?us-ascii?Q?cSQjqnF19gue/oFdi670W1rbgz79KGKywbqjlvIWOPkypTBKvxcpNp7h1bRF?=
 =?us-ascii?Q?g8ZLfUFykdUcVEPry/Jg2VoS78x/AtRXMjJh5jLenZ1lxMWRiGIW1Fk/hmuG?=
 =?us-ascii?Q?2ueJxDMEz7h4c4pDqbWYJmw33NaCDpSFHohRu5VmkMtwwyLGuJcHS/71gnqR?=
 =?us-ascii?Q?KtYBx7I21Ie4gbFK98aSnHl4JnwjZzTqxowGTj04wDKMKEiyHfFYNw9KHnLo?=
 =?us-ascii?Q?rST30dt1lhCoTr8PzqXuEcNKB36s0AGdT9KhWggRbUR4WtL8785JdGAiMp7Q?=
 =?us-ascii?Q?HJ3MjtaBb3XxsyzO69FiLPKU+yJNscgFR13tR1ex4KmYsWrUJuTQQmdrkPS9?=
 =?us-ascii?Q?NXrvNXT4WO+o5hDbOvYM0FeJbErYWMFICjuymbRJbjDpcvBePw1yidj6ba6J?=
 =?us-ascii?Q?ouf7y3Xn0kUhgblepOKBkebR4mLQf5Bh12lzEfUIDiAXxyZpQCQuZwx2Crjk?=
 =?us-ascii?Q?8b5PPxwOdJeNbsyZdZ/y6xjRnp4UkK6mULcSEZp8EluXAG2VbgKwMVdNGQ6+?=
 =?us-ascii?Q?69AgMCaiLBvgWvE/sY8XcWTe8hG2Rz1BilELsQO1rZ9cokMsLN5fqJexpj+B?=
 =?us-ascii?Q?k18AeRXYbDlj9rwgifDv0cj6lwQjYJ+9Yuu2K3oeqDIv/8lhLXX6/z01GXNp?=
 =?us-ascii?Q?bTUjJ5FfmmXAj1AZkPm0BNElRNBzrdYbsWDW1BWZbI4ieARu3no5GaPrvrgR?=
 =?us-ascii?Q?3EZRxA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	cFQBHvVRn5LOxSUozgtB68oCk5hTbEbFxQ47o3dMudZbOE0VxeOBvKFMzIQ00SS321vDCIsnGL8jZOra0KM75uy8awX5b2td6xLcP6DVdsOAYPpBIllC+ObU/lDmTVGJwysvQHAvpH9c1/nruiebquvtalQXpTmelMQ363s8tb/pDjIXafjTq7ZA+duNKCWtW27Kz30E2SShrX328mNSVYjaP9oFUp98yr3MpRMLROg20Xt+pF4VXhlKOnNSrWJh2Z9jCRvwYjP7oA2blaw2JYQT3+HxKkjgh77wYCO7Hl8E6EIRRuCqQZBplRE6qwPcFC5pSk3hI/3nz3Tg2A5XnAXTe3sKglz8lBbA1y+qoZyOAE7RjtKFIwy7PLaCay2fb4kE/iWLqhySjbFnBtEuT2c7IvSxj/4+UFLsR7ItDohcwQBu9FPYD7s8KR9jlTNFNgOAmgYzJpHKzhAjydliNw/BN+sHrp6J7Vta2HEGmV0d77bXbnaWQZ8alDOy/gxXV/uKsxkh7iVGtLaPpvTcCFfqTSVHd8lNufd/KSbcObfEbcC3m1Dtq3WdhUmnmaYVRe3X5n1JmoK3woo0BHmv6GOmOJipngMJMkCbPxhhNz0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59cd1a8b-27d7-4d8c-26d7-08dc2698ab95
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2024 22:20:33.6285
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bXWMQTVu7zLPPg0CeGkfMb9l5VdBc5mb8S2cg2/CbRviFKRGcK8bVzpYz0VU/gQL5Kbewg1Ooq3Azs5fyh2E3h3c/IQck2ndeqw0Z34AKNo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4164
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-05_16,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402050168
X-Proofpoint-GUID: _ddJY7PrJItZgyCw4_1I_DFa146zTX0G
X-Proofpoint-ORIG-GUID: _ddJY7PrJItZgyCw4_1I_DFa146zTX0G

From: Cheng Lin <cheng.lin130@zte.com.cn>

commit 2b99e410b28f5a75ae417e6389e767c7745d6fce upstream.

When abnormal drop_nlink are detected on the inode,
return error, to avoid corruption propagation.

Signed-off-by: Cheng Lin <cheng.lin130@zte.com.cn>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_inode.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 4d55f58d99b7..fb85c5c81745 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -918,6 +918,13 @@ xfs_droplink(
 	xfs_trans_t *tp,
 	xfs_inode_t *ip)
 {
+	if (VFS_I(ip)->i_nlink == 0) {
+		xfs_alert(ip->i_mount,
+			  "%s: Attempt to drop inode (%llu) with nlink zero.",
+			  __func__, ip->i_ino);
+		return -EFSCORRUPTED;
+	}
+
 	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
 
 	drop_nlink(VFS_I(ip));
-- 
2.39.3

