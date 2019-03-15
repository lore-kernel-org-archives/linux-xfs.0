Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53068 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726961AbfCOAZd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Mar 2019 20:25:33 -0400
Subject: [PATCH 09.5/36] xfs_io: document fzero_f -k option in manpage
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
 <155259748531.31886.6568534900832262149.stgit@magnolia>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <9784a4eb-f90c-c57a-34af-0039e24e9e78@redhat.com>
Date: Thu, 14 Mar 2019 19:25:28 -0500
MIME-Version: 1.0
In-Reply-To: <155259748531.31886.6568534900832262149.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

Perhaps the reason -k was broken is that nobody knew it existed?

Fixes: 938904c4 ("xfs_io: add fzero command for zeroing range via fallocate")
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index fbf50df..980dcfd 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -516,10 +516,13 @@ Call fallocate with FALLOC_FL_UNSHARE_RANGE flag as described in the
 .BR fallocate (2)
 manual page to unshare all shared blocks within the range.
 .TP
-.BI fzero " offset length"
+.BI "fzero [ \-k ]" " offset length"
 Call fallocate with FALLOC_FL_ZERO_RANGE flag as described in the
 .BR fallocate (2)
 manual page to allocate and zero blocks within the range.
+With the
+.B -k
+option, use the FALLOC_FL_KEEP_SIZE flag as well.
 .TP
 .BI zero " offset length"
 Call xfsctl with
