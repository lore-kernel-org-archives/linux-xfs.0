Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 30F177CA0
	for <xfs@oss.sgi.com>; Tue, 19 Jul 2016 05:04:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0275A8F8033
	for <xfs@oss.sgi.com>; Tue, 19 Jul 2016 03:04:25 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id sh2tlj7OR3uJ2ufn (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 19 Jul 2016 03:04:24 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id EB94F81F03
	for <xfs@oss.sgi.com>; Tue, 19 Jul 2016 10:04:23 +0000 (UTC)
Received: from zion.usersys.redhat.com (vpn-55-34.rdu2.redhat.com
	[10.10.55.34])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u6JA4MwG027722
	for <xfs@oss.sgi.com>; Tue, 19 Jul 2016 06:04:23 -0400
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH] xfs: Document error handling behavior
Date: Tue, 19 Jul 2016 12:04:17 +0200
Message-Id: <1468922657-3895-1-git-send-email-cmaiolino@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is the first try to document the implementation of error handlers into
sysfs.

Reviews and comments are appreciated, please also notice I'm not english-native,
so, spelling corrections are also appreciated :)

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 Documentation/filesystems/xfs.txt | 78 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 78 insertions(+)

diff --git a/Documentation/filesystems/xfs.txt b/Documentation/filesystems/xfs.txt
index 8146e9f..1df868a 100644
--- a/Documentation/filesystems/xfs.txt
+++ b/Documentation/filesystems/xfs.txt
@@ -348,3 +348,81 @@ Removed Sysctls
   ----				-------
   fs.xfs.xfsbufd_centisec	v4.0
   fs.xfs.age_buffer_centisecs	v4.0
+
+Error handling
+==============
+
+XFS can act differently according with the type of error found
+during its operation. The implementation introduces the following
+concepts to the error handler:
+
+ -failure speed:
+	Defines how fast XFS should shutdown in case of a specific
+	error is found during the filesystem  operation. It can
+	shutdown immediately, after a defined number of tries, or
+	simply try forever, which was the old behavior and is now
+	set as default behavior, except during unmount time, where
+	in case of a error is found while unmounting, the filesystem
+	will shutdown.
+
+ -error classes:
+	Specifies the subsystem/location where the error handlers
+	configure the behavior for, such as metadata or memory allocation.
+
+ -error handlers:
+	Defines the behavior for a specific error.
+
+The filesystem behavior during an error can be set via sysfs files, where, the
+errors are organized with the following structure:
+
+  /sys/fs/xfs/<dev>/error/<class>/<error>/
+
+Each directory contains:
+
+ /sys/fs/xfs/<dev>/error/
+
+	fail_at_unmount		(Min:  0  Default:  1  Max: 1)
+		Defines the global error behavior during unmount time. If set to
+		"1", XFS will shutdown in case of any error is found, otherwise,
+		if set to "0", the filesystem will indefinitely retry to cleanly
+		unmount the filesystem.
+
+	<class> subdirectories
+		Contains specific error handlers configuration
+		(Ex: /sys/fs/xfs/<dev>/error/metadata).
+
+ /sys/fs/xfs/<dev>/error/<class>/
+
+	The contents of this directory are <class> specific, since each <class>
+	might need to handle different types of errors. All <error> directory
+	though, contains the "default" directory, which is a global configuration
+	for errors not available for independent configuration.
+
+ /sys/fs/xfs/<dev>/error/<class>/<error>
+
+	Contains the failure speed configuration files for each specific error,
+	including the "default" behavior, which contains the same configuration
+	options as the specific errors.
+
+	The available configurations for each error type are:
+
+	max_retries			(Min: -1  Default: -1  Max: INTMAX)
+		Define how many tries the filesystem is allowed to retry its
+		operations during the specific error, before shutdown the
+		filesystem. Setting this file to "-1", will set XFS to retry
+		forever in the specific error, setting it to "0", will make
+		XFS to fail immediately after the specific error is found,
+		while setting it to a "N" value, where N is greater than 0,
+		will make XFS retry "N" times before shutdown.
+
+	retry_timeout_seconds		(Min:  0  Default:  0  Max: INTMAX)
+		Define the amount of time (in seconds) that the filesystem is
+		allowed to retry its operations when the specific error is
+		found. "0" means no wait time.
+
+
+	"max_retries" takes precedence over "retry_timeout_seconds", where,
+	"retry_timeout_seconds" will only be tested if the "max_retries" limit
+	were not reached yet or is set to retry forever ("-1"). If "max_retries"
+	limit is reached, the filesystem will shutdown, wether or not
+	"retry_timeout_seconds" has been reached.
-- 
2.7.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
