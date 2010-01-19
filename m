Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0J0a67m142246 for <xfs@oss.sgi.com>; Mon, 18 Jan 2010 18:36:07 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 181861C5C7CE
	for <xfs@oss.sgi.com>; Mon, 18 Jan 2010 16:37:04 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	t9YwjNDK8UlAq0Fi for <xfs@oss.sgi.com>;
	Mon, 18 Jan 2010 16:37:04 -0800 (PST)
Received: from discord (unverified [121.44.156.64])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11448820-1927428
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 11:07:03 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NX25e-0003EY-26
	for xfs@oss.sgi.com; Tue, 19 Jan 2010 11:37:02 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NX25d-0003aS-E2
	for xfs@oss.sgi.com; Tue, 19 Jan 2010 11:37:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/7] xfsprogs: fix some trivial warnings in xfs_db
Date: Tue, 19 Jan 2010 11:36:49 +1100
Message-Id: <1263861413-13729-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1263861413-13729-1-git-send-email-david@fromorbit.com>
References: <1263861413-13729-1-git-send-email-david@fromorbit.com>
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

Three warnings, none harmful - one dir2 name sign warning and
two cases where gcc can't work out if a variable is initialised
correctly in a child function or not.

Signed-off-by: Dave Chinner <david@fromorbit.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/check.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/db/check.c b/db/check.c
index 7620d9c..f94a16b 100644
--- a/db/check.c
+++ b/db/check.c
@@ -2317,7 +2317,7 @@ process_data_dir_v2(
 		tag_err += be16_to_cpu(*tagp) != (char *)dep - (char *)data;
 		addr = xfs_dir2_db_off_to_dataptr(mp, db,
 			(char *)dep - (char *)data);
-		xname.name = (char *)dep->name;
+		xname.name = (uchar_t *)dep->name;
 		xname.len = dep->namelen;
 		dir_hash_add(mp->m_dirnameops->hashname(&xname), addr);
 		ptr += xfs_dir2_data_entsize(dep->namelen);
@@ -3059,7 +3059,7 @@ process_leaf_node_dir_v2(
 	xfs_ino_t		lino;
 	int			nex;
 	xfs_ino_t		parent;
-	int			t;
+	int			t = 0;
 	int			v;
 	int			v2;
 	int			x;
@@ -3403,7 +3403,7 @@ process_quota(
 	xfs_fileoff_t	qbno;
 	char		*s = NULL;
 	int		scicb;
-	int		t;
+	int		t = 0;
 
 	switch (qtype) {
 	case IS_USER_QUOTA:
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
