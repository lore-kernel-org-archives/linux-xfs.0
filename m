Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56296 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751462AbeAYVV0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Jan 2018 16:21:26 -0500
Subject: Re: [PATCH 27/29] xfs_scrub: integrate services with systemd
References: <151622651142.31925.4179778330985746435.stgit@magnolia>
 <151622668376.31925.11115543396206091025.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <e517aefd-5ad0-4de6-6b8f-1911da22f464@sandeen.net>
Date: Thu, 25 Jan 2018 15:21:25 -0600
MIME-Version: 1.0
In-Reply-To: <151622668376.31925.11115543396206091025.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 1/17/18 4:04 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create a systemd service unit so that we can run the online scrubber
> under systemd with (somewhat) appropriate containment.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

<continue random review method>

...

> +/*
> + * If we are running as a service, we need to be careful about what
> + * error codes we return to the calling process.
> + */
> +static bool			is_service;
> +
>  static void __attribute__((noreturn))
>  usage(void)
>  {
> @@ -617,6 +623,9 @@ _("Only one of the options -n or -y may be specified.\n"));
>  	if (stdout_isatty && !progress_fp)
>  		progress_fp = fdopen(1, "w+");
>  
> +	if (getenv("SERVICE_MODE"))
> +		is_service = true;
> +
>  	/* Find the mount record for the passed-in argument. */
>  	if (stat(argv[optind], &ctx.mnt_sb) < 0) {
>  		fprintf(stderr,
> @@ -717,5 +726,21 @@ _("%s: %llu warnings found.\n"),
>  	free(ctx.blkdev);
>  	free(ctx.mntpoint);
>  
> +	/*
> +	 * If we're running as a service, bump return code up by 150 to
> +	 * avoid conflicting with (sysvinit) service return codes.
> +	 */
> +	if (is_service) {
> +		/*
> +		 * journald queries /proc as part of taking in log
> +		 * messages; it uses this information to associate the
> +		 * message with systemd units, etc.  This races with
> +		 * process exit, so delay that a couple of seconds so
> +		 * that we capture the summary outputs in the job log.
> +		 */
> +		sleep(2);
> +		if (ret)
> +			ret += 150;
> +	}

Ok this seems batshit crazy, no offense.  I don't blame /you/ ;)  You pointed me
at  http://refspecs.linuxbase.org/LSB_2.0.1/LSB-PDA/LSB-PDA/iniscrptact.html
but it says that the /initscript/ should exit with specific codes, not that
the application it /calls/ should do so.

> If the status command is given, /the init script/ will return the following exit status codes. 

So maybe this is getting philosophical, if xfs_scrub detects corruption,
does that mean it "failed?"  Shouldn't we use your _fail script to interpret
the scrub errors, and then give an appropriate return value back to the thing that
called us?

Anyway, can't we do return code mangling as appropriate in the script(s)
that call xfs_scrub, vs. in the binary itself?  The above just seems really
odd and non-obvious to me.

I'll try to plow through more of the scripty stuff in a bit.

Thanks,
-Eric
