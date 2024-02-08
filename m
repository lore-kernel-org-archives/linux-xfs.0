Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CFF554BD4;
	Thu,  8 Feb 2024 23:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707434487; cv=fail; b=Tfe59cgzLBgHGrbVeHIHtiqwc79VAMj93EOqOxG6zbX4s0XA5OzUbIwHwaA3KCtzSgMw4cQJtWG/31v4MbTuJxOs+KBKDkLfrkh2ENb0H3bRSZCWjJmF8vZ2CZ2oPQnWDet7tPAzCbofC1dNmX6Y9J/eurcF+Ss85H6jwcmT/+Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707434487; c=relaxed/simple;
	bh=y5KgQQSSkSjJQxcI/oTt/HWhd3yeJWgSulfl9nhjRX0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LUN8oQQE8Imf1MAzBkiYeBCd71/PYmqMnEW3GqEVEwxDQgg/WpHc5heRi7Dip6Q93Q8Dsah9qyKo2Kh1VHFd2/a9IwL9OT3H4yzO4vJ8pq6Qyy5KTTIDCauyhZKXrvWmUYJX/xsqdbuEKJArEvty4ZobgE4hkQpqTPe4S3UOl/w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XLEfJU9s; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=fpImwV4x; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XLEfJU9s";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="fpImwV4x"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 418LSpRu016674;
	Thu, 8 Feb 2024 23:21:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=vFDozcQmsuu8Kl15aipRYqGbq7AdZ5TTW9DDHJPsEdY=;
 b=XLEfJU9skIxiCJPV0pKVev+ZcImSafyoo1c6C7kk1UfCHlJdufMjQ4x8ZaofH8BXlk4U
 VDQzdd5utL0Ex7iDONhYDUDMgre1HxerMAO4P6KFmzUcWizW6jDwp/CZpAAVwT89pMF/
 txbjp74n+0mQzgebUK07DX8z7EZKnUsp0PL4eHY34o/IaHox+OoXeFScF8keYniuXcEn
 TIL6YhWmDvH31zn+IofKsBbTKT4IUu/qkqbosJv200j+NO7T+WeDZe0AzJqyeQaGF+mS
 OuckBnA5Qj5mVnC/wLfTCD/q6yOCURUAPXoGQzfVEh+otmCC54lhxEhbhHfBV+q8Mgl4 NA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w1d3up3xw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Feb 2024 23:21:23 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 418LgpLd038390;
	Thu, 8 Feb 2024 23:21:23 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3w1bxb7djj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Feb 2024 23:21:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=he/r00hN8LJXqAmJeVVd1nt07aGNaTv3JI6/3vz3qCO1V41PSMH9JkCipY0v1pj6yw8VUjSLdOwpMtdgsa3C2QwRia2TI3QKnbR8/m8LzwiQZzDnR5ZlKWJB42WxrcVIOTJ/CLCRai2rpy64g4VkFv3RNeVg0w6X4hFPz4EBgKhPJYJ2VYe0PeRokB5Pn532Vzt0S4GLZ8bgcjfumM9piX404+N+Kuhosc/WlWlG01+L209fKq1NIHi0lbFj8UiQd4OTFkZX8FVBF69Vmc/ziNMpPJ9b85Bg5v+5WUqWCl7YqC0porPiaHG+H5a8AAjxw7xKAyIziKwuqx9XOyIt2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vFDozcQmsuu8Kl15aipRYqGbq7AdZ5TTW9DDHJPsEdY=;
 b=T77nTqrfu10BjLXfPP0rAebN8rOxi0WtvnambrTDjQU/HYaz/NQnUZxTxeN+JIY3bE0w1tOABQYAZWPJBiNH2su4YuHNRe08aiJPW5AtVpyfKyb1EJARKBI5msoWICWKaxXRxDxR3MwwNJX9qdRSMasxc4INd7ENdqkHcpewL1ch9bbx5tRAno6+iJ9g7ch/k6C+wsNsbZGTWTJ0r1r+4aZCdKWQyDj49Uqe8VRwwFr3LvN8msYND6ZlPKWHzhgYR+WW0VH2qDH6ja0GAFZY7GI3l/UosKJc02lBTxMnw7ZqPk3esimXH6st3u0Th7IeMpPEXDL3t/1ksXwV4O7H8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vFDozcQmsuu8Kl15aipRYqGbq7AdZ5TTW9DDHJPsEdY=;
 b=fpImwV4xGp3dEFjdK+SrPiDswRG37w0MUr/rXg5f3lcsv7lb6WjTk9wdYABAYSzqB3d5tDl1/wLu+sobys2Sk/ilF7v2/PigVznlIJ0v4/DHNSVEl0EXgDUPxKiRtfdkwAX+GPzCV+zt4stFxthTjpLNn+AI+pWlq6Nelj9lQQc=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DM4PR10MB6014.namprd10.prod.outlook.com (2603:10b6:8:ad::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.37; Thu, 8 Feb
 2024 23:21:21 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::abec:4916:93a1:2f72]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::abec:4916:93a1:2f72%6]) with mapi id 15.20.7270.024; Thu, 8 Feb 2024
 23:21:21 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 12/21] xfs: abort intent items when recovery intents fail
Date: Thu,  8 Feb 2024 15:20:45 -0800
Message-Id: <20240208232054.15778-13-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240208232054.15778-1-catherine.hoang@oracle.com>
References: <20240208232054.15778-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0088.namprd03.prod.outlook.com
 (2603:10b6:a03:331::33) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|DM4PR10MB6014:EE_
X-MS-Office365-Filtering-Correlation-Id: 9631c242-9de1-49d1-dc1a-08dc28fca8f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	t6XDubWD/a1ZOKabqRq53s+dqeQjRbPQD3SHgYADPgJPgE5fRyrIg30RjaK8uA11gZjMf90UcApCRfQAqdezdHIM9b7gXz7BWV6tz8luc4LavGqI9UxZGo9XmI/P0lrFhwGtJbiXcdxpGrxFMl/+p+dtt8QeIhLxOzDwjQbh3AfgUKICsW9DB7qe7j/02LHJoCxxf+xbjZT39HETkA/u7LUbgDqpD8emNoFSSQ+MgPjYaJMml6s6jSr5lksj6dgoDBVrMf3LGI+7ZyBAO0apMpiRsTB9xwYCzhNHjc7N2zc0QZZZtCM7ubFpe3P66jmCI7V4ltSdQZT7hgvXtryWKzykhGEy1x1ZvdknQ/ECJnpC4b0XUVGPw2VIihApGr0bI23RCAUmfi4osAvG3tHj2SSjXIqFvFHDdooT59EFxSYaIVN7DeCG5EtQomBHjbehu1Cy5Fuiq4PgHWfZalgu13aofl+hu7xqnbR1TuE3SX8iQql+mfbDuRX7/8fjOw/T2fYMkqhek4A65VE54G1Q38z6afO6qXiFDyfzj0IIiHcYkMAlhruNv8W64y3SHzun
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(136003)(396003)(366004)(39860400002)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(86362001)(38100700002)(41300700001)(83380400001)(2906002)(66946007)(2616005)(66476007)(66556008)(6916009)(316002)(6666004)(36756003)(8936002)(1076003)(44832011)(4326008)(8676002)(450100002)(478600001)(6486002)(6506007)(5660300002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?6DquMBC0B1mRAk79GyBk3ZLvaock39HtxcIMd37uj0vnO/bSr+8ftUvGFIWC?=
 =?us-ascii?Q?P2SFPDh84nC8hdPVgz5y7oW7I7JywtO6bgjDoiq7zG26caFt4Fyp0aDDGhV7?=
 =?us-ascii?Q?j11xgrg88eej/oAwzcb+5hNAcOn+9j47c/0Kba1J7Ar1fZq6t99dNts6K/HD?=
 =?us-ascii?Q?Mu/D3ikoZzNodIqaDB7rKoktOPj7WG3bTdJCR8ueGXQBMfHgwt9Wx5edOdHN?=
 =?us-ascii?Q?sbVmlmhT30d8hVt0zFMep3ow15siaAgtci5pf0YMwRBEHai/WjwbJutKfpGE?=
 =?us-ascii?Q?EF/CB2Vuuf768T17LvxV3R834FTz4J68zsKQZAf4OkcgC4tV5N3DaHm6LFEz?=
 =?us-ascii?Q?Db9i633zl065q8ibMV6twNLw37eHNFtn8YVixyL6/luQAL3Ke1rTzxCz1tx/?=
 =?us-ascii?Q?PMnK0EBjTPcoypRDBz0264op6rlplx2z0mb4GITAIWZ8Gv7UG6MSq8PPUFT2?=
 =?us-ascii?Q?mww5Pm86a//RKj/tNFc+emIVUmwWkmlvBpDgOyHUMxvg7Tzy6W3FyJHFKU6y?=
 =?us-ascii?Q?+qspAOzzDYjdXMg8CUhEi4MtF45hzV/mKU4C4ACbXiRxqcPe2tUVSezHAPY5?=
 =?us-ascii?Q?e040jL4LOR9lohTqkYV13xVKrozcjSLVelf/XczUhGgRB53G2gos1Knq9OPx?=
 =?us-ascii?Q?hJ/K50itKtH1eVCbkYhHZJErfYWutURLBW29co8FftCQYN4ZVaMfua89INmw?=
 =?us-ascii?Q?OLTq8uzgzJcIWrGrtnsFLqHvBMreWxlu9t0XgcVuxZ4l/mOPoHG1jMFwagXx?=
 =?us-ascii?Q?PFf4li7wOZUOQLrbWjhzR7Z68jE4QP5/iZESX8ZFo0VctzluCRVEdi1X2Jey?=
 =?us-ascii?Q?VojyeZE7zT1lGH3d1+ZD/MOsmpN9bqHnWCczk+W0OnzgdeDf1PV2KjyH/67X?=
 =?us-ascii?Q?cnZTt5lwivsKfs03HjB1ytGKF2xn5kVAGSmcDAZPIgEOhoUa5mc1W6h+NnRg?=
 =?us-ascii?Q?xlwWAa0F/tr2MWASETW0OANT01Emv/B5a0buLhV/v3O4bbPO0wSUgIY9Pkcw?=
 =?us-ascii?Q?xnsjhB1q6yw2cpU8GvU30TdrBVswtzFMC12Pqvap5t8px03HtVNxGcdFUtDA?=
 =?us-ascii?Q?PtR7WDtQZIGjT4cnpDGzpzz5EHloex/n55KsYB2ogkuZvZLm1hLJz+PRyqQh?=
 =?us-ascii?Q?ZkpUuquED0GavznUBwJFEIkUQ6Tws3vt7ZmEUPvESJlRgzxagkJzgahjdX0h?=
 =?us-ascii?Q?wucVuoGVO7FLAuLkfN8CH2ny0DkRqvQgQrBSKdaDauPrxNM0TcUbvuZrALNA?=
 =?us-ascii?Q?4co7N2kqu3MGO0KCQaALGQgAjZu+hUSUU1xLH6tIDnG6HTCopoaamS1zQr2y?=
 =?us-ascii?Q?mpRGR6wdm6nrmUlPuIxhdEX4cUBv+iQ0FPkqDjl04X7cA6tyzZm9p66r92hX?=
 =?us-ascii?Q?TVfO4fwyw9SJxecpIYpUIrOsoY5r8nX6fGVxifSDa/Ov7g+yqfCzN0DQtxWL?=
 =?us-ascii?Q?acgsT/QBs1fP5EcEaCDAhaLXVTFMbzRq22htOTgWbDHGAC40K6YQydaUF+bl?=
 =?us-ascii?Q?cr1l5MTUd2dq4DWXqIlimHBg4Eg1PS2+hVTwcbfn5M6DMcDNS1VUlpKjKX0h?=
 =?us-ascii?Q?qETGe9SJpyBeiBV9QLZMJlQpUrw85vdBdoIdFrXRV/oT/U0J6eHiu5cEk28+?=
 =?us-ascii?Q?sfvKKwT1VczRTYY1u+O4u41Ysvfr5yxbHGdWYIHuooXDVZYAWpwgrKKB8de7?=
 =?us-ascii?Q?oDJOHA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	NSBCOuEzobT1C1DB14vR6WT0NZFRkiS0u64YzhMqAZRsLyAFT9YjOWTDcnAzWxvW6XrdEqCQKf4Of/ReHwRgmc+WuKM+tvsw9PoaBFOIZTaYPX8jkIHyS13PAOvRIgpJyKWB/d/IilVhX1h2yj9SDAMOiHcTBS08TLhZjMM/rj6q0NzMw2H6v0JET2OPeTvsGntNwricDrlHYP1A+bHlip1IGf65oThvQAz9wBT913MAsO5qt89AhExPqZdMuK/B4KdPVaOnJ9IOuuE1jrJDBGVhcQCfSuW4t1lqHAZhj6GfO+svJ3sHEIuTROxgoiKXtEPWhOTXJPZCkcHkPzo8MGNtPSMz+1Zpda9YvqvvvTC3WG0pchw+m7564sHWVID4q6hj+sOhiyxzHcaKXkF80yhxOeR9uKPCmzjWY45cbW2/135CGab1yc0B/ibvula3lzyGaeSp9OJRo0+/IY4xBn1RT94Lb8LRfyNEeszdvYzFDgBduK2wZZmRtzfzYMwCml0CNO/1tl5dAF22sDqy1Au+P33EWmvw53D8BLjKQXlKBiNLs79HsTLiU8C/elvBbBvZ4tWiBLdPto0P9+VDe54YZ8wS5qe1EsFutHzi7SQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9631c242-9de1-49d1-dc1a-08dc28fca8f1
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2024 23:21:21.2601
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RUohJi4AwKk0Xc+9/EPvLtgkkLd58Ay57vm0fh12RES86EKqZ5u/NnbLdVthEJd17Q6UBjk/FEhsBhuO7pEWiTR0LK9s4okrPAI5hG0gcsA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6014
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-08_11,2024-02-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402080132
X-Proofpoint-ORIG-GUID: et56s8yBSnepnm6hSt3dDijcvyoXAiUF
X-Proofpoint-GUID: et56s8yBSnepnm6hSt3dDijcvyoXAiUF

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
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
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

