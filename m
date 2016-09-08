Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 16AA27CB9
	for <xfs@oss.sgi.com>; Thu,  8 Sep 2016 04:24:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BEEC08F8040
	for <xfs@oss.sgi.com>; Thu,  8 Sep 2016 02:24:04 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id OV8w6nvBinFYB0Gy (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 08 Sep 2016 02:24:03 -0700 (PDT)
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH] xfs: Document error handlers behavior
Date: Thu,  8 Sep 2016 05:23:55 -0400
Message-Id: <1473326635-30209-1-git-send-email-cmaiolino@redhat.com>
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
To: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Document the implementation of error handlers into sysfs.

Changelog:

V2:
	- Add a description of the precedence order of each option, focusing on
	  the behavior of "fail_at_unmount" which was not well explained in V1

V3:
	- Fix English spelling mistakes suggested by Eric

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 Documentation/filesystems/xfs.txt | 70 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 70 insertions(+)

diff --git a/Documentation/filesystems/xfs.txt b/Documentation/filesystems/xfs.txt
index 8146e9f..8b6c861 100644
--- a/Documentation/filesystems/xfs.txt
+++ b/Documentation/filesystems/xfs.txt
@@ -348,3 +348,73 @@ Removed Sysctls
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
+	Defines how fast XFS should shut down when of a specific error is found
+	during the filesystem operation. It can shut down immediately, after a
+	defined number of retries, after a set time period, or simply retry
+	forever. The old "retry forever" behavior is still the default, except
+	during unmount, where any IOs retrying due to errors will be cancelled
+	and unmount will be allowed to proceed.
+
+ -error classes:
+	Specifies the subsystem/location where the error handlers, such as
+	metadata or memory allocation. Only metadata IO errors are handled
+	at this time.
+
+ -error handlers:
+	Defines the behavior for a specific error.
+
+The filesystem behavior during an error can be set via sysfs files, where the
+errors are organized with the structure below. Each configuration option works
+independently, the first condition met for a specific configuration will cause
+the filesystem to shut down:
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
+	this <class, as well as a "default" behavior. Each <error> directory
+	contains the following configuration files:
+
+	max_retries			(Min: -1  Default: -1  Max: INTMAX)
+		Defines the allowed number of retries of a specific error before
+		the filesystem will shut down.  The default value of "-1" will
+		cause XFS to retry forever for this specific error.  Setting it
+		to "0" will cause XFS to fail immediately when the specific
+		error is found, and setting it to "N," where N is greater than 0,
+		will make XFS retry "N" times before shutting down.
+
+	retry_timeout_seconds		(Min:  0  Default:  0  Max: INTMAX)
+		Define the amount of time (in seconds) that the filesystem is
+		allowed to retry its operations when the specific error is
+		found. The default value of "0" will cause XFS to retry forever.
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
