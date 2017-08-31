Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:5076 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751205AbdHaOLO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2017 10:11:14 -0400
From: Hou Tao <houtao1@huawei.com>
Subject: [PATCH 7/7] xfs: document the customizable default values of error configuration
Date: Thu, 31 Aug 2017 22:15:58 +0800
Message-ID: <1504188958-18374-8-git-send-email-houtao1@huawei.com>
In-Reply-To: <1504188958-18374-1-git-send-email-houtao1@huawei.com>
References: <1504188958-18374-1-git-send-email-houtao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com, david@fromorbit.com, cmaiolino@redhat.com

Mainly the sysfs paths of the default values and the difference between
the default errror configuration and the fs-specific one.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 Documentation/filesystems/xfs.txt | 31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/Documentation/filesystems/xfs.txt b/Documentation/filesystems/xfs.txt
index 3b9b5c1..0be68fc 100644
--- a/Documentation/filesystems/xfs.txt
+++ b/Documentation/filesystems/xfs.txt
@@ -397,12 +397,25 @@ Where:
   <error>
 	The individual error handler configurations.
 
+For the convenience of error configuration, there are also configuration files
+used for the default values of error configuration of all mounted filesystem:
+
+  /sys/fs/xfs/default_error/<class>/<error>/
+
+There is only one difference between the error configuration options under
+these two sysfs trees: the options under <dev>/error/ can have a value of
+"default", and the options under default_error/ can not.
 
 Each filesystem has "global" error configuration options defined in their top
 level directory:
 
   /sys/fs/xfs/<dev>/error/
 
+For the default values of the "global" error configuration options, the
+directory is:
+
+  /sys/fs/xfs/default_error/
+
   fail_at_unmount		(Min:  0  Default:  1  Max: 1)
 	Defines the filesystem error behavior at unmount time.
 
@@ -417,6 +430,9 @@ level directory:
 	filesystem from ever unmounting fully in the case of "retry forever"
 	handler configurations.
 
+	If set to "default", the behavior will be decided by the value of
+	/sys/fs/xfs/default_error/fail_at_unmount.
+
 	Note: there is no guarantee that fail_at_unmount can be set whilst an
 	unmount is in progress. It is possible that the sysfs entries are
 	removed by the unmounting filesystem before a "retry forever" error
@@ -427,12 +443,17 @@ level directory:
 Each filesystem has specific error class handlers that define the error
 propagation behaviour for specific errors. There is also a "default" error
 handler defined, which defines the behaviour for all errors that don't have
-specific handlers defined. Where multiple retry constraints are configuredi for
+specific handlers defined. Where multiple retry constraints are configured for
 a single error, the first retry configuration that expires will cause the error
 to be propagated. The handler configurations are found in the directory:
 
   /sys/fs/xfs/<dev>/error/<class>/<error>/
 
+There is also a corresponding directory for the default values of these
+handler configuration:
+
+  /sys/fs/xfs/default_error/<class>/<error>/
+
   max_retries			(Min: -1  Default: Varies  Max: INTMAX)
 	Defines the allowed number of retries of a specific error before
 	the filesystem will propagate the error. The retry count for a given
@@ -448,6 +469,10 @@ to be propagated. The handler configurations are found in the directory:
 	Setting the value to "N" (where 0 < N < Max) will make XFS retry the
 	operation "N" times before propagating the error.
 
+	Setting the value to "default" will let the default value of the handler,
+	namely the value of default_error/<class>/<error>/max_retries,
+	to decide the error propagation behavior.
+
   retry_timeout_seconds		(Min:  -1  Default:  Varies  Max: 1 day)
 	Define the amount of time (in seconds) that the filesystem is
 	allowed to retry its operations when the specific error is
@@ -462,6 +487,10 @@ to be propagated. The handler configurations are found in the directory:
 	Setting the value to "N" (where 0 < N < Max) will allow XFS to retry the
 	operation for up to "N" seconds before propagating the error.
 
+	Setting the value to "default" will let the default value of the handler,
+	namely the value of default_error/<class>/<error>/retry_timeout_seconds,
+	to decide the error propagation behavior.
+
 Note: The default behaviour for a specific error handler is dependent on both
 the class and error context. For example, the default values for
 "metadata/ENODEV" are "0" rather than "-1" so that this error handler defaults
-- 
2.5.0

