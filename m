Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4EBF4D9E4
	for <linux-xfs@vger.kernel.org>; Mon,  5 Feb 2024 22:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707171648; cv=fail; b=u9/oXw0CAPnDlwt4R5nh7dr4s3yfxEz1AXXdCuW/++P4peBrOUE3sEnG44MV6KZabsF+4eu5e4i3H9L2qcJwj70kozB395ymhTn0spSrXPRNDXPA1aFaxyZ334mQTQEjpHmJUBuslQDWiGcEYoHt2zuzOvNqeeACRsgvp7gMcNA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707171648; c=relaxed/simple;
	bh=FfGCslGG52T4ySOOOLSL19+i5snGO4w1YfMvs7VtihU=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LP0lZkKN24Mv/TG/tYQ8u98IIuMJH91MK97LJ3fRssvlt2HGiSWNCLNH80xgpuP3zuN5R9pTHC8fm+uuqag04P4zjn1lEdeAdI2oTUp6LlU0UDnrt+q/c8D+BDQlXSHDQpFmtQ3X76zecuSbBDKObJh6aGxqI9+lz2ObqSSa5ww=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KgOXkZbW; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=fcM2zd9y; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KgOXkZbW";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="fcM2zd9y"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 415LFncb018432
	for <linux-xfs@vger.kernel.org>; Mon, 5 Feb 2024 22:20:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=SpuJ2ko1Ml0rNMMvgSg/q5UB5W9Vmf/u4ej6IV6Vq8s=;
 b=KgOXkZbWcIKoW7LrhYSRVHXseum82ZiST1MG0x6R9b5me4U4/LKnuixL/Aw4dTfCLH3g
 DPsgZ9D5U2ynkKfDNvSuVsZzPYKj68JeNeV8nJhnfPPnD0X6iRoX6LvKE5N/usyYhQgz
 LcY7gpNrDTdqNmcrMtmQnYYyhOrLEw7uP94WX7JhKwDXoveg32fs42hpbcF6lczebnDZ
 kozrTGDKsnW5KoftAK5C26iGGlOw//QZYUjQb6yNxsTzW8OtV2KS8n7Y7XpiH2OH9nDY
 +74Ed9z6neJlzn7P5Q0+KJ+m9Z0pCSzL8myrrPpTQTkCLL/h15Ouigtq6RRm8sBMoDMp pA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w1cdcw9nu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 05 Feb 2024 22:20:46 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 415LeVfL038353
	for <linux-xfs@vger.kernel.org>; Mon, 5 Feb 2024 22:20:44 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3w1bx66vwa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 05 Feb 2024 22:20:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A968rvUorhCj8MxJY6YIH2pxEod/U1jmzbfjPq2zi7dasIqzJ52BJsBqVBu7mtXDLImga4fD+z3hiKKaSteEeDxp0e1Vzukv6XnxJXIYNGfLDOIrNcDsmjgT6x0iOesletIgrQzjvBr+S7tJvJQyW7OFrd4Ifam4r6pj03DJd/L7bjIEy9vT3BCosh7HDZ1oHWZ+o8DYTpPx6xGPjD/tb45DF1cZ+rqUedNFwSPeRiJo5Bbmq1KZALUX5jxTYpTK82c4u9ZfxZj1BalV0Nr7L60pxZWoDd7AmZzRIyBhmdh8PSnBgXIYkxdoDwkWFKm+d1RN3P2lVcu4IdN8SdT94g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SpuJ2ko1Ml0rNMMvgSg/q5UB5W9Vmf/u4ej6IV6Vq8s=;
 b=a7UPITWv1BoD0dj5a8PbXMeYINnK2KOfRv8jLw2ZgubnJLTs2ZyFTCiukJ4HUhxqOboa4z4rl/wHZRBxBfUKZEJDix8JFEziBDW4I7pr8gWY2MyMvfxivQrNfBZ+IqmZDnFvl6rPhLFmSp4Os3KpNh1EuxWQnnOwgd2MzPqiJAZcNqTVk6946fO/0Lu3raZa2kL8/dO/okFeTgW38UJKe/q74oZQE9vs0+xschkxMVCX+WSZoydaOHcdcrBRajBJVZTPbVcUyPrh26ARblClQdRRlJhRjI991ZUr83zDv005lLr3ctqt7bWWtZDrV85Wt04rUvIGOHoUN7KL9rmnfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SpuJ2ko1Ml0rNMMvgSg/q5UB5W9Vmf/u4ej6IV6Vq8s=;
 b=fcM2zd9y9LpP4wN3/B+uhInZjSeoyCc81DHkmHPEQqwW6QAMBqhD3wkwiotJIpcWpJdHpcNBGdrIjlExXfl/NbYTUaP89SYMctzyTqgd+KgBL4bujFl+0VHoHZSOM8gzJr/8dnaTpfWmljPCJKpJEiDKUKJ3nQ5FBino53kyF5Y=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BY5PR10MB4164.namprd10.prod.outlook.com (2603:10b6:a03:210::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.34; Mon, 5 Feb
 2024 22:20:42 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f%4]) with mapi id 15.20.7249.035; Mon, 5 Feb 2024
 22:20:42 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v2 12/21] xfs: abort intent items when recovery intents fail
Date: Mon,  5 Feb 2024 14:20:02 -0800
Message-Id: <20240205222011.95476-13-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240205222011.95476-1-catherine.hoang@oracle.com>
References: <20240205222011.95476-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0023.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::36) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|BY5PR10MB4164:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a447e2b-1576-439a-6350-08dc2698b0cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	EWF/kDVjnfxycizgQXhAq90FtafHYzWrpYLfzg5SKB6Iginl4Aaz+V9Fi4pBR5SyXCYdmA5dReHjPdtg2TDaCIcJhFBkGeF6AZFLvRlbJXp0f/2ErQEOzbt2CEk+b3hygKZbrZHuXUZ8cRwqX/EhezE+AW4lftBNZr2juoohcdt+2/gch435xNjR/AoEkakw1u/Q/HhfkVLW3pVkQiGXyBZJB2XiBcXsDYPPPCzEtQt+h25aYXn5SCAt0mGpp5rhOgy/JcyR8GT6jP42Kcb8AD0C98iMO+TqXsvK9UUxnjbwDgPjOOaJ22VY9ipecVmhJgXU+66UXKeQp9fEUe3dv7O/NeEb6RxpGVIPzRsOxhdB4MkE3E53qZt/UiseOtI2NCyKlqMwC4JvszXESzIjAVqHP4TjifTgxh3xl0czfdx6TdcTDaC/hiR5vXWbWPlys0RiiMsoH1Us9OM/NotCUlE6ZdkDOdDCMWIBvsg1Hr9zFUYPh4/dDTo6vnDEv9y3tl3iBzAZ81uDyYX4uXyLVA23WeK3NoEz+/YIbauSSUpMDm+8otLFycUgUs9rXbPk
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(346002)(396003)(39860400002)(376002)(230922051799003)(186009)(451199024)(1800799012)(64100799003)(41300700001)(316002)(66556008)(66946007)(6916009)(66476007)(86362001)(6506007)(36756003)(6666004)(478600001)(6486002)(44832011)(8676002)(83380400001)(38100700002)(8936002)(1076003)(2616005)(6512007)(2906002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?DO53dFbCcg7die58zhs8dAR3Kp/xCkUyhbRmevNP+2usiSm/No6lZ0FnWj8Q?=
 =?us-ascii?Q?rZU9AuzjDg3+atzJRsJ/3H39gZLcmyAv51jWwyAU3/BH3/5kjRDAPqb6jjfy?=
 =?us-ascii?Q?w1GJ1H4CMUlvkYvc3E54XAHbOGwIqLuWmELGbujEFDSZs3445yc0UEqQGogJ?=
 =?us-ascii?Q?+lwQdTkc5lCBG/L6cTqAaqx6P6jWFgTfFS5iCCTyo9Bscx/bkECVC2GAWVc8?=
 =?us-ascii?Q?SRohJLIbCZE1zr3ExUCvHhzOTlYNcwq0ulcNycli8zbr+/8cf7pPoOPvmutF?=
 =?us-ascii?Q?CHVsdHka/e+nF8pC02EZ4a3bbj8TI0fy3xG/aakJ1JBLIpM9nQl7WFMBc86b?=
 =?us-ascii?Q?7tAyRSZwyaJQtKURCBd7P0jfviWeGe1nVRXJjOQGa9WoQEPfBjYKjDXbtx9O?=
 =?us-ascii?Q?74rm6do15AGzuW+FDtQ/QKvW6dkNt6081lXdQoK9gB0FMuJmaS8exGpfUCLQ?=
 =?us-ascii?Q?/6f1asXHHcf6ZEx83OD/JVGf6XnSgG90oRO8Q2rW2DofIkwwZg8+3bB23TCv?=
 =?us-ascii?Q?0zEnxzsRkXErZ3lrtuFClDCOZNvv8V5xIMaDiuKG8tXndgIiUikThWbUL/hT?=
 =?us-ascii?Q?oXbls49NFOK7HB1byUdSEdcQyBU3N7BHNZqHbt1gSBzxoQNl3SA2ZMFwmV4B?=
 =?us-ascii?Q?ylhl57jhgl0ZPYNjSn5t3lQPyTocpt5poAr7QvnZrLxh+PVb/GG+DsQvQUsy?=
 =?us-ascii?Q?sK7lsn+ODRHxOo2javMA6PqiwOPI3XrNHAGm4TOhCs0UoBgAzf/+9ty/MGjO?=
 =?us-ascii?Q?+8WjaLeEKsNaC6gj94jbMuidT4VeMrk2NqMo+Wi3eAzSA0v54vTVt0wj25rC?=
 =?us-ascii?Q?RIVNPwer2kRBK///LolG/r7T2lcY0ME1zW59VZzC3bYqQKnsLQjUpCodQYxH?=
 =?us-ascii?Q?k6HOQ+Ud/Msvu21EMIY3evTqUqGkQeG7BH3uOpao1FB7AhvITeNVKjU9lx1x?=
 =?us-ascii?Q?0d09isAvTwVlRrbo6UEfkrVnQJoJMkjU96oPbuo3tYcFuJVy8hjVXDwe+ZA1?=
 =?us-ascii?Q?NAv2+qKaT8PcZZ9ROoMmm7w/4CpRubAYiGZQdbYdzV16iydGpfUNlPhrImZu?=
 =?us-ascii?Q?nZwZw1x+QD4zsAcTlFby52icdWFhKJOOSXWe7UzrGhvVEmJFry/sAXJqG8Wt?=
 =?us-ascii?Q?bL1nfdV4pRJlbpwekYkjbz8a9w9zYLXR2fzRbdHUdpEaOsSYRUq3AjQBCdjs?=
 =?us-ascii?Q?hhU8JrlpfS6w94hjXLG77vF6Ng99+/YiRgN3zrKFPdz4ADjLS8+JtGYT/A2F?=
 =?us-ascii?Q?/YebKSmyYWeWOo2Pm7nozpcqjEtDsEs4fj/2s0hJ5Af7Spd8oRFUzrYXzELM?=
 =?us-ascii?Q?qqupmfb2O0ZKNcTxG9q8Q6Z+ReylXntUBF6IHEGJze0DlTJBZ63YuzSYXFXn?=
 =?us-ascii?Q?EpoknYO/EjI/ohrpnKweMO5FSPu2WYkginrdNdtjJ16dYQGPtpKYy8x0/LKw?=
 =?us-ascii?Q?1PW5XYxjSzXHMUjqJn59hADFuyunWz/025q9sauKc0flMMLHnUjQSG68ARxi?=
 =?us-ascii?Q?YJGrvUoKUl8Tqmh9S4hMnvGtc09uf/LPM1I2LgRbhV3ymgcL4p/sKsZ22QgS?=
 =?us-ascii?Q?gLZS3Tf4qwR/gkphrwhPohr0guq58eTqrqIwKlKbh9f0T8+Pzn2zfOs2f4P4?=
 =?us-ascii?Q?o3jz42XP+pPujTmricZXd23bADSPdvJExmrkW14jh5/sVPnzHXFQCNhXZYRF?=
 =?us-ascii?Q?POkqKQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	25vP6S4VOnqcfriN8hVC5OJ9k3tVfAlXyDmFnX+EDKlnd3RKBgYkiDk7sKczOFsNLM6Ok9jUn4r1yv8dVsByHylSehBvHpE70OmrlMr6gPqSwQeem3Ao2Q1Vo54J94yNNSkNUQ/C4uHk8nMsucYC5fCDAxtt6ItNqMDhTck1jQ1+QF3YnnrXBS9zFjMz+CZ+REz274aMTBlGQGPcritYsyLXBM96stGsVFGj1KMrZZky54KUUP4nyZuy8R18bq6gc+IGg1vco43x+xVloPWGJ2B4kC3yY8wTalZDnNgkv0RWNjT5IW31KaFdZVTLUfKBoiTC1aOUKeT4oVs1Y7831VrYduaiybET1/48t9t8qw8yFxhwaD3E1tOEQyWOdgcqfsZ5WLD0fX5/rwb/XwUEP/kEAVPLDCGv+0749Y3b1woe28fXPLnfn62VNZaG0uVzU9L64UKiUKRrJTVTrQ4VnPoNRLPvIC6h1Q5tcyjwnV52+qde/EZWU50+w3StpkLLGubQBKl5lOE6vL2hLt6TUKx0M3bO+xO0asHwoXBX9xyXkd2yzNHWZ52WJIicF+wsgvQ0H2EbXJNb0JY4Cpou6oqq1GK9VkvevTBzXm7QhOo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a447e2b-1576-439a-6350-08dc2698b0cb
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2024 22:20:42.4144
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HsKztVwJQjJLa7ajhpJt+6UnR9u0LammmH/OTpT+q5wAHB9Zieb7b8KqB5tPNdRRFHjVxe6bfniNeFU+wTajLuMAJmNzQLtvVxPxKlLLAJQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4164
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-05_16,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402050168
X-Proofpoint-GUID: t0019I_i1QwDcSq590v9icryyZtJreGg
X-Proofpoint-ORIG-GUID: t0019I_i1QwDcSq590v9icryyZtJreGg

From: Long Li <leo.lilong@huawei.com>

commit f8f9d952e42dd49ae534f61f2fa7ca0876cb9848 upstream.

When recovering intents, we capture newly created intent items as part of
committing recovered intent items.  If intent recovery fails at a later
point, we forget to remove those newly created intent items from the AIL
and hang:

    [root@localhost ~]# cat /proc/539/stack
    [<0>] xfs_ail_push_all_sync+0x174/0x230
    [<0>] xfs_unmount_flush_inodes+0x8d/0xd0
    [<0>] xfs_mountfs+0x15f7/0x1e70
    [<0>] xfs_fs_fill_super+0x10ec/0x1b20
    [<0>] get_tree_bdev+0x3c8/0x730
    [<0>] vfs_get_tree+0x89/0x2c0
    [<0>] path_mount+0xecf/0x1800
    [<0>] do_mount+0xf3/0x110
    [<0>] __x64_sys_mount+0x154/0x1f0
    [<0>] do_syscall_64+0x39/0x80
    [<0>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

When newly created intent items fail to commit via transaction, intent
recovery hasn't created done items for these newly created intent items,
so the capture structure is the sole owner of the captured intent items.
We must release them explicitly or else they leak:

unreferenced object 0xffff888016719108 (size 432):
  comm "mount", pid 529, jiffies 4294706839 (age 144.463s)
  hex dump (first 32 bytes):
    08 91 71 16 80 88 ff ff 08 91 71 16 80 88 ff ff  ..q.......q.....
    18 91 71 16 80 88 ff ff 18 91 71 16 80 88 ff ff  ..q.......q.....
  backtrace:
    [<ffffffff8230c68f>] xfs_efi_init+0x18f/0x1d0
    [<ffffffff8230c720>] xfs_extent_free_create_intent+0x50/0x150
    [<ffffffff821b671a>] xfs_defer_create_intents+0x16a/0x340
    [<ffffffff821bac3e>] xfs_defer_ops_capture_and_commit+0x8e/0xad0
    [<ffffffff82322bb9>] xfs_cui_item_recover+0x819/0x980
    [<ffffffff823289b6>] xlog_recover_process_intents+0x246/0xb70
    [<ffffffff8233249a>] xlog_recover_finish+0x8a/0x9a0
    [<ffffffff822eeafb>] xfs_log_mount_finish+0x2bb/0x4a0
    [<ffffffff822c0f4f>] xfs_mountfs+0x14bf/0x1e70
    [<ffffffff822d1f80>] xfs_fs_fill_super+0x10d0/0x1b20
    [<ffffffff81a21fa2>] get_tree_bdev+0x3d2/0x6d0
    [<ffffffff81a1ee09>] vfs_get_tree+0x89/0x2c0
    [<ffffffff81a9f35f>] path_mount+0xecf/0x1800
    [<ffffffff81a9fd83>] do_mount+0xf3/0x110
    [<ffffffff81aa00e4>] __x64_sys_mount+0x154/0x1f0
    [<ffffffff83968739>] do_syscall_64+0x39/0x80

Fix the problem above by abort intent items that don't have a done item
when recovery intents fail.

Fixes: e6fff81e4870 ("xfs: proper replay of deferred ops queued during log recovery")
Signed-off-by: Long Li <leo.lilong@huawei.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_defer.c | 5 +++--
 fs/xfs/libxfs/xfs_defer.h | 2 +-
 fs/xfs/xfs_log_recover.c  | 2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 88388e12f8e7..f71679ce23b9 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -763,12 +763,13 @@ xfs_defer_ops_capture(
 
 /* Release all resources that we used to capture deferred ops. */
 void
-xfs_defer_ops_capture_free(
+xfs_defer_ops_capture_abort(
 	struct xfs_mount		*mp,
 	struct xfs_defer_capture	*dfc)
 {
 	unsigned short			i;
 
+	xfs_defer_pending_abort(mp, &dfc->dfc_dfops);
 	xfs_defer_cancel_list(mp, &dfc->dfc_dfops);
 
 	for (i = 0; i < dfc->dfc_held.dr_bufs; i++)
@@ -809,7 +810,7 @@ xfs_defer_ops_capture_and_commit(
 	/* Commit the transaction and add the capture structure to the list. */
 	error = xfs_trans_commit(tp);
 	if (error) {
-		xfs_defer_ops_capture_free(mp, dfc);
+		xfs_defer_ops_capture_abort(mp, dfc);
 		return error;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 114a3a4930a3..8788ad5f6a73 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -121,7 +121,7 @@ int xfs_defer_ops_capture_and_commit(struct xfs_trans *tp,
 		struct list_head *capture_list);
 void xfs_defer_ops_continue(struct xfs_defer_capture *d, struct xfs_trans *tp,
 		struct xfs_defer_resources *dres);
-void xfs_defer_ops_capture_free(struct xfs_mount *mp,
+void xfs_defer_ops_capture_abort(struct xfs_mount *mp,
 		struct xfs_defer_capture *d);
 void xfs_defer_resources_rele(struct xfs_defer_resources *dres);
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 13b94d2e605b..a1e18b24971a 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2511,7 +2511,7 @@ xlog_abort_defer_ops(
 
 	list_for_each_entry_safe(dfc, next, capture_list, dfc_list) {
 		list_del_init(&dfc->dfc_list);
-		xfs_defer_ops_capture_free(mp, dfc);
+		xfs_defer_ops_capture_abort(mp, dfc);
 	}
 }
 
-- 
2.39.3

