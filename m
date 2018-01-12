Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:56634 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932538AbeALByA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Jan 2018 20:54:00 -0500
Date: Thu, 11 Jan 2018 17:53:54 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 03/27] xfs_scrub: set up command line argument parsing
Message-ID: <20180112015354.GT5602@magnolia>
References: <151520348769.2027.9860697266310422360.stgit@magnolia>
 <151520350632.2027.11272777646597420008.stgit@magnolia>
 <08489be1-3567-2e14-5520-e28c2eaf81fd@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <08489be1-3567-2e14-5520-e28c2eaf81fd@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Thu, Jan 11, 2018 at 05:39:38PM -0600, Eric Sandeen wrote:
> On 1/5/18 7:51 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Parse command line options in order to set up the context in which we
> > will scrub the filesystem.
> 
> 
> > +static void __attribute__((noreturn))
> > +usage(void)
> > +{
> > +	fprintf(stderr, _("Usage: %s [OPTIONS] mountpoint\n"), progname);
> > +	fprintf(stderr, _("-a:\tStop after this many errors are found.\n"));
> > +	fprintf(stderr, _("-b:\tBackground mode.\n"));
> 
> do you intentionally not document -d?
> <same question for manpage>

Debug mode, so yes.

> > +	fprintf(stderr, _("-e:\tWhat to do if errors are found.\n"));
> > +	fprintf(stderr, _("-m:\tPath to /etc/mtab.\n"));
> > +	fprintf(stderr, _("-n:\tDry run.  Do not modify anything.\n"));
> > +	fprintf(stderr, _("-T:\tDisplay timing/usage information.\n"));
> > +	fprintf(stderr, _("-v:\tVerbose output.\n"));
> > +	fprintf(stderr, _("-V:\tPrint version.\n"));
> > +	fprintf(stderr, _("-x:\tScrub file data too.\n"));
> > +	fprintf(stderr, _("-y:\tRepair all errors.\n"));
> > +
> > +	exit(16);
> > +}
> 
> Could we make this more like xfs_repair usage() for consistency?
> 
> Usage: xfs_repair [options] device
> 
> Options:
>   -f           The device is a file
>   -L           Force log zeroing. Do this as a last resort.
>   -l logdev    Specifies the device where the external log resides.
>   -m maxmem    Maximum amount of memory to be used in megabytes.
>   -n           No modify mode, just checks the filesystem for damage.
>   -P           Disables prefetching.
>   -r rtdev     Specifies the device where the realtime section resides.
>   -v           Verbose output.
>   -c subopts   Change filesystem parameters - use xfs_admin.
>   -o subopts   Override default behaviour, refer to man page.
>   -t interval  Reporting interval in seconds.
>   -d           Repair dangerously.
>   -V           Reports version and exits.
> 
> so maybe:
> 
> Usage: xfs_scrub [options] mountpoint
> 
>   -a count	Stop after this many errors are found.
>   -b		Background mode.
>   -C fd		Print progress information to this fd.
>   -e behavior	What to do if errors are found. (shutdown|continue)
>   -m path	Path to /etc/mtab.
>   -n		Dry run.  Do not modify anything.
>   -T		Display timing/usage information.
>   -v		Verbose output.
>   -V		Reports version and exits.
>   -x		Scrub file data too.
>   -y		Repair all errors.

Ok.  Assuming you meant to indent everything by two spaces and make it
obvious which switches take parameters.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
