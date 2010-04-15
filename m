Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3FJRfNT187051 for <xfs@oss.sgi.com>; Thu, 15 Apr 2010 14:27:41 -0500
Subject: Re: [PATCH] xfstests: exit non-0 if fs check fails
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <4BB3F61D.3020507@sandeen.net>
References: <4BB3DCEF.8040704@redhat.com> <20100401001956.GL7671@dastard>
	<4BB3F61D.3020507@sandeen.net>
Date: Thu, 15 Apr 2010 14:29:31 -0500
Message-ID: <1271359771.2680.128.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Wed, 2010-03-31 at 20:25 -0500, Eric Sandeen wrote:
> Dave Chinner wrote:
> > On Wed, Mar 31, 2010 at 06:38:23PM -0500, Eric Sandeen wrote:
> >> Right now if any of the _check_scratch_fs tests etc fail,
> >> the check script exits but with 0 status.
> >>
> >> This change will cause the status to be non-0 so we can detect
> >> the error.
> >>
> >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> > 
> > Wouldn't it be better to do:
> > 
> > -   [ $ok -eq 0 ] && exit 1
> > +    if [ $ok -eq 0 ]; then
> > +	status=1
> > +	exit 1
> > +    fi
> > 
> > To catch all failures rather than just the fsck failure?

I see this patch is already committed to xfstests-dev.

I don't see the point of setting status=1 before exiting.
If what you meant was to set the status and then *return*
a non-zero value it would make sense.

How do you feel about updating your patch and committing
the result to the -dev tree?

If you change "exit" to "return" in both spots you
can consider it reviewed by me.

					-Alex

PS  Here is a script that shows what's going on.

#!/bin/bash

echo =============
status=1
echo top-level shell PID is $$
echo initial status is $status

bash <<!
        echo -------------
        echo sub-shell PID is \$$
        echo sub-shell initial status is \$status

        foo() { echo foo PID is \$$; status=2; return 3; }
        bar() { echo bar PID is \$$; status=4; exit 5; }
        
        echo -------------
        status=0
        foo             # This is run in the current (sub) shell
        echo foo result is \$?
        echo post-foo status is \$status
        echo current shell PID is \$$

        echo -------------
        status=0
        bar             # This will exit to the top-level shell
        # And the next three will not get executed
        echo bar result is \$?
        echo post-bar status is \$status
        echo current shell PID is \$$
!
R=$?
echo -------------
echo final result is $R
echo final shell PID is $$
echo final status is $status

echo =============

exit 0



> sure, that sounds better.  I'll check that version in w/ your SOB
> unless I hear otherwise :)
> 
> Thanks,
> -Eric
> 
> >> ---
> >>
> >> (aside - we could make it 2 instead of 1, so that a calling script
> >> could fsck and continue ... thoughts?)
> > 
> > I think if a test corrupts a filesystem, the test run should stop
> > so the failure can be analysed without needing to reproduce it
> > again...
> > 
> > Cheers,
> > 
> > Dave.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
