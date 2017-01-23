Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:17827 "EHLO
        aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750846AbdAWXlQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Jan 2017 18:41:16 -0500
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69])
        by aserp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v0NNehX4010656
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 23 Jan 2017 23:40:43 GMT
Date: Mon, 23 Jan 2017 15:39:37 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/5] xfs_db: fix the 'source' command when passed as a -c
 option
Message-ID: <20170123233937.GE4780@birch.djwong.org>
References: <148494391629.5256.3328772079712970611.stgit@birch.djwong.org>
 <148494392855.5256.2805905613919243845.stgit@birch.djwong.org>
 <64226033-de72-e342-609a-987cc3065079@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64226033-de72-e342-609a-987cc3065079@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Mon, Jan 23, 2017 at 04:29:00PM -0600, Eric Sandeen wrote:
> On 1/20/17 2:25 PM, Darrick J. Wong wrote:
> > The 'source' command is supposed to read commands out of a file and
> > execute them.  This works great when done from an interactive command
> > line, but it doesn't work at all when invoked from the command line
> > because we never actually do anything with the opened file.
> > 
> > So don't load stdin into the input stack when we're only executing
> > command line options, and use that to decide if source_f is executing
> > from the command line so that we can actually run the input loop.  We'll
> > use this for the per-field fuzzing xfstests.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  db/init.c  |    2 +-
> >  db/input.c |   29 +++++++++++++++++++++++++++--
> >  2 files changed, 28 insertions(+), 3 deletions(-)
> > 
> > 
> > diff --git a/db/init.c b/db/init.c
> > index e60ac66..46af024 100644
> > --- a/db/init.c
> > +++ b/db/init.c
> > @@ -254,7 +254,6 @@ main(
> >  	char	**v;
> >  	int	start_iocur_sp;
> >  
> > -	pushfile(stdin);
> >  	init(argc, argv);
> >  	start_iocur_sp = iocur_sp;
> >  
> > @@ -269,6 +268,7 @@ main(
> >  		goto close_devices;
> >  	}
> 
> Ok, so anything above this is commandline invocations.
> 
> Everything below is interactive...
> 
> > +	pushfile(stdin);
> >  	while (!done) {
> >  		if ((input = fetchline()) == NULL)
> >  			break;
> > diff --git a/db/input.c b/db/input.c
> > index 8f65190..7b12c97 100644
> > --- a/db/input.c
> > +++ b/db/input.c
> > @@ -145,6 +145,12 @@ get_prompt(void)
> >  	return prompt;
> >  }
> >  
> > +static bool
> > +interactive_input(void)
> > +{
> > +	return inputstacksize == 1 && inputstack[0] == stdin;
> > +}
> 
> how about just:
> 
> 	return curinput == stdin?

Sure.

> > +
> >  static char *
> >  fetchline_internal(void)
> >  {
> > @@ -156,7 +162,9 @@ fetchline_internal(void)
> >  
> >  	rval = NULL;
> >  	for (rlen = iscont = 0; ; ) {
> > -		if (inputstacksize == 1) {
> > +		if (curinput == NULL)
> > +			return NULL;
> > +		if (interactive_input()) {
> >  			if (iscont)
> >  				dbprintf("... ");
> >  			else
> > @@ -183,7 +191,8 @@ fetchline_internal(void)
> >  		    (len = strlen(buf)) == 0) {
> >  			popfile();
> >  			if (curinput == NULL) {
> > -				dbprintf("\n");
> > +				if (interactive_input())
> > +					dbprintf("\n");
> 
> I give up.  I see from testing that it is, but why is \n special here?

When we have an interactive session, no libreadline, and the user hits
^D, this makes it so that we print a newline before the prompt returns
so that we don't end up with:

xfs_db> bash-2.05$

However, now that we've moved pushfile(stdin), it's possible that a
non-interactive session (which is what you get with "-c 'source moo'")
will pop all the fds off the stack, causing the newline to print.

A better fix for all this is to:

if (curinput == stdin)
	dbprintf("\n");
popfile();
iscont = 0...

Another odd quirk I noticed is that when an invocation of
fetchline_internal reaches feof/ferror on a file descriptor, it'll pop
the input stack and try to continue with the next lower level.  Since
each source_f starts its own interpreter loop we could just jump out
when we run out of input data and let the /caller/ continue with the fd
that it pushed onto the stack.

> 
> >  				return NULL;
> >  			}
> >  			iscont = 0;
> > @@ -314,12 +323,28 @@ source_f(
> >  	char	**argv)
> >  {
> >  	FILE	*f;
> > +	int	c, done = 0;
> > +	char	*input;
> > +	char	**v;
> >  
> >  	f = fopen(argv[1], "r");
> >  	if (f == NULL)
> >  		dbprintf(_("can't open %s\n"), argv[0]);
> >  	else
> >  		pushfile(f);
> > +
> > +	/* If this isn't an interactive shell, run the commands now. */
> > +	if (inputstacksize == 0 || inputstack[0] == stdin)
> 
> This confuses me a bit, partly from the comment.  We could be in
> an interactive shell, but we've just issued a source command ...
> 
> If inputstacksize == 0, that means fopen failed and we didn't
> do a pushfile, right?  Maybe best to just return in the failure
> case above, and skip that test here?
> 
> And how can we ever be here w/ inputstack[0] == stdin?
> 
> I'm wondering if this isn't cleaner and still correct:
> 
>         f = fopen(argv[1], "r");
>         if (f == NULL) {
>                 dbprintf(_("can't open %s\n"), argv[0]);
>                 return 0;
>         }
> 
>         /* Run the sourced commands now */
>         pushfile(f);
>         while (!done) {
>                 if ((input = fetchline_internal()) == NULL)

Yes, that does seem cleaner.

--D

> 
> > +		return 0;
> > +	while (!done) {
> > +		if ((input = fetchline_internal()) == NULL)
> > +			break;
> > +		v = breakline(input, &c);
> > +		if (c)
> > +			done = command(c, v);
> > +		doneline(input, v);
> > +	}
> > +
> >  	return 0;
> >  }
> >  
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
