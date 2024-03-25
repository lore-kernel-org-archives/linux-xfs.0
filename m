Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4837771732
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711404506; cv=fail; b=qy111hEbqFJZqaSZAI2F/IBkphU9HhNVwqj+/+1+mVGpJmhdzE8wba3cW5577mA1/eyUxRQwhb/r8LIPPs32gPz2t6u1TpB07tu6TX4km1ChKqx18gjmP1NYDK04sASYpmmTS9bnQUUHMScttk7ZPKkpECOMixJSdEQsj8OxE8A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711404506; c=relaxed/simple;
	bh=oHSrdpfkoEh1ngNtKeNJqpeL4o4knMTXQ2MOuKl/F0w=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rrCBOw2rSCtg+5nY9bMK0qlJ4Wt4vrpIB7Xt5iMl/a1DEFz5JYWW76JgcU1FTUvZJ01TvIqP40KPyiLqhQm5ez+h36kRpi2Fr5IZOUYXaOq85y7kcJM+Jsgzk/8JIM9wpRNkFwg+oOqVbomHZUt9S/y2LP1AOgCwkH0BPThI7Ok=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dBzruGDf; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Mder2l9/; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dBzruGDf";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Mder2l9/"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42PLFvRk032449
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=KNM2q5sUeeytz1bQol0whl0X3tbcUn84s3I8u8mhcek=;
 b=dBzruGDfEw4YTdQGudz4mtecQ61jmynpL7aWWO/vy/HtAXjIJW9SP2mHZ/LIAfeDxqqg
 rkzmk8y5wH3Vz8F9occ68xFomoQZtyRTW6urM1xpdag1TEZWB3cYVHqQYwyGREmyV8fC
 +n4tpi2lfZr1YF9zZB2DU6YnuivlHc15ToamEq5io0gGiaydTw81ViLR5JHS/88c/GVp
 JeUiM30gK20XK9LsKkTy6SxzK+MVOmu26fY0KHdHUhyphi1bjrkZYlxpRvtCJG6xW2Yk
 8KNgzSaXFER51E/85Ex3dJRXM6qyS539PAnU8xn+YMQKdGt0RbxiEPjTJMeJsfa/ROXX Fg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x2f6h2r8g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:23 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42PKNtd5024519
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:22 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nh6ccn9-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Iihn5jFWMAplaHr9TXjyZql/KmFbL2fhapDr1ASvnNB/CuA7zFYA3BRxL8aSwEaEIR3pF/VHlsw/3n1MCIuY+LRVeck9xwGMwuO8r9JgaSINw9EbCAB8l4ixTH7/GRNCSEL9PAKNGi7hA3LqWCskWDUX+zMDuS0q4tJ8lWQmCc4C8vGTfILTN3Wv28LjODjJvDUXU0pwKC5O2C5iqfiQHkh+hLC+U4UfqXcZw/EQ5T2ZkVwG91Aj3/xAWjCrI/YQVjhBshz514cgrpHI86/5dKTD0qDhHXgX2Yu7beGa6QoNe0ztRJArX1vTW0ciOpp2pXi3nFTOxTDEDXXzeroPKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KNM2q5sUeeytz1bQol0whl0X3tbcUn84s3I8u8mhcek=;
 b=iaRRFuKFP4p6K3YRA9qwaDlQlYC3DOqPH1nIXD/bKwNHSq6VfJ/dEWSm3rhQyi+LBLqNRXRJ8TKOgLnUkY/og6paRbYUQnrs4Z2vXIKRhJEx2e2wMVfhBzm1fQPEJhLGCjCk0xnzYJkDl7MnbJoxZS6giRJaobBrHXaFpuE2flKm8ykJzIUF1+LjW3gxc7OAoMyroiG/iuvn4tVxoCF0dWHGpgxcqURWtLAvv43szR1WZ7NAQdRO3XcbvpwwaJg1nusUUAY12KxxzJ/J394F9msFPCfnDnGxDt0adKEo3D8nfZPItTeqfjg16Jjw8EuTLoUhawLbmrXkQwwHpV4YhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KNM2q5sUeeytz1bQol0whl0X3tbcUn84s3I8u8mhcek=;
 b=Mder2l9/htyVABL5ZNdZcKeegfiSaGPzSbKR11yhlrPdMMnbwJmNkHQPQpvFlZf0LsK1CynomefTiQiSj388YD2UDe1FDr3HaiSUkJcURPp+PFGxzNzZSlIDj9yh/ZF3H7lgQfEZBq8/3l8YJnwS3FdwZnCSmAY5bzlWOHjBAGI=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DS7PR10MB5005.namprd10.prod.outlook.com (2603:10b6:5:3ac::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Mon, 25 Mar
 2024 22:08:04 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a%4]) with mapi id 15.20.7409.031; Mon, 25 Mar 2024
 22:08:04 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 16/24] xfs: add missing nrext64 inode flag check to scrub
Date: Mon, 25 Mar 2024 15:07:16 -0700
Message-Id: <20240325220724.42216-17-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240325220724.42216-1-catherine.hoang@oracle.com>
References: <20240325220724.42216-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR03CA0005.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::18) To BLAPR10MB5316.namprd10.prod.outlook.com
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
	68aInk76v5Xz/yJfECaQZn9mhM6vCobwo5SfZ0f3ABs6+2AMExzLGIX8cf/ornCEc9beU/kCDJennL0gvV5rwnJfm1lnbMRHN2/Vleb/P5+Yi34K7nuUcdKJhze5gDAi8h+22tVjiCwbf/N+93CCJ4rC5/A4L1fRzZGmKTuJFZzk4WviVuyK/Z50KVcRLJo5ij7IO15nF/8MdThIljhS21Y7K/aWVOl8qWajZ6Nry2EL49L0jAefaWtjLVO/HI/fw2wIIA1w+MTpUjt42lLsh2alGqchM9Ye+2uSI1AnuKt5HeyFOLIx0ghuSPuzpsPIHrdqaGURJ/qqgK2SPEN6ovS0k5kSWEqnSlOkN34dVJZWSWWOCJcKWF5LSdIEv3UgCg1U5HxZkpwLogqHQrYz3oYnPhZlAHeNfWBZl2jnLvR7FxEczj6K6SzXY1g3OgknapV7fvG5BUzdiu7aMw+JUGrBgCnFHcZqzhAtZ7djJJmUGxUjx8J3RncWzsRptRUzu3DPr5e9qPVH18ygyFEjs/+0wLJTvOCjyOoe57oOhduFI8JPJv+MJVEipFUBSsxtgHqmdMYD7QUKZOOJAaWdHveGe5xYZToi/+8pfG562AcUwsyYIFTJiUWDMyIBvOzT3glymlLNu5Y+eA2VoTt8MPxyRWGf+++AKAOQZ1zQJWw=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?X9hl8rHUBGWoJzXcMTvTyKqFRQtWLVilQn91YzhEWeDFFVfQ74jFj++iHUoT?=
 =?us-ascii?Q?sFb2gaUCn0vFBGHF+lI6ZjfXt9vLvNMjX94cmwGkFIIOd1vfAgY/wXOoyEGe?=
 =?us-ascii?Q?WfBYIeaaTTX8TcRvvxARJpZkT4MdYcFMtG+SFJxYXlr4S7NNf52lg9CxeNAp?=
 =?us-ascii?Q?gKKjj8wB5qcTfyfpSJMOQB3myd621iuty9Us2X17EE25Vq8vZcrp7/dxeSj1?=
 =?us-ascii?Q?nyYTezMDFvdBYphPrMFmxxTiSGoPIHvHvnEXKvMtR0jemzsYCWiKLdTm/t3G?=
 =?us-ascii?Q?lmQZm3an7/NOGiXDnJ3vq8RlaRFvLIlpNBfkgtL6utTrLiNHzQjzky4LJiZP?=
 =?us-ascii?Q?xtRoasU2T21ZWbuLmCadPEvZZuazf7stj3AZ3EfkpcNQq/RT7evj26ppYBrP?=
 =?us-ascii?Q?yRU8B3UEdakgngnoKlG++q7vm/bI10D9MF3VbPkkZKZqccrk0NHJPGkACnZY?=
 =?us-ascii?Q?VhYcZ7/Y8I1dv+9+vA1rwiwD3LdFCshyo9bx0eTVuZyH6k82KbdnaaqiBbUR?=
 =?us-ascii?Q?Z3YhumYC4xTE//gjyqsfwfow8Gf8eWIwLcyRXErSq/KPo+5fpZ3wTb6XE8mm?=
 =?us-ascii?Q?0ctZbSECjecvCw8afjg0hv00KfbKyZI0/2VLIJFAGPiEH9g/usGDRfTZ4tec?=
 =?us-ascii?Q?nOQYBBrikFIxYlPkk2/zIRZ1IYIyzkHv93j0hcdD5qwqpOyd+T21o4iuJV+q?=
 =?us-ascii?Q?sbPaquXc7ew3NCQPgLB48JWeqETUqRSNFJeDnq7ATbmOtKcNmUUMQJ9U4skn?=
 =?us-ascii?Q?xT8yMYG7u2goLuOCmDC+eKG+hA1RkbRZByrsRD2ahprVcDdJLKPKNnZljHPX?=
 =?us-ascii?Q?e3HeNnTev/dVKiVn1814PJI38mjIYEgaZ2WiHbIom7bcSBjrxfK2TtsyfP6l?=
 =?us-ascii?Q?l+gnvFphgoKdmKDvTd98OmhMYpH06JPbS1/YMkYavbN+y7/0xaQvl8c0b3+v?=
 =?us-ascii?Q?18DoYvrvh5NBDJBbYdFtw4tjwH922vf66fx0jhDveRixLcK0ultB4/jOsPSE?=
 =?us-ascii?Q?3M1Yckc9v62wF8N2bhU6axJ4uQqHVK28Ao9s2K6qwHIGgQCKND8kXK2r/9/z?=
 =?us-ascii?Q?HrctEJHBrZM0Igk+ZVF78Ht0Y/7bS3nooDhrGj1DsaV2y8pZ1TZ3tZwxRU4K?=
 =?us-ascii?Q?W3WMBybw/bcKz+ijn0SpeNLB/fJgjtOQsFMHZ5d0h54Zhohzze3jhPY32zPi?=
 =?us-ascii?Q?8INyL3SozkghRj7MZgg7GmAYTeTCVKI0DAhYCSnmX7nBYfwregNHnjAIcc6b?=
 =?us-ascii?Q?coRGl0mOjYZp58BV4N02c7fG1pFey79a8wUdm9hrf75uhcBy+SZVyZMsUliP?=
 =?us-ascii?Q?xo+z6diqs1itAikyqWQOEiQNgZR1NQfoma6KllamjrYRJlZ6lavTsZu0WLDJ?=
 =?us-ascii?Q?dwdmCI/vz1voM7sf9zMwlZNC60n36fNlPwqEGVhsciQnEAmwlRpCOL6nvs+2?=
 =?us-ascii?Q?48UlxSc3ryUtwhnSCpCLLuowb7oTFGsRwKihb7B2053m6JcgtE4k07J6BndA?=
 =?us-ascii?Q?AROWPhXjuNcfumDeby8/OqgjH0+XWwONQWtg6MMwP0cr3GFiyblt/4cituef?=
 =?us-ascii?Q?nhhfdvFS700tBhAAi/7tLYzRRne4KkQ3OlYUElAt7mxkmfv/t6+NtCG2Dn0n?=
 =?us-ascii?Q?NXJLn0IDIMzct8Cq3ogAZXPIWz6mDuj0y3gdmRyEphkyBl4GV/YfK84Xr+Nl?=
 =?us-ascii?Q?3iqPxQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	i1S+cF+d71UOTdxpsewJeoGNonrINWQ8AsPEIMTlwnHjoXF7JMd3dgowKqibRKau4U13/7ovqAb3F213ynOzVNWwXx6BBzGZIc0ILk4K/9pZrL9AKe/nDYzc2XZ0c+q0fWXmTMsWLJpPZHgpAFXcv0VvUMFnsZNGuWcJJX/+7yFx6zB78IjIJqRRfLNunN0q4/ahaY7MBa/nFb3iYVPVL5d+SpwSB7jSGaIVNJ32Rv2uY6X6+9hgd4L95tLcJADuFl+YQhxY8Ov2dbCNK0sTJk5/ihGnCKdtEDGor1TcQEP8jfIJVsY/TycmL/WCZdeLVqSz0k4UiorUINVoMLqJ/sYtkOV3kkdEhdmyu/VhUxEAv9EzfWZ3q+G+dYjiukSOfoB/3CLF6Gk+W3hPxE6ew8o/tVT+QGdachDiLo7tCu0bQbqIaqx6tpj01oNhZ4xSeRlNrp7DUBsfJYQ8Xv75JMrg6s7RRC2Ii0pe6SDaRFb9sIF5SuJDeCjcbBwM9nwnqKZ3f+mm9/kLJHH0h21kUAAzuRuPTNn90UFN5NAyvi97+B3CixL6CwjDqBxef0304wICAhm3FAurmv5vFZLZlaYytje+1/ItjkHkGPy2QbE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a33193c-2f1e-4900-46d9-08dc4d180b80
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2024 22:08:04.8233
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OmgwMADPtkU0q+gfKT/Jqyi92ssHVRnWcyUxZJucUGVY4uHOu/QYyai0pqjl5twJK+6a/M18c9NJc0vYYuKV6J2zcQizuITns1FRZHXaYIg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5005
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-25_22,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403250138
X-Proofpoint-GUID: kDPZKJBv0TYPgCo3FnJVKs1Up457hwQG
X-Proofpoint-ORIG-GUID: kDPZKJBv0TYPgCo3FnJVKs1Up457hwQG

From: "Darrick J. Wong" <djwong@kernel.org>

commit 576d30ecb620ae3bc156dfb2a4e91143e7f3256d upstream.

Add this missing check that the superblock nrext64 flag is set if the
inode flag is set.

Fixes: 9b7d16e34bbeb ("xfs: Introduce XFS_DIFLAG2_NREXT64 and associated helpers")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/scrub/inode.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 74b1ebb40a4c..d03de74fd76f 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -337,6 +337,10 @@ xchk_inode_flags2(
 	if (xfs_dinode_has_bigtime(dip) && !xfs_has_bigtime(mp))
 		goto bad;
 
+	/* no large extent counts without the filesystem feature */
+	if ((flags2 & XFS_DIFLAG2_NREXT64) && !xfs_has_large_extent_counts(mp))
+		goto bad;
+
 	return;
 bad:
 	xchk_ino_set_corrupt(sc, ino);
-- 
2.39.3

