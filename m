Return-Path: <SRS0=pjFm=YJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18419ECE59D
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 00:41:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE9302067B
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 00:41:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388303AbfJPAlX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Oct 2019 20:41:23 -0400
Received: from icp-osb-irony-out1.external.iinet.net.au ([203.59.1.210]:40358
        "EHLO icp-osb-irony-out1.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726872AbfJPAlX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Oct 2019 20:41:23 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2DlAQDRZqZd/0e30XYNWRwBAQEBAQc?=
 =?us-ascii?q?BAREBBAQBAYF7hDyEJY8zAQEBAQEBBoERih2FIAGMDgkBAQEBAQEBAQE3AQG?=
 =?us-ascii?q?EOwMCAoMSOBMCDAEBAQQBAQEBAQUDAYVYhhoCAQMjVhAYDQImAgJHEAYThXW?=
 =?us-ascii?q?uB3WBMhqKKYEMKIFlikF4gQeBRIMdh1KCXgSPNjeGPkOHZ452giyVNgyOFgO?=
 =?us-ascii?q?LHal9gXpNLgqDJ1CQRmeRUQEB?=
X-IPAS-Result: =?us-ascii?q?A2DlAQDRZqZd/0e30XYNWRwBAQEBAQcBAREBBAQBAYF7h?=
 =?us-ascii?q?DyEJY8zAQEBAQEBBoERih2FIAGMDgkBAQEBAQEBAQE3AQGEOwMCAoMSOBMCD?=
 =?us-ascii?q?AEBAQQBAQEBAQUDAYVYhhoCAQMjVhAYDQImAgJHEAYThXWuB3WBMhqKKYEMK?=
 =?us-ascii?q?IFlikF4gQeBRIMdh1KCXgSPNjeGPkOHZ452giyVNgyOFgOLHal9gXpNLgqDJ?=
 =?us-ascii?q?1CQRmeRUQEB?=
X-IronPort-AV: E=Sophos;i="5.67,301,1566835200"; 
   d="scan'208";a="247444102"
Received: from unknown (HELO [192.168.1.222]) ([118.209.183.71])
  by icp-osb-irony-out1.iinet.net.au with ESMTP; 16 Oct 2019 08:40:52 +0800
Subject: [PATCH v6 02/12] xfs: remove very old mount option
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Wed, 16 Oct 2019 08:40:52 +0800
Message-ID: <157118645272.9678.5887961059070306546.stgit@fedora-28>
In-Reply-To: <157118625324.9678.16275725173770634823.stgit@fedora-28>
References: <157118625324.9678.16275725173770634823.stgit@fedora-28>
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
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_super.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 8d1df9f8be07..1bb7ede5d75b 100644
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

