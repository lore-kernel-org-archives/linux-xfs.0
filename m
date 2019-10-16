Return-Path: <SRS0=pjFm=YJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34676ECE58F
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 00:41:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 09AF420872
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 00:41:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390298AbfJPAlp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Oct 2019 20:41:45 -0400
Received: from icp-osb-irony-out1.external.iinet.net.au ([203.59.1.210]:40471
        "EHLO icp-osb-irony-out1.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388246AbfJPAlp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Oct 2019 20:41:45 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2DmAQDRZqZd/0e30XYNWRwBAQEBAQc?=
 =?us-ascii?q?BAREBBAQBAYF7gW+CTYQljzMBAQEBAQEGgRGKHYUgAYwOCQEBAQEBAQEBATc?=
 =?us-ascii?q?BAYQ7AwICgxI4EwIMAQEBBAEBAQEBBQMBhViGGgIBAyMEUhAYDQImAgJHEAY?=
 =?us-ascii?q?ThXWuB3V/MxqKKYEMKIFlikF4gQeBETODHYdSgl4EjzY3hj5Dll2CLJU2DI4?=
 =?us-ascii?q?WA4sdLalQgXpNLgqDJ1CBfxeOMGeRUQEB?=
X-IPAS-Result: =?us-ascii?q?A2DmAQDRZqZd/0e30XYNWRwBAQEBAQcBAREBBAQBAYF7g?=
 =?us-ascii?q?W+CTYQljzMBAQEBAQEGgRGKHYUgAYwOCQEBAQEBAQEBATcBAYQ7AwICgxI4E?=
 =?us-ascii?q?wIMAQEBBAEBAQEBBQMBhViGGgIBAyMEUhAYDQImAgJHEAYThXWuB3V/MxqKK?=
 =?us-ascii?q?YEMKIFlikF4gQeBETODHYdSgl4EjzY3hj5Dll2CLJU2DI4WA4sdLalQgXpNL?=
 =?us-ascii?q?gqDJ1CBfxeOMGeRUQEB?=
X-IronPort-AV: E=Sophos;i="5.67,301,1566835200"; 
   d="scan'208";a="247444293"
Received: from unknown (HELO [192.168.1.222]) ([118.209.183.71])
  by icp-osb-irony-out1.iinet.net.au with ESMTP; 16 Oct 2019 08:41:43 +0800
Subject: [PATCH v6 11/12] xfs: dont set sb in xfs_mount_alloc()
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Wed, 16 Oct 2019 08:41:43 +0800
Message-ID: <157118650328.9678.16779922388175839197.stgit@fedora-28>
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

When changing to use the new mount api the super block won't be
available when the xfs_mount info struct is allocated so move
setting the super block in xfs_mount to xfs_fs_fill_super().

Also change xfs_mount_alloc() decalaration static -> STATIC.

Signed-off-by: Ian Kent <raven@themaw.net>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_super.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index f5ea96073d11..13848465303a 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1604,8 +1604,7 @@ xfs_destroy_percpu_counters(
 }
 
 static struct xfs_mount *
-xfs_mount_alloc(
-	struct super_block	*sb)
+xfs_mount_alloc(void)
 {
 	struct xfs_mount	*mp;
 
@@ -1613,7 +1612,6 @@ xfs_mount_alloc(
 	if (!mp)
 		return NULL;
 
-	mp->m_super = sb;
 	spin_lock_init(&mp->m_sb_lock);
 	spin_lock_init(&mp->m_agirotor_lock);
 	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_ATOMIC);
@@ -1649,9 +1647,10 @@ xfs_fs_fill_super(
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

