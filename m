Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:35952 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753558AbeAKXjk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Jan 2018 18:39:40 -0500
Subject: Re: [PATCH 03/27] xfs_scrub: set up command line argument parsing
References: <151520348769.2027.9860697266310422360.stgit@magnolia>
 <151520350632.2027.11272777646597420008.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <08489be1-3567-2e14-5520-e28c2eaf81fd@sandeen.net>
Date: Thu, 11 Jan 2018 17:39:38 -0600
MIME-Version: 1.0
In-Reply-To: <151520350632.2027.11272777646597420008.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 1/5/18 7:51 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Parse command line options in order to set up the context in which we
> will scrub the filesystem.


> +static void __attribute__((noreturn))
> +usage(void)
> +{
> +	fprintf(stderr, _("Usage: %s [OPTIONS] mountpoint\n"), progname);
> +	fprintf(stderr, _("-a:\tStop after this many errors are found.\n"));
> +	fprintf(stderr, _("-b:\tBackground mode.\n"));

do you intentionally not document -d?
<same question for manpage>

> +	fprintf(stderr, _("-e:\tWhat to do if errors are found.\n"));
> +	fprintf(stderr, _("-m:\tPath to /etc/mtab.\n"));
> +	fprintf(stderr, _("-n:\tDry run.  Do not modify anything.\n"));
> +	fprintf(stderr, _("-T:\tDisplay timing/usage information.\n"));
> +	fprintf(stderr, _("-v:\tVerbose output.\n"));
> +	fprintf(stderr, _("-V:\tPrint version.\n"));
> +	fprintf(stderr, _("-x:\tScrub file data too.\n"));
> +	fprintf(stderr, _("-y:\tRepair all errors.\n"));
> +
> +	exit(16);
> +}

Could we make this more like xfs_repair usage() for consistency?

Usage: xfs_repair [options] device

Options:
  -f           The device is a file
  -L           Force log zeroing. Do this as a last resort.
  -l logdev    Specifies the device where the external log resides.
  -m maxmem    Maximum amount of memory to be used in megabytes.
  -n           No modify mode, just checks the filesystem for damage.
  -P           Disables prefetching.
  -r rtdev     Specifies the device where the realtime section resides.
  -v           Verbose output.
  -c subopts   Change filesystem parameters - use xfs_admin.
  -o subopts   Override default behaviour, refer to man page.
  -t interval  Reporting interval in seconds.
  -d           Repair dangerously.
  -V           Reports version and exits.

so maybe:

Usage: xfs_scrub [options] mountpoint

  -a count	Stop after this many errors are found.
  -b		Background mode.
  -C fd		Print progress information to this fd.
  -e behavior	What to do if errors are found. (shutdown|continue)
  -m path	Path to /etc/mtab.
  -n		Dry run.  Do not modify anything.
  -T		Display timing/usage information.
  -v		Verbose output.
  -V		Reports version and exits.
  -x		Scrub file data too.
  -y		Repair all errors.
