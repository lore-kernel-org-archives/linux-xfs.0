Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAB5BC43462
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 08:09:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A298561419
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 08:09:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235983AbhD1IK1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Apr 2021 04:10:27 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35820 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237331AbhD1IKW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Apr 2021 04:10:22 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13S7xPEt010071
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 08:09:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=iH8DBhHTdRUsmaxPrKlOxJnFoOqyqiNHSPKWeZB5Nd4=;
 b=GsYDqNWU2ltFT4dzD7MCWdSy7bFsTR2oVyw5iihLjZOwGRQe3/3TbnywCP6IiDAGlVHG
 op8BT4TsaX/l3ysfAGBgVutm+V/HS8gng7/YmngOPJb/cgiozqX6Z368dyE/a+GtQVeq
 QjJOWbdm1Yrm8fu26J0Uoyhd9uAuyNYuzBtnQs0wLPjTpdU10465YSaBM7QOKulocpid
 G5c/ponkr2vomfE27B6V7hHuPdTJ9a6HW0tQsiSp50FihvrlZT40jei6uPZvGAX8P/pC
 1SEm+fHS7VTrZVeTN+EX2mvmKDIX7gj/obuhPnBY2p0nhXQVcMf7W4044IntnbQ7C2Hq Ew== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 385afsyw33-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 08:09:37 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13S80oJk196107
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 08:09:37 GMT
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2051.outbound.protection.outlook.com [104.47.45.51])
        by userp3030.oracle.com with ESMTP id 3848ey69y1-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 08:09:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c4tml335Co0/8sOYtelxKOf+2yf8ny6Obd2cDQ+H7MNGwUCnynDjiOaeT0ZNr1ky/Q6oR630Ol/89pu3WJy8JXWZ51U6y5YFy1BE9kjAKgSLxQ+iINJuLRvOMPTYJK+vRC+IaHkUqeqsVI8bLibioWOmwzY7Uyf7Us/u07snEwdEoM9VZQL0O5xJWqVC2uyThH97t0DXItPMD5yG7TP82mQ8JIzLRuQEtfV/NVXKhGqaNvAGXWIcl8EzJw6pYFM0aiCE39FswGxS+p+HraTLEs3u6q+GK72lWAk44r+/pAWXSfARd0Pa8Hm3Mnr2OnhzwI48OIYsS7w6sQXAdjgEhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iH8DBhHTdRUsmaxPrKlOxJnFoOqyqiNHSPKWeZB5Nd4=;
 b=clY4uHWaF5lHNWTDu/A3ba0Jad+LkuRYxkJW/ggB/SqDLNxQ1si4BW02bkAMJGf2GDFZXq7F97vPGB2oJ1P4d9I6Pk5RY9qRYM2MTi6bgAyMUIYoorcEKLjWME3/Sh6c6MogeACD4s/QGpNOghhpt9FDU1m8wXQ/6YQSqE2dWOb7KPBE9zR7numZ2giGlVqtEJyMHLzkPepa3GJwDC4ahXkgo5QH6+w/qOihIcvn5eyS/axgiKpFtHJmTEf7Ram6uwTSKo9wPWs80ZEL1IKRc9URXUqEtqBVQ2V3dlBS7OgDckHAeHvSoFjFO3M5/BgmTe+iVWnyD34lABTpMiPO8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iH8DBhHTdRUsmaxPrKlOxJnFoOqyqiNHSPKWeZB5Nd4=;
 b=pDTtIeFl8qRmuEL4DgOCMT2AvG/DnZfgFxtQw1P8ZdNKwAXtTMGgf5Q2oGoBMuSVEW10E60P3EEKJcGldEPQwM+4qVBIIi58ZzPZc4vEsxeoYVUZFUvqlSvAQKq6d2ZGhzIaBs0C4JXjvl6ZWjFJztY7JmJZsrTQ1frneWz0zE0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB4086.namprd10.prod.outlook.com (2603:10b6:a03:129::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Wed, 28 Apr
 2021 08:09:34 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4042.024; Wed, 28 Apr 2021
 08:09:34 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v18 07/11] xfs: Hoist xfs_attr_node_addname
Date:   Wed, 28 Apr 2021 01:09:15 -0700
Message-Id: <20210428080919.20331-8-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210428080919.20331-1-allison.henderson@oracle.com>
References: <20210428080919.20331-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.222.141]
X-ClientProxiedBy: BYAPR05CA0051.namprd05.prod.outlook.com
 (2603:10b6:a03:74::28) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.222.141) by BYAPR05CA0051.namprd05.prod.outlook.com (2603:10b6:a03:74::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.16 via Frontend Transport; Wed, 28 Apr 2021 08:09:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e094e1e5-f78f-490a-845b-08d90a1cf51c
X-MS-TrafficTypeDiagnostic: BYAPR10MB4086:
X-Microsoft-Antispam-PRVS: <BYAPR10MB40861FB8A80D6B376281B38195409@BYAPR10MB4086.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BW04TNjW++CWpJMCX8bk5cNBi1Cb0z4zfLwkU6FRGulk9VsBhcZrQzEBWHlnS/K/eFaIt4iSIo5FcLK0Cr6OUzJusahttQwcOe4a2hTXUtBqWInSAwFdI/psQGSaYL1935+nP9VaCbD3jlBih4Ube89Lmy+TL3GHdGivEOT5LwblgrhPl9BM+xt8RHTkGa3icMAkko2Q/OL1MgsOqiBt5i/C3xocsdc6ErfpEJc5OtqlPtm/N/buWCPal60fTAOn3bzaeyiLICHn4OnHN17JILqqQmF+6uZjlZhfDmZ8xqK2zQGVpt0+faje4xBEswdWgDSvtXvymY5HupZtOvwbcV56d809B4q8q/a5vEjj9M4yQAVfvtb7EzuNoiQefUtMt6cVLnvVP0q+iRDCgya2itTEaRh/ZOOGT1VbY8AQskMtfAicJ2x2UTvNP10JDaNTXTsPNKkDQqL5weUvqQrUGFES/A8w8Q/Sdodr3PDxMIzzHwNnKPNmcwEtutKB9EPwTrhwLu9EBh+TBB/rsvL3//tanjSnyjFQxCjT0g2qzTeyubJwVGhkSW6nrxC+pydnmsB6n94nrBeC98oTLg4ELkDnx8YwM8lMfR1MLWuxL7pwUkKnTAqbFYvqD98MtazxKrt4lHlySeLslSidH2r+oAHCWhXjADVWAJ0X52fwWQSXa1A5zLtCjMHfoUOaAsGI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(136003)(39860400002)(396003)(346002)(83380400001)(8936002)(52116002)(6506007)(66946007)(36756003)(316002)(66476007)(26005)(956004)(6916009)(6486002)(2616005)(6666004)(6512007)(8676002)(478600001)(2906002)(86362001)(1076003)(5660300002)(16526019)(66556008)(186003)(38350700002)(44832011)(38100700002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?kO/PvEi9qT8yO1220CdHO38R1WcFqBiE9JDI+nNJwYoH3GvaYCIw/rt4oFIP?=
 =?us-ascii?Q?aNNpXNNxSaWxklHuV323B+C9sfGq5/jPeTgFJqsC1TH5fiKkLI8r5ytpH1vl?=
 =?us-ascii?Q?0fszSxiVXbRMKLf6KTidfiRycpx9chaZwJvOrBb2eXd7QAegtCM8HoZcYZNw?=
 =?us-ascii?Q?rBZZkxRgQQhE1Djluh4fiCVAo74HbDaKnU7yaHlBcFSTTWq00ZUfzj0/9N1s?=
 =?us-ascii?Q?w6UgGNWHwbmUEFPlMtBLwzV9x5Usgjr/tDTnSC/PNVf+fQowx7x7R3ZeqNS3?=
 =?us-ascii?Q?nosaUa5XNHGg3sKD23IFxGMTx8/PbUpSQm58IH+gU6zTjcW9X+bc1r8yaF93?=
 =?us-ascii?Q?y+h2wbPz1gRpDOIQWlS57xYAyTvMp1v/aUciPldQO23hGyFcF1q+O6I0ViQb?=
 =?us-ascii?Q?jdjN85epOdIWVTSIYTgig4IFWYh3HqT9spynqeSYBJht3Haw3VTKWmTFw9x2?=
 =?us-ascii?Q?M03E1Il2TgCQykkVT4IB5VY40Zu1IYx8/nI46y/CLGz4yN6sSzPDsQsuS2k+?=
 =?us-ascii?Q?gv+Di1pBl/OlLPeL8QOAtPFY8YyxO/NwGy1NDx0YSoOcxpj1bi4ZCOS6SFbA?=
 =?us-ascii?Q?SzEfSViqStWFP9xG7BOBLsO6wczKxsORvJ/KyWhrUao0843jGXsn0mqkeNjV?=
 =?us-ascii?Q?jlVIixQJgYN46z1RH2UswDTh1dfRk+l71OwflfAiM9OIJfyOAHgHaX8onQYx?=
 =?us-ascii?Q?L9BbiOG0EceJ39gZEsLqkmjVTiv4hKc9Ow4qeJ8UtbPKAgCmr+p43+ODaDi7?=
 =?us-ascii?Q?Hj0JqHiJTEqfSbb5BlvPt+XJ9c1VzgYpc+deNJRWBSsqgwQT9yq/gMarF/5L?=
 =?us-ascii?Q?lhbcrXjDZMancbxPmbMDI3T3MmYcWTlg+Sz2WQNPsoV/CkgJ70DKqBKxtr3+?=
 =?us-ascii?Q?EGKxK2It94nq+k8qlcScf7OwofuC01FC4lzpLXKieNQDYRFsoLaEV9qZan7d?=
 =?us-ascii?Q?JqRnPWXUF3Myy9UhHhrv97u6KeLGhHXFbBE/L+gBt2FTAqacnmPk+98ABc/2?=
 =?us-ascii?Q?orLfdSq+jl1H7ronRx9DqtGMi6WkEpFCI998Y1XObu+biIWivoriejqzWUy4?=
 =?us-ascii?Q?UaOazyhtHXfnWx/HSL0Jq45risQ4CEMJi+owxNoF0CeN8YERkuhGbKb8p/nv?=
 =?us-ascii?Q?pginIv/36YMKSuRdEPGo1QGyUNIwPerrfo2vWXxhDfVx6XJ2ys4pYyFvckWB?=
 =?us-ascii?Q?GUyNsi6jjaqNkxbbnZMHqqu1BA/PFOF1K8+l0QQWC5/PjePyIVqTfpjdPOiK?=
 =?us-ascii?Q?I7D42e34QlK/YHobqGF9Qbt9gTjupJr+0VAz+2lLpXU02P/WHzlpafkLinHQ?=
 =?us-ascii?Q?5smqLCL9OWCMF9IP3eZwV7Vs?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e094e1e5-f78f-490a-845b-08d90a1cf51c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2021 08:09:33.9076
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EX3WVfmr9gdV3Uszg3otpQ4lm5Q+PyzI31T0ErRmX1kPXMmHXxpzH1oZdNdTkZjKAaLfUnWdTUkiU4mAFuK27irnbM2ZPs6aoAoc4Sg+kek=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB4086
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9967 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104280054
X-Proofpoint-GUID: 11rPuNzMc5Ns9CkgyWhJxQgDqXTXjxIX
X-Proofpoint-ORIG-GUID: 11rPuNzMc5Ns9CkgyWhJxQgDqXTXjxIX
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9967 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 mlxlogscore=999 malwarescore=0 phishscore=0 priorityscore=1501
 clxscore=1015 spamscore=0 bulkscore=0 suspectscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104280054
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch hoists the later half of xfs_attr_node_addname into
the calling function.  We do this because it is this area that
will need the most state management, and we want to keep such
code in the same scope as much as possible

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_attr.c | 159 ++++++++++++++++++++++-------------------------
 1 file changed, 75 insertions(+), 84 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 8a60534..3cc09e2 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -52,6 +52,7 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
  * Internal routines when attribute list is more than one block.
  */
 STATIC int xfs_attr_node_get(xfs_da_args_t *args);
+STATIC void xfs_attr_restore_rmt_blk(struct xfs_da_args *args);
 STATIC int xfs_attr_node_addname(struct xfs_da_args *args,
 				 struct xfs_da_state *state);
 STATIC int xfs_attr_node_addname_find_attr(struct xfs_da_args *args,
@@ -290,8 +291,8 @@ xfs_attr_set_args(
 	struct xfs_da_args	*args)
 {
 	struct xfs_inode	*dp = args->dp;
-	struct xfs_da_state     *state;
-	int			error;
+	struct xfs_da_state     *state = NULL;
+	int			error = 0;
 
 	/*
 	 * If the attribute list is already in leaf format, jump straight to
@@ -342,7 +343,75 @@ xfs_attr_set_args(
 			return error;
 		error = xfs_attr_node_addname(args, state);
 	} while (error == -EAGAIN);
+	if (error)
+		return error;
 
+	/*
+	 * Commit the leaf addition or btree split and start the next
+	 * trans in the chain.
+	 */
+	error = xfs_trans_roll_inode(&args->trans, dp);
+	if (error)
+		goto out;
+
+	/*
+	 * If there was an out-of-line value, allocate the blocks we
+	 * identified for its storage and copy the value.  This is done
+	 * after we create the attribute so that we don't overflow the
+	 * maximum size of a transaction and/or hit a deadlock.
+	 */
+	if (args->rmtblkno > 0) {
+		error = xfs_attr_rmtval_set(args);
+		if (error)
+			return error;
+	}
+
+	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
+		/*
+		 * Added a "remote" value, just clear the incomplete flag.
+		 */
+		if (args->rmtblkno > 0)
+			error = xfs_attr3_leaf_clearflag(args);
+		goto out;
+	}
+
+	/*
+	 * If this is an atomic rename operation, we must "flip" the incomplete
+	 * flags on the "new" and "old" attribute/value pairs so that one
+	 * disappears and one appears atomically.  Then we must remove the "old"
+	 * attribute/value pair.
+	 *
+	 * In a separate transaction, set the incomplete flag on the "old" attr
+	 * and clear the incomplete flag on the "new" attr.
+	 */
+	error = xfs_attr3_leaf_flipflags(args);
+	if (error)
+		goto out;
+	/*
+	 * Commit the flag value change and start the next trans in series
+	 */
+	error = xfs_trans_roll_inode(&args->trans, args->dp);
+	if (error)
+		goto out;
+
+	/*
+	 * Dismantle the "old" attribute/value pair by removing a "remote" value
+	 * (if it exists).
+	 */
+	xfs_attr_restore_rmt_blk(args);
+
+	if (args->rmtblkno) {
+		error = xfs_attr_rmtval_invalidate(args);
+		if (error)
+			return error;
+
+		error = xfs_attr_rmtval_remove(args);
+		if (error)
+			return error;
+	}
+
+	error = xfs_attr_node_addname_clear_incomplete(args);
+out:
 	return error;
 }
 
@@ -968,7 +1037,7 @@ xfs_attr_node_addname(
 {
 	struct xfs_da_state_blk	*blk;
 	struct xfs_inode	*dp;
-	int			retval, error;
+	int			error;
 
 	trace_xfs_attr_node_addname(args);
 
@@ -976,8 +1045,8 @@ xfs_attr_node_addname(
 	blk = &state->path.blk[state->path.active-1];
 	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
 
-	retval = xfs_attr3_leaf_add(blk->bp, state->args);
-	if (retval == -ENOSPC) {
+	error = xfs_attr3_leaf_add(blk->bp, state->args);
+	if (error == -ENOSPC) {
 		if (state->path.active == 1) {
 			/*
 			 * Its really a single leaf node, but it had
@@ -1023,88 +1092,10 @@ xfs_attr_node_addname(
 		xfs_da3_fixhashpath(state, &state->path);
 	}
 
-	/*
-	 * Kill the state structure, we're done with it and need to
-	 * allow the buffers to come back later.
-	 */
-	xfs_da_state_free(state);
-	state = NULL;
-
-	/*
-	 * Commit the leaf addition or btree split and start the next
-	 * trans in the chain.
-	 */
-	error = xfs_trans_roll_inode(&args->trans, dp);
-	if (error)
-		goto out;
-
-	/*
-	 * If there was an out-of-line value, allocate the blocks we
-	 * identified for its storage and copy the value.  This is done
-	 * after we create the attribute so that we don't overflow the
-	 * maximum size of a transaction and/or hit a deadlock.
-	 */
-	if (args->rmtblkno > 0) {
-		error = xfs_attr_rmtval_set(args);
-		if (error)
-			return error;
-	}
-
-	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
-		/*
-		 * Added a "remote" value, just clear the incomplete flag.
-		 */
-		if (args->rmtblkno > 0)
-			error = xfs_attr3_leaf_clearflag(args);
-		retval = error;
-		goto out;
-	}
-
-	/*
-	 * If this is an atomic rename operation, we must "flip" the incomplete
-	 * flags on the "new" and "old" attribute/value pairs so that one
-	 * disappears and one appears atomically.  Then we must remove the "old"
-	 * attribute/value pair.
-	 *
-	 * In a separate transaction, set the incomplete flag on the "old" attr
-	 * and clear the incomplete flag on the "new" attr.
-	 */
-	error = xfs_attr3_leaf_flipflags(args);
-	if (error)
-		goto out;
-	/*
-	 * Commit the flag value change and start the next trans in series
-	 */
-	error = xfs_trans_roll_inode(&args->trans, args->dp);
-	if (error)
-		goto out;
-
-	/*
-	 * Dismantle the "old" attribute/value pair by removing a "remote" value
-	 * (if it exists).
-	 */
-	xfs_attr_restore_rmt_blk(args);
-
-	if (args->rmtblkno) {
-		error = xfs_attr_rmtval_invalidate(args);
-		if (error)
-			return error;
-
-		error = xfs_attr_rmtval_remove(args);
-		if (error)
-			return error;
-	}
-
-	error = xfs_attr_node_addname_clear_incomplete(args);
-	if (error)
-		goto out;
-	retval = 0;
 out:
 	if (state)
 		xfs_da_state_free(state);
-	if (error)
-		return error;
-	return retval;
+	return error;
 }
 
 
-- 
2.7.4

