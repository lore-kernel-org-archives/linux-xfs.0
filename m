Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6A5897CA0
	for <xfs@oss.sgi.com>; Wed, 14 Sep 2016 05:02:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3058530404E
	for <xfs@oss.sgi.com>; Wed, 14 Sep 2016 03:02:24 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 7r5RgH4GBOpgr8bf (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 14 Sep 2016 03:02:23 -0700 (PDT)
Date: Wed, 14 Sep 2016 12:02:19 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH V4] xfs: Document error handlers behavior
Message-ID: <20160914100219.5743534ofe6oktbb@redhat.com>
References: <1473757385-81633-1-git-send-email-cmaiolino@redhat.com>
	<20160914012334.GK30497@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160914012334.GK30497@dastard>
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
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

On Wed, Sep 14, 2016 at 11:23:34AM +1000, Dave Chinner wrote:
> Ok, I had to update this for the change in retry timeout values from
> Eric, so I went and fixed all the other things I thought needed
> fixing, too. New patch below....
> 

Hi, thanks, this looks good to me, with one exception described below.

> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> xfs: Document error handlers behavior
> 
> From: Carlos Maiolino <cmaiolino@redhat.com>
> 
> + -error handlers:
> +	Defines the behavior for a specific error.
> +
> +The filesystem behavior during an error can be set via sysfs files, Each
> +error handler works independently, the first condition met by and error handler
> +for a specific class will cause the error to be propagated rather than reset and
> +retried.
> +
> +The action taken by the filesystem when the error is propagated is context
> +dependent - it may cause a shut down in the case of an unrecoverable error,
> +it may be reported back to userspace, or it may even be ignored because
> +there's nothing useful we can with the error or anyone we can report it to (e.g.

"there's nothing useful we can do with the error"

> +during unmount).

Also, I apologize if I misunderstand it, but being ignored doesn't look a proper
description here, it sounds to me something like 'we ignore the error and tell
nobody about it", in unmount example, we shut down the filesystem if any error
happens, for me it doesn't sound like ignoring an error, but I might be
interpreting it in the wrong way.


> +
> +The configuration files are organized into the following per-mounted filesystem
> +hierarchy:
> +
> +  /sys/fs/xfs/<dev>/error/<class>/<error>/
> +
> +Where:
> +  <dev>
> +	The short device name of the mounted filesystem. This is the same device
> +	name that shows up in XFS kernel error messages as "XFS(<dev>): ..."
> +
> +  <class>
> +	The subsystem the error configuration belongs to. As of 4.9, the defined
> +	classes are:
> +
> +		- "metadata": applies metadata buffer write IO
> +
> +  <error>
> +	The individual error handler configurations.
> +
> +
> +Each filesystem has "global" error configuration options defined in their top
> +level directory:
> +
> +  /sys/fs/xfs/<dev>/error/
> +
> +  fail_at_unmount		(Min:  0  Default:  1  Max: 1)
> +	Defines the filesystem error behavior at unmount time.
> +
> +	If set to a value of 1, XFS will override all other error configurations
> +	during unmount and replace them with "immediate fail" characteristics.
> +	i.e. no retries, no retry timeout. This will always allow unmount to
> +	succeed when there are persistent errors present.
> +
> +	If set to 0, the configured retry behaviour will continue until all
> +	retries and/or timeouts have been exhausted. This will delay unmount
> +	completion when there are persistent errors, and it may prevent the
> +	filesystem from ever unmounting fully in the case of "retry forever"
> +	handler configurations.
> +
> +	Note: there is no guarantee that fail_at_unmount can be set whilst an
> +	unmount is in progress. It is possible that the sysfs entries are
> +	removed by the unmounting filesystem before a "retry forever" error
> +	handler configuration causes unmount to hang, and hence the filesystem
> +	must be configured appropriately before unmount begins to prevent
> +	unmount hangs.
> +
> +Each filesystem has specific error class handlers that define the error
> +propagation behaviour for specific errors. There is also a "default" error
> +handler defined, which defines the behaviour for all errors that don't have
> +specific handlers defined. The handler configurations are found in the
> +directory:
> +
> +  /sys/fs/xfs/<dev>/error/<class>/<error>/
> +
> +  max_retries			(Min: -1  Default: Varies  Max: INTMAX)
> +	Defines the allowed number of retries of a specific error before
> +	the filesystem will propagate the error. The retry count for a given
> +	error context (e.g. a specific metadata buffer) is reset ever time there
> +	is a successful completion of the operation.
> +
> +	Setting the value to "-1" will cause XFS to retry forever for this
> +	specific error.
> +
> +	Setting the value to "0" will cause XFS to fail immediately when the
> +	specific error is reported.
> +
> +	Setting the value to "N" (where 0 < N < Max) will make XFS retry the
> +	operation "N" times before propagating the error.
> +
> +  retry_timeout_seconds		(Min:  -1  Default:  Varies  Max: 1 day)
> +	Define the amount of time (in seconds) that the filesystem is
> +	allowed to retry its operations when the specific error is
> +	found.
> +
> +	Setting the value to "-1" will set an infinite timeout, causing
> +	error propagation behaviour to be determined solely by the "max_retries"
> +	parameter.
> +
> +	Setting the value to "0" will cause XFS to fail immediately when the
> +	specific error is reported.
> +
> +	Setting the value to  "N" (where 0 < N < Max) will propagate the error
> +	on the first retry that fails at least "N" seconds after the first error
> +	was detected, unless the number of retries defined by max_retries
> +	expires first.
> +
> +Note: The default behaviour for a specific error handler is dependent on both
> +the class and error context. For example, the default values for
> +"metadata/ENODEV" are "0" rather than "-1" so that this error handler defaults
> +to "fail immediately" behaviour. This is done because ENODEV is a fatal,
> +unrecoverable error no matter how many times the metadata IO is retried.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
