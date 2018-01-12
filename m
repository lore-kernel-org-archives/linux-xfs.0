Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:35224 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965156AbeALWOP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Jan 2018 17:14:15 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0CMCMuq063588
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jan 2018 22:14:14 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2ff5e302tp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jan 2018 22:14:14 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w0CM4Dnr025543
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jan 2018 22:04:13 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w0CM4DSL017409
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jan 2018 22:04:13 GMT
Subject: [PATCH 2/5] xfs: don't iunlock unlocked inodes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 12 Jan 2018 14:04:12 -0800
Message-ID: <151579465207.8694.2459805113822761321.stgit@magnolia>
In-Reply-To: <151579463950.8694.320025813242574491.stgit@magnolia>
References: <151579463950.8694.320025813242574491.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Don't iunlock an unlocked inode, which can happen if the parent pointer
scrubber bails out with sc->ip unlocked while trying to grab the parent
directory inode.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/scrub.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 9c177ea..89178b9 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -193,7 +193,8 @@ xfs_scrub_teardown(
 		sc->fs_frozen = false;
 	}
 	if (sc->ip) {
-		xfs_iunlock(sc->ip, sc->ilock_flags);
+		if (sc->ilock_flags)
+			xfs_iunlock(sc->ip, sc->ilock_flags);
 		if (sc->ip != ip_in &&
 		    !xfs_internal_inum(sc->mp, sc->ip->i_ino))
 			iput(VFS_I(sc->ip));

