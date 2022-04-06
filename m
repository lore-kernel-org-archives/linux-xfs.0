Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 236BCC433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Apr 2022 09:38:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352955AbiDFJkW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Apr 2022 05:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1585755AbiDFJgq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Apr 2022 05:36:46 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F23951CC43E
        for <linux-xfs@vger.kernel.org>; Tue,  5 Apr 2022 23:20:33 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2362J6W8014737;
        Wed, 6 Apr 2022 06:20:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=BhSIiPEEwtL8Rzw7W29dd4C6M6oyqjkml1CYmlzuPEI=;
 b=OGsnVOmxANdZmPDbMYSCr+eEiOwZMc8RB1ZvmJiKf0D+7fqxnBwArVYPEVQk+OWVTGV+
 IPPd8RZ6n73jfM4vGoY0Uq7Qu/Cx1mHGJBaOttHC249TfXcRkBj+g/wscLo3Zbe6m4Ph
 WTdw/dRuX5e+aEQ+S50RFSUrbYv4ZDNBUsLJ17ywW+GvPSvrYWSkliiZaye2fifLk39C
 O6cFjDrA+VBr+KtfCRNUokuudXpcEZGL8PymMqMD4iBwgO1+We6u4iykmpb0EscrLZds
 h43DjiYlJ72s+msR+iKqXEI4YZGOXyp1FK5e2l8Hob0aQP3khytVKrfrfGmNWR5Pw+R7 vA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6ec9qrrx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Apr 2022 06:20:30 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2366BaBZ040177;
        Wed, 6 Apr 2022 06:20:30 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f6cx446qy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Apr 2022 06:20:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dP86CtlGkyLCDqZgjid3q8ufDKc2bNSKE71+GWi00lXHlw074fLdKw9qk8PqYoB5VmP1D1OLT2WMZ0qNDgPhyDVHDm0WPToHCBWI1ebknBvaXRKdH3RlyktUhGiY50bYFftkWpyckfOPZTo45W4NogDW14NjJq8x1r49zfVtOOpZZ6CuZE43uj6mmIgA5/3hgdKKPJ1wrlH9DRRNTxNfK/2VHQK8sdXh6OpeV4LRTS8+Ul8M47vEKlwIngbYIPPsVQ+DijVWxdqllqQ5mnlP+ERRrUKACmYXcHKpIh2d7/aqQtu0YmOUzsNdPu6KqrqtO/7MJ5gTsk8IVwxtvStNJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BhSIiPEEwtL8Rzw7W29dd4C6M6oyqjkml1CYmlzuPEI=;
 b=Mlq6z4JDVeW74VDTeHmB6eyVFLhs2JTDnh8pdfH2eJA0nObZKsLg5ITiLHmWLHeZVZla9Y5Fot5oZ8D7pJOsi9rbi3+t8mjOLhVoAsP3bkcFZ7CPE5EatvTnxU5kWWs6dKtIjkS5C8QV48h5r2YFgAGcSj7aeRfGVZ2il5+WWBQppwdBsGuh2mihjIPs68AfZFZ/+TrkJ6zlkW5WuK2C+6W5+L6DZ9Xm9b+MHdggTEkLx9BwyNtlHlsqgiUfRu6xlj95nUNUgaxjYte52gXMuFqsrIxUyZ3Yk7gmLplpAhw9B12yzK+sl5aFMizYhzOOH5tsaSx6IbNgK/SYXwbpbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BhSIiPEEwtL8Rzw7W29dd4C6M6oyqjkml1CYmlzuPEI=;
 b=ApWded11G71Db3LCPbVx3PLUtjsvJd6HNaU71TT7wuz6W0w/o2ZTW0cIiCK63P6snqE9gVAxmh2aDdyXBlDJAVmMUuOdvudgR3htEjh3D4HWtQBz9Ew05H7aB1PsuWCtOpF8o8SYc4kfi8KrLVFJ3z1zG1WLsyjFEQtRYUG6nqs=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by PH0PR10MB5564.namprd10.prod.outlook.com (2603:10b6:510:f3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Wed, 6 Apr
 2022 06:20:28 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d%8]) with mapi id 15.20.5144.021; Wed, 6 Apr 2022
 06:20:28 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V9 11/19] xfs: Use uint64_t to count maximum blocks that can be used by BMBT
Date:   Wed,  6 Apr 2022 11:48:55 +0530
Message-Id: <20220406061904.595597-12-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220406061904.595597-1-chandan.babu@oracle.com>
References: <20220406061904.595597-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0047.jpnprd01.prod.outlook.com
 (2603:1096:405:1::35) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: de06da46-c57a-430f-979a-08da17958b29
X-MS-TrafficTypeDiagnostic: PH0PR10MB5564:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB5564A5548F67F795BB56D649F6E79@PH0PR10MB5564.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nGvzawWOvxjPLp+MmaqADqKMB3BxeT5ykJP4pMvFOMJv3cR33z1Xz66eqx5ut1cyGpqSiWuV5KuAilCa98xHYQLGa8OHlxOw539V6+wtg+SbK/Ec80zmzwAiXv8afuhHAxLQsokmU2gEwrllAGqtDmnTEbAQKDw/Ty5xkTpDJcPlFByVPatloNKRi2g640wGqIZoDN5BrxoaE5NLv7Vb4dyoAsGPxPcZpmJM8zRreGLuH7dj9NlRpLP+njmId/2c8qLtVpmrFaybXFlriJGuDSAKTcLk89Q0Z0WmtDYh3x1I5le/VZaMBTsxAUGp+E3CQWUdrGJ+Ep4M9hVL7BVrC8a/JShwvLMrl7rhvq+taynaeRgPN3ejIg1Zxd6Tjqra4696PsHfsX7FVvQlt1VLEt0F60ej+xNNI3hdA0loJOuOKZzldvpOEkrZ9MlrcQYX5Vyp38EKVJxp6zYyiclx327hRoj27iU3e9O2YAhRB+fe3iM6Hvv7/O6RnqeYoaqW/toofYblSh+7DzAJNGCvmv5qc+ZaCQH/81IY0VldwzMAWFiKd0hHUP4sVKlIG2VlLJNuCJSIzvc5bLJJtG5j8AcNAP5wZOwK4AOT8t6u3LuhilVDRxhED9zgEUfbv//nglaAJwtFWX07l8TrhJCZBUCsqu7/Iuhz4QOZme9UkL6PAJRQx2JeRMC3quwYdAI1NOH24irj6W6P5FDRJ+sMbQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(66476007)(66946007)(6506007)(66556008)(52116002)(6512007)(6486002)(6916009)(4326008)(8676002)(6666004)(316002)(5660300002)(1076003)(8936002)(2616005)(83380400001)(86362001)(38350700002)(38100700002)(2906002)(26005)(186003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vT1ga0amyoBRu9UyqsRHJN+iVZ+861YI0IvZRk9uw9tyfCUtU/4osZHKX86z?=
 =?us-ascii?Q?L1WnoSvhJQIFMIVUESQpJBn/Y3ahh6Kg+irZeGV6epD+qVLcv6QY0obrjV6W?=
 =?us-ascii?Q?Xia1iDIhukykJTV9hCaD8dVyIsSOCSL6hT/HcsyPEYsVVQ/N/U5IDMAvd3GU?=
 =?us-ascii?Q?uM6eDF68METwAHpoJl4Qxz3/HcW6HjB29tweh6uA/bxiUrw4FRJyJvKvu5Av?=
 =?us-ascii?Q?viN5tw0L1W9Gv15cdj7hZFsXVPZGx7KSncu5a+OSTh6ggzwcUcs5BlRRZJDu?=
 =?us-ascii?Q?gq+OyCLE1jD2jyzjdw3GXQZKm7GUOO53vy6uECQo+FhtYwn3mEpGzifrH8yu?=
 =?us-ascii?Q?Zg3b51b01/S4qd4Vu37aV3Jj6NpNjAQuTGGlWwb1YM5arlGrgekxP1hv48ns?=
 =?us-ascii?Q?bAv5yDlCY55K3AiZObRjY2LtWGt8vWF0WbtEF7NXzzc2lrh6fn80ndfphz3m?=
 =?us-ascii?Q?9UWg53P3TT9oHqWVBX6lyrUkTSiAScWM8aunzyVjpjni8XcFuvzfDZyqMIqA?=
 =?us-ascii?Q?o/H5V5+2NdCoVKm934DsJKoCHvdfKu1Gj7wZZsAaqd8E9JIHUjFc+6FdpfJv?=
 =?us-ascii?Q?Q4cOsLnzScdrnDSiii5fEcXelJZIIh6Hmc5ksS65d3Qdho9c9bASB/szWDEb?=
 =?us-ascii?Q?laWFf3aBSreF4naTDkd78X0v1dXHWV1VigjfHybMp+B9+iFtsayjyGrzDy6X?=
 =?us-ascii?Q?3N302KCNSLNKPJa5za4Ilm9+MtFA6Rv23GWZ8scsj0loju6+eRUX3NyfN9HP?=
 =?us-ascii?Q?GsebehHJ7Y1WP+wRf0Hy4/dxEQAmIDaAhZge5syMUHZNY1HXr9TnC2krojUF?=
 =?us-ascii?Q?dZx0w6jlZwQC0wwwk2ZPW6QCazroaUHZ2ZJw496Br7GQIzn4Tn44apLwVr7+?=
 =?us-ascii?Q?bYhnjRDbnrulD8DYDwR7YY2PWvyMcbUCrQIZCTypWfveWrFEG5IjhDQ7M558?=
 =?us-ascii?Q?RxZVYliwd5sviI0qPDWWWTsmc6ksr+dnE6P0pbOy3Tr6SdGkZMGiC+9p+gSN?=
 =?us-ascii?Q?pPq9odIUPCuUGUNZ0BlLqgM7HvJpUfZ8BdUkbZX5JT7N4KOpYzTPFjXCRZgH?=
 =?us-ascii?Q?If3TjVzekg66fTJ/yx+p2B2JWk9tST8lIWuuwR1YI8P5EhftlSzwMi6s662K?=
 =?us-ascii?Q?nykR6VVtj5zLSAROlmKaMdZBC5zKLlbgrOLvTPEJDzeXPqqPlMAHSfAp4JTy?=
 =?us-ascii?Q?mbSL+nXtNUg7oysFML0tcEeVZe9E8p02nXYTU7B2X56g9Hndxy3BIFNc9/gX?=
 =?us-ascii?Q?fZBiw4mhMD1YFNp7Q5buJthzhBw1Rf2KGwsX3J014lHLZMlDPii+KeTVgDzy?=
 =?us-ascii?Q?uGoWp+sGNi8QsOYjLPoFtXesKWO9aSJor1LQiMEie+XI0QSGMfwOlmN9ZP3W?=
 =?us-ascii?Q?Qxw36ZY/JSn/yowIh8pIGUZz3b12CswbAS1PKK46p7AchpuVFm5/RypWg5BN?=
 =?us-ascii?Q?ZX66xIF7GwhNeSuOp31Xwvjr34zJltB12f+LLxt6t+K5lY/V5anCtH62xHzY?=
 =?us-ascii?Q?etcsAZ6tXcaiu3t0jXCz82RVpMPcczXwHiT22HmXPNA1iPDWtOZV5fEac2+K?=
 =?us-ascii?Q?BJHF2+I1q8tVWBcquYeH+9Khe6XLoOi6hFaiwCgAxSDrP9huSN0N3cFwP19t?=
 =?us-ascii?Q?v+evsRPu3fULdrUJxOQ6lk0ma9opaiMKMDCiRbV+QsRUIofhnm94XflF7P8v?=
 =?us-ascii?Q?1AEt6Qr7Rbi/Jp4LXzdEGwJTcyzL7iofkWf/LOLq19uzZ+tYp3JQYD/3QvVX?=
 =?us-ascii?Q?pJo6ozPGrjE8hLgxCCSUAqdNmNyc/FY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de06da46-c57a-430f-979a-08da17958b29
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 06:20:28.0545
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dNMSJq7UWi1q5498MJF1mdLyfSVKNbBfXt3KDAMAT8KTIbeQ8UJcTAit8Urqy91UUDFYQFzER+AuU3KSuu/g9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5564
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-06_02:2022-04-04,2022-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 mlxscore=0
 bulkscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204060027
X-Proofpoint-GUID: 1KodkOpuWFkyw56ufwFcPnNkxhzneSQe
X-Proofpoint-ORIG-GUID: 1KodkOpuWFkyw56ufwFcPnNkxhzneSQe
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 9f38e33d6ce2..b317226fb4ba 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -52,9 +52,9 @@ xfs_bmap_compute_maxlevels(
 	xfs_mount_t	*mp,		/* file system mount structure */
 	int		whichfork)	/* data or attr fork */
 {
-	int		level;		/* btree level */
-	uint		maxblocks;	/* max blocks at this level */
+	uint64_t	maxblocks;	/* max blocks at this level */
 	xfs_extnum_t	maxleafents;	/* max leaf entries possible */
+	int		level;		/* btree level */
 	int		maxrootrecs;	/* max records in root block */
 	int		minleafrecs;	/* min records in leaf block */
 	int		minnoderecs;	/* min records in node block */
@@ -88,7 +88,7 @@ xfs_bmap_compute_maxlevels(
 		if (maxblocks <= maxrootrecs)
 			maxblocks = 1;
 		else
-			maxblocks = (maxblocks + minnoderecs - 1) / minnoderecs;
+			maxblocks = howmany_64(maxblocks, minnoderecs);
 	}
 	mp->m_bm_maxlevels[whichfork] = level;
 	ASSERT(mp->m_bm_maxlevels[whichfork] <= xfs_bmbt_maxlevels_ondisk());
-- 
2.30.2

