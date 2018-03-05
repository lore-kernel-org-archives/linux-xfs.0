Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:24326 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752756AbeCEV5C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Mar 2018 16:57:02 -0500
Date: Tue, 6 Mar 2018 08:56:59 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] fsck.xfs: allow forced repairs using xfs_repair
Message-ID: <20180305215659.GE18129@dastard>
References: <20180305150546.32191-1-jtulak@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180305150546.32191-1-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs@vger.kernel.org, sandeen@sandeen.net

On Mon, Mar 05, 2018 at 04:05:46PM +0100, Jan Tulak wrote:
> The fsck.xfs script did nothing, because xfs doesn't need a fsck to be
> run on every unclean shutdown. However, sometimes it may happen that the
> root filesystem really requires the usage of xfs_repair and then it is a
> hassle. This patch makes the situation a bit easier by detecting forced
> checks (/forcefsck or fsck.mode=force), so user can require the repair,
> without the repair being run all the time.
> 
> (Thanks Eric for suggesting this.)
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>

Ok, so I can see why support for this is probably neecssary, I have
a few reservations about the implementation....

> ---
>  fsck/xfs_fsck.sh | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/fsck/xfs_fsck.sh b/fsck/xfs_fsck.sh
> index e52969e4..71bfa2e1 100755
> --- a/fsck/xfs_fsck.sh
> +++ b/fsck/xfs_fsck.sh
> @@ -4,10 +4,12 @@
>  #
>  
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
> @@ -15,10 +17,18 @@ if [ ! -e $DEV ]; then
>  	echo "$0: $DEV does not exist"
>  	exit 8
>  fi
> +
> +# The flag -f is added by systemd/init scripts when /forcefsck file is present
> +# or fsck.mode=force is used during boot; an unclean shutdown won't trigger
> +# this check, user has to explicitly require a forced fsck.
> +if $FORCE; then
> +	xfs_repair $DEV
> +	exit $?
> +fi

This needs to check that the xfs_repair binary is present in the
environment that is running fsck. If this is checking the root fs
from the initramfs, then distros are going to need to package
xfs_repair into their initramfs build scripts...

Also, if the log is dirty, xfs_repair won't run. If the filesystem
is already mounted read-only, xfs_repair won't run. So if we're
forcing a boot time check, we want it to run unconditionally and fix
any problems found automatically, right?

Also, fsck exit values have specific meaning to the boot
infrastructure and xfs_repair does not follow them. Hence returning
the output of xfs_repair to the fsck caller is going to result in
unexpected/undesired behaviour. From the fsck man page:

      The exit code returned by fsck is the sum of the following conditions:

              0      No errors
              1      Filesystem errors corrected
              2      System should be rebooted
              4      Filesystem errors left uncorrected
              8      Operational error
              16     Usage or syntax error
              32     Checking canceled by user request
              128    Shared-library error

So there's error post processing that is needed here so that the
infrastructure is given the correct status indication so it will
do things like reboot the system if necessary after a repair...

I also wonder if we can limit this to just the boot infrastructure,
because I really don't like the idea of users using fsck.xfs -f to
repair damage filesystems because "that's what I do to repair ext4
filesystems"....

Also missing is a fsck.xfs man page update to document the option.

>  if $AUTO; then
>  	echo "$0: XFS file system."
>  else
>  	echo "If you wish to check the consistency of an XFS filesystem or"
>  	echo "repair a damaged filesystem, see xfs_repair(8)."
>  fi
> -exit 0

I think we still need to exit with a zero status if we did nothing,
because that's what the caller is expecting....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
