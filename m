Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:57718 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751781AbeAXCTP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Jan 2018 21:19:15 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0O27Tmi035646
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2018 02:19:15 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2fpgu183b2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2018 02:19:15 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w0O2JE6o031793
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2018 02:19:14 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w0O2JD5n007840
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2018 02:19:14 GMT
Subject: [PATCH 11/11] xfs: don't clobber inobt/finobt cursors when xref
 with rmap
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 23 Jan 2018 18:19:12 -0800
Message-ID: <151676035279.12349.4382494032049016865.stgit@magnolia>
In-Reply-To: <151676027743.12349.3845769501491774512.stgit@magnolia>
References: <151676027743.12349.3845769501491774512.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Even if we can't use the inobt/finobt cursors to count the number of
inode btree blocks, we are never allowed to clobber the cursor of the
btree being checked, so don't do this.  Found by fuzzing level = ones
in xfs/364.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/ialloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 21c850a..63ab3f9 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -391,12 +391,12 @@ xfs_scrub_iallocbt_xref_rmap_btreeblks(
 
 	/* Check that we saw as many inobt blocks as the rmap says. */
 	error = xfs_btree_count_blocks(sc->sa.ino_cur, &inobt_blocks);
-	if (!xfs_scrub_should_check_xref(sc, &error, &sc->sa.ino_cur))
+	if (!xfs_scrub_process_error(sc, 0, 0, &error))
 		return;
 
 	if (sc->sa.fino_cur) {
 		error = xfs_btree_count_blocks(sc->sa.fino_cur, &finobt_blocks);
-		if (!xfs_scrub_should_check_xref(sc, &error, &sc->sa.fino_cur))
+		if (!xfs_scrub_process_error(sc, 0, 0, &error))
 			return;
 	}
 

