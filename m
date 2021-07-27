Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33C7AC4320E
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:20:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F9DC61107
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:20:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235724AbhG0GUI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 02:20:08 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:51812 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235718AbhG0GTw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 02:19:52 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R6G8Ps024355
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=LVXiYrc8zJ36wJ2cmleTKxT9EdHvQrSciQjMlXsSbPE=;
 b=ArUfrK3iet++rC2NU4r8Rn0uAMbtaFiBqxLAfC+FYYTD07btxJeA7jLgziQk2+EPcANQ
 u44YVbqG7GrFaG9aIVpwmG6Ce0r09jh4v9FYZ574N9PPsBk4b8SiXkv9CFY8ygzuOgyU
 w7MR7d41322vEZ/hbUqOnJUxHYnubPOH8KPXfuWypotx1Xxt5hbOHYNxlJx9aCvdd8LN
 Rb48Fq6NyuEKrT2OtH3GqiJCGm6M5lC91MAsvc2mSr3u0h9dGIqrNLAFU30Iit5Vo2J3
 ZZHIKciCckvy2CQoozNbcyZnyIH8liJSuujM6UwGHCt8ndpysN3liQlDTFoG6q/QZh4I xw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=LVXiYrc8zJ36wJ2cmleTKxT9EdHvQrSciQjMlXsSbPE=;
 b=JM6TytJzjXGGKmSAKyh51b5IvCltynkPXyCZFspGi4/Q0R/Th+2/UID9DT81Ag5ZYm/B
 XL4/AfXS8qCp3kvkyKYb4im9gVdpkQg2yEWoNq3QUgPSA48UBDXkQFbn8J/uocYNDpxJ
 s8l/xH46TGJ07AFogGAcAa2rVuZx/B7SwEQ/1CIs6nQu1qWfXMJWSVUws1pFj0pOJXzs
 ooAWKW6gQyIYgr0vDvYHjQpkKJ+j3bntdnrVrNhSPxoj/LSiwQBNesXcLuTJ7ESdAYMM
 ru3DzvVhnomOOJOfHoGyzlP7ICMKh7HAA7lnErAosbXqDDPiUNqYj8lz/m7umdfJRttt Bw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a235drund-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:51 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16R6FjJC114851
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:50 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by aserp3030.oracle.com with ESMTP id 3a2349tqqb-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GBjrkiCNSkqAVRiblZj+YV2dYnPkZwm3J/W6q1jHMkrIRsNrz97jYFcjWOF02udh1WXS2ciLVqe9dX3vfWogwQi4w9w8U7qjLTSd9JILNCdO866C63DbC9XSAVvzQgXWew9hhIH2JfQLx6/gsnkZaMDYKGzjulSY7tSOMr3IjD/4YXxinR2yuBJAvYovYFAzkiOohXgYm6YyaSXWMU7upCaZnXC4oNjhAOLixPRBFGFx4pMc624fCvX3+jcilkbbArI79nbLE15hp4sTlCqzOqrTqyq/tMBfzaBD2TAV6OzFfQHTw0/vcikgckCJvK0Zm7UgksoPUWf2ZvSuGhsrkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LVXiYrc8zJ36wJ2cmleTKxT9EdHvQrSciQjMlXsSbPE=;
 b=N33zcKvwybOz75xCw34NCed/Gp4FGtH2+1zbAV9HqOn4AggHbnIMXUlAI9gVKiWeljijN9IJWwFfYfLb3TLZgrOnNiY55dopSSdzO9UURF7LXG4npAdOhFqNia0adE7xBD9aJaNnSwXjn8EgtkDmTpzuCxO+K9OWKmHQVklfFcgI1/Cspt/Hcs15Bc8f4xFz3HqGsow3LhDDMSmn1IjzLpXCJNlvBjp32xHcQew+iLhtg3UOXjqLzyq0GknNl7+9qto5fiXX75NwyNQP0QNA0HTJ5sArgiiYpJo/SjU4GVNWaiMxQqK8Q08yVoGWyoNnkZhk89C2DRscte6IJ7u9Ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LVXiYrc8zJ36wJ2cmleTKxT9EdHvQrSciQjMlXsSbPE=;
 b=SLXWFXcm8tGSi27Sum1x/C24XbfMYZMUbnRLwBEop8xY62Jo0O60iOUKIg9ryOMmAT5AGF+q9+FbBtzuHN0W+vCwDNEtltRQf1wfqc6TLHYiP8ZidJan8PG/y6ojp1Ag+aOKZ9/gZMasABY30ja9EJSaSL42JEe46qXY9+QCA/A=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2709.namprd10.prod.outlook.com (2603:10b6:a02:b7::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Tue, 27 Jul
 2021 06:19:49 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 06:19:49 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v22 26/27] xfsprogs: Add helper function xfs_attr_leaf_addname
Date:   Mon, 26 Jul 2021 23:19:03 -0700
Message-Id: <20210727061904.11084-27-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210727061904.11084-1-allison.henderson@oracle.com>
References: <20210727061904.11084-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0074.namprd05.prod.outlook.com
 (2603:10b6:a03:332::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by SJ0PR05CA0074.namprd05.prod.outlook.com (2603:10b6:a03:332::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend Transport; Tue, 27 Jul 2021 06:19:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a15f8887-4d94-44c9-26bf-08d950c68997
X-MS-TrafficTypeDiagnostic: BYAPR10MB2709:
X-Microsoft-Antispam-PRVS: <BYAPR10MB27094534C7797ABF3E6D781D95E99@BYAPR10MB2709.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sg9CZYdL9IGuVTZLIszqVp9FaPHYga7rEak1mA6QZ+7e1ZncUH9mzMbB75eHYqfe4EVJcmBH1ZK4awFz9Yhcf07TzbGqmneYIZbETZgb8xiILkcFDg2l4eRu77qxpT/JD+GwZbarISGHIM/bAhLDqrSjCsv0k08lEUCZM0oQKbvGJxp2ioABvu5xe0GP2GQAyKYNvFu0OhmYYmlzpWZnzD/91gHQGXmeTlOTaqTcHFes06+8RXzZ1EfxrQVlxoKJ2iahCy8WFxKR7v0ShGVMYPCMvxDHvmXqoQ0jV8q7PUwo8ZbrZf7NNWb12fYORWZvSZB6V74MFnwnM6d9kzdXKqRepOCOPI+gsyRsMF7gTlQrUWNmg7HtEWFWLVgJq0idHM+vIw8UakeYtZA86PF61wYg8V2lz2AC9Sa5QIGVvdhmk+HCeoI+MoiijtXscFzJL7ue+7Elc+ndt8sv8UhE/CvOWuhyq9jXovI2REmTGnzDLMFveDh6BkYuHsLFlo//Hmd7oglnlaDqa9RsLcrnNP2QN2aj6Ll3cNSkDSzT/GXLcYYsY62TvWyLieh7AalkvYvoYjy7Pq2x97yKMSJxsNB4q83HvHcYCo4YXEP5FHd5GhVnnsSiniQ3KXPVFoGuhw7d7v23qB/UWEVpEuAyg0MFBBYRz/rGWOoMTgHQRT4LbVM9cnqBcTGpW6JLyYf8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39860400002)(346002)(366004)(136003)(83380400001)(6486002)(2906002)(44832011)(6666004)(86362001)(6916009)(956004)(38100700002)(2616005)(36756003)(52116002)(38350700002)(478600001)(8936002)(186003)(8676002)(6506007)(5660300002)(66946007)(316002)(6512007)(26005)(1076003)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ypWvO+eEPGwPyTe9mQh3HaOFwnlet22Lnj2HQdSiBwLGMEC8SVn2Lr1r1QzG?=
 =?us-ascii?Q?uqrilKMaQBxAhyKJE3h1Yy9BqEv9crUJW6Mlk3Rr00g4ODIf8We50nsrKDGU?=
 =?us-ascii?Q?lR9TKTs2oaEOiWtEJmoj41yUubq/eaPBIU36P9rmk6nWSKpzmitJ1YgL1/I2?=
 =?us-ascii?Q?EiHQdwDbsCjkQMVc3Y7adsv5j9vfDXQv66k9mUERRKIM+NEW1X6Nnp2BPV4x?=
 =?us-ascii?Q?hVS1LPI5B6g0FKKIAF97IikBTWPpfUHDuX3diHApwvJliCBcPmHRMN/oBl+V?=
 =?us-ascii?Q?2gNgqMhhi3dnUHssaTiIz7S8OsmEYcRK7HrcLoZkLyQWbW1dLRo1Ax75JTAQ?=
 =?us-ascii?Q?+TSvwcHWHo5HWjNyPoApivUTFJw1UAUpAK6Lfv/NGk7rYP7kYEDVeqhPUb0F?=
 =?us-ascii?Q?zw2EyDw4YkDg5q7CFHLjf3IRC2gxSkkpI/tns6icLqtf0rGYCuiiNC6EsfvC?=
 =?us-ascii?Q?56NIo80JIw9xSk/Mw0ZfTfwEalrjSpSNGu3i6H/SlwUxBSqnnNPndMQZAS+b?=
 =?us-ascii?Q?ySoByqZGMnPmGHfU48l40WnlcD0OmOmhHRHl82PwmQdnYdC5GM+PvBrWNgnL?=
 =?us-ascii?Q?vM8cyV/TGzDpSCSeA0E5JXV4mnjTQZ47a6yBo70Q/qMaSEAJBYt+bFuXGXOv?=
 =?us-ascii?Q?bbtRa/k6RvnmiZbYYdAaO8nxGEQVp7iSRwNLNz65WTw12RUfEabGHVzecYtw?=
 =?us-ascii?Q?g4Og3pntu/z3uRAMsDSmqTC/T7tyGifPFa7/s/O6qZNTkkM+8tk7LWRF813f?=
 =?us-ascii?Q?qFhZ/W+0fwW3K3QEWPYv5wIjSq1s74noqQfcafzZu7NrpBX0D82mlbMLwIb+?=
 =?us-ascii?Q?JMP26u7AdCZaw8n0kZPWXGqSim07aXZmjNwdoVWJLSOYSkQrFTSNm+sRfUbT?=
 =?us-ascii?Q?v84MEpUDG7U4+R3IlNXDmEn4FCzksFG8VMLkVVVo7f9fdiOKaOiduayteXY4?=
 =?us-ascii?Q?E3Yc7IfaRPgRzcfGy1gVaeH4aPRyC5ZJp3ubmOmDWf7N/ehlcq/+fPs/LkHD?=
 =?us-ascii?Q?MPVfJPTvnITgUR4i1pRuTc9emOHXQf95yFhpK46WIsB8waSwiS3YK+vxVwQh?=
 =?us-ascii?Q?mwiPR7btO6hZnUO/YGuKJdeywCsL9DEmp0wJR2lL0hcKSam5THjrrwinBpiY?=
 =?us-ascii?Q?D+mV086L53CsPCWg+S8HqqwIacZpPRr6FQf6SODsj0N4mVWpKBfnt5RDqXBA?=
 =?us-ascii?Q?Ha/BB27K4mgLMvouTwB/SD6qRXyimBIsrcEhT4e9/PjLcF4eeM1cOEDhMKAh?=
 =?us-ascii?Q?zGlpBVSfXCU8sY6H3sr9OiJCuyU+bC6dPqGvxAHnFUZE6I1XsjCV+hp6LdBu?=
 =?us-ascii?Q?uVTkw3RGFFazNF1Cl06rtSfn?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a15f8887-4d94-44c9-26bf-08d950c68997
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 06:19:49.3549
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tgZQJmiIZ0ZG6HX5fquId7OfaJ3+tuoB7K/ViQ38WhYUbbpCGhZCLY64D2ycUQ+dDtF7HmPIWfIkbO50zvn7Y/oNlNNR8noO3QT9xqzzi/8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2709
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107270037
X-Proofpoint-GUID: bX7z6gm0RegPpArIp3uzP6cu4Fzt_lBE
X-Proofpoint-ORIG-GUID: bX7z6gm0RegPpArIp3uzP6cu4Fzt_lBE
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: 6d9d518192a3f633fce0821601847966280857f7

This patch adds a helper function xfs_attr_leaf_addname.  While this
does help to break down xfs_attr_set_iter, it does also hoist out some
of the state management.  This patch has been moved to the end of the
clean up series for further discussion.

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_trace.h |   1 +
 libxfs/xfs_attr.c   | 108 +++++++++++++++++++++++++++++-----------------------
 2 files changed, 61 insertions(+), 48 deletions(-)

diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index 2169c27..4557ddd 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -314,6 +314,7 @@
 
 #define trace_xfs_attr_sf_addname_return(a,b)	((void) 0)
 #define trace_xfs_attr_set_iter_return(a,b)	((void) 0)
+#define trace_xfs_attr_leaf_addname_return(a,b)	((void) 0)
 #define trace_xfs_attr_node_addname_return(a,b)	((void) 0)
 #define trace_xfs_attr_remove_iter_return(a,b)	((void) 0)
 #define trace_xfs_attr_rmtval_remove_return(a,b)	((void) 0)
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index f5d4380..c84997e 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -282,6 +282,65 @@ xfs_attr_sf_addname(
 	return -EAGAIN;
 }
 
+STATIC int
+xfs_attr_leaf_addname(
+	struct xfs_attr_item	*attr)
+{
+	struct xfs_da_args	*args = attr->xattri_da_args;
+	struct xfs_buf		*leaf_bp = attr->xattri_leaf_bp;
+	struct xfs_inode	*dp = args->dp;
+	int			error;
+
+	if (xfs_attr_is_leaf(dp)) {
+		error = xfs_attr_leaf_try_add(args, leaf_bp);
+		if (error == -ENOSPC) {
+			error = xfs_attr3_leaf_to_node(args);
+			if (error)
+				return error;
+
+			/*
+			 * Finish any deferred work items and roll the
+			 * transaction once more.  The goal here is to call
+			 * node_addname with the inode and transaction in the
+			 * same state (inode locked and joined, transaction
+			 * clean) no matter how we got to this step.
+			 *
+			 * At this point, we are still in XFS_DAS_UNINIT, but
+			 * when we come back, we'll be a node, so we'll fall
+			 * down into the node handling code below
+			 */
+			trace_xfs_attr_set_iter_return(
+				attr->xattri_dela_state, args->dp);
+			return -EAGAIN;
+		}
+
+		if (error)
+			return error;
+
+		attr->xattri_dela_state = XFS_DAS_FOUND_LBLK;
+	} else {
+		error = xfs_attr_node_addname_find_attr(attr);
+		if (error)
+			return error;
+
+		error = xfs_attr_node_addname(attr);
+		if (error)
+			return error;
+
+		/*
+		 * If addname was successful, and we dont need to alloc or
+		 * remove anymore blks, we're done.
+		 */
+		if (!args->rmtblkno && !args->rmtblkno2)
+			return 0;
+
+		attr->xattri_dela_state = XFS_DAS_FOUND_NBLK;
+	}
+
+	trace_xfs_attr_leaf_addname_return(attr->xattri_dela_state, args->dp);
+	return -EAGAIN;
+}
+
 /*
  * Set the attribute specified in @args.
  * This routine is meant to function as a delayed operation, and may return
@@ -317,55 +376,8 @@ xfs_attr_set_iter(
 			*leaf_bp = NULL;
 		}
 
-		if (xfs_attr_is_leaf(dp)) {
-			error = xfs_attr_leaf_try_add(args, *leaf_bp);
-			if (error == -ENOSPC) {
-				error = xfs_attr3_leaf_to_node(args);
-				if (error)
-					return error;
-
-				/*
-				 * Finish any deferred work items and roll the
-				 * transaction once more.  The goal here is to
-				 * call node_addname with the inode and
-				 * transaction in the same state (inode locked
-				 * and joined, transaction clean) no matter how
-				 * we got to this step.
-				 *
-				 * At this point, we are still in
-				 * XFS_DAS_UNINIT, but when we come back, we'll
-				 * be a node, so we'll fall down into the node
-				 * handling code below
-				 */
-				trace_xfs_attr_set_iter_return(
-					attr->xattri_dela_state, args->dp);
-				return -EAGAIN;
-			} else if (error) {
-				return error;
-			}
-
-			attr->xattri_dela_state = XFS_DAS_FOUND_LBLK;
-		} else {
-			error = xfs_attr_node_addname_find_attr(attr);
-			if (error)
-				return error;
+		return xfs_attr_leaf_addname(attr);
 
-			error = xfs_attr_node_addname(attr);
-			if (error)
-				return error;
-
-			/*
-			 * If addname was successful, and we dont need to alloc
-			 * or remove anymore blks, we're done.
-			 */
-			if (!args->rmtblkno && !args->rmtblkno2)
-				return 0;
-
-			attr->xattri_dela_state = XFS_DAS_FOUND_NBLK;
-		}
-		trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
-					       args->dp);
-		return -EAGAIN;
 	case XFS_DAS_FOUND_LBLK:
 		/*
 		 * If there was an out-of-line value, allocate the blocks we
-- 
2.7.4

