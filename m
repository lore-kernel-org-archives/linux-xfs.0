Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 285DE7CB1
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 01:57:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E95C28F8033
	for <xfs@oss.sgi.com>; Mon, 11 Apr 2016 23:57:34 -0700 (PDT)
Received: from mail-wm0-f48.google.com (mail-wm0-f48.google.com
	[74.125.82.48]) by cuda.sgi.com with ESMTP id RrqxdxAdgBALaHbH
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 11 Apr 2016 23:57:32 -0700 (PDT)
Received: by mail-wm0-f48.google.com with SMTP id v188so113995939wme.1
	for <xfs@oss.sgi.com>; Mon, 11 Apr 2016 23:57:32 -0700 (PDT)
From: Shyam Kaushik <shyam@zadarastorage.com>
MIME-Version: 1.0
Date: Tue, 12 Apr 2016 12:27:30 +0530
Message-ID: <23e35813cb097c7b15686852500cbf97@mail.gmail.com>
Subject: [PATCH] xfs: Abort intent log item in xfs_iflush() upon error to get
	buf
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Looking at xfs_iflush(). If an IO fails, it is supposed to unlock the
inode by calling xfs_iflush_abort(), which will also remove it from
the AIL. This can also happen on reclaim of a dirty inode, and if so
we'll still reclaim the inode because reclaim assumes xfs_iflush()
cleans up properly. Which, apparently, it doesn't.

Fix xfs_iflush() buf get failure to remove intent log item.

Discovered-by: Dave Chinner <dchinner at redhat.com>
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 96f606d..85414a6 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3374,8 +3374,9 @@ xfs_iflush(
        error = xfs_imap_to_bp(mp, NULL, &ip->i_imap, &dip, &bp,
XBF_TRYLOCK,
                               0);
        if (error || !bp) {
-               xfs_ifunlock(ip);
-               return error;
+               if (!bp)
+                       error = -EIO;
+               goto abort_out;
        }

        /*
--

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
