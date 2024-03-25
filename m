Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD8D7316D
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711404508; cv=fail; b=YlgaIxbxK3FhFZ+FquOSb635KNnGE1fUTxeEppGjiJ8OFcIe4db2GxBPz07ZuLGNfKL3ruSi0OYq9UqDNYIxwEpbmPNCNp199G8mMmBOYyCyNCgXRcXLd3vb54QjtkbxgHfDHR6mU04dqBZYVjPU6w4J2mJaOt9ODJaLqQaR+Eo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711404508; c=relaxed/simple;
	bh=PYJINc2+/MvwvLqM7Od7vGWzTPyotzPQkxoL8Bk8lEA=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DnvA8QoG3Bt+qgpU7dLu29Wq4/U69eOpO95uDCuUC3rLO7GdCS98Sam7lnU2Y13XbhlCpASGctcu587S9ScN4q3De5xGAQ6cj2dOZYMPb9RBExeN5lW1uh2HkqlSBnJ0VsM8QZs+gW/KwJe8samgAD7R0lrzxvfnvD/sNLm0OMA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NmOEHQwG; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=cD+g4Yuw; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NmOEHQwG";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="cD+g4Yuw"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42PLG6CD027956
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=/9Skm2eLBDr68rjbHueLe4CImRL5YV2di35tW+qa4pQ=;
 b=NmOEHQwGI/fYo1JtFXXTlFEsoN7AtZaH6wqiuIFVBDL+MiUgcQh/g30RSOI5dLBw4zzr
 +C7xmW3MZDXs3hIh3LY9OHDejyN2vn055lmzNCXd+Hf7WBLZ+YZrf1BR80C8ngv3jt2G
 WxmeeSzEjQ7rcPh64BcucERs8eUrV19UrLlEc11qXaSBhxzC0+WO+5s2L3Zn1JlGu3vv
 3A41whU5UblLN9uIp/zhQ3zReM62JJsyIECK88N93KZx1xKD9fRCrrEdrTzlOH+vjdp2
 PIkAfkzjHw8wQgtSk1lP9w9ixU8+Jcx1LwbB7VZlDWza+tQuzDCv97q1+M41hvJGs9p2 AA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x1pybkqjw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:26 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42PKPhAK015960
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:24 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nh64raq-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fyksbNT8D8ZhE5++9zAp/lQ8sKyDlMolHaU36CqTnKeFpoRIRKN+xpedW9RwoayT2aV3lrjKOt3wJc+4xjSwFnkk8o2RbftthaGQi5l9foyuASJAcncQolEMmreABKEYqt2NjWqGlfFzmtCcaHgyJudbV26kI+wQ5IJTVPBnp1CjrCCxXh2EaheCoOeoFtn2NI4U8XZNh/Hogoa5fkhFnT/0POkvMGZXX0UCygCgi9TMuVmeFM01M23+CxAFpKUxQO9K+FcX+iTs85QKycf+/QD42Wod+GuxogBSbynUnx+7QW03KVePLl79jSwwDnVv/8XxEHtv2ovT2MCEdyOPSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/9Skm2eLBDr68rjbHueLe4CImRL5YV2di35tW+qa4pQ=;
 b=MHCynKBzbxgJCu4D40j4LMM9S1WVTceRy24GdtOS1kYA/PNNHXwZGXD7YYAw2r5shAN19nxYDj3Lx4VerkLL7/nz2Pe9OsueIaV/A1r/2XCMnAYFmBq7FPO5ddHZjsRRlSTNls6f4sqq5pwN0mkY6cYMDkQ0EuiEmQjmI1e9zlklsggPobohsRUjsfwDGd5pLYfv20sOfwVjc0DWdKkDvD/awcRIHRi1v+TzHDBnT2S5iQ1DjPluwlqxrDh63ZT9rXuzJ0HuRkJZBgySBz39/PLmcMsImGGh4+U9pQ79aJwfu+fLtX2dbJc5UtLPSGkSUjtTiBfvWzrdyCoVkrKn0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/9Skm2eLBDr68rjbHueLe4CImRL5YV2di35tW+qa4pQ=;
 b=cD+g4YuwnBjJwSJcuiCApaWOKs5LOzgdATfJy4m7qqBAwjdx3VmkChIEUZfKMVGB9Z684b67dGZmsUzpr1CoY4Zu7pYseco+p9j5RfoFS2OJdc073q6DGbIsovY/khUH09jEpQ8h6yBbSi3lii6yTilM+qQYHVtYXrsBj+r75jE=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DS7PR10MB5005.namprd10.prod.outlook.com (2603:10b6:5:3ac::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Mon, 25 Mar
 2024 22:08:14 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a%4]) with mapi id 15.20.7409.031; Mon, 25 Mar 2024
 22:08:14 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 21/24] xfs: ensure logflagsp is initialized in xfs_bmap_del_extent_real
Date: Mon, 25 Mar 2024 15:07:21 -0700
Message-Id: <20240325220724.42216-22-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240325220724.42216-1-catherine.hoang@oracle.com>
References: <20240325220724.42216-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR03CA0017.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::30) To BLAPR10MB5316.namprd10.prod.outlook.com
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
	tBwg1f/Z+Rfa3S8d3C8bbgkBxNNAZtMDj4+tjTf2jsRPwOGyQrHP6z8DuajV7fVk4KfWeNvk5FEvcl3zS/iyXjgnpmdOTr2AHeMIj63CLKknJHY1+Rea56k6UWLXiX/oBevLhzHX4XGrsgQbrC5SakUn2f34wQ4PcKUZtChnGRBRWiKB0aOFtuYB/UAt0wCRrFIi/rCkHNWwC7dnwIs3IVB+wX5zEwU1SDvwg182MIRKh9JsBk0gYgIGqAizQ57da8oVMTtBV9DN9QCFPWg8wlLa4NpMzRZ3/g28PNCooykD0V6Vr2qiE8+jAB4IlS4Cjr6PuFI9JLi2LgPon4VArNyTE4CZfGkgIdmQhErAKiULPsQd0CkgYnoV7T6isM6HcFh47749voVWabXgL5W0hfqXsRmPJDBGIx3bX6bepY1S/YbUpomD1YaNn9D80SjSfpQySlDkcJ28mLDO7EjAFd3CpfCG2OvrBO5Qj/hBjBlo1CQK6GWIBfJ0yTZ24aZKn5JpHlaMom5EeZYW6+6m6dmOFQkPCXJojPci+HHN286FF03bQHCqakU2ijYC9dSVX7pSpFXeLlbXu4JC4xkAIhLZFjZv+OEy4BChBKVT+bFVD8tgtThtfm1LAbzJ+cRA8sLOGRC2DcjlkrmjF2FBKth3CaFQRR0zuVXVhmtJixc=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?b8VFHQva1UxR1Bbbns+OTExaBWucWmvHmOIz6lOxs24J/3b7c0APvlqonx4V?=
 =?us-ascii?Q?dOqsjF/waQjAlwihxpPOeaNH7CjYh+6VPHDNytEcEp49Ebh0rdDoNVW5tMt0?=
 =?us-ascii?Q?8z3s1zGExskDFWUTzJ1rD7nfiddGrMJcaDvww5mDWd+VfxbG0oKx7XoEsASJ?=
 =?us-ascii?Q?WQwDSHeu1QgUVHohjMzl5Edt3c5Mjx9l4cCyh0jXx9kWddhafOnG/hN/LmIT?=
 =?us-ascii?Q?2eXA+udIcIN613whXd1bEkc8DyeO+vk7hiX4l2ME/zcMkCnW0XGk9r6+moky?=
 =?us-ascii?Q?H2TnG6m8daSAxLNVz01Z2WeH0VzRzS7MWc9Nrloz1ta1kd38BVjebcyQbzEE?=
 =?us-ascii?Q?QidTWlF35uMyw6D0oyT1PIvkemiv6jLMan2V6sbX8jfhxxti9Bx4CGZJ+FRu?=
 =?us-ascii?Q?KoKxz8f4UOqmS2RyGY1FmTqT88qGsfBbkuCY83roCUK6RIIRmxpn7cUUdxm6?=
 =?us-ascii?Q?0Z9QlMnjL2yf+cnJxequdR9d+b1I43GpIm2masPo6So+d7mjeXp3GNDnNR57?=
 =?us-ascii?Q?YUDM+joigZUx7DGhYTnVOL3DIzqYEytJ8DRU7tHGcsoPY/MNwpPRoN5SPnKr?=
 =?us-ascii?Q?GFHfvLGDF1VU9JINTBSn54td/Ca135DIVMmger6odaLrpI4q/Wzp/0JoOgxN?=
 =?us-ascii?Q?4cBo3/3Rd0g77XyYuGk+LxaBAsM1ljBl736xqQaB/HuOZH8StEsQzNfWbpBJ?=
 =?us-ascii?Q?TFGm459jT680RD9Wnrz35y/og6aMeL28612yEfxHQoF2Kx/p4iqNq1EJzcHU?=
 =?us-ascii?Q?Vs2x5HdfCYlNVcg6TrFad9kb1bn8ZshNzAkCl7bjvluSKaRWUzVn2EyyOBpj?=
 =?us-ascii?Q?PFwtcpjt9Ag8vuxCEW3HoAbi1tp2+zKDdWdc1X4ec5PYkcstEanpv0OuOiEw?=
 =?us-ascii?Q?/+duhzOVDgiqSWNqucSUaq7N2mNF2LgSeFv2ZUqQYlaQDYHHpLIqcL6BVux2?=
 =?us-ascii?Q?MI29jTbvpIH76vQRTPZ7/riI+tKE7SUju/PIV/mf7M4vCCmfT78rVEkhhzUa?=
 =?us-ascii?Q?G+gD99CTrzKQQ5Qow/lso+rVI9Uz+KEo8cVGjZv8LLkv/IwSICjHRqzocDby?=
 =?us-ascii?Q?RXe4XFv13mfI55fV2Q2u2oEx3z+z8m+qG/iUJR8fiHvsuqV/EHXVRq5DMFWo?=
 =?us-ascii?Q?T7wX8DdB5l8nyiMJ2V2Bu3ylWvOBJBKIenbO+vwgLmxGbX9yxdcQD/WjcyC3?=
 =?us-ascii?Q?iCkF5WXB2DPWTuWOaanzK6WHuUxBdr+036bSdKSVLbHcpePjjsr8QQw3oZU3?=
 =?us-ascii?Q?ibWxI32yLaHat9Nr6hUyr+4P8+cxdRUv8uxMtXSdEjLxD5z5eOD1IWH+5K/C?=
 =?us-ascii?Q?sKU7k6NrkhmV+Cc96IWq5LpK9I5q4bgo4+SjFEX17KOw1QKHjdJ/FB/XQ3Di?=
 =?us-ascii?Q?wg5nujTCntyHGtRVJkmveV06n0+Pa5hlZ9u9uWCRc5lu6se1TWJrHz1Xs0yS?=
 =?us-ascii?Q?Sco1YuGxouIM1P2faOOCT6FYvd4NexiwA4ryELVIaESLkwqHkN8E4IWqunXe?=
 =?us-ascii?Q?Z7OwItkzr/5CaX+RDXzL5rocRiPpRqLVbMJok8H+BwMUrXnajvoaRLPq2Zlf?=
 =?us-ascii?Q?IXcfWaTprcbX6qT4tDbzM85ZkRLq9QPQdtPR2oLhPoK3NikbmG5InjTxxfU6?=
 =?us-ascii?Q?M2ibByQRPK+C7mwy/FWjVWABOD00NX3NlqC+aMsqcPCkME4dZTIIX7GPeR50?=
 =?us-ascii?Q?XMLAgw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	MA2/Ey6WBgAuFRtNUZOJxIKnyMgJ68JC8xLDdUq9tfn/YvdN+lI8809dikRwxBqVfoJd9DAu9XxXtBCSXVUEnNewsiToGHBpzAMIEHSmsGm0QcmP+aqhxE0MIJvDbdBG780t888lmggtXeu5fJ06GWG/t2KaTPE95TToMes62lYB+qALyAacE79nBSRVWCooUtQ4cKzwD1mr4K5xnrNiiGXyHXYaZW0pld7jzDn0iuYN6i4o6Lxoop8bj3w2FPZVNGliSirkibO1dZFVfhi3E1MoBWplVmnhKJZcrvWdlZkcNnyKunFsBJmGBa+tbOdaFJIUrZ2LhHYbJ6jG2NVm1VsosmLI0AEa/YngMjvMpV14XqBeI6TNGXf75hQTcJ0n1kcSGORS5rSg8BMYYiE7/g1f255l30Fukb/CpxLJqjLA+Vl0zY5uH/G7E56nrywiKRv5mTSuFEcdvmivWhAuMcRVlsb9Di+nNUvgiEXgl+TgJiF/F4Myr5q+553KYxhgr42TB++af2BV4IHJihiaWhMGtBGRsf+LlTs5EDZwUJgXr+qRGwviCtI9EVI0pPm+WgdZnS2luxUZDBUwrajjU0vfSre7/tIy4kmaX7q9ies=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72907e9b-4c61-4091-7f2f-08dc4d181107
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2024 22:08:14.1212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C6k1WfuiM2K1WAqzvNBP4/zg6aUvf8p/EwIIbVeGgcrgVxsMRhQl6THY96CN8HYrTZhnRH55EcBeJnDMxuU5XzhuNvYtE9QYett20m9ULxs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5005
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-25_22,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 mlxscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403250138
X-Proofpoint-GUID: OuEmI4whtUHQCL-sSj8bH4dxv629RvDQ
X-Proofpoint-ORIG-GUID: OuEmI4whtUHQCL-sSj8bH4dxv629RvDQ

From: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>

commit e6af9c98cbf0164a619d95572136bfb54d482dd6 upstream.

In the case of returning -ENOSPC, ensure logflagsp is initialized by 0.
Otherwise the caller __xfs_bunmapi will set uninitialized illegal
tmp_logflags value into xfs log, which might cause unpredictable error
in the log recovery procedure.

Also, remove the flags variable and set the *logflagsp directly, so that
the code should be more robust in the long run.

Fixes: 1b24b633aafe ("xfs: move some more code into xfs_bmap_del_extent_real")
Signed-off-by: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 73 +++++++++++++++++-----------------------
 1 file changed, 31 insertions(+), 42 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index a47da8d3d1bc..48f0d0698ec4 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5014,7 +5014,6 @@ xfs_bmap_del_extent_real(
 	xfs_fileoff_t		del_endoff;	/* first offset past del */
 	int			do_fx;	/* free extent at end of routine */
 	int			error;	/* error return value */
-	int			flags = 0;/* inode logging flags */
 	struct xfs_bmbt_irec	got;	/* current extent entry */
 	xfs_fileoff_t		got_endoff;	/* first offset past got */
 	int			i;	/* temp state */
@@ -5027,6 +5026,8 @@ xfs_bmap_del_extent_real(
 	uint32_t		state = xfs_bmap_fork_to_state(whichfork);
 	struct xfs_bmbt_irec	old;
 
+	*logflagsp = 0;
+
 	mp = ip->i_mount;
 	XFS_STATS_INC(mp, xs_del_exlist);
 
@@ -5039,7 +5040,6 @@ xfs_bmap_del_extent_real(
 	ASSERT(got_endoff >= del_endoff);
 	ASSERT(!isnullstartblock(got.br_startblock));
 	qfield = 0;
-	error = 0;
 
 	/*
 	 * If it's the case where the directory code is running with no block
@@ -5055,13 +5055,13 @@ xfs_bmap_del_extent_real(
 	    del->br_startoff > got.br_startoff && del_endoff < got_endoff)
 		return -ENOSPC;
 
-	flags = XFS_ILOG_CORE;
+	*logflagsp = XFS_ILOG_CORE;
 	if (whichfork == XFS_DATA_FORK && XFS_IS_REALTIME_INODE(ip)) {
 		if (!(bflags & XFS_BMAPI_REMAP)) {
 			error = xfs_rtfree_blocks(tp, del->br_startblock,
 					del->br_blockcount);
 			if (error)
-				goto done;
+				return error;
 		}
 
 		do_fx = 0;
@@ -5076,11 +5076,9 @@ xfs_bmap_del_extent_real(
 	if (cur) {
 		error = xfs_bmbt_lookup_eq(cur, &got, &i);
 		if (error)
-			goto done;
-		if (XFS_IS_CORRUPT(mp, i != 1)) {
-			error = -EFSCORRUPTED;
-			goto done;
-		}
+			return error;
+		if (XFS_IS_CORRUPT(mp, i != 1))
+			return -EFSCORRUPTED;
 	}
 
 	if (got.br_startoff == del->br_startoff)
@@ -5097,17 +5095,15 @@ xfs_bmap_del_extent_real(
 		xfs_iext_prev(ifp, icur);
 		ifp->if_nextents--;
 
-		flags |= XFS_ILOG_CORE;
+		*logflagsp |= XFS_ILOG_CORE;
 		if (!cur) {
-			flags |= xfs_ilog_fext(whichfork);
+			*logflagsp |= xfs_ilog_fext(whichfork);
 			break;
 		}
 		if ((error = xfs_btree_delete(cur, &i)))
-			goto done;
-		if (XFS_IS_CORRUPT(mp, i != 1)) {
-			error = -EFSCORRUPTED;
-			goto done;
-		}
+			return error;
+		if (XFS_IS_CORRUPT(mp, i != 1))
+			return -EFSCORRUPTED;
 		break;
 	case BMAP_LEFT_FILLING:
 		/*
@@ -5118,12 +5114,12 @@ xfs_bmap_del_extent_real(
 		got.br_blockcount -= del->br_blockcount;
 		xfs_iext_update_extent(ip, state, icur, &got);
 		if (!cur) {
-			flags |= xfs_ilog_fext(whichfork);
+			*logflagsp |= xfs_ilog_fext(whichfork);
 			break;
 		}
 		error = xfs_bmbt_update(cur, &got);
 		if (error)
-			goto done;
+			return error;
 		break;
 	case BMAP_RIGHT_FILLING:
 		/*
@@ -5132,12 +5128,12 @@ xfs_bmap_del_extent_real(
 		got.br_blockcount -= del->br_blockcount;
 		xfs_iext_update_extent(ip, state, icur, &got);
 		if (!cur) {
-			flags |= xfs_ilog_fext(whichfork);
+			*logflagsp |= xfs_ilog_fext(whichfork);
 			break;
 		}
 		error = xfs_bmbt_update(cur, &got);
 		if (error)
-			goto done;
+			return error;
 		break;
 	case 0:
 		/*
@@ -5154,18 +5150,18 @@ xfs_bmap_del_extent_real(
 		new.br_state = got.br_state;
 		new.br_startblock = del_endblock;
 
-		flags |= XFS_ILOG_CORE;
+		*logflagsp |= XFS_ILOG_CORE;
 		if (cur) {
 			error = xfs_bmbt_update(cur, &got);
 			if (error)
-				goto done;
+				return error;
 			error = xfs_btree_increment(cur, 0, &i);
 			if (error)
-				goto done;
+				return error;
 			cur->bc_rec.b = new;
 			error = xfs_btree_insert(cur, &i);
 			if (error && error != -ENOSPC)
-				goto done;
+				return error;
 			/*
 			 * If get no-space back from btree insert, it tried a
 			 * split, and we have a zero block reservation.  Fix up
@@ -5178,33 +5174,28 @@ xfs_bmap_del_extent_real(
 				 */
 				error = xfs_bmbt_lookup_eq(cur, &got, &i);
 				if (error)
-					goto done;
-				if (XFS_IS_CORRUPT(mp, i != 1)) {
-					error = -EFSCORRUPTED;
-					goto done;
-				}
+					return error;
+				if (XFS_IS_CORRUPT(mp, i != 1))
+					return -EFSCORRUPTED;
 				/*
 				 * Update the btree record back
 				 * to the original value.
 				 */
 				error = xfs_bmbt_update(cur, &old);
 				if (error)
-					goto done;
+					return error;
 				/*
 				 * Reset the extent record back
 				 * to the original value.
 				 */
 				xfs_iext_update_extent(ip, state, icur, &old);
-				flags = 0;
-				error = -ENOSPC;
-				goto done;
-			}
-			if (XFS_IS_CORRUPT(mp, i != 1)) {
-				error = -EFSCORRUPTED;
-				goto done;
+				*logflagsp = 0;
+				return -ENOSPC;
 			}
+			if (XFS_IS_CORRUPT(mp, i != 1))
+				return -EFSCORRUPTED;
 		} else
-			flags |= xfs_ilog_fext(whichfork);
+			*logflagsp |= xfs_ilog_fext(whichfork);
 
 		ifp->if_nextents++;
 		xfs_iext_next(ifp, icur);
@@ -5228,7 +5219,7 @@ xfs_bmap_del_extent_real(
 					((bflags & XFS_BMAPI_NODISCARD) ||
 					del->br_state == XFS_EXT_UNWRITTEN));
 			if (error)
-				goto done;
+				return error;
 		}
 	}
 
@@ -5243,9 +5234,7 @@ xfs_bmap_del_extent_real(
 	if (qfield && !(bflags & XFS_BMAPI_REMAP))
 		xfs_trans_mod_dquot_byino(tp, ip, qfield, (long)-nblks);
 
-done:
-	*logflagsp = flags;
-	return error;
+	return 0;
 }
 
 /*
-- 
2.39.3

