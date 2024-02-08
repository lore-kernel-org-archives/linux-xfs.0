Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DD083C068;
	Thu,  8 Feb 2024 23:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707434466; cv=fail; b=LYAFNINt0cnt7w/PFMOQsevaRjQqPCLaLjaHSQg88LyVWO9EcDuhitTQtmjLfnb+rl02j/N1uaiwC61rxmp9NSPzvb24TKEkyhH0NJUl2RbTBymP3r5jhv7nvTsRP0yFLkWbXwoZRxVL7fHME9fCERi/kaRxsXaFy5APzEiuLSI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707434466; c=relaxed/simple;
	bh=PXksS6DlAQUuGUwTwo13bAvWsq+3wXbkvqdFmMP6O+E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=u73C9WMCdwUeTwo7SJuukNharrX7bkwpMoLl3SIlE5rwlxPzbf6vjHgNDh2nzr3R52Y7TgZCHSTKDJI1UUzH854Xw1T6v+ypNg54YEjRgfOFSi36fB0FojfTIkf5a5LyGiKr+oTKH95KVui5a9yx0VevoW0RK0D7EHwEksIsyc8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=V+Y1Ilqq; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=H3hh+KJp; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="V+Y1Ilqq";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="H3hh+KJp"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 418LSiAT015651;
	Thu, 8 Feb 2024 23:21:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=IYUoq1tO/81cw9YBO9IbQZHKer8bK1vfY88WBM4CEqg=;
 b=V+Y1IlqqfD3fNtOK2aQoYrrwmPRFIzyLm9Pg43NQJyLzma25itE6ds760dap78KhmoYq
 Jl2FUb5BKVFMW3X0ymtxIBH2bbbnXMtGaU+pkwNoyeD/WRbaBj+vwR5RHeHvL6llniE6
 M2c+Y+t22QyElHNNyLRrcmDVzunD5yXYtMKilHRp6nmnlyvgWbElSmye9m3e+ATxNp9j
 QKusoArlEXZaop3jOBY3PlMcCCjq82UNLMudzs0OBd/c9KF1sCHkQ2FatRw9PW5cpIOT
 9R3eMAeesGHnHC2pJmlMS/SIofMUFeRYqcz8Kp4Ila809CYo/PzzDaVdOjzvuNlXBZOS Iw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w1dhdp8yh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Feb 2024 23:21:02 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 418M5cfD007131;
	Thu, 8 Feb 2024 23:21:01 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3w1bxbtg4c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Feb 2024 23:21:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PL9OWH9wSgohJ2CnUrEaLsTqT0EaQdkz+SmsBpOjlD7NJqAuLOGV0O3RT+880tQa7bWinYabJRg2faGp9Zjf/GKRxHnb24fnoCrs7kRCdIqRnGN3lGauPrED4MKGtycHC4B4BTCSg5CJAllNaxbBoMhxXEg6HGr89K2VlW23mvNPZhUqlGwj6xf90UmlEJVKeL+weRm4K8SxlD7KRAX3l4Ve401xryxlDw2EJJ6C1AENSkylhHJb27B13d0bAl8zlsQxTkkM5KnvENGP9EHUX8/oLLiUSJO3jI3M1ry0uQy/B41mlSFEc7z0xUIl7ApswJzzV6yocfFioOc/vAzD2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IYUoq1tO/81cw9YBO9IbQZHKer8bK1vfY88WBM4CEqg=;
 b=LmiGYzXszLNTg4Ekjq19YJnCVb19qotxY/0CYtuUHAHAKz5VBTOnkMBKVwZnni6UdXd+2POWR8SKUI8uG3OOPSZ6CKEyK/4gv/U9HPdLdtwc51BdzePvzDWv2eeXdzepHElfXHcOqDWI6gbWtoqT7cy2IJnZzZ0ZoLWk+MxVYbBoLtTVQbeF70LYJI/U3+wsY9Vh6TJMAJpBDhqMKa49NAdShBa8JNz+Ebb6J+7rV/2QmNHZWwFUr9vDp3tBeXCho1L5wVb+JU0sfzfdo6rkUU8vsITVfjQfnMRU0+1QBE4hbbT6uUA7pcJ6o0QXltkfW6fGvGdoH9HdHGqNIYVemA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IYUoq1tO/81cw9YBO9IbQZHKer8bK1vfY88WBM4CEqg=;
 b=H3hh+KJp04i4VvEiWmwZXFZB7dyquNENbTMMsUci9ZGItkwdmLvHIYQv2qR75elaFudDgOyg4IA2J3t6PxmwgkyzvBW/6ZDxaCOL7uVBGxPD75wSv1ZHJVyPUp9VST2R2rTvi2XBpIcDia+YYUpqiCSbo85+URJeD+FRQw7l/fE=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by IA0PR10MB7255.namprd10.prod.outlook.com (2603:10b6:208:40c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.36; Thu, 8 Feb
 2024 23:21:00 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::abec:4916:93a1:2f72]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::abec:4916:93a1:2f72%6]) with mapi id 15.20.7270.024; Thu, 8 Feb 2024
 23:21:00 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 02/21] xfs: bump max fsgeom struct version
Date: Thu,  8 Feb 2024 15:20:35 -0800
Message-Id: <20240208232054.15778-3-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240208232054.15778-1-catherine.hoang@oracle.com>
References: <20240208232054.15778-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0057.namprd17.prod.outlook.com
 (2603:10b6:a03:167::34) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|IA0PR10MB7255:EE_
X-MS-Office365-Filtering-Correlation-Id: 3cd36319-63d3-4fc7-4fa2-08dc28fc9c5a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	HHSCHH6/QzKZr2DLRL66opDjzy6V8suRY57HrTC6mKNZKCFp9c1h5UYXb4chnfaPmgIT8WvAz1TnMge3B7OJyF8jRXe0EZn7PjYbzQ0S9Fk5Yijila5u3jCyABJ+t6NwppCJIBZJe6i9qycA+rAo+FD/eOxQb7XAEb+nFCvT/4cQJDl3CYGBu9KMa6yqV6T9HtH3TJOxTpc+R4ZCubuJYVSJEn0sjq4pikAULec/sc4lAYCWwgIFIYZsBwuCIS1pnCKPbbDbryTSHtDsVltfBnP3oeE8VvIvu8XDl7zMKBrVSFJBnyiCoM45av4YPYJc+dDeWNDGN8yVr5crIxMasnYe+5C8MNF20Vr8M5HYd5Cevp7QH2WkSgTptQ5UVOPnV7EGTDwoU/D+oi4kOv5QPCuK8iYXPIgwagtje2ngJGwvT3koMaNSU8hh89DToBk6NaC/B95Ij9XZRxu68+ElDV359m+MthntOE0UhBiv7CIdD6VR1tLuK+YiErwRWWOSvDGCDRrJGZrfeAxzG6W5llACW60HCTdf03+liX8YsYe7VF+V/qTsIGL8cJ0AjccV
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(366004)(396003)(376002)(346002)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(41300700001)(6506007)(4326008)(450100002)(86362001)(44832011)(8936002)(6486002)(36756003)(5660300002)(478600001)(2616005)(6512007)(1076003)(6916009)(66946007)(316002)(66556008)(66476007)(6666004)(8676002)(83380400001)(38100700002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?i2B0NT8jKXlndG5eTPiMROMge3qWunMsv0s8IZlDT7AD7pTTambg210Are28?=
 =?us-ascii?Q?vkIUhOCB/oUuiA9rK5534b1cQ/XiiFrcxZ9+DJinil2gJNc3cOLS3f3PKlbE?=
 =?us-ascii?Q?qnZMmmGssG+IoiZ4KJ3l2YwAkbiRD2AVcQvsUeULDd7LSfjFVSapYsH0q5p2?=
 =?us-ascii?Q?SkoYuhgf7Ssri9aMQMJi/zBRo2XbTztzEfWg5HyHG94g5ic82HpgvJK3QZU5?=
 =?us-ascii?Q?dkbJIt3JHOgQU1eE2F1s94HqRmQMayb8+oHZcFctn+KMesdTGRws9mJvviVk?=
 =?us-ascii?Q?xOCCruZsBeYvewTVg8jwVSMpSfM6Evk8BwT5/tB60U7jtbi2aJCIHuD1+vM8?=
 =?us-ascii?Q?+ThUhTQcpqBF3JH4nNDNxcGp3wP09sWexq22AWFxWctWc3yr6lq0t8q51Gmm?=
 =?us-ascii?Q?sV3isT0zTxSYSyBYd1tKZr171rXanvjf5/yEqY00Th6vt8XU8TwaiEXBiC6w?=
 =?us-ascii?Q?NrFEnLDSSoKk5tvfIw7YBUsvSf9jR+dltCiAtmN5WBjPrYCZQ7YKzNkZqzEK?=
 =?us-ascii?Q?Nim4rVqLRI0ekr7A9Ngcw/qWfApnx7RFIaSCV1lIKdb/ka/fHuDHB/52CXQE?=
 =?us-ascii?Q?dEa4JCIBzGv4EPJ+POT5E/RD5sYH2Fm733GowxXvkufX/gW9o7GK9/8+VphS?=
 =?us-ascii?Q?Lv4ae2nUzEch97zC1gbeer/+zr/5Qw8sdliJi3cj0kOT5giexm406Dk74wTm?=
 =?us-ascii?Q?fEcpawJ06f4kLAwHyV9LPhrOrt7CNfl9RcWgEdKzDhsA040rSrQHl40hft3d?=
 =?us-ascii?Q?HgZxB3fm3x/PdZ4R3G0UMQL8mWlpZGy6Qwejqi33A1PjYkJrsX/wfbd1jIT1?=
 =?us-ascii?Q?7//gqJsvhgFuQmINU6AAYfrWJ4MmXcWc1QeUAPd23nK7Vw4DQQ+X9+dw7BFg?=
 =?us-ascii?Q?FCi+WpJMDkOxL7nlaJjSnHK6kF6E5UQ7919opr+xSnpT++4EsfTVjULYAzlJ?=
 =?us-ascii?Q?98p0kOAc+oAk+IX9U8L23XOEMMORhvkR+GacBb7rCPu/6lqJnGSW06HexMdC?=
 =?us-ascii?Q?h/aAQADRtdzE5FggEPElZZn+DPThRWXu8trG22rBvj4rHqLcp/pPzBcbROJi?=
 =?us-ascii?Q?5slGit67jlsSH/RRtcjBMaKrDgn9mz7lYZ98efGbs8MQlXMllDsNM6u1gDv9?=
 =?us-ascii?Q?P4iHCiiWxCqSNVEmTSD0oxsfaQxtEC3rh6BxfpPdi3JC3+od5a+j6Aw8Q0iN?=
 =?us-ascii?Q?vkMQkJ6ay1vuAerxupq9WSEjBHPX7qJpkFuQWR9tUhTcRKoPwsfTnZi52csl?=
 =?us-ascii?Q?KKV4139tAuEfv45i8SjLws7slhqopEFp5Xykk9wiy1afZpHt8HmMpliFqTdi?=
 =?us-ascii?Q?wVXLLJhqIgHyr4u3gNN+gUOoHC1D59ciHsoSDFn6JwbM0nA+PJU+YjHiyMeq?=
 =?us-ascii?Q?w7+/5j2k6jUDwkC2kelHoGLDJVjlE+FegzVPzLaPYKtOAXMOkzXcFVXqKBTe?=
 =?us-ascii?Q?CBfKrHcuIKQ9dRzs3XFn63G/1zbf6WZzN2qMt/JIcIebLTFnbi33VhArFcSW?=
 =?us-ascii?Q?8iykhYpactLCaYMKvPIhYdNf9YHNqejoaFGkVa6rMGyCefiwywXaus1u0b1a?=
 =?us-ascii?Q?w4PTmhP6o3eaiB9DWkVB+6HUaR9pvXnaexxVfhc1s1OtSjsTpuNNI6eV6Ee9?=
 =?us-ascii?Q?so6sJtq23ESZUIyNrMto25j79A1WdYigtejHWIat23r5qGc+zBQm+iFQFAwZ?=
 =?us-ascii?Q?40N2vQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	H2p+W7kNoT/DuatcY6VoIgGY9qO27poscJIS67/aFEM8hM5soeA43xvjWe1OIOqhBYwzcKI8myL9Pm4jpPAJDpGrDxXvvV7zVIZ0C2491XTAcsEbmc9vCpukzPwXe96nztxxk8bqQPbK0Lje146p2paxhKToyzA2k6VMhMx/eWmbEC3yDI9reNObVnc37TXRyDlbiDnKCUVRFaADsft79ADtjo632NOTqHsa3rS99YcKKM3A/MUu7YFkHuToeie6SD0wwuk8pAZ5Sp5PnvVHwhv7u/h98H7wWVHHRIO0UagdUsy1nKeNdI+vLR9qyubhbbJJ2UmtUvkMqInU2HQ28IF371419rUY5v3huvrBG9essT42enD7CGv3G3I30uPZZPr0Q8cqP6LVMasvKKGp+sGHJGivzqOqTmXq4AgOea1BIfIVHQI4lUkfjL0Ba8Vq0OQKPTAWCiIBKg+MnnLWXt4JzXcKgcgb4GT8zNLOBq0QQs+p5IJmgCgr4msboiN7LxRfSqTA+bIHIlZlWNEG+1lFcRUZaBbCmh3gKCQrRnJY0KZ2w9eApRRGsbk1vgOSJGD5NJK2ipbMCxvTQwJR/OmYv7sMZECi7FHJspn4Yrg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cd36319-63d3-4fc7-4fa2-08dc28fc9c5a
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2024 23:21:00.1185
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kwVMVg2LNhrDZ2Wx0hVF4RHYY+kAPdJxLxShPNwKGHvQDGXjluJctyhb5xsoIxLU33rukAvPEzmCQFA+WaHwR83AfE7mRuujTycdsVVC/E0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7255
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-08_11,2024-02-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402080132
X-Proofpoint-GUID: 8RBAWFjIQA65vU3nAa7QkTp7z0K7QA9p
X-Proofpoint-ORIG-GUID: 8RBAWFjIQA65vU3nAa7QkTp7z0K7QA9p

From: "Darrick J. Wong" <djwong@kernel.org>

commit 9488062805943c2d63350d3ef9e4dc093799789a upstream.

The latest version of the fs geometry structure is v5.  Bump this
constant so that xfs_db and mkfs calls to libxfs_fs_geometry will fill
out all the fields.

IOWs, this commit is a no-op for the kernel, but will be useful for
userspace reporting in later changes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
---
 fs/xfs/libxfs/xfs_sb.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
index a5e14740ec9a..19134b23c10b 100644
--- a/fs/xfs/libxfs/xfs_sb.h
+++ b/fs/xfs/libxfs/xfs_sb.h
@@ -25,7 +25,7 @@ extern uint64_t	xfs_sb_version_to_features(struct xfs_sb *sbp);
 
 extern int	xfs_update_secondary_sbs(struct xfs_mount *mp);
 
-#define XFS_FS_GEOM_MAX_STRUCT_VER	(4)
+#define XFS_FS_GEOM_MAX_STRUCT_VER	(5)
 extern void	xfs_fs_geometry(struct xfs_mount *mp, struct xfs_fsop_geom *geo,
 				int struct_version);
 extern int	xfs_sb_read_secondary(struct xfs_mount *mp,
-- 
2.39.3

