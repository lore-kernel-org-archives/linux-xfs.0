Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:48254 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751400AbeAYXKy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jan 2018 18:10:54 -0500
Date: Thu, 25 Jan 2018 15:10:48 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 27/29] xfs_scrub: integrate services with systemd
Message-ID: <20180125231048.GR9068@magnolia>
References: <151622651142.31925.4179778330985746435.stgit@magnolia>
 <151622668376.31925.11115543396206091025.stgit@magnolia>
 <e517aefd-5ad0-4de6-6b8f-1911da22f464@sandeen.net>
 <20180125214411.GP9068@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180125214411.GP9068@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Thu, Jan 25, 2018 at 01:44:11PM -0800, Darrick J. Wong wrote:
> On Thu, Jan 25, 2018 at 03:21:25PM -0600, Eric Sandeen wrote:
> > On 1/17/18 4:04 PM, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Create a systemd service unit so that we can run the online scrubber
> > > under systemd with (somewhat) appropriate containment.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > <continue random review method>
> > 
> > ...
> > 
> > > +/*
> > > + * If we are running as a service, we need to be careful about what
> > > + * error codes we return to the calling process.
> > > + */
> > > +static bool			is_service;
> > > +
> > >  static void __attribute__((noreturn))
> > >  usage(void)
> > >  {
> > > @@ -617,6 +623,9 @@ _("Only one of the options -n or -y may be specified.\n"));
> > >  	if (stdout_isatty && !progress_fp)
> > >  		progress_fp = fdopen(1, "w+");
> > >  
> > > +	if (getenv("SERVICE_MODE"))
> > > +		is_service = true;
> > > +
> > >  	/* Find the mount record for the passed-in argument. */
> > >  	if (stat(argv[optind], &ctx.mnt_sb) < 0) {
> > >  		fprintf(stderr,
> > > @@ -717,5 +726,21 @@ _("%s: %llu warnings found.\n"),
> > >  	free(ctx.blkdev);
> > >  	free(ctx.mntpoint);
> > >  
> > > +	/*
> > > +	 * If we're running as a service, bump return code up by 150 to
> > > +	 * avoid conflicting with (sysvinit) service return codes.
> > > +	 */
> > > +	if (is_service) {
> > > +		/*
> > > +		 * journald queries /proc as part of taking in log
> > > +		 * messages; it uses this information to associate the
> > > +		 * message with systemd units, etc.  This races with
> > > +		 * process exit, so delay that a couple of seconds so
> > > +		 * that we capture the summary outputs in the job log.
> > > +		 */
> > > +		sleep(2);
> > > +		if (ret)
> > > +			ret += 150;
> > > +	}
> > 
> > Ok this seems batshit crazy, no offense.  I don't blame /you/ ;)  You pointed me
> > at  http://refspecs.linuxbase.org/LSB_2.0.1/LSB-PDA/LSB-PDA/iniscrptact.html
> > but it says that the /initscript/ should exit with specific codes, not that
> > the application it /calls/ should do so.
> 
> Yes.  At the moment, the systemd service calls xfs_scrub directly, hence
> it interprets the return code as an initscript error code.  So in theory
> we could create a wrapper script that does all the is_service junk, but
> now that's another weird little script to break.  On the plus side we'd
> contain the systemd workaround crap to some random wrapper in /usr/lib.
> 
> Ok, I'll think about it.

We can't do the wrapper thing because of that stupid systemd journal bug
wherein there are delays between the point where the service logs a
message and journald processes.  The process must still be in memory in
order to index (the log message (which encodes the pid)) -> (process) ->
(service) so that /all/ the log messages are associated with the systemd
unit.

Because if we don't do that, xfs_scrub_fail won't see the end of the
xfs_scrub messages and therefore won't email the entire error transcript
to the admin, which is stupid.

Stupid stupid stupid stupid.  If it weren't for the easy sandboxing and
io prioritization stuff none of this would be worth it.

--D

> > > If the status command is given, /the init script/ will return the following exit status codes. 
> > 
> > So maybe this is getting philosophical, if xfs_scrub detects corruption,
> > does that mean it "failed?"  Shouldn't we use your _fail script to interpret
> > the scrub errors, and then give an appropriate return value back to the thing that
> > called us?
> 
> We want the xfs_scrub@ service to return a failure code so that systemd
> will notice the failure and start the xfs_scrub_fail@ fail service.
> This "fail service" doesn't receive the error code of the service that
> failed passed to it, so all it can do is rifle through the journal
> output for whatever xfs_scrub spat out and email it somewhere.
> 
> Hm, yeah, all that crap doesn't need to be there for the non-systemd
> case.
> 
> > Anyway, can't we do return code mangling as appropriate in the script(s)
> > that call xfs_scrub, vs. in the binary itself?  The above just seems really
> > odd and non-obvious to me.
> > 
> > I'll try to plow through more of the scripty stuff in a bit.
> 
> Yeah.
> 
> --D
> 
> > 
> > Thanks,
> > -Eric
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
