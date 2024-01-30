Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8347879950
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706658302; cv=fail; b=t0fIvgh0pGY02Lp+AQ7e2YC/zZO+d4BMTraDZINAdkGcZ2dn+BFDCSfVAmsYuZo+qe6epRQEW8E3Ag/uabFxR0YufG5FnsU+KRhnifSSMtRlWlfyTdEJ6Tvo41k3rJxtjmCy4d8G7u7y+D3bz7D1VWNr9M4jHUYhyVZze30dMxk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706658302; c=relaxed/simple;
	bh=qCuP2zIkark+CiJ9njMGUDWYFilwRgp3lPsInxk1Rk8=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XU3ebW7cnWLWrrCHZgWI3hPGyfh4xbkYVwmThI6JLlGk8PxVHm3I8QAkQWXN5oM6oR2FfWfKz99HltC7YzdxP0MIKFyZCAIZBItkpi7Cpv0uutaMCkttWuJsogzGh4XRirE/VPsMS+lxjXN5H3CNHlK60l3NkuB85mo+FKaAYE4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=V81RF560; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=BE6TNN4W; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="V81RF560";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="BE6TNN4W"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40UKxb8k021740
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:45:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=DunNBBwLHa8gbOz2awBRm1eDp6Y8GG+bO0mwHzIrvfE=;
 b=V81RF560Z2xMTVYb+csl8SEVfx+iFG3vGRTZPB7g0fR6K83ROKFIn9ZLcAtyv0pswFBj
 pFIExSCO9M50SPE4osyCqpFYk8FpoP5oCg91pxhDiCMA5Xmv+BdJ90wJAiroi0N5LwaQ
 E4YiKANv1pLpldJnDCMnTPJ4rY87s6j9R2N9+pObGCm8vgLFjENkct87pDYKdWbhahZ+
 WsBWKiv+PS8Xhi6vaJHoTfvmjG+sVxM4IzNunVVs0npfUwWnKlLFCykxC/svXt3mob39
 ZEZ9uwLwtOEvIpA1y3O9UQMztWmCmC99nKhBfeEEublBSzutFm/NyJLAIMeqQ+HGHB+y bA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvtcv0f26-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:59 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40UMcYxr014630
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:58 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr9e97w9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M1cRp41ytNCQiQ1wuKMLpX5X2pIADfbvQIpSvFnwJK2blMKxrMYAoq0DjvQ6k8BEmm7ea8PrVBvJvUSeX+6tJmk1gl6Odp/hHQ5F6wetLqJx3QBkE8gnAk3jAVZTsChBFqyo8YDSxo47HDyPizbb0oJEwM3fNSF2E9pxR9Rb3FIFgwzcy8UdyvbiJigzMOTj5MJY+9RQ/kzQU22mWxlx3l0q17WQCLmMjMxqJNQq0hYL64T8tlNpEXAhbU/xbDfh5LiGLmi7f1Qs0dGbphVCMbsOPC1vw9evrdbRt6TL0P384lcR+0NR27GJG6ZFY42MjMj6YIRagBwb5S9ZprYvIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DunNBBwLHa8gbOz2awBRm1eDp6Y8GG+bO0mwHzIrvfE=;
 b=E6tYBmJCnTRT2uXwQO920Nsy7L12W5nHnSqya/WWU1/8VNtHBFksb1KiMfu8fqefaVqf3/nvxrFQ6mpoUayv6GqjKBK0Zi9V0a4C08W8woSnIIbBuDj+RmcFH5HUunq9o0yk+opgKKwA3oLIjpZvKJ/jAuUmCtm6S1cYIx69EsZQ6YUn5Q79fSNq3ab7rBtzKQwx8Zdt0gOg1JFKr3FH1pVtzIk9a/k5yD1vnmXx73xngf5HToB7vmNMlk+g4QGk8C9RWB4hNL2UribE4vAGYQqK8dHzrX3/EWPCtID7q90xgGLWg5Mhfbsj74HY6TC/vufMyPxLWBBrxj8bJsAdHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DunNBBwLHa8gbOz2awBRm1eDp6Y8GG+bO0mwHzIrvfE=;
 b=BE6TNN4WUEeLppibPXFNpOpq5y0TChpOYMr+IeXOmmi0WQrk5n9VB5rpoI1fJBdOrocKDFnIYLk8LofJlhleXmZzN/lTB2z0CXFU2tC2rqKoLNZn6cikaDAdUb635f2s5GWXwRnRJGZBYbkJaR5C5uRei8BFdVdv63dXqxhj6Tg=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BL3PR10MB6092.namprd10.prod.outlook.com (2603:10b6:208:3b8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.34; Tue, 30 Jan
 2024 23:44:56 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f%4]) with mapi id 15.20.7249.017; Tue, 30 Jan 2024
 23:44:56 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v1 17/21] xfs: clean up dqblk extraction
Date: Tue, 30 Jan 2024 15:44:15 -0800
Message-Id: <20240130234419.45896-18-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240130234419.45896-1-catherine.hoang@oracle.com>
References: <20240130234419.45896-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0073.namprd07.prod.outlook.com
 (2603:10b6:510:f::18) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|BL3PR10MB6092:EE_
X-MS-Office365-Filtering-Correlation-Id: 873fd8b1-e7cd-4bdd-8467-08dc21ed76b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	ADK0LXgdhRq0BcbImPr2Dfyj0vW799gM3IssuyQ5wEusAUwIeQELlwQn7ANnDOcw81txlfWHQDGGsBF0cvyzxtpXBG3UBLac9/gOxR3Wd+qa76J8SvNyRxxy0s9C0RrfwqxMX9m4xZgUx1a1clFGH18tZLvC78tjF+9/JaCDjBLG80xyQUgnc0CDNo/Ycj6oR905Pf8x0UmjkH5PMb8Tlksltuj01QBHiyeGP/BNPh5QBQ4ARrg0mg0GtGASvH05VNsR1Laa9rYRwlX7VXhGHry1q1DSMSVxmxK6jLrHGAPrUQ8ewo6QVuV5RFZhoGFvJapq0BXtJDgmxnW4vNjOQdZjiUaeAVPlDfDp1tDMan0Jf5LEad3RC6glNqE6g34E25N0Z/Cmkcs909P0eiA1mVgQfHgwTIfdJw23nhsRQCIl4zdmYS9g4BSp1FpAYf8lqASrp4dKT5P+IBfx69wYJjR8fn8KMCw2kjlyn2AWwOoS7PnBHffOtoqojjXF/OM0UZ+oQMUMoPIcaDP+8adddJiCcaWQ+lHwPcto0eH5eZ1+vdEa2Z1KSnrWnLh4jncm
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39860400002)(376002)(346002)(136003)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(41300700001)(8936002)(36756003)(86362001)(66476007)(38100700002)(478600001)(2616005)(83380400001)(1076003)(6512007)(66556008)(66946007)(6486002)(316002)(6916009)(6666004)(6506007)(8676002)(5660300002)(44832011)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?McF8Ph+WcdmHbXi2xRfZkO3KXt3QsuPnQzB8frb+zrxUohD5jsyCh0c1swuy?=
 =?us-ascii?Q?nbKjkusz8K4cfvY4GuKOWplC/FoR/QwMzTCJ5Ue4DQHsdpN+cObHLpjX8FVy?=
 =?us-ascii?Q?4kzXFCscmRU/4IPHOlwXRvxR5hVvOr21YoxirOpjzsfDa2aKFgAmRMlNxL6y?=
 =?us-ascii?Q?wCN22CkCI0oVhCjN6VPoVNqMYeL3c/izf5idjxgBMMuxB+iXz3/RDV6gBjxG?=
 =?us-ascii?Q?dSQeDx8VWEeOcXrHvNlD4X40ILQmNuGDaJf/FrLShqnO583eVEHBQHkSXz2J?=
 =?us-ascii?Q?+65x3jJfwrBs46nPhVQmCY0Xu/bYSj9sr6QuVSCq+9LHZtAb4/4VCffZZu0d?=
 =?us-ascii?Q?bReThejbq6Orvr2ga4N+v44xhqDmfWKWBA3FSNQFL+EYiKwCyd2wyn8ixBN5?=
 =?us-ascii?Q?gIC+MPXDKR6aJdT0vevuobQanyy2OvPHXrUX0O2oIOk5tJJ3jGkasTlr4Ozi?=
 =?us-ascii?Q?215i/CLXggxlyCLBj+xM2WnSjZ0ZKu9gbrTP9z8Qcq384L2BZ7xQ7R/L8+Kh?=
 =?us-ascii?Q?LXkPpm6slrlnO8UZSz7ZrmQzRnr1f5kqez3/eY2YlOp+NrYV12K0druWAn68?=
 =?us-ascii?Q?20oNdvHLKN7ukR1g6Vxyh9tzzryumgRONZruAci0JnPt0DrPmnfkCpB8m1W+?=
 =?us-ascii?Q?WM5O5uT9IsY5SLi97CCpUf1EKxH1vBLyTLgqgw2da6HeA8yoX67rHYPG531Z?=
 =?us-ascii?Q?nsug/p83SQClqAPuL3D8oaXC+4P1qvK60SyRtVdvPEQmhwMbdYbtidnkvAoA?=
 =?us-ascii?Q?DLWNPuBFA8KyIcphTPczKU9H+rF6ySW1hlBF7NFV63sN7vJiF3uDuMFD//y1?=
 =?us-ascii?Q?uV5FsCsug0ftdddQjja0ESLfEEpPxens6JGI/SsKhmiS6GLRy5+KfqWPyL88?=
 =?us-ascii?Q?p3N6sEWgPRkySNr2ztw+cz+CP0NzpAX33yCj+RmIn4HO1Vm/JkKs/A9UMLVT?=
 =?us-ascii?Q?dvCmytsJTegxOO6tRAurzaT1z1X+szTsj5XmdpaF5QjOQQ+Y9clhsfsZtmYg?=
 =?us-ascii?Q?z7Wzw1CnlBRl2MrfkgnJE02wqaHdypmdAyCaPjCypfTbu/rtr3gIarezQ6OS?=
 =?us-ascii?Q?ed29F4uRlWcxVe39H1SRsZUGOUZM0ZP23dUbpQoQjj34DFsGZCnREQ6oJ0L6?=
 =?us-ascii?Q?lhb0nkvXWflVyNsnkfB5Egt8N84JOKaGIb/ZvcVoAT4gMFQ0w4/89LKdu3EY?=
 =?us-ascii?Q?QgHEmQihUw7lRrFFNhlGl5PFr0nrvhDwUHdmStaQBW+wGx3S3IH85IBQRT0R?=
 =?us-ascii?Q?erhBy33MgEDKECWFEYRlaHyko4z3i4m85hgPE/KD6XAEfrVumMTdh0zboIpl?=
 =?us-ascii?Q?I6xjSpOwmaoDXmhVzrwfkSd3b65MJMu2/+hAR8BmeDpdQsizI5AFmJCtOaz5?=
 =?us-ascii?Q?ysQyjJWAux5DS7EruIyDkCcke0R7rMXegWARYZURl6iRRtsZQMWgSYPnkUVW?=
 =?us-ascii?Q?0xVgAJ8CWbYHz4ehlUDC+lD0mY3WvHrjXfarPknYM+LXNF3FfvWOA3YSsTca?=
 =?us-ascii?Q?hzpYjDTYg3dk8ly8PO3hg+mrButPVa80E3430uGe1Opfkz7MU9ZjGqAX19Oi?=
 =?us-ascii?Q?i2tS731mmclFBBu3DhEzmDqOIdARqACBzZD54kNiBy//2SBztkQU+yXjia8R?=
 =?us-ascii?Q?Tmg/BJOQZoFigevpE4DCGGxlFH3EWg/yqXxUJmk8iZzx8gcNCJNFHTeAlUfQ?=
 =?us-ascii?Q?Tw/ySA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	nsrKi7LHccgNT3DvyFIpNN7TDRHbV1g4swDloNIfEkhjh9Udq2rM1XERHiaGqXIGD3tHrTyfg4qdoR0O9w/RVJpWeOwaRtmBGhcYwlQ3/JMTpUvauKCAZqt9Gy3QNsjcRvff7OvOEU1pmaA3GtcmsHi7seuV0AqK9Ouj165Q2qBaenc6rMmprdgc+oTYymZwa3vftpDuDtMnOhHqpCwN5F82yq5svsNc4QLlKJEpG0B+l7J0Cp17zYm4g6wCfxxKy1tztDP6qhDOCnMatAiEQonLhOnboXfyYp1QrNCPvXg0Bo/SS0zhEwy4LJyNUxUlyk+F0/uVIZVkY7fEsVEQECFuJMNSo+yWHzKC8C3Y7U0mVBQkJNTFPzagHq66fZJ3+fpL+/uQfXF/KbKmn7eAzuj8NowRwVyDAvCC0BYPX/QVsmZRyiSMK/aIw1YptfWsDLM2dQZXRf8hDXBbrEu22Wy75MPLeC81du3AvFBCKs+8ra99Y597g4qeC8XfSJNEhhW+rOkMyXsM5L3LgnWpOb0NmniF1AnyidVJlmQp38CotISWilCcpCa3RPLQ8Ce40weF3Pc5aiQ+TRqYNOqWfUuJRqod5YVKppNh1OtpUKM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 873fd8b1-e7cd-4bdd-8467-08dc21ed76b4
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2024 23:44:56.3229
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ivTzY5G9TeRuqba7wo/t/oH5AiOKLqZR/GGttEuwfbjDR/vp41kFPBG8Mb/jx1stCGg9Txc/F2yLk5HqHLUa7mJOSgC+G5TqctsMq01YJ48=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6092
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-30_12,2024-01-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 malwarescore=0 suspectscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401300179
X-Proofpoint-ORIG-GUID: 7CLj6QAWzBCRztWc-y-rY256UX5k7OJd
X-Proofpoint-GUID: 7CLj6QAWzBCRztWc-y-rY256UX5k7OJd

From: "Darrick J. Wong" <djwong@kernel.org>

commit ed17f7da5f0c8b65b7b5f7c98beb0aadbc0546ee upstream.

Since the introduction of xfs_dqblk in V5, xfs really ought to find the
dqblk pointer from the dquot buffer, then compute the xfs_disk_dquot
pointer from the dqblk pointer.  Fix the open-coded xfs_buf_offset calls
and do the type checking in the correct order.

Note that this has made no practical difference since the start of the
xfs_disk_dquot is coincident with the start of the xfs_dqblk.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_dquot.c              | 5 +++--
 fs/xfs/xfs_dquot_item_recover.c | 7 ++++---
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index ac6ba646624d..a013b87ab8d5 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -562,7 +562,8 @@ xfs_dquot_from_disk(
 	struct xfs_dquot	*dqp,
 	struct xfs_buf		*bp)
 {
-	struct xfs_disk_dquot	*ddqp = bp->b_addr + dqp->q_bufoffset;
+	struct xfs_dqblk	*dqb = xfs_buf_offset(bp, dqp->q_bufoffset);
+	struct xfs_disk_dquot	*ddqp = &dqb->dd_diskdq;
 
 	/*
 	 * Ensure that we got the type and ID we were looking for.
@@ -1250,7 +1251,7 @@ xfs_qm_dqflush(
 	}
 
 	/* Flush the incore dquot to the ondisk buffer. */
-	dqblk = bp->b_addr + dqp->q_bufoffset;
+	dqblk = xfs_buf_offset(bp, dqp->q_bufoffset);
 	xfs_dquot_to_disk(&dqblk->dd_diskdq, dqp);
 
 	/*
diff --git a/fs/xfs/xfs_dquot_item_recover.c b/fs/xfs/xfs_dquot_item_recover.c
index 8966ba842395..db2cb5e4197b 100644
--- a/fs/xfs/xfs_dquot_item_recover.c
+++ b/fs/xfs/xfs_dquot_item_recover.c
@@ -65,6 +65,7 @@ xlog_recover_dquot_commit_pass2(
 {
 	struct xfs_mount		*mp = log->l_mp;
 	struct xfs_buf			*bp;
+	struct xfs_dqblk		*dqb;
 	struct xfs_disk_dquot		*ddq, *recddq;
 	struct xfs_dq_logformat		*dq_f;
 	xfs_failaddr_t			fa;
@@ -130,14 +131,14 @@ xlog_recover_dquot_commit_pass2(
 		return error;
 
 	ASSERT(bp);
-	ddq = xfs_buf_offset(bp, dq_f->qlf_boffset);
+	dqb = xfs_buf_offset(bp, dq_f->qlf_boffset);
+	ddq = &dqb->dd_diskdq;
 
 	/*
 	 * If the dquot has an LSN in it, recover the dquot only if it's less
 	 * than the lsn of the transaction we are replaying.
 	 */
 	if (xfs_has_crc(mp)) {
-		struct xfs_dqblk *dqb = (struct xfs_dqblk *)ddq;
 		xfs_lsn_t	lsn = be64_to_cpu(dqb->dd_lsn);
 
 		if (lsn && lsn != -1 && XFS_LSN_CMP(lsn, current_lsn) >= 0) {
@@ -147,7 +148,7 @@ xlog_recover_dquot_commit_pass2(
 
 	memcpy(ddq, recddq, item->ri_buf[1].i_len);
 	if (xfs_has_crc(mp)) {
-		xfs_update_cksum((char *)ddq, sizeof(struct xfs_dqblk),
+		xfs_update_cksum((char *)dqb, sizeof(struct xfs_dqblk),
 				 XFS_DQUOT_CRC_OFF);
 	}
 
-- 
2.39.3

