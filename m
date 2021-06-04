Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FD61C48BC2
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Jun 2021 23:42:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FF4A613FE
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Jun 2021 23:42:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbhFDXob (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Jun 2021 19:44:31 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:48654 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbhFDXoa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Jun 2021 19:44:30 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 154Nghlt067466
        for <linux-xfs@vger.kernel.org>; Fri, 4 Jun 2021 23:42:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=QAS76PG8gCV+t1DEcGzPORiIJl8CPTcLNTqF2xo+fyQ=;
 b=kgaUnrTnn+o80Hdy4tUd3cy+SPMyTsc7IWqaXHxr2TyAtzZCYJDYc2DqIndNDEzsw/nO
 j5V+Cy/HsDjXRY14H/MXgSRGo5IufK0IW/I7X20x3v6T7IdfYGtsdSKVqOrcPoQtScug
 zGEjclrsnsqJ+Pq57Y08hU/mcaBDRKDsRHbabvkHfbkwprHd96wZy7do5we0eFDRguRJ
 MmOYvrllfvvQPnjzirECg+xReNvVFWTxSZ2nE7KYO13BdloQIARe2OTUvqDyfJwV/5XL
 sUg7JJvLpA4Kpys26wA7Kn6ezbJ5kcM6lt1KUq2mbsB2SScNx0G662l0qhu2t6Gex1R7 sg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 38ub4cy2np-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 04 Jun 2021 23:42:43 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 154Nde0U039038
        for <linux-xfs@vger.kernel.org>; Fri, 4 Jun 2021 23:42:43 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by aserp3020.oracle.com with ESMTP id 38xyn50rp7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 04 Jun 2021 23:42:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XID3j0whDQXO40UTviQkEcV0qfHquo0RNf4DnaQnAeMJiRcr1Yu+UiO0n5CPZ/ZcIUSQAjI/737HVpg0Qkndy2iEgP06fvNECzKPAIW6IAe8N0ZDBiZMeRlNzZykyS1TW/ywlcCgyZpIthOTu4D1YDOAiAiMHzIJ9ovb3I//Hcdw6UXPO3zpNfSaW0xVEzCznjkeBW+diFzbETBCZ5pGwvj/sVsZtiA947fnQ0PD07oogJlp97tpl68NMI02/WVMTtP4wxZN6KctHuJD+yZ12UxqEHPmjdZtaJ5+toGHBph3B/7Kb4U7TVjmw/FY0G9RjLnLZP8PkzNQbDjnXvUWAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QAS76PG8gCV+t1DEcGzPORiIJl8CPTcLNTqF2xo+fyQ=;
 b=ZPWMz2qc6mCb9ifK4LokJ39tR+QKiJs/I4H9DmYi6jdet+P8d53k3eKkEE8CUHf2E+/N33QVBGGoUhTWsEy4AE4OOM7WM9WiGRJyPJU8wl0Rbd/YidxyIr2tlNKh+wLCF+Rn2X/NsngcgMh2RRN44tMpuUqARj/RE5eyf2cnUxf8Cv82f+jWJ/AoBpQo2Nq6R3k4OMJQrsm3PWTJNPIQ+fz6RiMqaavMlTerIdioPKCHSqp1CB2ujoIc0eZyEyKQ3ij7d6yOiwulkq0IBK4xrcqVmrcFrx6aHNCU7RmbLIqjPqSBUZmAr4R7UFUsLJVJEPC3zoQu2uORF2nlI7bShA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QAS76PG8gCV+t1DEcGzPORiIJl8CPTcLNTqF2xo+fyQ=;
 b=iQtGS0GEppTnZnNwfH1cAbofmh1e4TybfbYun8eDvXpKYgDLG68EwZADKGWZcRWfVRqL93MudU0fiUbZJ4815zTUifjM81ViVy04YI6vC7Lv1zuVhW96QHkCF/mUuURQl0JuW6BI8bDbwpaze5aOdbSGCG4E0WHifJrlVW+gYAE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB5485.namprd10.prod.outlook.com (2603:10b6:a03:3ab::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Fri, 4 Jun
 2021 23:42:41 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a9c4:d124:3473:1728]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a9c4:d124:3473:1728%5]) with mapi id 15.20.4195.025; Fri, 4 Jun 2021
 23:42:41 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v20 04/14] xfs: Separate xfs_attr_node_addname and xfs_attr_node_addname_clear_incomplete
Date:   Fri,  4 Jun 2021 16:41:56 -0700
Message-Id: <20210604234206.31683-5-allison.henderson@oracle.com>
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
Received: from localhost.localdomain (67.1.210.54) by BYAPR07CA0095.namprd07.prod.outlook.com (2603:10b6:a03:12b::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.21 via Frontend Transport; Fri, 4 Jun 2021 23:42:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e14a38b1-fbe5-4051-b49e-08d927b271cb
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5485:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB548541E7F3E983EABF1BFD34953B9@SJ0PR10MB5485.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8EDjyfc62RCHruvN7x7iSgLvq2o4ueJ/ddBX+eaDbpqnIv+s0xpegH0VeR3lmUIDfZEdRtaAwtZcuilSs75asgXEJ82ag/RpPSb/UxDH6PRHgGRly5tLFUTiaGHtSV6rUeuIxAWmWx7TKtY9moJ0bqAVTVaiyGmjuhWupL8IZYQnEoZvXe1J1ZjRdjuLVQEMZiXAf+CC2loPsJclTO3c06fPfgwT1BaSzXud/GHGunD9SixpFCxIYGQ6blwuT87xeEmpnftAmOwjqtoV6ay853Uon0RLKSrpu7ZlM6PE9fOUl4JEgMtuyDSHvlPkBlwU6IyoFfZYpK674GhpWRacoS/Dq64o6PtlQulJt0zgLj0Q01Glethtjouzb5RzJsjiVolFhyL1tMGel10mv+G7kcktCBJQy3GjbYbADDSwD9C3phkmr0nL/W6jdGlPXtoEsA8xnvFJheyw8zmtgxGbBfuqglQvkVR5HeAvnByEYJ/OpiX/OuNo0PHkYpjI0hT981Yyrw5iJhBAIknm1n+3ZI4/4o07pdmk6OX9sqVTXnh9qWBciUuoChtif6fQWi6zS7Z4tJ2dK/vGF2cEjVTnmq2/h1ddX2I5Mf+Cvav+RUJ6ligrBsrC1Ix273ty5PpWfKRYkmhIQL9cmY5DqTGSONLrgj+X0GmoEgMjmt1Tpqr4zuuF3Kvn9WErzABZLX4m
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(396003)(136003)(346002)(39850400004)(2616005)(66476007)(66556008)(2906002)(66946007)(5660300002)(8676002)(956004)(316002)(186003)(16526019)(6916009)(86362001)(38100700002)(478600001)(38350700002)(8936002)(6666004)(36756003)(26005)(6512007)(1076003)(44832011)(6506007)(52116002)(6486002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?tnB2IFziULDgw1KVcp+8mF3J6BEND4TiBXH03F+/3SxiwR97t/EWZPQNo+In?=
 =?us-ascii?Q?w3XfZkX7/7pOfr8ltIbfPJvTbHT9A5wDMYHae9E7msCGnOwAxPmf8ENHUcjX?=
 =?us-ascii?Q?Yqw/ivSuenrOgJkA1JMDnDQgRUBWmGpt9RzgawzgvmmuPc9izDuUEuT/1Dxn?=
 =?us-ascii?Q?ohcSSAywMiRHav+q+Euq3GIL8EYh2exMCMOF1+6FQD7LgrJgyTBptR8XiFA5?=
 =?us-ascii?Q?5kDyZzPorLPhEmq/uVbzFNxRM3scGQZJx3nGxwV8xUSjtgG7QxP9Q+1SeTMh?=
 =?us-ascii?Q?KD3pDrzgoygIdYSJx/v3Zo6pvbmiZqg6aHIKgIi2nIq+etx58Bs3SC7Udh2Y?=
 =?us-ascii?Q?xCgqkc6YtggfwIDcJ78ZP6P4ViHgFKJqZ3Q8eMfE/TdLez5JG9PiRECxy+oW?=
 =?us-ascii?Q?WMEOdQ75X+ppl/bZqqgeyYY89YK0vc6YhRAqPhtVl2H9AOvBFV8Mrrg/kwRw?=
 =?us-ascii?Q?lTVH9n9QSWy1MHd5E+HTyS5wsqIIHhTyhTsRI6bz5Y7ONYoytB9AFeal8/bR?=
 =?us-ascii?Q?dgSIi7qvYrus0NlHhNWNozutPj+dSgJJx8trZs9rJO0XbS/uVfWIJaPuasYQ?=
 =?us-ascii?Q?ShSXFVIdKqwaJzmyC8u7NFl7UlncFAVah8P6tPUh/Pf7LqhnQuds/m1UAN58?=
 =?us-ascii?Q?lpqQPLP2nWT538X7agg8ES6Wp5/fTV9UEy/l+ZimFSa3ItMYCE7ggKnqInSq?=
 =?us-ascii?Q?asynaC67W8hlxa630ojWBO6zJn9s9/bxKMZEeAkBAELCiWtHCwLUyKv/Myjz?=
 =?us-ascii?Q?724wqFuGxBqejCG1TmBf8e095Xf8l9lJPf6LAWAruVOIpcyXyLGyUGRJq/wR?=
 =?us-ascii?Q?wODOyyra4Tik8SQPqU96jzu8LCGJ2dXo1drPPk39ZoltIKK17TfmEFVkSv5Z?=
 =?us-ascii?Q?hVyLKSpQZ4NOLbCQ0NROeGMhxkLS/A3QMl5QMemdTX4BsvqZy/YAedJjdnFb?=
 =?us-ascii?Q?mnquX25fwRdwB8RCpo83UGtgl4NpIIHS8UwPCZL80nWaDd2k86VBLK+6hUPZ?=
 =?us-ascii?Q?DLW55C3sAhsOu1Y13SjlTeVrIKRwSBhozFkXzoWI3XRL1oHUAesVYbsaDsY5?=
 =?us-ascii?Q?hfTJhhCDza/EZp5KFzDTtwf4+UCjL5qSJgstnezj2zGh/4K73fmoGwcZOSlI?=
 =?us-ascii?Q?LerrsJ42Sw9fkti0kovwU5xDqQXKZ56uKi9ZGhc1tNZWeY2PQi6Xa+RGrnke?=
 =?us-ascii?Q?9oW6XUNzo4cn4E8F6ljHj0ous3hErNvVR3jNZuzogckjOtRg82ym5+Z5ePZD?=
 =?us-ascii?Q?u5monIc9aEclis7XS0e1hKeAQECT986KTgVB1lX9VYutrmwsi2zPWc4WkL+Q?=
 =?us-ascii?Q?ladBaV1JvHRS8PtUkL4AS1PN?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e14a38b1-fbe5-4051-b49e-08d927b271cb
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2021 23:42:41.8145
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4giefzCcV9qxIzFnPdqLC01+uel+XDW3TavrC5DaMxXHMZLFIoi/o+H31IYBnHI5xIURIH6Y13dRRmKbSekmSgIgOeDxiDH2MrYoWRdulPo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5485
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10005 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 bulkscore=0 suspectscore=0 mlxscore=0 malwarescore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106040162
X-Proofpoint-GUID: R6J-UCcYHC4__7Q1yUIRQGTjk-ELFepk
X-Proofpoint-ORIG-GUID: R6J-UCcYHC4__7Q1yUIRQGTjk-ELFepk
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10005 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 lowpriorityscore=0
 clxscore=1015 impostorscore=0 adultscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106040162
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch separate xfs_attr_node_addname into two functions.  This will
help to make it easier to hoist parts of xfs_attr_node_addname that need
state management

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 0ec1547..ad44d77 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -54,6 +54,7 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
 STATIC int xfs_attr_node_get(xfs_da_args_t *args);
 STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
 STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
+STATIC int xfs_attr_node_addname_clear_incomplete(struct xfs_da_args *args);
 STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
 				 struct xfs_da_state **state);
 STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
@@ -1073,6 +1074,28 @@ xfs_attr_node_addname(
 			return error;
 	}
 
+	error = xfs_attr_node_addname_clear_incomplete(args);
+	if (error)
+		goto out;
+	retval = 0;
+out:
+	if (state)
+		xfs_da_state_free(state);
+	if (error)
+		return error;
+	return retval;
+}
+
+
+STATIC int
+xfs_attr_node_addname_clear_incomplete(
+	struct xfs_da_args		*args)
+{
+	struct xfs_da_state		*state = NULL;
+	struct xfs_da_state_blk		*blk;
+	int				retval = 0;
+	int				error = 0;
+
 	/*
 	 * Re-find the "old" attribute entry after any split ops. The INCOMPLETE
 	 * flag means that we will find the "old" attr, not the "new" one.
-- 
2.7.4

