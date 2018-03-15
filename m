Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:33340 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751864AbeCOSMS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Mar 2018 14:12:18 -0400
Date: Thu, 15 Mar 2018 11:11:20 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/2] fsck.xfs: allow forced repairs using xfs_repair
Message-ID: <20180315181120.GA4865@magnolia>
References: <20180315174745.34308-1-jtulak@redhat.com>
 <20180315175026.34779-1-jtulak@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180315175026.34779-1-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Mar 15, 2018 at 06:50:26PM +0100, Jan Tulak wrote:
> The fsck.xfs script did nothing, because xfs doesn't need a fsck to be
> run on every unclean shutdown. However, sometimes it may happen that the
> root filesystem really requires the usage of xfs_repair and then it is a
> hassle. This patch makes the situation a bit easier by detecting forced
> checks (/forcefsck or fsck.mode=force), so user can require the repair,
> without the repair being run all the time.
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> 
> ---
> Changelog:
> v3:
> - too quick with fixing in v2... add line at the end of the file
> v2:
> - return the "exit 0" at the end
> 
> v1:
> - test for xfs_repair binary
> - run only in non-interactive session
> - translate xfs_repair return codes to fsck ones
> - run only if the filesystem is not mounted
> - add manpage update
> ---
>  fsck/xfs_fsck.sh    | 65 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  man/man8/fsck.xfs.8 | 12 +++++++++-
>  2 files changed, 75 insertions(+), 2 deletions(-)
> 
> diff --git a/fsck/xfs_fsck.sh b/fsck/xfs_fsck.sh
> index e52969e4..0ec6b049 100755
> --- a/fsck/xfs_fsck.sh
> +++ b/fsck/xfs_fsck.sh
> @@ -3,11 +3,42 @@
>  # Copyright (c) 2006 Silicon Graphics, Inc.  All Rights Reserved.
>  #
>  
> +NAME=$0
> +
> +# get the right return code for fsck
> +function repair2fsck_code() {
> +	case $1 in
> +	0)  return 0 # everything is ok
> +		;;
> +	1)  echo "$NAME error: xfs_repair could not fix the filesystem." 1>&2
> +		return 4 # errors left uncorrected
> +		;;
> +	2)  echo "$NAME error: The filesystem to be checked must not be mounted." 1>&2
> +		return 4 # it should not me mounted during boot, something is wrong
> +		;;
> +	3)  return 1 # The fs has been fixed
> +		;;
> +	*)  echo "$NAME error: An unknown return code from xfs_repair '$1'" 1>&2
> +		return 4 # something went wrong with xfs_repair
> +	esac
> +}
> +
> +function ensure_not_mounted() {
> +	local dev=$1
> +	mounted=`grep -c "^$dev " /proc/mounts`
> +	if [ $mounted -ne 0 ]; then
> +		echo "$NAME error: The filesystem to be checked must not be mounted." 1>&2
> +		exit 4
> +	fi
> +}
> +
>  AUTO=false
> -while getopts ":aApy" c
> +FORCE=false
> +while getopts ":aApyf" c
>  do
>  	case $c in
>  	a|A|p|y)	AUTO=true;;
> +	f)      	FORCE=true;;
>  	esac
>  done
>  eval DEV=\${$#}
> @@ -15,6 +46,38 @@ if [ ! -e $DEV ]; then
>  	echo "$0: $DEV does not exist"
>  	exit 8
>  fi
> +
> +# The flag -f is added by systemd/init scripts when /forcefsck file is present
> +# or fsck.mode=force is used during boot; an unclean shutdown won't trigger
> +# this check, user has to explicitly require a forced fsck.
> +# But first of all, test if it is a non-interactive session. Use multiple
> +# methods to capture most of the cases:
> +# The case for *i* and -n "$PS1" are commonly suggested in bash manual
> +# and the -t 0 test checks stdin
> +case $- in
> +	*i*) FORCE=false ;;
> +esac
> +if [ -n "$PS1" -o -t 0 ]; then
> +	FORCE=false
> +fi
> +
> +if $FORCE; then
> +	if [ -f /sbin/xfs_repair ]; then
> +		BIN="/sbin/xfs_repair"
> +	elif [ -f /usr/sbin/xfs_repair ]; then
> +		BIN="/usr/sbin/xfs_repair"

Can we just run xfs_repair and assume it's in the PATH?

> +	else
> +		echo "$NAME error: xfs_repair was not found!" 1>&2
> +		exit 4
> +	fi
> +
> +	ensure_not_mounted $DEV
> +
> +	$BIN -e $DEV
> +	repair2fsck_code $?
> +	exit $?
> +fi
> +
>  if $AUTO; then
>  	echo "$0: XFS file system."
>  else
> diff --git a/man/man8/fsck.xfs.8 b/man/man8/fsck.xfs.8
> index ace7252d..3eb3ad7f 100644
> --- a/man/man8/fsck.xfs.8
> +++ b/man/man8/fsck.xfs.8
> @@ -1,6 +1,6 @@
>  .TH fsck.xfs 8
>  .SH NAME
> -fsck.xfs \- do nothing, successfully
> +fsck.xfs \- do nothing, successfuly

successfully has two 'l'.

>  .SH SYNOPSIS
>  .B fsck.xfs
>  [
> @@ -21,6 +21,16 @@ If you wish to check the consistency of an XFS filesystem,
>  or repair a damaged or corrupt XFS filesystem,
>  see
>  .BR xfs_repair (8).
> +.PP
> +However, it may happen that a forced repair is required and in makes sense to start
> +.BR xfs_repair (8)
> +on startup (either using /forcefsck file or fsck.mode=force kernel option). In this case
> +.B fsck.xfs
> +run
> +.B xfs_repair
> +for the user. But if run outside of boot environment or without the
> +.B -f
> +option, it does nothing.

Bleh, I hate manpages.  I'll just ... do this without the formatting.

However, the system administrator can force fsck.xfs to run
xfs_repair(8) by creating a /forcefsck file, booting the system with
"fsck.mode=force" on the kernel command line, or by running fsck.xfs -f.

--D

>  .
>  .SH FILES
>  .IR /etc/fstab .
> -- 
> 2.15.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
