Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:35114 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751624AbeDKA2Q (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 10 Apr 2018 20:28:16 -0400
Subject: Re: [PATCH 11/14] xfs_scrub_all: report version
References: <152160358015.8288.2700156777231657519.stgit@magnolia>
 <152160364815.8288.2405559533299403970.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <de78d4fd-bba4-6df3-2e9f-bb9493621b71@sandeen.net>
Date: Tue, 10 Apr 2018 19:28:15 -0500
MIME-Version: 1.0
In-Reply-To: <152160364815.8288.2405559533299403970.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 3/20/18 10:40 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Make xfs_scrub_all -V report its version like the other xfs tools.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  man/man8/xfs_scrub_all.8 |   10 ++++++++++
>  scrub/Makefile           |    1 +
>  scrub/xfs_scrub_all.in   |   11 +++++++++++
>  3 files changed, 22 insertions(+)
> 
> 
> diff --git a/man/man8/xfs_scrub_all.8 b/man/man8/xfs_scrub_all.8
> index 5e1420b..7454880 100644
> --- a/man/man8/xfs_scrub_all.8
> +++ b/man/man8/xfs_scrub_all.8
> @@ -3,6 +3,9 @@
>  xfs_scrub_all \- scrub all mounted XFS filesystems
>  .SH SYNOPSIS
>  .B xfs_scrub_all
> +[
> +.B \-hV
> +]
>  .SH DESCRIPTION
>  .B xfs_scrub_all
>  attempts to read and check all the metadata on all mounted XFS filesystems.
> @@ -13,6 +16,13 @@ in a restricted fashion.
>  Mounted filesystems are mapped to physical storage devices so that scrub
>  operations can be run in parallel so long as no two scrubbers access
>  the same device simultaneously.
> +.SH OPTIONS
> +.TP
> +.B \-h
> +Display help.
> +.TP
> +.B \-V
> +Prints the version number and exits.
>  .SH EXIT CODE
>  The exit code returned by
>  .B xfs_scrub_all
> diff --git a/scrub/Makefile b/scrub/Makefile
> index bcc05a0..482e8a7 100644
> --- a/scrub/Makefile
> +++ b/scrub/Makefile
> @@ -102,6 +102,7 @@ default: depend $(LTCOMMAND) $(XFS_SCRUB_ALL_PROG) $(OPTIONAL_TARGETS)
>  xfs_scrub_all: xfs_scrub_all.in
>  	@echo "    [SED]    $@"
>  	$(Q)$(SED) -e "s|@sbindir@|$(PKG_ROOT_SBIN_DIR)|g" \
> +		   -e "s|@pkg_version@|$(PKG_VERSION)|g" \
>  		   -e "s|@scrub_args@|$(XFS_SCRUB_ARGS)|g" < $< > $@
>  	$(Q)chmod a+x $@
>  
> diff --git a/scrub/xfs_scrub_all.in b/scrub/xfs_scrub_all.in
> index 80f07d5..aed66a1 100644
> --- a/scrub/xfs_scrub_all.in
> +++ b/scrub/xfs_scrub_all.in
> @@ -26,6 +26,7 @@ import threading
>  import time
>  import sys
>  import os
> +import argparse
>  
>  retcode = 0
>  terminate = False
> @@ -139,6 +140,16 @@ def main():
>  		thr.start()
>  	global retcode, terminate
>  
> +	parser = argparse.ArgumentParser( \
> +			description = "Scrub all mounted XFS filesystems.")
> +	parser.add_argument("-V", help = "Report version and exit.", \
> +			action = "store_true")
> +	args = parser.parse_args()
> +
> +	if args.V:
> +		print("xfs_scrub_all version @pkg_version@")
> +		sys.exit(0)
> +
>  	fs = find_mounts()
>  
>  	# Tail the journal if we ourselves aren't a service...
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
