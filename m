Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:39330 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751314AbeCOAaZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Mar 2018 20:30:25 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w2F0R7Jj083775
        for <linux-xfs@vger.kernel.org>; Thu, 15 Mar 2018 00:30:24 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2gqdf504ak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 15 Mar 2018 00:30:24 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w2F0UNb5008986
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 15 Mar 2018 00:30:24 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w2F0UNCr001545
        for <linux-xfs@vger.kernel.org>; Thu, 15 Mar 2018 00:30:23 GMT
Subject: [PATCH 8/9] xfs: record inode buf errors as a xref error in inode
 scrubber
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 14 Mar 2018 17:30:20 -0700
Message-ID: <152107382051.19571.2865600595521884732.stgit@magnolia>
In-Reply-To: <152107377037.19571.8618901963505842632.stgit@magnolia>
References: <152107377037.19571.8618901963505842632.stgit@magnolia>
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

