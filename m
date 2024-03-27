Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF3D28EC;
	Wed, 27 Mar 2024 00:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711498406; cv=fail; b=IV7ZxI5JVov+LwWWfQm7HIJY4Uu9vXwPfdBqolGQj+YdzrvhSq5xTzKwVveTAx9AI3WB0yGuVK5r81XD1dKig/rhSHdRNl74RtVeDYEYFmaNc1hlfnjtfF17/UXbiix7ALGqjWs5M6RsOAi5z4CA5xgroma0Y3pzVIpfTgNSSS0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711498406; c=relaxed/simple;
	bh=ffF7Vt9WJrn2loTAODaqeRiyULZMUsEyg/eyAol/gGM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kMXFM4/RICja37ubhT7vy1O9zV33KPItCdaYUO76TIk2bey29ipEdYHpslMVt6yGGzR9eUMKk8d4EBz6rA+vg28F3XeVp6wgskbc9iDnIRHHLJdBkYC4zcyF0tr6/4WV2MJgythTIkrK9D4TVd0ZHGTq8ESGqAMnMk4e6w/Aiic=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bhr8bmg5; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=xe3tIAJa; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bhr8bmg5";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="xe3tIAJa"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42QNnmdg008836;
	Wed, 27 Mar 2024 00:13:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=yUjFmOiV06Td2fw5JB+JBdI/KrjVB2O+jLOj6dgxbLA=;
 b=bhr8bmg5VixwTLYucn7vBOUVP4naIjrS/cB8OJhemqtYkU4Y60p6nlAM2QVcE11hXAmQ
 Y4Y189CNjTFEc7WpO1RwCcrUzA9HUnU1JVVEvqjMBOm8zs/nD42HIsmA4I2/EJvnoRhw
 r0EwNR6+AHTPOwg8ZkA6i/ICtRZIfC41f1aT+ToSiL1m5zjiRIVZoSMpKBwg0CCRcLy1
 at5IieJmpO6CroxUklxAntfEIeUP7v77eTFbwQS1GNtXyDhVYbf8uEY4qv76vRlMset2
 uc1V4EFP40pTzi7+UQs+SnHTkuEUIXIdttj+l5stGd28dLyvysupPHKKnuLwhijNAwbq 8g== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x2s9gvsd4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 00:13:24 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42R05MAn020824;
	Wed, 27 Mar 2024 00:13:23 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2041.outbound.protection.outlook.com [104.47.51.41])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nhe1akw-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 00:13:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qrbf2zpvy6MrmiSdAw5CRVymsrZtbBv6ibgMeRJYCoruJ/K9s6y1k+kRJ6gEo/VhWw208NfDWzaduSWvPEP0/H5182MaRrY9+zDdUGmpDx9YmKZI0vceJL7Z64YFmpYk3PbDTmz9nfMmLGGcXnrI+VC726YAV+3uTi2/LkeLY2TU60e+x6pQdtfNOwjw+sWIu83Sjy2Fqi56up28vj/EEeowA3VVE+QTHjVzM9JBvyLoEg4jElOTKH2+5L1DweizrPE5qC1EPIi9LYgMBaOVVIHZsohQU/IFwWCf5H8pc1uUlFshVK2rcKnouzqQ3fo6hZM6nenDmrt9bXAMvF1kFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yUjFmOiV06Td2fw5JB+JBdI/KrjVB2O+jLOj6dgxbLA=;
 b=KlWK/Y0al/EVjicrdLtKp4xsyhkBrMucWjKnNT6FtpBNJDlumo8LaUMiuDl2tEErN+8dGYssEzjGOVD0GaG5OgAv3nC1e3/VIcUTFgYqOGh0sT8dB4scxsRjYSG8tWQa0DeH7sSJNbRLJXJCmWWWtcdBnM8IiE50FsjsEAcadmcgiZpXMR6jk/8jxlaGR1mw5KyCw0FSxYi1QNItUEMYRk63fFy9IBP5MRvo4727V6SF4IYn68Z1yTnL9HyLSGOWbc0mOEobru6QNBGXsTQRm/64kac9VL7hUO3azi1RkPs6+zeDLim/pHBdv+UXb1kC4UkpyTuFA1a/KQ79N6jyXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yUjFmOiV06Td2fw5JB+JBdI/KrjVB2O+jLOj6dgxbLA=;
 b=xe3tIAJazQxRFK4kDpe+0EKOs2tL3YMhDU3w9KhGRBm292XOhbBCsyNhtPRaXpS9d3S9DkN5XRzXq6QXB3vVlbBSRxNgTKkjoQMJn55vno1bClqabZCTI/CIRV/LLwipqZoDDOoza2T/E3QvxXu1mPuKsUQtcOmdRIVNsQLtByE=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BLAPR10MB4897.namprd10.prod.outlook.com (2603:10b6:208:30f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Wed, 27 Mar
 2024 00:13:20 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a%4]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 00:13:20 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 18/24] xfs: short circuit xfs_growfs_data_private() if delta is zero
Date: Tue, 26 Mar 2024 17:12:27 -0700
Message-Id: <20240327001233.51675-19-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240327001233.51675-1-catherine.hoang@oracle.com>
References: <20240327001233.51675-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR16CA0009.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::22) To BLAPR10MB5316.namprd10.prod.outlook.com
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
	cLal7pj76GhuDXD86L8+6bagcii5QMO3xjs/eNs7lTsxpS82O/lUdwwdmqwgHymkcK+VqaZjlNoPMW6yqATuTtH7hwbEm1v+zN8P360LtT+3BYcoDW7kqRpDwv9ZntZ7OQ8f/13ENUkPifAqeJEML8GrYYc/InInO6ItObg/4a0DLRvkdvDhxywAMIlLjaEc+trMFLMZm8KaXDIRR6JFNdpUFh/5ArDovpTsXDucdhZyUEaXqqBWtCnLNL5gLMTJHN2uMV85dUnyzuPrz2qVIacoMaLvWLCvVS4Hu9QUaj4OtwHPMpsuY+mfLL0MX4jROiYApxXP82rCTXzy23XFsXUPwT0qWmhSxhovT0yFMlAaItYgWPU3vLOA6K7zwwgbvhzw2Pkxwj5/04cKPdc3a3p0aUjl4bzOQWIXz+7Q8IPN/axqsjct/gnicL44hX0WjFpULTJiR550S43wHY8zCurDH0Zkd6KHwrJYiZzjDZg33dvkhrCBq2A8po4Dd/J89UGSNBqGS535NYxWYlBzuyAKJ9vbtUu7c3YC8H51ISrWKiIrwOd3gcuR9d+vgvgivPuZWjxPQOyI8mDApFwbqjIpyP15xeV1SbqV7JCmgYSvzpExB5/XohslHKr+XlCn/uvQ884qr5HoX5i/bgrbrxrAAJ5QP4OELNwyKekDWyk=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?3u9amSFASmAsVR1R8lrKsTlwiq2n1b4pKaXejXMRzOwuFE82u4PqfagJ9geo?=
 =?us-ascii?Q?pHrTqAph7ozvrjlYUDxJX21V4vE/31fXri0N+cavMaJqLUKwLUXv0DyRc1qD?=
 =?us-ascii?Q?vW72gUGwohvap/KNaLs0iQFqBfcuEMrnrnRCm1j5yDmbAas2e/bKA1U9oOH1?=
 =?us-ascii?Q?nakzpZ40G1WQ/4vL04xY8K4ya4rVtadf2vrIXHMoDzSMfCEoVbQMJNwQgiQK?=
 =?us-ascii?Q?YfOe1ygFCpxL5RUjnosfr06OUspe6ej40NC+4BegJaay//MsZtCAel3iZ7eX?=
 =?us-ascii?Q?BZQJXn5EMfOLLmEIlsLHd9p/7OFUm5sBxLo6mHS22hfLo4QCS/GUVx4h/jgU?=
 =?us-ascii?Q?ugs8GvYsLj7CXMeTvWIwBLXNxXyJwwVZXGPUCOdoXkL7AgQO9S9bzNg98XR0?=
 =?us-ascii?Q?c1IiZOjVW6QnhJxFRogaxwq+0PuksBtKhcGMDH5Z3qr8bpq/ZQMzxdQDgXCt?=
 =?us-ascii?Q?qNa0JccFZyi6QxsO/TJzWySJ0dOEzDY02I5SoXQlrHJc9c6PAoRuDFXco+yN?=
 =?us-ascii?Q?fOu93d/D7ucz4/ImT8DLPbV0EeFrcsFNci/IjyT3ih7l6/wk0lCBLwD4s7Yz?=
 =?us-ascii?Q?kCLtUNyVAv0evc8Gve78maQERRFgKXZv/cT/0ujAD7wSg4AWSDdhRrY31Tn1?=
 =?us-ascii?Q?ZgJ2uTJez5n8dIc229UNHyGJt9Gl3I70eBxQ7itWTMYOfHrap55ksRRmeMPq?=
 =?us-ascii?Q?DTU5p7mr3SaRMJ4z4SAZOwe6MDjDhmvR95h1TXJyOQPZln2/z9LifxC+15DG?=
 =?us-ascii?Q?j5ccYh7cuvgGg0Iok/32Qr2t6BW/snSRERDePQOpTQI7l98vndDJszFycBdr?=
 =?us-ascii?Q?8s/U2l4ZwAJAAMazyMhSeO6wzi6rvlAQYFKd+/Xu6/9faq8GRfpkiWj8A76i?=
 =?us-ascii?Q?KSIGdrPgkPGxASbBonuQZQDDY6JUUIp+bFrmLH51a8Bnt2cXJW+3B3Ty5Wq3?=
 =?us-ascii?Q?Lsa9t6eWA6IwNzKRF+Z23JodO7KVrcfUBaATxgcntVw5lWvLITFS/KT0xBaV?=
 =?us-ascii?Q?saa017ZGRffNv10ucW2RjhL7yJ3MidMPnBdGoSTYejPujipZyTciGgOS/lsu?=
 =?us-ascii?Q?teTyl7lKGFrY5M8aC5AKpoDWhS+AZKZRs6+8gEAPYmqyPOsaNCMBvJDN7xGZ?=
 =?us-ascii?Q?IMs1CcP7kDzy5jrlEq6oCftB1ATCM2qN9cAc7eTwdNE/NHCHR/CrToCp9Gdk?=
 =?us-ascii?Q?uFUOOwhdR/Es1/oj8wvgf2oyEEv0yUtJWZ45EHI0tjWjUM73Qm6Yf0g6BZho?=
 =?us-ascii?Q?n7rBjb64avNpJ+wAhzk17UT2qw+14IRyU7H+WX2xF/0BUo8N5FlFB7QcHHEA?=
 =?us-ascii?Q?ZMxLuQm0u+YoX7DaNb0D1rAWgoAJUR30kGN4pSA36pBrgkvI7SMZxop1MU/x?=
 =?us-ascii?Q?HoLavVvRiOuwChg24s9BdFfa8BWHKrCJR5YilKRoXVlNwOYBkYqUwJSJXDoj?=
 =?us-ascii?Q?3KEylj2K5QTXN6uQIkIwH+cqf88E+aMLnVbgYgsoCgYpkjkKwK7EKbp588uj?=
 =?us-ascii?Q?aQ5aJxETWis2QP+oixaTdubK+BV6fmgV0krv76pro2k8YgKHLOw09sjuo8hF?=
 =?us-ascii?Q?GLiIj4Tm10p0oIg4F47cCRa3ARfPAfmbay+LETiUzmxXysAcpyqE4w+OA4mB?=
 =?us-ascii?Q?O2rIgFmyRHChAJT/A+inXA/ny5xJqnhHR69vaOVGj7dX8axWfTkg7TaPQbnn?=
 =?us-ascii?Q?mSByxw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	RKrepGHi5SJrQI+1DqOQ7J2lLxI/NXXD1yJcec7TNEgLKQrci26wr5hXZOY4K3gxveSIKUrYmmIAAUsNdj7Q/QYfjFzf39Efub6sTfqFShH76gYZfkSswBRRwIMn40nBT/79Ya1L01CTmj6Kd7pxoyJ1eZzwQ+MOf7Ly7Etymo2gl2qG4uYVYGqGBzDF+J2M752tXZwUEiTvdta9Tj6RAlDAXfBDk9mkvDVFzJH+I7Jqa0uy9X9LbSpDL1RVqsx6Nus3LEUhuTnxK2Rl+uB9PFRIsEPS04SeiEsBU+a237lL71AxaoeVKiF0zo4T6XdUIQLtInZvpxvJ9i6ZohyZd2XcPl26s244i9DeWu5AhroqVgCISvZLz2jQ4N+XHw7SQBBavld6r1PehyR+HPUcoUj6+s/0wFGemAeeCHUP4gMKUFYGvucoxcc9PqCJ/HqQjf5NE5A9GZpFLU6MJ60cELIRbFg3RI3L2cmpqVHnpCs/kPAOtIR0kRBa9epVWBHLBqU4RZPpB9c3cIZl9VrlGFuk9Tznl+xB39dMTg0RP0gCkz0PRN/NRiC3OSrkLOIEmXiqH24ovnxnaFMnLg9cZh0Zr1lZlyWbcAHFK4EbSLM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb6558ca-de66-4df6-869e-08dc4df2b552
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 00:13:20.1445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8Ncf4HBN0JJzYTjG1+t/1C7gOT5jvBZQS4gtVYkFLoHu6LhnIlmfPFDSQTZIW5U47NQgEF2qATslmRW37z1Fz5U4MzBHXUjxdTq1xCeH/Fg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4897
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-26_10,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2403210000
 definitions=main-2403270000
X-Proofpoint-GUID: W4rbMeoYbvEuLZx3oYnOewVW220g6oEq
X-Proofpoint-ORIG-GUID: W4rbMeoYbvEuLZx3oYnOewVW220g6oEq

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
Acked-by: Darrick J. Wong <djwong@kernel.org>
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

