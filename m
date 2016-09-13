Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33748 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755555AbcIMJDJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 13 Sep 2016 05:03:09 -0400
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH V4] xfs: Document error handlers behavior
Date: Tue, 13 Sep 2016 05:03:05 -0400
Message-Id: <1473757385-81633-1-git-send-email-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Document the implementation of error handlers into sysfs.


Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
Changelog:

V2:
	- Add a description of the precedence order of each option, focusing on
	  the behavior of "fail_at_unmount" which was not well explained in V1

V3:
	- Fix English spelling mistakes suggested by Eric

V4:
	- Typo mistakes, document ENODEV default value for max_retries, fix
	  directories's hierarchy description

 Documentation/filesystems/xfs.txt | 75 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 75 insertions(+)

diff --git a/Documentation/filesystems/xfs.txt b/Documentation/filesystems/xfs.txt
index 8146e9f..374af3b 100644
--- a/Documentation/filesystems/xfs.txt
+++ b/Documentation/filesystems/xfs.txt
@@ -348,3 +348,78 @@ Removed Sysctls
   ----				-------
   fs.xfs.xfsbufd_centisec	v4.0
   fs.xfs.age_buffer_centisecs	v4.0
+
+Error handling
+==============
+
+XFS can act differently according to the type of error found
+during its operation. The implementation introduces the following
+concepts to the error handler:
+
+ -failure speed:
+	Defines how fast XFS should shut down when a specific error is found
+	during the filesystem operation. It can shut down immediately, after a
+	defined number of retries, after a set time period, or simply retry
+	forever. The old "retry forever" behavior is still the default, except
+	during unmount, where any IOs retrying due to errors will be cancelled
+	and unmount will be allowed to proceed.
+
+ -error classes:
+	Specifies the subsystem/location of the error handlers, such as
+	metadata or memory allocation. Only metadata IO errors are handled
+	at this time.
+
+ -error handlers:
+	Defines the behavior for a specific error.
+
+The filesystem behavior during an error can be set via sysfs files, Each
+configuration option works independently, the first condition met for a
+specific configuration will cause the filesystem to shut down.
+
+The configuration files are organized into the following hierarchy:
+
+  /sys/fs/xfs/<dev>/error/<class>/<error>/
+
+Each directory contains:
+
+ /sys/fs/xfs/<dev>/error/
+
+	fail_at_unmount		(Min:  0  Default:  1  Max: 1)
+		Defines the global error behavior at unmount time. If set to the
+		default value of 1, XFS will cancel any pending IO retries, shut
+		down, and unmount. If set to 0, pending IO retries may prevent
+		the filesystem from unmounting.
+
+	<class> subdirectories
+		Contains specific error handlers configuration
+		(Ex: /sys/fs/xfs/<dev>/error/metadata, see below).
+
+ /sys/fs/xfs/<dev>/error/<class>/
+
+	Directory containing configuration for a specific error <class>;
+	currently only the "metadata" <class> is implemented.
+	The contents of this directory are <class> specific, since each <class>
+	might need to handle different types of errors.
+
+ /sys/fs/xfs/<dev>/error/<class>/<error>/
+
+	Contains the failure speed configuration files for specific errors in
+	this <class>, as well as a "default" behavior. Each <error> directory
+	contains the following configuration files:
+
+	max_retries			(Min: -1  Default: -1  Max: INTMAX)
+		Defines the allowed number of retries of a specific error before
+		the filesystem will shut down.  The default value of "-1" will
+		cause XFS to retry forever for this specific error.  Setting it
+		to "0" will cause XFS to fail immediately when the specific
+		error is found, and setting it to "N," where N is greater than 0,
+		will make XFS retry "N" times before shutting down.
+		Default value for ENODEV error is set to '0', once there is no
+		reason to keep retrying if the device is gone.
+
+	retry_timeout_seconds		(Min:  0  Default:  0  Max: 1 day)
+		Define the amount of time (in seconds) that the filesystem is
+		allowed to retry its operations when the specific error is
+		found. The default value of "0" will cause XFS to retry forever.
+
+	
-- 
2.5.5

