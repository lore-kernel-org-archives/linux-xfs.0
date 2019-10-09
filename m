Return-Path: <SRS0=7gTY=YC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 531B6ECE58D
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 11:31:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37ECC20B7C
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 11:31:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729686AbfJILbE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Oct 2019 07:31:04 -0400
Received: from icp-osb-irony-out3.external.iinet.net.au ([203.59.1.153]:33489
        "EHLO icp-osb-irony-out3.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729566AbfJILbE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 07:31:04 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2AbAABxxJ1d/0e30XYNWRwBAQEBAQc?=
 =?us-ascii?q?BAREBBAQBAYFoBgEBCwGBboJLhCOPKAEBAQMGgRGKHYUfihSBewkBAQEBAQE?=
 =?us-ascii?q?BAQE3AQGEOwMCAoJyNQgOAgwBAQEEAQEBAQEFAwGFWIYaAgEDI1YQGA0CJgI?=
 =?us-ascii?q?CRxAGE4UZr291gTIaiiyBDCgBgWSKQXiBB4ERM4MdhB0BC4MpglgEjzQ3hVt?=
 =?us-ascii?q?hQ5ZZgiyVNAyOFQOLHIQ3pSgCgg1NLgqDJ1CBfxeOMGeOQAGCUwEB?=
X-IPAS-Result: =?us-ascii?q?A2AbAABxxJ1d/0e30XYNWRwBAQEBAQcBAREBBAQBAYFoB?=
 =?us-ascii?q?gEBCwGBboJLhCOPKAEBAQMGgRGKHYUfihSBewkBAQEBAQEBAQE3AQGEOwMCA?=
 =?us-ascii?q?oJyNQgOAgwBAQEEAQEBAQEFAwGFWIYaAgEDI1YQGA0CJgICRxAGE4UZr291g?=
 =?us-ascii?q?TIaiiyBDCgBgWSKQXiBB4ERM4MdhB0BC4MpglgEjzQ3hVthQ5ZZgiyVNAyOF?=
 =?us-ascii?q?QOLHIQ3pSgCgg1NLgqDJ1CBfxeOMGeOQAGCUwEB?=
X-IronPort-AV: E=Sophos;i="5.67,273,1566835200"; 
   d="scan'208";a="216229006"
Received: from unknown (HELO [192.168.1.222]) ([118.209.183.71])
  by icp-osb-irony-out3.iinet.net.au with ESMTP; 09 Oct 2019 19:30:31 +0800
Subject: [PATCH v5 04/17] xfs: mount-api - add fs parameter description
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Wed, 09 Oct 2019 19:30:31 +0800
Message-ID: <157062063161.32346.15357252773768069084.stgit@fedora-28>
In-Reply-To: <157062043952.32346.977737248061083292.stgit@fedora-28>
References: <157062043952.32346.977737248061083292.stgit@fedora-28>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The new mount-api uses an array of struct fs_parameter_spec for
parameter parsing, create this table populated with the xfs mount
parameters.

The new mount-api table definition is wider than the token based
parameter table and interleaving the option description comments
between each table line is much less readable than adding them to
the end of each table entry. So add the option description comment
to each entry line even though it causes quite a few of the entries
to be longer than 80 characters.

Signed-off-by: Ian Kent <raven@themaw.net>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_super.c |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 1010097354a6..9c1ce3d70c08 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -38,6 +38,8 @@
 
 #include <linux/magic.h>
 #include <linux/parser.h>
+#include <linux/fs_context.h>
+#include <linux/fs_parser.h>
 
 static const struct super_operations xfs_super_operations;
 struct bio_set xfs_ioend_bioset;
@@ -108,6 +110,54 @@ static const match_table_t tokens = {
 	{Opt_err,	NULL},
 };
 
+static const struct fs_parameter_spec xfs_param_specs[] = {
+ fsparam_u32	("logbufs",    Opt_logbufs),   /* number of XFS log buffers */
+ fsparam_string ("logbsize",   Opt_logbsize),  /* size of XFS log buffers */
+ fsparam_string ("logdev",     Opt_logdev),    /* log device */
+ fsparam_string ("rtdev",      Opt_rtdev),     /* realtime I/O device */
+ fsparam_flag	("wsync",      Opt_wsync),     /* safe-mode nfs compatible mount */
+ fsparam_flag	("noalign",    Opt_noalign),   /* turn off stripe alignment */
+ fsparam_flag	("swalloc",    Opt_swalloc),   /* turn on stripe width allocation */
+ fsparam_u32	("sunit",      Opt_sunit),     /* data volume stripe unit */
+ fsparam_u32	("swidth",     Opt_swidth),    /* data volume stripe width */
+ fsparam_flag	("nouuid",     Opt_nouuid),    /* ignore filesystem UUID */
+ fsparam_flag   ("grpid",      Opt_grpid),     /* group-ID from parent directory */
+ fsparam_flag   ("nogrpid",    Opt_nogrpid),   /* no group-ID from parent directory */
+ fsparam_flag	("bsdgroups",  Opt_bsdgroups), /* group-ID from parent directory */
+ fsparam_flag	("sysvgroups", Opt_sysvgroups),/* group-ID from current process */
+ fsparam_string ("allocsize",  Opt_allocsize), /* preferred allocation size */
+ fsparam_flag	("norecovery", Opt_norecovery),/* don't run XFS recovery */
+ fsparam_flag	("inode64",    Opt_inode64),   /* inodes can be allocated anywhere */
+ fsparam_flag	("inode32",    Opt_inode32),   /* inode allocation limited to XFS_MAXINUMBER_32 */
+ fsparam_flag   ("ikeep",      Opt_ikeep),     /* do not free empty inode clusters */
+ fsparam_flag   ("noikeep",    Opt_noikeep),   /* free empty inode clusters */
+ fsparam_flag   ("largeio",    Opt_largeio),   /* report large I/O sizes in stat() */
+ fsparam_flag   ("nolargeio",  Opt_nolargeio), /* do not report large I/O sizes in stat() */
+ fsparam_flag   ("attr2",      Opt_attr2),     /* do use attr2 attribute format */
+ fsparam_flag   ("noattr2",    Opt_noattr2),   /* do not use attr2 attribute format */
+ fsparam_flag	("filestreams",Opt_filestreams), /* use filestreams allocator */
+ fsparam_flag   ("quota",      Opt_quota),     /* disk quotas (user) */
+ fsparam_flag   ("noquota",    Opt_noquota),   /* no quotas */
+ fsparam_flag	("usrquota",   Opt_usrquota),  /* user quota enabled */
+ fsparam_flag	("grpquota",   Opt_grpquota),  /* group quota enabled */
+ fsparam_flag	("prjquota",   Opt_prjquota),  /* project quota enabled */
+ fsparam_flag	("uquota",     Opt_uquota),    /* user quota (IRIX variant) */
+ fsparam_flag	("gquota",     Opt_gquota),    /* group quota (IRIX variant) */
+ fsparam_flag	("pquota",     Opt_pquota),    /* project quota (IRIX variant) */
+ fsparam_flag	("uqnoenforce",Opt_uqnoenforce), /* user quota limit enforcement */
+ fsparam_flag	("gqnoenforce",Opt_gqnoenforce), /* group quota limit enforcement */
+ fsparam_flag	("pqnoenforce",Opt_pqnoenforce), /* project quota limit enforcement */
+ fsparam_flag	("qnoenforce", Opt_qnoenforce),  /* same as uqnoenforce */
+ fsparam_flag   ("discard",    Opt_discard),   /* Discard unused blocks */
+ fsparam_flag   ("nodiscard",  Opt_nodiscard), /* Do not discard unused blocks */
+ fsparam_flag	("dax",	       Opt_dax),       /* Enable direct access to bdev pages */
+ {}
+};
+
+static const struct fs_parameter_description xfs_fs_parameters = {
+	.name		= "XFS",
+	.specs		= xfs_param_specs,
+};
 
 STATIC int
 suffix_kstrtoint(const substring_t *s, unsigned int base, int *res)

