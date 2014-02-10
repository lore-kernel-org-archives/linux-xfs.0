Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1F3FD7F50
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 05:10:54 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E2A758F8037
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 03:10:50 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	U04R91Q90J35dTk3 for <xfs@oss.sgi.com>;
	Mon, 10 Feb 2014 03:10:48 -0800 (PST)
Date: Mon, 10 Feb 2014 22:10:42 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/6] xfs: add xfs_verifier_error()
Message-ID: <20140210111042.GY13997@dastard>
References: <52F83630.4020008@redhat.com> <52F83A8D.7030506@sandeen.net>
	<20140210034321.GR13647@dastard> <52F85294.6010309@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52F85294.6010309@sandeen.net>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Sun, Feb 09, 2014 at 10:16:20PM -0600, Eric Sandeen wrote:
> On 2/9/14, 9:43 PM, Dave Chinner wrote:
> > On Sun, Feb 09, 2014 at 08:33:49PM -0600, Eric Sandeen wrote:
> >> We want to distinguish between corruption, CRC errors,
> >> etc.  In addition, the full stack trace on verifier errors
> >> seems less than helpful; it looks more like an oops than
> >> corruption.  
> >>
> >> Create a new function to specifically alert the user to
> >> verifier errors, which can differentiate between
> >> EFSCORRUPTED and CRC mismatches.  It doesn't dump stack
> >> unless the xfs error level is turned up high.
> >>
> >> Define a new error message (EFSBADCRC) to clearly identify
> >> CRC errors.  (Defined to EILSEQ, bad byte sequence)
> >>
> >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >> ---
> >>  fs/xfs/xfs_error.c |   22 ++++++++++++++++++++++
> >>  fs/xfs/xfs_error.h |    3 +++
> >>  fs/xfs/xfs_linux.h |    1 +
> >>  3 files changed, 26 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> >> index 9995b80..08d76f4 100644
> >> --- a/fs/xfs/xfs_error.c
> >> +++ b/fs/xfs/xfs_error.c
> >> @@ -178,3 +178,25 @@ xfs_corruption_error(
> >>  	xfs_error_report(tag, level, mp, filename, linenum, ra);
> >>  	xfs_alert(mp, "Corruption detected. Unmount and run xfs_repair");
> >>  }
> >> +
> >> +/*
> >> + * Warnings specifically for verifier errors.  Differentiate CRC vs. invalid
> >> + * values, and omit the stack trace unless the error level is tuned high.
> >> + */
> >> +void
> >> +__xfs_verifier_error(
> >> +	const char		*func,
> >> +	struct xfs_buf		*bp)
> >> +{
> >> +	struct xfs_mount *mp = bp->b_target->bt_mount;
> >> +
> >> +	xfs_alert(mp,
> >> +"%sCorruption detected in %s, block 0x%llx. Unmount and run xfs_repair",
> >> +		  bp->b_error == EFSBADCRC ? "CRC " : "", func, bp->b_bn);
> > 
> > Perhaps if we do this:
> > 
> > 	xfs_alert(mp,
> > "Metadata %s detected at %pF, block 0x%llx. Unmount and run xfs_repair",
> > 		  bp->b_error == EFSBADCRC ? "CRC error"
> > 					   : "corruption", _RET_IP_, bp->b_bn);
> > 
> > We'll get a symbol of the form caller_name+0xoffset similar to a
> > stack dump. That way if we have multiple calls to a
> > xfs_verifier_error() inside a single function we get something that
> > tells us which call detected the error...
> 
> Hm, but the point of the switch based on error nrs was to require only
> one call in each ->verifier, and ...

Right, that's the current usage of it because we are simply
returning true/false from the checking code. Determining the exact
error is the report is much more useful - let's not lose sight of
the end goal....

> > Also, the use of _RET_IP_ gets rid of the need for the wrapper
> > macro....
> 
> 0x${SPLAT} is a lot less useful than i.e. "xfs_agi_read_verify"

Note the format string I used: "%pF". That decodes the _RET_IP_
into the function name and offset from the start of the function.
i.e. it returns xfs_agi_read_verify+0x<splat>.

> Printing the _RET_IP_ requires disassembly of that particular build
> to figure out where we went wrong, whereas printing __func__ makes it
> clear on the initial read of the dmesg.

The function is already there in plain test. You only need to go to
tools if you want ot know the exact line it came from....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
