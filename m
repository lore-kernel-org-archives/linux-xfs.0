Return-Path: <SRS0=ckLY=XT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20945C432C1
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Sep 2019 13:23:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00B082064A
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Sep 2019 13:23:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2632732AbfIXNX2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Sep 2019 09:23:28 -0400
Received: from icp-osb-irony-out7.external.iinet.net.au ([203.59.1.107]:5979
        "EHLO icp-osb-irony-out7.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2632730AbfIXNX2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Sep 2019 09:23:28 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2AVAAA1GIpd/9+j0HYNWBwBAQEEAQE?=
 =?us-ascii?q?MBAEBgVMHAQELAYQ5hCKIHIc9AQEBAQEBBoERihqFH4oOFIFnCQEBAQEBAQE?=
 =?us-ascii?q?BATcBAYQ6AwICg0Q0CQ4CDAEBAQQBAQEBAQUDAYVYhhkCAQMjVhAYDQImAgJ?=
 =?us-ascii?q?HEAYThRmtE3OBMhqKNIEMKAGBYoo+eIEHgREzgx2EHQELA4MjglgEjHGCZYY?=
 =?us-ascii?q?sQpZIgiyVJQyOBwOLD4QzpHaCEE0uCoMnUIF+F44vZopRAYJTAQE?=
X-IPAS-Result: =?us-ascii?q?A2AVAAA1GIpd/9+j0HYNWBwBAQEEAQEMBAEBgVMHAQELA?=
 =?us-ascii?q?YQ5hCKIHIc9AQEBAQEBBoERihqFH4oOFIFnCQEBAQEBAQEBATcBAYQ6AwICg?=
 =?us-ascii?q?0Q0CQ4CDAEBAQQBAQEBAQUDAYVYhhkCAQMjVhAYDQImAgJHEAYThRmtE3OBM?=
 =?us-ascii?q?hqKNIEMKAGBYoo+eIEHgREzgx2EHQELA4MjglgEjHGCZYYsQpZIgiyVJQyOB?=
 =?us-ascii?q?wOLD4QzpHaCEE0uCoMnUIF+F44vZopRAYJTAQE?=
X-IronPort-AV: E=Sophos;i="5.64,544,1559491200"; 
   d="scan'208";a="205615243"
Received: from unknown (HELO [192.168.1.222]) ([118.208.163.223])
  by icp-osb-irony-out7.iinet.net.au with ESMTP; 24 Sep 2019 21:23:25 +0800
Subject: [REPOST PATCH v3 16/16] xfs: mount-api - remove legacy mount
 functions
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Date:   Tue, 24 Sep 2019 21:23:25 +0800
Message-ID: <156933140555.20933.7807966711564994383.stgit@fedora-28>
In-Reply-To: <156933112949.20933.12761540130806431294.stgit@fedora-28>
References: <156933112949.20933.12761540130806431294.stgit@fedora-28>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Now that the new mount api is being used the old mount functions
and parsing table can be removed.

Signed-off-by: Ian Kent <raven@themaw.net>
---
 fs/xfs/xfs_super.c |   48 +-----------------------------------------------
 1 file changed, 1 insertion(+), 47 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 3d41bb141cab..7820093bfca8 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -61,53 +61,7 @@ enum {
 	Opt_filestreams, Opt_quota, Opt_noquota, Opt_usrquota, Opt_grpquota,
 	Opt_prjquota, Opt_uquota, Opt_gquota, Opt_pquota,
 	Opt_uqnoenforce, Opt_gqnoenforce, Opt_pqnoenforce, Opt_qnoenforce,
-	Opt_discard, Opt_nodiscard, Opt_dax, Opt_err,
-};
-
-static const match_table_t tokens = {
-	{Opt_logbufs,	"logbufs=%u"},	/* number of XFS log buffers */
-	{Opt_logbsize,	"logbsize=%s"},	/* size of XFS log buffers */
-	{Opt_logdev,	"logdev=%s"},	/* log device */
-	{Opt_rtdev,	"rtdev=%s"},	/* realtime I/O device */
-	{Opt_wsync,	"wsync"},	/* safe-mode nfs compatible mount */
-	{Opt_noalign,	"noalign"},	/* turn off stripe alignment */
-	{Opt_swalloc,	"swalloc"},	/* turn on stripe width allocation */
-	{Opt_sunit,	"sunit=%u"},	/* data volume stripe unit */
-	{Opt_swidth,	"swidth=%u"},	/* data volume stripe width */
-	{Opt_nouuid,	"nouuid"},	/* ignore filesystem UUID */
-	{Opt_grpid,	"grpid"},	/* group-ID from parent directory */
-	{Opt_nogrpid,	"nogrpid"},	/* group-ID from current process */
-	{Opt_bsdgroups,	"bsdgroups"},	/* group-ID from parent directory */
-	{Opt_sysvgroups,"sysvgroups"},	/* group-ID from current process */
-	{Opt_allocsize,	"allocsize=%s"},/* preferred allocation size */
-	{Opt_norecovery,"norecovery"},	/* don't run XFS recovery */
-	{Opt_inode64,	"inode64"},	/* inodes can be allocated anywhere */
-	{Opt_inode32,   "inode32"},	/* inode allocation limited to
-					 * XFS_MAXINUMBER_32 */
-	{Opt_ikeep,	"ikeep"},	/* do not free empty inode clusters */
-	{Opt_noikeep,	"noikeep"},	/* free empty inode clusters */
-	{Opt_largeio,	"largeio"},	/* report large I/O sizes in stat() */
-	{Opt_nolargeio,	"nolargeio"},	/* do not report large I/O sizes
-					 * in stat(). */
-	{Opt_attr2,	"attr2"},	/* do use attr2 attribute format */
-	{Opt_noattr2,	"noattr2"},	/* do not use attr2 attribute format */
-	{Opt_filestreams,"filestreams"},/* use filestreams allocator */
-	{Opt_quota,	"quota"},	/* disk quotas (user) */
-	{Opt_noquota,	"noquota"},	/* no quotas */
-	{Opt_usrquota,	"usrquota"},	/* user quota enabled */
-	{Opt_grpquota,	"grpquota"},	/* group quota enabled */
-	{Opt_prjquota,	"prjquota"},	/* project quota enabled */
-	{Opt_uquota,	"uquota"},	/* user quota (IRIX variant) */
-	{Opt_gquota,	"gquota"},	/* group quota (IRIX variant) */
-	{Opt_pquota,	"pquota"},	/* project quota (IRIX variant) */
-	{Opt_uqnoenforce,"uqnoenforce"},/* user quota limit enforcement */
-	{Opt_gqnoenforce,"gqnoenforce"},/* group quota limit enforcement */
-	{Opt_pqnoenforce,"pqnoenforce"},/* project quota limit enforcement */
-	{Opt_qnoenforce, "qnoenforce"},	/* same as uqnoenforce */
-	{Opt_discard,	"discard"},	/* Discard unused blocks */
-	{Opt_nodiscard,	"nodiscard"},	/* Do not discard unused blocks */
-	{Opt_dax,	"dax"},		/* Enable direct access to bdev pages */
-	{Opt_err,	NULL},
+	Opt_discard, Opt_nodiscard, Opt_dax,
 };
 
 static const struct fs_parameter_spec xfs_param_specs[] = {

