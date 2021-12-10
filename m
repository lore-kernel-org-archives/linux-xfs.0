Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1094EC433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Dec 2021 20:21:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344187AbhLJUZa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Dec 2021 15:25:30 -0500
Received: from sandeen.net ([63.231.237.45]:43504 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344161AbhLJUZ3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 10 Dec 2021 15:25:29 -0500
Received: by sandeen.net (Postfix, from userid 500)
        id A1304335031; Fri, 10 Dec 2021 14:21:40 -0600 (CST)
From:   Eric Sandeen <sandeen@sandeen.net>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/4] mkfs.xfs(8): remove incorrect default inode allocator description
Date:   Fri, 10 Dec 2021 14:21:35 -0600
Message-Id: <1639167697-15392-3-git-send-email-sandeen@sandeen.net>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1639167697-15392-1-git-send-email-sandeen@sandeen.net>
References: <1639167697-15392-1-git-send-email-sandeen@sandeen.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

The "maxpct" section of the mkfs.xfs manpage has a gratuitous and
incorrect description of the default inode allocator mode.

inode64 has been the default since 2012, as of

08bf540412ed xfs: make inode64 as the default allocation mode

so the description is wrong. In addition, imaxpct is only
tangentially related to inode allocator behavior, so this section
of the man page is really the wrong place for discussion.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 man/man8/mkfs.xfs.8 | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
index a7f7028..a67532a 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -568,22 +568,15 @@ can be allocated to inodes. The default
 is 25% for filesystems under 1TB, 5% for filesystems under 50TB and 1%
 for filesystems over 50TB.
 .IP
-In the default inode allocation mode, inode blocks are chosen such
-that inode numbers will not exceed 32 bits, which restricts the inode
-blocks to the lower portion of the filesystem. The data block
-allocator will avoid these low blocks to accommodate the specified
-maxpct, so a high value may result in a filesystem with nothing but
-inodes in a significant portion of the lower blocks of the filesystem.
-(This restriction is not present when the filesystem is mounted with
-the
-.I "inode64"
-option on 64-bit platforms).
-.IP
 Setting the value to 0 means that essentially all of the filesystem
-can become inode blocks, subject to inode32 restrictions.
+can become inode blocks (subject to possible
+.B inode32
+mount option restrictions, see
+.BR xfs (5)
+for details.)
 .IP
 This value can be modified with
-.IR xfs_growfs(8) .
+.BR xfs_growfs (8).
 .TP
 .BI align[= value ]
 This is used to specify that inode allocation is or is not aligned. The
-- 
1.8.3.1

