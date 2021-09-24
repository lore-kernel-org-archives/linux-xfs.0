Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8057C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Sep 2021 14:10:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC4EC610D1
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Sep 2021 14:10:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345666AbhIXOMD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Sep 2021 10:12:03 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:19914 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346721AbhIXOLu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Sep 2021 10:11:50 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18ODQFeh017645;
        Fri, 24 Sep 2021 14:10:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=M9G0NiOq1leKWVzZu5kULPhfvt1/k0YVhzi3+wGYZFU=;
 b=D7brZXpKdV/L1ccAnX/76uLl0B4ypNYF+aeFVL8TiVYgFhQtD/6/ZR6psNHL051DHosf
 f8+7AG7+wQ6smPzjY2xtpkhyUF639VYTcZeqXRgM2kbTYRlsNk2TgLgHDj7SWpo4HJ2e
 XkK7nWCt8w5zWw4ycHKWPgRk5YKsoAApeiwvEOfykQX9gk8f46oWWciC3bCF78fyGKWR
 X0J7qgwKpYoxdbEyS53Ux6QnOG1QYw9cb2qRHlitXBk+5b7KI1Q7wTN4abmdWXhQkhdQ
 9DtEK+JHgjyn9ww/1vVvnt0zJOJfYJWlct62rLQbq6lJRpK3j/LPKvj4saWMtslCWOXb wA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b93eqkq1a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Sep 2021 14:10:11 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18OE1gHv125133;
        Fri, 24 Sep 2021 14:10:09 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by userp3030.oracle.com with ESMTP id 3b93g3aa3r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Sep 2021 14:10:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZMB7PGW8SfQLzSh1j/RLXvkzWzbP3jdo6+HjOlepywSpx78EvG4xoKFGh2KsUpIF8YO2BiPBbeql2ZKjxU48Z8d/R6Vhb3gvHKmm934gIjjqtWWFABQNAsrTkIVZ9kYf6Gsxipiq94EtSgYKY049flvVJbMPccKnR1J7EFqTjbi1IsAS9QSd58URUQ2ZsHbZtHQvAGT6N3NtiKAG4QR0ywNrjwEmG6gSDykinvUqKwQZRxtuSzmI2Gn0tHIo1472PGp9Aqw9iiudVzHgp7AlFoWppbosfKjUF4EuOnt4HMT9ynV6q76tqLbcFERHWnilN2GJrjQkdnM+XAF9nRxjEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=M9G0NiOq1leKWVzZu5kULPhfvt1/k0YVhzi3+wGYZFU=;
 b=n7Ev2GgrsjJ6vQV9Rx2mbLJdIPemF9JLQHNMCCHsFUhFS9vgOgOBmD5PkKLzoPJKYo6COwSQhokQsGAPp6RrzyDRC05VXoc5vgt3f4VvavBRZam6D4yB6slLJFzhsL50djBDWfehEqlIIhQfMqSSM5Lvwi9jOek5IN19EqKuYkmFX9THdyuAxcrigaiqnyAwKEC7noCviaDxDAw2V2RXWSUsrIB4XSPTrl2Hdjw6egyVjdXWJY5snO31UhL9hB/qnkCj6IKPjBLfZy1jmFdL48x/U9j3XDIQMtxoEgQWjHp2JSTdlAQpBJ5KugTDmPx29MfTxvx98yKR9OAwTGjoYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M9G0NiOq1leKWVzZu5kULPhfvt1/k0YVhzi3+wGYZFU=;
 b=Wui7u6dd3a0SHfPt6YGfPlwUGoYqjeQe14YnH5zok6LSsWLXBoMU39R/Ka1sTtkx7zJ+Al7iZqlH7SN5LWSVEh5Y4Dg8DUW01UcSA4LJVa2042hM0/9ajRq15MYZBqX2UVGV4hRYn6DMvT51J8XghMNlqed+ujbTzWdW97CpdN0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2541.namprd10.prod.outlook.com (2603:10b6:805:44::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Fri, 24 Sep
 2021 14:10:07 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%8]) with mapi id 15.20.4544.018; Fri, 24 Sep 2021
 14:10:07 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, david@fromorbit.com,
        sandeen@sandeen.net, djwong@kernel.org,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH V2 1/5] xfsprogs: introduce liburcu support
Date:   Fri, 24 Sep 2021 19:39:08 +0530
Message-Id: <20210924140912.201481-2-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210924140912.201481-1-chandan.babu@oracle.com>
References: <20210924140912.201481-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0143.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::13) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from localhost.localdomain (122.179.80.2) by MA1PR01CA0143.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:71::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Fri, 24 Sep 2021 14:10:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ba0819ca-6a03-4f51-231b-08d97f6502f6
X-MS-TrafficTypeDiagnostic: SN6PR10MB2541:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR10MB2541E832E37AF939C6544F48F6A49@SN6PR10MB2541.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H155wDERb3vVqAagdYMHlVc0v0rdsAp3UdPV6wuPOOXUh4MEArqjquqYYBR2CXkIZvrswORfQZFqbd1HH4YiDyC1sMupK9LPa556KMtS6tXjgP7sf1CVKX/pO8Ti25LTADqvGfYeScgRAEvVwBieFC34kMuVMzyd5he/NT/zFTCFY86leN6No+bWmBCNpka7ffF2o3nU/KoeFLeBEt7bEaGYcBE7ybivObzLe+O4dk5m+NdaNsr76KvfwuwLKpOpNvldXEAYNwx/oeInkDBAnjFdN1kx35/wXPNZLzpTeAWCNBWbNgttapp0hcsOSIdvoZCDUNu58bHq7f1QCaL9klNrVhpBLppxyo2yoWQwSlaTtCDQum6sccgWfdQjo15ckFP/LXTJ+nTlIbb7G1b8ud2Gmf0yjUy68s3NbXO8nmzW280qovI7HxCTHg2olSY+puUrDQGT8oca1h+pqaYjY5qqZRtSFaNtRJxLgvFMiwXDZEllta9Nt07fkf6FcvxkXYj0tO0Tu61ZeSD3A6yI/2Z0j489PH2KvIgxL1ZHOwUv4/VSWnbJ52irul0gHdpa7Z1DFhYdfoMA8GKOi32vc2YYKgeRTjTGuVTpFoCmXuA3NI+iKiqhj/S9+W0DnGD3cpg77tvWQuhqgJmADYqNVQVNXuD8gKkCe68VypT4jgGQfDI3bNu9BIQzJfKwhZQgsMfDc6RvK3AfloSmMRbcnUCExNm7+Ng3JtLtFFFED0t9JvMrKSmCifYP49E9V3T1S5SLRnb+aRX4gtKok0AnSQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38350700002)(38100700002)(966005)(36756003)(86362001)(316002)(956004)(1076003)(8936002)(6916009)(508600001)(2616005)(26005)(83380400001)(66476007)(8676002)(66946007)(66556008)(4326008)(30864003)(6512007)(6506007)(186003)(52116002)(6486002)(2906002)(54906003)(5660300002)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LAFcuY+enNVSNjN7dZMLeTOlKUgdyMyvkYnleRHja6nRbl4yK0BTZJ/zFQIP?=
 =?us-ascii?Q?sgSGwad7ITDCByIyCwyzycTokUvLkBUJVZyCnwJ0J6vf9tX8FXTQ5lNhLD6D?=
 =?us-ascii?Q?EwMPaDp91sqMSMsI8yXojKPQLmGncKnRleYuNsQxkUv00kITEBTwRWpTRkdR?=
 =?us-ascii?Q?ylV3vkIyRK7HCTwhnvt/00t8j9MrBkPtg+5jCB0n4kUoZ3zK61YI4+7HdUkc?=
 =?us-ascii?Q?f5KsQKCy6xQjzekzaVxbOA6E295xgduF7ck55X4F4OrsS9hUghRxTnCRniuU?=
 =?us-ascii?Q?ZQpaWwsEnzkczOuAf/H9HseMB1KJh/KaUeD+cQWSFJEraaFWDvnpR/DMU5PL?=
 =?us-ascii?Q?wmeSpmKvJYVWNZMBkeb5/ejbQJ2Ew/JpcKqxpG6+97moHc1dhgtgXPRNxStK?=
 =?us-ascii?Q?Dh96k8HqIYZgMlZwt9WhQ4whN8RST0VIXDLIQoXWrcG2QGIQd2x0JKmMZIeB?=
 =?us-ascii?Q?Fbz9bY7UIKNE+iq4J5HWynYTJwvQi8Dms2oU/zSkBOllHtMAZXauVK6fWpey?=
 =?us-ascii?Q?0h01wqwjMjYBxdGDHyDbOYS1iaiq5np0mZrtdJkXL47s9NxOgFzcTULL+w1q?=
 =?us-ascii?Q?nA9Sz8gLD7YxUDYAhGX6Y9cwU9idj/dijthCqz6CXOMm43KZnNf64a2N0Fpv?=
 =?us-ascii?Q?Ep9ll2Z+eBddVwDJ/lJEzhuMOLIaLoAZTCSCc+1Srn9UIKy0aP701VB2kP/X?=
 =?us-ascii?Q?W2FzK+B4PFJk4nNXeT9geuuAEz9l/3kj0M5uTygE4smCYLmqUv5Dj7sgl9Nb?=
 =?us-ascii?Q?2z6vU92J2H/Z2xgspF3J/hgXbXWJywSWnoQc3bHfoKLjV6tefDh9hnaYP1vp?=
 =?us-ascii?Q?GRwfmXLyt7xXU3pFMIe8bUCfU8LsE529s53YZ0RyghzycTcN5Mf1nozQ5Y/B?=
 =?us-ascii?Q?wbTijenY/w7y3Dorl7vGOQOtZNSnx4n1xJHu2hV1ZAQYQsTMkvtkZPWEBFdd?=
 =?us-ascii?Q?TtVaIqJ3037lnOXa733mmi70TCjJZLSLBa/4XHlJ+z42Vr/cynFlEIcmkQOb?=
 =?us-ascii?Q?5r4kHSV3TmqRU+LZPdn0TwUogtZqqsFqCXUmwIWgr74Asr2DXNV2dv0sYs6/?=
 =?us-ascii?Q?juY1wlTL1ZbrvFYsFAbcsgcGGApeUhre7elSXxjGzzjVV06vYsPWBtsNQh+W?=
 =?us-ascii?Q?eIRag+7wdz2Gr2SBBPw9/2dISpdHmjoqLsW6tZsSkojz0I1k6kogUtvsa+ND?=
 =?us-ascii?Q?Ki0RNnk4mbSYGp1cnfSvkG+ZpV91uvPMnuggWCFxQPmIRg85+zfxQgkCa/AX?=
 =?us-ascii?Q?I4gaHvHCgbQ56gcrSnb1bbjKwyDfb/hm+wHEbG3El+YD6L0rsmh3m9gW/nAx?=
 =?us-ascii?Q?wrEb1xp0trZEslIqIYDDCA5y?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba0819ca-6a03-4f51-231b-08d97f6502f6
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2021 14:10:07.2006
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: flgps5Lv/pi3CLb7u4TMHWUwltSUmaTDcE+ru+r920+V0TBBiRMN+pvYtqcwTKY/A2bNKBJ65Kzx1GBcSSt+xA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2541
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10116 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 spamscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109240088
X-Proofpoint-ORIG-GUID: q1z0oDcLKZXuW15SOwb_9MXXC3DrkOd4
X-Proofpoint-GUID: q1z0oDcLKZXuW15SOwb_9MXXC3DrkOd4
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The upcoming buffer cache rework/kerenl sync-up requires atomic
variables. I could use C++11 atomics build into GCC, but they are a
pain to work with and shoe-horn into the kernel atomic variable API.

Much easier is to introduce a dependency on liburcu - the userspace
RCU library. This provides atomic variables that very closely match
the kernel atomic variable API, and it provides a very similar
memory model and memory barrier support to the kernel. And we get
RCU support that has an identical interface to the kernel and works
the same way.

Hence kernel code written with RCU algorithms and atomic variables
will just slot straight into the userspace xfsprogs code without us
having to think about whether the lockless algorithms will work in
userspace or not. This reduces glue and hoop jumping, and gets us
a step closer to having the entire userspace libxfs code MT safe.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
[chandan.babu@oracle.com: Add m4 macros to detect availability of liburcu]
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 configure.ac               |  3 +++
 copy/Makefile              |  3 ++-
 copy/xfs_copy.c            |  3 +++
 db/Makefile                |  3 ++-
 debian/control             |  2 +-
 growfs/Makefile            |  3 ++-
 include/builddefs.in       |  4 +++-
 include/platform_defs.h.in |  1 +
 libfrog/workqueue.c        |  3 +++
 libxfs/init.c              |  3 +++
 libxfs/libxfs_priv.h       |  3 +--
 logprint/Makefile          |  3 ++-
 m4/Makefile                |  1 +
 m4/package_urcu.m4         | 24 ++++++++++++++++++++++++
 mdrestore/Makefile         |  3 ++-
 mkfs/Makefile              |  2 +-
 repair/Makefile            |  2 +-
 repair/prefetch.c          |  9 +++++++--
 repair/progress.c          |  4 +++-
 scrub/Makefile             |  3 ++-
 scrub/progress.c           |  2 ++
 21 files changed, 69 insertions(+), 15 deletions(-)
 create mode 100644 m4/package_urcu.m4

diff --git a/configure.ac b/configure.ac
index 56871745..61c6cf40 100644
--- a/configure.ac
+++ b/configure.ac
@@ -154,6 +154,9 @@ AC_PACKAGE_NEED_UUIDCOMPARE
 AC_PACKAGE_NEED_PTHREAD_H
 AC_PACKAGE_NEED_PTHREADMUTEXINIT
 
+AC_PACKAGE_NEED_URCU_H
+AC_PACKAGE_NEED_RCU_SET_POINTER_SYM
+
 AC_HAVE_FADVISE
 AC_HAVE_MADVISE
 AC_HAVE_MINCORE
diff --git a/copy/Makefile b/copy/Makefile
index 449b235f..1b00cd0d 100644
--- a/copy/Makefile
+++ b/copy/Makefile
@@ -9,7 +9,8 @@ LTCOMMAND = xfs_copy
 CFILES = xfs_copy.c
 HFILES = xfs_copy.h
 
-LLDLIBS = $(LIBXFS) $(LIBXLOG) $(LIBFROG) $(LIBUUID) $(LIBPTHREAD) $(LIBRT)
+LLDLIBS = $(LIBXFS) $(LIBXLOG) $(LIBFROG) $(LIBUUID) $(LIBPTHREAD) $(LIBRT) \
+	  $(LIBURCU)
 LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG) $(LIBFROG)
 LLDFLAGS = -static-libtool-libs
 
diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index fc7d225f..f5eff969 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -110,6 +110,7 @@ do_message(int flags, int code, const char *fmt, ...)
 		fprintf(stderr,
 			_("Aborting XFS copy -- logfile error -- reason: %s\n"),
 			strerror(errno));
+		rcu_unregister_thread();
 		pthread_exit(NULL);
 	}
 }
@@ -224,6 +225,7 @@ begin_reader(void *arg)
 {
 	thread_args	*args = arg;
 
+	rcu_register_thread();
 	for (;;) {
 		pthread_mutex_lock(&args->wait);
 		if (do_write(args, NULL))
@@ -243,6 +245,7 @@ handle_error:
 	if (--glob_masks.num_working == 0)
 		pthread_mutex_unlock(&mainwait);
 	pthread_mutex_unlock(&glob_masks.mutex);
+	rcu_unregister_thread();
 	pthread_exit(NULL);
 	return NULL;
 }
diff --git a/db/Makefile b/db/Makefile
index beafb105..5c017898 100644
--- a/db/Makefile
+++ b/db/Makefile
@@ -18,7 +18,8 @@ CFILES = $(HFILES:.h=.c) btdump.c btheight.c convert.c info.c namei.c \
 	timelimit.c
 LSRCFILES = xfs_admin.sh xfs_ncheck.sh xfs_metadump.sh
 
-LLDLIBS	= $(LIBXFS) $(LIBXLOG) $(LIBFROG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
+LLDLIBS	= $(LIBXFS) $(LIBXLOG) $(LIBFROG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD) \
+	  $(LIBURCU)
 LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG) $(LIBFROG)
 LLDFLAGS += -static-libtool-libs
 
diff --git a/debian/control b/debian/control
index e4ec897c..71c08167 100644
--- a/debian/control
+++ b/debian/control
@@ -3,7 +3,7 @@ Section: admin
 Priority: optional
 Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
 Uploaders: Nathan Scott <nathans@debian.org>, Anibal Monsalve Salazar <anibal@debian.org>, Bastian Germann <bastiangermann@fishpost.de>
-Build-Depends: libinih-dev (>= 53), uuid-dev, dh-autoreconf, debhelper (>= 5), gettext, libtool, libedit-dev, libblkid-dev (>= 2.17), linux-libc-dev, libdevmapper-dev, libattr1-dev, libicu-dev, pkg-config
+Build-Depends: libinih-dev (>= 53), uuid-dev, dh-autoreconf, debhelper (>= 5), gettext, libtool, libedit-dev, libblkid-dev (>= 2.17), linux-libc-dev, libdevmapper-dev, libattr1-dev, libicu-dev, pkg-config, liburcu-dev
 Standards-Version: 4.0.0
 Homepage: https://xfs.wiki.kernel.org/
 
diff --git a/growfs/Makefile b/growfs/Makefile
index a107d348..08601de7 100644
--- a/growfs/Makefile
+++ b/growfs/Makefile
@@ -9,7 +9,8 @@ LTCOMMAND = xfs_growfs
 
 CFILES = xfs_growfs.c
 
-LLDLIBS = $(LIBXFS) $(LIBXCMD) $(LIBFROG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
+LLDLIBS = $(LIBXFS) $(LIBXCMD) $(LIBFROG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD) \
+	  $(LIBURCU)
 
 ifeq ($(ENABLE_EDITLINE),yes)
 LLDLIBS += $(LIBEDITLINE) $(LIBTERMCAP)
diff --git a/include/builddefs.in b/include/builddefs.in
index e8f447f9..78eddf4a 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -22,6 +22,7 @@ LDFLAGS =
 
 LIBRT = @librt@
 LIBUUID = @libuuid@
+LIBURCU = @liburcu@
 LIBPTHREAD = @libpthread@
 LIBTERMCAP = @libtermcap@
 LIBEDITLINE = @libeditline@
@@ -125,7 +126,8 @@ CROND_DIR = @crond_dir@
 GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
 #	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
 
-PCFLAGS = -D_GNU_SOURCE $(GCCFLAGS)
+# _LGPL_SOURCE is for liburcu to work correctly with GPL/LGPL programs
+PCFLAGS = -D_LGPL_SOURCE -D_GNU_SOURCE $(GCCFLAGS)
 ifeq ($(HAVE_UMODE_T),yes)
 PCFLAGS += -DHAVE_UMODE_T
 endif
diff --git a/include/platform_defs.h.in b/include/platform_defs.h.in
index 539bdbec..7c6b3ada 100644
--- a/include/platform_defs.h.in
+++ b/include/platform_defs.h.in
@@ -23,6 +23,7 @@
 #include <limits.h>
 #include <stdbool.h>
 #include <libgen.h>
+#include <urcu.h>
 
 typedef struct filldir		filldir_t;
 
diff --git a/libfrog/workqueue.c b/libfrog/workqueue.c
index 8c1a163e..702a53e2 100644
--- a/libfrog/workqueue.c
+++ b/libfrog/workqueue.c
@@ -11,6 +11,7 @@
 #include <stdbool.h>
 #include <errno.h>
 #include <assert.h>
+#include <urcu.h>
 #include "workqueue.h"
 
 /* Main processing thread */
@@ -24,6 +25,7 @@ workqueue_thread(void *arg)
 	 * Loop pulling work from the passed in work queue.
 	 * Check for notification to exit after every chunk of work.
 	 */
+	rcu_register_thread();
 	while (1) {
 		pthread_mutex_lock(&wq->lock);
 
@@ -60,6 +62,7 @@ workqueue_thread(void *arg)
 		(wi->function)(wi->queue, wi->index, wi->arg);
 		free(wi);
 	}
+	rcu_unregister_thread();
 
 	return NULL;
 }
diff --git a/libxfs/init.c b/libxfs/init.c
index 1ec83791..b06faf8a 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -310,6 +310,8 @@ libxfs_init(libxfs_init_t *a)
 	fd = -1;
 	flags = (a->isreadonly | a->isdirect);
 
+	rcu_init();
+	rcu_register_thread();
 	radix_tree_init();
 
 	if (a->volname) {
@@ -1023,6 +1025,7 @@ libxfs_destroy(
 	libxfs_bcache_free();
 	cache_destroy(libxfs_bcache);
 	leaked = destroy_zones();
+	rcu_unregister_thread();
 	if (getenv("LIBXFS_LEAK_CHECK") && leaked)
 		exit(1);
 }
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 7181a858..db90e173 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -210,8 +210,7 @@ enum ce { CE_DEBUG, CE_CONT, CE_NOTE, CE_WARN, CE_ALERT, CE_PANIC };
 #define spin_unlock(a)		((void) 0)
 #define likely(x)		(x)
 #define unlikely(x)		(x)
-#define rcu_read_lock()		((void) 0)
-#define rcu_read_unlock()	((void) 0)
+
 /* Need to be able to handle this bare or in control flow */
 static inline bool WARN_ON(bool expr) {
 	return (expr);
diff --git a/logprint/Makefile b/logprint/Makefile
index 758504b3..cdedbd0d 100644
--- a/logprint/Makefile
+++ b/logprint/Makefile
@@ -12,7 +12,8 @@ CFILES = logprint.c \
 	 log_copy.c log_dump.c log_misc.c \
 	 log_print_all.c log_print_trans.c log_redo.c
 
-LLDLIBS	= $(LIBXFS) $(LIBXLOG) $(LIBFROG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
+LLDLIBS	= $(LIBXFS) $(LIBXLOG) $(LIBFROG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD) \
+	  $(LIBURCU)
 LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG) $(LIBFROG)
 LLDFLAGS = -static-libtool-libs
 
diff --git a/m4/Makefile b/m4/Makefile
index c6c73dc9..73120530 100644
--- a/m4/Makefile
+++ b/m4/Makefile
@@ -24,6 +24,7 @@ LSRCFILES = \
 	package_services.m4 \
 	package_types.m4 \
 	package_icu.m4 \
+	package_urcu.m4 \
 	package_utilies.m4 \
 	package_uuiddev.m4 \
 	multilib.m4 \
diff --git a/m4/package_urcu.m4 b/m4/package_urcu.m4
new file mode 100644
index 00000000..74a24db9
--- /dev/null
+++ b/m4/package_urcu.m4
@@ -0,0 +1,24 @@
+AC_DEFUN([AC_PACKAGE_NEED_URCU_H],
+  [ AC_CHECK_HEADERS([urcu.h])
+    if test $ac_cv_header_urcu_h = no; then
+	echo
+	echo 'FATAL ERROR: could not find a valid URCU header.'
+	echo 'Install the Userspace RCU development package.'
+	exit 1
+    fi
+  ])
+
+AC_DEFUN([AC_PACKAGE_NEED_RCU_SET_POINTER_SYM],
+  [ AC_CHECK_FUNCS(rcu_set_pointer_sym)
+    if test $ac_cv_func_rcu_set_pointer_sym = yes; then
+	liburcu=""
+    else
+	AC_CHECK_LIB(urcu, rcu_set_pointer_sym,, [
+	    echo
+	    echo 'FATAL ERROR: could not find a valid urcu library.'
+	    echo 'Install the Userspace RCU development package.'
+	    exit 1])
+	liburcu="-lurcu"
+    fi
+    AC_SUBST(liburcu)
+  ])
diff --git a/mdrestore/Makefile b/mdrestore/Makefile
index d946955b..8f28ddab 100644
--- a/mdrestore/Makefile
+++ b/mdrestore/Makefile
@@ -8,7 +8,8 @@ include $(TOPDIR)/include/builddefs
 LTCOMMAND = xfs_mdrestore
 CFILES = xfs_mdrestore.c
 
-LLDLIBS = $(LIBXFS) $(LIBFROG) $(LIBRT) $(LIBPTHREAD) $(LIBUUID)
+LLDLIBS = $(LIBXFS) $(LIBFROG) $(LIBRT) $(LIBPTHREAD) $(LIBUUID) \
+	  $(LIBURCU)
 LTDEPENDENCIES = $(LIBXFS) $(LIBFROG)
 LLDFLAGS = -static
 
diff --git a/mkfs/Makefile b/mkfs/Makefile
index b8805f7e..811ba9db 100644
--- a/mkfs/Makefile
+++ b/mkfs/Makefile
@@ -11,7 +11,7 @@ HFILES =
 CFILES = proto.c xfs_mkfs.c
 
 LLDLIBS += $(LIBXFS) $(LIBXCMD) $(LIBFROG) $(LIBRT) $(LIBPTHREAD) $(LIBBLKID) \
-	$(LIBUUID) $(LIBINIH)
+	$(LIBUUID) $(LIBINIH) $(LIBURCU)
 LTDEPENDENCIES += $(LIBXFS) $(LIBXCMD) $(LIBFROG)
 LLDFLAGS = -static-libtool-libs
 
diff --git a/repair/Makefile b/repair/Makefile
index 5f0764d1..47536ca1 100644
--- a/repair/Makefile
+++ b/repair/Makefile
@@ -72,7 +72,7 @@ CFILES = \
 	xfs_repair.c
 
 LLDLIBS = $(LIBXFS) $(LIBXLOG) $(LIBXCMD) $(LIBFROG) $(LIBUUID) $(LIBRT) \
-	$(LIBPTHREAD) $(LIBBLKID)
+	$(LIBPTHREAD) $(LIBBLKID) $(LIBURCU)
 LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG) $(LIBXCMD) $(LIBFROG)
 LLDFLAGS = -static-libtool-libs
 
diff --git a/repair/prefetch.c b/repair/prefetch.c
index 48affa18..22a0c0c9 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -660,6 +660,7 @@ pf_io_worker(
 	if (buf == NULL)
 		return NULL;
 
+	rcu_register_thread();
 	pthread_mutex_lock(&args->lock);
 	while (!args->queuing_done || !btree_is_empty(args->io_queue)) {
 		pftrace("waiting to start prefetch I/O for AG %d", args->agno);
@@ -682,6 +683,7 @@ pf_io_worker(
 	free(buf);
 
 	pftrace("finished prefetch I/O for AG %d", args->agno);
+	rcu_unregister_thread();
 
 	return NULL;
 }
@@ -726,6 +728,8 @@ pf_queuing_worker(
 	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
 	unsigned long long	cluster_mask;
 
+	rcu_register_thread();
+
 	cluster_mask = (1ULL << igeo->inodes_per_cluster) - 1;
 
 	for (i = 0; i < PF_THREAD_COUNT; i++) {
@@ -739,7 +743,7 @@ pf_queuing_worker(
 			args->io_threads[i] = 0;
 			if (i == 0) {
 				pf_skip_prefetch_thread(args);
-				return NULL;
+				goto out;
 			}
 			/*
 			 * since we have at least one I/O thread, use them for
@@ -779,7 +783,6 @@ pf_queuing_worker(
 			 * Start processing as well, in case everything so
 			 * far was already prefetched and the queue is empty.
 			 */
-			
 			pf_start_io_workers(args);
 			pf_start_processing(args);
 			sem_wait(&args->ra_count);
@@ -841,6 +844,8 @@ pf_queuing_worker(
 	if (next_args)
 		pf_create_prefetch_thread(next_args);
 
+out:
+	rcu_unregister_thread();
 	return NULL;
 }
 
diff --git a/repair/progress.c b/repair/progress.c
index e5a9c1ef..f6c4d988 100644
--- a/repair/progress.c
+++ b/repair/progress.c
@@ -182,6 +182,7 @@ progress_rpt_thread (void *p)
 		do_error (_("progress_rpt: cannot malloc progress msg buffer\n"));
 
 	running = 1;
+	rcu_register_thread();
 
 	/*
 	 * Specify a repeating timer that fires each MSG_INTERVAL seconds.
@@ -286,7 +287,8 @@ progress_rpt_thread (void *p)
 		do_warn(_("cannot delete timer\n"));
 
 	free (msgbuf);
-	return (NULL);
+	rcu_unregister_thread();
+	return NULL;
 }
 
 int
diff --git a/scrub/Makefile b/scrub/Makefile
index 47c887eb..849e3afd 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -71,7 +71,8 @@ spacemap.c \
 vfs.c \
 xfs_scrub.c
 
-LLDLIBS += $(LIBHANDLE) $(LIBFROG) $(LIBPTHREAD) $(LIBICU_LIBS) $(LIBRT)
+LLDLIBS += $(LIBHANDLE) $(LIBFROG) $(LIBPTHREAD) $(LIBICU_LIBS) $(LIBRT) \
+	$(LIBURCU)
 LTDEPENDENCIES += $(LIBHANDLE) $(LIBFROG)
 LLDFLAGS = -static
 
diff --git a/scrub/progress.c b/scrub/progress.c
index 15247b7c..a3d096f9 100644
--- a/scrub/progress.c
+++ b/scrub/progress.c
@@ -116,6 +116,7 @@ progress_report_thread(void *arg)
 	struct timespec		abstime;
 	int			ret;
 
+	rcu_register_thread();
 	pthread_mutex_lock(&pt.lock);
 	while (1) {
 		uint64_t	progress_val;
@@ -139,6 +140,7 @@ progress_report_thread(void *arg)
 			progress_report(progress_val);
 	}
 	pthread_mutex_unlock(&pt.lock);
+	rcu_unregister_thread();
 	return NULL;
 }
 
-- 
2.30.2

