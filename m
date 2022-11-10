Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D295C43217
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Nov 2022 21:06:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231824AbiKJVGY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Nov 2022 16:06:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231849AbiKJVGV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Nov 2022 16:06:21 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D87F34AF21
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 13:06:20 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAL2xAs003525
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:06:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=9uahsxhrxrZctLjO7i0bKlN8TFtQJxwASfWHnhLF6Cw=;
 b=hzwsTJukRUMfX3vDHp9eRPBM0QIMQHqWbnMMvP5NZFVjxRt1+KnXghQ1Dl0D6MqGhE14
 3kzIAuyUQdEnYeDkFDD7M9G9Vz/FdztdBXZcy+pXy1cyrFG1f3J6tpighWwi0AWV6G5L
 gHGls+0Rce6knbVVEvFoELsuE5O9kZB4B90/qFpBTNULKvlLTfe3yYygYd3xz+lVn1hE
 NPv1K4KuakerScOU94vHJAez48t9HFiNReFOrKvZQJorXDKXqjdVhQuVNy1lBgYgs71x
 yzlyfscfxX7J95wGebxRns38lZrtkWd3CMp7ysBsaMSzYb0emf8VdZNsEV3EccR9xPKj zA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ks8vcg09x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:06:19 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAKatx8009687
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:06:18 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcq5hbp1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:06:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hwHA7zrxke68dtzKumaKxTRizlLqh+6bpV3lbNS5lgbvwtHdbMUC8PbTlxujqSioVr86VXz/M/HajRRBQh66EzKSiX3XFhRJsgtP4Pz9l+h/X90CKiUOxwaWgYnvqQr5Jja4nAUdtdkgBIn+E4GG7Wp0R0Ypi/wnPUoiaKeERFddq5RpyFt5nS0gnFLUidzorWZReRf4P62z1HMtqJJ8ZZwA8xk+kJdnBz5msVcxOeQzBp6easc3UFdutiNj/nPbBtWKt92z8Jo6Ws3gG6L/83L0iAiVL2HRL3Up0nqN8YyfXhhlx3xq8Glt/AoIGWlWlnuAnJMM9XbhxyrLfJl7Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9uahsxhrxrZctLjO7i0bKlN8TFtQJxwASfWHnhLF6Cw=;
 b=JwYd7rxc24IUqkDiakZ0KXRE7oeesVPs94q8mFfIIBG5DEmp52vYA4bCSRVFPAOfAswAum6/vdphrObli19v+IAf5j/2pl3XPS+ZK1E+pn1ohb2zPcewapVKmDrJhvOk3Rub1Ct1JYpO6FKgPkBYkxmEKwWMu/lkQhAYJzqDlp7SaBoC1yEsprS8mhp0Deem6civ2HQrzSyMs0KxmTfy+rfKnVw3jcXdZeY7SFd1N8+37XOmHntUmLCzNCUFj7B+BCkdQmk4vZkQ+IwGyHt10SXkCmbMvzhFMy0pNAZIoYCNUJ8GXydBLA96EQatlqScAq0OMUg3zhVYJ+Eku4D6Zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9uahsxhrxrZctLjO7i0bKlN8TFtQJxwASfWHnhLF6Cw=;
 b=cVvs7RaNhDbtWGHCVdPXu4kBEexHFM/2vKGA5RfmxajW9T3jbKat12EkbykzpLkmzmVOhFYiNL/je6bmgxUdLuejM8Y1MheZ/ImJk1WojePsLs+N4w9voRjn59uZSJMubNmzvoJeqcKMe/ah84IFa6G5AIGFB6HSveN2id+rdb8=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SA1PR10MB6318.namprd10.prod.outlook.com (2603:10b6:806:251::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Thu, 10 Nov
 2022 21:06:16 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5813.013; Thu, 10 Nov 2022
 21:06:16 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 25/25] xfsprogs: Add i, n and f flags to parent command
Date:   Thu, 10 Nov 2022 14:05:27 -0700
Message-Id: <20221110210527.56628-26-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221110210527.56628-1-allison.henderson@oracle.com>
References: <20221110210527.56628-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0253.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::18) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SA1PR10MB6318:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ff06841-f885-4eba-eb51-08dac35f6840
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RMUEbN6e8hdXytt8fAwslQUVZ5eGpfwLvexUtS+5SDsXprfwm0YfpoteP11jncIomtPG6bd6gUO3SvUqcLtp1P6NMcTWi2q414O4dg4efw0HiJgK3FKHJOJeZOmRnB0eAhpGHm4FOFAqRnbv0y69mg8udd9riHPzOkwX8jSVY+em6wgpJ1DRUNr9dEVBx8ETo8eHjjXorA3RdzPyI4Rqls9w5tMm7koYWxBYe3MOIUcmxr+ca1gfOpdlqNb3xlsW02FU8TzgH7Zl0xBbvuSu6F14fFaz9u2igWv+uR6csuIDDmXWB9O6w8epFvvoY9UX1ieW2s9Q0gVZbAn8MANjVa8PqLrf59NCwvMF/gLb9fk41jj+jT0vCYyFT5a0MVgqfnWtDi6NLvRmq3w9pBEEvprcpVkfSybnvx6CEnY7SXvQFeK+bSppMMo240CQNcFt4AhnXZkIZYstF2HZr6z7k+uSh5idOANq0f++ceiJ4+hJ/pua8yhYxAgc1vYqehYaJc2I0tCnukSc8nFhHKUJVdaWeBLE6R5ppAM1bL2pNdyY0wCS6v+EU9DtIMMddxE7ksmQHNBqghK+FiP0S4YhXSnYw9QUZqQF0VQqu/7V8G+9HOjBsUWibRD4GYhEyN3ZjDH6LjygENsoCk0HscHs692e6vgTk0LJLMDcQHMbeGt836lqj8wRD6x6HBPLoy0UdR9dmJRM2T2ssO0uOWsLLw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(39860400002)(376002)(366004)(346002)(451199015)(2906002)(6916009)(36756003)(66476007)(316002)(86362001)(6506007)(478600001)(30864003)(9686003)(6512007)(26005)(8936002)(41300700001)(6486002)(5660300002)(6666004)(38100700002)(66946007)(8676002)(66556008)(83380400001)(1076003)(186003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Q/uVh3FYXqrQi1SKrNHQXRL+1J5Bef3SDqQcbo2yRnVHzWo9RGs2iApd9C4Y?=
 =?us-ascii?Q?T4af/Q0461TnrQk7vsx4aq7Et4Sxj9YhRjl1kNM2kQNsxj7evZ+HUvTSjR9+?=
 =?us-ascii?Q?oDheb+jxJ1CoweLWfGOFgCseL8wLMsgmMxqvx5p12kb1N3hAeY5SDMHbJSdF?=
 =?us-ascii?Q?riCfmq19qmUuyZdOAMrp6dAgn/aizMmWep4fizzhWh1ttC77uTL8JRd8ylWG?=
 =?us-ascii?Q?ZXtZYJgANo54G9UltEWy6DsHR0UuVVJfD+DXDeRz5zexWLBJXHiwMnJleSNP?=
 =?us-ascii?Q?MApOVL9xvvv2RDQLxb/zqP4wLNpCvu6ed+zAsPpYvU7plaxnHDWRehrRVrkM?=
 =?us-ascii?Q?Q6qJbnNbekThyvlb2KCeMD+0eKxUcL1nYwJbjdyh95jHEAIpoinVCIQ0Tikq?=
 =?us-ascii?Q?iOaDfNdoL2eTMCQtR8BHnMQhA4pqXiiW4uuZ3TwZZd8YL3DNL8UILiF8D2nA?=
 =?us-ascii?Q?GRd7/8HtpYQsd2I5D9UjP5xiks19y0ZcSmazEEd7FbGGSMEBVBLmfuy/R1Ji?=
 =?us-ascii?Q?HEvSGjef+p7rYtEo9utv8L35KFnf5aVigR4TiWcxXN/6rP/vYq/pgAgMaXiJ?=
 =?us-ascii?Q?AeVUe3A9ghzTO4Do9pakqnZ3ki/iPnif3dn80DiWPWl2VN2sgW2o0wtP0xIg?=
 =?us-ascii?Q?T2ySg2zDDKB/FXhbNhBYWzV8IdiWytKQAV4eHei+7x4/FZ2e7C7v6Zw5jFW/?=
 =?us-ascii?Q?r60kmqiloTg9ZCRKS6hgZy/S8GNjVU+68Xj8XhosCKbozyWmXKtk0u3X8Qe9?=
 =?us-ascii?Q?9tuIWz6P/LSaCdbbPBUvdFIMEd5o26UJiAqdFzz0nfaFFRGwFf9rqti9FAXK?=
 =?us-ascii?Q?IrjdlH9XAzIQfqk902cKPRUvP86SDNToz6MV+fkVPPzCuVVuATTHSTW+eGc9?=
 =?us-ascii?Q?YsQcatvblD3BUZ4RhS9pActFhj8/VhTwsnuz9PMh52lZJwVWEHIskp9LmHsV?=
 =?us-ascii?Q?dJVHXuIwS3vuYmh0TmNsOTtMudbWa2Ehty8hP4OOeWg+rEsfRnJ8SR3F7sVc?=
 =?us-ascii?Q?o8kmAiXKRMUWxm7qZQ8TnryrGYCJCu/+ZgskWAUR9NsdYphL+DECF+hpc7VN?=
 =?us-ascii?Q?WJ2uDh/rG5sg/Yj2b/f11bcPEYKBcXNnQI/QTj00PR2UkiHnbpT34jzQjCLZ?=
 =?us-ascii?Q?zfRr1f8JJvlx9kwyO8l1ernbRqIjLRr9HL/9m1cqePHrZ6TlEM/B2lxKpAPx?=
 =?us-ascii?Q?xtdV/S02vuOGAIq3QIEMWmlUVDCwGI/prm+pQBEG1/3vk91BFoTObTCGToJq?=
 =?us-ascii?Q?lq1r02ARuCo7NWsB1P2cwZTJAbcjsqtjXgfhfrwjX8molRSxzJqqZcluRYcX?=
 =?us-ascii?Q?lOLO9nP/wOJ/tYXlBnwWtClyYmPMQZOFWJCi1eQFWrwCAWkaF3BRYgsbVMvv?=
 =?us-ascii?Q?NwIZ13+xv0hmjY98bXTFfxO0OrxbTG9tNdZRO3DZ9M/O54HNVmb0BhCJ+6xa?=
 =?us-ascii?Q?rPVF+WoGe41zNCgEbVzY8xfa2VxwyeCZDdEUCaqm60YxJPIJqPjRc7KuR+Ao?=
 =?us-ascii?Q?oy8+xIBVBVd6StL76b6gNDbMIvZxjHBG7uKnqNoZ1BrwqQIUScz1HiOjxWpK?=
 =?us-ascii?Q?6kdeWpCU+fnDUVZVzjsxvZnG/OraRQ7TT0bvLljRHYm21zV3xjD2r6rRSV30?=
 =?us-ascii?Q?Cw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ff06841-f885-4eba-eb51-08dac35f6840
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 21:06:16.5834
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7oyQxnq60MX6OI93+/5Wo3wg1Fgc4c2Kq0DkowsaWvD3pENPSWg2pjwNTrCMjjUejhOhUolkqDGbHWtoNmD9X6gH46aZhNhaZzsweO6vHyg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6318
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_13,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211100148
X-Proofpoint-GUID: Sx0AJuevIGlQlroDPqMVTrHXnNtUCsIG
X-Proofpoint-ORIG-GUID: Sx0AJuevIGlQlroDPqMVTrHXnNtUCsIG
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch adds the flags i, n, and f to the parent command. These flags add
filtering options that are used by the new parent pointer tests in xfstests, and
help to improve the test run time.  The flags are:

-i: Only show parent pointer records containing the given inode
-n: Only show parent pointer records containing the given filename
-f: Print records in short format: ino/gen/namelen/name

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 include/parent.h   | 17 +++++++---
 io/parent.c        | 78 ++++++++++++++++++++++++++++++++++++----------
 libhandle/parent.c | 73 +++++++++++++++++++++++++++++++------------
 3 files changed, 126 insertions(+), 42 deletions(-)

diff --git a/include/parent.h b/include/parent.h
index fb9000419bee..2e136724b831 100644
--- a/include/parent.h
+++ b/include/parent.h
@@ -17,20 +17,27 @@ typedef struct parent_cursor {
 	__u32	opaque[4];      /* an opaque cookie */
 } parent_cursor_t;
 
+/* Print parent pointer option flags */
+#define XFS_PPPTR_OFLAG_SHORT  (1<<0)	/* Print in short format */
+
 struct path_list;
 
 typedef int (*walk_pptr_fn)(struct xfs_pptr_info *pi, struct xfs_parent_ptr *pptr,
-		void *arg);
+		void *arg, int flags);
 typedef int (*walk_ppath_fn)(const char *mntpt, struct path_list *path,
 		void *arg);
 
 #define WALK_PPTRS_ABORT	1
-int fd_walk_pptrs(int fd, walk_pptr_fn fn, void *arg);
-int handle_walk_pptrs(void *hanp, size_t hanlen, walk_pptr_fn fn, void *arg);
+int fd_walk_pptrs(int fd, uint64_t pino, char *pname, walk_pptr_fn fn,
+		void *arg, int flags);
+int handle_walk_pptrs(void *hanp, size_t hanlen, uint64_t pino, char *pname,
+		walk_pptr_fn fn, void *arg, int flags);
 
 #define WALK_PPATHS_ABORT	1
-int fd_walk_ppaths(int fd, walk_ppath_fn fn, void *arg);
-int handle_walk_ppaths(void *hanp, size_t hanlen, walk_ppath_fn fn, void *arg);
+int fd_walk_ppaths(int fd, uint64_t pino, char *pname, walk_ppath_fn fn,
+		void *arg, int flags);
+int handle_walk_ppaths(void *hanp, size_t hanlen, uint64_t pino, char *pname,
+		walk_ppath_fn fn, void *arg, int flags);
 
 int fd_to_path(int fd, char *path, size_t pathlen);
 int handle_to_path(void *hanp, size_t hlen, char *path, size_t pathlen);
diff --git a/io/parent.c b/io/parent.c
index e0ca29eb54c7..4c895bbba16e 100644
--- a/io/parent.c
+++ b/io/parent.c
@@ -19,7 +19,8 @@ static int
 pptr_print(
 	struct xfs_pptr_info	*pi,
 	struct xfs_parent_ptr	*pptr,
-	void			*arg)
+	void			*arg,
+	int			flags)
 {
 	char			buf[XFS_PPTR_MAXNAMELEN + 1];
 	unsigned int		namelen = strlen((char *)pptr->xpp_name);
@@ -31,24 +32,36 @@ pptr_print(
 
 	memcpy(buf, pptr->xpp_name, namelen);
 	buf[namelen] = 0;
-	printf(_("p_ino    = %llu\n"), (unsigned long long)pptr->xpp_ino);
-	printf(_("p_gen    = %u\n"), (unsigned int)pptr->xpp_gen);
-	printf(_("p_reclen = %u\n"), namelen);
-	printf(_("p_name   = \"%s\"\n\n"), buf);
+
+	if (flags & XFS_PPPTR_OFLAG_SHORT) {
+		printf("%llu/%u/%u/%s\n",
+			(unsigned long long)pptr->xpp_ino,
+			(unsigned int)pptr->xpp_gen, namelen, buf);
+	}
+	else {
+		printf(_("p_ino    = %llu\n"), (unsigned long long)pptr->xpp_ino);
+		printf(_("p_gen    = %u\n"), (unsigned int)pptr->xpp_gen);
+		printf(_("p_reclen = %u\n"), namelen);
+		printf(_("p_name   = \"%s\"\n\n"), buf);
+	}
 	return 0;
 }
 
 int
 print_parents(
-	struct xfs_handle	*handle)
+	struct xfs_handle	*handle,
+	uint64_t		pino,
+	char			*pname,
+	int			flags)
 {
 	int			ret;
 
 	if (handle)
-		ret = handle_walk_pptrs(handle, sizeof(*handle), pptr_print,
-				NULL);
+		ret = handle_walk_pptrs(handle, sizeof(*handle), pino,
+				pname, pptr_print, NULL, flags);
 	else
-		ret = fd_walk_pptrs(file->fd, pptr_print, NULL);
+		ret = fd_walk_pptrs(file->fd, pino, pname, pptr_print,
+				NULL, flags);
 	if (ret)
 		perror(file->name);
 
@@ -79,15 +92,19 @@ path_print(
 
 int
 print_paths(
-	struct xfs_handle	*handle)
+	struct xfs_handle	*handle,
+	uint64_t		pino,
+	char			*pname,
+	int			flags)
 {
 	int			ret;
 
 	if (handle)
-		ret = handle_walk_ppaths(handle, sizeof(*handle), path_print,
-				NULL);
+		ret = handle_walk_ppaths(handle, sizeof(*handle), pino,
+				pname, path_print, NULL, flags);
  	else
-		ret = fd_walk_ppaths(file->fd, path_print, NULL);
+		ret = fd_walk_ppaths(file->fd, pino, pname, path_print,
+				NULL, flags);
 	if (ret)
 		perror(file->name);
 	return 0;
@@ -109,6 +126,9 @@ parent_f(
 	int			listpath_flag = 0;
 	int			ret;
 	static int		tab_init;
+	uint64_t		pino = 0;
+	char			*pname = NULL;
+	int			ppptr_flags = 0;
 
 	if (!tab_init) {
 		tab_init = 1;
@@ -123,11 +143,27 @@ parent_f(
 	}
 	mntpt = fs->fs_dir;
 
-	while ((c = getopt(argc, argv, "p")) != EOF) {
+	while ((c = getopt(argc, argv, "pfi:n:")) != EOF) {
 		switch (c) {
 		case 'p':
 			listpath_flag = 1;
 			break;
+		case 'i':
+	                pino = strtoull(optarg, &p, 0);
+	                if (*p != '\0' || pino == 0) {
+	                        fprintf(stderr,
+	                                _("Bad inode number '%s'.\n"),
+	                                optarg);
+	                        return 0;
+			}
+
+			break;
+		case 'n':
+			pname = optarg;
+			break;
+		case 'f':
+			ppptr_flags |= XFS_PPPTR_OFLAG_SHORT;
+			break;
 		default:
 			return command_usage(&parent_cmd);
 		}
@@ -169,9 +205,11 @@ parent_f(
 	}
 
 	if (listpath_flag)
-		exitcode = print_paths(ino ? &handle : NULL);
+		exitcode = print_paths(ino ? &handle : NULL,
+				pino, pname, ppptr_flags);
 	else
-		exitcode = print_parents(ino ? &handle : NULL);
+		exitcode = print_parents(ino ? &handle : NULL,
+				pino, pname, ppptr_flags);
 
 	if (hanp)
 		free_handle(hanp, hlen);
@@ -189,6 +227,12 @@ printf(_(
 " -p -- list the current file's paths up to the root\n"
 "\n"
 "If ino and gen are supplied, use them instead.\n"
+"\n"
+" -i -- Only show parent pointer records containing the given inode\n"
+"\n"
+" -n -- Only show parent pointer records containing the given filename\n"
+"\n"
+" -f -- Print records in short format: ino/gen/namelen/filename\n"
 "\n"));
 }
 
@@ -199,7 +243,7 @@ parent_init(void)
 	parent_cmd.cfunc = parent_f;
 	parent_cmd.argmin = 0;
 	parent_cmd.argmax = -1;
-	parent_cmd.args = _("[-p] [ino gen]");
+	parent_cmd.args = _("[-p] [ino gen] [-i] [ino] [-n] [name] [-f]");
 	parent_cmd.flags = CMD_NOMAP_OK;
 	parent_cmd.oneline = _("print parent inodes");
 	parent_cmd.help = parent_help;
diff --git a/libhandle/parent.c b/libhandle/parent.c
index ebd0abd55927..3de8742ccefd 100644
--- a/libhandle/parent.c
+++ b/libhandle/parent.c
@@ -40,13 +40,21 @@ xfs_pptr_alloc(
       return pi;
 }
 
-/* Walk all parents of the given file handle. */
+/*
+ * Walk all parents of the given file handle.
+ * If pino is set, print only the parent pointer
+ * of that inode.  If pname is set, print only the
+ * parent pointer of that filename
+ */
 static int
 handle_walk_parents(
 	int			fd,
 	struct xfs_handle	*handle,
+	uint64_t		pino,
+	char			*pname,
 	walk_pptr_fn		fn,
-	void			*arg)
+	void			*arg,
+	int			flags)
 {
 	struct xfs_pptr_info	*pi;
 	struct xfs_parent_ptr	*p;
@@ -65,13 +73,20 @@ handle_walk_parents(
 	ret = ioctl(fd, XFS_IOC_GETPARENTS, pi);
 	while (!ret) {
 		if (pi->pi_flags & XFS_PPTR_OFLAG_ROOT) {
-			ret = fn(pi, NULL, arg);
+			ret = fn(pi, NULL, arg, flags);
 			break;
 		}
 
 		for (i = 0; i < pi->pi_ptrs_used; i++) {
 			p = xfs_ppinfo_to_pp(pi, i);
-			ret = fn(pi, p, arg);
+			if ((pino != 0) && (pino != p->xpp_ino))
+				continue;
+
+			if ((pname  != NULL) && (strcmp(pname,
+					(char *)p->xpp_name) != 0))
+				continue;
+
+			ret = fn(pi, p, arg, flags);
 			if (ret)
 				goto out_pi;
 		}
@@ -92,8 +107,11 @@ int
 handle_walk_pptrs(
 	void			*hanp,
 	size_t			hlen,
+	uint64_t		pino,
+	char			*pname,
 	walk_pptr_fn		fn,
-	void			*arg)
+	void			*arg,
+	int			flags)
 {
 	char			*mntpt;
 	int			fd;
@@ -107,17 +125,20 @@ handle_walk_pptrs(
 	if (fd < 0)
 		return -1;
 
-	return handle_walk_parents(fd, hanp, fn, arg);
+	return handle_walk_parents(fd, hanp, pino, pname, fn, arg, flags);
 }
 
 /* Walk all parent pointers of this fd. */
 int
 fd_walk_pptrs(
 	int			fd,
+	uint64_t		pino,
+	char			*pname,
 	walk_pptr_fn		fn,
-	void			*arg)
+	void			*arg,
+	int			flags)
 {
-	return handle_walk_parents(fd, NULL, fn, arg);
+	return handle_walk_parents(fd, NULL, pino, pname, fn, arg, flags);
 }
 
 struct walk_ppaths_info {
@@ -135,13 +156,15 @@ struct walk_ppath_level_info {
 };
 
 static int handle_walk_parent_paths(struct walk_ppaths_info *wpi,
-		struct xfs_handle *handle);
+		struct xfs_handle *handle, uint64_t pino, char *pname,
+		int flags);
 
 static int
 handle_walk_parent_path_ptr(
 	struct xfs_pptr_info		*pi,
 	struct xfs_parent_ptr		*p,
-	void				*arg)
+	void				*arg,
+	int				flags)
 {
 	struct walk_ppath_level_info	*wpli = arg;
 	struct walk_ppaths_info		*wpi = wpli->wpi;
@@ -160,7 +183,7 @@ handle_walk_parent_path_ptr(
 		wpli->newhandle.ha_fid.fid_ino = p->xpp_ino;
 		wpli->newhandle.ha_fid.fid_gen = p->xpp_gen;
 		path_list_add_parent_component(wpi->path, wpli->pc);
-		ret = handle_walk_parent_paths(wpi, &wpli->newhandle);
+		ret = handle_walk_parent_paths(wpi, &wpli->newhandle, 0, NULL, 0);
 		path_list_del_component(wpi->path, wpli->pc);
 		if (ret)
 			break;
@@ -176,7 +199,10 @@ handle_walk_parent_path_ptr(
 static int
 handle_walk_parent_paths(
 	struct walk_ppaths_info		*wpi,
-	struct xfs_handle		*handle)
+	struct xfs_handle		*handle,
+	uint64_t			pino,
+	char				*pname,
+	int				flags)
 {
 	struct walk_ppath_level_info	*wpli;
 	int				ret;
@@ -192,8 +218,8 @@ handle_walk_parent_paths(
 	wpli->wpi = wpi;
 	memcpy(&wpli->newhandle, handle, sizeof(struct xfs_handle));
 
-	ret = handle_walk_parents(wpi->fd, handle, handle_walk_parent_path_ptr,
-			wpli);
+	ret = handle_walk_parents(wpi->fd, handle, pino, pname,
+			handle_walk_parent_path_ptr, wpli, flags);
 
 	path_component_free(wpli->pc);
 	free(wpli);
@@ -208,8 +234,11 @@ int
 handle_walk_ppaths(
 	void			*hanp,
 	size_t			hlen,
+	uint64_t		pino,
+	char			*pname,
 	walk_ppath_fn		fn,
-	void			*arg)
+	void			*arg,
+	int			flags)
 {
 	struct walk_ppaths_info	wpi;
 	ssize_t			ret;
@@ -228,7 +257,7 @@ handle_walk_ppaths(
 	wpi.fn = fn;
 	wpi.arg = arg;
 
-	ret = handle_walk_parent_paths(&wpi, hanp);
+	ret = handle_walk_parent_paths(&wpi, hanp, pino, pname, flags);
 	path_list_free(wpi.path);
 
 	return ret;
@@ -241,8 +270,11 @@ handle_walk_ppaths(
 int
 fd_walk_ppaths(
 	int			fd,
+	uint64_t		pino,
+	char			*pname,
 	walk_ppath_fn		fn,
-	void			*arg)
+	void			*arg,
+	int			flags)
 {
 	struct walk_ppaths_info	wpi;
 	void			*hanp;
@@ -264,7 +296,7 @@ fd_walk_ppaths(
 	wpi.fn = fn;
 	wpi.arg = arg;
 
-	ret = handle_walk_parent_paths(&wpi, hanp);
+	ret = handle_walk_parent_paths(&wpi, hanp, pino, pname, flags);
 	path_list_free(wpi.path);
 
 	return ret;
@@ -310,7 +342,8 @@ handle_to_path(
 
 	pwi.buf = path;
 	pwi.len = pathlen;
-	return handle_walk_ppaths(hanp, hlen, handle_to_path_walk, &pwi);
+	return handle_walk_ppaths(hanp, hlen, 0, NULL, handle_to_path_walk,
+			&pwi, 0);
 }
 
 /* Return any eligible path to this file description. */
@@ -324,5 +357,5 @@ fd_to_path(
 
 	pwi.buf = path;
 	pwi.len = pathlen;
-	return fd_walk_ppaths(fd, handle_to_path_walk, &pwi);
+	return fd_walk_ppaths(fd, 0, NULL, handle_to_path_walk, &pwi, 0);
 }
-- 
2.25.1

