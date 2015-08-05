Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F111E7FC6
	for <xfs@oss.sgi.com>; Wed,  5 Aug 2015 06:09:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C13F98F8049
	for <xfs@oss.sgi.com>; Wed,  5 Aug 2015 04:09:00 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	oTfAHaMQGWc46Q3E for <xfs@oss.sgi.com>;
	Wed, 05 Aug 2015 04:08:57 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1ZMwYt-0006Gy-MD
	for xfs@oss.sgi.com; Wed, 05 Aug 2015 21:08:43 +1000
Received: from dave by disappointment with local (Exim 4.86_RC4)
	(envelope-from <dave@disappointment.disaster>) id 1ZMwYt-0007nI-LL
	for xfs@oss.sgi.com; Wed, 05 Aug 2015 21:08:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [RFC, PATCH 00/10] xfs: configurable error behaviours
Date: Wed,  5 Aug 2015 21:08:31 +1000
Message-Id: <1438772921-28715-1-git-send-email-david@fromorbit.com>
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

Hi folks,

This is my first pass at introducing a framework for configuring the
error handling behaviour of various subsystems in XFS. This is being
driven by the need to handle things like ENOSPC from thin
provisioned block devices in a sane manner, as well as from the mm/
side of the kernel for more configurable memory allocation failure
behaviour.

The patchset introduces the concepts of:

	- "failure speed", which defines the obvious behaviour of
	  the error handlers. "fast" will fail immediately, "slow"
	  will fail after a bound number of retries or timeout, and
	  "never" means exactly that. The current behaviour is
	  "never", and this patchset mostly leaves the default
	  behaviour configured this way.

	- "error class", which is the subsystem or error location
	  the error handlers configure the behaviour for. "metadata"
	  configures async write errors in metadata buffers, "kmem"
	  configures memory allocation failure behaviour and we'll
	  add others as we see fit.

	- "error handler", which is the specific error the
	  configuration applies to. For IO errors, it's obvious that
	  EIO, ENOSPC, ENODEV, etc are errors that need to be
	  handled in different ways. But for the kmem class, the
	  only error is ENOMEM, so while that it is currently
	  configured that way, the error handlers are more likely to
	  refer to failures in transaction context, in buffer
	  allocation context, etc. IOWs, the name and failure
	  context can change, but the same "failure speed"
	  definition still applies.

As a result, the infrastructure is quite flexible - anywhere you
have a struct xfs_mount you can look up an error handling
configuration and apply it appropriately for that context. The
patchset really only implements a metadata buffer async write IO
error context handler, but that is just the tip of the iceberg....

I've tried to make the initialisation as generic and simple as
possible. It's all table based, so all the default values are in one
place and easy to find - you don't have to touch the initialisation
code to modify the default error config, or to add new errors. Only
sysfs handlers need to be added for new error classes and handlers.

The current sysfs layout looks like this:

$ find /sys/fs/xfs/vdc/error
/sys/fs/xfs/vdc/error
/sys/fs/xfs/vdc/error/kmem
/sys/fs/xfs/vdc/error/kmem/ENOMEM
/sys/fs/xfs/vdc/error/kmem/ENOMEM/max_retries
/sys/fs/xfs/vdc/error/kmem/ENOMEM/failure_speed
/sys/fs/xfs/vdc/error/kmem/ENOMEM/fail_at_unmount
/sys/fs/xfs/vdc/error/kmem/ENOMEM/retry_timeout_seconds
/sys/fs/xfs/vdc/error/kmem/Default
/sys/fs/xfs/vdc/error/kmem/Default/max_retries
/sys/fs/xfs/vdc/error/kmem/Default/failure_speed
/sys/fs/xfs/vdc/error/kmem/Default/fail_at_unmount
/sys/fs/xfs/vdc/error/kmem/Default/retry_timeout_seconds
/sys/fs/xfs/vdc/error/metadata
/sys/fs/xfs/vdc/error/metadata/EIO
/sys/fs/xfs/vdc/error/metadata/EIO/max_retries
/sys/fs/xfs/vdc/error/metadata/EIO/failure_speed
/sys/fs/xfs/vdc/error/metadata/EIO/fail_at_unmount
/sys/fs/xfs/vdc/error/metadata/EIO/retry_timeout_seconds
/sys/fs/xfs/vdc/error/metadata/ENODEV
/sys/fs/xfs/vdc/error/metadata/ENODEV/max_retries
/sys/fs/xfs/vdc/error/metadata/ENODEV/failure_speed
/sys/fs/xfs/vdc/error/metadata/ENODEV/fail_at_unmount
/sys/fs/xfs/vdc/error/metadata/ENODEV/retry_timeout_seconds
/sys/fs/xfs/vdc/error/metadata/ENOSPC
/sys/fs/xfs/vdc/error/metadata/ENOSPC/max_retries
/sys/fs/xfs/vdc/error/metadata/ENOSPC/failure_speed
/sys/fs/xfs/vdc/error/metadata/ENOSPC/fail_at_unmount
/sys/fs/xfs/vdc/error/metadata/ENOSPC/retry_timeout_seconds
/sys/fs/xfs/vdc/error/metadata/Default
/sys/fs/xfs/vdc/error/metadata/Default/max_retries
/sys/fs/xfs/vdc/error/metadata/Default/failure_speed
/sys/fs/xfs/vdc/error/metadata/Default/fail_at_unmount
/sys/fs/xfs/vdc/error/metadata/Default/retry_timeout_seconds
$

Which shows the classes and error handlers, and how different
classes can have different error handlers.

The patchset runs through xfstests without problems on the default
configuration it sets. Note that the default config for the metadata
class now sets "fail at unmount" so errors that have been retries
indefinitely will fail at unmount and trigger a shutdown at that
point. This is preferable to hanging unmount as currently happens.

Anyway, have a play, have a poke, and let me know what you think...

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
