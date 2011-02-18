Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1IHiSij228490 for <xfs@oss.sgi.com>; Fri, 18 Feb 2011 11:44:28 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9EDD79AB290
	for <xfs@oss.sgi.com>; Fri, 18 Feb 2011 09:47:08 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id TPdqWmewQBDEKZYf for
	<xfs@oss.sgi.com>; Fri, 18 Feb 2011 09:47:08 -0800 (PST)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1IHl8rN025952
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 18 Feb 2011 12:47:08 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id p1IHl5rx009183
	(version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 18 Feb 2011 12:47:07 -0500
Message-ID: <4D5EB09A.3030605@redhat.com>
Date: Fri, 18 Feb 2011 11:47:06 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs_quota: don't try to report quotas which aren't there.
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

Red Hat bug #669333 - xfs_quota generates "XFS_GETQUOTA: No such process" errors
shows that if you do this for a filesystem w/o group quota enabled:

# xfs_quota -x -c ' report -h ' /xfsquota"

You'll get this output:

User quota on /xfsquota (/dev/vdb)
                        Blocks              
User ID      Used   Soft   Hard Warn/Grace   
---------- --------------------------------- 
root            0      0      0  00 [------]

XFS_GETQUOTA: No such process
XFS_GETQUOTA: No such process
...

because we're calling XFS_GETQUOTA for types which aren't enabled.

The below patch fixes it for me, but I'm not sure if it's the
best way to detect whether accounting is on?  Seems to work.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/quota/report.c b/quota/report.c
index 0e005c3..d8d2bef 100644
--- a/quota/report.c
+++ b/quota/report.c
@@ -514,12 +514,16 @@ report_any_type(
 	uint		upper,
 	uint		flags)
 {
+	fs_quota_stat_t	qs;
 	fs_cursor_t	cursor;
 	fs_path_t	*mount;
 
 	if (type & XFS_USER_QUOTA) {
 		fs_cursor_initialise(dir, FS_MOUNT_POINT, &cursor);
 		while ((mount = fs_cursor_next_entry(&cursor))) {
+			xfsquotactl(XFS_GETQSTAT, mount->fs_name, type, 0, &qs);
+			if (!(qs.qs_flags & XFS_QUOTA_UDQ_ACCT))
+				continue;
 			if (xfsquotactl(XFS_QSYNC, mount->fs_name,
 						XFS_USER_QUOTA, 0, NULL) < 0
 					&& errno != ENOENT && errno != ENOSYS)
@@ -531,6 +535,9 @@ report_any_type(
 	if (type & XFS_GROUP_QUOTA) {
 		fs_cursor_initialise(dir, FS_MOUNT_POINT, &cursor);
 		while ((mount = fs_cursor_next_entry(&cursor))) {
+			xfsquotactl(XFS_GETQSTAT, mount->fs_name, type, 0, &qs);
+			if (!(qs.qs_flags & XFS_QUOTA_GDQ_ACCT))
+				continue;
 			if (xfsquotactl(XFS_QSYNC, mount->fs_name,
 						XFS_GROUP_QUOTA, 0, NULL) < 0
 					&& errno != ENOENT && errno != ENOSYS)
@@ -542,6 +549,9 @@ report_any_type(
 	if (type & XFS_PROJ_QUOTA) {
 		fs_cursor_initialise(dir, FS_MOUNT_POINT, &cursor);
 		while ((mount = fs_cursor_next_entry(&cursor))) {
+			xfsquotactl(XFS_GETQSTAT, mount->fs_name, type, 0, &qs);
+			if (!(qs.qs_flags & XFS_QUOTA_PDQ_ACCT))
+				continue;
 			if (xfsquotactl(XFS_QSYNC, mount->fs_name,
 						XFS_PROJ_QUOTA, 0, NULL) < 0
 					&& errno != ENOENT && errno != ENOSYS)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
