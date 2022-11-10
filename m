Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECA98C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Nov 2022 21:07:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232082AbiKJVHH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Nov 2022 16:07:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231849AbiKJVHG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Nov 2022 16:07:06 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C6B05FC5
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 13:07:04 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAL0cYD006990
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:07:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=H3lkxB03rzm94caOkcTVUFJ/CEZuIvLz0oLcTqZUAUI=;
 b=NHYhIw5+6sevbgrZETMdkN9Z7+L+ioODb2YktLxzTLZYAqxICItMf23RrDbjGe/pIjx6
 SJkBS3hLz8FNs3vO6eVXp9Z+Uav4iJYmNGoG1z+s3tq/2V5h0dZ2Q07L+sJyBdyCzAzu
 rd3DJmXJ+MDRyfe7ts/8xVfvEHpNmu9CbKThUe5/ggXk7476ETEF/G5q6qwjray4Lb1Q
 FLQSPOQjDwxtKr74Vhwrfvyogwc3+E2yuFcFfzuqA7YvmSwVEfIt16VlDsnCPYwyceIA
 CWL/iPN5sMzGmL5XfFAv8pjpDCqdygMbbcJbgZJjZqM04jjawEVcu5VnLiofrmJWHXAd 7Q== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ks8u5r1c7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:07:01 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAKWWx9023224
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:06:16 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcyset43-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:06:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KB7pjOPUsq4suExsDoPT0wVLm+PlZf8T2F+6kq3d+e+GXfOiu/Zk/Mvi6LtHaO8VQtbL1OufwAzefGjmmsWfXAEsX5M8nSOHS8tXd3RUJzVMX0rfCduAFLb2fioav8692/EAVwJmCPA67MjUumiks4xjAj0ZcmeQGXZpFVgjDhVVWrzhvxosiXNePmZmA/MZbl0st7KGCHJDTaxIS5U+JzdmevAxATRm+CtWCn6fUExmqRUOBLES7ok0a0wV8QqAdBz1shNMUlZhNgLknjYZ6DIFGtTYpCkrv7iFUWBExEcewqC9yBq9KE1oEDeLDfxUxDDHKvmud3lFCJGqF93TVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H3lkxB03rzm94caOkcTVUFJ/CEZuIvLz0oLcTqZUAUI=;
 b=jAXg4s9BKmQiRJybEErbBaBhFViClHM1PqVWvFdCYxdwHYhS9ifX2qxBq+B3qYHMgB285MqUHDv+U4gNKAurtQd5QJ02remPyjokhZ/RdbWcMQWEMRdPioBqcLyLOddpUyQgmfMt0sPiLSZ4kah0cJP6Y11AGR+rRWYLJzfblX6An1o98END9lgncjuNYGQy9yqjEVlIFBiSdFzjM8L3m3pzgjz2aPSv8KhHNavOVpe2WhnDwTY6iNaNn96qqRqKRhPI2jMHYbTpR738hTMxkoEPoOFEYE8uQVjlAjLeITVqOE6jbdgJ+e1Nl+q1I73eZABZbs5qOFHqTDiYbXMh7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H3lkxB03rzm94caOkcTVUFJ/CEZuIvLz0oLcTqZUAUI=;
 b=zGUk0GQAaWESeuRNsiD2f1YO8Gw0LUDX+jpcCE05WgC8KYv7Ax2RA3IMvxs40ik2i2u5YQH2cOkzkpE5WFewXte7UlM5yzc0eOBpTTPyjh7YzQ2e2J2jXO6gFQCheiL/DprkOW8EXmChrLoT+hCzbxQV07bJqCOguiyEQZ4IqHA=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH8PR10MB6527.namprd10.prod.outlook.com (2603:10b6:510:229::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Thu, 10 Nov
 2022 21:06:13 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5813.013; Thu, 10 Nov 2022
 21:06:13 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 23/25] xfsprogs: implement the upper half of parent pointers
Date:   Thu, 10 Nov 2022 14:05:25 -0700
Message-Id: <20221110210527.56628-24-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221110210527.56628-1-allison.henderson@oracle.com>
References: <20221110210527.56628-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0012.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::17) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH8PR10MB6527:EE_
X-MS-Office365-Filtering-Correlation-Id: 6abf2638-c5b5-4e82-277a-08dac35f667e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7IC6PjpVjsPtAdB9qf1/hDHb9ZMqYKJOE6ZrEL1dzBXz1WiPI5r4hHSwRUEaCL8MLfhymSRB+tf1auGm1JNdf1KIUFDUfcI8anJGupmli90Dtg0EU9mp70ymGsU6skeiko2zUOmVwTMDnR3ynOn6BR75cvOKCN9iwvLhKqvwgXGbYx3QGlbGeqjnI9A+N6mtFxO+d/SAvLAM6SiqAxPzWYHlCmdz+EDe/ohkbcunCcoKw7+JcqhZj+xK4dzAdBwUiOITW2eHZpChC2KvHD7p1iuTys5NQgvX0Ty+1OhuPYyj8uJNUB3dgYP/T/ixJPREAp609jnLatFh7PhFLgLm7/ECZqqUtxVwQbZKkxpokfepTE6xdAizeQpRO+xq04abMy2y3rwzALg51Is6MKoVQQtltFx6xqjYA4jr66eclBGgQ1ZhvfA7N4YHM8Oqs8ZF+huOuArUcIVHtOToUBIE13eGC4Rcaxh/AUbLs+FpbPuVRb2UrWkI3o9O9KBkwrjT7C2s5rcT8h4OClufs9rkJl24kZmMfPsx8qFqQuyoIQIC7k3iE5wwnmqEY/0qzJSSS6Cn+csZLpMl+0L/qo9kvXGrC6h7ze84+YjG79An4jhLJJuNUiJCW4BiYHGdufT07JWzwyzG4uWYnVnVI0A9uCkFRb0eIZnp0d+NadVNIz/FfWLdGrSEvcDTzH93LF3SC29fH8MRNPl7+wm6XGfRXiXpeo+SI8uq9x1gEExd1gsdb+Jm9me2LXx72oDcYW5/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(346002)(136003)(39860400002)(451199015)(1076003)(186003)(83380400001)(2616005)(478600001)(6486002)(6506007)(9686003)(26005)(6512007)(6666004)(86362001)(38100700002)(2906002)(66946007)(66556008)(66476007)(8676002)(41300700001)(8936002)(6916009)(5660300002)(316002)(30864003)(36756003)(2004002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FXtJFZXANn0Y92qSR0AgiQ/bOc2zz+DaonqepAFkUfDMZMREr7W/AfAZoiDT?=
 =?us-ascii?Q?rEhvF/0dBMC4OT6VATFC9eie+qOHiD1jzOxT/6wwbpvWq77EGXQV5UXpyDlG?=
 =?us-ascii?Q?tXKcS1SHLTsJAGCufbXDSPqGcKuxZOilmVRWzNYKdoWXYQ6+E2ynhtgWG7nv?=
 =?us-ascii?Q?lh/tv07z9pvhM87dZsHw0zbrwWQpIkBYvaPwQDQ+mYmHNrPRTiouiSf/Ygpu?=
 =?us-ascii?Q?Y6bjitwnEB8DNmWBrSwPeMKFXXfrs3vN7fPO+TW27NQ+4U5GxwcpXwlEi830?=
 =?us-ascii?Q?OPZQbsm1sZmVWfwQleII3cB3t6QsVZgSP36vnYkQH+QBy5C015TDJuQtrI2G?=
 =?us-ascii?Q?IR5swNJXCfqCIR9lkOHi0YK/1wXTpqi2Z9oMdwbx6U3wgjy90e83x2Jk21fn?=
 =?us-ascii?Q?wCxdYZi156j128HrkF/YYu8vL9SS4310nxFQo2yIx2OCjPOXbc5ZSQ22guBS?=
 =?us-ascii?Q?yYTRItBfsCPFjlfL3boHErN8KxDNrJ6xzh5XhZoVp1bliFR416ulArYbjTPw?=
 =?us-ascii?Q?UAv73g1JMPb7TqHYbEsBk9/wbR5Vg+d5RSQduaM7OFSnm/Vekb1G91S+IC2i?=
 =?us-ascii?Q?ICECrveplPQK4LoEhzOhC9CEzqaz9rRWLFNRbQl5yM8chVYVzZeyAgglzxe+?=
 =?us-ascii?Q?37iMcdZjYesK/L3VXPEre+ITHjesw70xL50ETGpOP7UJUjik9OS9WOeJfD7M?=
 =?us-ascii?Q?uEbR2fdR64IHYK+/5B/S7BS7tgAKs2ZA5LlffwFiSaIjj7PYhb70Ui/4LkwE?=
 =?us-ascii?Q?jPFTf40rlSl4O9a7huAqQixodVRymA02UXZ3P7P30nUciPuKtTiHRNEHgBX2?=
 =?us-ascii?Q?dnWEP1TNvIpOIhimWqI5IVXja6oaaEbj+kQnEECClCIDGAnyYSMckI9Rq1b5?=
 =?us-ascii?Q?bKVYvNoDBp3L6ceNWnFVHhXOtRYlgKgXYxwyyrX1rmsGJPb15kJ5Ula98GE9?=
 =?us-ascii?Q?gdDvL6pnAoBpRf0Ts2G7BXSPKOIukj6kaAjmtTq7m+cwRrR/YXrSyLuv/2F1?=
 =?us-ascii?Q?mH9c8rSlcxKaD5cp9x+OmLy953Gjk2X9QwJj3tTEX+ng0FcE7mjgHtmNJMHw?=
 =?us-ascii?Q?cwwu8JnokukuXsBUHlQJ+X9ojsqfgrQbxnjRA3xIr9YGoAOa/OT9PwET8GIA?=
 =?us-ascii?Q?H3ZpOZkiVzZo6PI/VyIjcfHeHe5p1ouWPwqCT3kHS5VDdDH4LGNFeQEhMVLA?=
 =?us-ascii?Q?S5I8jVqEfEF1qI0u1zmCKVOUknUG+/1KAIWbYVSwBE+usG982cw8nkw7QPRz?=
 =?us-ascii?Q?xFkxd9lAtPoaaI3wbWe0M0bahF63fNK4mmbkW0quwsFeEBZfzn+lygvup7Il?=
 =?us-ascii?Q?wiQspyEunR9xU83i+QWIMmTn3VTls0666ANW8RsGo7y2HF10ZyNx/58jTb4y?=
 =?us-ascii?Q?YpA1oFt1EDjMQF03HEezmRWFsMfemf7MDyOIlMivLblAaOD+Dyi8CzkBnVWZ?=
 =?us-ascii?Q?MEVUzKY86mWFR88Tgi4fQJwF7BlRrdtmP8VoSb4NXRvydCySuMSUDxsxfC43?=
 =?us-ascii?Q?pNHQX4vRK3OcqtApUbq0+Mk4ihtOwRjNZJYX/dys7JGoU6Rd77YugvtPTk1C?=
 =?us-ascii?Q?mlKaphIemloJlYGHap4esguTi1de7RDavkK1kJZdXMZN+25C3Vwz4L0itNcE?=
 =?us-ascii?Q?OA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6abf2638-c5b5-4e82-277a-08dac35f667e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 21:06:13.6762
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8YYyZeZ+ac6taxm1H1ePyEx3rfsY9bSSpWxGolGyms0jEFektlVjGFqf8QGVhAD1ejR2pAJDdfPY44LbSpnnTRbJkV1dP8bO9ZYHr+2dqXw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6527
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_13,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 malwarescore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211100148
X-Proofpoint-ORIG-GUID: PaIf4oChr54FfVaEhPjbMhmdrBuyWkS_
X-Proofpoint-GUID: PaIf4oChr54FfVaEhPjbMhmdrBuyWkS_
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Collins <allison.henderson@oracle.com>

Add ioctl definitions to libxfs, build the necessary helpers into libfrog and
libhandle to iterate parents (and parent paths), then wire up xfs_scrub to be able
to query parent pointers from userspace.  The goal of this patch is to exercise
userspace, and is nowhere near a complete solution.  A basic xfs_io parent command
implementation replaces ... whatever that is that's there now.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Allison Collins <allison.henderson@oracle.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 include/handle.h   |   2 +
 include/parent.h   |  18 ++
 io/parent.c        | 469 ++++++++++++---------------------------------
 libfrog/paths.c    | 136 +++++++++++++
 libfrog/paths.h    |  21 +-
 libhandle/Makefile |   2 +-
 libhandle/handle.c |   7 +-
 libhandle/parent.c | 328 +++++++++++++++++++++++++++++++
 scrub/inodes.c     |  26 +++
 scrub/inodes.h     |   2 +
 10 files changed, 656 insertions(+), 355 deletions(-)

diff --git a/include/handle.h b/include/handle.h
index 34246f3854de..1f02c96427b7 100644
--- a/include/handle.h
+++ b/include/handle.h
@@ -40,6 +40,8 @@ extern int  fssetdm_by_handle (void *__hanp, size_t __hlen,
 
 void fshandle_destroy(void);
 
+int handle_to_fsfd(void *hanp, char **path);
+
 #ifdef __cplusplus
 }
 #endif
diff --git a/include/parent.h b/include/parent.h
index 4d3ad51b476c..fb9000419bee 100644
--- a/include/parent.h
+++ b/include/parent.h
@@ -17,4 +17,22 @@ typedef struct parent_cursor {
 	__u32	opaque[4];      /* an opaque cookie */
 } parent_cursor_t;
 
+struct path_list;
+
+typedef int (*walk_pptr_fn)(struct xfs_pptr_info *pi, struct xfs_parent_ptr *pptr,
+		void *arg);
+typedef int (*walk_ppath_fn)(const char *mntpt, struct path_list *path,
+		void *arg);
+
+#define WALK_PPTRS_ABORT	1
+int fd_walk_pptrs(int fd, walk_pptr_fn fn, void *arg);
+int handle_walk_pptrs(void *hanp, size_t hanlen, walk_pptr_fn fn, void *arg);
+
+#define WALK_PPATHS_ABORT	1
+int fd_walk_ppaths(int fd, walk_ppath_fn fn, void *arg);
+int handle_walk_ppaths(void *hanp, size_t hanlen, walk_ppath_fn fn, void *arg);
+
+int fd_to_path(int fd, char *path, size_t pathlen);
+int handle_to_path(void *hanp, size_t hlen, char *path, size_t pathlen);
+
 #endif
diff --git a/io/parent.c b/io/parent.c
index 8f63607ffec2..e0ca29eb54c7 100644
--- a/io/parent.c
+++ b/io/parent.c
@@ -9,363 +9,106 @@
 #include "libfrog/paths.h"
 #include "parent.h"
 #include "handle.h"
-#include "jdm.h"
 #include "init.h"
 #include "io.h"
 
-#define PARENTBUF_SZ		16384
-#define BSTATBUF_SZ		16384
-
 static cmdinfo_t parent_cmd;
-static int verbose_flag;
-static int err_status;
-static __u64 inodes_checked;
 static char *mntpt;
 
-/*
- * check out a parent entry to see if the values seem valid
- */
-static void
-check_parent_entry(struct xfs_bstat *bstatp, parent_t *parent)
-{
-	int sts;
-	char fullpath[PATH_MAX];
-	struct stat statbuf;
-	char *str;
-
-	sprintf(fullpath, _("%s%s"), mntpt, parent->p_name);
-
-	sts = lstat(fullpath, &statbuf);
-	if (sts != 0) {
-		fprintf(stderr,
-			_("inode-path for inode: %llu is incorrect - path \"%s\" non-existent\n"),
-			(unsigned long long) bstatp->bs_ino, fullpath);
-		if (verbose_flag) {
-			fprintf(stderr,
-				_("path \"%s\" does not stat for inode: %llu; err = %s\n"),
-				fullpath,
-			       (unsigned long long) bstatp->bs_ino,
-				strerror(errno));
-		}
-		err_status++;
-		return;
-	} else {
-		if (verbose_flag > 1) {
-			printf(_("path \"%s\" found\n"), fullpath);
-		}
-	}
-
-	if (statbuf.st_ino != bstatp->bs_ino) {
-		fprintf(stderr,
-			_("inode-path for inode: %llu is incorrect - wrong inode#\n"),
-		       (unsigned long long) bstatp->bs_ino);
-		if (verbose_flag) {
-			fprintf(stderr,
-				_("ino mismatch for path \"%s\" %llu vs %llu\n"),
-				fullpath,
-				(unsigned long long)statbuf.st_ino,
-				(unsigned long long)bstatp->bs_ino);
-		}
-		err_status++;
-		return;
-	} else if (verbose_flag > 1) {
-		printf(_("inode number match: %llu\n"),
-			(unsigned long long)statbuf.st_ino);
-	}
-
-	/* get parent path */
-	str = strrchr(fullpath, '/');
-	*str = '\0';
-	sts = stat(fullpath, &statbuf);
-	if (sts != 0) {
-		fprintf(stderr,
-			_("parent path \"%s\" does not stat: %s\n"),
-			fullpath,
-			strerror(errno));
-		err_status++;
-		return;
-	} else {
-		if (parent->p_ino != statbuf.st_ino) {
-			fprintf(stderr,
-				_("inode-path for inode: %llu is incorrect - wrong parent inode#\n"),
-			       (unsigned long long) bstatp->bs_ino);
-			if (verbose_flag) {
-				fprintf(stderr,
-					_("ino mismatch for path \"%s\" %llu vs %llu\n"),
-					fullpath,
-					(unsigned long long)parent->p_ino,
-					(unsigned long long)statbuf.st_ino);
-			}
-			err_status++;
-			return;
-		} else {
-			if (verbose_flag > 1) {
-			       printf(_("parent ino match for %llu\n"),
-				       (unsigned long long) parent->p_ino);
-			}
-		}
-	}
-}
-
-static void
-check_parents(parent_t *parentbuf, size_t *parentbuf_size,
-	     jdm_fshandle_t *fshandlep, struct xfs_bstat *statp)
-{
-	int error, i;
-	__u32 count;
-	parent_t *entryp;
-
-	do {
-		error = jdm_parentpaths(fshandlep, statp, parentbuf, *parentbuf_size, &count);
-
-		if (error == ERANGE) {
-			*parentbuf_size *= 2;
-			parentbuf = (parent_t *)realloc(parentbuf, *parentbuf_size);
-		} else if (error) {
-			fprintf(stderr, _("parentpaths failed for ino %llu: %s\n"),
-			       (unsigned long long) statp->bs_ino,
-				strerror(errno));
-			err_status++;
-			break;
-		}
-	} while (error == ERANGE);
-
-
-	if (count == 0) {
-		/* no links for inode - something wrong here */
-	       fprintf(stderr, _("inode-path for inode: %llu is missing\n"),
-			       (unsigned long long) statp->bs_ino);
-		err_status++;
-	}
-
-	entryp = parentbuf;
-	for (i = 0; i < count; i++) {
-		check_parent_entry(statp, entryp);
-		entryp = (parent_t*) (((char*)entryp) + entryp->p_reclen);
-	}
-}
-
 static int
-do_bulkstat(parent_t *parentbuf, size_t *parentbuf_size,
-	    struct xfs_bstat *bstatbuf, int fsfd, jdm_fshandle_t *fshandlep)
+pptr_print(
+	struct xfs_pptr_info	*pi,
+	struct xfs_parent_ptr	*pptr,
+	void			*arg)
 {
-	__s32 buflenout;
-	__u64 lastino = 0;
-	struct xfs_bstat *p;
-	struct xfs_bstat *endp;
-	struct xfs_fsop_bulkreq bulkreq;
-	struct stat mntstat;
+	char			buf[XFS_PPTR_MAXNAMELEN + 1];
+	unsigned int		namelen = strlen((char *)pptr->xpp_name);
 
-	if (stat(mntpt, &mntstat)) {
-		fprintf(stderr, _("can't stat mount point \"%s\": %s\n"),
-			mntpt, strerror(errno));
-		return 1;
+	if (pi->pi_flags & XFS_PPTR_OFLAG_ROOT) {
+		printf(_("Root directory.\n"));
+		return 0;
 	}
 
-	bulkreq.lastip  = &lastino;
-	bulkreq.icount  = BSTATBUF_SZ;
-	bulkreq.ubuffer = (void *)bstatbuf;
-	bulkreq.ocount  = &buflenout;
-
-	while (xfsctl(mntpt, fsfd, XFS_IOC_FSBULKSTAT, &bulkreq) == 0) {
-		if (*(bulkreq.ocount) == 0) {
-			return 0;
-		}
-		for (p = bstatbuf, endp = bstatbuf + *bulkreq.ocount; p < endp; p++) {
-
-			/* inode being modified, get synced data with iget */
-			if ( (!p->bs_nlink || !p->bs_mode) && p->bs_ino != 0 ) {
-
-				if (xfsctl(mntpt, fsfd, XFS_IOC_FSBULKSTAT_SINGLE, &bulkreq) < 0) {
-				    fprintf(stderr,
-					  _("failed to get bulkstat information for inode %llu\n"),
-					 (unsigned long long) p->bs_ino);
-				    continue;
-				}
-				if (!p->bs_nlink || !p->bs_mode || !p->bs_ino) {
-				    fprintf(stderr,
-					  _("failed to get valid bulkstat information for inode %llu\n"),
-					 (unsigned long long) p->bs_ino);
-				    continue;
-				}
-			}
-
-			/* skip root */
-			if (p->bs_ino == mntstat.st_ino) {
-				continue;
-			}
-
-			if (verbose_flag > 1) {
-			       printf(_("checking inode %llu\n"),
-				       (unsigned long long) p->bs_ino);
-			}
-
-			/* print dotted progress */
-			if ((inodes_checked % 100) == 0 && verbose_flag == 1) {
-				printf("."); fflush(stdout);
-			}
-			inodes_checked++;
-
-			check_parents(parentbuf, parentbuf_size, fshandlep, p);
-		}
-
-	}/*while*/
-
-	fprintf(stderr, _("syssgi bulkstat failed: %s\n"), strerror(errno));
-	return 1;
+	memcpy(buf, pptr->xpp_name, namelen);
+	buf[namelen] = 0;
+	printf(_("p_ino    = %llu\n"), (unsigned long long)pptr->xpp_ino);
+	printf(_("p_gen    = %u\n"), (unsigned int)pptr->xpp_gen);
+	printf(_("p_reclen = %u\n"), namelen);
+	printf(_("p_name   = \"%s\"\n\n"), buf);
+	return 0;
 }
 
-static int
-parent_check(void)
+int
+print_parents(
+	struct xfs_handle	*handle)
 {
-	int fsfd;
-	jdm_fshandle_t *fshandlep;
-	parent_t *parentbuf;
-	size_t parentbuf_size = PARENTBUF_SZ;
-	struct xfs_bstat *bstatbuf;
-
-	err_status = 0;
-	inodes_checked = 0;
-
-	sync();
-
-        fsfd = file->fd;
-
-	fshandlep = jdm_getfshandle(mntpt);
-	if (fshandlep == NULL) {
-		fprintf(stderr, _("unable to open \"%s\" for jdm: %s\n"),
-		      mntpt,
-		      strerror(errno));
-		return 1;
-	}
-
-	/* allocate buffers */
-        bstatbuf = (struct xfs_bstat *)calloc(BSTATBUF_SZ, sizeof(struct xfs_bstat));
-	parentbuf = (parent_t *)malloc(parentbuf_size);
-	if (!bstatbuf || !parentbuf) {
-		fprintf(stderr, _("unable to allocate buffers: %s\n"),
-			strerror(errno));
-		err_status = 1;
-		goto out;
-	}
+	int			ret;
 
-	if (do_bulkstat(parentbuf, &parentbuf_size, bstatbuf, fsfd, fshandlep) != 0)
-		err_status++;
-
-	if (err_status > 0)
-		fprintf(stderr, _("num errors: %d\n"), err_status);
+	if (handle)
+		ret = handle_walk_pptrs(handle, sizeof(*handle), pptr_print,
+				NULL);
 	else
-		printf(_("succeeded checking %llu inodes\n"),
-			(unsigned long long) inodes_checked);
-
-out:
-	free(bstatbuf);
-	free(parentbuf);
-	free(fshandlep);
-	return err_status;
-}
+		ret = fd_walk_pptrs(file->fd, pptr_print, NULL);
+	if (ret)
+		perror(file->name);
 
-static void
-print_parent_entry(parent_t *parent, int fullpath)
-{
-       printf(_("p_ino    = %llu\n"),  (unsigned long long) parent->p_ino);
-	printf(_("p_gen    = %u\n"),	parent->p_gen);
-	printf(_("p_reclen = %u\n"),	parent->p_reclen);
-	if (fullpath)
-		printf(_("p_name   = \"%s%s\"\n"), mntpt, parent->p_name);
-	else
-		printf(_("p_name   = \"%s\"\n"), parent->p_name);
+	return 0;
 }
 
 static int
-parent_list(int fullpath)
-{
-	void *handlep = NULL;
-	size_t handlen;
-	int error, i;
-	int retval = 1;
-	__u32 count;
-	parent_t *entryp;
-	parent_t *parentbuf = NULL;
-	char *path = file->name;
-	int pb_size = PARENTBUF_SZ;
-
-	/* XXXX for linux libhandle version - to set libhandle fsfd cache */
-	{
-		void *fshandle;
-		size_t fshlen;
+path_print(
+	const char		*mntpt,
+	struct path_list	*path,
+	void			*arg) {
 
-		if (path_to_fshandle(mntpt, &fshandle, &fshlen) != 0) {
-			fprintf(stderr, _("%s: failed path_to_fshandle \"%s\": %s\n"),
-				progname, path, strerror(errno));
-			goto error;
-		}
-		free_handle(fshandle, fshlen);
-	}
+	char			buf[PATH_MAX];
+	size_t			len = PATH_MAX;
+	int			ret;
 
-	if (path_to_handle(path, &handlep, &handlen) != 0) {
-		fprintf(stderr, _("%s: path_to_handle failed for \"%s\"\n"), progname, path);
-		goto error;
+	ret = snprintf(buf, len, "%s", mntpt);
+	if (ret != strlen(mntpt)) {
+		errno = ENOMEM;
+		return -1;
 	}
 
-	do {
-		parentbuf = (parent_t *)realloc(parentbuf, pb_size);
-		if (!parentbuf) {
-			fprintf(stderr, _("%s: unable to allocate parent buffer: %s\n"),
-				progname, strerror(errno));
-			goto error;
-		}
-
-		if (fullpath) {
-			error = parentpaths_by_handle(handlep,
-						       handlen,
-						       parentbuf,
-						       pb_size,
-						       &count);
-		} else {
-			error = parents_by_handle(handlep,
-						   handlen,
-						   parentbuf,
-						   pb_size,
-						   &count);
-		}
-		if (error == ERANGE) {
-			pb_size *= 2;
-		} else if (error) {
-			fprintf(stderr, _("%s: %s call failed for \"%s\": %s\n"),
-				progname, fullpath ? "parentpaths" : "parents",
-				path, strerror(errno));
-			goto error;
-		}
-	} while (error == ERANGE);
-
-	if (count == 0) {
-		/* no links for inode - something wrong here */
-		fprintf(stderr, _("%s: inode-path is missing\n"), progname);
-		goto error;
-	}
-
-	entryp = parentbuf;
-	for (i = 0; i < count; i++) {
-		print_parent_entry(entryp, fullpath);
-		entryp = (parent_t*) (((char*)entryp) + entryp->p_reclen);
-	}
+	ret = path_list_to_string(path, buf + ret, len - ret);
+	if (ret < 0)
+		return ret;
+	return 0;
+}
 
-	retval = 0;
-error:
-	free(handlep);
-	free(parentbuf);
-	return retval;
+int
+print_paths(
+	struct xfs_handle	*handle)
+{
+	int			ret;
+
+	if (handle)
+		ret = handle_walk_ppaths(handle, sizeof(*handle), path_print,
+				NULL);
+ 	else
+		ret = fd_walk_ppaths(file->fd, path_print, NULL);
+	if (ret)
+		perror(file->name);
+	return 0;
 }
 
 static int
-parent_f(int argc, char **argv)
+parent_f(
+	int			argc,
+	char			**argv)
 {
-	int c;
-	int listpath_flag = 0;
-	int check_flag = 0;
-	fs_path_t *fs;
-	static int tab_init;
+	struct xfs_handle	handle;
+	void			*hanp = NULL;
+	size_t			hlen;
+	struct fs_path		*fs;
+	char			*p;
+	uint64_t		ino = 0;
+	uint32_t		gen = 0;
+	int			c;
+	int			listpath_flag = 0;
+	int			ret;
+	static int		tab_init;
 
 	if (!tab_init) {
 		tab_init = 1;
@@ -380,46 +123,72 @@ parent_f(int argc, char **argv)
 	}
 	mntpt = fs->fs_dir;
 
-	verbose_flag = 0;
-
-	while ((c = getopt(argc, argv, "cpv")) != EOF) {
+	while ((c = getopt(argc, argv, "p")) != EOF) {
 		switch (c) {
-		case 'c':
-			check_flag = 1;
-			break;
 		case 'p':
 			listpath_flag = 1;
 			break;
-		case 'v':
-			verbose_flag++;
-			break;
 		default:
 			return command_usage(&parent_cmd);
 		}
 	}
 
-	if (!check_flag && !listpath_flag) /* default case */
-		exitcode = parent_list(listpath_flag);
-	else {
-		if (listpath_flag)
-			exitcode = parent_list(listpath_flag);
-		if (check_flag)
-			exitcode = parent_check();
+	/*
+	 * Always initialize the fshandle table because we need it for
+	 * the ppaths functions to work.
+	 */
+	ret = path_to_fshandle((char *)mntpt, &hanp, &hlen);
+	if (ret) {
+		perror(mntpt);
+		return 0;
+ 	}
+ 
+	if (optind + 2 == argc) {
+		ino = strtoull(argv[optind], &p, 0);
+		if (*p != '\0' || ino == 0) {
+			fprintf(stderr,
+				_("Bad inode number '%s'.\n"),
+				argv[optind]);
+			return 0;
+		}
+		gen = strtoul(argv[optind + 1], &p, 0);
+		if (*p != '\0') {
+			fprintf(stderr,
+				_("Bad generation number '%s'.\n"),
+				argv[optind + 1]);
+			return 0;
+		}
+
+		memcpy(&handle, hanp, sizeof(handle));
+		handle.ha_fid.fid_len = sizeof(xfs_fid_t) -
+				sizeof(handle.ha_fid.fid_len);
+		handle.ha_fid.fid_pad = 0;
+		handle.ha_fid.fid_ino = ino;
+		handle.ha_fid.fid_gen = gen;
+
 	}
 
+	if (listpath_flag)
+		exitcode = print_paths(ino ? &handle : NULL);
+	else
+		exitcode = print_parents(ino ? &handle : NULL);
+
+	if (hanp)
+		free_handle(hanp, hlen);
+
 	return 0;
 }
 
 static void
 parent_help(void)
 {
-	printf(_(
+printf(_(
 "\n"
 " list the current file's parents and their filenames\n"
 "\n"
-" -c -- check the current file's file system for parent consistency\n"
-" -p -- list the current file's parents and their full paths\n"
-" -v -- verbose mode\n"
+" -p -- list the current file's paths up to the root\n"
+"\n"
+"If ino and gen are supplied, use them instead.\n"
 "\n"));
 }
 
@@ -430,9 +199,9 @@ parent_init(void)
 	parent_cmd.cfunc = parent_f;
 	parent_cmd.argmin = 0;
 	parent_cmd.argmax = -1;
-	parent_cmd.args = _("[-cpv]");
+	parent_cmd.args = _("[-p] [ino gen]");
 	parent_cmd.flags = CMD_NOMAP_OK;
-	parent_cmd.oneline = _("print or check parent inodes");
+	parent_cmd.oneline = _("print parent inodes");
 	parent_cmd.help = parent_help;
 
 	if (expert)
diff --git a/libfrog/paths.c b/libfrog/paths.c
index abb29a237e80..a86ae07c135e 100644
--- a/libfrog/paths.c
+++ b/libfrog/paths.c
@@ -15,6 +15,7 @@
 #include "paths.h"
 #include "input.h"
 #include "projects.h"
+#include "list.h"
 #include <limits.h>
 
 extern char *progname;
@@ -563,3 +564,138 @@ fs_table_insert_project_path(
 
 	return error;
 }
+
+
+/* Structured path components. */
+
+struct path_list {
+	struct list_head	p_head;
+};
+
+struct path_component {
+	struct list_head	pc_list;
+	char			*pc_fname;
+};
+
+/* Initialize a path component with a given name. */
+struct path_component *
+path_component_init(
+	const char		*name)
+{
+	struct path_component	*pc;
+
+	pc = malloc(sizeof(struct path_component));
+	if (!pc)
+		return NULL;
+	INIT_LIST_HEAD(&pc->pc_list);
+	pc->pc_fname = strdup(name);
+	if (!pc->pc_fname) {
+		free(pc);
+		return NULL;
+	}
+	return pc;
+}
+
+/* Free a path component. */
+void
+path_component_free(
+	struct path_component	*pc)
+{
+	free(pc->pc_fname);
+	free(pc);
+}
+
+/* Change a path component's filename. */
+int
+path_component_change(
+	struct path_component	*pc,
+	void			*name,
+	size_t			namelen)
+{
+	void			*p;
+
+	p = realloc(pc->pc_fname, namelen + 1);
+	if (!p)
+		return -1;
+	pc->pc_fname = p;
+	memcpy(pc->pc_fname, name, namelen);
+	pc->pc_fname[namelen] = 0;
+	return 0;
+}
+
+/* Initialize a pathname. */
+struct path_list *
+path_list_init(void)
+{
+	struct path_list	*path;
+
+	path = malloc(sizeof(struct path_list));
+	if (!path)
+		return NULL;
+	INIT_LIST_HEAD(&path->p_head);
+	return path;
+}
+
+/* Empty out a pathname. */
+void
+path_list_free(
+	struct path_list	*path)
+{
+	struct path_component	*pos;
+	struct path_component	*n;
+
+	list_for_each_entry_safe(pos, n, &path->p_head, pc_list) {
+		path_list_del_component(path, pos);
+		path_component_free(pos);
+	}
+	free(path);
+}
+
+/* Add a parent component to a pathname. */
+void
+path_list_add_parent_component(
+	struct path_list	*path,
+	struct path_component	*pc)
+{
+	list_add(&pc->pc_list, &path->p_head);
+}
+
+/* Add a component to a pathname. */
+void
+path_list_add_component(
+	struct path_list	*path,
+	struct path_component	*pc)
+{
+	list_add_tail(&pc->pc_list, &path->p_head);
+}
+
+/* Remove a component from a pathname. */
+void
+path_list_del_component(
+	struct path_list	*path,
+	struct path_component	*pc)
+{
+	list_del_init(&pc->pc_list);
+}
+
+/* Convert a pathname into a string. */
+ssize_t
+path_list_to_string(
+	struct path_list	*path,
+	char			*buf,
+	size_t			buflen)
+{
+	struct path_component	*pos;
+	ssize_t			bytes = 0;
+	int			ret;
+
+	list_for_each_entry(pos, &path->p_head, pc_list) {
+		ret = snprintf(buf, buflen, "/%s", pos->pc_fname);
+		if (ret != 1 + strlen(pos->pc_fname))
+			return -1;
+		bytes += ret;
+		buf += ret;
+		buflen -= ret;
+	}
+	return bytes;
+}
diff --git a/libfrog/paths.h b/libfrog/paths.h
index f20a2c3ef582..52538fb5614e 100644
--- a/libfrog/paths.h
+++ b/libfrog/paths.h
@@ -58,4 +58,23 @@ typedef struct fs_cursor {
 extern void fs_cursor_initialise(char *__dir, uint __flags, fs_cursor_t *__cp);
 extern fs_path_t *fs_cursor_next_entry(fs_cursor_t *__cp);
 
-#endif	/* __LIBFROG_PATH_H__ */
+/* Path information. */
+
+struct path_list;
+struct path_component;
+
+struct path_component *path_component_init(const char *name);
+void path_component_free(struct path_component *pc);
+int path_component_change(struct path_component *pc, void *name,
+		size_t namelen);
+
+struct path_list *path_list_init(void);
+void path_list_free(struct path_list *path);
+void path_list_add_parent_component(struct path_list *path,
+		struct path_component *pc);
+void path_list_add_component(struct path_list *path, struct path_component *pc);
+void path_list_del_component(struct path_list *path, struct path_component *pc);
+
+ssize_t path_list_to_string(struct path_list *path, char *buf, size_t buflen);
+
+#endif	/* __PATH_H__ */
diff --git a/libhandle/Makefile b/libhandle/Makefile
index f297a59e47f9..cf7df67c8f39 100644
--- a/libhandle/Makefile
+++ b/libhandle/Makefile
@@ -12,7 +12,7 @@ LT_AGE = 0
 
 LTLDFLAGS += -Wl,--version-script,libhandle.sym
 
-CFILES = handle.c jdm.c
+CFILES = handle.c jdm.c parent.c
 LSRCFILES = libhandle.sym
 
 default: ltdepend $(LTLIBRARY)
diff --git a/libhandle/handle.c b/libhandle/handle.c
index 333c21909007..1e8fe9ac5f10 100644
--- a/libhandle/handle.c
+++ b/libhandle/handle.c
@@ -29,7 +29,6 @@ typedef union {
 } comarg_t;
 
 static int obj_to_handle(char *, int, unsigned int, comarg_t, void**, size_t*);
-static int handle_to_fsfd(void *, char **);
 static char *path_to_fspath(char *path);
 
 
@@ -203,8 +202,10 @@ handle_to_fshandle(
 	return 0;
 }
 
-static int
-handle_to_fsfd(void *hanp, char **path)
+int
+handle_to_fsfd(
+	void		*hanp,
+	char		**path)
 {
 	struct fdhash	*fdhp;
 
diff --git a/libhandle/parent.c b/libhandle/parent.c
new file mode 100644
index 000000000000..ebd0abd55927
--- /dev/null
+++ b/libhandle/parent.c
@@ -0,0 +1,328 @@
+/*
+ * Copyright (C) 2017 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+#include "platform_defs.h"
+#include "xfs.h"
+#include "xfs_arch.h"
+#include "list.h"
+#include "libfrog/paths.h"
+#include "handle.h"
+#include "parent.h"
+
+/* Allocate a buffer large enough for some parent pointer records. */
+static inline struct xfs_pptr_info *
+xfs_pptr_alloc(
+      size_t                  nr_ptrs)
+{
+      struct xfs_pptr_info    *pi;
+
+      pi = malloc(xfs_pptr_info_sizeof(nr_ptrs));
+      if (!pi)
+              return NULL;
+      memset(pi, 0, sizeof(struct xfs_pptr_info));
+      pi->pi_ptrs_size = nr_ptrs;
+      return pi;
+}
+
+/* Walk all parents of the given file handle. */
+static int
+handle_walk_parents(
+	int			fd,
+	struct xfs_handle	*handle,
+	walk_pptr_fn		fn,
+	void			*arg)
+{
+	struct xfs_pptr_info	*pi;
+	struct xfs_parent_ptr	*p;
+	unsigned int		i;
+	ssize_t			ret = -1;
+
+	pi = xfs_pptr_alloc(4);
+	if (!pi)
+		return -1;
+
+	if (handle) {
+		memcpy(&pi->pi_handle, handle, sizeof(struct xfs_handle));
+		pi->pi_flags = XFS_PPTR_IFLAG_HANDLE;
+	}
+
+	ret = ioctl(fd, XFS_IOC_GETPARENTS, pi);
+	while (!ret) {
+		if (pi->pi_flags & XFS_PPTR_OFLAG_ROOT) {
+			ret = fn(pi, NULL, arg);
+			break;
+		}
+
+		for (i = 0; i < pi->pi_ptrs_used; i++) {
+			p = xfs_ppinfo_to_pp(pi, i);
+			ret = fn(pi, p, arg);
+			if (ret)
+				goto out_pi;
+		}
+
+		if (pi->pi_flags & XFS_PPTR_OFLAG_DONE)
+			break;
+
+		ret = ioctl(fd, XFS_IOC_GETPARENTS, pi);
+	}
+
+out_pi:
+	free(pi);
+	return ret;
+}
+
+/* Walk all parent pointers of this handle. */
+int
+handle_walk_pptrs(
+	void			*hanp,
+	size_t			hlen,
+	walk_pptr_fn		fn,
+	void			*arg)
+{
+	char			*mntpt;
+	int			fd;
+
+	if (hlen != sizeof(struct xfs_handle)) {
+		errno = EINVAL;
+		return -1;
+	}
+
+	fd = handle_to_fsfd(hanp, &mntpt);
+	if (fd < 0)
+		return -1;
+
+	return handle_walk_parents(fd, hanp, fn, arg);
+}
+
+/* Walk all parent pointers of this fd. */
+int
+fd_walk_pptrs(
+	int			fd,
+	walk_pptr_fn		fn,
+	void			*arg)
+{
+	return handle_walk_parents(fd, NULL, fn, arg);
+}
+
+struct walk_ppaths_info {
+	walk_ppath_fn			fn;
+	void				*arg;
+	char				*mntpt;
+	struct path_list		*path;
+	int				fd;
+};
+
+struct walk_ppath_level_info {
+	struct xfs_handle		newhandle;
+	struct path_component		*pc;
+	struct walk_ppaths_info		*wpi;
+};
+
+static int handle_walk_parent_paths(struct walk_ppaths_info *wpi,
+		struct xfs_handle *handle);
+
+static int
+handle_walk_parent_path_ptr(
+	struct xfs_pptr_info		*pi,
+	struct xfs_parent_ptr		*p,
+	void				*arg)
+{
+	struct walk_ppath_level_info	*wpli = arg;
+	struct walk_ppaths_info		*wpi = wpli->wpi;
+	unsigned int			i;
+	int				ret = 0;
+
+	if (pi->pi_flags & XFS_PPTR_OFLAG_ROOT)
+		return wpi->fn(wpi->mntpt, wpi->path, wpi->arg);
+
+	for (i = 0; i < pi->pi_ptrs_used; i++) {
+		p = xfs_ppinfo_to_pp(pi, i);
+		ret = path_component_change(wpli->pc, p->xpp_name,
+				strlen((char *)p->xpp_name));
+		if (ret)
+			break;
+		wpli->newhandle.ha_fid.fid_ino = p->xpp_ino;
+		wpli->newhandle.ha_fid.fid_gen = p->xpp_gen;
+		path_list_add_parent_component(wpi->path, wpli->pc);
+		ret = handle_walk_parent_paths(wpi, &wpli->newhandle);
+		path_list_del_component(wpi->path, wpli->pc);
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
+
+/*
+ * Recursively walk all parents of the given file handle; if we hit the
+ * fs root then we call the associated function with the constructed path.
+ */
+static int
+handle_walk_parent_paths(
+	struct walk_ppaths_info		*wpi,
+	struct xfs_handle		*handle)
+{
+	struct walk_ppath_level_info	*wpli;
+	int				ret;
+
+	wpli = malloc(sizeof(struct walk_ppath_level_info));
+	if (!wpli)
+		return -1;
+	wpli->pc = path_component_init("");
+	if (!wpli->pc) {
+		free(wpli);
+		return -1;
+	}
+	wpli->wpi = wpi;
+	memcpy(&wpli->newhandle, handle, sizeof(struct xfs_handle));
+
+	ret = handle_walk_parents(wpi->fd, handle, handle_walk_parent_path_ptr,
+			wpli);
+
+	path_component_free(wpli->pc);
+	free(wpli);
+	return ret;
+}
+
+/*
+ * Call the given function on all known paths from the vfs root to the inode
+ * described in the handle.
+ */
+int
+handle_walk_ppaths(
+	void			*hanp,
+	size_t			hlen,
+	walk_ppath_fn		fn,
+	void			*arg)
+{
+	struct walk_ppaths_info	wpi;
+	ssize_t			ret;
+
+	if (hlen != sizeof(struct xfs_handle)) {
+		errno = EINVAL;
+		return -1;
+	}
+
+	wpi.fd = handle_to_fsfd(hanp, &wpi.mntpt);
+	if (wpi.fd < 0)
+		return -1;
+	wpi.path = path_list_init();
+	if (!wpi.path)
+		return -1;
+	wpi.fn = fn;
+	wpi.arg = arg;
+
+	ret = handle_walk_parent_paths(&wpi, hanp);
+	path_list_free(wpi.path);
+
+	return ret;
+}
+
+/*
+ * Call the given function on all known paths from the vfs root to the inode
+ * referred to by the file description.
+ */
+int
+fd_walk_ppaths(
+	int			fd,
+	walk_ppath_fn		fn,
+	void			*arg)
+{
+	struct walk_ppaths_info	wpi;
+	void			*hanp;
+	size_t			hlen;
+	int			fsfd;
+	int			ret;
+
+	ret = fd_to_handle(fd, &hanp, &hlen);
+	if (ret)
+		return ret;
+
+	fsfd = handle_to_fsfd(hanp, &wpi.mntpt);
+	if (fsfd < 0)
+		return -1;
+	wpi.fd = fd;
+	wpi.path = path_list_init();
+	if (!wpi.path)
+		return -1;
+	wpi.fn = fn;
+	wpi.arg = arg;
+
+	ret = handle_walk_parent_paths(&wpi, hanp);
+	path_list_free(wpi.path);
+
+	return ret;
+}
+
+struct path_walk_info {
+	char			*buf;
+	size_t			len;
+};
+
+/* Helper that stringifies the first full path that we find. */
+static int
+handle_to_path_walk(
+	const char		*mntpt,
+	struct path_list	*path,
+	void			*arg)
+{
+	struct path_walk_info	*pwi = arg;
+	int			ret;
+
+	ret = snprintf(pwi->buf, pwi->len, "%s", mntpt);
+	if (ret != strlen(mntpt)) {
+		errno = ENOMEM;
+		return -1;
+	}
+
+	ret = path_list_to_string(path, pwi->buf + ret, pwi->len - ret);
+	if (ret < 0)
+		return ret;
+
+	return WALK_PPATHS_ABORT;
+}
+
+/* Return any eligible path to this file handle. */
+int
+handle_to_path(
+	void			*hanp,
+	size_t			hlen,
+	char			*path,
+	size_t			pathlen)
+{
+	struct path_walk_info	pwi;
+
+	pwi.buf = path;
+	pwi.len = pathlen;
+	return handle_walk_ppaths(hanp, hlen, handle_to_path_walk, &pwi);
+}
+
+/* Return any eligible path to this file description. */
+int
+fd_to_path(
+	int			fd,
+	char			*path,
+	size_t			pathlen)
+{
+	struct path_walk_info	pwi;
+
+	pwi.buf = path;
+	pwi.len = pathlen;
+	return fd_walk_ppaths(fd, handle_to_path_walk, &pwi);
+}
diff --git a/scrub/inodes.c b/scrub/inodes.c
index ffe7eb334410..ac2bc3aa019b 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -19,6 +19,7 @@
 #include "descr.h"
 #include "libfrog/fsgeom.h"
 #include "libfrog/bulkstat.h"
+#include "parent.h"
 
 /*
  * Iterate a range of inodes.
@@ -449,3 +450,28 @@ scrub_open_handle(
 	return open_by_fshandle(handle, sizeof(*handle),
 			O_RDONLY | O_NOATIME | O_NOFOLLOW | O_NOCTTY);
 }
+
+/* Construct a description for an inode. */
+void
+xfs_scrub_ino_descr(
+	struct scrub_ctx	*ctx,
+	struct xfs_handle	*handle,
+	char			*buf,
+	size_t			buflen)
+{
+	uint64_t		ino;
+	xfs_agnumber_t		agno;
+	xfs_agino_t		agino;
+	int			ret;
+
+	ret = handle_to_path(handle, sizeof(struct xfs_handle), buf, buflen);
+	if (ret >= 0)
+		return;
+
+	ino = handle->ha_fid.fid_ino;
+	agno = ino / (1ULL << (ctx->mnt.inopblog + ctx->mnt.agblklog));
+	agino = ino % (1ULL << (ctx->mnt.inopblog + ctx->mnt.agblklog));
+	snprintf(buf, buflen, _("inode %"PRIu64" (%u/%u)"), ino, agno,
+			agino);
+}
+
diff --git a/scrub/inodes.h b/scrub/inodes.h
index f03180458ab9..189fa282d4c3 100644
--- a/scrub/inodes.h
+++ b/scrub/inodes.h
@@ -21,5 +21,7 @@ int scrub_scan_all_inodes(struct scrub_ctx *ctx, scrub_inode_iter_fn fn,
 		void *arg);
 
 int scrub_open_handle(struct xfs_handle *handle);
+void xfs_scrub_ino_descr(struct scrub_ctx *ctx, struct xfs_handle *handle,
+		char *buf, size_t buflen);
 
 #endif /* XFS_SCRUB_INODES_H_ */
-- 
2.25.1

