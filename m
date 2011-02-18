Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1IHxWGJ229124 for <xfs@oss.sgi.com>; Fri, 18 Feb 2011 11:59:33 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1A2832EA0A6
	for <xfs@oss.sgi.com>; Fri, 18 Feb 2011 10:02:13 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id XF91nPW1h2vrsk9i for
	<xfs@oss.sgi.com>; Fri, 18 Feb 2011 10:02:13 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1II2Ch8003744
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 18 Feb 2011 13:02:13 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id p1II2BiX022526
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 18 Feb 2011 13:02:12 -0500
Message-ID: <4D5EB423.9040009@redhat.com>
Date: Fri, 18 Feb 2011 12:02:11 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH V3] xfs_quota: don't try to report quotas which aren't there.
References: <4D5EB09A.3030605@redhat.com> <4D5EB27C.3070306@redhat.com>
In-Reply-To: <4D5EB27C.3070306@redhat.com>
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

The below patch fixes it for me, just ignoring types that aren't
there.

V2: Thanks to Arkadiusz Miskiewicz for pointing out the simpler fix.
V3: Thanks again to Arkadiusz for suggesting fixing dump as well

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---


diff --git a/quota/report.c b/quota/report.c
index 0e005c3..8653590 100644
--- a/quota/report.c
+++ b/quota/report.c
@@ -82,7 +82,7 @@ dump_file(
 	fs_disk_quota_t	d;
 
 	if (xfsquotactl(XFS_GETQUOTA, dev, type, id, (void *)&d) < 0) {
-		if (errno != ENOENT && errno != ENOSYS)
+		if (errno != ENOENT && errno != ENOSYS && errno != ESRCH)
 			perror("XFS_GETQUOTA");
 		return;
 	}
@@ -302,7 +302,7 @@ report_mount(
 	int		count;
 
 	if (xfsquotactl(XFS_GETQUOTA, dev, type, id, (void *)&d) < 0) {
-		if (errno != ENOENT && errno != ENOSYS)
+		if (errno != ENOENT && errno != ENOSYS && errno != ESRCH)
 			perror("XFS_GETQUOTA");
 		return 0;
 	}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
