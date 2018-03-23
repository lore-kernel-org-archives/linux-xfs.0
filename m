Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:35096 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751667AbeCWChK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Mar 2018 22:37:10 -0400
Subject: Re: [PATCH 2/2 v5] fsck.xfs: allow forced repairs using xfs_repair
References: <20180315182850.36783-1-jtulak@redhat.com>
 <20180316170720.44227-1-jtulak@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <709ab06b-4efc-2925-6621-f17ed4c048c6@sandeen.net>
Date: Thu, 22 Mar 2018 21:37:08 -0500
MIME-Version: 1.0
In-Reply-To: <20180316170720.44227-1-jtulak@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>, linux-xfs@vger.kernel.org

On 3/16/18 12:07 PM, Jan Tulak wrote:
> The fsck.xfs script did nothing, because xfs doesn't need a fsck to be
> run on every unclean shutdown. However, sometimes it may happen that the
> root filesystem really requires the usage of xfs_repair and then it is a
> hassle. This patch makes the situation a bit easier by detecting forced
> checks (/forcefsck or fsck.mode=force)

and invoking xfs_repair.

(and then can strike the rest below)

>, so user can require the repair,
> without the repair being run all the time.
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> 
> ---
> Changelog:
> v5:
> - Change the message for xfs_repair code 2
> v4:
> - man page changes
> v3:
> - too quick with fixing in v2... add line at the end of the file
> v2:
> - return the "exit 0" at the end
> v1:
> - test for xfs_repair binary
> - run only in non-interactive session
> - translate xfs_repair return codes to fsck ones
> - run only if the filesystem is not mounted
> - add manpage update
> ---
>  fsck/xfs_fsck.sh    | 67 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  man/man8/fsck.xfs.8 |  7 ++++++
>  2 files changed, 73 insertions(+), 1 deletion(-)
> 
> diff --git a/fsck/xfs_fsck.sh b/fsck/xfs_fsck.sh
> index e52969e4..2ac09aeb 100755
> --- a/fsck/xfs_fsck.sh
> +++ b/fsck/xfs_fsck.sh
> @@ -3,11 +3,44 @@
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
> +	2)  echo "$NAME error: The filesystem log is dirty, mount it to recover" \
> +		     "the log. If that fails, refer to the section DIRTY LOGS in the" \
> +		     "xfs_repair manual page." 1>&2
> +		return 4 # dirty log, don't do anything and let the user solve it
> +		;;
> +	3)  return 1 # The fs has been fixed

(4, if patch 1/2 changes ...)

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

Is this necessary?  Doesn't xfs_repair already check this?

# xfs_repair /dev/loop0
xfs_repair: /dev/loop0 contains a mounted filesystem
xfs_repair: /dev/loop0 contains a mounted and writable filesystem

fatal error -- couldn't initialize XFS library

# echo $?
1

(script would then say "error: xfs_repair could not fix the filesystem."
and exit with 4.)

It might be nice to have the cleaner message above, but I wonder about
the wisdom and safety of hand-rolling another simplistic mount check in a bash
script.... thoughts?

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
> @@ -15,6 +48,38 @@ if [ ! -e $DEV ]; then
>  	echo "$0: $DEV does not exist"
>  	exit 8
>  fi
> +
> +# The flag -f is added by systemd/init scripts when /forcefsck file is present
> +# or fsck.mode=force is used during boot; an unclean shutdown won't trigger
> +# this check, user has to explicitly require a forced fsck.
> +# But first of all, test if it is a non-interactive session.

Let's say why, here:

"Invoking xfs_repair via fsck.xfs is only intended to happen via initscripts.
Normal administrative filesystem repairs should always invoke xfs_repair directly."

or something like that.

> Use multiple
> +# methods to capture most of the cases:
> +# The case for *i* and -n "$PS1" are commonly suggested in bash manual
> +# and the -t 0 test checks stdin
> +case $- in
> +	*i*) FORCE=false ;;
> +esac
> +if [ -n "$PS1" -o -t 0 ]; then
> +	FORCE=false
> +fi

Ok - I thought maybe we should be noisy about ignoring -f, but on
second thought, I like hiding it.

> +
> +if $FORCE; then
> +	if [ -f /sbin/xfs_repair ]; then
> +		BIN="/sbin/xfs_repair"
> +	elif [ -f /usr/sbin/xfs_repair ]; then
> +		BIN="/usr/sbin/xfs_repair"
> +	else
> +		echo "$NAME error: xfs_repair was not found!" 1>&2
> +		exit 4
> +	fi

Ok, similar question as Darrick had - why hardcode paths?  Seems reasonable
to assume that xfs_repair will be in the path, and who knows what the
path may be in any given initrd...

Could just do:

XFS_REPAIR=$(command -v xfs_repair)
if [ ! -x "$XFS_REPAIR" ] ; then
	echo "$NAME error: xfs_repair was not found!" 1>&2
	exit 4
fi

It make sense to check that it's available before running it, but I think
hardcoding paths runs the risk of missing it if it's somewhere unique.

> +
> +	ensure_not_mounted $DEV
> +
> +	$BIN -e $DEV

please rename $BIN as $XFS_REPAIR for clarity?

> +	repair2fsck_code $?
> +	exit $?
> +fi
> +
>  if $AUTO; then
>  	echo "$0: XFS file system."
>  else
> diff --git a/man/man8/fsck.xfs.8 b/man/man8/fsck.xfs.8
> index ace7252d..08812be8 100644
> --- a/man/man8/fsck.xfs.8
> +++ b/man/man8/fsck.xfs.8
> @@ -21,6 +21,13 @@ If you wish to check the consistency of an XFS filesystem,
>  or repair a damaged or corrupt XFS filesystem,
>  see
>  .BR xfs_repair (8).
> +.PP
> +However, the system administrator can force
> +.B fsck.xfs
> +to run
> +.BR xfs_repair (8)

at boot time

> +by creating a /forcefsck file or booting the system with
> +"fsck.mode=force" on the kernel command line.
>  .
>  .SH FILES
>  .IR /etc/fstab .
> 
