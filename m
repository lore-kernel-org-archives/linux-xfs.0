Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:60728 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751367AbeBWCBN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Feb 2018 21:01:13 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w1N1utrn066607
        for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2018 02:01:12 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2ga9bpg239-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2018 02:01:12 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w1N21C5M020016
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2018 02:01:12 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w1N21CEW010581
        for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2018 02:01:12 GMT
Subject: [PATCH 7/8] xfs: record inode buf errors as a xref error in inode
 scrubber
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 22 Feb 2018 18:01:11 -0800
Message-ID: <151935127107.21842.13901796994176849963.stgit@magnolia>
In-Reply-To: <151935122813.21842.14996049216693190946.stgit@magnolia>
References: <151935122813.21842.14996049216693190946.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

During the inode btree scrubs we try to confirm the freemask bits
against the inode records.  If the inode buffer read fails, this is a
cross-referencing error, not a corruption of the inode btree itself.
Use the xref_process_error call here.  Found via core.version middlebit
fuzz in xfs/415.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/ialloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 63ab3f9..32e0d1a 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -259,7 +259,8 @@ xfs_scrub_iallocbt_check_freemask(
 
 		error = xfs_imap_to_bp(mp, bs->cur->bc_tp, &imap,
 				&dip, &bp, 0, 0);
-		if (!xfs_scrub_btree_process_error(bs->sc, bs->cur, 0, &error))
+		if (!xfs_scrub_btree_xref_process_error(bs->sc, bs->cur, 0,
+				&error))
 			continue;
 
 		/* Which inodes are free? */

