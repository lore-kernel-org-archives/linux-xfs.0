Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 155A8C46467
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Nov 2022 21:13:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237062AbiK2VNq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:13:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237081AbiK2VNG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2022 16:13:06 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A55D58BCE
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 13:13:04 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ATIYrr4031378
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=7QXTbX0KYrG7QX1bq+3YXkeoJmVRTBZWaERF9t/o8N0=;
 b=VcQLfrYw5mwrSNG1vu7JuyZM2Hg4hmTqDSh0eeLSJl46IuB16ogVHd2PnDMnQSks33Mx
 xPDfTRYzmBVBepElxnmg/CZQuD0dP/5uIspQG3H0whk+opegEh8JcqscQIhERXNqstGV
 D14mVzGxKxekyYQwyK0Xo9tJnmpxJ+f1FdCTikE00Eq61EksNU9DSqCFTggafEtX3sQL
 dIXeUamVJ5Mi/x9hDU8/pixBpd7AN1LBTHmaaNn7f+Vcf3lm8X4fChPnFe7HMXMTCQpU
 KJF89gIM2S3iWv/T+X02u5m5ha+whTlWIyGZMiXPPPzFgN8eOifsWlQfeX6aT0/g9m9v dg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m40y3y5q2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:03 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ATK4l95027960
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:03 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3m4a2hj168-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZSOaz4MOGGXxqHIsf09fXZJZRw4H3AAMaHpJTXyum+EIZ9yrTp/+DBYnglYbMCGUiiymJ/k1U1G17dtDNLRmlCRg1TyPspyqZMbZHHaZaJjg2nyySHimpzFAjBcnmDPh2ZVFrUYL/rwBpcAY77SXJ/JSWOFN2bjIcEPMG5SaS4IMCbQSRoKaALR7zb6Fjez/4yhsHFNrFIHN6eiHaU4D5IiNpR9ZTcO3vxpmnisSQRQHSq4wKOy0pDF2YksUw3YO0tqJ/4qePYNkBpXV4mISNjHomRnxxEnBJPgd+F6re3yjItQ4qMCBUNyeM7Gvsgk6x5McPJGuxFMzEbNUwEmctQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7QXTbX0KYrG7QX1bq+3YXkeoJmVRTBZWaERF9t/o8N0=;
 b=gGLLvsrDg1bnpMaxZVquqF+/ov4ku9fYIOFoIh8DS/PDcXroaI/U5l/EnIKZ5xgQDs1z8VTOjFRQg8Prhssp7/rxlVj0Alc/sC8Z75wHgSATgw3pHsQzDWO7ISqL7lGarEio/R3AEk+6awzE3BCJJHRQWzBZ6ncgxy3/NH8flkNo96yjJugSj4FQT2YgjHjuCdfdAixPomKjHBqmzkrC4Xg9l0TKDPa8p0PJajyrp5ESGAuySqWjzQNw5XCB240IZDlPE1dwzqtRDQ716ciOVUPdX/y/JRr/bq10Fk55O90WsunjotBUGCbn9H2paxa1xIQjm9CJzk/M+cv2smQPvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7QXTbX0KYrG7QX1bq+3YXkeoJmVRTBZWaERF9t/o8N0=;
 b=nWdh1ib6nWiw9Pg28jXLDtYvP7FVoXigrvm8EzPvHV6KTEP7LZPXvG1378gtwuvY5DEi5iMMTwPeq+Y8oTkMymD5UKd98rFhcCai367w01xReQ2+rKk9YqUJy7OH7nS7Hs2SCp/hdA0GhCOAKjwS0h8wqcSlG4AOXg86rfddWao=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DM4PR10MB6205.namprd10.prod.outlook.com (2603:10b6:8:88::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.23; Tue, 29 Nov 2022 21:13:00 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c%4]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 21:13:00 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v6 10/27] xfs: get directory offset when replacing a directory name
Date:   Tue, 29 Nov 2022 14:12:25 -0700
Message-Id: <20221129211242.2689855-11-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221129211242.2689855-1-allison.henderson@oracle.com>
References: <20221129211242.2689855-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0073.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::14) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|DM4PR10MB6205:EE_
X-MS-Office365-Filtering-Correlation-Id: f5590fef-05a7-4c3b-a803-08dad24e7f0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R3BkX1T7yuSpVWldf4RuXp+JbY+BgGoSgcvDhlSGFjFO9D1mZmHGdqOlFzllE1XMX1KEXg7uebQpRxx84LzYwUa3djFO4hY7QBHCWfbkmBSgCiyq5Rfr/QCKexMlEzrFB7Ua++LD1wzINc7Upb0hT/r7F/IrVleTE13lyR1n3CyU2d7+fVyHvLMKFW1QMBXgufQohcTLiQL0AsX2D4Pp6BzcwL9CFNn7hAoBLId0N1Ge3QfhdWsZYnLfte6g3Xuau7b545nc38swCMrkGNESpx0FnrcLntMsdKIos7m5le85Jl7A62Sv3g+iXW8Yweji3A/1pHuKaSV/Gqpca+HxrcesTZ5pT5vhXoe5Fj6lhmw9CtH5meAyIQQm9S3dMJHJOuSNsRQ8SHx7al1ukzjmNjZQsX2ncOHsLEQLlhVrET6B+nWBz+SWQ6eGi7amkZdCv4+/MfMlv+yWI6+D8nodVegqnTJAdTX3TwDaAsv8fvcdlRa0LM9Iy5SRyY5iXBA7IadBVlLjswTKQZqHDcpACKNL2A5pS2HKxdlY8/feTiFZBBmOu5zoJp8JX0YZWu1Ch1Gc0kr+yyEDPQ2+iFtwAa5r5+9444zukTMLg5KeEO0MRFxG8bMQUbPqS66XfVff
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(136003)(376002)(39860400002)(366004)(451199015)(316002)(36756003)(83380400001)(6486002)(6916009)(1076003)(2616005)(186003)(2906002)(41300700001)(66556008)(66946007)(8676002)(66476007)(86362001)(8936002)(38100700002)(6512007)(5660300002)(9686003)(26005)(6666004)(6506007)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?z5EXroKepcyjqSFel1G059C7LQCQ5MTTBxH4fQ6H1vZ/Ktps+gsnzldQXpHH?=
 =?us-ascii?Q?Iqe6FeAuBBClH1p9BNiw0bEczKHvSNvJl3KEWwj2RuAr0xFnINUd98+69wJw?=
 =?us-ascii?Q?JGH6Wx9OaWAL9G6RCDWB0GqkoNNKnnTehGKZqpC/h2Kz6l9pHDhySSBekx+d?=
 =?us-ascii?Q?2pcA3Re8qFMlwbhUFKiCb/fJPNLipyjLkP53a+dmiys5S+QPuXti78gTonnc?=
 =?us-ascii?Q?4n0aFMpJ4o4gPF4BcVJLEsqEJzsV3JaznUCfuNejptdH4qipiziSQcL4IUnU?=
 =?us-ascii?Q?f779tXTNszi47psT7pp/lcF6WPIc8/GTTzdhi8OAe0+px6z7OLPEnqrpPYN8?=
 =?us-ascii?Q?uoCUuwovZCWGAyH59RcQeptUOQ/7BIlfCaT+bMI/10uiJsm+WvnWyuef8aVA?=
 =?us-ascii?Q?YrPQqf0NKc/rd5k5rrp23M40GMV8l3seDm+Jayprst5kWEXQXzuv9qerEnOS?=
 =?us-ascii?Q?ar3FN0Yxse2Cn5fCWme4qcqkjeDV5sjsIJymqtpJst3iTTomqBZWpKUu20vw?=
 =?us-ascii?Q?4a0l4kkAAR+MIPvARTpGk/N4gNj4GCsjLQGdiKjMSkQsIZhC8SL0gWktJaTz?=
 =?us-ascii?Q?MrIkVzjFH3u2naRROm0jCMkB9pmo339brE6JarT8pBiSYldcPAxipvuSJot+?=
 =?us-ascii?Q?7p2EEE7tjtlSJuKzITLtmq7tJ2sNjAWy4Tqn/0oP2oIenj31zySNHdwkqZYM?=
 =?us-ascii?Q?qTMwFh4dqqVifNFBxhilp1MzbXx3syBXp+2z5q0ZpqKHHNBgubcdGvEG1qq7?=
 =?us-ascii?Q?w6sNletk3RJLytQh9VPK4IAwx2lHLBqa3s+5mwrBaveMmjVsAtzfHlcGsd1i?=
 =?us-ascii?Q?+DWN8JzQUpSv4FkGsvaqrmuVVv1m2VowVWPLQ4NukApXhxAcq7TPg+G2t5wm?=
 =?us-ascii?Q?5GdI4Y5roe+99wRVOs7fbYNZjA1xl9j2gi6oL/ECSOjWzVRZc5c51Osw+mOX?=
 =?us-ascii?Q?q2uhyX6r4eyO/b82zkAP2aq8HyV3xDx16lWo0N/vjgygfMLQcQQQwutnJsam?=
 =?us-ascii?Q?tmOJDU9cvhdJE4ZMkZ5Nj/VIPlA8obgoT1DHj5bdXbBaVLYW4my1xtcQiDMF?=
 =?us-ascii?Q?xy3k9PujD44A84q8Sd0zNQv1CMCBZNlY9Rky1kibPLSByhb2ofS39SIsyWjn?=
 =?us-ascii?Q?LzBptZYSKKP7bsDnlFz7cgC0kdzIrDp1TXCJYuscRinuIL/w6RER6xKqYt/Z?=
 =?us-ascii?Q?P1ZeLpbimTeDvHio1YPHENZFFEmWKbFWsEL1SFS3tXNNbdnyCyFNGpnuWLQ/?=
 =?us-ascii?Q?lPMbxINPcKxN+pcoVeN5DKaGBKA8z5F6u5FRdmdQVSAphFF5mdaqQgaPaxVW?=
 =?us-ascii?Q?6l+lEMaKzEZQe0b0vvPut2jX+h9Z7F2+bD5vnf/qSRfC7N5KEDBMAZWOm8hb?=
 =?us-ascii?Q?kaiKaFbzyg7SVTko2eSvI3Wn6BY5EkXAHc2T0YJX1oaOVufLWxwKUUL1sTNq?=
 =?us-ascii?Q?ynnvRZ9AdLDKtgcTEMNY/JQ+7dboMOkAxJD7T5W1kyC0jJ6BOnIjupw/rktO?=
 =?us-ascii?Q?gK6tqFSdBAd2+D55+SRGeGyspdoUhVr15ILSUUQ6N3UG3ONIypiiRW0mnuRb?=
 =?us-ascii?Q?96rG0INGhxQ7X8kOary9t8fVruy9eH4rc1nV1+8320L8o3A41riNTICNp5Yp?=
 =?us-ascii?Q?RQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 2yyoyLlAyXQ1BVm77cN46VbbRzWCEL+ni41EaSV9tQ0vl9jjfjBZ0IiQlrQGdxPrhe9L05sO6CBD0YbhfY2X6urrkyIdb75oAJurhz9WVg7Ygoowy324ieXY0WHAM5LBqBkD8ILvSfCxuLgvRQHPindx+5oz/in0FEJIpRR1uhhnW2d3k+AHi3J/qpBiLr8e3QD0N9Y4/aSmJG7qTJ/soKnPETAHD7kKP7KYoSpQxiZ+U6Ss4y/ULG7j831/Je4PPMgqMgXvNCKycPYe2JrHiduCANhNkQbzVZkeClvgMECvdUszl0g+HxFsBLQx54b2cCswPJgtetJNqpJ35UE/0eo1T0GLVBs4C/+L8ajc7Dh7yYcmqDuS4L1l45KGQTTeJ50JpplSEsbMTrt0F7JhLrez9PIhWPSQl9z6JsVnWtm7pO1J590H4fd2BIDWMmVD2BaBtGjsTvE7QD3rw9eKEjJJMEWKRN+aFCJSP0f4AV/MKMDH7mAgYpmFo2WVBdI4oh/OEiACfmd3jnAPhBulATwlNJE28o6BGK1VSyhDNqqkGeGCFNsCoKjqSh3HWimLDxABDsF+WHPrjF+Pe6u800soRVjx52w3vOJNK+YwEfhNBe0RuKNIdWeBKtUzzGNiUS9/GNfccyJYGJjQLGEv/z19baIsnS+XHD3Asok6gUx2pjvp3lKSZQnbjSJ7/2rzD+cYb3D6OjlI67RUzkJhWiuDMmKROauNGuEmzczwKkY4/PUN8wMwbBEImzfmcBhq7z6gT9Y5707JFc7TGM0pDA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5590fef-05a7-4c3b-a803-08dad24e7f0f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 21:13:00.8923
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QXEs1LVkdqfSYPc9Wh7DN0IBGPSe64XB5V5NRUf0WOrPPR9SI7HCDt/gqVa3nYFbUD4eBVwgNVn88Wp9eychuJOllHIMKc0FFIgUgpGxWeI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6205
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-29_12,2022-11-29_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=977 spamscore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211290125
X-Proofpoint-GUID: UyicLJbChdwNIKU-gNWOhSN05FS15zVm
X-Proofpoint-ORIG-GUID: UyicLJbChdwNIKU-gNWOhSN05FS15zVm
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Return the directory offset information when replacing an entry to the
directory.

This offset will be used as the parent pointer offset in xfs_rename.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_dir2.c       |  8 ++++++--
 fs/xfs/libxfs/xfs_dir2.h       |  2 +-
 fs/xfs/libxfs/xfs_dir2_block.c |  4 ++--
 fs/xfs/libxfs/xfs_dir2_leaf.c  |  1 +
 fs/xfs/libxfs/xfs_dir2_node.c  |  1 +
 fs/xfs/libxfs/xfs_dir2_sf.c    |  2 ++
 fs/xfs/xfs_inode.c             | 16 ++++++++--------
 7 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 891c1f701f53..c1a9394d7478 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -482,7 +482,7 @@ xfs_dir_removename(
 	else
 		rval = xfs_dir2_node_removename(args);
 out_free:
-	if (offset)
+	if (!rval && offset)
 		*offset = args->offset;
 
 	kmem_free(args);
@@ -498,7 +498,8 @@ xfs_dir_replace(
 	struct xfs_inode	*dp,
 	const struct xfs_name	*name,		/* name of entry to replace */
 	xfs_ino_t		inum,		/* new inode number */
-	xfs_extlen_t		total)		/* bmap's total block count */
+	xfs_extlen_t		total,		/* bmap's total block count */
+	xfs_dir2_dataptr_t	*offset)	/* OUT: offset in directory */
 {
 	struct xfs_da_args	*args;
 	int			rval;
@@ -546,6 +547,9 @@ xfs_dir_replace(
 	else
 		rval = xfs_dir2_node_replace(args);
 out_free:
+	if (offset)
+		*offset = args->offset;
+
 	kmem_free(args);
 	return rval;
 }
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 0c2d7c0af78f..ff59f009d1fd 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -50,7 +50,7 @@ extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
 				xfs_dir2_dataptr_t *offset);
 extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
 				const struct xfs_name *name, xfs_ino_t inum,
-				xfs_extlen_t tot);
+				xfs_extlen_t tot, xfs_dir2_dataptr_t *offset);
 extern int xfs_dir_canenter(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name);
 
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index d36f3f1491da..0f3a03e87278 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -885,9 +885,9 @@ xfs_dir2_block_replace(
 	/*
 	 * Point to the data entry we need to change.
 	 */
+	args->offset = be32_to_cpu(blp[ent].address);
 	dep = (xfs_dir2_data_entry_t *)((char *)hdr +
-			xfs_dir2_dataptr_to_off(args->geo,
-						be32_to_cpu(blp[ent].address)));
+			xfs_dir2_dataptr_to_off(args->geo, args->offset));
 	ASSERT(be64_to_cpu(dep->inumber) != args->inumber);
 	/*
 	 * Change the inode number to the new value.
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index b4a066259d97..fe75ffadace9 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -1523,6 +1523,7 @@ xfs_dir2_leaf_replace(
 	/*
 	 * Point to the data entry.
 	 */
+	args->offset = be32_to_cpu(lep->address);
 	dep = (xfs_dir2_data_entry_t *)
 	      ((char *)dbp->b_addr +
 	       xfs_dir2_dataptr_to_off(args->geo, be32_to_cpu(lep->address)));
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 39cbdeafa0f6..53cd0d5d94f7 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -2242,6 +2242,7 @@ xfs_dir2_node_replace(
 		hdr = state->extrablk.bp->b_addr;
 		ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
 		       hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC));
+		args->offset = be32_to_cpu(leafhdr.ents[blk->index].address);
 		dep = (xfs_dir2_data_entry_t *)
 		      ((char *)hdr +
 		       xfs_dir2_dataptr_to_off(args->geo,
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index b49578a547b3..032c65804610 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -1107,6 +1107,8 @@ xfs_dir2_sf_replace(
 				xfs_dir2_sf_put_ino(mp, sfp, sfep,
 						args->inumber);
 				xfs_dir2_sf_put_ftype(mp, sfep, args->filetype);
+				args->offset = xfs_dir2_byte_to_dataptr(
+						  xfs_dir2_sf_get_offset(sfep));
 				break;
 			}
 		}
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 580eca532290..6bb5889a71f3 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2487,7 +2487,7 @@ xfs_remove(
 		 */
 		if (dp->i_ino != tp->t_mountp->m_sb.sb_rootino) {
 			error = xfs_dir_replace(tp, ip, &xfs_name_dotdot,
-					tp->t_mountp->m_sb.sb_rootino, 0);
+					tp->t_mountp->m_sb.sb_rootino, 0, NULL);
 			if (error)
 				goto out_trans_cancel;
 		}
@@ -2642,12 +2642,12 @@ xfs_cross_rename(
 	int		dp2_flags = 0;
 
 	/* Swap inode number for dirent in first parent */
-	error = xfs_dir_replace(tp, dp1, name1, ip2->i_ino, spaceres);
+	error = xfs_dir_replace(tp, dp1, name1, ip2->i_ino, spaceres, NULL);
 	if (error)
 		goto out_trans_abort;
 
 	/* Swap inode number for dirent in second parent */
-	error = xfs_dir_replace(tp, dp2, name2, ip1->i_ino, spaceres);
+	error = xfs_dir_replace(tp, dp2, name2, ip1->i_ino, spaceres, NULL);
 	if (error)
 		goto out_trans_abort;
 
@@ -2661,7 +2661,7 @@ xfs_cross_rename(
 
 		if (S_ISDIR(VFS_I(ip2)->i_mode)) {
 			error = xfs_dir_replace(tp, ip2, &xfs_name_dotdot,
-						dp1->i_ino, spaceres);
+						dp1->i_ino, spaceres, NULL);
 			if (error)
 				goto out_trans_abort;
 
@@ -2685,7 +2685,7 @@ xfs_cross_rename(
 
 		if (S_ISDIR(VFS_I(ip1)->i_mode)) {
 			error = xfs_dir_replace(tp, ip1, &xfs_name_dotdot,
-						dp2->i_ino, spaceres);
+						dp2->i_ino, spaceres, NULL);
 			if (error)
 				goto out_trans_abort;
 
@@ -3019,7 +3019,7 @@ xfs_rename(
 		 * name at the destination directory, remove it first.
 		 */
 		error = xfs_dir_replace(tp, target_dp, target_name,
-					src_ip->i_ino, spaceres);
+					src_ip->i_ino, spaceres, NULL);
 		if (error)
 			goto out_trans_cancel;
 
@@ -3053,7 +3053,7 @@ xfs_rename(
 		 * directory.
 		 */
 		error = xfs_dir_replace(tp, src_ip, &xfs_name_dotdot,
-					target_dp->i_ino, spaceres);
+					target_dp->i_ino, spaceres, NULL);
 		ASSERT(error != -EEXIST);
 		if (error)
 			goto out_trans_cancel;
@@ -3092,7 +3092,7 @@ xfs_rename(
 	 */
 	if (wip)
 		error = xfs_dir_replace(tp, src_dp, src_name, wip->i_ino,
-					spaceres);
+					spaceres, NULL);
 	else
 		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
 					   spaceres, NULL);
-- 
2.25.1

