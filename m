Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05E57C19F31
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:21:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E37D260F94
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:21:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235659AbhG0GVV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 02:21:21 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:6460 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235657AbhG0GVR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 02:21:17 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R6GfrG007119
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:21:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=e61Am3qgAmGknvEOsNiHtF6hjhKvkrpI4uhMvKOX6N8=;
 b=l95lDwIrNdaehqv3CYuLNs/wwnBpBI4pbF1QP/mpNg8+2H5kDHLj4lnxhxiGxBGXcWBe
 tMDMpMqalPFyexSNaFCSlAT7rNGO+mSOjI79GEYD7jbeFvuxvagFkbV5eDFm8DwFz7Q7
 h2JgeJ8rYJXv82BQKFNVVycjZWw4jhgh9z5HozI73QOcYTxd7qCmRXGv+XHR3GlubOcC
 ThFOZ0e6YPtmu5ebKEwMzRbG/JNwcCPg8zofRy1nJp8eDUuOCK4IDbZTRnYwdxMVcxWa
 X+aDdb9Hj5W0Nlt7UiVLibviJhBZaxTULQl2HMLIMX/XmfeADgQg93xGmE1EKqLCPOO9 NA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=e61Am3qgAmGknvEOsNiHtF6hjhKvkrpI4uhMvKOX6N8=;
 b=Wfa78HcGIobRZuKfR609dl1iGytMGSHIFJBmnCJ6m174yXVwegjrWwLrYb4PMMlxVRKP
 6hlowCiETv2kAxeBpw3TzKsB2ZRHHxy0zjzx1xXZwbSxfrOMdwHfUf8DADzUBjFA7WSN
 xUPXYPnx/LIwO3dtkvDDoNDKmKBeDvqprQkc6JzipGAa2GVFMW/2t6wXRb3JsQAZbqwf
 EXdfCaeNRImlhE/d0uIlQ4W2oJmnlSm+5HOhhHomvaWWtM7bFboDUqJet82+AtDJllMM
 Nunr8OqXDxJmd2glY2C+1nwElz9HoAh4cEpB7hFLWsdYkfdc8FymgcaAadr0J1nTZ3dg Ng== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a234n0ufn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:21:16 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16R6FT1v019894
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:21:15 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2042.outbound.protection.outlook.com [104.47.57.42])
        by aserp3020.oracle.com with ESMTP id 3a2347k0as-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:21:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kqKsMC2SA07LY00KWn3YfTeqNBsMiLSoZqjYAKXjdBSVwkkUNx20jL8n4TnySwEo0wlajOVRoiWtPXzUaw9kvah4Fts4nNPEHgMl7WttyixSpwWwVSLEhyvWU/We7dZsvA0Qbpcxj/7Y5KIXx01SZLoRH95VuhTPF1N388QCtJ6aIOLoEDMCHB+I6QLz5poYgYOAx0+zBEEbk6SUdSL68itqZNjDoGyZC8xH8dySFcSCQ8YpUDw5VVTZhplU3x924srfTRm4RFFPEnIEi0FUR98R1Ame5kXJ5m4eTiJagyYoxCnoC3QO2qIBLKb96ZUgCG++KnF7SyJDOosycpSucg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e61Am3qgAmGknvEOsNiHtF6hjhKvkrpI4uhMvKOX6N8=;
 b=d/SePhM5QKwUW9ms0fYu3nPorb4sNhVi+kTSiEhELZ1d/1XqxK4twHolxHTtYI0LX1ogyi4hJ4PQ4rlwQcIdM5qs2ZZLI++wI1f9APXub6WGqfazMjKlJ/TPpwjA8ZCcAFZPC1tdw4H9Hr9B1bVG92w+afk4YAZ6PhfsdWs7kKjcbUzbf3+gvW3PZ0w7a5rjwaf39Szke5ywFo7Pm7TNq7SsdFBp7olTdrU3yORhkomzPldgGBSjiCVyTAbkrsRDh7iEMrQW7YALC46pl0uQMFF0S1IF825zS/E+Y1SHYKBsGcAuxvu5zZJtUoswHo2XPpdD6k1XzeJAc71mEAcCBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e61Am3qgAmGknvEOsNiHtF6hjhKvkrpI4uhMvKOX6N8=;
 b=jan7p+QBtaI97dd4dRDGoZEJri2Tl18+zqFPVHPjZU9cyws210jkLAb9Vf2OERzGry/dNfVbV0ggNwxmnJP5KV+OZeb2B8/QuzkLgakHeZoRmtFlapVtbb0pqYDr87cMn2tkTptfOS3gAiRmBw1u+e3Wmd9Xxlu+bKxlk0SN/5A=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3383.namprd10.prod.outlook.com (2603:10b6:a03:15c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Tue, 27 Jul
 2021 06:21:13 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 06:21:13 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v22 12/16] xfs: Remove unused xfs_attr_*_args
Date:   Mon, 26 Jul 2021 23:20:49 -0700
Message-Id: <20210727062053.11129-13-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210727062053.11129-1-allison.henderson@oracle.com>
References: <20210727062053.11129-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0191.namprd05.prod.outlook.com
 (2603:10b6:a03:330::16) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by SJ0PR05CA0191.namprd05.prod.outlook.com (2603:10b6:a03:330::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend Transport; Tue, 27 Jul 2021 06:21:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7e1bfc31-5259-4c28-e3ee-08d950c6bb26
X-MS-TrafficTypeDiagnostic: BYAPR10MB3383:
X-Microsoft-Antispam-PRVS: <BYAPR10MB33838B71C2E3F1979BC57A0B95E99@BYAPR10MB3383.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FaUVf6FnXUWBUtcECDFAHruSGSFwWadCKzp7o2/DHh0oDHFmkqQUwWC1RM0oxG+lcxR5LrTwOz+tWtWscy2DS7Y/BhowewgrjVWf5rGrX3oZYf03im5/bb7x+FTi/1U4QDcv9ZBIw6sM6Hkoi2pVS4XOgYjKFYnb7sXI5dMNxYZnmyVh3BeFImmRmq9lIUPfgIuRmetbznqi7eNTRd9MYQ+Ycfflb+MATJJJA6kjiUYB/RiY3bnPCl0K2HmcwlrMisoiXzRLhDjwy2ioEdcISK5xk52f67QYkwBjffPsE0bJcycuQ54oQZrgDPxlePOYfXKOLvRN8WWG1lhrBPPU4b1Krw1wGw1sgSDZ2MRwlutpo+WyuHeIMX3YD8OOcPF6wmhBY4HOwUVvr9DVsyEyl6WyRaZvWOqk7EhElp8mdCWLK1Ny7+WsTZVl+Hml01UienEXLb1kqgk1HpbDK96TAByBNwhfdgeqX0l9WkAJ1of8GD5m0t87NKgA+NyoS5KSFwzdkcgAcK1ixyB6WRPT5vMxcXcW8yPdKUknpzK/SAxPIE20hOOvZ+MA8/yiKhltsnc80W+12rgSMzogRPPR1ntPEGWNO3oUiZh6WMDyjGQzTIwjmJHtcVPrKAu7aPVoZjcbZMUp37aEgsiW3FfYzo2VjjqNrXxauj1sQ2yzYniF8aQyms9JWREVGsRr/bA+DwmJ7fYktFSYCeq81MryIw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(376002)(39860400002)(136003)(346002)(44832011)(956004)(36756003)(26005)(2616005)(6512007)(6506007)(186003)(6486002)(86362001)(6666004)(2906002)(8936002)(1076003)(6916009)(66946007)(52116002)(83380400001)(66476007)(66556008)(38350700002)(38100700002)(8676002)(316002)(5660300002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1nQPxc0AVQk20LMIHW4x4ZOUmU5cX9WBBiCgs6mJeeB4yjwKOjg102QUF1Rg?=
 =?us-ascii?Q?N0ttrcS+MwvXpW3jOPUqOunmt2UpAj+Jv+2av/0Zd5QA4+Opx6cf6L4+o4/E?=
 =?us-ascii?Q?7I4PE3bFu4sWNnNMoQTQCIUwHmDuEWhdzyq5cDi1nL+7W17uPFDln78jwDly?=
 =?us-ascii?Q?LE8elshc7cu3/ME1I4ViS725F0OBWyZhojgFn1UTWnI5AfNhwTAoQ8QUQb7j?=
 =?us-ascii?Q?N2ohsTL65P5ju44Ev2yMv+nKvg9WTIGz2XkiLSKPLiIsWxU003EztYUPqqDN?=
 =?us-ascii?Q?wvgyWhi4m8m2rgmV7zGdCFaI9MzswH3cMfo+cTSeRmU/nTbrR7O5Xt7KVEi3?=
 =?us-ascii?Q?iz+XDfqziRkuEkmAP9K74S+gXruSC1abSe2hd1gzFB2xmISGKyi3GXhqeqQP?=
 =?us-ascii?Q?C2BDLipNqm/Iq+M5i5uwbFSTFiklUNvSrBkKurkrPstbvbCHIfUjUugg3S1F?=
 =?us-ascii?Q?j7rsxVnQxqrQ9FecPd7K/vUHWDVgfB4ELogXh/y6kjQkf5gsbdIFJlR10Qih?=
 =?us-ascii?Q?NmQ0OImUrDl0XCsTDMz2PtY1d71YR2Apn1VB3QJkuAbvWkBDbrrO9Z8nGOui?=
 =?us-ascii?Q?nCM76tyDfn7Y7SULfX3z5RyfQ0PgiiXezKw7rwTi6Pms8KYDSQLWAigjqtSK?=
 =?us-ascii?Q?+fjf5XmbIvR5sssptBCSIn1s+KK/w1NfHEvPjZsIKdWvezLfAxuj+n3qndFR?=
 =?us-ascii?Q?G6KYrx2a5AblY+byvGhZmc+kq9iO+08fF4o/N5zhWUqztWMCSUEStqsZ+BQJ?=
 =?us-ascii?Q?esHr1UJlP1UKFAOqSf4sVC3iLAza6Amt8MHxbCCeWNVPNZkooKgmKc3xFMuV?=
 =?us-ascii?Q?1Y6GjNMDeQgcez31Hh9EVJqph3uF+eKumw9eDHQUbY22u1StQ3CWxgc0Vpmt?=
 =?us-ascii?Q?UE2cEvSjfb77KSCChgmiy7Gtdp3BZA6o7nNvsA2UPhKpNjgoqxxNQnXPG8DQ?=
 =?us-ascii?Q?+5Sf180A4L0782Qk3EEQFtK8DwcV0HX6gf89u1HXwx2DRJUAecLOJGVHivAm?=
 =?us-ascii?Q?I3IQ5njOIwcg3kEPyccOaE4ZEmx9UtEMPwrd/7cvcqlN3tz1iyaHRVZNpfyo?=
 =?us-ascii?Q?QVOyX/BdkKPxVG0JJZiAwjyN1bBsJZWLtMSKjtG5kq2c/0JrBtF4CT1zNnB6?=
 =?us-ascii?Q?Tn9Mm5JjdYBgCAXtVdU589kX5VWJ1P+lxynPLv2x0T3dSELTnn2HskivWwqt?=
 =?us-ascii?Q?iUN64Q72EMnz/6rASKVQgFxBR4EoIsOGcWytZGQ5sxXX9Fv1jB2CuqmYXD5r?=
 =?us-ascii?Q?sxkgIP5/mq3563mmJQlXV/L+cKy9c9cJFggm5tKh9ecFH7qxlaUIqF6ywX3G?=
 =?us-ascii?Q?7lNNrWifQ6YU5diTxToxuSUm?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e1bfc31-5259-4c28-e3ee-08d950c6bb26
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 06:21:12.4833
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M4Ry0FE/KLLTc9Wk/jxIYPGBDjciCI9Tg4klCjBfbf3YZgTdtdSozRdQjJFdUPQVfQEyhiryQ+ic4DLkw9/46sBL6bDwhT0zryBYYsdGq/I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3383
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 suspectscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2107270037
X-Proofpoint-ORIG-GUID: 6FqtKg7lmuLmzd2GPIl2WB44FeumJ89L
X-Proofpoint-GUID: 6FqtKg7lmuLmzd2GPIl2WB44FeumJ89L
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Remove xfs_attr_set_args, xfs_attr_remove_args, and xfs_attr_trans_roll.
These high level loops are now driven by the delayed operations code,
and can be removed.

Additionally collapse in the leaf_bp parameter of xfs_attr_set_iter
since we only have one caller that passes dac->leaf_bp

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c        | 96 +++--------------------------------------
 fs/xfs/libxfs/xfs_attr.h        | 10 ++---
 fs/xfs/libxfs/xfs_attr_remote.c |  1 -
 fs/xfs/xfs_attr_item.c          |  6 +--
 4 files changed, 10 insertions(+), 103 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index c447c21..ec03a7b 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -244,67 +244,13 @@ xfs_attr_is_shortform(
 		ip->i_afp->if_nextents == 0);
 }
 
-/*
- * Checks to see if a delayed attribute transaction should be rolled.  If so,
- * transaction is finished or rolled as needed.
- */
-STATIC int
-xfs_attr_trans_roll(
-	struct xfs_delattr_context	*dac)
-{
-	struct xfs_da_args		*args = dac->da_args;
-	int				error;
-
-	if (dac->flags & XFS_DAC_DEFER_FINISH) {
-		/*
-		 * The caller wants us to finish all the deferred ops so that we
-		 * avoid pinning the log tail with a large number of deferred
-		 * ops.
-		 */
-		dac->flags &= ~XFS_DAC_DEFER_FINISH;
-		error = xfs_defer_finish(&args->trans);
-	} else
-		error = xfs_trans_roll_inode(&args->trans, args->dp);
-
-	return error;
-}
-
-/*
- * Set the attribute specified in @args.
- */
-int
-xfs_attr_set_args(
-	struct xfs_da_args		*args)
-{
-	struct xfs_buf			*leaf_bp = NULL;
-	int				error = 0;
-	struct xfs_delattr_context	dac = {
-		.da_args	= args,
-	};
-
-	do {
-		error = xfs_attr_set_iter(&dac, &leaf_bp);
-		if (error != -EAGAIN)
-			break;
-
-		error = xfs_attr_trans_roll(&dac);
-		if (error) {
-			if (leaf_bp)
-				xfs_trans_brelse(args->trans, leaf_bp);
-			return error;
-		}
-	} while (true);
-
-	return error;
-}
-
 STATIC int
 xfs_attr_sf_addname(
-	struct xfs_delattr_context	*dac,
-	struct xfs_buf			**leaf_bp)
+	struct xfs_delattr_context	*dac)
 {
 	struct xfs_da_args		*args = dac->da_args;
 	struct xfs_inode		*dp = args->dp;
+	struct xfs_buf			**leaf_bp = &dac->leaf_bp;
 	int				error = 0;
 
 	/*
@@ -337,7 +283,6 @@ xfs_attr_sf_addname(
 	 * add.
 	 */
 	trace_xfs_attr_sf_addname_return(XFS_DAS_UNINIT, args->dp);
-	dac->flags |= XFS_DAC_DEFER_FINISH;
 	return -EAGAIN;
 }
 
@@ -350,10 +295,10 @@ xfs_attr_sf_addname(
  */
 int
 xfs_attr_set_iter(
-	struct xfs_delattr_context	*dac,
-	struct xfs_buf			**leaf_bp)
+	struct xfs_delattr_context	*dac)
 {
 	struct xfs_da_args              *args = dac->da_args;
+	struct xfs_buf			**leaf_bp = &dac->leaf_bp;
 	struct xfs_inode		*dp = args->dp;
 	struct xfs_buf			*bp = NULL;
 	int				forkoff, error = 0;
@@ -370,7 +315,7 @@ xfs_attr_set_iter(
 		 * release the hold once we return with a clean transaction.
 		 */
 		if (xfs_attr_is_shortform(dp))
-			return xfs_attr_sf_addname(dac, leaf_bp);
+			return xfs_attr_sf_addname(dac);
 		if (*leaf_bp != NULL) {
 			xfs_trans_bhold_release(args->trans, *leaf_bp);
 			*leaf_bp = NULL;
@@ -396,7 +341,6 @@ xfs_attr_set_iter(
 				 * be a node, so we'll fall down into the node
 				 * handling code below
 				 */
-				dac->flags |= XFS_DAC_DEFER_FINISH;
 				trace_xfs_attr_set_iter_return(
 					dac->dela_state, args->dp);
 				return -EAGAIN;
@@ -685,32 +629,6 @@ xfs_has_attr(
 }
 
 /*
- * Remove the attribute specified in @args.
- */
-int
-xfs_attr_remove_args(
-	struct xfs_da_args	*args)
-{
-	int				error;
-	struct xfs_delattr_context	dac = {
-		.da_args	= args,
-	};
-
-	do {
-		error = xfs_attr_remove_iter(&dac);
-		if (error != -EAGAIN)
-			break;
-
-		error = xfs_attr_trans_roll(&dac);
-		if (error)
-			return error;
-
-	} while (true);
-
-	return error;
-}
-
-/*
  * Note: If args->value is NULL the attribute will be removed, just like the
  * Linux ->setattr API.
  */
@@ -1272,7 +1190,6 @@ xfs_attr_node_addname(
 			 * this. dela_state is still unset by this function at
 			 * this point.
 			 */
-			dac->flags |= XFS_DAC_DEFER_FINISH;
 			trace_xfs_attr_node_addname_return(
 					dac->dela_state, args->dp);
 			return -EAGAIN;
@@ -1287,7 +1204,6 @@ xfs_attr_node_addname(
 		error = xfs_da3_split(state);
 		if (error)
 			goto out;
-		dac->flags |= XFS_DAC_DEFER_FINISH;
 	} else {
 		/*
 		 * Addition succeeded, update Btree hashvals.
@@ -1538,7 +1454,6 @@ xfs_attr_remove_iter(
 			if (error)
 				goto out;
 			dac->dela_state = XFS_DAS_RM_NAME;
-			dac->flags |= XFS_DAC_DEFER_FINISH;
 			return -EAGAIN;
 		}
 
@@ -1565,7 +1480,6 @@ xfs_attr_remove_iter(
 			if (error)
 				goto out;
 
-			dac->flags |= XFS_DAC_DEFER_FINISH;
 			dac->dela_state = XFS_DAS_RM_SHRINK;
 			trace_xfs_attr_remove_iter_return(
 					dac->dela_state, args->dp);
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 72b0ea5..c0c92bd3 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -457,9 +457,8 @@ enum xfs_delattr_state {
 /*
  * Defines for xfs_delattr_context.flags
  */
-#define XFS_DAC_DEFER_FINISH		0x01 /* finish the transaction */
-#define XFS_DAC_LEAF_ADDNAME_INIT	0x02 /* xfs_attr_leaf_addname init*/
-#define XFS_DAC_DELAYED_OP_INIT		0x04 /* delayed operations init*/
+#define XFS_DAC_LEAF_ADDNAME_INIT	0x01 /* xfs_attr_leaf_addname init*/
+#define XFS_DAC_DELAYED_OP_INIT		0x02 /* delayed operations init*/
 
 /*
  * Context used for keeping track of delayed attribute operations
@@ -517,11 +516,8 @@ bool xfs_attr_is_leaf(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
-int xfs_attr_set_args(struct xfs_da_args *args);
-int xfs_attr_set_iter(struct xfs_delattr_context *dac,
-		      struct xfs_buf **leaf_bp);
+int xfs_attr_set_iter(struct xfs_delattr_context *dac);
 int xfs_has_attr(struct xfs_da_args *args);
-int xfs_attr_remove_args(struct xfs_da_args *args);
 int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
 bool xfs_attr_namecheck(const void *name, size_t length);
 void xfs_delattr_context_init(struct xfs_delattr_context *dac,
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 1669043..e29c2b9 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -695,7 +695,6 @@ xfs_attr_rmtval_remove(
 	 * the parent
 	 */
 	if (!done) {
-		dac->flags |= XFS_DAC_DEFER_FINISH;
 		trace_xfs_attr_rmtval_remove_return(dac->dela_state, args->dp);
 		return -EAGAIN;
 	}
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 44c44d9..12a0151 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -285,7 +285,6 @@ STATIC int
 xfs_trans_attr_finish_update(
 	struct xfs_delattr_context	*dac,
 	struct xfs_attrd_log_item	*attrdp,
-	struct xfs_buf			**leaf_bp,
 	uint32_t			op_flags)
 {
 	struct xfs_da_args		*args = dac->da_args;
@@ -300,7 +299,7 @@ xfs_trans_attr_finish_update(
 	switch (op) {
 	case XFS_ATTR_OP_FLAGS_SET:
 		args->op_flags |= XFS_DA_OP_ADDNAME;
-		error = xfs_attr_set_iter(dac, leaf_bp);
+		error = xfs_attr_set_iter(dac);
 		break;
 	case XFS_ATTR_OP_FLAGS_REMOVE:
 		ASSERT(XFS_IFORK_Q(args->dp));
@@ -424,7 +423,7 @@ xfs_attr_finish_item(
 	 */
 	dac->da_args->trans = tp;
 
-	error = xfs_trans_attr_finish_update(dac, done_item, &dac->leaf_bp,
+	error = xfs_trans_attr_finish_update(dac, done_item,
 					     attr->xattri_op_flags);
 	if (error != -EAGAIN)
 		kmem_free(attr);
@@ -640,7 +639,6 @@ xfs_attri_item_recover(
 	xfs_trans_ijoin(tp, ip, 0);
 
 	ret = xfs_trans_attr_finish_update(&attr->xattri_dac, done_item,
-					   &attr->xattri_dac.leaf_bp,
 					   attrp->alfi_op_flags);
 	if (ret == -EAGAIN) {
 		/* There's more work to do, so add it to this transaction */
-- 
2.7.4

