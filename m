Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24FA1C43462
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 17:06:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8501613D3
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 17:06:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239719AbhELRGS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 May 2021 13:06:18 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48582 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239721AbhELQPj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 May 2021 12:15:39 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14CG8wl7053056
        for <linux-xfs@vger.kernel.org>; Wed, 12 May 2021 16:14:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=iH8DBhHTdRUsmaxPrKlOxJnFoOqyqiNHSPKWeZB5Nd4=;
 b=dAHM3QqFVyOJTCzDA2JfEgk2zFnMJozrj8+TKJ7gcFftG+AFX935IOkbwM0LloyzIIry
 PQTSVNRSq5knDDmTpn8fcItIMJIxDyJJjVd4mUoyDWL+HP5Ouaai4Box2yXqvnqlVo5Q
 31eyEwc1RSnXyY+UmB1svRN9C6dAXHQXyTSedwLkQFJlzIByN9scGbIMb3P2QfXeMaak
 trR45bhN6qMyiFZwcFKQotBDSXBmzrN0vteoCN1uYL2KtUAOY3WTLdiKYkynXOyCS63x
 DccNn/TTPDFD/OHSGnZGVgTE16LTBZ0jRQIOJWb0oFWLKAzjvIQGqeqkxeC+vKcrc0ps 9A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 38dk9njh8e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 12 May 2021 16:14:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14CG9fYY021006
        for <linux-xfs@vger.kernel.org>; Wed, 12 May 2021 16:14:29 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2049.outbound.protection.outlook.com [104.47.57.49])
        by userp3030.oracle.com with ESMTP id 38dfryyw0g-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 12 May 2021 16:14:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G6UgCvR6me4yxwWFDnxeHGZGqHWmBknMOlXqIg7j6a3rLTvo7Y9+m/GMghLTQ5J+fg9qbdwgxdoD8wuhabTpWh3jugRhxz87SVaYseIz31kPOwqK1YTEf+P6/VI1BH325TSnF+6AzqvSvG/I7yN9V7MUGjs///nVctt4iqW/r7uocdB78OPoAuu7dwQvZFN90FyQALEiRccQVihZrnZeeGppTDJz9B2I2ODqWrKot74MIZIYNJ7PQa2xWrg8k5Pt0uC6EFT1kB+l03shx3ASWH+uLMGYASLEz1a0DOjzGnC/xExLarWiFMtVMArroy0NFTKaT/xCY8u1IrQsYT97Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iH8DBhHTdRUsmaxPrKlOxJnFoOqyqiNHSPKWeZB5Nd4=;
 b=M9IL9vnA1RSbMJcvw0y65TPqgsaD7j9JgmtNvF+LjWKEsfvtviLCLRC8EC0CQPEfmbz3V58uyrG7LI1qTSOnuilJ50ZxgAOn/Md5eh225D9TOGmkBY0+Hi7QdJIFFaNmvQgcuMnSibiEIteuVcI0LOuRB3DfphsunIlD14OlQkMHFoafEcgWTMQyTSpnrXLBR/ya/A6uYVaG6BzWVRtl5v/BNBMJi94VUBdQ8QHIfR7+MHUEU6pPaRVsEF5S0jJ/frQBQleDIP11KpQf6K8CD/YY7AoIu+gYb2eeP3XbQooQ1xANQJ5fsW3YWmJU6P3ol8p5F4c9a6Sl9xgwh4XQZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iH8DBhHTdRUsmaxPrKlOxJnFoOqyqiNHSPKWeZB5Nd4=;
 b=sZ8ZKJUmra1BZ4SSGHQnRAoD0i3khMG0GXSivRMs09GU+oxR2cyrFQupjPUQajicoirQWvHXKnvvi8xqEAImYKSNQk3aBGd1o3ydH/MO3XrzzoTgFQktF9cTSV3WgWROXodP5+aVNGIvP/4cm3uVK2iJ070UmegDFRky9XxYSE4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3112.namprd10.prod.outlook.com (2603:10b6:a03:157::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25; Wed, 12 May
 2021 16:14:25 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4129.027; Wed, 12 May 2021
 16:14:25 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH RESEND v18 07/11] xfs: Hoist xfs_attr_node_addname
Date:   Wed, 12 May 2021 09:14:04 -0700
Message-Id: <20210512161408.5516-8-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210512161408.5516-1-allison.henderson@oracle.com>
References: <20210512161408.5516-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: SJ0PR05CA0200.namprd05.prod.outlook.com
 (2603:10b6:a03:330::25) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.210.54) by SJ0PR05CA0200.namprd05.prod.outlook.com (2603:10b6:a03:330::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.11 via Frontend Transport; Wed, 12 May 2021 16:14:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 750fa6a6-da2b-454a-3a9a-08d91561028a
X-MS-TrafficTypeDiagnostic: BYAPR10MB3112:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3112A9DF77D25B3B2C34B84795529@BYAPR10MB3112.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oShJJqdo8GDn1/REULdfF7pfSsmMLCBxy3S/myaWIuMabPdzv+sHRoK4QqIuYtQw6+cQ6UGaBnvHeixxrX6+N+hhwWkyp40gzGP709zh+DiId3u679PGXbNMGdA/2Ic2FXTcIlAQnZQr0b7r7a4cuDtGiz28UNMJQXOWexgxgX6fF38i/fSyIlBWHGMMlKjQkljunBMYKV9p5hwdlSXp2ZZI9OT51x4p2d+HqlEP2S4LTPhYsXX/OISP13nk3oynj/YMhL4GRRKTGoIgcAfg4u+Yp/KIMzInw/dQx1tamYqBpL1245VFYB1BKw7qoK4WWOOoNdoJI6M/GwwqiUS2SW24WhCDmiZ9+ZS2uPj1oPKKOreK0c9yy8HpRTfn2d9XM7JZZTG41NwnXFIN1Z+wUAZ6gRdMLqaOz2NhYkHz5ysbSiCktLVjchQ+2cx7cvkUcWc8N0tb8L/Lu7twtjVE8A9wfQAvMl93XSr2kWLHGzEaMH8Ys3PMIv/cvD0rO7igMl66uWvVnECm2n4wAIq/Ro9jgbqiLjV68yOBGAYjkRAvwFxRYScZRew3fRD63eKTOjfspljb+Qw2vrOpiOQFLtrPK7ZlkOaWdyq5qnhfE1RUPVZFltzJ/GuQygxHxUoneZsC6WpLsoQn4CajR7gHUYYsqgzZ5IpGsOhtyp+MtNDAPBRWERYrGL07zvGipZTk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(346002)(376002)(39860400002)(366004)(478600001)(316002)(66946007)(38350700002)(1076003)(52116002)(2616005)(5660300002)(36756003)(8676002)(8936002)(66556008)(6486002)(6506007)(83380400001)(44832011)(2906002)(6916009)(186003)(26005)(38100700002)(16526019)(66476007)(6512007)(6666004)(956004)(86362001)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?7NubTiVBwufQdY07LMg6JgyttV5ZlnN2h6D4Ru1Ghs9InuflpWpKVprD+Ftm?=
 =?us-ascii?Q?TDDf9JX0dyaw2zD81JbGfisdyiCy+j2EM/NtCA523N878lBHXYwtIkE7oOsc?=
 =?us-ascii?Q?jfA6CpF7vp2BiTGVvDE3QVQQMwNyz7ZueBBwwNSD80tGaRe2t7zDXBiQpf0i?=
 =?us-ascii?Q?eaIGOCTkXMxD3zThAycrx7yPRhjvqoNpqyeAn3CELPZzTqtMjkleqy0llaCC?=
 =?us-ascii?Q?dgXmE+FGedLb1EGPJAk8WK1Gbs+DIsOcxSLrkY9EIiXKUj+you5KRTXzSl/U?=
 =?us-ascii?Q?1xAF5BQ9lvMMyzGLnkNgR5cS26BpQgj9AOq8a4lavHam/C9b2ZVaLtEfITY9?=
 =?us-ascii?Q?8qhUe6RsGjeP86xDkmv78wEvClECG2g+VWiqGyRzSCnKKbYBP2qTpjiTXFaY?=
 =?us-ascii?Q?iUj8Wa4OjUYFdbV4GU9HUIxOv8Si9HJxCdScO9X6cwp/Go9aNHV4WWNKUfla?=
 =?us-ascii?Q?Cuz6KeimeGmcQHUA/hCs0sAyUA+jezB6Kn418+3/o85bsvEtlsXMiWHdlnqu?=
 =?us-ascii?Q?H58gmU9jGxjQTAYNTgd7wNEvG/zMiD6Mine4hqjsPpmG0+qSRbu74fxqmFqf?=
 =?us-ascii?Q?yaX6d4skHsUb0HXsypzjEz+L0BB0vPnuL2uToiIezkZuK+DUzuqTY17wydwT?=
 =?us-ascii?Q?63vsYezWKQJeGJ2lZU7N81oTG4EaCuW1ukSbYdeeL/14ukfldxtwdyvoQD4u?=
 =?us-ascii?Q?iVQzpw+WiYQc6oK0uIgea0mdBQWVupeWPUfUOQuJMMDWSjGv495xgl6QlVJE?=
 =?us-ascii?Q?HoX0x6goHNUPCCzUB+bZSUV3eXffvnjKYu0iAK+mLIahfz+WKbVcw1gehypZ?=
 =?us-ascii?Q?yWUv/624yUNpidjtJ5OY4jKTSJvntjM5JoDvtMABAIzVdxEak6/x4y/t+vna?=
 =?us-ascii?Q?3mYlFpy6ziWyx2m3jqt8dICsUjEb5ouYgTup/z8aJPpCXghwktdWr9xp6Jq1?=
 =?us-ascii?Q?AdmFODzY0wuZELPkcHkNCDLYenEP8E10pFuXVCTf2a7AKTzU+oNA0StVKH1k?=
 =?us-ascii?Q?PqEkBuMgRC69iquP3OzZzu+E5nOBBZyptqC7v2Ua1EG2s5AnrWG0C8f0mOiK?=
 =?us-ascii?Q?6ITrh8xH7O+uJScgX83vYjsbBrPE4VL8cEn9/ua8+uzHo9+VkhzgWTShRGs6?=
 =?us-ascii?Q?OkWLz43RvqsH3/RXOamkBSh73lQaVguHacm5/KcD//INcmkT9tVKaNtVDKs3?=
 =?us-ascii?Q?zC6y9ib/htIXojxNJbIUoj9SVVatt1aUSNn1gTGWppcQsJsGxeovDleE4GV2?=
 =?us-ascii?Q?jM+3sizyrdG3gCza1klAiPxWTwyYVJOJSZY0yMqBHLE0YffTR4fWprNB4WFs?=
 =?us-ascii?Q?p0uiMfD7lPBEuyZwgvekFCPF?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 750fa6a6-da2b-454a-3a9a-08d91561028a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2021 16:14:25.0112
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ybmjzsUOJ+kU5VlEGmapdDgD8izRBcTydfOPhsQa04Fn0i7pkz8JIdIOcywzzJA57sRUJrFH34KeNwsyyKH6hziUhH1b9tdtHKoP1OancqU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3112
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9982 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 bulkscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105120102
X-Proofpoint-ORIG-GUID: U_9Y3Dc7XnTi2DnT3P7pJyBcoNdRS2bO
X-Proofpoint-GUID: U_9Y3Dc7XnTi2DnT3P7pJyBcoNdRS2bO
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9982 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 adultscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 lowpriorityscore=0
 malwarescore=0 priorityscore=1501 clxscore=1015 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105120102
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

