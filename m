Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8B38E7F77
	for <xfs@oss.sgi.com>; Tue,  8 Oct 2013 14:27:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2A73FAC004
	for <xfs@oss.sgi.com>; Tue,  8 Oct 2013 12:27:28 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	49SAf8GFOAKu1q3o for <xfs@oss.sgi.com>;
	Tue, 08 Oct 2013 12:27:26 -0700 (PDT)
Date: Wed, 9 Oct 2013 06:27:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests XFS: verify extended attributes after
	multi-stream xfsdump/xfsrestore
Message-ID: <20131008192701.GZ4446@dastard>
References: <524AF8AE.5030300@sgi.com> <20131007193912.256265551@sgi.com>
	<20131008005317.GU4446@dastard> <52535864.8020503@sandeen.net>
	<525414D9.10308@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <525414D9.10308@sgi.com>
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
To: Rich Johnston <rjohnston@sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Tue, Oct 08, 2013 at 09:21:13AM -0500, Rich Johnston wrote:
> On 10/07/2013 07:57 PM, Eric Sandeen wrote:
> >On 10/7/13 7:53 PM, Dave Chinner wrote:
> >>Two tests, please. move all the common parts into common/dump, and
> >>write them as two separate tests. That way we can easily track what
> >>test is failing just by looking at what harness test is failing...
> >
> >I'm not quite convinced that it's 2 separate tests, TBH.
> >
> >It's the same root cause; I guess there is a slightly different
> >outcome because if you hit the same root cause enough times,
> >you'll segfault.
> 
> 
> Multiple DMF offline files are successfully restored but the attrs
> are lost. I wanted to show/test that case.
> 
> I agree with Eric that it is the same  root cause but because can
> occur with successful dumps and does not segfault,  Thats why the 2
> tests.

Ok, the problem might be triggering the same root cause, but in the
case of unit tests that is usually irrelevant. That is each individual test
should be independently tracked by the test harness regardless of
the bug it triggers.

And reading on #xfs, the problem isn't clearly understood yet as
both you and Eric are not sure exactly why there are differences in
behaviour between different tests yet. e.g:

[09/10/13 02:13] <rjohnston1> Ahh OK but my DMF test case had several wholly-sparse (offline files) and the dump succeeded. 
[09/10/13 02:18] <sandeen> tbh there is one thing I'm not clear on here, why a 1t sparse file behaves differently from a 1k sparse file
[09/10/13 02:18] <sandeen> that seems . .  wrong
[09/10/13 02:19] <sandeen> but I guess it must just key on i_size, not blocks
[09/10/13 02:19] <sandeen> so anyway, maybe your dmf testcase had smaller file sizes?
[09/10/13 02:19] <sandeen> sorry, I have to run & get missed homework to my kid @ school, bbiab.  Grr.
[09/10/13 02:20] <rjohnston1> NP, yes they were smaller.
[09/10/13 02:22] <rjohnston1> 100 10MB files no segfault, just trashed attrs.

SO, there's different behaviour dependent on file sizes, and that's
not understood yet. IOWs, there's yet another test case that needs
to be exercised here to demonstrate the different failure cases
that are being seen.

And that brings it further into the realm of multiple tests, in
which case we might have:

	- 320 - multistream with wholly sparse files
	- 321 - multistream with small sparse files
	- 322 - multistream with large sparse files

This is the point I'm trying to make - from a test harness
perspective, we don't really care what the bugs are that are being
triggered by the tests - what we are trying to do is get coverage of
different behaviours and test cases and track which ones fail. What
i see from the above woul dbe:

	- 320 = pass
	- 321 = fail, corrupt attrs
	- 322 = fail, SEGV

Different tests, different failure modes, easy to tell them apart.

> >That's the only difference in test #2.
> >(and the segfault isn't fixed AFAIK).

Exactly my point. With the fix you have made, we'll get:

	- 320 = pass
	- 321 = pass
	- 322 = fail, segv.

We can clearly state at this point that your patch has fixed an
attribute corruption problem because it makes a specific unit go
from fail to pass. If we see that unit test fail on other distros,
we know exactly what patch is needed to fix it. And the same can be
said for when we find the root cause of the SEGV failure....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
