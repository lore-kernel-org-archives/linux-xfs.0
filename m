Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2A15A7CA0
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2016 23:10:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F1338304032
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2016 21:09:58 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id q5Lu9R9sVc1sZGAC (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 21 Jul 2016 21:09:57 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id C03863E2CC
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2016 04:09:56 +0000 (UTC)
Date: Fri, 22 Jul 2016 12:09:55 +0800
From: Zorro Lang <zlang@redhat.com>
Subject: Re: [PATCH] xfs: Document error handling behavior
Message-ID: <20160722040955.GB16413@zlang.usersys.redhat.com>
References: <1468922657-3895-1-git-send-email-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1468922657-3895-1-git-send-email-cmaiolino@redhat.com>
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
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Jul 19, 2016 at 12:04:17PM +0200, Carlos Maiolino wrote:
> This is the first try to document the implementation of error handlers into
> sysfs.
> 
> Reviews and comments are appreciated, please also notice I'm not english-native,
> so, spelling corrections are also appreciated :)
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  Documentation/filesystems/xfs.txt | 78 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 78 insertions(+)
> 
> diff --git a/Documentation/filesystems/xfs.txt b/Documentation/filesystems/xfs.txt
> index 8146e9f..1df868a 100644
> --- a/Documentation/filesystems/xfs.txt
> +++ b/Documentation/filesystems/xfs.txt
> @@ -348,3 +348,81 @@ Removed Sysctls
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

Hi Carlos,

Could you explain more about the relationship of fail_at_unmount and
max_retries(/retry_timeout_seconds). For example, if I set fail_at_unmount=0,
and set EIO/max_retries=1, what's expected?

I'd like to write test case about this error handling, according to
your document.

Thanks,
Zorro

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
> +	"max_retries" takes precedence over "retry_timeout_seconds", where,
> +	"retry_timeout_seconds" will only be tested if the "max_retries" limit
> +	were not reached yet or is set to retry forever ("-1"). If "max_retries"
> +	limit is reached, the filesystem will shutdown, wether or not
> +	"retry_timeout_seconds" has been reached.
> -- 
> 2.7.4
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
