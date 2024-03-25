Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 391CD6F520
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711404507; cv=fail; b=hpF+NiVXy9HHoAG3utKWcXpdoJMhdz/YkGNMuy5Wxkpiw7EGrh9m6l8v6BaYNp+5MyMdH79pOASmbDIUE6ki2OyWKPm+xaxgx3vbyikeovNxAsCpNCsZQIxShItFfGSql4ou5o6dvhGDbJcYAT0bMTJDee9HDDI0YI6jO8wnrdQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711404507; c=relaxed/simple;
	bh=sewNhM0X2+NYmoxs9f9VMKDbDYDarP86N2hUvWM6gx0=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WXJYMFjoj8QG6ksfPoBkxTwhw01xmzK5es+Slb/uoCY3HgN2YRlH7Wt2oAmSfSZy0c2+pkMXzZMrDNZUw0gqsWJq8IMxXaBIAGh6gGtLQKCc/OxH/DXwqchz37id29yaiEJmgJshktzyipOYUBviX5v/1700roOEaIu1/Z2goN8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=o0Z+JfHk; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=aFDG7mSC; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="o0Z+JfHk";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="aFDG7mSC"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42PLFshG027120
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=V1bPPXQzSFosBx9zsf6lrRJwEcLM45nlzVo7k2Nh8wU=;
 b=o0Z+JfHkxTSqn2ERWiAiDbu9Tm7sNz6hdovHsjzvAvLS8mAGjWv0sSxG9mVl2syUG6hE
 38xGSh9RyvNIbowFUMd57eskelB/OySuxm3uaTogHqHuTorK75fkggNUNA6CCeCl9r7w
 0NVO5aiVA6ANO2KGDarDyh7TSUE1Heo0hzInzThzjPJrWCM20YFL42kyE1ikX+7LjGqJ
 y6kDDf7Kfx2SpKSJxp0/4R6C04NQ0kR8pIa9QnSJOgj3Z3N1OEhG9ETiB5dmyap/8/3r
 IRptW25G4rumGjKyGrIIO+wRfkW6F+fiMAchkMG9NqRMSJP/8DOGVAs91yed8jUPejCg BQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x1pybkqjs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:25 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42PKPhAI015960
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:24 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nh64raq-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LkUaevZKGKXV10i6jTq1FTu97/eBqhg8GOxuq8gc+huHDe4MYU2YaFfepvw+wyQPcTvpbJfU4Bp5WI66n1Nm+L80TWwNxFvEpLWJkaNcER1Cefy7GI9OMEWXEy8OwJNnM7PcLfxQPSeNv0wh7TgP3lIkoLIVZsydbeaxtctgH2NFK9CHkAvc9uDgNszuVjgoxjW9tdAQus/f02GCdxutwpH1c3NTUroMDkCgxtLHBOgviACfX3ma3eFl+GrLbU6bA7h3hCrBmI4j31uJKRZdDaPnvIpHYFXTrjpf87BHvEFwTdOT8rAxfmkGfCJqm+EJE+Y/U+L7+0aN5q3oD9aKBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V1bPPXQzSFosBx9zsf6lrRJwEcLM45nlzVo7k2Nh8wU=;
 b=oMpDSGsc1FauKgnEyt/1UpHHZWfGATHx/QlumgH0nqoPjDNoxcyWpJU+x2SqZwOBOiJP5DvEelMXBVEXcic1GLAkPE8DPq7P3+P5WUrFxXX2RxAIlRXOzvSG3cAUYWo0Db0WP11uZFfhMwYgG+NcdjBg6zuDZAKEF7SgzU+NxvDK78Fxr2BJ7Ay4CJ2988pPSwpRcKjy89WP53X/QtwEPSZGQkEWoOcv3eS4R4ekFq/4Y3k8IO1ke9ZMx3tuFQjNKWNUAUGY4MMSpclWHJ2Fk052oQX6RQm/S5krb1ToQkam5dcGrav8rhOneyfYIzUH/CYsQ/TPqC3QkLJC3SmbdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V1bPPXQzSFosBx9zsf6lrRJwEcLM45nlzVo7k2Nh8wU=;
 b=aFDG7mSCqjkQzPL6jOwSESI/QVb8uOYuyr/LQ8cejv2SmLpvqARI9zdl2XujpT31broTcNuXF/qqgWgkz0vXKevy+rU+1+7rdiJedfqBU/5qEKcY5BW2AioV/vfcm2z5CtcVGLyj4Oy5jftpZSSUogacS+Ymrsu3dtG9Jc1fQ8Q=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DS7PR10MB5005.namprd10.prod.outlook.com (2603:10b6:5:3ac::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Mon, 25 Mar
 2024 22:08:10 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a%4]) with mapi id 15.20.7409.031; Mon, 25 Mar 2024
 22:08:10 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 19/24] xfs: add lock protection when remove perag from radix tree
Date: Mon, 25 Mar 2024 15:07:19 -0700
Message-Id: <20240325220724.42216-20-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240325220724.42216-1-catherine.hoang@oracle.com>
References: <20240325220724.42216-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR03CA0036.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::49) To BLAPR10MB5316.namprd10.prod.outlook.com
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
	7/T70E78QEw+455va2HrRIfGDmz2fF7c08ZhsNCNOk35z6pDrXnOQlg7dNLrGI0OISfjVEqcDHnhNi27YvceAtnBNiGiD4DKHFjxsf/lP7dZySoR2n19zk87yxIteS28arDghPsFk0C0DzfNlUlcfMfNIIH6Cw39NNxBZRUSt7onWCKkEo5P3jrpzRBfOt4wUAS5BXy2DvVwRcf/sSjgTaYUWmAceiKzu5l/XUuUaEFO+khetdCiAkqJTjzWDcJYxMCpJ3kGNZz5ipgsGi1XKvD2cB7mbGMYQsgLeagxPlZQnrHqeh5Kck2dbYFzBTrdsOn7WHUwFI4Rw6/gn3GbkP2ITBZALrdAyU4y3VlUZ/L5r53QxdPJ/ot5psATs5fdRPHlwTuY28uOfe9brBh6drBXsB1wTXHeA7ZoW9PfVRv+CsMljm+A+vWlE+xfV+oCzIxsxGtwphNXSGaRFStNkKEVADxIjzIgVynvxx3sYsV1BjaGcWXlXMSdRNAF68za2KiV5IxokxPbeMmj+Jn42LrGEIaEjaLR3rcA7Eu5grN8HuUZWmbSi2PQLQlyroJKvdaK7V6O67eOD1nYJ9ftkfqhF2AhNKF1K0en5ajEZrc6mBHjcgFvJfNPD1qqizVYhHrIgAK0LtzuHbFXhmr/mR5e+Di07aMfaP7f/Mz2RWo=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?u157h16TkosSuVENNVf7G1xCYXkoRQjFLjWi8LhipKcmTCZ9D68EciJT83gg?=
 =?us-ascii?Q?u05J/PDGpxUflPE9hQ5P14H2mVzCVNAYq2HCLmi8HYOLimUBAZOIsNBanpmb?=
 =?us-ascii?Q?LxnGp6s56XG1pS1rUcENQD7LYA6uyZpFcFQ9r0og+p2tli9PoiwOV8/ycXfT?=
 =?us-ascii?Q?vQC3Q4hZ5QJzOkEZQRLBSpNazR0L+viMNy9ynLTwF7FFTe8xXUqQLNbfuz4N?=
 =?us-ascii?Q?CDzlK8hycKuSIzpGMIhJJaJUfdcqrp3JoiWEoqQFCw6j771fSbxyBFRRponi?=
 =?us-ascii?Q?gfJQvcU/2pS+22/95K+4jzDNkcwldQ3PDaE38UsxEtzBPNKbsx6zbZ/NtII5?=
 =?us-ascii?Q?mV+afHJTBNIFO3Tj/udj1D+aHD4GvSP1AJfql00ga2CcB8WBNxzGOFv/6ErV?=
 =?us-ascii?Q?AmY1BRJW4N57wPCwOd1foh6J39uRrZ8bJTA1ARja05SsrLKNEeruSPJMpW82?=
 =?us-ascii?Q?4fhF3E2ygfdFr0YtEadLfKm/xokQhb+NFy2Arn+m/Hr386svo9rUhrROoWsC?=
 =?us-ascii?Q?5HxgTsszNsknwnUOoCVO0VC+bLzuC1Y5QyXYSZJvNzD0iIkn9WK3iKwHnLPW?=
 =?us-ascii?Q?nm/W4cmcpqJocb7lis7ha2DmVvJyf2T4UgOksBVmetZOVMzlxqt5934VZkZW?=
 =?us-ascii?Q?zihReUwcRyVS/6j5ll9RHSlUQXJVDJMydqD/Cem8YRg68DnqftyZerIJPIlA?=
 =?us-ascii?Q?1WhnvHgenbBxX0823TQDqTS6dAtLDBo+8lnFo8t48mlxb2aMgzGrPBfy7Rfx?=
 =?us-ascii?Q?Rw+G7TEm9dSBCE0SKxXyckW77IBX2+iFvB+r4aDpb/WzA+WjQ6DqxqS/0rWa?=
 =?us-ascii?Q?6r4QRVFmEzD9THjkE8ECymZeHEm46oz2obv6PVI15nHlBzYisieoEYxUaGMJ?=
 =?us-ascii?Q?uZcBAWMz7w25gBV9lyCaMIbTuIDtdlYgqTyNMzVek/4/xfoyr9SqxzzFB9IJ?=
 =?us-ascii?Q?AgENn0NjZL70dRsUKSPU9bav0P3fr9arhle17/dfkJEyXv+gx8vluyb6MzSb?=
 =?us-ascii?Q?Hkolkg4FRcneOALpQLmY9+gfQA6OEc+ARlJCOTFvpiSpxyOJua+EDzlwJXPO?=
 =?us-ascii?Q?8g3XeuMG7X5JthpOWHrN+fbvMW2VeR1G1VAPM9S3sgWbOp/vg9ykr6N02OwU?=
 =?us-ascii?Q?NWU5Un6Ow3vgKvQIhDu4P8Ts4pR8+kkA0V3j5iZ0Oo+XxFTjF/BUwT2sEOM+?=
 =?us-ascii?Q?48cGEJspiHonbNreVGLFG6fcxD5Es2juEAH3KTIJ4KTzvdOoFZMAuP97gYJ9?=
 =?us-ascii?Q?wmgkgX0Vu2BzFtzGeKqEzL0GzusaI9q0kxoeqWX+qskkNd9SHWq0H9Sla1rS?=
 =?us-ascii?Q?XLhVwx5g4PwmcPRLd+WOPVs2pJQrvPL8QNuf5W5ApNAaZL6PSuDME1c4O1Ts?=
 =?us-ascii?Q?TP7x8KTjJI/MJY9OcOP4pTmHKJt+Tbhqjm/k/4RIrz8fSwQdC95e+rneMWFS?=
 =?us-ascii?Q?hX/yiELTNUqS1BV34iCqPu2UWbIY5G/7waMOfrKO+UioUyZPDle4yjiIDQyC?=
 =?us-ascii?Q?2eU0WqKPyEHIyxp1qv0zZ57TJUWaDjUQK3Rmv9d9cop/TuKfQ9K354Xf0gS9?=
 =?us-ascii?Q?a96b33IkspYx3lcLL2M0mZ3gSA+dykyewmjpCuGSD2qCWmoYL2BL5mhpk4t5?=
 =?us-ascii?Q?pBthj8dRjEJsFS4kDnLPnJPEd+RFyuUD7tVya2MviGP1wMEDvaTiRymu0n6J?=
 =?us-ascii?Q?j3cDzA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	AsycFwbpVUVO91l9HfZVbgdGoNhUStYniw7jdiwcsQD1KlrSP5+ryiMTBgKONdrd183iPhtuOglbYY9C2BlNGOqJyIjUy7K+JHb3Yy51qdeaDv/yxDKuXdBUiz5LsggIfTn6YTaMABbLXghE5XXZtwqq+6wek3kBTclSddHIyS85BxBJr/5FGC3ItnhmXJ+h+8FbynWjTsxZ+NajkkGaqNR2+2x3Ani4QsSEzgTkwObu4no8iTwkMUmPibiGAZUaGOX09RSMPC0C/fdnd2Y+/WMF89d0dsX/xIk/hYSaR7oYxUXC3R6CJTXv7xPvXLlebMtlsfPc2CJFq9e9iyF+XSvVtUT6dfKSxAb0XdAyjfzYvUFv07I3s4HynQZSg/jw9kdbcr0yKI2e/c3GNblIFsQj/CEZjeQJ0mCHHr1r9Fs92qIAotnt3TczwIHwmzxGwPPJryz0xvQhU6Nqxet5w5Zvsg3mR2a0yPLzxEgfXGpqkMGYuAhqJ+p5yusd8i6UkmXnAQE4n1rI+B6CcGs9rWgTKFuT+2fsznkHdrRi5hX4LjehylAfYS9I0KI3Dg7OQHUUIBNh6cV8c/me2BugnKxbz8aw3cNdYFYaPRZGV+4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68dabd47-685a-4334-b2d9-08dc4d180f0b
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2024 22:08:10.8366
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qRyxN3q+j2HwDzFhj0uScFA1POvXpS+P3+SO7f5DaY0jOR2/Bl9cO/OQQmYvwD27nS9gfQpciCbSQnRlO0k7ba6e0chkmbpR2Yle28zxU3U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5005
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-25_22,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 mlxscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403250138
X-Proofpoint-GUID: PhkU1uh2TQmjv7BGaznkxeIIc8-VsBel
X-Proofpoint-ORIG-GUID: PhkU1uh2TQmjv7BGaznkxeIIc8-VsBel

From: Long Li <leo.lilong@huawei.com>

commit 07afd3173d0c6d24a47441839a835955ec6cf0d4 upstream.

Take mp->m_perag_lock for deletions from the perag radix tree in
xfs_initialize_perag to prevent racing with tagging operations.
Lookups are fine - they are RCU protected so already deal with the
tree changing shape underneath the lookup - but tagging operations
require the tree to be stable while the tags are propagated back up
to the root.

Right now there's nothing stopping radix tree tagging from operating
while a growfs operation is progress and adding/removing new entries
into the radix tree.

Hence we can have traversals that require a stable tree occurring at
the same time we are removing unused entries from the radix tree which
causes the shape of the tree to change.

Likely this hasn't caused a problem in the past because we are only
doing append addition and removal so the active AG part of the tree
is not changing shape, but that doesn't mean it is safe. Just making
the radix tree modifications serialise against each other is obviously
correct.

Signed-off-by: Long Li <leo.lilong@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_ag.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index f9f4d694640d..cc10a3ca052f 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -424,13 +424,17 @@ xfs_initialize_perag(
 
 out_remove_pag:
 	xfs_defer_drain_free(&pag->pag_intents_drain);
+	spin_lock(&mp->m_perag_lock);
 	radix_tree_delete(&mp->m_perag_tree, index);
+	spin_unlock(&mp->m_perag_lock);
 out_free_pag:
 	kmem_free(pag);
 out_unwind_new_pags:
 	/* unwind any prior newly initialized pags */
 	for (index = first_initialised; index < agcount; index++) {
+		spin_lock(&mp->m_perag_lock);
 		pag = radix_tree_delete(&mp->m_perag_tree, index);
+		spin_unlock(&mp->m_perag_lock);
 		if (!pag)
 			break;
 		xfs_buf_hash_destroy(pag);
-- 
2.39.3

