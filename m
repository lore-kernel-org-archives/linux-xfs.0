Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64287C4320E
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Aug 2021 22:44:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4926F61265
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Aug 2021 22:44:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbhHXWph (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Aug 2021 18:45:37 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:30868 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229618AbhHXWpg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Aug 2021 18:45:36 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17OJtEOt001055
        for <linux-xfs@vger.kernel.org>; Tue, 24 Aug 2021 22:44:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=lL6Vhj0wXx7fEncQZyaT7f1MkTmtmyaMVQ7xLHxPaM8=;
 b=tIpWOOsttadUb/de2I3Y8J46CihvHAkX1KdHrTJ78Po8H02JGhlCuzRFTnIJQJN+6Tjw
 HWbsT0OvUCBJSZxroaNBreAYgLwtr8wpGGDNDIjZ8oiBWpVy/G4KTJOP1sqRU4FahPGp
 9H6Q5GOhZGb3TGCghgvpGs6Aj67BSaVT40RQR5M+BIVPpBqZYkZJR8guPxR7ezzTzFxG
 aANyK4zJQfVj9fgvTuHNfV1nUDBEiMS5r5UJhme4U2RadePIzpPIfKibLBT8g7VGVT0w
 3RMU69kODs1T16Vo/KFMAEIiKkRb4jDFctxDIM71hHh52vdL8fqDQJzYQQ+TUNfPn236 7Q== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2020-01-29;
 bh=lL6Vhj0wXx7fEncQZyaT7f1MkTmtmyaMVQ7xLHxPaM8=;
 b=GNp4o+FxV9IedlPH2/Psx7/MRDdAOlEstK9xkuIChIOKTOsobdqFQA6lx1BCiSNJDNzN
 aXx83FNkRfcSoB0/9kY/FqrSPGpnOhgAKnb0N8zoGUpkRMn5v7U2WPE6eF5kTICWqxQr
 eSImlBYJSYHKtVBo4xYwKlRzfqKg1x1kk8R3HnaDO49cyRpmTqUqiXoXHioBRar0+1w0
 8m9lLCaYB49SRDO5/moYkkMrbWOt0hmmMRp88jaEWTiaDnL/61BKMd+CxETt5d/P73qV
 UFvK86YydCgl9AkFeyJ+8bbuLzjmQejkazZNkuHOew7laCTCLi4Z7MWyx8t5QgVfhdpq Vg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3amvtvt4uk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Aug 2021 22:44:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17OMfYQ5025324
        for <linux-xfs@vger.kernel.org>; Tue, 24 Aug 2021 22:44:50 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by userp3030.oracle.com with ESMTP id 3ajpky4yms-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Aug 2021 22:44:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kAfcNv9hYBEDWioS5YhgLIAM9ESZ8KWRGdh5kkdfX4aJsLunLKWVjjc7g+93dxmwoGvZx1fy3O+D5MrrKKZ9ND5ECugtX2NAeUZf10Rn4y0C2A5NhTE4qaEc6zLYCgfEOOJFElJJN0H7yzcg5EB1mq0YbR50ISXoM9qS1PGikI13Wqs7FvCv7K14ogEH2Kl1ZqeD1y00mXPkobkXe5Hzc6eSq4geTWqARZWkbi2prsncvLdxDeP67EvWEgLJWRLz+GzveM4Mx/cALVt0hOJjjcuzd5irHJMh791lsf874F4rkHahlnwIGDXrNznpXSw6PFlWZfJXhExLTdH1CZ6A1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lL6Vhj0wXx7fEncQZyaT7f1MkTmtmyaMVQ7xLHxPaM8=;
 b=gK+3BJu/r8nufmThN7l1kROK6iEHMlJe+fJM3/EJQkjYjNnF6pEM0dy0niAmWxINzHrR9LoRytIFFCjamjHYnrGuErQIsG4VgDWaojgjrsL8koNA92apgEFJs4IJ9jjsxI9FsbcsWgeuBzXBT3rPp0xcW+grCd90QMp8drLuPF14rkTAoK0/kdKs2DhHaulVZjR7HSMddl9PN/qKKmfUqJagZsIca3cKQXsT3KuZmA/IoNQAZa7uDL1Gdldy3URVIJGGru4utWDLu2nS9D+uqUSHegI0rN026WXq2aoNbo1RHpnSj9chamIqCotLC9NGyFtmrUDfAUDOsjTKlwN8vA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lL6Vhj0wXx7fEncQZyaT7f1MkTmtmyaMVQ7xLHxPaM8=;
 b=asRTrwXC8qMCd9xiVTPN//pMGFOuEcQ16V/5oIYH9O4rxUS3C0sGll5Jn21CFN6KjiY+NlL7W6eWCG//c/NL0fPsY8SZ7V9GVfbuU2Whh+ECQShpJFmTArHkgZDgCa2KoMj2AF69NA++AkXYGaoXk3bgnQtKakTh4s00OEn12Lo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4653.namprd10.prod.outlook.com (2603:10b6:a03:2d7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Tue, 24 Aug
 2021 22:44:47 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f%9]) with mapi id 15.20.4436.024; Tue, 24 Aug 2021
 22:44:47 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v24 06/11] xfs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred
Date:   Tue, 24 Aug 2021 15:44:29 -0700
Message-Id: <20210824224434.968720-7-allison.henderson@oracle.com>
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
Received: from localhost.localdomain (67.1.112.125) by BY5PR17CA0012.namprd17.prod.outlook.com (2603:10b6:a03:1b8::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Tue, 24 Aug 2021 22:44:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a7f2de91-0f3f-4d45-0f1a-08d96750c428
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4653:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB465328285087DD021F1AA5B595C59@SJ0PR10MB4653.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:494;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gcJKnqVTg6LclYRtoflkGov0RM91Re6gs/5CLXlI/WS+cxl2JcKOjzxlTFjIDMfyRaA7KQZHqiVOEUjq0cosZFsIAG3g5EPkp150wx/21g0kfGJYidDsm8U/MjI9aZYb0aIyfzs6EYdkUOq4+fh1lYPPjF1xo+XdEYZ7hf6VF6fgd8Epy6+Isoev5zEJcZJ6zCCVonWQPsKLfK8adcaM6FoyugX18MAezl9jihVmMrW0vG38GCQFryulWWWE0Pp8R8BA+D+Wk3lUqgI7HF9Gh/i7KqIyLRhStgX6kvq6KCnac4MOm/hlYACZTGSzua6hmr328J4dFoHytaB0j/h+QhJeO9yXFabWrngUcGnyOB/ouH8XEZ6pcqPIEeGWSN5oyi4zHzvod5tIzUInN7qLCUgWAjZRrr7p3ZbJiK8jalthxs77Wj/4N9xeQpQcGoLb01uL33PnGrGXJxIUNTES7A60BqwnIYc7DVQK/DpD01/j74fs9NwX3id01vGoqx1weFntYMMCSEiv5m6821r/4ree+UHEUrojIjwvct7ukzWO2qPbnbKl6RafRISEk9PApwSKwe0/wv+ADlUGq17pGCaE1u0i6gdLrpCc55MphT7PRoJEwUBMRnr+reOeOBXIbERl+r2Vcd80I1cHN0bLKqQb5BPN6awnTHl3YkpuPtoZy4x6BIOzzeqIyUnrhlS9Es0wX7lGHAYaDbPpJcmLlg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6666004)(66476007)(86362001)(66946007)(83380400001)(6486002)(6512007)(2906002)(52116002)(186003)(6506007)(66556008)(508600001)(8676002)(316002)(956004)(8936002)(36756003)(26005)(44832011)(5660300002)(2616005)(38100700002)(38350700002)(6916009)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YJMbXOczc6fQ5CFLaseWL13UMO0TTP7OmTB81LN+ZJaBUAwjpuVzKD3gxngS?=
 =?us-ascii?Q?QArEkzomyBnMV6SAev3kM+qpcVKBH7amCMAJt2OHPi8KLb67aW2bfNuHmJnm?=
 =?us-ascii?Q?gl90oNsfzIRk5QKjOayN9BIXaoKo5RwIvwyDo+DjoBzqTL9V+k4y5jJv33Ta?=
 =?us-ascii?Q?4y3JQb9a1ENSpmm9T0OlIBFgC8JjDe0nHzz1NTyJk8UZuClP9EW2kYXSqntI?=
 =?us-ascii?Q?kZcpGxdPjhsA9/MJ5OlnrHZzUzyFlkN+eyob+B+LNhBZoODg+TNKtGQFPUa3?=
 =?us-ascii?Q?eJRSQMFXy6E6Hl7n/4JD6ZXuf5N9Y2IN0c7HB9AEjKo95E+fGqGYKnnzvcaa?=
 =?us-ascii?Q?lTxVgTiq8CKoZ1/Cv+csGGk1dM93+3qkr4rbMeKBbA1Db5v3Uc8QIizzMPGM?=
 =?us-ascii?Q?/uDKwpwR37EpE/vG+2kQj1UFikGgiF7+2LQ7/Xp/ItVYeJfv2ZNMtZnKz1Qp?=
 =?us-ascii?Q?Z+SxWBReWb3H6f93W+GtGaRSPITi3eSw7WzQdb3uOWxNzvNlQ/HpbiMIiRKr?=
 =?us-ascii?Q?P04jAFC80LRgh3Ay94JrR1IU8HBEPIuhp5qtd+ls6jWlAjpYBWqTU7DOo9Ik?=
 =?us-ascii?Q?Xp7E4KiMwzVHImr9CC9VZB6o4Imd6AWcI0S9iZZh4PTmYfltzSnSdNMhxsP+?=
 =?us-ascii?Q?+rQHL3eD4xmJsyLVtcNCNK3LelK0dWjySfc76jWZHvQgT39CWDi6bn7KGdcw?=
 =?us-ascii?Q?ZzEe9fe7UyH8GrM8WJcuMNvacn0/UpkTk7X+FXCKodMBq6+wMPGAVFqa+Ja3?=
 =?us-ascii?Q?D35/T4MF146osv+qwvCmML91jpTBDOjbBLeXx38qy6rkVEsgIU+nhGYibuh/?=
 =?us-ascii?Q?IQVweorAMoNckiumvCIy8vxYjpqvMN/QgA5h7IWBMxUE5eO9jdMM4HxuRom/?=
 =?us-ascii?Q?dLqsywmnSVXxQxJXVZwyXm0tWGPpd0qj4Oa9EeG1hluW3DOXg3HKkilkehto?=
 =?us-ascii?Q?Q1gI0XwVVbehjU9ySVgG9nzHrI7d9YAG6HtNLGKawmdYN7QtYMRaJ8kC/oBR?=
 =?us-ascii?Q?OCllXEkpUpjXmstNYdd34oSa63w7jtBjNiOPK5kJZ5Y19FHUoJ+L/9PFQSFn?=
 =?us-ascii?Q?sShg5K6czGue9YAXb1rnvLpk7cYdl1E0rWnf7z2nTINVPaLT3a4PT/E4YNFS?=
 =?us-ascii?Q?sMq5caMavIhN2QUUxqBrnOGSneFUvcBaJ0zb8VAxyGbJyTVJLYymUoEGgqoD?=
 =?us-ascii?Q?tnRapqw2R/k9/HJUd+aQQX+q7gwwCkNngrlJO8t6z0g6mqTCF2cDRKoaX6Za?=
 =?us-ascii?Q?c3dgZ3Tya1b6QnDf6pa5+aYmFntThDOR4NJtbQRXSpoaYL1VV5UZE4DPCU2+?=
 =?us-ascii?Q?SKbavS0//RdAyN+En4XOkxuP?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7f2de91-0f3f-4d45-0f1a-08d96750c428
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 22:44:43.6974
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8F67rqqzJuZ3Kkzl58uc7hDQJbuhkFPzlTAmF85JhoOPMjrjmGsxyHDWblrhsz+vW78YXMCWBbetHnqKVnWvFp8x5X1jXtHt2CDbcu3knMg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4653
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10086 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108240141
X-Proofpoint-ORIG-GUID: vSnyGtU9yQlnNSgESVZry2pobA2jkwQW
X-Proofpoint-GUID: vSnyGtU9yQlnNSgESVZry2pobA2jkwQW
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Collins <allison.henderson@oracle.com>

These routines set up and queue a new deferred attribute operations.
These functions are meant to be called by any routine needing to
initiate a deferred attribute operation as opposed to the existing
inline operations. New helper function xfs_attr_item_init also added.

Finally enable delayed attributes in xfs_attr_set and xfs_attr_remove.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c | 71 ++++++++++++++++++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_attr.h |  2 ++
 fs/xfs/xfs_log.c         | 41 +++++++++++++++++++++++
 fs/xfs/xfs_log.h         |  1 +
 4 files changed, 112 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index fce67c717be2..6877683e2e35 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -25,6 +25,8 @@
 #include "xfs_trans_space.h"
 #include "xfs_trace.h"
 #include "xfs_attr_item.h"
+#include "xfs_attr.h"
+#include "xfs_log.h"
 
 /*
  * xfs_attr.c
@@ -726,6 +728,7 @@ xfs_attr_set(
 	int			error, local;
 	int			rmt_blks = 0;
 	unsigned int		total;
+	int			delayed = xfs_has_larp(mp);
 
 	if (xfs_is_shutdown(dp->i_mount))
 		return -EIO;
@@ -782,13 +785,19 @@ xfs_attr_set(
 		rmt_blks = xfs_attr3_rmt_blocks(mp, XFS_XATTR_SIZE_MAX);
 	}
 
+	if (delayed) {
+		error = xfs_attr_use_log_assist(mp);
+		if (error)
+			return error;
+	}
+
 	/*
 	 * Root fork attributes can use reserved data blocks for this
 	 * operation if necessary
 	 */
 	error = xfs_trans_alloc_inode(dp, &tres, total, 0, rsvd, &args->trans);
 	if (error)
-		return error;
+		goto drop_incompat;
 
 	if (args->value || xfs_inode_hasattr(dp)) {
 		error = xfs_iext_count_may_overflow(dp, XFS_ATTR_FORK,
@@ -806,9 +815,10 @@ xfs_attr_set(
 		if (error != -ENOATTR && error != -EEXIST)
 			goto out_trans_cancel;
 
-		error = xfs_attr_set_args(args);
+		error = xfs_attr_set_deferred(args);
 		if (error)
 			goto out_trans_cancel;
+
 		/* shortform attribute has already been committed */
 		if (!args->trans)
 			goto out_unlock;
@@ -816,7 +826,7 @@ xfs_attr_set(
 		if (error != -EEXIST)
 			goto out_trans_cancel;
 
-		error = xfs_attr_remove_args(args);
+		error = xfs_attr_remove_deferred(args);
 		if (error)
 			goto out_trans_cancel;
 	}
@@ -838,6 +848,9 @@ xfs_attr_set(
 	error = xfs_trans_commit(args->trans);
 out_unlock:
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+drop_incompat:
+	if (delayed)
+		xlog_drop_incompat_feat(mp->m_log);
 	return error;
 
 out_trans_cancel:
@@ -846,6 +859,58 @@ xfs_attr_set(
 	goto out_unlock;
 }
 
+STATIC int
+xfs_attr_item_init(
+	struct xfs_da_args	*args,
+	unsigned int		op_flags,	/* op flag (set or remove) */
+	struct xfs_attr_item	**attr)		/* new xfs_attr_item */
+{
+
+	struct xfs_attr_item	*new;
+
+	new = kmem_zalloc(sizeof(struct xfs_attr_item), KM_NOFS);
+	new->xattri_op_flags = op_flags;
+	new->xattri_dac.da_args = args;
+
+	*attr = new;
+	return 0;
+}
+
+/* Sets an attribute for an inode as a deferred operation */
+int
+xfs_attr_set_deferred(
+	struct xfs_da_args	*args)
+{
+	struct xfs_attr_item	*new;
+	int			error = 0;
+
+	error = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_SET, &new);
+	if (error)
+		return error;
+
+	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
+
+	return 0;
+}
+
+/* Removes an attribute for an inode as a deferred operation */
+int
+xfs_attr_remove_deferred(
+	struct xfs_da_args	*args)
+{
+
+	struct xfs_attr_item	*new;
+	int			error;
+
+	error  = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_REMOVE, &new);
+	if (error)
+		return error;
+
+	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
+
+	return 0;
+}
+
 /*========================================================================
  * External routines when attribute list is inside the inode
  *========================================================================*/
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index aa33cdcf26b8..0f326c28ab7c 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -526,5 +526,7 @@ bool xfs_attr_namecheck(const void *name, size_t length);
 void xfs_delattr_context_init(struct xfs_delattr_context *dac,
 			      struct xfs_da_args *args);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
+int xfs_attr_set_deferred(struct xfs_da_args *args);
+int xfs_attr_remove_deferred(struct xfs_da_args *args);
 
 #endif	/* __XFS_ATTR_H__ */
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 4402c5d09269..0d0afa1aae59 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3993,3 +3993,44 @@ xlog_drop_incompat_feat(
 {
 	up_read(&log->l_incompat_users);
 }
+
+/*
+ * Get permission to use log-assisted atomic exchange of file extents.
+ *
+ * Callers must not be running any transactions or hold any inode locks, and
+ * they must release the permission by calling xlog_drop_incompat_feat
+ * when they're done.
+ */
+int
+xfs_attr_use_log_assist(
+	struct xfs_mount	*mp)
+{
+	int			error = 0;
+
+	/*
+	 * Protect ourselves from an idle log clearing the logged xattrs log
+	 * incompat feature bit.
+	 */
+	xlog_use_incompat_feat(mp->m_log);
+
+	/*
+	 * If log-assisted xattrs are already enabled, the caller can use the
+	 * log assisted swap functions with the log-incompat reference we got.
+	 */
+	if (sb_version_haslogxattrs(&mp->m_sb))
+		return 0;
+
+	/* Enable log-assisted xattrs. */
+	error = xfs_add_incompat_log_feature(mp,
+			XFS_SB_FEAT_INCOMPAT_LOG_XATTRS);
+	if (error)
+		goto drop_incompat;
+
+	xfs_warn_once(mp,
+"EXPERIMENTAL logged extended attributes feature added. Use at your own risk!");
+
+	return 0;
+drop_incompat:
+	xlog_drop_incompat_feat(mp->m_log);
+	return error;
+}
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index dc1b77b92fc1..4504ab60ac85 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -144,5 +144,6 @@ bool	  xlog_force_shutdown(struct xlog *log, int shutdown_flags);
 
 void xlog_use_incompat_feat(struct xlog *log);
 void xlog_drop_incompat_feat(struct xlog *log);
+int xfs_attr_use_log_assist(struct xfs_mount *mp);
 
 #endif	/* __XFS_LOG_H__ */
-- 
2.25.1

