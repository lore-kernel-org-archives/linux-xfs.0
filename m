Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 04 Nov 2008 08:17:36 -0800 (PST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mA4GHMYH014567
	for <xfs@oss.sgi.com>; Tue, 4 Nov 2008 08:17:22 -0800
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F29D014DDEED
	for <xfs@oss.sgi.com>; Tue,  4 Nov 2008 08:17:24 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com with ESMTP id xfJOu1Y7VhCBQA7t for <xfs@oss.sgi.com>; Tue, 04 Nov 2008 08:17:24 -0800 (PST)
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id mA4GHNx8003522
	for <xfs@oss.sgi.com>; Tue, 4 Nov 2008 11:17:23 -0500
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA4GHNOt011676
	for <xfs@oss.sgi.com>; Tue, 4 Nov 2008 11:17:23 -0500
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id mA4GHM0g030880
	for <xfs@oss.sgi.com>; Tue, 4 Nov 2008 11:17:22 -0500
Message-ID: <49107592.3030800@sandeen.net>
Date: Tue, 04 Nov 2008 10:17:22 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfstests: mount with security context if SELinux is enabled
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs mailing list <xfs@oss.sgi.com>

When SELinux is enabled, it adds extra xattrs for security
attributes which can change the output of various tests, causing
them to fail.

If SELinux is enabled, mount with a liberal/permissive context
for the entire filesystem, so that SELinux xattrs don't get
created.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

Index: xfs-cmds/xfstests/common.rc
===================================================================
--- xfs-cmds.orig/xfstests/common.rc
+++ xfs-cmds/xfstests/common.rc
@@ -39,9 +39,18 @@ dd()
 
 _mount_opts()
 {
+    # SELinux adds extra xattrs which can mess up our expected output.
+    # So, mount with a context, and they won't be created
+    # nfs_t is a "liberal" context so we can use it.
+    if [ "$HOSTOS" == "Linux" ]; then
+	if [ -x /usr/sbin/selinuxenabled ] && /usr/sbin/selinuxenabled; then
+		SELINUX_OPTIONS="-o context=system_u:object_r:nfs_t:s0"
+	fi
+    fi
+
     case $FSTYP in
     xfs)
-	export MOUNT_OPTIONS=$XFS_MOUNT_OPTIONS
+	export MOUNT_OPTIONS="$XFS_MOUNT_OPTIONS $SELINUX_OPTIONS"
 	;;
     udf)
 	export MOUNT_OPTIONS=$UDF_MOUNT_OPTIONS
