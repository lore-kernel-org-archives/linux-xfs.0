Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:51244 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755599AbcLQAWb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 16 Dec 2016 19:22:31 -0500
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 487C892
        for <linux-xfs@vger.kernel.org>; Fri, 16 Dec 2016 18:13:52 -0600 (CST)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH] xfs_quota: handle wrapped id from GETNEXTQUOTA
Message-ID: <ce6f019b-e851-eef0-17aa-b98e3a563de4@sandeen.net>
Date: Fri, 16 Dec 2016 18:13:53 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

The GETNEXTQUOTA interface in the kernel had a bug
(at least in xfs) where if we pass in UINT_MAX as the
ID, it incremented, warpped, and returned 0 for the next
id.  This would cause userspace to start querying
again at zero, and an xfs_quota "report" command would
loop forever.  This occurred if a quota ID near
UINT max existed, and later offsets within the block
wrapped the xfs_dqid_t.

This will also be fixed in the kernel, but we should also
catch this in userspace, and stop the loop if it happens.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/quota/report.c b/quota/report.c
index 604f50d..bcf4a15 100644
--- a/quota/report.c
+++ b/quota/report.c
@@ -101,6 +101,10 @@ dump_file(
 	if (oid)
 		*oid = d.d_id;
 
+	/* Did kernelspace wrap? */
+	if (*oid < id)
+		return 0;
+
 	if (!d.d_blk_softlimit && !d.d_blk_hardlimit &&
 	    !d.d_ino_softlimit && !d.d_ino_hardlimit &&
 	    !d.d_rtb_softlimit && !d.d_rtb_hardlimit)
@@ -360,6 +360,10 @@ report_mount(
 	if (oid)
 		*oid = d.d_id;
 
+	/* Did kernelspace wrap? */
+	if (*oid < id)
+		return 0;
+
 	if (flags & TERSE_FLAG) {
 		count = 0;
 		if ((form & XFS_BLOCK_QUOTA) && d.d_bcount)

