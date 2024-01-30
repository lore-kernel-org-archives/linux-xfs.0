Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD17C7EEFD
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706658288; cv=fail; b=QKwYalJ0fsMnhnRC9a8YMeHZXYVtKYKzqIbsnRDukW6Yh3DZePOZpUEJj09XnyrpfhB1TbzuSa2pEuBo87n2r/nZQBbVD0z6QL+VG2PPOUY8hWOHC/bp0PGTEkEeeU/S4LUNYrQbKC7N1AB6JFSv/Jl+XPSJePHksm1KUD4juAM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706658288; c=relaxed/simple;
	bh=ptQUU1riNYeaZ6ra63JPwMP6vbPi8VoDd9PokttUThs=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=U3EA3OTosZOewGUaRA7R+HlKMcZA41bqCGhW+vtHm9F+KAUYKIsLNBw4Ihpp3lGh/UMvfzNBV8b3TJBI96ufZNOR2lEr12nu+UyDFZ/lDyPYdAfXMqLzZX42lbelb6Nm1w6s4VwqAa7yhoyBqWKK7xNnsU0R/PXmOFgizYNdtXo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZEhZ2hSW; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=BYWNVAaG; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZEhZ2hSW";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="BYWNVAaG"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40UKx9K0017002
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=Rpp41uyfpYqkyVkZRwrxUVLNdfIlk2H6xU10UsUHj90=;
 b=ZEhZ2hSWyBwHOj7Y+U3JxzH7iern4Z/Y3XuLYkekmAyLFkv1+INtgKeXThWoqh2J+1WE
 /hfxg91f71Q7pAGVDlapXFSfIHTLKLhpv69W19CCY0O3VFKSHhoBkmqoAxSOhwAoqyQ9
 7drTA94ZNhabI0Li8rFiGLJGTmol0gfVaSVTjTTNH4qlgPrmOm8EuFJX9Kal8e5U0CVs
 XmArhj8aU8gUcPsRyEbOkTMxkjtYmuR7RBRdWCxKeBoJgtbCwMfJxo51709VH8V0UF2B
 SfqbkvGmmQ4jDfrez7mpXkkex0Qiq/qo6bcFdwvo3qHj/qzbo4gGjjR3E59aETKl4Q52 8A== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvseugcmf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:45 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40UMU8or014620
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:44 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2040.outbound.protection.outlook.com [104.47.73.40])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr9e97sx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dyggK/BM/gsxhxxtEc8ZJgUlAy92ORjuZ5BfeXyWPbsiAXhZ7MEnEZ2V96v1BNitHw/EuI7Y8a1zX4F12lsGZdHNgHI177s3LAMfTmrt7X+7IMpq0gubE5nAQs7WM2BPROvhrE25x/KHJ8qglM4nNtTTEa4LcD0AolNLyfMTF2vJxyAc2D9SEQQh4hzO7Z+QhxA2a0dIzApqJ4seA9TQyUqQk5LJtLXXYPKKV8f3eh9Dg9zihfAiEgirzKbYReXKauyvdoVDq+8M2hJaJK/yZfp3doEk3kGlTBMRm4wg1QjEpk4m7MGzx3u0j8SbywnVZMsO5OJ+b2+aRAGz7DndEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rpp41uyfpYqkyVkZRwrxUVLNdfIlk2H6xU10UsUHj90=;
 b=gIHJvp/iKtPQ2ugoMseoVOQs37TNlQ6rhWwCRM4/WFG+p2zh8hcu74BL+7bf/eUZnhyji3cbbc6xTkClZRhwZEfCchZeFI0XFjVFVy5MoKbC9F3AaMJKOyGPmiQ5YayXrvcjkwtICTTJ9jmCS23v8My9TTmco2fLAliy7vBMAr308XvWvMZZSC2Rzgr1mONlERXKPZR3oA0qH7LQpROZNjvDUNV9ts4beS3NGZKYJiH9ydpuoiWg7Yno4dFZH+CiucCYgT2rs3qV7ME5zjhjgHb4vJ8CatWUE54cW5ql6hgycONm+l0Hr3h8H6AVxha9kxv2x/Kdp7pqb7Ftn8RSEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rpp41uyfpYqkyVkZRwrxUVLNdfIlk2H6xU10UsUHj90=;
 b=BYWNVAaGdkQmhROkiL7T5+nevaJBo7QPUMDsvFsuY7UtMkgB7Hpnf8oEZ0Z7LrO7ipdZ6N8u+0Um4jGiZ5S7YQAxbJ0+a+5KFAosaD2D9CqIMRBIAgO1ir33HIEz0ZvmMJIOTBbY82nWPohp+EYuL8fuw9vLS1a2EzhbFlJ8EJk=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CH0PR10MB5305.namprd10.prod.outlook.com (2603:10b6:610:d9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.22; Tue, 30 Jan
 2024 23:44:43 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f%4]) with mapi id 15.20.7249.017; Tue, 30 Jan 2024
 23:44:43 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v1 10/21] xfs: factor out xfs_defer_pending_abort
Date: Tue, 30 Jan 2024 15:44:08 -0800
Message-Id: <20240130234419.45896-11-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240130234419.45896-1-catherine.hoang@oracle.com>
References: <20240130234419.45896-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0225.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::20) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CH0PR10MB5305:EE_
X-MS-Office365-Filtering-Correlation-Id: a956ab7e-a59b-4e03-48f0-08dc21ed6ec8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	qSW/ez+COMH+aSWQcpcWmKkZyjcx++NhWd4om9yAG9HxmCTQyImvoq60xuhZEOz3IFfrw0jE8pqckFv+YUTpN3+Og1thre61z1wV0MEXjvfgJCZq9gAw7tRr748Y6sjrpIngXfI1SN9hgDnOVm0akycxwVITn9/eyll3AAH5bE80B4LXb2qd0w/9kBke6nc/7r7hd6fkU2nAbkAPTEFsnewADAUkFu6Uh9NVu4J3RAM3jHEx7bmu4x+rNHrFzZFxIxaCGRSMJxfiZL3URTDcDH4mH8D1XjKFGIoPHkCryKtDnROXF8xkcQEiWtaOlahMnE6Xjh0FarPEbqNjSB/dBYD8i+Fe1Y8bzpKeLTpipyoVrosbW4W736xnX9jFfu5jgz6cQBKaB05d1z5oBun/jNtD+akhE02UubW4YrB/c0hrnzfz/KUS+Tudum8y2IQjAuRrl+b89/qy1UTeFbcMfYFOitPgU4d+EpfCRjaxgleJLVbyTxKUHw/HsLlzVMb/kHZ4kks/PfxJ4ozfVQTT4/CIySrAB5o8VzImRDqeVvv4YUbRuMixOybklFC/N+qQ
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(39860400002)(396003)(346002)(366004)(230922051799003)(186009)(451199024)(64100799003)(1800799012)(6666004)(6506007)(83380400001)(316002)(6486002)(478600001)(86362001)(66946007)(6916009)(66556008)(66476007)(2616005)(41300700001)(6512007)(44832011)(5660300002)(8936002)(8676002)(38100700002)(2906002)(1076003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?1jgyC9wt22acZbbhrssihqb/Kx5e8Wvn222sJRaF8MVzJoptUCWd6fFUG5YL?=
 =?us-ascii?Q?Kjql8vJe78naYxopYoemliHOZ+P7hcu/L6KGX99MA7DPCTHdYcyiewag2fcW?=
 =?us-ascii?Q?VUINo3EBfEAoFeSRfVFgnggYz1Wlz8CU8Y/AjLvPEVdhox6pQdyzQWZNEt4j?=
 =?us-ascii?Q?UGxe46waRNAiX4R5HP96DRaQhuNnU/AxG5470k4amOr8weAEWXJ79r+Uvc76?=
 =?us-ascii?Q?Ua6OdWPfsxsQx2amvj0E+Wavsnt6v7mMX6OToV90iNlr7WfP1rsONSEX0zYP?=
 =?us-ascii?Q?ZN8uWIDKKbba5mFwIwO3z81x6brawWtS+sAOJdxHAb3025pi6Tppun5d03tJ?=
 =?us-ascii?Q?2/XCaz/zlXsEWC4vzq9dVeP4toUjJY/K8Q9k1ZXLtxN1b3tEFH+DsX98FxRj?=
 =?us-ascii?Q?W1xykkSoALXvLXTLN1yj1A0iHcuh8aih2DO8R6blnOBxAB6+9dLZIPU+g/Jx?=
 =?us-ascii?Q?AwJgZ7LBDmArvyNigukEyVRq2QnFKS+khmd+CsBIqGHXaouHfmBcJLsv1GXY?=
 =?us-ascii?Q?fts+eQ+xpyKbvCImbFc05Mn59GSehCWPeyQ/gjKkNy4NonUoQRrU31PgGugn?=
 =?us-ascii?Q?AX3WOorJMbytYWusGEFQEVY8Nsz/BvFSI9GtSt60OLoOLMPrU/BwFMZnuwZx?=
 =?us-ascii?Q?I/9jQN8jLkO2mk+G8A5PjQietWznHgN82/MsOeqgRH71S3/TQWH+qON8+/8W?=
 =?us-ascii?Q?TNJ6FYz7OkFenjSQglKB65w957M/2BSEvrbZvziObbJqzLBX2HgVEIS8iTUF?=
 =?us-ascii?Q?TQawCq9oRleuiH+qIFmd76Wu+CeCqF4zar4c7LrTpN3t90bb6JxJ2kFMya3D?=
 =?us-ascii?Q?WasINKUojGAhi5AbnidT7NnxktGqGGakwICLkJQo73PKFJJ4m7Bx67mKf/o8?=
 =?us-ascii?Q?LXpq/Mc3zHDOPZP5pZrJjChJvIT/ZeVr7XwXXlq9jpq8NUBcQOshUAeVy/xw?=
 =?us-ascii?Q?CuUxI1Y0DJESwzsDq9Sun424J1tDbHOY/o9k4LC3FLp4N1yypkheVhZj9nuE?=
 =?us-ascii?Q?bnmsAkqWgJXeJ5PFwJSXOfILPxv1gW8q9/fC31yecr/2kG7o7CMaOClgxz7S?=
 =?us-ascii?Q?nkaxeXOi6PHqNQ3a2gShbL02xq1bxoYwr/LmTTXIRXU/0yB81rgBAKfe8f7s?=
 =?us-ascii?Q?+FQb8fothPFh0v2YeTIzjGCS7hkxreuc8vDCHzNZ4ZtR2v5WE43RfMnyfCdF?=
 =?us-ascii?Q?Caz2aaQ+wYdnTHe7/B0sHHOKA51XOo06gFCiW0Vli8/zOoiqATLhNx9Ml7Ak?=
 =?us-ascii?Q?xtzbs9YcIZovjd1CTUMMbob1EFX+0MZBAuPxiMGwK23g6ajbZ0LNo6LKg/M5?=
 =?us-ascii?Q?xX4kOpMYxA8M7HCEBpw5dt/iextjSWHlzRqO4MRxuJCAXJmFMoeqvV+bjsuY?=
 =?us-ascii?Q?Erg/dXFut4YEn75snujxH8PLAoReWLCRJSc8W+dBWtjzfPs5csMlQXoeiBgb?=
 =?us-ascii?Q?7Vku49Re5aAYJy3WgXTMXynEgPyrWurRnmUPWfTulUc9FaVN4sfWYDxMo97j?=
 =?us-ascii?Q?fVto7jSO6vdPQ26jTp12H/wYMkpPh7t2JKGAfYVPr1lkXqMnKGT0qlyhXGQa?=
 =?us-ascii?Q?2e4cjqzGA6q1znbbVPlUmg7FQBYDxPsUXO2Xhje26Qvk1gbd13ol5Nwlnz7Q?=
 =?us-ascii?Q?PNX0Jpesyt3Ox1ErbqsluBDxp/2Sl9I56vkPNtIit0baTHAHmX2ASbWwiWtt?=
 =?us-ascii?Q?50Y54A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	c5va2D96GlZ8PzcMbMeswuhi8S2XpxdE3toZSB+I3T+Uc2nTV8/SRnUCmU/HdCUL6YxVp/udEZtJaz4GXPlamfMI73xUaSMRy/2/BsbxuuxjTv7Jk+djVuS5oVOcD3cOvJN2zhCkiVwYxjrqCRPaq6Xn735/cYlJ1XjyP8+gYNqSQXXd8DF/MIkx+OhJisxRrygrtMpVfzynnoKeArEKcXbm9otDIjTzs6Mu/EVrt0rn72AXeShOupLEPs44HxnO4ENPBGi5w7VeTfD5rQgABPUMnNCoDV+V9iW0GJpG+llLsdj1LuHb5ZkRL+oswauLgKpk2f2PBRuB37S9apZKLFfoci/LoYumzUzmrCeU+gwNXmCh3DHfcXnQRjRh+KESzhM5B3DgCEXkaw6mLvSREas+bImybmQIEmbWAjOOm2QV7h1Mj2krefKeg3WhwvZ2Rvm/LeFK7cqNdmt9bS4ExRjmYSstuogUWsOXizE6NOy6/zgg322An0GL6etQ1gPQvvvN9cHuW4W5kY9m2d9tyX3T4biCi01RKqD3z0pknWgRCzAdxDi6ZWFFXAWSfzTQ+YSXHz0wK00tRRqaH9OcDkiQEvY6yJ5UTvlE4w1M10c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a956ab7e-a59b-4e03-48f0-08dc21ed6ec8
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2024 23:44:43.0803
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J9Qb6C3czi8w5NTZTKw9o0H6Az3q+6M5U1z/QDAp+xNT1JVoVyolgtS0oZMOvkwD3rl30OEvD3q2MaxT6laouiFBtn1o1vvhjU4uZSy6N34=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5305
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-30_12,2024-01-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 malwarescore=0 suspectscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401300179
X-Proofpoint-ORIG-GUID: XGlKKYDQKXYTsE7ljwjUpc2YBSejX-li
X-Proofpoint-GUID: XGlKKYDQKXYTsE7ljwjUpc2YBSejX-li

From: Long Li <leo.lilong@huawei.com>

commit 2a5db859c6825b5d50377dda9c3cc729c20cad43 upstream.

Factor out xfs_defer_pending_abort() from xfs_defer_trans_abort(), which
not use transaction parameter, so it can be used after the transaction
life cycle.

Signed-off-by: Long Li <leo.lilong@huawei.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_defer.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index bcfb6a4203cd..88388e12f8e7 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -245,21 +245,18 @@ xfs_defer_create_intents(
 	return ret;
 }
 
-/* Abort all the intents that were committed. */
 STATIC void
-xfs_defer_trans_abort(
-	struct xfs_trans		*tp,
-	struct list_head		*dop_pending)
+xfs_defer_pending_abort(
+	struct xfs_mount		*mp,
+	struct list_head		*dop_list)
 {
 	struct xfs_defer_pending	*dfp;
 	const struct xfs_defer_op_type	*ops;
 
-	trace_xfs_defer_trans_abort(tp, _RET_IP_);
-
 	/* Abort intent items that don't have a done item. */
-	list_for_each_entry(dfp, dop_pending, dfp_list) {
+	list_for_each_entry(dfp, dop_list, dfp_list) {
 		ops = defer_op_types[dfp->dfp_type];
-		trace_xfs_defer_pending_abort(tp->t_mountp, dfp);
+		trace_xfs_defer_pending_abort(mp, dfp);
 		if (dfp->dfp_intent && !dfp->dfp_done) {
 			ops->abort_intent(dfp->dfp_intent);
 			dfp->dfp_intent = NULL;
@@ -267,6 +264,16 @@ xfs_defer_trans_abort(
 	}
 }
 
+/* Abort all the intents that were committed. */
+STATIC void
+xfs_defer_trans_abort(
+	struct xfs_trans		*tp,
+	struct list_head		*dop_pending)
+{
+	trace_xfs_defer_trans_abort(tp, _RET_IP_);
+	xfs_defer_pending_abort(tp->t_mountp, dop_pending);
+}
+
 /*
  * Capture resources that the caller said not to release ("held") when the
  * transaction commits.  Caller is responsible for zero-initializing @dres.
-- 
2.39.3

