Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p19C3eU8233020 for <xfs@oss.sgi.com>; Wed, 9 Feb 2011 06:03:40 -0600
Date: Wed, 9 Feb 2011 13:06:04 +0100 (CET)
From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH v3] Add test 249: Check filesystem FITRIM
 implementation
In-Reply-To: <1297167619.7351.29.camel@doink>
Message-ID: <alpine.LFD.2.00.1102091255030.32212@dhcp-27-109.brq.redhat.com>
References: <1296762207-17265-1-git-send-email-lczerner@redhat.com>
	<1297167619.7351.29.camel@doink>
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alex Elder <aelder@sgi.com>
Cc: hch@infradead.org, Lukas Czerner <lczerner@redhat.com>, esandeen@redhat.com, xfs@oss.sgi.com

On Tue, 8 Feb 2011, Alex Elder wrote:

> On Thu, 2011-02-03 at 20:43 +0100, Lukas Czerner wrote:
> > FITRIM ioctl  is used on a mounted filesystem to discard (or "trim")
> > blocks which are not in use by the filesystem.  This is useful for
> > solid-state drives (SSDs) and thinly-provi-sioned storage. This test
> > helps to verify filesystem FITRIM implementation to assure that it
> > does not corrupts data.
> > 
> > This test creates checksums of all files in xfstests directory and
> > run several processes which clear its working directory on SCRATCH_MNT,
> > then copy everything from xfstests into its working directory, create
> > list of files in working directory and its checksums and compare it with the
> > original list of checksums. Every process works in the loop so it repeat
> > remove->copy->check, while fstrim tool is running simultaneously.
> > 
> > Fstrim is just a helper tool which uses FITRIM ioctl to actually do the
> > filesystem discard.
> > 
> > I found this very useful because when the FITRIM is really buggy (thus
> > data-destroying) the 249 test will notice, because checksums will most
> > likely change.
> 
> This sounds like a good test.  I ran it and it failed, but I
> couldn't really tell why.  Turns out the ioctl() returned
> ENOTSUP, which is fine.  But the test shouldn't work quite
> that way.
> 
> Based on this very small experience, I have a few comments,
> below.  I glanced at the C code also, and have a few suggestions
> but they're not that important.
> 
> 					-Alex
> 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > ---
> >  249          |  170 ++++++++++++++++++++++++++++++++++++++
> >  249.out      |    3 +
> >  group        |    3 +-
> >  src/Makefile |    2 +-
> >  src/fstrim.c |  257 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  5 files changed, 433 insertions(+), 2 deletions(-)
> >  create mode 100644 249
> >  create mode 100644 249.out
> >  create mode 100644 src/fstrim.c
> > 
> > diff --git a/249 b/249
> > new file mode 100644
> > index 0000000..9943176
> > --- /dev/null
> > +++ b/249
> > @@ -0,0 +1,170 @@
> > +#!/bin/bash
> > +# FS QA Test No. 248
> 
> Unfortunately for you, you'll need to change the number yet again.
> (When the time comes to commit it I'll update the number for you
> if needed.)  I made it number 252 for my own testing.  Remember
> to change the name as well as the content of the test and its
> output file.

Oh, I have reposted this so many times :) I always forget some stupid
little thing. Thanks.

> 
> > +#
> > +# This test was created in order to verify filesystem FITRIM implementation.
> > +# By many concurrent copy and remove operations and checking that files
> > +# does not change after copied into SCRATCH_MNT test if FITRIM implementation
> > +# corrupts the filesystem (data/metadata).
> > +#
> 
> . . .
> 
> > +
> > +function run_process() {
> > +	local p=$1
> > +	repeat=10
> > +
> > +	sleep $((5*$p))s &
> > +	export chpid=$! && wait $chpid &> /dev/null
> > +	chpid=0
> > +
> > +	while [ $repeat -gt 0 ]; do
> > +
> > +		# Remove old directories.
> > +		rm -rf $SCRATCH_MNT/$p
> > +		export chpid=$! && wait $chpid &> /dev/null
> > +
> > +		# Copy content -> partition.
> > +		mkdir $SCRATCH_MNT/$p
> > +		cp -axT $content $SCRATCH_MNT/$p
> > +		export chpid=$! && wait $chpid &> /dev/null
> > +
> > +		check_sums
> > +		repeat=$(( $repeat - 1 ))
> > +	done
> > +}
> > +
> > +nproc=20
> > +content=$here
> > +
> 
> Here (below), you are checking for support and including
> that check in the test itself.  Instead, you should check
> for support and if support isn't found, call something like:
> 
> _notrun "fstrim support not available"
> 
> Even better, you should encapsulate the check for support
> in a shell function, so the call would look like:
> 
> _check_fstrim_support || _notrun "fstrim support not available"

Right, sounds good.

> 
> I don't think there's a need for a "common.fstrim" file,
> but you can look at some other examples (like filestreams)
> for examples of this pattern.
> 
> > +# Check for FITRIM support
> > +echo -n "Checking FITRIM support: "
> > +$here/src/fstrim -l 10M $SCRATCH_MNT &> /dev/null
> 
> Redirecting both stdout and stderr is very unhelpful
> for diagnosing why the command failed.
> 
> I also think you should have an explicit command line
> option to the src/fstrim command to check for support,
> silently, rather than specifying a length to trim.
> (If it had been supported in my case, would this have
> actually done the TRIM?  That is not desirable in a
> feature check.)

Hmm, I do not think it is really needed. Calling fstrim on the part of the
SCRATCH_MNT is just fine. I do not see any problem here, if it is
not supported nothing will happen, but if it is supported part of the
filesystem will be TRIM'med, but that is going to happen anyway since this is
the intention of this test.

>  
> > +[ $? -ne 0 ] && exit
> > +echo "done."
> > +
> > +mkdir -p $tmp
> . . .
> 
> >  
> > diff --git a/src/fstrim.c b/src/fstrim.c
> > new file mode 100644
> > index 0000000..a93a6f3
> > --- /dev/null
> > +++ b/src/fstrim.c
> > @@ -0,0 +1,257 @@
> > +/*
> > + * fstrim.c -- discard the part (or whole) of mounted filesystem.
> > + *
> > + * Copyright (C) 2009 Red Hat, Inc., Lukas Czerner <lczerner@redhat.com>
> 
> Is this the right copyright date?  I don't care, just thought
> I'd call this to your attention in case it's wrong.
> 
> . . .
> 
> > +
> > +int main(int argc, char **argv)
> > +{
> > +	struct options *opts;
> > +	struct stat sb;
> > +	int fd, err = 0, ret = EXIT_FAILURE;
> > +
> > +	opts = malloc(sizeof(struct options));
> 
> No real need to malloc the options structure here, just define
> it as a struct rather than pointer and avoid this failure.

Yeah, I do not really know why I did it with malloc :), however I am not
going to change it since it does not matter at all. If the malloc shall
fail, you would not want to run xfstests anyway, but rather deal with
"what is going on":).

> 
> > +	if (!opts)
> > +		err_exit("%s: malloc(): %s\n", program_name, strerror(errno));
> > +
> > +	opts->range = NULL;
> > +	opts->verbose = 0;
> > +
> > +	if (argc > 1)
> > +		strncpy(opts->mpoint, argv[argc - 1], sizeof(opts->mpoint));
> > +
> > +	opts->range = calloc(1, sizeof(struct fstrim_range));
> 
> Same thing here--just make the range be a struct component
> of the options structure and you won't have to allocate
> it (and will avoid the need to check for and handle the
> failure).
> 
> > +	if (!opts->range) {
> > +		fprintf(stderr, "%s: calloc(): %s\n", program_name,
> > +			strerror(errno));
> > +		goto free_opts;
> > +	}
> > +
> > +	opts->range->len = ULLONG_MAX;
> > +
> > +	if (argc > 2)
> > +		err = parse_opts(argc, argv, opts);
> > +
> > +	if (err) {
> > +		usage();
> > +		goto free_opts;
> > +	}
> > +
> 
> This is more of a style comment...  I think I prefer
> seeing both initializing default values (such as how
> you set opts->range->len) and checking for their
> validity after they've been parsed inside the argument
> parsing routine itself.  That leaves the top-level
> code simpler--just parse the options and go.
> 
> > +	if (strnlen(opts->mpoint, 1) < 1) {
> > +		fprintf(stderr, "%s: You have to specify mount point.\n",
> > +			program_name);
> > +		usage();
> > +		goto free_opts;
> > +	}

Thanks for review, I'll repost it ASAP.

-Lukas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
