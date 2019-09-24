Return-Path: <SRS0=ckLY=XT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFEF6C432C2
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Sep 2019 13:22:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91AF02064A
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Sep 2019 13:22:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729851AbfIXNWN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Sep 2019 09:22:13 -0400
Received: from icp-osb-irony-out7.external.iinet.net.au ([203.59.1.107]:5799
        "EHLO icp-osb-irony-out7.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727930AbfIXNWN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Sep 2019 09:22:13 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2AVAABDF4pd/9+j0HYNWBwBAQEEAQE?=
 =?us-ascii?q?MBAEBgVMHAQELAYQ5hCKIHIc9AQEBAQEBBoERihqFH4oOgXsJAQEBAQEBAQE?=
 =?us-ascii?q?BNwEBhDoDAgKDRDQJDgIMAQEBBAEBAQEBBQMBhViGGQIBAyNWEBgNAiYCAkc?=
 =?us-ascii?q?QBhOFGa0bc4EyGoo0gQwoAYFiij54gQeBRIMdh0+CWASPVoYsQodfjmmCLJU?=
 =?us-ascii?q?lDI4HA4sPqSmCEE0uCoMnUJBEZo0lAQE?=
X-IPAS-Result: =?us-ascii?q?A2AVAABDF4pd/9+j0HYNWBwBAQEEAQEMBAEBgVMHAQELA?=
 =?us-ascii?q?YQ5hCKIHIc9AQEBAQEBBoERihqFH4oOgXsJAQEBAQEBAQEBNwEBhDoDAgKDR?=
 =?us-ascii?q?DQJDgIMAQEBBAEBAQEBBQMBhViGGQIBAyNWEBgNAiYCAkcQBhOFGa0bc4EyG?=
 =?us-ascii?q?oo0gQwoAYFiij54gQeBRIMdh0+CWASPVoYsQodfjmmCLJUlDI4HA4sPqSmCE?=
 =?us-ascii?q?E0uCoMnUJBEZo0lAQE?=
X-IronPort-AV: E=Sophos;i="5.64,544,1559491200"; 
   d="scan'208";a="205615132"
Received: from unknown (HELO [192.168.1.222]) ([118.208.163.223])
  by icp-osb-irony-out7.iinet.net.au with ESMTP; 24 Sep 2019 21:22:10 +0800
Subject: [REPOST PATCH v3 02/16] xfs: remove very old mount option
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Date:   Tue, 24 Sep 2019 21:22:10 +0800
Message-ID: <156933133068.20933.15706259182756410145.stgit@fedora-28>
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

It appears the biosize mount option hasn't been documented as
a vilid option since 2005.

So remove it.

Signed-off-by: Ian Kent <raven@themaw.net>
---
 fs/xfs/xfs_super.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index f9450235533c..1010097354a6 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -51,7 +51,7 @@ static struct xfs_kobj xfs_dbg_kobj;	/* global debug sysfs attrs */
  * Table driven mount option parser.
  */
 enum {
-	Opt_logbufs, Opt_logbsize, Opt_logdev, Opt_rtdev, Opt_biosize,
+	Opt_logbufs, Opt_logbsize, Opt_logdev, Opt_rtdev,
 	Opt_wsync, Opt_noalign, Opt_swalloc, Opt_sunit, Opt_swidth, Opt_nouuid,
 	Opt_grpid, Opt_nogrpid, Opt_bsdgroups, Opt_sysvgroups,
 	Opt_allocsize, Opt_norecovery, Opt_inode64, Opt_inode32, Opt_ikeep,
@@ -67,7 +67,6 @@ static const match_table_t tokens = {
 	{Opt_logbsize,	"logbsize=%s"},	/* size of XFS log buffers */
 	{Opt_logdev,	"logdev=%s"},	/* log device */
 	{Opt_rtdev,	"rtdev=%s"},	/* realtime I/O device */
-	{Opt_biosize,	"biosize=%u"},	/* log2 of preferred buffered io size */
 	{Opt_wsync,	"wsync"},	/* safe-mode nfs compatible mount */
 	{Opt_noalign,	"noalign"},	/* turn off stripe alignment */
 	{Opt_swalloc,	"swalloc"},	/* turn on stripe width allocation */
@@ -229,7 +228,6 @@ xfs_parseargs(
 				return -ENOMEM;
 			break;
 		case Opt_allocsize:
-		case Opt_biosize:
 			if (suffix_kstrtoint(args, 10, &iosize))
 				return -EINVAL;
 			iosizelog = ffs(iosize) - 1;

