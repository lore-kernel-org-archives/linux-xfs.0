Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o261oGOP041818 for <xfs@oss.sgi.com>; Fri, 5 Mar 2010 19:50:16 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 26FF113FE7DB
	for <xfs@oss.sgi.com>; Fri,  5 Mar 2010 17:51:40 -0800 (PST)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	iKxFB6GiMBorF7k6 for <xfs@oss.sgi.com>;
	Fri, 05 Mar 2010 17:51:40 -0800 (PST)
Received: from discord (unverified [121.44.103.80])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	4462088-1927428
	for <xfs@oss.sgi.com>; Sat, 06 Mar 2010 12:21:38 +1030 (CDT)
Received: from disturbed ([192.168.1.9]) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NnjB3-0007Ru-Kg
	for xfs@oss.sgi.com; Sat, 06 Mar 2010 12:51:37 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NnjAv-0001ES-3o
	for xfs@oss.sgi.com; Sat, 06 Mar 2010 12:51:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/9] xfs: fix reservation release commit flag in
	xfs_bmap_add_attrfork()
Date: Sat,  6 Mar 2010 12:51:19 +1100
Message-Id: <1267840284-4652-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1267840284-4652-1-git-send-email-david@fromorbit.com>
References: <1267840284-4652-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

xfs_bmap_add_attrfork() passes XFS_TRANS_PERM_LOG_RES to xfs_trans_commit()
to indicate that the commit should release the permanent log reservation
as part of the commit. This is wrong - the correct flag is
XFS_TRANS_RELEASE_LOG_RES - and it is only by the chance that both these
flags have the value of 0x4 that the code is doing the right thing.

Fix it by changing to use the correct flag.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_bmap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 95a4813..528a3b4 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -3834,7 +3834,7 @@ xfs_bmap_add_attrfork(
 	}
 	if ((error = xfs_bmap_finish(&tp, &flist, &committed)))
 		goto error2;
-	error = xfs_trans_commit(tp, XFS_TRANS_PERM_LOG_RES);
+	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
 	ASSERT(ip->i_df.if_ext_max ==
 	       XFS_IFORK_DSIZE(ip) / (uint)sizeof(xfs_bmbt_rec_t));
 	return error;
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
