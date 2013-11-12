Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 184AF7F61
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 11:13:23 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A9764AC008
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 09:13:19 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id zwo40B0OcFfO2pnH for
	<xfs@oss.sgi.com>; Tue, 12 Nov 2013 09:13:19 -0800 (PST)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id rACHDIES007400
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 12:13:18 -0500
Received: from Liberator.local (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id rACHDH6w006284
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 12:13:18 -0500
Message-ID: <528261AD.50501@redhat.com>
Date: Tue, 12 Nov 2013 11:13:17 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH RFC] xfsprogs: suggest "-d" option for repair of RO mount
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
To: xfs-oss <xfs@oss.sgi.com>

How dangerous is dangerous?

We could offer the suggestion of a "-d" repair, if we're
in single-user mode with the root fs mounted readonly.

This change suggests -d to repair any RO mounted fs.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/repair/init.c b/repair/init.c
index c3f380b..a7a7613 100644
--- a/repair/init.c
+++ b/repair/init.c
@@ -97,8 +97,17 @@ xfs_init(libxfs_init_t *args)
 	else
 		args->isreadonly = LIBXFS_EXCLUSIVELY;
 
-	if (!libxfs_init(args))
+	if (!libxfs_init(args)) {
+		/* would -d be an option? */
+		if (!no_modify && !dangerously) {
+			args->isreadonly = (LIBXFS_ISINACTIVE |
+					    LIBXFS_DANGEROUSLY);
+			if (libxfs_init(args))
+				fprintf(stderr,
+_("Unmount or use -d to repair a read-only mounted filesystem\n"));
+		}
 		do_error(_("couldn't initialize XFS library\n"));
+	}
 
 	ts_create();
 	increase_rlimit();

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
