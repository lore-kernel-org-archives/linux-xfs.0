Return-Path: <SRS0=lWMA=WT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83213C3A5A1
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Aug 2019 01:09:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 643B3233A0
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Aug 2019 01:09:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387642AbfHWBJi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Aug 2019 21:09:38 -0400
Received: from icp-osb-irony-out2.external.iinet.net.au ([203.59.1.155]:5692
        "EHLO icp-osb-irony-out2.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387641AbfHWBJh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Aug 2019 21:09:37 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2DWAQAROl9d/3Wz0XYNWBwBAQEEAQE?=
 =?us-ascii?q?HBAEBgWeBaYJKhCCPVgEBBoERihGRIwkBAQEBAQEBAQE3AQGEOgMCAoMCOBM?=
 =?us-ascii?q?CCQEBAQQBAgEBBgMBhViGGQIBAyMEUhAYDQImAgJHEAYThRmrUHN/MxqKQIE?=
 =?us-ascii?q?MKIFjiiR4gQeBETODHYdPglgEjxSGD0KVdwmCH5RYDI1bA4pgLYNzo2GBeU0?=
 =?us-ascii?q?uCoMngk4Xji9ljFYBAQ?=
X-IPAS-Result: =?us-ascii?q?A2DWAQAROl9d/3Wz0XYNWBwBAQEEAQEHBAEBgWeBaYJKh?=
 =?us-ascii?q?CCPVgEBBoERihGRIwkBAQEBAQEBAQE3AQGEOgMCAoMCOBMCCQEBAQQBAgEBB?=
 =?us-ascii?q?gMBhViGGQIBAyMEUhAYDQImAgJHEAYThRmrUHN/MxqKQIEMKIFjiiR4gQeBE?=
 =?us-ascii?q?TODHYdPglgEjxSGD0KVdwmCH5RYDI1bA4pgLYNzo2GBeU0uCoMngk4Xji9lj?=
 =?us-ascii?q?FYBAQ?=
X-IronPort-AV: E=Sophos;i="5.64,419,1559491200"; 
   d="scan'208";a="231796886"
Received: from unknown (HELO [192.168.1.222]) ([118.209.179.117])
  by icp-osb-irony-out2.iinet.net.au with ESMTP; 23 Aug 2019 09:00:27 +0800
Subject: [PATCH v2 13/15] xfs: mount-api - dont set sb in xfs_mount_alloc()
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Dave Chinner <dchinner@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Date:   Fri, 23 Aug 2019 09:00:27 +0800
Message-ID: <156652202737.2607.3093583575197287887.stgit@fedora-28>
In-Reply-To: <156652158924.2607.14608448087216437699.stgit@fedora-28>
References: <156652158924.2607.14608448087216437699.stgit@fedora-28>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

When changing to use the new mount api the super block won't be
available when the xfs_mount info struct is allocated so move
setting the super block in xfs_mount to xfs_fs_fill_super().

Also change xfs_mount_alloc() decalaration static -> STATIC.

Signed-off-by: Ian Kent <raven@themaw.net>
---
 fs/xfs/xfs_super.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 9976163dc537..d2a1a62a3edc 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1766,9 +1766,9 @@ xfs_destroy_percpu_counters(
 	percpu_counter_destroy(&mp->m_delalloc_blks);
 }
 
-static struct xfs_mount *
+STATIC struct xfs_mount *
 xfs_mount_alloc(
-	struct super_block	*sb)
+	void)
 {
 	struct xfs_mount	*mp;
 
@@ -1776,7 +1776,6 @@ xfs_mount_alloc(
 	if (!mp)
 		return NULL;
 
-	mp->m_super = sb;
 	spin_lock_init(&mp->m_sb_lock);
 	spin_lock_init(&mp->m_agirotor_lock);
 	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_ATOMIC);
@@ -1990,9 +1989,10 @@ xfs_fs_fill_super(
 	 * allocate mp and do all low-level struct initializations before we
 	 * attach it to the super
 	 */
-	mp = xfs_mount_alloc(sb);
+	mp = xfs_mount_alloc();
 	if (!mp)
 		goto out;
+	mp->m_super = sb;
 	sb->s_fs_info = mp;
 
 	error = xfs_parseargs(mp, (char *)data);

