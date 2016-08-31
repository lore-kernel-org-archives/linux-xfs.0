Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 448B87CA0
	for <xfs@oss.sgi.com>; Wed, 31 Aug 2016 04:49:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DF8C6304032
	for <xfs@oss.sgi.com>; Wed, 31 Aug 2016 02:49:37 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Lz6OkoPXGPLIxd0I (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 31 Aug 2016 02:49:36 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id AAFC790E54
	for <xfs@oss.sgi.com>; Wed, 31 Aug 2016 09:49:35 +0000 (UTC)
Received: from redhat.com (gfs-i24c-02.mpc.lab.eng.bos.redhat.com
	[10.16.144.214])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u7V9nXUi001666
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>; Wed, 31 Aug 2016 05:49:35 -0400
Date: Wed, 31 Aug 2016 05:49:33 -0400
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs: Document error handlers behavior [V2]
Message-ID: <20160831094933.GC54371@redhat.com>
References: <1470734124-65204-1-git-send-email-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1470734124-65204-1-git-send-email-cmaiolino@redhat.com>
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
To: xfs@oss.sgi.com

Hi folks, any comments on this?

Cheers

On Tue, Aug 09, 2016 at 05:15:24AM -0400, Carlos Maiolino wrote:
> Document the implementation of error handlers into sysfs.
> 
> Changelog:
> 
> V2:
> 	- Add a description of the precedence order of each option, focusing on
> 	  the behavior of "fail_at_unmount" which was not well explained in V1
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  Documentation/filesystems/xfs.txt | 94 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 94 insertions(+)
> 
> diff --git a/Documentation/filesystems/xfs.txt b/Documentation/filesystems/xfs.txt
> index 8146e9f..d483e0b 100644
> --- a/Documentation/filesystems/xfs.txt
> +++ b/Documentation/filesystems/xfs.txt
> @@ -348,3 +348,97 @@ Removed Sysctls
>    ----				-------
>    fs.xfs.xfsbufd_centisec	v4.0
>    fs.xfs.age_buffer_centisecs	v4.0
> +
> +Error handling
> +==============
> +
> +XFS can act differently according with the type of error found
> +during its operation. The implementation introduces the following
> +concepts to the error handler:
> +
> + -failure speed:
> +	Defines how fast XFS should shutdown in case of a specific
> +	error is found during the filesystem  operation. It can
> +	shutdown immediately, after a defined number of tries, or
> +	simply try forever, which was the old behavior and is now
> +	set as default behavior, except during unmount time, where
> +	in case of a error is found while unmounting, the filesystem
> +	will shutdown.
> +
> + -error classes:
> +	Specifies the subsystem/location where the error handlers
> +	configure the behavior for, such as metadata or memory allocation.
> +
> + -error handlers:
> +	Defines the behavior for a specific error.
> +
> +The filesystem behavior during an error can be set via sysfs files, where, the
> +errors are organized with the following structure:
> +
> +  /sys/fs/xfs/<dev>/error/<class>/<error>/
> +
> +Each directory contains:
> +
> + /sys/fs/xfs/<dev>/error/
> +
> +	fail_at_unmount		(Min:  0  Default:  1  Max: 1)
> +		Defines the global error behavior during unmount time. If set to
> +		"1", XFS will shutdown in case of any error is found, otherwise,
> +		if set to "0", the filesystem will indefinitely retry to cleanly
> +		unmount the filesystem.
> +
> +	<class> subdirectories
> +		Contains specific error handlers configuration
> +		(Ex: /sys/fs/xfs/<dev>/error/metadata).
> +
> + /sys/fs/xfs/<dev>/error/<class>/
> +
> +	The contents of this directory are <class> specific, since each <class>
> +	might need to handle different types of errors. All <error> directory
> +	though, contains the "default" directory, which is a global configuration
> +	for errors not available for independent configuration.
> +
> + /sys/fs/xfs/<dev>/error/<class>/<error>
> +
> +	Contains the failure speed configuration files for each specific error,
> +	including the "default" behavior, which contains the same configuration
> +	options as the specific errors.
> +
> +	The available configurations for each error type are:
> +
> +	max_retries			(Min: -1  Default: -1  Max: INTMAX)
> +		Define how many tries the filesystem is allowed to retry its
> +		operations during the specific error, before shutdown the
> +		filesystem. Setting this file to "-1", will set XFS to retry
> +		forever in the specific error, setting it to "0", will make
> +		XFS to fail immediately after the specific error is found,
> +		while setting it to a "N" value, where N is greater than 0,
> +		will make XFS retry "N" times before shutdown.
> +
> +	retry_timeout_seconds		(Min:  0  Default:  0  Max: INTMAX)
> +		Define the amount of time (in seconds) that the filesystem is
> +		allowed to retry its operations when the specific error is
> +		found. "0" means no wait time.
> +
> +
> +
> + Order of precedence:
> +		"max_retries" takes precedence over "retry_timeout_seconds",
> +		where, "retry_timeout_seconds" will only be tested if
> +		"max_retries" limit was not reached yet or is set to retry
> +		forever ("-1"). If "max_retries" limit is reached, the
> +		filesystem will shutdown, wether or not "retry_timeout_seconds"
> +		has been reached.
> +
> +		"fail_at_unmount" on the other hand, works independently of the
> +		remainder options. It will only be tested during unmount time,
> +		but, it will shutdown the filesystem independent of the limits
> +		set into "max_retries" or "retry_timeout_seconds".
> +		It has been added because sysfs configuration can't be changed
> +		after an unmount is triggered, once the sysfs directory from
> +		the filesystem being unmounted will be detached from the sysfs
> +		tree, so, even if the sysadmin wants to make XFS retry forever
> +		for any error during the filesystem operation, the filesystem
> +		can still be properly unmounted if any error was detected and
> +		"fail_at_unmount" is set. Otherwise, the umount process get
> +		stuck forever.
> -- 
> 2.5.5
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
