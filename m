Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63C971732
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711404509; cv=fail; b=HIsVDZY2ptNy8Jg95FFMAzdCxrqfaX9ppSQhRdkQhodq59WuMxYXJp9Za66V79Xez5eRZEbxvGPltbUzLXdBdOxtC6vWvot21VAczQqPdZ+US+/a6VtzPw7529C64EG3pSum9+b8J/BdYIRq9WvEVk69ZuAh/n0/bti5UuVhqt8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711404509; c=relaxed/simple;
	bh=bVgMwrV4fQoZ6HvExvW2DESlKnaOniHWYFBtoja9M5s=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MkkRHYzydDGirHz8VUM+pqidRGBLQI2k6UjfbkqPyKdGvOXCL2U1wWDuxbjZtamYmUqG96z3qzMO7uTtBHO/bwor+tcvgzh0BtIyEl5+/xfhEw48bXx+WwD+E7ZIIb27feocLeKbx1oc2xPq8gG6BTSigwDSehO7BHpejmBq+Fg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mG4z2pLk; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=fs8zYvkj; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mG4z2pLk";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="fs8zYvkj"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42PLGF7K002390
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=b+BRZ3siabQNDqfMKyj8ZMM8RvWVZKxx0b6tsy8vVvA=;
 b=mG4z2pLkf1TpkU7H6ySTvMue9eR1n1i/5PuwlR+ULa936qDpECv4gUcQ+1ueOvuUeX4/
 Q8deB6AjrnHBnSsSdyVaI+i5bOcMJqHQIIlG+FCzEDCRW4f+qeSYg+F/p46DvN4lTZRA
 oK8FM/moeOKBU2y9R14mps50/fNWAYwMtD8cs47/RYOHCKm+7KkAbfBt1FQRBCrfjTzG
 bOoxS2wFCW0FoDuJagZMJw+O7Aa2pnLMIAZjFcpt2IUBwvF1wr3x8FauQdbg9GLfa/Ud
 AVibxFtD8IRNvSkJCx/0DHCIh2V+gsRb6JyfTYbWBDsGM1EVvf2FbiFpjFketIK07tdi 6g== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x1np2btj5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:26 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42PKPhAM015960
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:25 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nh64raq-7
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZLKO3Y7VHeZcBSvRRZf1yG5LltZWBGtP1S0AsuemusdgaoqeSDcEdGq6IYW6OfYO6hAwlzPpnAP4sBeuR/ab4vvPJe2j6DPNCer54f6vOMUHTsJy0TJBlQrJ7lyj5XZw5Qy7hRJIlRXqiWg4TfQoB7Bd/WIEWNrc+WA0bVdKQ8s6OGS/CCDe6WRFvVOjmC841q8E4UjPY2FfzkYopPR63JbShtkR07gjtAS8fuVNOuaup9UpfA3Xs9nqsfHuOBW9IKJ98R0TxDwhgZENkfLbPFblvLatkLWZbwCGn77jwJ7SllXQDR+QzuLQq9Dpx0RSq0LY6NgvDEaFBj+OuTLdJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b+BRZ3siabQNDqfMKyj8ZMM8RvWVZKxx0b6tsy8vVvA=;
 b=m19OSCvgYdm61eRnAP8XqfmKUtkIt+8po8A+MSg14iBi6eePIIbkdUS0ftj2zzA4sB1kEWb+13u83ycFLCQjTjETIESjPgknU/b+k2IB5RtemVHpQbKAlufDlGVM6CBgAhvUP9FTtn0Tz4WqNrETot17i34emG43BBikCTmCfTs0+l/6nFdSuqjql+jKjixVxmDB1zABZskTFwpWFvZTtv5+cp4KJIlPtIbclOABdyydqhWiFMWXsNfTMXAUfnsuKqnnTURm2matdFfiVaKJS7hg9opuSp+88l+8X3wTHyNhLy2eFSyTUJh89pDUDqqV0TXOo45EbL+IDVv/9TZp4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b+BRZ3siabQNDqfMKyj8ZMM8RvWVZKxx0b6tsy8vVvA=;
 b=fs8zYvkjxxWXH74jHxbCLZOFCh1ClDMSLqdiWFykfc3Z7fJYt2GHDD9wLorRmeWgiFnCp9lLcdTy6KgVeuLvW6bapt6YnhKiEB6iLqWLilMAx1cBs12yw/4hGQE9Tkm4Zf7yvWBwM3x4zlhn5Yq8blN/9KQZMPlql5YZYhA53Bs=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DS7PR10MB5005.namprd10.prod.outlook.com (2603:10b6:5:3ac::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Mon, 25 Mar
 2024 22:08:17 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a%4]) with mapi id 15.20.7409.031; Mon, 25 Mar 2024
 22:08:17 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 23/24] xfs: reset XFS_ATTR_INCOMPLETE filter on node removal
Date: Mon, 25 Mar 2024 15:07:23 -0700
Message-Id: <20240325220724.42216-24-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240325220724.42216-1-catherine.hoang@oracle.com>
References: <20240325220724.42216-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0012.namprd04.prod.outlook.com
 (2603:10b6:a03:217::17) To BLAPR10MB5316.namprd10.prod.outlook.com
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
	we3jplsu8kKmyNUWY5OPt27g11a781ZKOVeqSe/siscmBsjfbvR7beGBA80aHebaxb5/zdaZ4f7IkWvL8I/EC9kdNzidFDKRm3O1MzFRKeHmceZovtu7jMcTYrRlB9bBlpOK5ijRszXXrM64wxBda47F+yLcZcvZtzwBaeOH0dHgibSWRNFOgZk5lltAMVpyrIh3Im87StUOwgkOZNS2qWnN703BVggT1qyHc5oYHAWJS03Xf0KsQDZjSkN17VfdZcCUyVfzXF6czvoGuxfOJ3mvyMP4mxzhiTzF0JTVRUNEpi94EU6qiaqHEZ2wuBedaCaWEEii0ZZXMbJWB2vQS6+rFtP+p/VBCanp1iYFgaDZmm7QRRiVsCAqYMbczun2AFJa0jA2j+Xn8+OMVimprmdvoVfxQ7qvtDI0LIgLH5goWxCLJNUbpxk1juj7BvVD3Do94YHhKptKhbJoou2TO8JIdAymfhFDbr6rV8fobg2nz/5hfXwlioLWFyAGTb8T0AO87TP6Y2qjJu+bZXeA8Zhyv76Id+fmIzjPl/QbyKZiyarBqfJtsSYIFnvpVMKvNnjR9TF1/39YCHXt4jt5U3ArbMlTpTbYyBQnFTrthHfaoOmNgTtlM2icN2keIxg6sniFxQo7Z7CAjSlHPg8UHNPNao8bHlXesjHHvsxQ2mo=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?tPjge1jgglJvV8+JBP1tvJ5uJmKQnpc69UgNcWzHatFcDCPy8ZbTIW33kRS3?=
 =?us-ascii?Q?2uooBK4X1FX5v34mrzyh1HiBKJ09QQ14LSUiwZIIe3yMLQtN5xsaobuTD1Oo?=
 =?us-ascii?Q?w/M40tWYNCkdE6xte49qGtZRTTBHFTurvh1fZmCVO3O2PLVe2zigmJ7vdP6p?=
 =?us-ascii?Q?zpZl+ZVPQqtDC0NmJz0IahxjP4uqNGWaK5dvi027qL4eSdjFI3PIalqMm6m6?=
 =?us-ascii?Q?nvBdj362soqyE39F5SAIzY47vrdSeuJkbHJO2xX3TFvSrhaOtmc1ftnwmUbg?=
 =?us-ascii?Q?38U+NF3OQgxgrg8hkcXjQOR0RBKxrF6/49++3R8hTqnjvyThN3Z92EWp19aD?=
 =?us-ascii?Q?ZXy+//iqZWahQG8MzjAcXIrfsfJWFka6eQh/4P0MYY1qgX2yerpgcYgeHdcR?=
 =?us-ascii?Q?pRwkx9vlQVPp3nGg5cklYHf4j2Fqi7jUxqdH/GUZivxT/8Gz7uQOPiGdpmkR?=
 =?us-ascii?Q?vdZSl8Ig8vwRRucUZp+x7kEWtxwrnYyvLaBjrjE9DiadjUzu5ShzW5pUxhTJ?=
 =?us-ascii?Q?olBtyKJKDe745d+2J6CrQReBS4K6qDk5RKrioHOoDh5wBHOo1crtqRVgXLA1?=
 =?us-ascii?Q?L+aW4f4AROKm1SwAwMOF+ffSSxPJB47FWivbC1RVU+1MTgrOSqJtL26gBEWt?=
 =?us-ascii?Q?4WIiQ90R5mvj1pr4v0xDggz6251L1d160A+PGFVT+vaLhWMeZzCocxd4hSV0?=
 =?us-ascii?Q?Sa7k5AiK6RBTk7avaF+cKg+I9XbfZha19dRcb0g17vvxcBO0RisoZ2v3Odyf?=
 =?us-ascii?Q?bZxX+m51awIhyVYRizo4ptxTtrYFHwOXDRI4KBdJkhPksKT/96ETpfflp6qT?=
 =?us-ascii?Q?Ins0glTy7wmX7wD1lsZSgukunbC9NByXQxu9uYkxcQ9C45CTV8OxVVERHufA?=
 =?us-ascii?Q?rwrZNkbND7wzLizv1eob0lOMTQT2JWfNz8JFEj+Z4xbdGVbBIpHugw16wTQr?=
 =?us-ascii?Q?fSDLyednitRx/vrdUcQvAIgMV7Og/dwUeqkgxL69P0Va2jIPUxzzVCEmJRE4?=
 =?us-ascii?Q?p0sKqOSGecshRJVgPe1jGlFSZVQBbw3bY72kopVlhJ+sL6JYlTPgmOeUUfBI?=
 =?us-ascii?Q?4YTQPhRj3FCuUM66q9ep4sP+8AvY+GsCj6ROIXtWhBmtN+OK56p6rJsed5OM?=
 =?us-ascii?Q?ClxE9NbcgHNbkNf1N2oMKor5tsxDJLLwK5ZlHypCIxq6qBd1xtwSAvk84w0h?=
 =?us-ascii?Q?ZOLAEouNSE+3Uavv6/Vmq6aLCZvn8qn5t4i/LJkRENwgz/oTnYT4y/GLldQz?=
 =?us-ascii?Q?DPbgIfh7HThdHwU4fKsyqTW7VV2FU4ie4P1RoxG+oBhIP5DhZr0WV19bkSux?=
 =?us-ascii?Q?PjZ7Ii8fweTCbUGEqyb+eogG8BqH3+8+Jz47YXLDTe5A8zQqbcFmkY4uk+C2?=
 =?us-ascii?Q?BjA8Gm3dQov71XRcgNEF8t7inwHojAYsHrTJ551InCT1tN0v1D2fEMRYlOCL?=
 =?us-ascii?Q?xIZyqog5CjA8Cb+T34chrpS2gFFsDcwmBPZMMylswduWEMdjLCDA9lk47CBv?=
 =?us-ascii?Q?zpjYlRbAPUktO4BevyMNNGeJwxAcX6tvxFV2wNNY0j+2bgHnn6V8X8CeAO5l?=
 =?us-ascii?Q?RCONR2E7LUoqs0XkKpYUiinQmfempvtnAGuGYjscIlsViVxNK+fJ1/W9QREu?=
 =?us-ascii?Q?sOfTLtN151BJZvmGNfmgrnTwxtj6RC5VyYaqZyjoGwQSyCqdClxs2SVa5UOT?=
 =?us-ascii?Q?Tj/8gA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	SNA8NZDoRBn1T18l53gvI9BKcGyvbJ3IAUdV1a6pWR4JnGp+ppYvcCb8B6Gpzx6MtiwQC+Lhssfesk/EysQELbVHhn+pOyCrwSgBKEXvT1zJuJhIVFTrcZOnF9QlCzVhtdmtEMBpN4v0BC9ogYy88YrL5MF9g+NL1q9bMBk6Udx8j4PM+qgshhTf7OCec7qlLNSoJwQFwJW7UopSgtHzn/tNQ4D2G+c5uRZOyjKT76UaWFoK5ZJO0X1FjvjnWYFCl5/L2ffE6M+Lg7jk58B91pr0QlKgt4rINEflEPwKnrby9GH11bN0wCnb3o/X9ddrqHXgM3foGos/sVX3hkVwbUCa8LAJvyqfpOZFY5kZuWKEot4+RFjxr/IbCqY+0EqTyP5BcQthkpRENg3YXvhKGVhUoeMb3d5yzhdH590fnueLk2hfXzN8E/Zv0yi+lzXZsKtuNJ4XpaD3fBaL7kGuKyN2htYvK06KvsHnpo9/5/qof+4Op+jsx1HOcmTyjtBgXlnelSAfX199IIe+V99S44aDsH+iRamPE10UNnbHaciLWn08eT5+8BnsazB4pfDQpQlM5BEUOcfHWEgLKUhsPm7RJEqybeT8iaUWHMoBOVk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48f2476e-ec21-4d1a-ad25-08dc4d1812e6
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2024 22:08:17.2902
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: op8zM58x/Uiopi0Id0lyLxoFHEn3RMXYR2tqEM4qw8d093jI/YKNfkq18VNAfp+ZbJCzaLdb3yEkwIXRd5Htw1jvNrvRPrF6trQ5hu9LuYg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5005
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-25_22,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 mlxscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403250138
X-Proofpoint-GUID: L9I7xY1WTVbLZWgHWIFlEvS2Bw3zmB8H
X-Proofpoint-ORIG-GUID: L9I7xY1WTVbLZWgHWIFlEvS2Bw3zmB8H

From: Andrey Albershteyn <aalbersh@redhat.com>

commit 82ef1a5356572219f41f9123ca047259a77bd67b upstream.

In XFS_DAS_NODE_REMOVE_ATTR case, xfs_attr_mode_remove_attr() sets
filter to XFS_ATTR_INCOMPLETE. The filter is then reset in
xfs_attr_complete_op() if XFS_DA_OP_REPLACE operation is performed.

The filter is not reset though if XFS just removes the attribute
(args->value == NULL) with xfs_attr_defer_remove(). attr code goes
to XFS_DAS_DONE state.

Fix this by always resetting XFS_ATTR_INCOMPLETE filter. The replace
operation already resets this filter in anyway and others are
completed at this step hence don't need it.

Fixes: fdaf1bb3cafc ("xfs: ATTR_REPLACE algorithm with LARP enabled needs rework")
Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index e28d93d232de..32d350e97e0f 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -421,10 +421,10 @@ xfs_attr_complete_op(
 	bool			do_replace = args->op_flags & XFS_DA_OP_REPLACE;
 
 	args->op_flags &= ~XFS_DA_OP_REPLACE;
-	if (do_replace) {
-		args->attr_filter &= ~XFS_ATTR_INCOMPLETE;
+	args->attr_filter &= ~XFS_ATTR_INCOMPLETE;
+	if (do_replace)
 		return replace_state;
-	}
+
 	return XFS_DAS_DONE;
 }
 
-- 
2.39.3

