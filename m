Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FA62C43214
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Aug 2021 22:44:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72A5B61357
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Aug 2021 22:44:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbhHXWpl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Aug 2021 18:45:41 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:52836 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231135AbhHXWpk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Aug 2021 18:45:40 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17OM4Elo000915
        for <linux-xfs@vger.kernel.org>; Tue, 24 Aug 2021 22:44:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=n75Fp+Ql+pwe7T3W6dNDENsXFlViZYe1Rcs0MpVmbKY=;
 b=n2Y9UD2BL4DsEbtJsBdnDwyeQNFArCM4CoS8tfH/kLXNoaU4XAHhivrfNrJ2vhKerId+
 LZtDtWR+9Cr1r4vUBDNnUoxLm+Rgxw/WUUV5w8J5xogocr90GJi1HPnreNT1QFkl2pfz
 s1TpoOtJ2Rp1PqIVQH0rjOgCjayIcz6oh1CjlY+k6apkHM6CFnqHadGkByT9WTmHQwrb
 /2oY2lYq+jBZ2y+GeKpXAhumAWxbrsfW3+xiIrfy8aYycySSwEEhFk427qgmlKsASjsT
 cuwd16+/lpLd7/PtmUV64pU4QJnL3ymJAU0ko3YzWO+/0abvytrCMS2rL+00hazMyw2e 7Q== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2020-01-29;
 bh=n75Fp+Ql+pwe7T3W6dNDENsXFlViZYe1Rcs0MpVmbKY=;
 b=jDU15hQ2md1T6j3BAN7L6165Gmn5JSxSDT1xKHnMFWMgEo0pgsqjxoJLCVNWZoIUn3un
 +qs/ErpiGjLozCE/HxEB1iO5gO/FPb7gK62nfUYt0xxJiBqQhB+Bif65w35aUdgg3Mub
 UPz5D85xDCluWOuN0apmpVOjKtyaXr69C56AVvbfJ38gDySGz09T3j23v8119hUhvXa6
 mL/2+cyayWnd742hjkExJ6JeAEiANSpuFMl6QjW399DG0C57vl6R/zwxJwaYx3kwvWPX
 hpwwy7OlwnGJTRskAnDskMsTPKDdDRIs2yWsjD18I2IkcSqSR5bX180QyeB8pOXq2DH9 Gg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3amwpd9wfm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Aug 2021 22:44:54 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17OMfYQE025324
        for <linux-xfs@vger.kernel.org>; Tue, 24 Aug 2021 22:44:53 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by userp3030.oracle.com with ESMTP id 3ajpky4yms-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Aug 2021 22:44:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F4dYEiHkDhHuj5BmUfWrnh1Pi0e46IfqoPwEUuZRKmA9obKxzaot5UGHMHCTrv0UyTUHJnvJpHvQTmvd7s+c18ZqaYG/QLp0KpLQNjsY/Z2P0xFilzl+dE4HQ4rg9kAeVmRlmSay7wb4CFV6maKc0oxk1ltQDnfs8Oh3YLhIjZ247v9SXxl/L0UBgBPEugYu8F2dWgThGrsQQl4T7f7g7RURJ2HdHh5AWzc9w6OXxe77tJav54CLxlw+HpbGssnZ85YGEqEMVMoNZqnVhwXKWfLnBlPi1Baq8kGAUT3Txw5XpZnUzjM6w+vrvzPDx9rCAgNvagwg6dDJ01hbBpV3gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n75Fp+Ql+pwe7T3W6dNDENsXFlViZYe1Rcs0MpVmbKY=;
 b=NrXagDTfN3NjfTeZD6t9r0TDBuZVD+59kQ/HfefTJldlkbnulc8i37JYo6R8P5MbNab6DjP48rJPvGgDsJdJMFC9Lx1lsDtsu1flCdaYn6c4ZJImzM4UxF1kAvQfK3FgSLFQ3knNFrENSiOvEje8SW2+Aho94VJzymkA8+d2v5FF23owU3FZQd7EyZ2hRDY1Jj7DN2WJMCA2zY5mv9kF29AUPdDJOtpRllKfcmHZ/hGO0g+HWaZthMblRSOzad3I3fL+PGr+myzI/kL6/HJrfQOIaQ22xMT6rW/RDG+A8rz819FOBDU5Yhe9OsmxTZ90vyHQBR8kdj8tUXc+wx4IVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n75Fp+Ql+pwe7T3W6dNDENsXFlViZYe1Rcs0MpVmbKY=;
 b=YpoirJ990vdE21/ah1YYQ3fP8puHX5Wm2aPp5f2MX5VA/p5sFIdIwE20+GcRwHO+KDznUzTPUdyDiWJpkjUPPWnuJZAPqOwDOtKYcI4FhekLfqUgvDl1C0ACFzzgUXagsRNyRdEMihKOiStCEn4sxTrwo7HM0T4w7cuJTwdyfSQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4653.namprd10.prod.outlook.com (2603:10b6:a03:2d7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Tue, 24 Aug
 2021 22:44:50 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f%9]) with mapi id 15.20.4436.024; Tue, 24 Aug 2021
 22:44:50 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v24 10/11] xfs: Merge xfs_delattr_context into xfs_attr_item
Date:   Tue, 24 Aug 2021 15:44:33 -0700
Message-Id: <20210824224434.968720-11-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210824224434.968720-1-allison.henderson@oracle.com>
References: <20210824224434.968720-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0012.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::25) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by BY5PR17CA0012.namprd17.prod.outlook.com (2603:10b6:a03:1b8::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Tue, 24 Aug 2021 22:44:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ac5f6bf5-db78-403e-1e0b-08d96750c559
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4653:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB46533E189097F10D1D61A6D695C59@SJ0PR10MB4653.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:250;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DfmM7tBkoG0iVyifNvTkk3BMmSEK860jwfUV+d2ZxMcidbu54EJI/ys0LBYRdxd7jgurQI4NggTCwA0MdRSn2uGwV/OGjc/nEBeq4aBOzcGuY6121PoY+vU1mj6UX33M35NUaxF+jkDNfVxLGsqTnEbJLu8oLqSmfEG21rEV4EasUZjJHlGgO/489w5X6gzniNJs4AY3KwfGxGgJBYQZBECpWjfH4MZFdOHFUW0PgbdiDw5EiXIEUcpfQ8WOZpzzZTquYx/yYCMA20net49bSlx4miDGH+SWmgoIlzF6FuPgLjciwLlqXntlm7bul8QUHTpJD6n+IwHQZT/yDe2/QM7CiNBca8iZE2Swjp65J+Im2V83NlBFwflpQO94bOWwl2NHjrDjQnIwGV1uVA3ODks5YizM2SYJrxBhCGb2mTdV5RzF/7FgtbcqNjUlYJWT+6CamXmrMyDnEpJAyEseQdX0pspWfCeXYObzLjVSyLQ5IOv5CR8KyPR8sKvBkD+PdMGBTu6imnRVmGZAJTJXY4NKKuIj9CRzNqiEBg1JD6ibphxAKdiZxGHl0Ou2NJo5HGM1GK8l9rkIWtFgc8pa6dMiNOAMzXfQfnZyZUkal5GPo8ClNwWpy+yTb4ZWf3g7EDKnkQacEd3Jsnyd500aY44nkbsQYGq5VFBTSFsD+H4u5PHe2lbZQqsVoFdtbo0pmdOXA9KkRQI3Zy6urAeibg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6666004)(66476007)(86362001)(66946007)(83380400001)(6486002)(6512007)(2906002)(52116002)(186003)(6506007)(66556008)(508600001)(8676002)(316002)(956004)(30864003)(8936002)(36756003)(26005)(44832011)(5660300002)(2616005)(38100700002)(38350700002)(6916009)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hRRDbKKwhoh+MxA2cfpJffTSBSTbNju8uV5OB3VWM25LZ6X8pQsG1qpi1AhC?=
 =?us-ascii?Q?+0bCNRjR9sIlVqT91l0bZVL2YFfW/2Ymx2XfrmweVeVLHpbHxEBG5WkW1eJe?=
 =?us-ascii?Q?XshHwHSSQ0bLGQJzGB1xUCgDgnZIomEFUFVUkpbhPp7apIGL1RqVTdLu+8cP?=
 =?us-ascii?Q?FJRZqL76z8qSuuuDKXDFrOUdL1KTUDjk1jGaE3+Nb+5Iy2i6sPoLKRWGTdk9?=
 =?us-ascii?Q?OgXKKtJ1rxc0XdT7TE2t68XPTg4LURHbZyUJ2vCmb/VIM28XnVepjkjy6ymy?=
 =?us-ascii?Q?Ywmc2YPQ1s4EDrS1iz1I1BFeUr25rmB5gM+gj/mFAsmTEMRUyUbEtE/tj7fi?=
 =?us-ascii?Q?oZ8+q0bVWM4ahZPd74z+4iaOET6mw44u8uAn7Vdpn5sPHTN6qwfQS+BGX16k?=
 =?us-ascii?Q?AJ318qm9MChSnHsSRbzOBso75odaTTN9UeEXVVmm0jrQtJmuU0tkA8bOiL15?=
 =?us-ascii?Q?9BEEZcXfv+OvDaImO9f3JM87ZWpVo+NQXBXW297w08R2mPJT9KrSWeDKGm6o?=
 =?us-ascii?Q?PsZJKvElP4IIka34FVcnAUa8d0qCiAgsdDrI8gF9AVwMG75kEgaEQeHqaxe5?=
 =?us-ascii?Q?wLBM8TxM/1TBQbOqMRQ+Bc+mSl+feE0sqw2IsT4tiY0v1MEFpQ6qRRHCCIo8?=
 =?us-ascii?Q?jSvBDvYGi+4QWO0Rpoz2HuvrAD/4aMT90SGANZh3sOQQZ8RkjJh3w9xClXwH?=
 =?us-ascii?Q?HiPmZQjwEcu3g98BUnLxpBwJwmM1UvjEVvTsxdLnLaon9d+wHbOHQTOmJ+bg?=
 =?us-ascii?Q?izXzBgIqyqL+3DSW4B20jG/0a3Lwbt1wNNxS8JVHD0Z39Ogcls8oKMXPCY19?=
 =?us-ascii?Q?bgYLVNvKdSmBcX1tVjuMn6lVF9+un7/CpggsVv1oDW8/2OWqoDVVpr+mVFB/?=
 =?us-ascii?Q?EsWIcRCupEtKHNKk/HYu9uVBXC5EZ/TJZlQq6I2fMGaec+mq4KWgpefLTX9K?=
 =?us-ascii?Q?tgp8/3gRTzfdU8N+s07ut+ls+axPysh0m29qNMLZq2IvsJGdKqA53ilLYo0w?=
 =?us-ascii?Q?0VjKb/AK6Z6gG60tk88ow9scH4Q61awXt5wlqbT+bcAYHtAJbii5s9kHmaW+?=
 =?us-ascii?Q?DIXFpwcSRog5ApREGcbBHWNVMTyQIo0f9ZRP6DFdDtMXhbdvpTc8QrfIhZlJ?=
 =?us-ascii?Q?Ycc9At4lC/14+KyKzjn1MBSgdeRA4XkyX7pc/7KCmOioiqSWbRvtJk5d0ota?=
 =?us-ascii?Q?jjdBmhghzV8EShGbLXi5pa/fra853E88KrdLgk263EEQqxvmn3cgsySiqoJN?=
 =?us-ascii?Q?x9VShFBkSbsdf1uX/YUH1VDKJdaX/GOgEtTjfJmjeiA9G3c1nQjZ58GacHgG?=
 =?us-ascii?Q?B4LRQXxL1IcziRH4AzgZgp2p?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac5f6bf5-db78-403e-1e0b-08d96750c559
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 22:44:45.7135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ReesrVAb3C454W4D/1xZWu1jzQzGkAPLiG2GZ5j0yDup6agH8RHn7Jp8M98nRrX+hcfPoezPf7Epd4JZQL9rCRJ4k5Yqv8l4ZiGs0dd37+M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4653
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10086 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108240141
X-Proofpoint-ORIG-GUID: RoIpmQxHZdqdjqOizAAY97JJ7P_2ZAhK
X-Proofpoint-GUID: RoIpmQxHZdqdjqOizAAY97JJ7P_2ZAhK
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is a clean up patch that merges xfs_delattr_context into
xfs_attr_item.  Now that the refactoring is complete and the delayed
operation infrastructure is in place, we can combine these to eliminate
the extra struct

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_attr.c        | 162 +++++++++++++++++---------------
 fs/xfs/libxfs/xfs_attr.h        |  40 ++++----
 fs/xfs/libxfs/xfs_attr_remote.c |  36 +++----
 fs/xfs/libxfs/xfs_attr_remote.h |   6 +-
 fs/xfs/xfs_attr_item.c          |  38 ++++----
 5 files changed, 141 insertions(+), 141 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index d62ab53c3b07..c3fdf232cd51 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -56,10 +56,9 @@ STATIC int xfs_attr_leaf_try_add(struct xfs_da_args *args, struct xfs_buf *bp);
  */
 STATIC int xfs_attr_node_get(xfs_da_args_t *args);
 STATIC void xfs_attr_restore_rmt_blk(struct xfs_da_args *args);
-STATIC int xfs_attr_node_addname(struct xfs_delattr_context *dac);
-STATIC int xfs_attr_node_addname_find_attr(struct xfs_delattr_context *dac);
-STATIC int xfs_attr_node_addname_clear_incomplete(
-				struct xfs_delattr_context *dac);
+STATIC int xfs_attr_node_addname(struct xfs_attr_item *attr);
+STATIC int xfs_attr_node_addname_find_attr(struct xfs_attr_item *attr);
+STATIC int xfs_attr_node_addname_clear_incomplete(struct xfs_attr_item *attr);
 STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
 				 struct xfs_da_state **state);
 STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
@@ -246,9 +245,9 @@ xfs_attr_is_shortform(
 
 STATIC int
 xfs_attr_sf_addname(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_args		*args = attr->xattri_da_args;
 	struct xfs_inode		*dp = args->dp;
 	int				error = 0;
 
@@ -265,7 +264,7 @@ xfs_attr_sf_addname(
 	 * It won't fit in the shortform, transform to a leaf block.  GROT:
 	 * another possible req'mt for a double-split btree op.
 	 */
-	error = xfs_attr_shortform_to_leaf(args, &dac->leaf_bp);
+	error = xfs_attr_shortform_to_leaf(args, &attr->xattri_leaf_bp);
 	if (error)
 		return error;
 
@@ -274,7 +273,7 @@ xfs_attr_sf_addname(
 	 * push cannot grab the half-baked leaf buffer and run into problems
 	 * with the write verifier.
 	 */
-	xfs_trans_bhold(args->trans, dac->leaf_bp);
+	xfs_trans_bhold(args->trans, attr->xattri_leaf_bp);
 
 	/*
 	 * We're still in XFS_DAS_UNINIT state here.  We've converted
@@ -294,16 +293,16 @@ xfs_attr_sf_addname(
  */
 int
 xfs_attr_set_iter(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args              *args = dac->da_args;
+	struct xfs_da_args              *args = attr->xattri_da_args;
 	struct xfs_inode		*dp = args->dp;
 	struct xfs_buf			*bp = NULL;
 	int				forkoff, error = 0;
 	struct xfs_mount		*mp = args->dp->i_mount;
 
 	/* State machine switch */
-	switch (dac->dela_state) {
+	switch (attr->xattri_dela_state) {
 	case XFS_DAS_UNINIT:
 		/*
 		 * If the fork is shortform, attempt to add the attr. If there
@@ -313,14 +312,16 @@ xfs_attr_set_iter(
 		 * release the hold once we return with a clean transaction.
 		 */
 		if (xfs_attr_is_shortform(dp))
-			return xfs_attr_sf_addname(dac);
-		if (dac->leaf_bp != NULL) {
-			xfs_trans_bhold_release(args->trans, dac->leaf_bp);
-			dac->leaf_bp = NULL;
+			return xfs_attr_sf_addname(attr);
+		if (attr->xattri_leaf_bp != NULL) {
+			xfs_trans_bhold_release(args->trans,
+						attr->xattri_leaf_bp);
+			attr->xattri_leaf_bp = NULL;
 		}
 
 		if (xfs_attr_is_leaf(dp)) {
-			error = xfs_attr_leaf_try_add(args, dac->leaf_bp);
+			error = xfs_attr_leaf_try_add(args,
+						      attr->xattri_leaf_bp);
 			if (error == -ENOSPC) {
 				error = xfs_attr3_leaf_to_node(args);
 				if (error)
@@ -340,19 +341,19 @@ xfs_attr_set_iter(
 				 * handling code below
 				 */
 				trace_xfs_attr_set_iter_return(
-					dac->dela_state, args->dp);
+					attr->xattri_dela_state, args->dp);
 				return -EAGAIN;
 			} else if (error) {
 				return error;
 			}
 
-			dac->dela_state = XFS_DAS_FOUND_LBLK;
+			attr->xattri_dela_state = XFS_DAS_FOUND_LBLK;
 		} else {
-			error = xfs_attr_node_addname_find_attr(dac);
+			error = xfs_attr_node_addname_find_attr(attr);
 			if (error)
 				return error;
 
-			error = xfs_attr_node_addname(dac);
+			error = xfs_attr_node_addname(attr);
 			if (error)
 				return error;
 
@@ -364,9 +365,10 @@ xfs_attr_set_iter(
 			    !(args->op_flags & XFS_DA_OP_RENAME))
 				return 0;
 
-			dac->dela_state = XFS_DAS_FOUND_NBLK;
+			attr->xattri_dela_state = XFS_DAS_FOUND_NBLK;
 		}
-		trace_xfs_attr_set_iter_return(dac->dela_state,	args->dp);
+		trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
+					       args->dp);
 		return -EAGAIN;
 	case XFS_DAS_FOUND_LBLK:
 		/*
@@ -377,10 +379,10 @@ xfs_attr_set_iter(
 		 */
 
 		/* Open coded xfs_attr_rmtval_set without trans handling */
-		if ((dac->flags & XFS_DAC_LEAF_ADDNAME_INIT) == 0) {
-			dac->flags |= XFS_DAC_LEAF_ADDNAME_INIT;
+		if ((attr->xattri_flags & XFS_DAC_LEAF_ADDNAME_INIT) == 0) {
+			attr->xattri_flags |= XFS_DAC_LEAF_ADDNAME_INIT;
 			if (args->rmtblkno > 0) {
-				error = xfs_attr_rmtval_find_space(dac);
+				error = xfs_attr_rmtval_find_space(attr);
 				if (error)
 					return error;
 			}
@@ -390,11 +392,11 @@ xfs_attr_set_iter(
 		 * Repeat allocating remote blocks for the attr value until
 		 * blkcnt drops to zero.
 		 */
-		if (dac->blkcnt > 0) {
-			error = xfs_attr_rmtval_set_blk(dac);
+		if (attr->xattri_blkcnt > 0) {
+			error = xfs_attr_rmtval_set_blk(attr);
 			if (error)
 				return error;
-			trace_xfs_attr_set_iter_return(dac->dela_state,
+			trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
 						       args->dp);
 			return -EAGAIN;
 		}
@@ -430,8 +432,8 @@ xfs_attr_set_iter(
 			 * Commit the flag value change and start the next trans
 			 * in series.
 			 */
-			dac->dela_state = XFS_DAS_FLIP_LFLAG;
-			trace_xfs_attr_set_iter_return(dac->dela_state,
+			attr->xattri_dela_state = XFS_DAS_FLIP_LFLAG;
+			trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
 						       args->dp);
 			return -EAGAIN;
 		}
@@ -450,17 +452,18 @@ xfs_attr_set_iter(
 		fallthrough;
 	case XFS_DAS_RM_LBLK:
 		/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
-		dac->dela_state = XFS_DAS_RM_LBLK;
+		attr->xattri_dela_state = XFS_DAS_RM_LBLK;
 		if (args->rmtblkno) {
-			error = xfs_attr_rmtval_remove(dac);
+			error = xfs_attr_rmtval_remove(attr);
 			if (error == -EAGAIN)
 				trace_xfs_attr_set_iter_return(
-					dac->dela_state, args->dp);
+					attr->xattri_dela_state, args->dp);
 			if (error)
 				return error;
 
-			dac->dela_state = XFS_DAS_RD_LEAF;
-			trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
+			attr->xattri_dela_state = XFS_DAS_RD_LEAF;
+			trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
+						       args->dp);
 			return -EAGAIN;
 		}
 
@@ -491,7 +494,7 @@ xfs_attr_set_iter(
 		 * state.
 		 */
 		if (args->rmtblkno > 0) {
-			error = xfs_attr_rmtval_find_space(dac);
+			error = xfs_attr_rmtval_find_space(attr);
 			if (error)
 				return error;
 		}
@@ -504,14 +507,14 @@ xfs_attr_set_iter(
 		 * after we create the attribute so that we don't overflow the
 		 * maximum size of a transaction and/or hit a deadlock.
 		 */
-		dac->dela_state = XFS_DAS_ALLOC_NODE;
+		attr->xattri_dela_state = XFS_DAS_ALLOC_NODE;
 		if (args->rmtblkno > 0) {
-			if (dac->blkcnt > 0) {
-				error = xfs_attr_rmtval_set_blk(dac);
+			if (attr->xattri_blkcnt > 0) {
+				error = xfs_attr_rmtval_set_blk(attr);
 				if (error)
 					return error;
 				trace_xfs_attr_set_iter_return(
-					dac->dela_state, args->dp);
+					attr->xattri_dela_state, args->dp);
 				return -EAGAIN;
 			}
 
@@ -547,8 +550,8 @@ xfs_attr_set_iter(
 			 * Commit the flag value change and start the next trans
 			 * in series
 			 */
-			dac->dela_state = XFS_DAS_FLIP_NFLAG;
-			trace_xfs_attr_set_iter_return(dac->dela_state,
+			attr->xattri_dela_state = XFS_DAS_FLIP_NFLAG;
+			trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
 						       args->dp);
 			return -EAGAIN;
 		}
@@ -568,18 +571,19 @@ xfs_attr_set_iter(
 		fallthrough;
 	case XFS_DAS_RM_NBLK:
 		/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
-		dac->dela_state = XFS_DAS_RM_NBLK;
+		attr->xattri_dela_state = XFS_DAS_RM_NBLK;
 		if (args->rmtblkno) {
-			error = xfs_attr_rmtval_remove(dac);
+			error = xfs_attr_rmtval_remove(attr);
 			if (error == -EAGAIN)
 				trace_xfs_attr_set_iter_return(
-					dac->dela_state, args->dp);
+					attr->xattri_dela_state, args->dp);
 
 			if (error)
 				return error;
 
-			dac->dela_state = XFS_DAS_CLR_FLAG;
-			trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
+			attr->xattri_dela_state = XFS_DAS_CLR_FLAG;
+			trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
+						       args->dp);
 			return -EAGAIN;
 		}
 
@@ -589,7 +593,7 @@ xfs_attr_set_iter(
 		 * The last state for node format. Look up the old attr and
 		 * remove it.
 		 */
-		error = xfs_attr_node_addname_clear_incomplete(dac);
+		error = xfs_attr_node_addname_clear_incomplete(attr);
 		break;
 	default:
 		ASSERT(0);
@@ -786,7 +790,7 @@ xfs_attr_item_init(
 
 	new = kmem_zalloc(sizeof(struct xfs_attr_item), KM_NOFS);
 	new->xattri_op_flags = op_flags;
-	new->xattri_dac.da_args = args;
+	new->xattri_da_args = args;
 
 	*attr = new;
 	return 0;
@@ -1099,16 +1103,16 @@ xfs_attr_node_hasname(
 
 STATIC int
 xfs_attr_node_addname_find_attr(
-	struct xfs_delattr_context	*dac)
+	 struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_args		*args = attr->xattri_da_args;
 	int				retval;
 
 	/*
 	 * Search to see if name already exists, and get back a pointer
 	 * to where it should go.
 	 */
-	retval = xfs_attr_node_hasname(args, &dac->da_state);
+	retval = xfs_attr_node_hasname(args, &attr->xattri_da_state);
 	if (retval != -ENOATTR && retval != -EEXIST)
 		return retval;
 
@@ -1136,8 +1140,8 @@ xfs_attr_node_addname_find_attr(
 
 	return 0;
 error:
-	if (dac->da_state)
-		xfs_da_state_free(dac->da_state);
+	if (attr->xattri_da_state)
+		xfs_da_state_free(attr->xattri_da_state);
 	return retval;
 }
 
@@ -1158,10 +1162,10 @@ xfs_attr_node_addname_find_attr(
  */
 STATIC int
 xfs_attr_node_addname(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
-	struct xfs_da_state		*state = dac->da_state;
+	struct xfs_da_args		*args = attr->xattri_da_args;
+	struct xfs_da_state		*state = attr->xattri_da_state;
 	struct xfs_da_state_blk		*blk;
 	int				error;
 
@@ -1192,7 +1196,7 @@ xfs_attr_node_addname(
 			 * this point.
 			 */
 			trace_xfs_attr_node_addname_return(
-					dac->dela_state, args->dp);
+					attr->xattri_dela_state, args->dp);
 			return -EAGAIN;
 		}
 
@@ -1221,9 +1225,9 @@ xfs_attr_node_addname(
 
 STATIC int
 xfs_attr_node_addname_clear_incomplete(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_args		*args = attr->xattri_da_args;
 	struct xfs_da_state		*state = NULL;
 	struct xfs_mount		*mp = args->dp->i_mount;
 	int				retval = 0;
@@ -1327,10 +1331,10 @@ xfs_attr_leaf_mark_incomplete(
  */
 STATIC
 int xfs_attr_node_removename_setup(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
-	struct xfs_da_state		**state = &dac->da_state;
+	struct xfs_da_args		*args = attr->xattri_da_args;
+	struct xfs_da_state		**state = &attr->xattri_da_state;
 	int				error;
 
 	error = xfs_attr_node_hasname(args, state);
@@ -1389,16 +1393,16 @@ xfs_attr_node_removename(
  */
 int
 xfs_attr_remove_iter(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
-	struct xfs_da_state		*state = dac->da_state;
+	struct xfs_da_args		*args = attr->xattri_da_args;
+	struct xfs_da_state		*state = attr->xattri_da_state;
 	int				retval, error = 0;
 	struct xfs_inode		*dp = args->dp;
 
 	trace_xfs_attr_node_removename(args);
 
-	switch (dac->dela_state) {
+	switch (attr->xattri_dela_state) {
 	case XFS_DAS_UNINIT:
 		if (!xfs_inode_hasattr(dp))
 			return -ENOATTR;
@@ -1417,16 +1421,16 @@ xfs_attr_remove_iter(
 		 * Node format may require transaction rolls. Set up the
 		 * state context and fall into the state machine.
 		 */
-		if (!dac->da_state) {
-			error = xfs_attr_node_removename_setup(dac);
+		if (!attr->xattri_da_state) {
+			error = xfs_attr_node_removename_setup(attr);
 			if (error)
 				return error;
-			state = dac->da_state;
+			state = attr->xattri_da_state;
 		}
 
 		fallthrough;
 	case XFS_DAS_RMTBLK:
-		dac->dela_state = XFS_DAS_RMTBLK;
+		attr->xattri_dela_state = XFS_DAS_RMTBLK;
 
 		/*
 		 * If there is an out-of-line value, de-allocate the blocks.
@@ -1439,10 +1443,10 @@ xfs_attr_remove_iter(
 			 * May return -EAGAIN. Roll and repeat until all remote
 			 * blocks are removed.
 			 */
-			error = xfs_attr_rmtval_remove(dac);
+			error = xfs_attr_rmtval_remove(attr);
 			if (error == -EAGAIN) {
 				trace_xfs_attr_remove_iter_return(
-						dac->dela_state, args->dp);
+					attr->xattri_dela_state, args->dp);
 				return error;
 			} else if (error) {
 				goto out;
@@ -1457,8 +1461,10 @@ xfs_attr_remove_iter(
 			error = xfs_attr_refillstate(state);
 			if (error)
 				goto out;
-			dac->dela_state = XFS_DAS_RM_NAME;
-			trace_xfs_attr_remove_iter_return(dac->dela_state, args->dp);
+
+			attr->xattri_dela_state = XFS_DAS_RM_NAME;
+			trace_xfs_attr_remove_iter_return(
+					attr->xattri_dela_state, args->dp);
 			return -EAGAIN;
 		}
 
@@ -1468,7 +1474,7 @@ xfs_attr_remove_iter(
 		 * If we came here fresh from a transaction roll, reattach all
 		 * the buffers to the current transaction.
 		 */
-		if (dac->dela_state == XFS_DAS_RM_NAME) {
+		if (attr->xattri_dela_state == XFS_DAS_RM_NAME) {
 			error = xfs_attr_refillstate(state);
 			if (error)
 				goto out;
@@ -1485,9 +1491,9 @@ xfs_attr_remove_iter(
 			if (error)
 				goto out;
 
-			dac->dela_state = XFS_DAS_RM_SHRINK;
+			attr->xattri_dela_state = XFS_DAS_RM_SHRINK;
 			trace_xfs_attr_remove_iter_return(
-					dac->dela_state, args->dp);
+					attr->xattri_dela_state, args->dp);
 			return -EAGAIN;
 		}
 
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 492762541174..ceb2c18b9cca 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -430,7 +430,7 @@ struct xfs_attr_list_context {
  */
 
 /*
- * Enum values for xfs_delattr_context.da_state
+ * Enum values for xfs_attr_item.xattri_da_state
  *
  * These values are used by delayed attribute operations to keep track  of where
  * they were before they returned -EAGAIN.  A return code of -EAGAIN signals the
@@ -455,7 +455,7 @@ enum xfs_delattr_state {
 };
 
 /*
- * Defines for xfs_delattr_context.flags
+ * Defines for xfs_attr_item.xattri_flags
  */
 #define XFS_DAC_LEAF_ADDNAME_INIT	0x01 /* xfs_attr_leaf_addname init*/
 #define XFS_DAC_DELAYED_OP_INIT		0x02 /* delayed operations init*/
@@ -463,32 +463,25 @@ enum xfs_delattr_state {
 /*
  * Context used for keeping track of delayed attribute operations
  */
-struct xfs_delattr_context {
-	struct xfs_da_args      *da_args;
+struct xfs_attr_item {
+	struct xfs_da_args		*xattri_da_args;
 
 	/*
 	 * Used by xfs_attr_set to hold a leaf buffer across a transaction roll
 	 */
-	struct xfs_buf		*leaf_bp;
+	struct xfs_buf			*xattri_leaf_bp;
 
 	/* Used in xfs_attr_rmtval_set_blk to roll through allocating blocks */
-	struct xfs_bmbt_irec	map;
-	xfs_dablk_t		lblkno;
-	int			blkcnt;
+	struct xfs_bmbt_irec		xattri_map;
+	xfs_dablk_t			xattri_lblkno;
+	int				xattri_blkcnt;
 
 	/* Used in xfs_attr_node_removename to roll through removing blocks */
-	struct xfs_da_state     *da_state;
+	struct xfs_da_state		*xattri_da_state;
 
 	/* Used to keep track of current state of delayed operation */
-	unsigned int            flags;
-	enum xfs_delattr_state  dela_state;
-};
-
-/*
- * List of attrs to commit later.
- */
-struct xfs_attr_item {
-	struct xfs_delattr_context	xattri_dac;
+	unsigned int			xattri_flags;
+	enum xfs_delattr_state		xattri_dela_state;
 
 	/*
 	 * Indicates if the attr operation is a set or a remove
@@ -496,7 +489,10 @@ struct xfs_attr_item {
 	 */
 	unsigned int			xattri_op_flags;
 
-	/* used to log this item to an intent */
+	/*
+	 * used to log this item to an intent containing a list of attrs to
+	 * commit later
+	 */
 	struct list_head		xattri_list;
 };
 
@@ -516,11 +512,9 @@ bool xfs_attr_is_leaf(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
-int xfs_attr_set_iter(struct xfs_delattr_context *dac);
-int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
+int xfs_attr_set_iter(struct xfs_attr_item *attr);
+int xfs_attr_remove_iter(struct xfs_attr_item *attr);
 bool xfs_attr_namecheck(const void *name, size_t length);
-void xfs_delattr_context_init(struct xfs_delattr_context *dac,
-			      struct xfs_da_args *args);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
 int xfs_attr_set_deferred(struct xfs_da_args *args);
 int xfs_attr_remove_deferred(struct xfs_da_args *args);
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index c806319134fb..4250159ecced 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -568,14 +568,14 @@ xfs_attr_rmtval_stale(
  */
 int
 xfs_attr_rmtval_find_space(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
-	struct xfs_bmbt_irec		*map = &dac->map;
+	struct xfs_da_args		*args = attr->xattri_da_args;
+	struct xfs_bmbt_irec		*map = &attr->xattri_map;
 	int				error;
 
-	dac->lblkno = 0;
-	dac->blkcnt = 0;
+	attr->xattri_lblkno = 0;
+	attr->xattri_blkcnt = 0;
 	args->rmtblkcnt = 0;
 	args->rmtblkno = 0;
 	memset(map, 0, sizeof(struct xfs_bmbt_irec));
@@ -584,8 +584,8 @@ xfs_attr_rmtval_find_space(
 	if (error)
 		return error;
 
-	dac->blkcnt = args->rmtblkcnt;
-	dac->lblkno = args->rmtblkno;
+	attr->xattri_blkcnt = args->rmtblkcnt;
+	attr->xattri_lblkno = args->rmtblkno;
 
 	return 0;
 }
@@ -598,17 +598,18 @@ xfs_attr_rmtval_find_space(
  */
 int
 xfs_attr_rmtval_set_blk(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_args		*args = attr->xattri_da_args;
 	struct xfs_inode		*dp = args->dp;
-	struct xfs_bmbt_irec		*map = &dac->map;
+	struct xfs_bmbt_irec		*map = &attr->xattri_map;
 	int nmap;
 	int error;
 
 	nmap = 1;
-	error = xfs_bmapi_write(args->trans, dp, (xfs_fileoff_t)dac->lblkno,
-			dac->blkcnt, XFS_BMAPI_ATTRFORK, args->total,
+	error = xfs_bmapi_write(args->trans, dp,
+			(xfs_fileoff_t)attr->xattri_lblkno,
+			attr->xattri_blkcnt, XFS_BMAPI_ATTRFORK, args->total,
 			map, &nmap);
 	if (error)
 		return error;
@@ -618,8 +619,8 @@ xfs_attr_rmtval_set_blk(
 	       (map->br_startblock != HOLESTARTBLOCK));
 
 	/* roll attribute extent map forwards */
-	dac->lblkno += map->br_blockcount;
-	dac->blkcnt -= map->br_blockcount;
+	attr->xattri_lblkno += map->br_blockcount;
+	attr->xattri_blkcnt -= map->br_blockcount;
 
 	return 0;
 }
@@ -673,9 +674,9 @@ xfs_attr_rmtval_invalidate(
  */
 int
 xfs_attr_rmtval_remove(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_args		*args = attr->xattri_da_args;
 	int				error, done;
 
 	/*
@@ -695,7 +696,8 @@ xfs_attr_rmtval_remove(
 	 * the parent
 	 */
 	if (!done) {
-		trace_xfs_attr_rmtval_remove_return(dac->dela_state, args->dp);
+		trace_xfs_attr_rmtval_remove_return(attr->xattri_dela_state,
+						    args->dp);
 		return -EAGAIN;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
index d72eff30ca18..62b398edec3f 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.h
+++ b/fs/xfs/libxfs/xfs_attr_remote.h
@@ -12,9 +12,9 @@ int xfs_attr_rmtval_get(struct xfs_da_args *args);
 int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
 		xfs_buf_flags_t incore_flags);
 int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
-int xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
+int xfs_attr_rmtval_remove(struct xfs_attr_item *attr);
 int xfs_attr_rmt_find_hole(struct xfs_da_args *args);
 int xfs_attr_rmtval_set_value(struct xfs_da_args *args);
-int xfs_attr_rmtval_set_blk(struct xfs_delattr_context *dac);
-int xfs_attr_rmtval_find_space(struct xfs_delattr_context *dac);
+int xfs_attr_rmtval_set_blk(struct xfs_attr_item *attr);
+int xfs_attr_rmtval_find_space(struct xfs_attr_item *attr);
 #endif /* __XFS_ATTR_REMOTE_H__ */
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 69646a8b6e09..2f48e84754ae 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -284,11 +284,11 @@ xfs_attrd_item_release(
  */
 STATIC int
 xfs_trans_attr_finish_update(
-	struct xfs_delattr_context	*dac,
+	struct xfs_attr_item		*attr,
 	struct xfs_attrd_log_item	*attrdp,
 	uint32_t			op_flags)
 {
-	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_args		*args = attr->xattri_da_args;
 	unsigned int			op = op_flags &
 					     XFS_ATTR_OP_FLAGS_TYPE_MASK;
 	int				error;
@@ -300,11 +300,11 @@ xfs_trans_attr_finish_update(
 
 	switch (op) {
 	case XFS_ATTR_OP_FLAGS_SET:
-		error = xfs_attr_set_iter(dac);
+		error = xfs_attr_set_iter(attr);
 		break;
 	case XFS_ATTR_OP_FLAGS_REMOVE:
 		ASSERT(XFS_IFORK_Q(args->dp));
-		error = xfs_attr_remove_iter(dac);
+		error = xfs_attr_remove_iter(attr);
 		break;
 	default:
 		error = -EFSCORRUPTED;
@@ -348,16 +348,16 @@ xfs_attr_log_item(
 	 * structure with fields from this xfs_attr_item
 	 */
 	attrp = &attrip->attri_format;
-	attrp->alfi_ino = attr->xattri_dac.da_args->dp->i_ino;
+	attrp->alfi_ino = attr->xattri_da_args->dp->i_ino;
 	attrp->alfi_op_flags = attr->xattri_op_flags;
-	attrp->alfi_value_len = attr->xattri_dac.da_args->valuelen;
-	attrp->alfi_name_len = attr->xattri_dac.da_args->namelen;
-	attrp->alfi_attr_flags = attr->xattri_dac.da_args->attr_filter;
-
-	attrip->attri_name = (void *)attr->xattri_dac.da_args->name;
-	attrip->attri_value = attr->xattri_dac.da_args->value;
-	attrip->attri_name_len = attr->xattri_dac.da_args->namelen;
-	attrip->attri_value_len = attr->xattri_dac.da_args->valuelen;
+	attrp->alfi_value_len = attr->xattri_da_args->valuelen;
+	attrp->alfi_name_len = attr->xattri_da_args->namelen;
+	attrp->alfi_attr_flags = attr->xattri_da_args->attr_filter;
+
+	attrip->attri_name = (void *)attr->xattri_da_args->name;
+	attrip->attri_value = attr->xattri_da_args->value;
+	attrip->attri_name_len = attr->xattri_da_args->namelen;
+	attrip->attri_value_len = attr->xattri_da_args->valuelen;
 }
 
 /* Get an ATTRI. */
@@ -398,10 +398,8 @@ xfs_attr_finish_item(
 	struct xfs_attr_item		*attr;
 	struct xfs_attrd_log_item	*done_item = NULL;
 	int				error;
-	struct xfs_delattr_context	*dac;
 
 	attr = container_of(item, struct xfs_attr_item, xattri_list);
-	dac = &attr->xattri_dac;
 	if (done)
 		done_item = ATTRD_ITEM(done);
 
@@ -409,9 +407,9 @@ xfs_attr_finish_item(
 	 * Always reset trans after EAGAIN cycle
 	 * since the transaction is new
 	 */
-	dac->da_args->trans = tp;
+	attr->xattri_da_args->trans = tp;
 
-	error = xfs_trans_attr_finish_update(dac, done_item,
+	error = xfs_trans_attr_finish_update(attr, done_item,
 					     attr->xattri_op_flags);
 	if (error != -EAGAIN)
 		kmem_free(attr);
@@ -585,7 +583,7 @@ xfs_attri_item_recover(
 			   sizeof(struct xfs_da_args), KM_NOFS);
 	args = (struct xfs_da_args *)(attr + 1);
 
-	attr->xattri_dac.da_args = args;
+	attr->xattri_da_args = args;
 	attr->xattri_op_flags = attrp->alfi_op_flags;
 
 	args->dp = ip;
@@ -622,7 +620,7 @@ xfs_attri_item_recover(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
-	ret = xfs_trans_attr_finish_update(&attr->xattri_dac, done_item,
+	ret = xfs_trans_attr_finish_update(attr, done_item,
 					   attrp->alfi_op_flags);
 	if (ret == -EAGAIN) {
 		/* There's more work to do, so add it to this transaction */
@@ -636,7 +634,7 @@ xfs_attri_item_recover(
 	}
 
 	error = xfs_defer_ops_capture_and_commit(tp, ip, capture_list,
-						 attr->xattri_dac.leaf_bp);
+						 attr->xattri_leaf_bp);
 
 out_unlock:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-- 
2.25.1

