Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4D8CA2A;
	Wed, 27 Mar 2024 00:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711498375; cv=fail; b=szN/e+TAygtr/RBgOYCMAtj4EAF9McmPYyfi2FvMYYIATc1KppiiG8dlJLTY/NckrzkWA40AdfJnnh0xsvh9TAPqgwdyRDO3htWZ2v2XZ3FfYurrBrXkwML9n79HKmRn72qFAcYjc6+sT00oB5VC6+dU+Tw58r82Gwr1RPTEsAk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711498375; c=relaxed/simple;
	bh=yn1eJwaPZACK0enbZWOPUs9sdNE/XHts3w21Qt/7yas=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=q6URoCEWLl7N5J8cDEDChxhZv6GikQ/O7YZwHXEvztKZ4m2FC30wIunQbBNRWvU7T9TuimJgTfieaIWs4mlyNHWltqZNCxssUDcuLUDgmHIMuk4Zyu9QMGIuQ4eV+3lhm00HZqk9nxZ1ZH39CriCv5MRbFD628nW7BrMKibbARg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jmU2rkpb; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=l+R/0Fmt; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jmU2rkpb";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="l+R/0Fmt"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42QNnmde008836;
	Wed, 27 Mar 2024 00:12:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=j3fAUf47eDkPMvS0YiPc8w5goUsG4AzmMmMRQfoiBKs=;
 b=jmU2rkpb8ki9u1KSVbxCg4AO46cTr5cPrcZAqnkAHBl9F9KAx75kb0Z1Pz14BPmVcM0w
 YL9HzPczLUMcmtzcQkozgG4w0+dI1tCs/Kq/iBhnz2FIExEsgI30B9lC3PYSMUlMNUo8
 /gYiwM1XpogMBg/OejNr+OjTYYwTD5wUnOCnEYA2VBomfOc+qhkjlTXyx40B1wUAhlfd
 716O/WsmfAcwER5NKThRQwSvGQoO5Gghf8LUVKiqPGTz2h4R0TOejCtMRyJk27KKuIae
 6myG8LKSGvF29OmY0DDRb13sqGPMn5Rlx1PN6C6mHa82eDwIsVOKB4De6E1B243rS/Px sg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x2s9gvsck-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 00:12:52 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42R05SbS011649;
	Wed, 27 Mar 2024 00:12:51 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nh7sq6m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 00:12:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oaRwHrhQAtXiVk+ONFmvr+YEM95sB1eDvQUsws6VS4xcmYz+ATf0Yt7vuxEIXN33IyUru/+R3BxM5+Om9y2YChiiWmsS/f6dY5ynLkVfxsiSTz43oEPS1L3LCf95hR31oPyGF2nttZmbbyDlIt+mj0fto2fiqJR0rL5MHEn2qtYOjadFpnKoJHdzJ+uSWkD595OSffDHAcT8PZTC7UET2ph2r33WPoaHqEAgQJ+xmMbE9VxQY6X3WnAPOKcgua9jKkwb28hKuNTlJzumbjpcVu3Xm3x8imw83UIIUeEKmlQIA+GmdSfsvXiLPzJIu4QmD3jV7Rm81XBDOGpCWdao5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j3fAUf47eDkPMvS0YiPc8w5goUsG4AzmMmMRQfoiBKs=;
 b=Zptw+s50JtdoIY2BxPIN5veQ+gqzfXS7e2CAxQJmGyTS8WYJcdSEfF6h3HkKwOZIHRChzP4RkDgNAZcam8zZaa50XNUeWicmyGfKr7Y2Mu2epqr0kRa989/kdca2nSAbHfJyXj4x3gpaqMOhUv6CtL0dCdhygQGdXGB8JLE866iwh5wiTSMteiswLJBt8j9PQXSUoCekySXawhuv/3Ye+90F8WBpZywYPelRaQwBFkDsTgKU2v2DY1x6/fToxf15bOtYRaa/1FC9VnZOSgbrnCJ3GUdAWPj2/J25epED9FlCfn1qd0RwmhIpFpjCppcH6GMAcKGMRizpNaSWhPwx1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j3fAUf47eDkPMvS0YiPc8w5goUsG4AzmMmMRQfoiBKs=;
 b=l+R/0Fmtxr7Ro2P4E3HY2PfPF714rdu/+iMXJEXNpWENckvoYq7bd7O0VqQG2fj6wZySOL530cJBVyBdNKHPsAYBkkoHsQsetcFwkJPNY92KS1NjokUmIzohQJjnwd0CQK+7sTrn4YX62HxGsJKIZV+BfhemlUZj2v5ufJ9qVws=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH7PR10MB6226.namprd10.prod.outlook.com (2603:10b6:510:1f1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Wed, 27 Mar
 2024 00:12:49 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a%4]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 00:12:49 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 03/24] xfs: consider minlen sized extents in xfs_rtallocate_extent_block
Date: Tue, 26 Mar 2024 17:12:12 -0700
Message-Id: <20240327001233.51675-4-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240327001233.51675-1-catherine.hoang@oracle.com>
References: <20240327001233.51675-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0001.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::14) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|PH7PR10MB6226:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	zFvNQ7YJ4rNcnFCP5S0pHaUw0aIQaW22WUAghlWWKW008pRuaKiwkRoyAED9fvf3pCSyZwU9CIISHPLgbWaG70vX5qvex1DsvaktTdXVXGfDmVFHwTI6rJRwfDeX6tV0qRx12pSKI3i2RYXbKxIHlWiCR02U54ny/vMePLj66R45vo22QjGpY204RmJePgo+xqdwDmQzaKCDM5TiYMpjV5uI4fr/M9UBlRQOcSpmtnTX7rjBWTuXF+9VSuvHJ+ksiD1OGc0kpSqIxivpVPAApE1ft6y+kvc/ulu3VwHuX+lyE/Q2pnDRLzDX3BKM4pPgQnU5OhPh3y4SBpJ4rhcup4JcX/JbhpmtYNJ/51koXTQ4s1As5ZuwBt3SQJxQ8fchmqsE43rDNDIlUJHkI99Vy3jXDDFxDeuq5ylRXeJnyvUTpDxo1L3wrOocSmkW5Pyhz67yqFBp7JyGBGqbRPOZpRowngNGOJhzBA07T5Os8akLyxaYAApnM3cO1EgwjXd3OJkqA4Jrd7Kr7c23XnpWtx4xPUsQCyaDqDlGyj8V+wrmTVB7c44ujB9vIn/mWOrdzh7K7p+PmJKIG6fSskkCzGHEonVJ3WkDoH4x5/XttwkLmrI2zxhgs9jgEWv5BxeUal4MK6H3ULN7XM55pv7uN8nxaonWKLuJCRIs1EG79rs=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?R/XAL7kwksLT3RmWVoblk0zWi/mDJ69/w4zYIK25dAGkquGBRNvzLdaCodq2?=
 =?us-ascii?Q?s0Hem8gsXrRumNXmjkopjsT4U7QwS5RvFPbVFgNTXL0J4UXzFPJR6+kvsR74?=
 =?us-ascii?Q?z9CrfVrcsxrMtzO6XcF1gM5o52Sdgv0N1pugmLz5NBmVBHMydCFX0ZLzHEwW?=
 =?us-ascii?Q?OB3D+uDwc0pkkIkkobZwoIYdgtKzGHR33GXIcRRcTX9HmcbMfHUA6UgeG5zF?=
 =?us-ascii?Q?zEDOT1CcDxuZSRZ6p0Vv7kSBtJqQ3Zc8qo3gXRslOK7HcKpYBDkcmNMdtzOP?=
 =?us-ascii?Q?KeDLceHChZMKndyrzumWAqN6m3d38LpgErh7Duq21v6cBhbZ+UOMfdoNuSI0?=
 =?us-ascii?Q?OxkukAS6PPTbaDkWBbJO7N3KyPfSrRAVWXW119kqMs8VMkvXmHVL3eA7c2ys?=
 =?us-ascii?Q?mG2gIxi0lIdsoqkvfUndsHqTZl4CVbyRYJSRAkbhFPJrf9x+kmitIWmE3JGw?=
 =?us-ascii?Q?NBQYOzh6AlagKn/OBoh3Q0W+2CVZv8VM88qoqxvv3uLV2yWWCvzMJDEzgFl0?=
 =?us-ascii?Q?6XT2/urH2BUNc3w6NI0Ns+DCYGLOXTIi/KCmw6OqnM3xaNO2Po6G3NS6euxG?=
 =?us-ascii?Q?kjWxgQqodNdQJSnERV/9j9Z+Nlwna5yrWGLCH0/3yWIsOrOXDoPY8lBPP02E?=
 =?us-ascii?Q?UYQhINKNXV8wXhHmCfc8f+3kUYHR8/bJlKcFyUHjZrDhP0g/gdxLG2dXTLHT?=
 =?us-ascii?Q?sM/J/UVbA+pmlPGGKOGrIXEUzUfCzsUr05S1N6Mc8qDe4vVUtKw9DiGdI4vg?=
 =?us-ascii?Q?TId9HCpU4LejMZzyJtWxobpLGrjEs021NhB/rHooWHh74phsSEATAaJ5u4do?=
 =?us-ascii?Q?M05b/6+XVJbwoNqJQ33CDPeQlAJdSLQr30sgzNI0Tgk6unvyur9WpLsgPPx+?=
 =?us-ascii?Q?8ALjJHeSsMnpv8c4FtImJ0HA5mMtNoz8hRqcMJY4MvK1EGNvSLJ7QGr+d4ku?=
 =?us-ascii?Q?CV+jgDrxBjibTMq/UTaqGYxrLqR7t0JJCnwjqXhA9pY/R+LjelT1zOJTginD?=
 =?us-ascii?Q?nZQBxk3boS8LTljHYmvo4qxXV7kIejR3YRgEJXS4SyCHbAqf+nlz6zZIPdO8?=
 =?us-ascii?Q?gGLlzklijDqkUe1BJKC3/Mm912pipmLSvy8TqyEdBO34zsxRiP8wiciQyfmd?=
 =?us-ascii?Q?wNC8p6PoaWJeYdIMBC5LT3nElruAfDLENXHaV3EzCGGoxtxcegCAfUE9dQpO?=
 =?us-ascii?Q?06gpTJOa5LkyxgpceHiJAuwfjVtWT7yxKwyk9+MUHuvF5EwxhiRERWsHM3RL?=
 =?us-ascii?Q?JN4LvnZ3Qqfu2iijHxrDj1b8ICPjtpLCUADfq6elueDwoRUyl6lRo5OLAOIX?=
 =?us-ascii?Q?mrPlif/uszo1p5/xhNEWDphM+DUBq6tkIo+/wiYsp2nHzXvNfMjQ0j15DK1q?=
 =?us-ascii?Q?XIGPo/xPjYLjZWduiwZlV5WypJY2Z4BcSiLWoE3Hjppc3Nrm2e/HYpFynRbh?=
 =?us-ascii?Q?5sTzkv0cdzg4iCWSuDGxjAgIX8gGFOSyr6scGT/P2VDj5sf7dvzp45YVCOUf?=
 =?us-ascii?Q?kIGyglYkEV8H9oL8+HEg95akcNuIY9YtT9FKxsRj5AsLh6dE+1COqbuaZBSG?=
 =?us-ascii?Q?Vd3lKLbzaEAJYvp7dB7uFtnKAXhJIb9/nAr1T46qp3jswwVDSDFhDB2zsXwS?=
 =?us-ascii?Q?9zBeDxnK0LTNzHvcoDJjesDA2/BGLUh0BYcWhDJ+mSKyA/ZcTtQcN4zOw1tB?=
 =?us-ascii?Q?puYJHw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	NtzlWruhjdZ8ON7dxVY51acAM+N9Db4bD3C+lq65Agg+513jB3nZ6w9lMIQ8kgfnhV1mOtzJw7R8pGY843Vl+MKOa0j9DiU1pJFyGmPmYUjriKrrFCkh0Laxfym6THoWsXNRG46u4TuQ9khliV2YC0TZvfOGDZ8raKqEebxjYdCCY09Hlc+JAALsIYdk5E/E8J8NvrkX+Li0TPm2Mv9lCPQmAwr4NI4GmF/oL2AbZdVeBmd2bLsgqni5YBvW8v2r/JWqIbo2F4tkaLfK6kR+4r0iDSpFJYVJXwZtt2MjlLB3ODX8RlUUO2r9wH5HpVNUXX8N76aunB+YXJRoZGFZDS8xLPxNZOqDf34OL0zzICKJC2UNdRMTB4hM4wJJheVeLPDjrmz91Km+XNQgf9dX9CStquoFuc+W1Qb1eLgNa048zSvDBGN8+RYA2J9N9Vl07Z1pvjPhcoa8BuQKDygSfCN0ye1xBAkq5pALe974oOtODtsd+Fmx7N3zWkimD/7Ift+g/+aPkVnZ0mrf13Cich1TLIqn8fgu3qecsFHyxYcSYf0qVkszNww8YnBVciMIYkRkO57/u93sgRicFuL4R3LlwSF95QefDaiPDrOac+M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 752b612a-b912-417b-36a6-08dc4df2a2fc
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 00:12:49.2792
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P1/0z8PZGH/b/Gto7xMJJgoHDBIAf51CDCxe40oV8NE7ucpn1UjCDZRmeXiHAM+RfsZbTVbcGdw9VdpngU1A6lMb3w5xiVwPqb0CKV8Nd7M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6226
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-26_10,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 mlxscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403270000
X-Proofpoint-GUID: MYsHpjD8lUOL6h2nrgJLaTK1AQ-fjFaY
X-Proofpoint-ORIG-GUID: MYsHpjD8lUOL6h2nrgJLaTK1AQ-fjFaY

From: Christoph Hellwig <hch@lst.de>

commit 944df75958807d56f2db9fdc769eb15dd9f0366a upstream.

[backport: resolve merge conflict due to missing xfs_rtxlen_t type]

minlen is the lower bound on the extent length that the caller can
accept, and maxlen is at this point the maximal available length.
This means a minlen extent is perfectly fine to use, so do it.  This
matches the equivalent logic in xfs_rtallocate_extent_exact that also
accepts a minlen sized extent.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rtalloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index f2eb0c8b595d..5a439d90e51c 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -318,7 +318,7 @@ xfs_rtallocate_extent_block(
 	/*
 	 * Searched the whole thing & didn't find a maxlen free extent.
 	 */
-	if (minlen < maxlen && besti != -1) {
+	if (minlen <= maxlen && besti != -1) {
 		xfs_extlen_t	p;	/* amount to trim length by */
 
 		/*
-- 
2.39.3

