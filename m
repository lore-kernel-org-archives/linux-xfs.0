Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:45276 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966100AbcIHO3U (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 8 Sep 2016 10:29:20 -0400
Subject: Re: [PATCH] xfs: Document error handlers behavior
References: <1473326635-30209-1-git-send-email-cmaiolino@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <15083dbd-d598-0ec1-25d7-26cb039dd78d@sandeen.net>
Date: Thu, 8 Sep 2016 09:29:18 -0500
MIME-Version: 1.0
In-Reply-To: <1473326635-30209-1-git-send-email-cmaiolino@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org, xfs@oss.sgi.com

On 9/8/16 4:23 AM, Carlos Maiolino wrote:
> Document the implementation of error handlers into sysfs.
> 
> Changelog:
> 
> V2:
> 	- Add a description of the precedence order of each option, focusing on
> 	  the behavior of "fail_at_unmount" which was not well explained in V1
> 
> V3:
> 	- Fix English spelling mistakes suggested by Eric

Please put the patch version changelog after the "---" so it doesn't become
part of the permanent commit log; it's for current patch reviewers, not for
future code archaeologists.

> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  Documentation/filesystems/xfs.txt | 70 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 70 insertions(+)
> 
> diff --git a/Documentation/filesystems/xfs.txt b/Documentation/filesystems/xfs.txt
> index 8146e9f..8b6c861 100644
> --- a/Documentation/filesystems/xfs.txt
> +++ b/Documentation/filesystems/xfs.txt
> @@ -348,3 +348,73 @@ Removed Sysctls
>    ----				-------
>    fs.xfs.xfsbufd_centisec	v4.0
>    fs.xfs.age_buffer_centisecs	v4.0
> +
> +Error handling
> +==============
> +
> +XFS can act differently according to the type of error found
> +during its operation. The implementation introduces the following
> +concepts to the error handler:
> +
> + -failure speed:
> +	Defines how fast XFS should shut down when of a specific error is found

when a specific error is found

> +	during the filesystem operation. It can shut down immediately, after a
> +	defined number of retries, after a set time period, or simply retry
> +	forever. The old "retry forever" behavior is still the default, except
> +	during unmount, where any IOs retrying due to errors will be cancelled
> +	and unmount will be allowed to proceed.
> +
> + -error classes:
> +	Specifies the subsystem/location where the error handlers, such as

location of the error handlers

> +	metadata or memory allocation. Only metadata IO errors are handled
> +	at this time.
> +
> + -error handlers:
> +	Defines the behavior for a specific error.
> +
> +The filesystem behavior during an error can be set via sysfs files, where the
> +errors are organized with the structure below. Each configuration option works
> +independently, the first condition met for a specific configuration will cause
> +the filesystem to shut down:
> +
> +  /sys/fs/xfs/<dev>/error/<class>/<error>/

The above line kind of hangs there oddly, because the first thing you do below
is describe a file which isn't in the above hierarchy.

Maybe we should show something like:

+  /sys/fs/xfs/<dev>/error/fail_at_unmount
+  /sys/fs/xfs/<dev>/error/<class>/<error>/<configuration>

to show everything that might be under it?  Not sure if that's better.

> +
> +Each directory contains:
> +
> + /sys/fs/xfs/<dev>/error/
> +
> +	fail_at_unmount		(Min:  0  Default:  1  Max: 1)
> +		Defines the global error behavior at unmount time. If set to the
> +		default value of 1, XFS will cancel any pending IO retries, shut
> +		down, and unmount. If set to 0, pending IO retries may prevent
> +		the filesystem from unmounting.
> +
> +	<class> subdirectories
> +		Contains specific error handlers configuration
> +		(Ex: /sys/fs/xfs/<dev>/error/metadata, see below).
> +
> + /sys/fs/xfs/<dev>/error/<class>/
> +
> +	Directory containing configuration for a specific error <class>;
> +	currently only the "metadata" <class> is implemented.
> +	The contents of this directory are <class> specific, since each <class>
> +	might need to handle different types of errors.
> +
> + /sys/fs/xfs/<dev>/error/<class>/<error>/
> +
> +	Contains the failure speed configuration files for specific errors in
> +	this <class, as well as a "default" behavior. Each <error> directory

<class>

> +	contains the following configuration files:
> +
> +	max_retries			(Min: -1  Default: -1  Max: INTMAX)
> +		Defines the allowed number of retries of a specific error before
> +		the filesystem will shut down.  The default value of "-1" will
> +		cause XFS to retry forever for this specific error.  Setting it
> +		to "0" will cause XFS to fail immediately when the specific
> +		error is found, and setting it to "N," where N is greater than 0,
> +		will make XFS retry "N" times before shutting down.
> +
> +	retry_timeout_seconds		(Min:  0  Default:  0  Max: INTMAX)
> +		Define the amount of time (in seconds) that the filesystem is
> +		allowed to retry its operations when the specific error is
> +		found. The default value of "0" will cause XFS to retry forever.

The default for ENODEV is different ... tricky to document that.  Good luck.  ;)

The maximum for retry_timeout_seconds is 86400 (1 day), not INTMAX:

retry_timeout_seconds_store()
{
...
        /* 1 day timeout maximum */
        if (val < 0 || val > 86400)
                return -EINVAL;
...
}

The default of -1 vs. 0 might change with the other patch I sent, but we can
fix this up if it's accepted.

-Eric

