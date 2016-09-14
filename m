Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:18714 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750975AbcINBYX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Sep 2016 21:24:23 -0400
Date: Wed, 14 Sep 2016 11:23:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V4] xfs: Document error handlers behavior
Message-ID: <20160914012334.GK30497@dastard>
References: <1473757385-81633-1-git-send-email-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1473757385-81633-1-git-send-email-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

On Tue, Sep 13, 2016 at 05:03:05AM -0400, Carlos Maiolino wrote:
> Document the implementation of error handlers into sysfs.
> 
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
> Changelog:
> 
> V2:
> 	- Add a description of the precedence order of each option, focusing on
> 	  the behavior of "fail_at_unmount" which was not well explained in V1
> 
> V3:
> 	- Fix English spelling mistakes suggested by Eric
> 
> V4:
> 	- Typo mistakes, document ENODEV default value for max_retries, fix
> 	  directories's hierarchy description

Ok, I had to update this for the change in retry timeout values from
Eric, so I went and fixed all the other things I thought needed
fixing, too. New patch below....

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: Document error handlers behavior

From: Carlos Maiolino <cmaiolino@redhat.com>

Document the implementation of error handlers into sysfs.

[dchinner: significant update:
	- removed examples from concept descriptions, placed them in
	  appropriate detailed descriptions instead
	- added explanations for <dev>, <class> and <error> strings
	  in sysfs layout description
	- added specific definition of "global" per-filesystem error
	  configuration parameters.
	- reformatted to remove multiple indents
	- added more information about fail_at_unmount behaviour and
	  constraints
	- added comment that there is a "default" handler to
	  configure behaviour for all errors that don't have
	  specific handlers defined.
	- added specific handler value explanations
	- added note about handlers having context specific
	  defaults with example. ]

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>

---
 Documentation/filesystems/xfs.txt | 125 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 125 insertions(+)

diff --git a/Documentation/filesystems/xfs.txt b/Documentation/filesystems/xfs.txt
index 8146e9f..705d064 100644
--- a/Documentation/filesystems/xfs.txt
+++ b/Documentation/filesystems/xfs.txt
@@ -348,3 +348,128 @@ Removed Sysctls
   ----				-------
   fs.xfs.xfsbufd_centisec	v4.0
   fs.xfs.age_buffer_centisecs	v4.0
+
+
+Error handling
+==============
+
+XFS can act differently according to the type of error found during its
+operation. The implementation introduces the following concepts to the error
+handler:
+
+ -failure speed:
+	Defines how fast XFS should propagate an error upwards when a specific
+	error is found during the filesystem operation. It can propagate
+	immediately, after a defined number of retries, after a set time period,
+	or simply retry forever.
+
+ -error classes:
+	Specifies the subsystem the error configuration will apply to, such as
+	metadata IO or memory allocation. Different subsystems will have
+	different error handlers for which behaviour can be configured.
+
+ -error handlers:
+	Defines the behavior for a specific error.
+
+The filesystem behavior during an error can be set via sysfs files, Each
+error handler works independently, the first condition met by and error handler
+for a specific class will cause the error to be propagated rather than reset and
+retried.
+
+The action taken by the filesystem when the error is propagated is context
+dependent - it may cause a shut down in the case of an unrecoverable error,
+it may be reported back to userspace, or it may even be ignored because
+there's nothing useful we can with the error or anyone we can report it to (e.g.
+during unmount).
+
+The configuration files are organized into the following per-mounted filesystem
+hierarchy:
+
+  /sys/fs/xfs/<dev>/error/<class>/<error>/
+
+Where:
+  <dev>
+	The short device name of the mounted filesystem. This is the same device
+	name that shows up in XFS kernel error messages as "XFS(<dev>): ..."
+
+  <class>
+	The subsystem the error configuration belongs to. As of 4.9, the defined
+	classes are:
+
+		- "metadata": applies metadata buffer write IO
+
+  <error>
+	The individual error handler configurations.
+
+
+Each filesystem has "global" error configuration options defined in their top
+level directory:
+
+  /sys/fs/xfs/<dev>/error/
+
+  fail_at_unmount		(Min:  0  Default:  1  Max: 1)
+	Defines the filesystem error behavior at unmount time.
+
+	If set to a value of 1, XFS will override all other error configurations
+	during unmount and replace them with "immediate fail" characteristics.
+	i.e. no retries, no retry timeout. This will always allow unmount to
+	succeed when there are persistent errors present.
+
+	If set to 0, the configured retry behaviour will continue until all
+	retries and/or timeouts have been exhausted. This will delay unmount
+	completion when there are persistent errors, and it may prevent the
+	filesystem from ever unmounting fully in the case of "retry forever"
+	handler configurations.
+
+	Note: there is no guarantee that fail_at_unmount can be set whilst an
+	unmount is in progress. It is possible that the sysfs entries are
+	removed by the unmounting filesystem before a "retry forever" error
+	handler configuration causes unmount to hang, and hence the filesystem
+	must be configured appropriately before unmount begins to prevent
+	unmount hangs.
+
+Each filesystem has specific error class handlers that define the error
+propagation behaviour for specific errors. There is also a "default" error
+handler defined, which defines the behaviour for all errors that don't have
+specific handlers defined. The handler configurations are found in the
+directory:
+
+  /sys/fs/xfs/<dev>/error/<class>/<error>/
+
+  max_retries			(Min: -1  Default: Varies  Max: INTMAX)
+	Defines the allowed number of retries of a specific error before
+	the filesystem will propagate the error. The retry count for a given
+	error context (e.g. a specific metadata buffer) is reset ever time there
+	is a successful completion of the operation.
+
+	Setting the value to "-1" will cause XFS to retry forever for this
+	specific error.
+
+	Setting the value to "0" will cause XFS to fail immediately when the
+	specific error is reported.
+
+	Setting the value to "N" (where 0 < N < Max) will make XFS retry the
+	operation "N" times before propagating the error.
+
+  retry_timeout_seconds		(Min:  -1  Default:  Varies  Max: 1 day)
+	Define the amount of time (in seconds) that the filesystem is
+	allowed to retry its operations when the specific error is
+	found.
+
+	Setting the value to "-1" will set an infinite timeout, causing
+	error propagation behaviour to be determined solely by the "max_retries"
+	parameter.
+
+	Setting the value to "0" will cause XFS to fail immediately when the
+	specific error is reported.
+
+	Setting the value to  "N" (where 0 < N < Max) will propagate the error
+	on the first retry that fails at least "N" seconds after the first error
+	was detected, unless the number of retries defined by max_retries
+	expires first.
+
+Note: The default behaviour for a specific error handler is dependent on both
+the class and error context. For example, the default values for
+"metadata/ENODEV" are "0" rather than "-1" so that this error handler defaults
+to "fail immediately" behaviour. This is done because ENODEV is a fatal,
+unrecoverable error no matter how many times the metadata IO is retried.
