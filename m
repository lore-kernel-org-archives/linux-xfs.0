Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D989C19F21
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Aug 2022 19:40:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234158AbiHDTke (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Aug 2022 15:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238897AbiHDTk2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Aug 2022 15:40:28 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98816BC00
        for <linux-xfs@vger.kernel.org>; Thu,  4 Aug 2022 12:40:26 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 274Hbevc021085
        for <linux-xfs@vger.kernel.org>; Thu, 4 Aug 2022 19:40:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=f5aHvGd5hQuc9cRs1aPWAQAXl6QR4yycUZQor0R62N4=;
 b=Tm1OLDABzEsRDDJ2lqm8IFH/WHvgfUbKi62YNkNOX8evk9Tt/N/KS8PauSJM6m2sHeWO
 F+TtoDTMNGa9kJyUQTNR4dbaewEhCpHvlfh3ycS5THbqB+ZOjBirduXtRFdPQQhqw6f5
 629xx9LQW/abwJaCJ21srJYrkTN6CocWJCW3zqj9RPIaOCtm7LMbB+flUhYZkHGJ7s8C
 zN72zWzWb0VO0nwDUop+YrXQS0W48Hp/a+l/aNxbXBk9bTTFFSlSasDbzEJg6y9VyoxG
 8DQhzVa/BH0xC+iACOeI/G1lwjibVzdi1yifVGatJoXOuBvZ8L3IpCV0OF2U+FJAardG nQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmu815xrr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 04 Aug 2022 19:40:26 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 274IH90f007562
        for <linux-xfs@vger.kernel.org>; Thu, 4 Aug 2022 19:40:25 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu34b93d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 04 Aug 2022 19:40:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gKdDRM4n4YDDVwHMz+4C65D6W1w5LGYgvrK9mojHeXyTajRvWP0od1woxr1As81FbB3K16weLzd318YinJTErihP2WdxwturfG1U/AHyzcJ5GYAsyM+HbxAnNb3mZi/GD/6pnNAVJEUUtUsn63QqHaT/TwI9Sd5tnQzDvyykZMimpOGH0dQSvpDFwecSrqcNXfkbIA/NVHoPzct8nc1GNDFtMb/LR1dMd05QC7hGmuZ+qrfPnOWX2P/4shoDv/vKhoMsxxge8GW7Hni0XBcipztuddBSYbk2wEAPITiYx1ooJ8YSTULLdrr7SV02Rhcr/oIVTJ337UeyzCLGdcHVng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f5aHvGd5hQuc9cRs1aPWAQAXl6QR4yycUZQor0R62N4=;
 b=ZnzOV2icryEYVdnuCtEy1dobVIdQY4FKEs16/ZXaxTb7Ng3FF7jh3zL4/v7asq0sXMemNSEr6VFKtFkc/8MkFlgExuX2xO7UMHAicnJH1uSQlwQANXf52LP4hOyU+n46pk+tLKXxPYMgHx1W/Y31yU/B+uorjIBESI8m1vQWuccHfckXerNQbtokUkQG1877rn2iOCb2siYhMJtceaFAiikYaEYg+DDYH5kwRWzapxTNQnqwcdIKgEoYkRCEmQGkaYIqzbSSah3f8Tml3HKiMpNPuPCqZgFuJXpLSjDdu1wsb+tKHGrMVBUoOrMQZIMusVaGF8sjBOZlVVopxnN3cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f5aHvGd5hQuc9cRs1aPWAQAXl6QR4yycUZQor0R62N4=;
 b=r9HxaIYBT3UzwDbjUVCH+8FARUDGQJWRfrc8s6S6Bm3leTjj+vMkfuaw+lAlnXUaWNfxt4ekxIaKN8yKvVklenvWyw5KhM/dp3umrHrw6xS2CX4sqsn24YWUyZne06q5uUouSw+VIcATH7V5Wz+nYpk84WD5iDzNPBn2+KwhonU=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DS7PR10MB5040.namprd10.prod.outlook.com (2603:10b6:5:3b0::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Thu, 4 Aug
 2022 19:40:23 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519%4]) with mapi id 15.20.5504.016; Thu, 4 Aug 2022
 19:40:23 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH RESEND v2 05/18] xfs: get directory offset when adding directory name
Date:   Thu,  4 Aug 2022 12:40:00 -0700
Message-Id: <20220804194013.99237-6-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220804194013.99237-1-allison.henderson@oracle.com>
References: <20220804194013.99237-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0198.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::23) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a83b436e-68ab-4b12-e3bf-08da76512bc5
X-MS-TrafficTypeDiagnostic: DS7PR10MB5040:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dij53wC/F6IvCshCoZsRlm2rUp+n1c/9PZUpZYQM6Xp/J598XDjARi2VdP1I5VBjNqgZMFKpqvIqwn8hds7WUK4+XDhzKUu9OH5zzmidGsGDTtM+RmqpFqR7jp3kKOLM06TQai2eH1VuyUfuiXEFAsBxwnNk2irqSszvbTodt3wdmYWkbbTzlO1DbiQIceRKUkg9L1uz0dQjvJfRq98/fjJrhsccNiMrk0tVZSDSMU93ujUlKwWb8trOWcX1o5Yrdv5mM+sTYO5G3huu4dd5yPTXu3xgl/uTd4LR65hLAy8NwGxXgrAOirEYbQpKJ3supvu1Fahv6krkLkjTMticeXqoOTaSYOToARLJZNnUjw/Ort5pn1mF7h0D2RUiyE6DYdoe6L/WkTC0tqGyjtGSNw/U4pX9aJfJc8m1z+ZYcRSrOSGrvLlI04UsJFX0V3olzn+Yr15scsrsZ6Sc+31U2pitbRrll502xmnmFx6+LGiW4Gg6sdoYnztBzLTr0nDOSF04+gLEgXTuzmKfpkz1SuCsBKXfkmZqw9LN7cA8aESUi3WNuYtiUDMGKeU2exnuGMYJGbVB26PoH9YdgD9Cl/ZLeHm5kFzGG9/Gmj4RfaV/WB1N2C+ZORLYDdaDkvqehzq74X79qT8FrdsJA1iGNXOvYe2YJs5raLHobtRx51DzWJgHtH7aan8rnVr1Y6a/HfSeo2HSZE51ZmMzmuXZGT610LAF9qlFUtrfNh6ADcnXWStV0JBnUCTCm4iSeLgkiv3RnzRrIkUTyv6+qg7CkG0IGGpOEWv4CaLtIJtsynE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(376002)(136003)(39860400002)(346002)(396003)(41300700001)(6486002)(36756003)(2616005)(6666004)(2906002)(83380400001)(478600001)(316002)(1076003)(52116002)(66556008)(66946007)(26005)(6916009)(6512007)(66476007)(6506007)(8676002)(86362001)(8936002)(186003)(38350700002)(38100700002)(5660300002)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9eSPYPp8MrDfhdLUIpLFDrPXtnApHq3R7zuA89wDdjTh5JXHsU842kMhXELA?=
 =?us-ascii?Q?ouF92NeJ5mYSmJB/Yx10rPhjkBDPWmQra8YxfN1cxOLyJKvtLViGEmtR6G03?=
 =?us-ascii?Q?p2ynTDabpk6w9Ya+vpjiAfk2rU3+uiCScPq2hyjQc+z2hltvUbDirf8A8nnz?=
 =?us-ascii?Q?1t8/JZ+xP0ouRISSREOw0hlST2+ZWBK1Dg9E2An5Qg3yUYW+OpjB/XsO9E+s?=
 =?us-ascii?Q?1mZQmFZtWrivipYkCVMSdUSTOhvaISOpr89D4fdKBErQSZZCItkNfudQ7XFD?=
 =?us-ascii?Q?zUgxLAMFxJ2tIczU1N+7MO/KD8cDiapaXULKfZ4SM7d5hOOqMWMOcd40za5j?=
 =?us-ascii?Q?smNGFwU19YxggGSJUVUvbq5lqbUnaRkW9r4MAbjIWHDnwtvK6IsLdfoIPGru?=
 =?us-ascii?Q?6gf/KXIiStQx8z0D5K3TX81ZoAd7A6J2Ft12U76jfYbSGe86fJE5g2GFoRcr?=
 =?us-ascii?Q?gRZ/lXEn5YvvUCDsu7JGlg6MK8y5SQ7+Tb4WFbQBjqRo4uGkRP8qYgtsMA1c?=
 =?us-ascii?Q?1Jrnwkh5gTIntfNmYfkPJCgZK8Z7OyRPKwlbBWXrCmQ3mYrYkyvPguEtMmk4?=
 =?us-ascii?Q?Nu323mC/yn4qbsieKoz0KFoPG/G/nISohkZkM0A07RIwN8EMSxK59gJqwBeO?=
 =?us-ascii?Q?MKgUpwz7L6n8/0pcvWaYJksCinNa7Q+rWQRfJ5lsA9zxxAnbmubAbHAclUuk?=
 =?us-ascii?Q?By4N7mvWRoUkrOR60tOnvYx/aNFrk5sQwtA9PCnabKsuSCcoEZf/Grgi4+xQ?=
 =?us-ascii?Q?XSW7kFOE0R/9C5izJqKLTUslsC8x85ZNRiWdR6h4dpvA9vmoYv5QEhcKJ+J3?=
 =?us-ascii?Q?ClxKzqoUbvwLRsjwm42K8EHU79Dv7ABRooIOJKyGmBJAF+k/Yk9Ixl/JmIqy?=
 =?us-ascii?Q?/UYOzFd++k/PsGsLo/ybGdi9YTrygcu+Os+lj0aQsOvu6y6LIVFCkHXXLWKz?=
 =?us-ascii?Q?gnMh+lfy1BW//9gCKuT6yDgrP/I05B17bdBJXDK1z+pha198FuYegw84XiF0?=
 =?us-ascii?Q?8Moo6ajf7+vMRObiqaS8owmrH3Sj1XYYeBg1mBr363/NePJ2qVS1dG2TdGSr?=
 =?us-ascii?Q?DvhqAKfbk4xxaglVA9SNMAkihSLtOcizDJWxZ09UsP6tlMggNh3nWWE/Nf1F?=
 =?us-ascii?Q?qRrENhyT2ZMJdPPvpljs1xK0x1X99f+7DH30ylfrtoGzuSCOafvKKrh4QGZQ?=
 =?us-ascii?Q?qARIQw8oi7c78eLzQOC0NCSUbTaHAXKLW1ilkRnyBbjhzDJKq2HhknvIOqbP?=
 =?us-ascii?Q?PaqKfAesG3MHVahAQlDT4DEfHZP1m2ehgZYBm3lMhoPmp/wqMdUwNFwsmO9s?=
 =?us-ascii?Q?pXjkt9y3iWiO/1jqyaojryWd8xWEWpJxNnGbGakCQ6f2r7sfTJfOGHmmgvUb?=
 =?us-ascii?Q?8a47GrfGbvGk8CEi2LAdFbrDpGEGy/GEdpj01S87vT958ci2KMuIOkmqJ+b1?=
 =?us-ascii?Q?8Ol7Wbu/VLaQO1WxDkjxsgfk2Wujhq5zyzLXgetKO6ath9sv+s1ggo3JBPW0?=
 =?us-ascii?Q?APhVDaQfhH+AaJL7Yl0FOqy/PXLydOJ2xMr7RlAyBmhIVc8whTzbMbfkkiiF?=
 =?us-ascii?Q?TTTz4mtV58hCFd6exadW+xlCNzSl7YFpg/9u/Fu3Hdy/yST9YKjpoG4GKAfe?=
 =?us-ascii?Q?Hg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a83b436e-68ab-4b12-e3bf-08da76512bc5
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 19:40:22.6726
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1PRS87y1nbc34U701ftKmyH+pVkH1A2PRvciwrEGiOPsvAPNj4fM/EG00WVp9HICLA7blo/KMo2MqVdsNgjZeV3/dfZ2mWX/6ZnVSsUiwvQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5040
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-04_03,2022-08-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208040085
X-Proofpoint-ORIG-GUID: 0V5eVN3jDlU3zk-3QyX1wocf5GgUD3U-
X-Proofpoint-GUID: 0V5eVN3jDlU3zk-3QyX1wocf5GgUD3U-
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Return the directory offset information when adding an entry to the
directory.

This offset will be used as the parent pointer offset in xfs_create,
xfs_symlink, xfs_link and xfs_rename.

[dchinner: forward ported and cleaned up]
[dchinner: no s-o-b from Mark]
[bfoster: rebased, use args->geo in dir code]
[achender: rebased, chaged __uint32_t to xfs_dir2_dataptr_t]

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
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
index ffa3df5b2893..3692de4e6716 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -79,6 +79,7 @@ typedef struct xfs_da_args {
 	int		rmtvaluelen2;	/* remote attr value length in bytes */
 	uint32_t	op_flags;	/* operation flags */
 	enum xfs_dacmp	cmpresult;	/* name compare result for lookups */
+	xfs_dir2_dataptr_t offset;	/* OUT: offset in directory */
 } xfs_da_args_t;
 
 /*
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 76eedc2756b3..c0629c2cdecc 100644
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
index b6df3c34b26a..4d1c2570b833 100644
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
index d9b66306a9a7..bd0c2f963545 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -865,6 +865,8 @@ xfs_dir2_leaf_addname(
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
index 003812fd7d35..541235b37d69 100644
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
index 2703473b13b1..08550f579551 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1039,7 +1039,7 @@ xfs_create(
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
@@ -2983,7 +2983,7 @@ xfs_rename(
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

