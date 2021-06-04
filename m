Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA5D1C4743D
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Jun 2021 23:42:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8178613FE
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Jun 2021 23:42:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbhFDXob (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Jun 2021 19:44:31 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33290 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbhFDXob (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Jun 2021 19:44:31 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 154Ne3pZ062232
        for <linux-xfs@vger.kernel.org>; Fri, 4 Jun 2021 23:42:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=gVd0enhwIWaYRhCmoYWj67z08taQidFZsLD19HHO84Q=;
 b=c9zA/uxh4lJC1OLpBTE4BOUksMpBzzAtuT3WILAz6dwQizvThgQqGBn206x2IdYBotH6
 OF7dXD+s+FCnJF+C21948OP++6zTRGqTCD+9USCILmNpt273zN+z8lx3DRyjvVbNqYyP
 dkwEK6EemUKMgk4u5w5hb+KcYExei+FDnn1IHAZMJbR1F/Eis5d0kyJGU1un0kvHqjLd
 uHTZL3OjiLv0YAk0XoYrdy1gERGkEubgkfcgjneuVAJqpdmyI3p5ngsqOEkhEhDTXwNH
 JnrWDrCA92UdbJ0njD9LDifUro0dGNLUkbuNLS4yjyEM7s+nIO/BnN0rDQ1IOgi0bd84 SA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 38ue8pq0gr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 04 Jun 2021 23:42:43 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 154Nedi7056299
        for <linux-xfs@vger.kernel.org>; Fri, 4 Jun 2021 23:42:42 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by aserp3030.oracle.com with ESMTP id 38yuymb0mg-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 04 Jun 2021 23:42:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JgHt24/gPOYrCgqkpawWMbe7V4k/iuJXrDLDRwEg6MuNOJz6shU3OS5fCD0j0UeRdIvcuQRN3UhdwtZAKvjHVJb7G8sBR85J9dyOtmHpf85KUj7rAhvyXgktgWs1Nu3xfRzzmvHhqvwagU59wjW5+Au4EClLU+7g3vUpzdLt8c3652u2VNgSnYu8AIxt8m0TsVBRxJDgsMeDM2oUVle3GktZQ3ku4jDojccPvt6uhpoTJ9g0c7PsTANKescK3E2Fk9gOBrHtPF3wTA/JOo/RsumehrMLGjHnZu1hKfxbKrdc2omwhACBMq2KImoJRJziwCEoVJqgQtvvy5XXjWtsyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gVd0enhwIWaYRhCmoYWj67z08taQidFZsLD19HHO84Q=;
 b=ltbmTaNFmdKxMqasn7UA/rHWGTtr/6uX/eWmhQEPC+PVNunv2t3/reJzszt51SuiWXdeYdK6YRT9nuPwEFferMC54a03pfPFAZZz/2A+tEOClhpLCuqmqdJtbMRgl1nUiZaY9sU0L5Jw4PSMZtgc5LtkQBn0iBHhbnl+mz+VsyvJAtHPF8VIUB0qj8SaUkQaKOpFuUtbz1lqbPAfhVx5Rur3RooCLFCjsiTF/aoRg0/16ucTT2/+DQg7pzUvjBbEUhsCOljzBkLr5JVfAtSLYNlFjYpsTUgJXKvDDLal2paL82s8/8sdvD8WFIv2tHdP5TkDHm9lyq0X3FQRAVPQCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gVd0enhwIWaYRhCmoYWj67z08taQidFZsLD19HHO84Q=;
 b=V2c0YKHK7CDffHmMmktECxovUvsKStDse/coS42Cy2IW7iFXFKLhuGSI7/kRxkaAdjPwbpqu+OQWXwZa4MpbJ3oEv6+C4V7Qx4LE+Tn0FHTqt7TSMcoZYJSHhJ3wFfrJgjs/xy43UUZ1eQOmMkwBtGdTA/+y3U3MeXBWjpIEmlM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2485.namprd10.prod.outlook.com (2603:10b6:a02:b2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Fri, 4 Jun
 2021 23:42:41 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a9c4:d124:3473:1728]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a9c4:d124:3473:1728%5]) with mapi id 15.20.4195.025; Fri, 4 Jun 2021
 23:42:41 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v20 03/14] xfs: Refactor xfs_attr_set_shortform
Date:   Fri,  4 Jun 2021 16:41:55 -0700
Message-Id: <20210604234206.31683-4-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210604234206.31683-1-allison.henderson@oracle.com>
References: <20210604234206.31683-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: BYAPR07CA0095.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::36) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.210.54) by BYAPR07CA0095.namprd07.prod.outlook.com (2603:10b6:a03:12b::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.21 via Frontend Transport; Fri, 4 Jun 2021 23:42:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 862c1551-c6ef-4332-835f-08d927b27112
X-MS-TrafficTypeDiagnostic: BYAPR10MB2485:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2485874D9BB1A7E34068DEA0953B9@BYAPR10MB2485.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ydWW8+Ks7qPuJA5ZPuf3szulPfDfDH+1Er8P6oaiqZ9QNB4Vv7S22wQG122NMQ8LLdDb8mt5Xe2cJjjazX2LDMvh5h3boJrp2q6aZ2TA+s8UHUsZrOTox3QLyA4xmr32YCgEDZWwgx7nUkVe1/mEN22cTIvTrWFKzaDZhZdIqwWf8zcZRO7vCL+GgJclGT3zeNPB0/050xySw0QGvFBdfnMYPU30jK4+VT1LBA8fDQYHD7HbIv40wQmL5GKAjX+7Ubj1D1Q4YZg9N6maalCHzZDmqsTZFOGdwVLV2RNdKz5b66goXiIT7eF1liBiT8bGDpDA9TK/sOBdAkpcowSDpFs42GeX0hTlf5XeUkz0lopN6XpJ/YNpGAuuSaH84lpqL4RLnZuU0AWpj+9psne6OFop2+DZOP9R24DMlIrBQ28UErg1i0Dyk1uWlmtdEPpoYpFPMQAhqL7HXFzRVPKKNC+toBYmL5mu40FVwiW9eaIUSqBMl4rrX4KoBg+ceeIfAsqiMluC2lh1PWe2R5wvq456TgwkDNpkKNnSPFngn7zWSoaGLD432KyW+GXA6DaPLCOmAI4C3zFXgC+YTfoURCWIJ1oi+c686xPN+Gy59Xj3pwt111OpPDAsjJ+3AqHZT1WiWjul+mW70qt9QA8eXE3F8tFmUxKuanEzBai4GwjiCGoBr/K4zP8gCCjjV+yD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(376002)(396003)(346002)(39850400004)(316002)(956004)(38350700002)(2616005)(83380400001)(38100700002)(16526019)(44832011)(6666004)(2906002)(1076003)(186003)(6916009)(8676002)(6506007)(6486002)(36756003)(8936002)(66556008)(66946007)(86362001)(478600001)(66476007)(52116002)(26005)(6512007)(5660300002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?2TI17QRFrV1cRTzofGmtZhWyrPZfNQ9er2nzrP1zG+tPp1snSS4Q0Vk4A0JR?=
 =?us-ascii?Q?ovxUsO1WcTQQApNmYr3572RC9crP36XtukBLigyrYQy3yvHic8zdaScqy7vB?=
 =?us-ascii?Q?pOM5/zl4LvFIZ17uaPr5ue9O0GLlLP2x9CHs+eJWtwxrt3gW3H93URIeDj0d?=
 =?us-ascii?Q?nGgpDsZdjpVettpHLxxTY1pgbu+jNp7ozWoavIb3BxWwhYDfWvQva+QA+js+?=
 =?us-ascii?Q?iH5A3MesVyEC6wmENFvNdylTUAsqHSOK8+WwnRRekqqLq/D2ymwq5MqftfKl?=
 =?us-ascii?Q?X0+eUC5R/zF9irRGETflI1uaYttKAJxN+QxVv6FslXWVYjuzahwFljxtMN3g?=
 =?us-ascii?Q?HrYsvhpQ2PFxJwC8HvJeMqbAtnUd+2StcoGSmQVTJDHny1hiiTqpRKUcysrn?=
 =?us-ascii?Q?+aewLgghY6/qfVDs9YAIg1LIYbKTxDi3YOPA3K40Pj3dZd17Q8hmuD26uFVp?=
 =?us-ascii?Q?aaCGSBKpZfspR40RJgQHdLwF9Sl8Wm3geUMuxZOf3uhlCMq6hQRE4hfUxOvm?=
 =?us-ascii?Q?mkoSCJcIZAHb6xKjch8xHzv+oEArqyE6lKUQsC6MxPKT80WtmlTg+/jjkNRK?=
 =?us-ascii?Q?GiNox7O04AQZZDIV9UJfj5aMPilC4oBmaZ4WZGAn66MreS8iaX98V+h6wZqo?=
 =?us-ascii?Q?0DwmBdajA9qCZ+21Oijtjm9IIG9CaNyXBFGl9Q22FxRDSh4jDcyyKJ4MsTbU?=
 =?us-ascii?Q?ThlTvByU2mnHRFJibbvE/h8FnM70gZunZSVF2RFzKj7BDuweN9i807QPwGVR?=
 =?us-ascii?Q?qOUbRXCK/bWUNwRc8aJIbeRNfKDmkv0KSnJ4ml8Bch99NUZbftRS63/Ln+5C?=
 =?us-ascii?Q?ekM41iokT4tbcdXR5GoE6lxz0n21kdbjr+Fg6DEZKtByVuyG7DOPdNvIHlVn?=
 =?us-ascii?Q?2Y1mOjgukHHjfttVukMHQZEv6fdC5xJp3WKlrM2IZOQWFKlvgLdWrSRGWZCU?=
 =?us-ascii?Q?mb3ZhcGvYxgt5CF5RklvJMB2prk/FctZ30dCcBNuYH7vvp/XzRcBs2DX+H4x?=
 =?us-ascii?Q?o43GlGxxc+nMPo9uiVjvkZxjacoFDvqaUus66YG0Hna60OGjrPGM4Nr+JGqE?=
 =?us-ascii?Q?tq2D57CKAbNa9L2cTw3Ft/dBnqaqrxpPv/Ck5t1/AL9Mdq1GkRk2mIyD3LmS?=
 =?us-ascii?Q?rMcEf25MfkE4iRKQRieToO6bN91SLy1Q3Q+RdKBpKj6hX4OBwuPjViRKaajq?=
 =?us-ascii?Q?IsrxPjp4HE0KkePQ2c9mmffjzpAFEdcOr9LHVAcX+SgonAVLZkw+zTLPMz03?=
 =?us-ascii?Q?cIkZLnj/o2Z3B8O7rcYA4q+Xp4VuD1REAxAJUm8l5vH62QuqmjO11zAnZGPU?=
 =?us-ascii?Q?lX8XiRppp1+nmggdYpCl/LmS?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 862c1551-c6ef-4332-835f-08d927b27112
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2021 23:42:41.2948
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /IN8WnrJmqjUDEkOgaoCuGHy+M0Yc8rxC4GsvOls0QUJhbOifjs+nwW2UExukniFTFIRgOVeftmG7HB1wTHkDP6AberYAMoFtAzOu9KCKW8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2485
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10005 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106040162
X-Proofpoint-GUID: 4FXeVuVfg0I-_dtIF-2LuPRElBhbUdT1
X-Proofpoint-ORIG-GUID: 4FXeVuVfg0I-_dtIF-2LuPRElBhbUdT1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10005 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 malwarescore=0 adultscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0
 bulkscore=0 phishscore=0 priorityscore=1501 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106040162
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch is actually the combination of patches from the previous
version (v18).  Initially patch 3 hoisted xfs_attr_set_shortform, and
the next added the helper xfs_attr_set_fmt. xfs_attr_set_fmt is similar
the old xfs_attr_set_shortform. It returns 0 when the attr has been set
and no further action is needed. It returns -EAGAIN when shortform has
been transformed to leaf, and the calling function should proceed the
set the attr in leaf form.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_attr.c | 42 ++++++++++++++----------------------------
 1 file changed, 14 insertions(+), 28 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 8a08d5b..0ec1547 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -236,16 +236,11 @@ xfs_attr_is_shortform(
 		ip->i_afp->if_nextents == 0);
 }
 
-/*
- * Attempts to set an attr in shortform, or converts short form to leaf form if
- * there is not enough room.  If the attr is set, the transaction is committed
- * and set to NULL.
- */
 STATIC int
-xfs_attr_set_shortform(
-	struct xfs_da_args	*args,
-	struct xfs_buf		**leaf_bp)
+xfs_attr_set_fmt(
+	struct xfs_da_args	*args)
 {
+	struct xfs_buf          *leaf_bp = NULL;
 	struct xfs_inode	*dp = args->dp;
 	int			error, error2 = 0;
 
@@ -258,29 +253,29 @@ xfs_attr_set_shortform(
 		args->trans = NULL;
 		return error ? error : error2;
 	}
+
 	/*
 	 * It won't fit in the shortform, transform to a leaf block.  GROT:
 	 * another possible req'mt for a double-split btree op.
 	 */
-	error = xfs_attr_shortform_to_leaf(args, leaf_bp);
+	error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
 	if (error)
 		return error;
 
 	/*
 	 * Prevent the leaf buffer from being unlocked so that a concurrent AIL
 	 * push cannot grab the half-baked leaf buffer and run into problems
-	 * with the write verifier. Once we're done rolling the transaction we
-	 * can release the hold and add the attr to the leaf.
+	 * with the write verifier.
 	 */
-	xfs_trans_bhold(args->trans, *leaf_bp);
+	xfs_trans_bhold(args->trans, leaf_bp);
 	error = xfs_defer_finish(&args->trans);
-	xfs_trans_bhold_release(args->trans, *leaf_bp);
+	xfs_trans_bhold_release(args->trans, leaf_bp);
 	if (error) {
-		xfs_trans_brelse(args->trans, *leaf_bp);
+		xfs_trans_brelse(args->trans, leaf_bp);
 		return error;
 	}
 
-	return 0;
+	return -EAGAIN;
 }
 
 /*
@@ -291,8 +286,7 @@ xfs_attr_set_args(
 	struct xfs_da_args	*args)
 {
 	struct xfs_inode	*dp = args->dp;
-	struct xfs_buf          *leaf_bp = NULL;
-	int			error = 0;
+	int			error;
 
 	/*
 	 * If the attribute list is already in leaf format, jump straight to
@@ -301,15 +295,8 @@ xfs_attr_set_args(
 	 * again.
 	 */
 	if (xfs_attr_is_shortform(dp)) {
-
-		/*
-		 * If the attr was successfully set in shortform, the
-		 * transaction is committed and set to NULL.  Otherwise, is it
-		 * converted from shortform to leaf, and the transaction is
-		 * retained.
-		 */
-		error = xfs_attr_set_shortform(args, &leaf_bp);
-		if (error || !args->trans)
+		error = xfs_attr_set_fmt(args);
+		if (error != -EAGAIN)
 			return error;
 	}
 
@@ -344,8 +331,7 @@ xfs_attr_set_args(
 			return error;
 	}
 
-	error = xfs_attr_node_addname(args);
-	return error;
+	return xfs_attr_node_addname(args);
 }
 
 /*
-- 
2.7.4

