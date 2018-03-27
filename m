Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:50892 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752232AbeC0WWj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Mar 2018 18:22:39 -0400
Date: Tue, 27 Mar 2018 15:22:30 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/3] xfs_scrub: synchronize error levels & logging
Message-ID: <20180327222230.GF4818@magnolia>
References: <f7ab3da2-618c-dc1c-6d95-3890cdac2b43@redhat.com>
 <3b8c1fd3-46bb-39ea-fca9-63d308cbe6b4@redhat.com>
 <20180327221403.GC4818@magnolia>
 <c1f36c29-092e-4f81-47fa-cf272186f09f@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c1f36c29-092e-4f81-47fa-cf272186f09f@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Mar 27, 2018 at 05:20:36PM -0500, Eric Sandeen wrote:
> On 3/27/18 5:14 PM, Darrick J. Wong wrote:
> > On Tue, Mar 27, 2018 at 05:08:54PM -0500, Eric Sandeen wrote:
> >> Having only a subset of the five error_levels present in
> >> the log_level[] array is asking for trouble when someone
> >> tries to __str_log(S_PREEN ...) and overruns the array.
> >>
> >> Tie it all together in a single structure that's
> >> initialized together to make the mapping more obvious and
> >> idiot-proof.
> >>
> >> Fixes-coverity-id: 1433618
> >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >> ---
> >>
> >> diff --git a/scrub/common.c b/scrub/common.c
> >> index 5a37a98..02c6c9d 100644
> >> --- a/scrub/common.c
> >> +++ b/scrub/common.c
> >> @@ -56,18 +56,15 @@ xfs_scrub_excessive_errors(
> >>  	return ret;
> >>  }
> >>  
> >> -static const char *err_str[] = {
> >> -	[S_ERROR]	= "Error",
> >> -	[S_WARN]	= "Warning",
> >> -	[S_REPAIR]	= "Repaired",
> >> -	[S_INFO]	= "Info",
> >> -	[S_PREEN]	= "Optimized",
> >> -};
> >> -
> >> -static int log_level[] = {
> >> -	[S_ERROR]	= LOG_ERR,
> >> -	[S_WARN]	= LOG_WARNING,
> >> -	[S_INFO]	= LOG_INFO,
> >> +static struct {
> >> +	const char *string;
> >> +	int loglevel;
> >> +} err_levels[] = {
> >> +	[S_ERROR]  = { .string = "Error",	.loglevel = LOG_ERR },
> >> +	[S_WARN]   = { .string = "Warning",	.loglevel = LOG_WARNING },
> >> +	[S_REPAIR] = { .string = "Repaired",	.loglevel = LOG_WARNING },
> >> +	[S_INFO]   = { .string = "Info",	.loglevel = LOG_INFO },
> >> +	[S_PREEN]  = { .string = "Optimized",	.loglevel = LOG_INFO }
> >>  };
> >>  
> >>  /* If stream is a tty, clear to end of line to clean up progress bar. */
> >> @@ -106,8 +103,8 @@ __str_out(
> >>  	if (level == S_PREEN && !debug && !verbose)
> >>  		goto out_record;
> >>  
> >> -	fprintf(stream, "%s%s: %s: ", stream_start(stream), _(err_str[level]),
> >> -			descr);
> >> +	fprintf(stream, "%s%s: %s: ", stream_start(stream),
> >> +			err_levels[level].string, descr);
> > 
> > _(err_levels[level]) here ^^^^^^^^^^^^
> > 
> > Otherwise we end up with:
> > 
> > Error: 你吃饭了吗？你多吃一点。
> 
> oops
> 
> but: _(err_levels[level].string) right ...

Er, right.

> > 
> >>  	if (error) {
> >>  		fprintf(stream, _("%s."), strerror_r(error, buf, DESCR_BUFSZ));
> >>  	} else {
> >> @@ -152,10 +149,6 @@ __str_log(
> >>  	char			buf[LOG_BUFSZ];
> >>  	int			sz;
> >>  
> >> -	/* We only want to hear about optimizing when in debug/verbose mode. */
> >> -	if (level == S_PREEN && !debug && !verbose)
> >> -		return;
> > 
> > Why is this being removed?
> 
> It seemed like a cut & paste error originally but ... it's a leftover, sorry. 

:)

--D

> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
