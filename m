Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07824C4332F
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Nov 2022 09:03:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbiKGJDE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Nov 2022 04:03:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbiKGJDD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Nov 2022 04:03:03 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 853E115FC0
        for <linux-xfs@vger.kernel.org>; Mon,  7 Nov 2022 01:03:02 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A77ixDf023182
        for <linux-xfs@vger.kernel.org>; Mon, 7 Nov 2022 09:03:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=e93XNYlgfX+2efxQ4Khye86kHaN9bj5/x561YMwv7y8=;
 b=MsR/kfi472xlXTWClOJdkk+6OEXqn+7VYOCuMVXHvIrWvlrf9y9lTCqb0sHLw0e12hSN
 JyE6+cO1LiyEXT58VEWuA0XEz4lvR80QTh1yca1TMtKDJShjOoVXgnbpWVHj4ROEQt0+
 zcPBt7AcjayS3+1wWZ9UUq8gIgx8UljbP5NiS4P50khyKrC+hsz902XX6wXl5xx3cibU
 Kg5w3f/OdemG4N7pITu7+GfEqRx4rNCe4zmJIjbOxPAskkt22nUfJFwwq6cOsEWKaz3H
 lsX30lNp4omX9utN31HbDIgFAQJ+7vDvT21zu4eqKh/mNBkGWEntEgGCtbSbCoA/Vuas rg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kngkw3398-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Nov 2022 09:03:01 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A77CvTv001595
        for <linux-xfs@vger.kernel.org>; Mon, 7 Nov 2022 09:03:00 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2048.outbound.protection.outlook.com [104.47.57.48])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcq0jkv9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Nov 2022 09:03:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oddQPuArvyBJ1x3Xcoj/fRG2FMYTNVwgI6vcPwau/IAE2wxOirkdskGS88tGk3RfRg0o1p1DpiAbv5Wdw14Bvm8qFFGsAVZdKXuo4/WynaFxWKIEgk86ZwSSb9w00tvHqPOAfMwy62YahyXj/nc4G5/a00J79apaFmEMLFPIa/7RB9VJFCehMNaMc+XJbF2XH0RS/YdDhn1YYDDjw3Rm0vbrLq+tLLvESspexKhsWmhl/r9/RkShwLHWTp8fpmNUUmG0q2GSDSeB/FgsIf+1Id49aAxS9/vcWVgiAptHhaYKjjy9hDSmDu9vpJOLJ2uZrSExMNUKwUJIQTmztJcbEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e93XNYlgfX+2efxQ4Khye86kHaN9bj5/x561YMwv7y8=;
 b=F/RrsP+w9ERxp3X9zKnf2EXA5dw0lXbC4vpU6/l7SpBq6S7TRYNl603C5qLjDaqsDg0FAJ74/jhLLS5JieVx2RbpjUKrT9RdJh3Ngxclpr9EF9AYYcJmeHvi3JHk0/oaI6xa6h5pTHvB4X48ouNP8pFduCs44ub6fRQpz7ccrqEHT1Q9IrIKspsvNkLhzs6jBYr9IInshEMyByAsAj9maEWBZWLccPvqQU1OCBFYWTCXALv585BvhAtq2RNH1X3JEaddwL9g6KdK5c5Wr5wwa0dGdLNFXlGgiDHlQQ5msUO5zk/YjFzknQ6DJ9jDEudbSGBEx2uP6Mw2H47wq7JLLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e93XNYlgfX+2efxQ4Khye86kHaN9bj5/x561YMwv7y8=;
 b=Q+t6j3hGwJoy1aXvLK2GtlpRy2qkGg+9bInVqESLd88VjxCoilOcdoGvahfZoCmE2NqraH1h1ZYIEd7rCG9mOnuiB1/PQUGK9qx2ILwhGm7iqWPm0UEcqcOzdw+5n7ZKKgvNGUKV+Zeqywh+RRjWVTyr5kw776DursgtGFa6Z8s=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB5848.namprd10.prod.outlook.com (2603:10b6:510:149::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Mon, 7 Nov
 2022 09:02:59 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%4]) with mapi id 15.20.5791.026; Mon, 7 Nov 2022
 09:02:58 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 07/26] xfs: get directory offset when adding directory name
Date:   Mon,  7 Nov 2022 02:01:37 -0700
Message-Id: <20221107090156.299319-8-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221107090156.299319-1-allison.henderson@oracle.com>
References: <20221107090156.299319-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0034.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::9) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB5848:EE_
X-MS-Office365-Filtering-Correlation-Id: 644c7c35-231f-4674-8eca-08dac09eddfd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MrBp9TJ3bYbe9pT6Viok4zLAPsfgHggr+Rm4HzQwplscjKrMSAxOpZ5cW5kg97Tw2UpMmDidIVrft+MUNNvfLTpy7tOb/ueJhyFxFPnImYL2GUD9/olWe1lBUCB9k5e5nRJ/aSD8/AU6bMlA7P/++lqfaTKNpMcMe/DUp/BISBawhmsDlQSxCb6Sk6h5ClOnGpkEPQrjG+P7ZQuiKBWRCEfBAeD8bIZ2uYbVVYWHzNoaD1o+/lUImWpqaHFMZr4sciHWRXzITVtOLzQDMlVroUlFsiTRkvwOq63dQ+6Rwtwdg2XXvNRg12a9HqQxW1N2cNUtpa0S9gBAUYRWoaNdCvq5gcC38Gt5g8eaCIk806HWOxjTJZTk+n+LRimxFGDieHE9Cf7O81nWBPspOVTheopC1u7iRt64EXJVMFn+dLCrWZUavT/dnacFS1lIatdGwkMpEbAHVrE1Ls7ZxhELGKPIJH+I6BWx4aCdWOxJ/WAZvTctsuhu2hq1GYcCARXwDPoykKH0Fdl+tjbT+w2TGfS3/AvId5UJf46YgFx+bZOZY3X021e3cuP5pb5fqUUd5HFSjzlV+xGbZCqJ2kKa8k1tri6m5L+M6rGqzEmHdbIp46uEpqGdBLceMENdZnzmtSrgzR0sCoJnaIVBxSs2ilrmbKSP2nuIl7gKQXCxZOhvohuJtuBV9hJsvTg2FjxLkXVN8hAAukKTF45qrmt9zA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(136003)(346002)(366004)(376002)(451199015)(36756003)(8676002)(66946007)(6916009)(66556008)(66476007)(83380400001)(2906002)(6486002)(41300700001)(5660300002)(8936002)(478600001)(6512007)(2616005)(186003)(1076003)(26005)(316002)(38100700002)(6666004)(86362001)(9686003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MKSeltDo63MGj4Ptydzc3wLRJ5qWkTwrtv/oizK+SnUcGEDqx5UMIpO7fWYy?=
 =?us-ascii?Q?+AluaSMawHINARVkeH4ryTx/CaBZZ5WKIsJZpRTaKypNBaTu1CvYAPmUd2RU?=
 =?us-ascii?Q?S2BfKxZKMpujvsfGwBBGR2GgxqYtuCMd8dkeUygq3XL/3BmDf/F3taQXOyPp?=
 =?us-ascii?Q?oTS6rbxW3W5j3VL8NC/re5sa6Cbh3PklKYYsoLl/7Pcuh7swDOvfMz4AJmug?=
 =?us-ascii?Q?nVpLYMqNHX5Ys5GY34ZShy6eVNcKcHsAoU6CUFCNlIJ8cZZrQgU6CNRHjja9?=
 =?us-ascii?Q?KkVEy/itw+riZXHnSqmMhKUg5OS6qfKysqoAUunx431sK9TUgEFTp/zawslE?=
 =?us-ascii?Q?5DMrUHy+JVKiJPkdipwtSOJw2s1x0Mtz6Jx9Nn+vVXqzICduZ/Q9oci3IZHU?=
 =?us-ascii?Q?KX3jIMdlSs3FsBJkOI9b8LbmNRwL0z55Zuc/trNoc74Ah5NSjOaE6MJpWTKs?=
 =?us-ascii?Q?cT7a9Wn+MAJKu6Q0JF4M4DP7aUw5MseHDShU5JHZWDCCbueLEQDJgungL1g0?=
 =?us-ascii?Q?Gm4IF5uzexUUg5aCiaKL96yu31NbWyeMTSji2DhLySFey6RVeRs+0UhJO/Z/?=
 =?us-ascii?Q?uwPACR4qg6fI065VMKo1Sxfkh7vW0gWXrDIrNwpcACqxPFgeHtePER8L3IFx?=
 =?us-ascii?Q?DLVZO6VW5k0SWqWba05QsgkBG96gofn5sEupWsdOlf0/AO9w0p3WqcNHrqED?=
 =?us-ascii?Q?bb2hDxT1FezhtRHxgqOxQ37vKO/rKKLJfd3Y4yUaHljtV8qhwQxBeX9TU2sX?=
 =?us-ascii?Q?3ALXE508FhjT04imu+TWFGdOgqgFLiMF3hrJ+ysZrOYJPiDNuH+UZC+9g0af?=
 =?us-ascii?Q?ypRAm7KtymxkFhjLgQZboItff+gZV5fmFj+lV3zCgl9dQcrk/l3o1XRxHdoT?=
 =?us-ascii?Q?w/XLdZuWqdMXB60n8yJ5m8/U1SpARYUT0yFog2yOEYXvzfthGHbEzU4gdyb3?=
 =?us-ascii?Q?0kGmUTBSF6CIzEeAXRI2NBK2v1Eb4dKayGKS0mUGK7pHAE0zINDrqrlCebjR?=
 =?us-ascii?Q?TTAsARDdS7WhJWycs9NIn+RoZ1jgy7C3xR7uUrQPFvEPyOppY6sKNQROCAYI?=
 =?us-ascii?Q?HTuh6agQN1VFZ10uhz9V5YfpU0XiD+FeRjZt2Lcgk5Z6MSU06MmCUABNYzyC?=
 =?us-ascii?Q?OXTlRQ9jsVVYlvagwTj6jwxRd3wonNivz5pggF9MXyYMif9r76+iWZBNRKr5?=
 =?us-ascii?Q?jOFeTzSfBbQ8KvXotV9QmpCl9arsBIx9VWISx9WGtblnquzH0/EWh+OEkAhw?=
 =?us-ascii?Q?uLy6vEJb2TbMkf4RiZOyIJGuCdALUH4+g4u7ghC7IhKeGfNe9SI+PecRLZvA?=
 =?us-ascii?Q?sE5xdlj0j04SIS4zsYEYdk302VS5iFupRea16JXF82Ro0DJ9qgHyR34Dp5va?=
 =?us-ascii?Q?hb1kHzbaaV4fkrS1c9J8HkH6iTTwAUAKYEj9J8YGGrYp/nuKUKa1UWXXdTZ7?=
 =?us-ascii?Q?AQsbxfBKzNjUSCMhPTs/+dfbdj/8MQ8RV0o8LEsFMGCN2jHUoG4hUmO9Wlzz?=
 =?us-ascii?Q?dSkAGAOcJ+z+mLBhNkrSDI1svO10+2GApdvUhD0UbB+SWlgJN2bsfEnUDmaC?=
 =?us-ascii?Q?GJr+9SMaUEP2j7iOHJBD+NSnbvTahECd8zpYagtmnNzKUknRTDFnAZlKwYBL?=
 =?us-ascii?Q?CA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 644c7c35-231f-4674-8eca-08dac09eddfd
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2022 09:02:58.8875
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QCU71K2VeqUPJMC6ulJnRIHFL71OLiRU6i8eLbSBsMqGD62aJXQ6AjKddyB4E9zi1mpxdS9Fi/SKSYmesj7EfwOQ51T+xwSbXnP2XmQhywU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5848
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_02,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211070076
X-Proofpoint-GUID: kPMpxwdcIxeu5h2-lJXkGyup34u7WpPi
X-Proofpoint-ORIG-GUID: kPMpxwdcIxeu5h2-lJXkGyup34u7WpPi
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Return the directory offset information when adding an entry to the
directory.

This offset will be used as the parent pointer offset in xfs_create,
xfs_symlink, xfs_link and xfs_rename.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_da_btree.h   | 1 +
 fs/xfs/libxfs/xfs_dir2.c       | 9 +++++++--
 fs/xfs/libxfs/xfs_dir2.h       | 2 +-
 fs/xfs/libxfs/xfs_dir2_block.c | 1 +
 fs/xfs/libxfs/xfs_dir2_leaf.c  | 2 ++
 fs/xfs/libxfs/xfs_dir2_node.c  | 2 ++
 fs/xfs/libxfs/xfs_dir2_sf.c    | 2 ++
 fs/xfs/xfs_inode.c             | 6 +++---
 fs/xfs/xfs_symlink.c           | 3 ++-
 9 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index a4b29827603f..90b86d00258f 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -81,6 +81,7 @@ typedef struct xfs_da_args {
 	int		rmtvaluelen2;	/* remote attr value length in bytes */
 	uint32_t	op_flags;	/* operation flags */
 	enum xfs_dacmp	cmpresult;	/* name compare result for lookups */
+	xfs_dir2_dataptr_t offset;	/* OUT: offset in directory */
 } xfs_da_args_t;
 
 /*
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 92bac3373f1f..69a6561c22cc 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -257,7 +257,8 @@ xfs_dir_createname(
 	struct xfs_inode	*dp,
 	const struct xfs_name	*name,
 	xfs_ino_t		inum,		/* new entry inode number */
-	xfs_extlen_t		total)		/* bmap's total block count */
+	xfs_extlen_t		total,		/* bmap's total block count */
+	xfs_dir2_dataptr_t	*offset)	/* OUT entry's dir offset */
 {
 	struct xfs_da_args	*args;
 	int			rval;
@@ -312,6 +313,10 @@ xfs_dir_createname(
 		rval = xfs_dir2_node_addname(args);
 
 out_free:
+	/* return the location that this entry was place in the parent inode */
+	if (offset)
+		*offset = args->offset;
+
 	kmem_free(args);
 	return rval;
 }
@@ -550,7 +555,7 @@ xfs_dir_canenter(
 	xfs_inode_t	*dp,
 	struct xfs_name	*name)		/* name of entry to add */
 {
-	return xfs_dir_createname(tp, dp, name, 0, 0);
+	return xfs_dir_createname(tp, dp, name, 0, 0, NULL);
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index dd39f17dd9a9..d96954478696 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -40,7 +40,7 @@ extern int xfs_dir_init(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_inode *pdp);
 extern int xfs_dir_createname(struct xfs_trans *tp, struct xfs_inode *dp,
 				const struct xfs_name *name, xfs_ino_t inum,
-				xfs_extlen_t tot);
+				xfs_extlen_t tot, xfs_dir2_dataptr_t *offset);
 extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
 				const struct xfs_name *name, xfs_ino_t *inum,
 				struct xfs_name *ci_name);
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 00f960a703b2..70aeab9d2a12 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -573,6 +573,7 @@ xfs_dir2_block_addname(
 	xfs_dir2_data_put_ftype(dp->i_mount, dep, args->filetype);
 	tagp = xfs_dir2_data_entry_tag_p(dp->i_mount, dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
+	args->offset = xfs_dir2_byte_to_dataptr((char *)dep - (char *)hdr);
 	/*
 	 * Clean up the bestfree array and log the header, tail, and entry.
 	 */
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index cb9e950a911d..9ab520b66547 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -870,6 +870,8 @@ xfs_dir2_leaf_addname(
 	xfs_dir2_data_put_ftype(dp->i_mount, dep, args->filetype);
 	tagp = xfs_dir2_data_entry_tag_p(dp->i_mount, dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
+	args->offset = xfs_dir2_db_off_to_dataptr(args->geo, use_block,
+						(char *)dep - (char *)hdr);
 	/*
 	 * Need to scan fix up the bestfree table.
 	 */
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 7a03aeb9f4c9..5a9513c036b8 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -1974,6 +1974,8 @@ xfs_dir2_node_addname_int(
 	xfs_dir2_data_put_ftype(dp->i_mount, dep, args->filetype);
 	tagp = xfs_dir2_data_entry_tag_p(dp->i_mount, dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
+	args->offset = xfs_dir2_db_off_to_dataptr(args->geo, dbno,
+						  (char *)dep - (char *)hdr);
 	xfs_dir2_data_log_entry(args, dbp, dep);
 
 	/* Rescan the freespace and log the data block if needed. */
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 8cd37e6e9d38..44bc4ba3da8a 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -485,6 +485,7 @@ xfs_dir2_sf_addname_easy(
 	memcpy(sfep->name, args->name, sfep->namelen);
 	xfs_dir2_sf_put_ino(mp, sfp, sfep, args->inumber);
 	xfs_dir2_sf_put_ftype(mp, sfep, args->filetype);
+	args->offset = xfs_dir2_byte_to_dataptr(offset);
 
 	/*
 	 * Update the header and inode.
@@ -575,6 +576,7 @@ xfs_dir2_sf_addname_hard(
 	memcpy(sfep->name, args->name, sfep->namelen);
 	xfs_dir2_sf_put_ino(mp, sfp, sfep, args->inumber);
 	xfs_dir2_sf_put_ftype(mp, sfep, args->filetype);
+	args->offset = xfs_dir2_byte_to_dataptr(offset);
 	sfp->count++;
 	if (args->inumber > XFS_DIR2_MAX_SHORT_INUM && !objchange)
 		sfp->i8count++;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 7eb65bccd8e4..7f8c99695140 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1038,7 +1038,7 @@ xfs_create(
 	unlock_dp_on_error = false;
 
 	error = xfs_dir_createname(tp, dp, name, ip->i_ino,
-					resblks - XFS_IALLOC_SPACE_RES(mp));
+				   resblks - XFS_IALLOC_SPACE_RES(mp), NULL);
 	if (error) {
 		ASSERT(error != -ENOSPC);
 		goto out_trans_cancel;
@@ -1262,7 +1262,7 @@ xfs_link(
 	}
 
 	error = xfs_dir_createname(tp, tdp, target_name, sip->i_ino,
-				   resblks);
+				   resblks, NULL);
 	if (error)
 		goto error_return;
 	xfs_trans_ichgtime(tp, tdp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
@@ -2998,7 +2998,7 @@ xfs_rename(
 		 * to account for the ".." reference from the new entry.
 		 */
 		error = xfs_dir_createname(tp, target_dp, target_name,
-					   src_ip->i_ino, spaceres);
+					   src_ip->i_ino, spaceres, NULL);
 		if (error)
 			goto out_trans_cancel;
 
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index d8e120913036..27a7d7c57015 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -314,7 +314,8 @@ xfs_symlink(
 	/*
 	 * Create the directory entry for the symlink.
 	 */
-	error = xfs_dir_createname(tp, dp, link_name, ip->i_ino, resblks);
+	error = xfs_dir_createname(tp, dp, link_name,
+			ip->i_ino, resblks, NULL);
 	if (error)
 		goto out_trans_cancel;
 	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
-- 
2.25.1

