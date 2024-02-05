Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3CA24B5A7
	for <linux-xfs@vger.kernel.org>; Mon,  5 Feb 2024 22:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707171635; cv=fail; b=K7Q+GNE8SljNmEe4rkO9YlBs+9nLPCuvSHypHb/NUQPYwYG+aV56FjWQzeOqFJRv2OjUJnGtC5nYqj2KM2stxshHGSKEg22p4jyU8CGj/ZthchSxn2LjxWM3WMiIoJeiGxuw9YJwgRdbpj8Y9Tu4EpPE6lHD1RyDXShBs8fgDz8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707171635; c=relaxed/simple;
	bh=mEraLLdjAqgQt8UqpWEOY7nP6XS/EykgEkL/tLOGET4=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=c/xU6Rbq62n+ddqoCSK8L/JiPzM0QzdBZkC+bG60IcoHOCBD4uCGujJmEKGClW+KHzIAoNC6TNn1ItaMkegjF98caKAiWtt5dl0kUk+mMBT69Ny+KlpYMac7zH73FQLlUV+NdhN3kyNz5+fZ6cx/1mOXZeDMQuIN5D8hgYl2xto=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KrVQGi1m; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Ds1HwP5G; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KrVQGi1m";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Ds1HwP5G"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 415LDt3w017346
	for <linux-xfs@vger.kernel.org>; Mon, 5 Feb 2024 22:20:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=bYI+mZNChQBgr/ucopMGIvCAUQzi4CBOh2pHbbZN/vw=;
 b=KrVQGi1m7lfyPA9/mNKw6Qxmw9GyhCO8JzldqkO5/vabCGjw+cf3t6YvcTWjtAJoe9f0
 KCX+MsQ9YwecfawEwYgaW27unTpGDtt3lbDEfU2Ut8a0jWq4Ez9NximPZVCtYPFoTjLt
 UfLEdUHP+GuAiSpdHS0MKX+jLJwBGWaDcWrER2Iu7jIP1ZRFjMPcCYDk50OXajPCcQKC
 2QHUN//0Lfi/QMmLBSxfv8gVaKl5MFoIYfd2T28x4fEMZSvxTcWtC0BdzicRzA/rb9G7
 shvYe1cvvf3WDkCpcq8WFkJjxA32le/CInsZaEJEq0dA1rKDfXs+BHWbNySkYCgJQQ2q qA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w1dhdda6d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 05 Feb 2024 22:20:32 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 415KnjNo038427
	for <linux-xfs@vger.kernel.org>; Mon, 5 Feb 2024 22:20:31 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2040.outbound.protection.outlook.com [104.47.73.40])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3w1bx6e5es-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 05 Feb 2024 22:20:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NgPPI/pllwZXwIvGPGaWUQjOPkifK9tF6cxU5bU1VBTVjmjkPWW3UsUI608e6bj/TqeaqLH7jALNkQxezdgolsaGRkwWZ21qC8+ASeWm3cfqhm6AylEPcZrmo+1ZM3Lsjb3l7imbwNHUiB8/u+f6A/pGHO/AAU+WuDqMMbwV/XQQLG/fMMMSUc+GFPGsjXvrNFZ+5PUQ/t6std2HRpzmX2yFXyN45OwMJ36w2zN80vOxM4vapZ7gBY3f/IPzYfNHAuVan0jChJZClzt+l6ryHg+yDKxcZ2jb2BxRakD2nRl7VlR7SCHM8f+cUW0phXNBcIH9MRa2OnKhsJoMs5Z34g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bYI+mZNChQBgr/ucopMGIvCAUQzi4CBOh2pHbbZN/vw=;
 b=VPEAgFgoreHjjBPlFdEcZqcamL66hguYZ4HHmY5k2B0CjX2l3dzolodHcglMWOmgbAUl42CsfElfoWOwPUEcnVr2U6SvSSFFcL3rseIgIKIoCfv2lutG3oW2oxeaWc/1bfglhdWgUsircugdgBynoX4FgJj+3bJtq+c0BpEBOD5yp/VYEyQnneIA7+J1xPr9xgu9S35I/d2gSEpljuW5g0ip+Nbw7A0HwepoaVX8pSrVPyDmv+bRMdqhUgNUgRBZnnYSx4xobbfKRREzNX5hzUz+EDljNF5G0LsQjRTtNOnbRzJH0oiUPaRnGZxQS7wZkfPGLquNnf+zajLtJF1zTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bYI+mZNChQBgr/ucopMGIvCAUQzi4CBOh2pHbbZN/vw=;
 b=Ds1HwP5GbBzbwGv5S6qBuFYBeEr1ieaYdeNiQEu9MBnvbEf9fIAIgT3FzctxqbL2cjnoxSVajMK6m915Wfp0Mq1CVpQ0QZ3Zmq6eJotOfNzKqJcsuvmFYeOBMkb99hXCbNoxpG7yK8apGFLO5p7QCVbQ63590mToc6gmRWYgYF8=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH7PR10MB6402.namprd10.prod.outlook.com (2603:10b6:510:1ac::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.34; Mon, 5 Feb
 2024 22:20:26 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f%4]) with mapi id 15.20.7249.035; Mon, 5 Feb 2024
 22:20:26 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v2 05/21] xfs: rt stubs should return negative errnos when rt disabled
Date: Mon,  5 Feb 2024 14:19:55 -0800
Message-Id: <20240205222011.95476-6-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240205222011.95476-1-catherine.hoang@oracle.com>
References: <20240205222011.95476-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0066.prod.exchangelabs.com (2603:10b6:a03:94::43)
 To BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|PH7PR10MB6402:EE_
X-MS-Office365-Filtering-Correlation-Id: 52657ea9-8cf7-4445-6024-08dc2698a784
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	kgfFoLOpPn33s8HyG6qITIOAm8XnlcKRR5nX0XVIfoAB8iwjTUnrCLR4oAsdTqDTiOAcVR7YLylqnLBDx3udmZzhygudziYZhG0FJslvikg4J00h5imry4aItN/VZja2oKciIP9IIg8YsShT+f3lYPPNkaFL5NXI/XssEkHSMWVdhXWCw+Lqj5j38IRXAJa8y12xTxgUIq9iW8pGh1uKYpb2hEOTkjVP72YndR5JU3xMWo/64NMaUjBiUWolYG14ugV0Teb5brCHo9UiwQCdtil67LURfUgWNSqJEyxKrFkVeyS1ejJL+zmoIK7YcmEo0m6Fh4o8pj8JBC29IXeVV4b9oGKPVTrxBxKeC5YIanJqiHrr08Mn3yrwtPsAah7oFCIwbaHBQJ+Gkvu1cKx5V4ClZOnOuG0fP5zvwFGn0PtfThk+UV4hUhoKmZS+LDiRYLapfxAJUyDuZ8QRn3M8ri5XXnHOZMRjSTYkrQkC4I6j/oK9jOsoeaZmhhaHBkOntlCCSH+mvg9Wxvx4BVLrlZG4evb5k8cWcIJvW/w4uo+70Bo5lt1bzgddguKTuza1
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(136003)(39860400002)(396003)(366004)(230922051799003)(1800799012)(64100799003)(186009)(451199024)(41300700001)(6666004)(316002)(36756003)(8676002)(8936002)(6486002)(66476007)(66946007)(6916009)(66556008)(44832011)(5660300002)(2906002)(38100700002)(6512007)(86362001)(2616005)(478600001)(6506007)(83380400001)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?HvFZ6rKj2BHHS6jcydZdrBIRIMEaOnkU0uUmpVLd373ex1Q5wc6Hf4KJsh5n?=
 =?us-ascii?Q?lyH83jIUE1tZZADkMMMJEQw7ITBBg5CXtwD0lwbFpehqaWDDIBpG1EmNhs5o?=
 =?us-ascii?Q?Xb9G8230uc7FSfaBqtZwFYumJITnn7tPpcIX4Ay1f1MfBbxyeEIYSb+ooGD/?=
 =?us-ascii?Q?aSaG0iIGP6hRVIin5To5pQWjKHvbQRUMMgdu2Hf1/yW5IO3A7x22qpVilUcB?=
 =?us-ascii?Q?2qpIgthe3KHXfrqoISZEFYQaM3IbGRMI0w18rHlVopdlbHS9safWNy9sGMtC?=
 =?us-ascii?Q?BdK1xKYaBOUZObV2/Dw0+Ee7P0deg6hHk9f76tFn81yjOd6R960B6jtCmvDj?=
 =?us-ascii?Q?fsuXiO28DJtZAVOWi2rI5Xt+ZZL2mkc0qx8/+mbvQp1A7zEkAZXybcUrtIYw?=
 =?us-ascii?Q?9fVtQLRWjbOceVLNhlaOLXPyq887RqyWtF1Hm5akLsUOLTFP5BR1SaL89JIb?=
 =?us-ascii?Q?Rt+Xwz60o8b4hIAPAQfD5vh3cOo8HV1TUzzI4zaFVsmoQAozF2m8Qwm25Txo?=
 =?us-ascii?Q?HdCi/RvDTyIQWoZeTVd0BX5NEJmMLl4dsNTF2XRLx8KdhfQVFC08yqTVZGvx?=
 =?us-ascii?Q?LSzUHwaz+GBETEw+rCC1EENJsWlhoxzxL+WnM7MOYEMNfeSIM/F62vD1Zv2j?=
 =?us-ascii?Q?yTss3pbIBCXLgEvkmYJlf9ihd5IcRPWE2RE1cAQKAN2uU/i4XYDFItkU38kt?=
 =?us-ascii?Q?rC9KaZHOVcZwRbEt+tkMRRbsBuU1va/JSqYCAqNsbmXo4k+ihRrpwU8TEq9E?=
 =?us-ascii?Q?3rrXk9k5qYoK71NkVUZCF14ejAvxIdwBv46DPp9m62maa1Lj5L3XUk87+K2h?=
 =?us-ascii?Q?R6NxNmh6F2SUmwMHlATJjk1IE7O09WeOBMycihVqcNSlraPq4Sr2hj9ThFNq?=
 =?us-ascii?Q?WO+mUvsp3MWDYSrLQdEKf7N9nUWxH4mj5qpbF8OsAaDqfA1cSVnw6NAuRchC?=
 =?us-ascii?Q?I/2gYkJ5crsyxt1FEFSqocF+8SFNsBM2yvCwG7daSk/1FoAroMdLJR6EZiUp?=
 =?us-ascii?Q?hPwM+uDVeg0p7v3sd0RulHGk0o7e9UmpDZNumCR4hs+585VMEi7H0xC89UKP?=
 =?us-ascii?Q?juiSvCic6zi9D5YUS8BzmZTzVdiWEvhQOuddM+i6c9EMcodXoOUhfDbJ/CQ/?=
 =?us-ascii?Q?ZYjNLk6fo7erUnESmAT0bTQquqFdX68y4uFA/vWi+9eBV0aiDDBp743q5v2X?=
 =?us-ascii?Q?FXwF8LP32c5mgYYUsLHTo3d9NW+LGAdwvQTh/QCyDAmC/lZsLnGTWzgrs7ii?=
 =?us-ascii?Q?BMZvgDVS45wSVAqClghaA7Tqd+xvtGpzMbpdQ6B2ZoqunX54RPdbuGiyZLOR?=
 =?us-ascii?Q?iJlGrLol7OyEldosfLukfNhgSVemkSnwCNadAX9SkZtxzXqcyW+4ywW4xZtc?=
 =?us-ascii?Q?ZvdlTiMcxSFlk5wntiQ/+JI0GCkqyNZTYiOcnfWxRovRoY4k19XZgfI0aOO6?=
 =?us-ascii?Q?m8g2Nw/N0G2j0Iie+bgC96Sb0Wbv8GrFnWnGFw7HII1X40hZ0Cs49JyPbPA/?=
 =?us-ascii?Q?U8sbf2P3c1BbnwpZN/5kQUFO+Z9OyZFEherYrN0hCIu55dakIZMSYcvMypuM?=
 =?us-ascii?Q?rjPPxMIPFEVf0ErPt8eHsEQFucukOXzmv5MicIb0BiQ1Ja1AfelgbHVq5aS/?=
 =?us-ascii?Q?Jpg7hh9pL1CXN96Il7ZBqnIUvUsUimtzSAt8YlNM1TiGbec+djvfanOgnpMa?=
 =?us-ascii?Q?8QC7qg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	Xd6XT/XGX6T4IE7gqbtJ/N/4cX70ZO+xvgBhdMs+mDMmV9U8SkQwMJOtYKmzLPdSiCXL+4fMwLhsc+QZIuIdGTevhX4v3iWGVzy6/vyjzMZQEQITVEW/do0/qY3GyageSNVYOi0pIa/tHdqUOP+/gkOGp2t7ddylhvFXzFX8+KJ57XKnkQ8cS9MZR7ChP8QsPVklaGsHufYjhAd5Cj/1pUafX0PGzD3jeElpOJDJJL8ZKTy1vgU2+jlKXkXTiw6cbTJiwxSHg5jBKA7WKQsOImXQkUW8o3doZabJB3EEHA7SxHo2m20cZYdIbwqbUaJcqI3T74y/+ZzBlN/203yq9pyTqD/KSfnyqZv44EalNTmaUH0wlBuDb2WF14xmnWSuNZvEs+Q3V8MuoZmBFQhX+dp44rCOmUQGUyb3hGK0JPo+6bYBuUNj/A9Jx9Dq0ejdDuX5vaGwnXmlJxc5jvwMCRLnf+1rcVBVidlZWnMjhIcuf39ruFB07GgeRNJ9sIpUkQbQ3VEGwog4lp645wJTzbzXkrzcoKzEVZxZVXa8smPxBpAsGd8jH7rPuehykhhXhkOHUyFM9gKtDk0oXtc4/iaGEH4Nf5K1ZCxXgzTddbI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52657ea9-8cf7-4445-6024-08dc2698a784
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2024 22:20:26.8806
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3SEBxNmypGrKDqTTrDLX3aJ2kMT3QNXb7XUvRYRjuhGYJU/0M+RC8FClDv65ih8CiwiCH+Ar/WQeUhsOp0P2iLXqYVGuzN6Ui6Vt3kvNS+o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6402
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-05_16,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402050168
X-Proofpoint-GUID: eFKUn-9LHBCFAlnfiNKenUPF9GLw17id
X-Proofpoint-ORIG-GUID: eFKUn-9LHBCFAlnfiNKenUPF9GLw17id

From: "Darrick J. Wong" <djwong@kernel.org>

commit c2988eb5cff75c02bc57e02c323154aa08f55b78 upstream.

When realtime support is not compiled into the kernel, these functions
should return negative errnos, not positive errnos.  While we're at it,
fix a broken macro declaration.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_rtalloc.h | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index 3b2f1b499a11..65c284e9d33e 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -141,17 +141,17 @@ int xfs_rtalloc_extent_is_free(struct xfs_mount *mp, struct xfs_trans *tp,
 			       bool *is_free);
 int xfs_rtalloc_reinit_frextents(struct xfs_mount *mp);
 #else
-# define xfs_rtallocate_extent(t,b,min,max,l,f,p,rb)    (ENOSYS)
-# define xfs_rtfree_extent(t,b,l)                       (ENOSYS)
-# define xfs_rtfree_blocks(t,rb,rl)			(ENOSYS)
-# define xfs_rtpick_extent(m,t,l,rb)                    (ENOSYS)
-# define xfs_growfs_rt(mp,in)                           (ENOSYS)
-# define xfs_rtalloc_query_range(t,l,h,f,p)             (ENOSYS)
-# define xfs_rtalloc_query_all(m,t,f,p)                 (ENOSYS)
-# define xfs_rtbuf_get(m,t,b,i,p)                       (ENOSYS)
-# define xfs_verify_rtbno(m, r)			(false)
-# define xfs_rtalloc_extent_is_free(m,t,s,l,i)          (ENOSYS)
-# define xfs_rtalloc_reinit_frextents(m)                (0)
+# define xfs_rtallocate_extent(t,b,min,max,l,f,p,rb)	(-ENOSYS)
+# define xfs_rtfree_extent(t,b,l)			(-ENOSYS)
+# define xfs_rtfree_blocks(t,rb,rl)			(-ENOSYS)
+# define xfs_rtpick_extent(m,t,l,rb)			(-ENOSYS)
+# define xfs_growfs_rt(mp,in)				(-ENOSYS)
+# define xfs_rtalloc_query_range(m,t,l,h,f,p)		(-ENOSYS)
+# define xfs_rtalloc_query_all(m,t,f,p)			(-ENOSYS)
+# define xfs_rtbuf_get(m,t,b,i,p)			(-ENOSYS)
+# define xfs_verify_rtbno(m, r)				(false)
+# define xfs_rtalloc_extent_is_free(m,t,s,l,i)		(-ENOSYS)
+# define xfs_rtalloc_reinit_frextents(m)		(0)
 static inline int		/* error */
 xfs_rtmount_init(
 	xfs_mount_t	*mp)	/* file system mount structure */
@@ -162,7 +162,7 @@ xfs_rtmount_init(
 	xfs_warn(mp, "Not built with CONFIG_XFS_RT");
 	return -ENOSYS;
 }
-# define xfs_rtmount_inodes(m)  (((mp)->m_sb.sb_rblocks == 0)? 0 : (ENOSYS))
+# define xfs_rtmount_inodes(m)  (((mp)->m_sb.sb_rblocks == 0)? 0 : (-ENOSYS))
 # define xfs_rtunmount_inodes(m)
 #endif	/* CONFIG_XFS_RT */
 
-- 
2.39.3

