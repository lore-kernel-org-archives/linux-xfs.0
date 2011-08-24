Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7O7hmfM026357 for <xfs@oss.sgi.com>; Wed, 24 Aug 2011 02:43:48 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 193211F03AE4
	for <xfs@oss.sgi.com>; Wed, 24 Aug 2011 00:43:46 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	rPjzGuwp3jJ3otFP for <xfs@oss.sgi.com>;
	Wed, 24 Aug 2011 00:43:46 -0700 (PDT)
Date: Wed, 24 Aug 2011 17:42:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [GIT PULL] XFS update for 3.1-rc4
Message-ID: <20110824074240.GH3162@dastard>
References: <201108231739.p7NHdXQ8008360@stout.americas.sgi.com>
	<CA+55aFxEyj8qJnr9QR3Scy7SFocEr2BNA9z4PXs7q9rpkXM1vQ@mail.gmail.com>
	<20110824004206.GG3162@dastard>
	<CA+55aFwJAPN=EgTo-2iarhe4cFSArqB6AZAHDsuEK5EPBZVn+A@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+55aFwJAPN=EgTo-2iarhe4cFSArqB6AZAHDsuEK5EPBZVn+A@mail.gmail.com>
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: akpm@linux-foundation.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, Alex Elder <aelder@sgi.com>

On Tue, Aug 23, 2011 at 05:59:46PM -0700, Linus Torvalds wrote:
> On Tue, Aug 23, 2011 at 5:42 PM, Dave Chinner <david@fromorbit.com> wrote:
> >
> > I consider the context it adds to cscope searches a damn good reason
> > for keeping it.
> 
> Umm. I suggest you start learning to use the tools you have, rather
> than blame your inability to use them for then making crap decisions
> in file naming.

If you're passing judgement on the XFS filenaming convention, then
don't blame me - way before my time.  e.g. the two initial XFS
commits from 29 October, 1993 show exactly the same names as we
currently use:

http://oss.sgi.com/cgi-bin/gitweb.cgi?p=archive/xfs-import.git;a=commitdiff;h=67e682e44dd02a2a0efaa0ed2579894325010a85
http://oss.sgi.com/cgi-bin/gitweb.cgi?p=archive/xfs-import.git;a=commitdiff;h=ec2b385b4b79e3967e1e0480fb1863ba029f6c30

So perhaps you might want to go hunt down the original XFS
developers. They'd probably just laugh at you, though.

Regardless, changing the filenames now is a bad idea. Plenty of
people are familiar with what they mean and what they contain, and
changing them just means everyone has to relearn where stuff is. We
lose the simple solution to the question "what file does that
function exist in" and deciding where to put new code becomes harder
because it's not as clear what the overall scope of each file is
supposed to be.  It will also make code archeology during bug triage
harder as well.  That doesn't improve anything for anyone in the
short term - it will only slow us down.

And in the long term, a major rename makes things like backports to
stable kernels harder, more time consuming and more error prone due
to the extra transformations that need to take place for each patch.
That's two strikes.

Then there is also the userspace tools that share a bunch of the
kernel code that we have to keep in sync. Hence renaming the kernel
files means we'll make a bunch of work for ourselves in userspace as
well to keep that in sync. Strike Three.

So really, I can't see any good reason to change the XFS file names.

> Read up on the "-pN" thing to cscope.

I learnt about that in 2002.

However, if you ever used cscope with the -pN option on a source
tree with long verbose filenames (like you suggest) and functions on
a 80-90 column terminal, you'd understand that these shift the code
context output (the most important bit of the cscope output) so far
across the terminal that it line wraps 3 or 4 times and is
completely unreadable.....

> So here's a trick of the day:
> 
>   export CSCOPEOPTIONS=-p2
>
> or something like that.

Sure. You need to wrap it in an alias because cscope doesn't have a
magic environment variable or config file to set default options.

Of course, the obvious logical extension of that is to then hook up
a script to PROMPT_COMMAND or aliasing cd/pushd/popd (or cwdcmd for
tcsh) so that $CSCOPEOPTIONS changes automatically depending on the
source tree you are currently working in.

That would require learning a bit about the tools you use every day,
though. I learnt this trick in 2003..... :P

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
