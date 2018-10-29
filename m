Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:50402 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725920AbeJ3B4m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Oct 2018 21:56:42 -0400
Date: Mon, 29 Oct 2018 10:07:00 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs_db: add crc32 self test
Message-ID: <20181029170700.GA4135@magnolia>
References: <20181023155701.GD28243@magnolia>
 <ac96e362-a298-b171-ccc6-5fb22907c786@sandeen.net>
 <20181026201628.GJ28243@magnolia>
 <1bd96482-8901-365b-a16e-e3fefeea4ec3@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1bd96482-8901-365b-a16e-e3fefeea4ec3@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>

On Mon, Oct 29, 2018 at 11:28:53AM -0500, Eric Sandeen wrote:
> 
> 
> On 10/26/18 3:16 PM, Darrick J. Wong wrote:
> > On Fri, Oct 26, 2018 at 03:06:06PM -0500, Eric Sandeen wrote:
> >> On 10/23/18 10:57 AM, Darrick J. Wong wrote:
> >>> From: Darrick J. Wong <darrick.wong@oracle.com>
> >>>
> >>> Add a self test for crc32 into xfs_db so that xfstests can check the
> >>> operation of the (potentially cross-compiled) package binaries by
> >>> isolating the self test code to a header file that can be included by
> >>> the build system self test and xfs_db.
> >>>
> >>> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> >>> ---
> >>>  db/command.c            |    1 
> >>>  db/crc.c                |   36 ++
> >>>  db/crc.h                |    1 
> >>>  include/crc32selftest.h |  706 +++++++++++++++++++++++++++++++++++++++++++++++
> >>>  libfrog/crc32.c         |  669 ---------------------------------------------
> >>>  man/man8/xfs_db.8       |    5 
> >>>  6 files changed, 750 insertions(+), 668 deletions(-)
> >>>  create mode 100644 include/crc32selftest.h
> >>>
> >>> diff --git a/db/command.c b/db/command.c
> >>> index c7c52342..7b727986 100644
> >>> --- a/db/command.c
> >>> +++ b/db/command.c
> >>> @@ -139,4 +139,5 @@ init_commands(void)
> >>>  	write_init();
> >>>  	dquot_init();
> >>>  	fuzz_init();
> >>> +	crc32selftest_init();
> >>>  }
> >>> diff --git a/db/crc.c b/db/crc.c
> >>> index b6775bc7..93745003 100644
> >>> --- a/db/crc.c
> >>> +++ b/db/crc.c
> >>> @@ -17,6 +17,7 @@
> >>>  #include "output.h"
> >>>  #include "bit.h"
> >>>  #include "print.h"
> >>> +#include "crc32selftest.h"
> >>>  
> >>>  static int crc_f(int argc, char **argv);
> >>>  static void crc_help(void);
> >>> @@ -175,3 +176,38 @@ crc_f(
> >>>  	flist_free(fl);
> >>>  	return 0;
> >>>  }
> >>> +
> >>> +static int
> >>> +crc32selftest_f(
> >>> +	int		argc,
> >>> +	char		**argv)
> >>> +{
> >>> +	int		c;
> >>> +	int		errors;
> >>> +
> >>> +	while ((c = getopt(argc, argv, "")) != EOF) {
> >>> +		switch (c) {
> >>> +		default:
> >>> +			dbprintf(_("Bad option for crc32selftest command.\n"));
> >>> +			return 0;
> >>> +		}
> >>> +	}
> >>> +
> >>> +	if (argc != optind) {
> >>> +		dbprintf(_("The crc32selftest command takes no arguments.\n"));
> >>> +		return 0;
> >>> +	}
> >>
> >> Isn't this redundant w/ the first "Bad option" message - can we even 
> >> get here?
> > 
> > Hmm, I guess not.
> > 
> >>> +
> >>> +	errors = crc32c_test();
> >>> +	return errors == 0 ? 0 : 1;
> >>
> >> Oh, ok, it can return number of errors, fine.
> > 
> > We might as well stop if crc32 is broken. :)
> 
> Ok, so I think the way this is structured is a bit weird.
> 
> We have to specify a device even though it's not used for
> this command:
> 
> # xfs_db -x -c crc32selftest
> Usage: xfs_db [-ifFrxV] [-p prog] [-l logdev] [-c cmd]... device
> 
> Also, patching to return a forced error still returns 1 on the xfs_db cmdline:
> 
> #xfs_db -x -c crc32selftest fsfile
> crc32c: 1 self tests failed
> # echo $?
> 0
> 
> is that intentional or expected? (I know our subcommand error handling is a mess).
> 
> I guess it does stop processing as expected:
> 
> # xfs_db -x -c crc32selftest -c "sb 0" -c p fsfile
> crc32c: 1 self tests failed
> #
> 
> But maybe this shouldn't be considered a command, and more like a weird bolt-on
> next to 'V' i.e. a top-level option which tests the crc and exits with status.
> I can't think of any reason it needs to be a chained command, can you?

<urk> I forgot that I moved crc32 to libfrog, so yes this should be a
CMD_NOFILE_OK xfs_io command and then we can do:

$ xfs_io -c crc32selftest

Will fix and resubmit.

--D

> -Eric
