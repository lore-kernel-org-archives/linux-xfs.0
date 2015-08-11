Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 95CE77F54
	for <xfs@oss.sgi.com>; Tue, 11 Aug 2015 09:20:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7E848304051
	for <xfs@oss.sgi.com>; Tue, 11 Aug 2015 07:20:59 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id t6iRCN1pGSKG1GLn (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 11 Aug 2015 07:20:58 -0700 (PDT)
Date: Tue, 11 Aug 2015 10:20:56 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [RFC, PATCH 00/10] xfs: configurable error behaviours
Message-ID: <20150811142056.GD59636@bfoster.bfoster>
References: <1438772921-28715-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1438772921-28715-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, Aug 05, 2015 at 09:08:31PM +1000, Dave Chinner wrote:
> Hi folks,
> 
> This is my first pass at introducing a framework for configuring the
> error handling behaviour of various subsystems in XFS. This is being
> driven by the need to handle things like ENOSPC from thin
> provisioned block devices in a sane manner, as well as from the mm/
> side of the kernel for more configurable memory allocation failure
> behaviour.
> 

By and large, this looks pretty good to me. I sent some comments on the
individual patches separately. A few more random thoughts below...

> The patchset introduces the concepts of:
> 
> 	- "failure speed", which defines the obvious behaviour of
> 	  the error handlers. "fast" will fail immediately, "slow"
> 	  will fail after a bound number of retries or timeout, and
> 	  "never" means exactly that. The current behaviour is
> 	  "never", and this patchset mostly leaves the default
> 	  behaviour configured this way.
> 
> 	- "error class", which is the subsystem or error location
> 	  the error handlers configure the behaviour for. "metadata"
> 	  configures async write errors in metadata buffers, "kmem"
> 	  configures memory allocation failure behaviour and we'll
> 	  add others as we see fit.
> 
> 	- "error handler", which is the specific error the
> 	  configuration applies to. For IO errors, it's obvious that
> 	  EIO, ENOSPC, ENODEV, etc are errors that need to be
> 	  handled in different ways. But for the kmem class, the
> 	  only error is ENOMEM, so while that it is currently
> 	  configured that way, the error handlers are more likely to
> 	  refer to failures in transaction context, in buffer
> 	  allocation context, etc. IOWs, the name and failure
> 	  context can change, but the same "failure speed"
> 	  definition still applies.
> 

At first thought, I'm not a huge fan of encoding the error codes into
the sysfs interface. This stuff probably shouldn't change much, if ever,
but it's not exactly under our control since we're talking about
underlying device error codes.

On one hand, I think it would be nice to have something like
'out_of_space' in the sysfs tree rather than ENOSPC, for example. Then
the filesystem would just do the right thing for whatever error code
that happens to reflect. On the other hand, one could have some 3rd
party storage device that reports EIO or something else in the context
where a thin volume is out of space, for example. The user would have no
sense of how to configure that for this particular device without the
error code based configuration.

> As a result, the infrastructure is quite flexible - anywhere you
> have a struct xfs_mount you can look up an error handling
> configuration and apply it appropriately for that context. The
> patchset really only implements a metadata buffer async write IO
> error context handler, but that is just the tip of the iceberg....
> 
> I've tried to make the initialisation as generic and simple as
> possible. It's all table based, so all the default values are in one
> place and easy to find - you don't have to touch the initialisation
> code to modify the default error config, or to add new errors. Only
> sysfs handlers need to be added for new error classes and handlers.
> 
> The current sysfs layout looks like this:
> 
> $ find /sys/fs/xfs/vdc/error
> /sys/fs/xfs/vdc/error
> /sys/fs/xfs/vdc/error/kmem
> /sys/fs/xfs/vdc/error/kmem/ENOMEM
> /sys/fs/xfs/vdc/error/kmem/ENOMEM/max_retries
> /sys/fs/xfs/vdc/error/kmem/ENOMEM/failure_speed
> /sys/fs/xfs/vdc/error/kmem/ENOMEM/fail_at_unmount
> /sys/fs/xfs/vdc/error/kmem/ENOMEM/retry_timeout_seconds
> /sys/fs/xfs/vdc/error/kmem/Default
> /sys/fs/xfs/vdc/error/kmem/Default/max_retries
> /sys/fs/xfs/vdc/error/kmem/Default/failure_speed
> /sys/fs/xfs/vdc/error/kmem/Default/fail_at_unmount
> /sys/fs/xfs/vdc/error/kmem/Default/retry_timeout_seconds
> /sys/fs/xfs/vdc/error/metadata
> /sys/fs/xfs/vdc/error/metadata/EIO
> /sys/fs/xfs/vdc/error/metadata/EIO/max_retries
> /sys/fs/xfs/vdc/error/metadata/EIO/failure_speed
> /sys/fs/xfs/vdc/error/metadata/EIO/fail_at_unmount
> /sys/fs/xfs/vdc/error/metadata/EIO/retry_timeout_seconds
> /sys/fs/xfs/vdc/error/metadata/ENODEV
> /sys/fs/xfs/vdc/error/metadata/ENODEV/max_retries
> /sys/fs/xfs/vdc/error/metadata/ENODEV/failure_speed
> /sys/fs/xfs/vdc/error/metadata/ENODEV/fail_at_unmount
> /sys/fs/xfs/vdc/error/metadata/ENODEV/retry_timeout_seconds
> /sys/fs/xfs/vdc/error/metadata/ENOSPC
> /sys/fs/xfs/vdc/error/metadata/ENOSPC/max_retries
> /sys/fs/xfs/vdc/error/metadata/ENOSPC/failure_speed
> /sys/fs/xfs/vdc/error/metadata/ENOSPC/fail_at_unmount
> /sys/fs/xfs/vdc/error/metadata/ENOSPC/retry_timeout_seconds
> /sys/fs/xfs/vdc/error/metadata/Default
> /sys/fs/xfs/vdc/error/metadata/Default/max_retries
> /sys/fs/xfs/vdc/error/metadata/Default/failure_speed
> /sys/fs/xfs/vdc/error/metadata/Default/fail_at_unmount
> /sys/fs/xfs/vdc/error/metadata/Default/retry_timeout_seconds
> $
> 

The error context isn't quite clear from this organization. It is
consistent and seems functionally sane from the code. I just wonder
whether users might get confused considering that some of these errors
can originate from the filesystem vs. the underlying device. Clearly
we're interested in the latter, but how is that evident from the sysfs
interface?

Maybe tweaking the class name would help clarify a bit. E.g.,
metadata_io..?

Brian

> Which shows the classes and error handlers, and how different
> classes can have different error handlers.
> 
> The patchset runs through xfstests without problems on the default
> configuration it sets. Note that the default config for the metadata
> class now sets "fail at unmount" so errors that have been retries
> indefinitely will fail at unmount and trigger a shutdown at that
> point. This is preferable to hanging unmount as currently happens.
> 
> Anyway, have a play, have a poke, and let me know what you think...
> 
> Cheers,
> 
> Dave.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
