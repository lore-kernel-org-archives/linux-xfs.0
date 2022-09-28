Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BFDDC04A95
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Sep 2022 05:28:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbiI1F21 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Sep 2022 01:28:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbiI1F20 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Sep 2022 01:28:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 813001CE17E
        for <linux-xfs@vger.kernel.org>; Tue, 27 Sep 2022 22:28:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CCEA761D07
        for <linux-xfs@vger.kernel.org>; Wed, 28 Sep 2022 05:28:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C0B6C433D6;
        Wed, 28 Sep 2022 05:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664342904;
        bh=vw4elpFDxpQRQpiNqPwhf/U724dC1IxE0A+phxCcrac=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g/I/Jn/blm+t12fPpp7XExJvBGnr5Qg8yxSX4bKC+yYzcWZGVnxgaswRNnYdTbQmi
         XsO/Db2x/isbMUMF4yHFkNEpPP1pDw9ozZHJGNq21pXH7qIQ3iJggryF4BMmQnB4XW
         kD0qzUD2N3/b9yEiCahtCs13WGgvT/6jHue2cxj7nxRlWJEDPXvzMmWYT/dUhfoniP
         4+z2wZNG0T2hlFmIYKAXKvjeilqnTrVYJeNXbl6+OcIpWDWUf8e2Dv2HCT8ux72feP
         IppxpSJsy9zc04Iivk+SehsXz/vmF3cF5LCYMRm/aRoGEU3wHznGsEOt78lTlhlN4M
         DFxL0PYF6ESGA==
Date:   Tue, 27 Sep 2022 22:28:23 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Jan Tulak <jtulak@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2 v6] fsck.xfs: allow forced repairs using xfs_repair
Message-ID: <YzPbd1nbb30Wd8ji@magnolia>
References: <20180316170720.44227-1-jtulak@redhat.com>
 <20180323143313.31277-1-jtulak@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180323143313.31277-1-jtulak@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 23, 2018 at 03:33:13PM +0100, Jan Tulak wrote:
> The fsck.xfs script did nothing, because xfs doesn't need a fsck to be
> run on every unclean shutdown. However, sometimes it may happen that the
> root filesystem really requires the usage of xfs_repair and then it is a
> hassle. This patch makes the situation a bit easier by detecting forced
> checks (/forcefsck or fsck.mode=force) and invoking xfs_repair.
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> 
> ---
> Changelog:
> v6:
> - update exit code 3->4
> - avoid hardcoding xfs_repair path
> - rename $BIN->$xfs_repair
> - remove mounted check - xfs_repair does it on its own
> - small manpage edit
> - better explanation in the comment
> v5:
> - Change the message for xfs_repair code 2
> v4:
> - man page changes
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
>  fsck/xfs_fsck.sh    | 57 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  man/man8/fsck.xfs.8 |  7 +++++++
>  2 files changed, 63 insertions(+), 1 deletion(-)
> 
> diff --git a/fsck/xfs_fsck.sh b/fsck/xfs_fsck.sh
> index e52969e4..c9fc3eb3 100755
> --- a/fsck/xfs_fsck.sh
> +++ b/fsck/xfs_fsck.sh
> @@ -3,11 +3,35 @@
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
> +	4)  return 1 # The fs has been fixed
> +		;;
> +	*)  echo "$NAME error: An unknown return code from xfs_repair '$1'" 1>&2
> +		return 4 # something went wrong with xfs_repair
> +	esac
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
> @@ -15,6 +39,37 @@ if [ ! -e $DEV ]; then
>  	echo "$0: $DEV does not exist"
>  	exit 8
>  fi
> +
> +# The flag -f is added by systemd/init scripts when /forcefsck file is present
> +# or fsck.mode=force is used during boot; an unclean shutdown won't trigger
> +# this check, user has to explicitly require a forced fsck.
> +# But first of all, test if it is a non-interactive session.
> +# Invoking xfs_repair via fsck.xfs is only intended to happen via initscripts.
> +# Normal administrative filesystem repairs should always invoke xfs_repair
> +# directly.
> +#
> +# Use multiple methods to capture most of the cases:
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
> +	XFS_REPAIR=`command -v xfs_repair`
> +	if [ ! -x "$XFS_REPAIR" ] ; then
> +		echo "$NAME error: xfs_repair was not found!" 1>&2
> +		exit 4
> +	fi
> +
> +	$XFS_REPAIR -e $DEV
> +	repair2fsck_code $?

Just to reopen years-old discussions --

Recently, a customer decided to add "fsck.mode=force" to the kernel
command line to force systemd to fsck the rootfs on boot.  They
performed a powerfail simulation, and on next boot they were dropped to
an emergency shell because the log was dirty and xfs_repair returned a
nonzero error code.  If the system was rebooted cleanly then xfs_repair
rebuilds the space metadata and exits quietly.

Earlier in this thread we decided not to do a mount/umount cycle to
clear a dirty log for fear that the mount could crash the kernel.  Would
anyone like to entertain the idea of adding that cycle to fsck.xfs if
the program argv includes '-y' and xfs_repair returns 2?  That would
only happen if the sysadmin *also* adds "fsck.repair=yes" to the kernel
command line.

Omitting a fsck.repair= setting means systemd passes -a to fsck instead
of -y.

--D

> +	exit $?
> +fi
> +
>  if $AUTO; then
>  	echo "$0: XFS file system."
>  else
> diff --git a/man/man8/fsck.xfs.8 b/man/man8/fsck.xfs.8
> index ace7252d..a51baf7c 100644
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
> +at boot time by creating a /forcefsck file or booting the system with
> +"fsck.mode=force" on the kernel command line.
>  .
>  .SH FILES
>  .IR /etc/fstab .
> -- 
> 2.16.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
