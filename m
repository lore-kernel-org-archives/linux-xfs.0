Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DF104F216
	for <linux-xfs@vger.kernel.org>; Mon,  5 Feb 2024 22:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707171660; cv=fail; b=KN7DC4OG8NEc+qIwxDjUmvoFQsVP+qg6UbWq8kMJrUWyUidXWIdpRk5i8TLf2LyDu0tzLIKVkdqisf8/PygiW+DKcSshPYFhgt4haOnOb8xVG2QuCt25PoHBkAFlDW/bysbPtqhfyQ3/hFWeU/1BkrPZSGDqy5waGE43GD7aAxY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707171660; c=relaxed/simple;
	bh=qCuP2zIkark+CiJ9njMGUDWYFilwRgp3lPsInxk1Rk8=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QF2L4WjAQoYtY8vYT4FWBH+vPtmCsxtCXpMp9bb0Tn9ZhEbH9K4Fj1pCcqxLQsxku1776dfS39bS+6qJE5aEBtQSfu53a3SseZCqP6I+VeqhYBWySxhg4mvDxf2qqyXJNAOs9xVC2wq0caVY7qmwybx1jWbjlED02UzKwnGqomo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IdQgmZ0s; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Qrvx688O; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IdQgmZ0s";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Qrvx688O"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 415LFkj7024987
	for <linux-xfs@vger.kernel.org>; Mon, 5 Feb 2024 22:20:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=DunNBBwLHa8gbOz2awBRm1eDp6Y8GG+bO0mwHzIrvfE=;
 b=IdQgmZ0sBLPWKsIrKmGOxSsUXNfnk7FtWowGM5HhsvKbAqI01lnmzBqtdLfAx9jddGUH
 8CCbFCCQdaW7FXV5KNV8TE6W3CmGi1Z8CJwg9KBQWC/TLM09YOEXVfrd8GWWLOk24YXk
 hx7WATYp/hItOVLJ2Mz3Si13nLVkOQ/cocpz5CMPIr2fFPaZGn6P+OkN7I+iaZoHAVw8
 6z0xzfqeMJOHUIG7/JLS24H9Rmo7Wc43DjOUp7GPN0Zz1wn31pQfyx780SUyChtKxaLl
 hoDSLNbueHckTWIwR+FjsJlfFchKmJ0eCSmbfYD2uUqen4lbV9tp68Lt8SB2fEpfzBz1 zA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w1c32nac9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 05 Feb 2024 22:20:58 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 415LDrSt019741
	for <linux-xfs@vger.kernel.org>; Mon, 5 Feb 2024 22:20:56 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3w1bxcpjmp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 05 Feb 2024 22:20:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m8UNAv1cLIr2Hkd/+GaZ1xNH3tF2Hd9dpRKRrt1KRzAbyqtQyVthRVE8Hq9mAgrEaB7Vaa+2Iz16xj3QxPcmFMBokd9Vg563FmFQyK0J5OOgOOpMwVCAyODO+CSv4v4/0KBswyFyVJQ5c4GUsYFr5qSji7q2HgvaMHpFMbAMKEwnACLlCDL9HEhX86pu1K1JE11Hz0lNBydDBMLLm+t0NDFM356dLFhS89ugCNmvhOaU79lM/27YyYJvKR8Lu9J7O1o8H2r8lPWUxh/pP3CRL9RMcwWwjPgTPrqxxookOgn08IqpUI/f8cGxXAqHGL0uiD8Tdg03+nIEubNdweHPaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DunNBBwLHa8gbOz2awBRm1eDp6Y8GG+bO0mwHzIrvfE=;
 b=hqhm7EAGZnMEv9vNtoY/ccDDttRmNX8dOhOZxi2dgPKztbMXNpBgXrx19IJEqY/XU+j470SvdADL72bkvPU6Oz6gkWM13pGpZSeKcvl/ccMAztPH6VQMp1+H5dIBWvDf/JNz3DHy00vTv9F+bNq4hQg4vQsj7xYlx2bLA+EyslEVvawC3UvqkFAD7rjiTPFXFMdnJYqQxrD50L1t8pwyXvFnphWdYZUC0g0CwhlfnOcVDY28IS869O2bfFVka2FQUe6k5CcqgfH/xWXuWZ3GB/mwCu9KHH6WLtVyewkGeY6vkaGnDep3f8e4+PZZPGZw4IBXvIV7zyxQDK3iIJQdTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DunNBBwLHa8gbOz2awBRm1eDp6Y8GG+bO0mwHzIrvfE=;
 b=Qrvx688OmoYKofZTYh7tNalkZC7yUeCInnWIAMuNCLRF/XUH///AO66MIUyLHQ17EljmyU1UXWVdQHYSLb8HZhE6ftmUelaobx3Ixdw+wSyZ6Q2rrGAKzC6JOl2W44JKnWhvK2Ft6+s8k4ulizrweRQwfn/QtgfBCxX9x6mxqgs=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BY5PR10MB4164.namprd10.prod.outlook.com (2603:10b6:a03:210::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.34; Mon, 5 Feb
 2024 22:20:54 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f%4]) with mapi id 15.20.7249.035; Mon, 5 Feb 2024
 22:20:54 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v2 18/21] xfs: clean up dqblk extraction
Date: Mon,  5 Feb 2024 14:20:08 -0800
Message-Id: <20240205222011.95476-19-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240205222011.95476-1-catherine.hoang@oracle.com>
References: <20240205222011.95476-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0298.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::33) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|BY5PR10MB4164:EE_
X-MS-Office365-Filtering-Correlation-Id: c76b2257-ac00-41ca-d127-08dc2698b83a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	zRDk33uFRMy2WMw2HrD+ujk1VTw9knUcS/6AaEb7SSLJ/hNA1jaAsc+z55kHN+e4Gnxe4xOghQex3pBddwHXkdqSteiAMfr7COeUx++D6un/rl4SLCvFxzmjOXuq3svTrE/bN82dxmiFenLfXnNAecfQveDsjY1GmxLWILID7+M+Q2omlltqMukEVppCkXNzDz6DOWIjax+PsA4wOu99mxH9PZY8sC7exGe/6nkFQUb6GqEjbRZAq1UBsw0gdt0ly6eOHyLgfg3ghn8yd+17eMhH3ojw3/HBSn5nxRKjd5dP+GDlS5GutRSSTKO/NzcMq32D7Urz+s6ffVfVsY4jhmCc3W1Xi4x/NOBqHbHUS+RaMdzZEUOPX1zx6i0lDZ4012I1dXaWIpQ9vbzfWVji8GvEJtcLS3X0HDw2bJTR/ySS2OfmlSjLF47EgAsgINvO4roE3Ppj3BIxTcLVMe8NXQd3WNpH1iDtWOYKtIoIiHxUL9W9p3dEjGNB3FbKQCaoy/XjBiqhaGjwYHouhVfaL16ezDfw/zowuKqsu1fx+Q2qiyvddVMQoIpcBXOYJDqD
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(346002)(396003)(39860400002)(376002)(230922051799003)(186009)(451199024)(1800799012)(64100799003)(41300700001)(316002)(66556008)(66946007)(6916009)(66476007)(86362001)(6506007)(36756003)(6666004)(478600001)(6486002)(44832011)(8676002)(83380400001)(38100700002)(8936002)(1076003)(2616005)(6512007)(2906002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?fGBRxa08OcjijI/gedtvvKB+z/DUjneUkI1+nCV1jQxMqCn9vl6YKwU2/Yk3?=
 =?us-ascii?Q?hEzDMZavm0VXbyFxUAxyeJ3BmmXKzunSHrzVFJt9V5MGsGa36AGuaGsAsz8/?=
 =?us-ascii?Q?b5rS9rc6+4kJJDmEZlb3/nDFRtbQP4mk7RopEuebkTkkyYpaYUiMm32dtrJ5?=
 =?us-ascii?Q?yGdZJjkGCuA1jHCh2pekks6QcSOl7eWisAHmJv7xU1JATv/qz6u1VxKsQMIa?=
 =?us-ascii?Q?ThNtm8RZwJ4DvkXiBaxfOf3YwW0DdiT+hZD4vM3odMs1CII0Bp3i/jW1dZor?=
 =?us-ascii?Q?oYKQGQdoZD35fBwEZdqC1csly06VuBloBzBvjgHoTtLJxhAWFQrPk9Lczm6Q?=
 =?us-ascii?Q?rDjo4tdWQ8DnSyf6XKfFyOP8HYlci7OiRj2cDMEQ40gsAQTxZk9h0wPG1Koi?=
 =?us-ascii?Q?rv5uF40ARUXwBxeL+KbUMkXx9VR9oWMyZxVMMYATD0R/mhkOup2oQygdvbVA?=
 =?us-ascii?Q?bE72EmneuqvUnPUQI0W42cNHPJsnfP3DIM/8y+WWqZ3NlWenW/egdFtP1cBF?=
 =?us-ascii?Q?sBejLrD5goDolVCg/kjeobFX7PL8d0NWP9PYXT9O5O9t1dlzXUHhewWtKiYw?=
 =?us-ascii?Q?N9vYmVuppP0ya9+/PDJSTWiqmfxNxNcimfIiK8rTy3McHTnptSqlyNrAM5bt?=
 =?us-ascii?Q?6sTi+0lMZ6GHEn9lCgYBVBHZ/S1qIHO36cGJY0nbHrjEGzYTkmtAGYakLX79?=
 =?us-ascii?Q?5VyAfFdw7swcrf2oxkmLRtSg9ZVshTAeDukVJUuW4GJ4Mva9wH7N/kQjmVtc?=
 =?us-ascii?Q?YvMKt1n//Jy0zQAS44YrAPEbDbI8SlABSLD9VNwtmVCkPaONlRcPJw1RcWnN?=
 =?us-ascii?Q?HN/IhKFo4j3K8zgMi+mieg1/6mFPZYNcg1SLSxC0njAmKeJi2x8TY0AXW5L+?=
 =?us-ascii?Q?anz7fhiogpHSjcqWaqhB5NfSCWTl7YvYUQj3RFGMhhj2eilHCdRrJckH1ocn?=
 =?us-ascii?Q?Wd/dw0LqPHiylhYCpzTM1fnq90cdndIGaWESfx/zXQdQuDF41eZhlnAX6xcj?=
 =?us-ascii?Q?l0UjIdHLi2rT/WFtT9kneHp01WV3qvJ60ud0oy9QV+iB+JV/Gb8XMmf3QRl+?=
 =?us-ascii?Q?BqvI7gQ3WK1apLIpnWiLsjsthuByrwnmlzsbhtUx4j4PLwmZUc66gdD3t6nc?=
 =?us-ascii?Q?kc40Rvox3kwjBcs/WGtStqh/eZsFO3ngJrXo6ryaCM/SzUiLv0o6C0Ej2Hho?=
 =?us-ascii?Q?eAqjdz7g5HOFGOxDtF3u23Jlz9ke7V7cO/31gnN+7vuObgi+iUgotNEqVue3?=
 =?us-ascii?Q?omHdNrhwfyl/YfO0su9Bg3BeiG4QVrJ9aihTe1JEhKSb2bBeAmm/0GM0HvSs?=
 =?us-ascii?Q?4JjrntB29Ub7q7+ujfwQwr9HIHHXm+kKgXpEG0Dg2jYjxXpNhIpG/V9cF05p?=
 =?us-ascii?Q?xdA+KG+nsb0SFrPSXPrbqwFxJSonF9WVNcUK3x9M08adOeDFEDxUac8zZmkm?=
 =?us-ascii?Q?IzmjJGYj2hYwswc0Rhw6a0bCtMuGmUWpUuj53gv5I5RwRm+0env5QVK7XgnV?=
 =?us-ascii?Q?is+9rjn4evOZElNyEgiXmmY7TfEnUcZ4W51Q4rTEsZo3KcZ5At4xlhnebCH1?=
 =?us-ascii?Q?Z8qf/c2ZUon2LdyALODfhJWhYZheP813ExxvwhAB6ARvhhfKt731/dFl0giH?=
 =?us-ascii?Q?TpawnYwpJNuDq/HHXkondMjbKAoJMBgu/rHof4KvFyEXxnvXuC7TVsP17I/w?=
 =?us-ascii?Q?/ijTlA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	pthPNmnnniH+s3hh3MwQevATloZKrDY7BBew4kOpabmnYgLYs3+TwvdkC11tMzMupY0yP73UWXoowxGOglAguzb95GTKia7lKPxc7PKTRTwpv/ONS88d2yxZTq/thw6HVcHEreOdsOkwTzMDBSyOHtR+lEsAeelJ0Kzhv/z5Rg83muERI47S7EpIj9UsYcBB7DagiPOvnoqPl/b5kd+7l+RVD9siHeZV2w4HBOPN+P5D5Xi6UTPoCoXmCiuxdz/E2C99Tb7R6YEHkeYOYWlj8U6rTQciJ1xa38ZZhJyAprUQpmIvd3LUcWTPaLNYfq8NkwJS1UGHx+c8E0R1ufd/ipvKJN0dyj6Dl6C1dyQT8t4B+HyVsPKHM+AoAWX/UYEaxmWukmQLDuXwGAtF69a/zyNol4/F9gwek7dNRvqganXJ7T1w4sYjKRW8pS2o3WGLt6Oap2OAlhXoyWC3TLZog2gNJEWm5cI/fMFHdwhAbtTsV7BNIviMez+e4x0eFIFTrkiVxm8rBYLZ0msvomzSDzNC3D3osRvcPE93NSruS9QAHLU6hqezzjbm8M6NCVOL+YqLLKFGQMYy7SnTWLK8m6/rUO1+sICnW6IpPSaRl8w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c76b2257-ac00-41ca-d127-08dc2698b83a
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2024 22:20:54.8950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fxI7e8vaSFUcwfuEciZ8vHruNwC+v0oaTW92DyU33HP4bkGABoh3pNMQ3vTjvKIsmsQ9ojXB7aEWjmG8lDGpsg7aVKW0BSLfH8ECLPrMQM8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4164
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-05_16,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 mlxscore=0
 adultscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402050168
X-Proofpoint-GUID: h-4aumCaXefnnYcxzp8_O2E-cmtBS4rv
X-Proofpoint-ORIG-GUID: h-4aumCaXefnnYcxzp8_O2E-cmtBS4rv

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

