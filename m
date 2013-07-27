Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 79C397F51
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 20:26:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3231E8F8035
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 18:26:57 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	kIi9YQ5jyGmlniXN for <xfs@oss.sgi.com>;
	Fri, 26 Jul 2013 18:26:55 -0700 (PDT)
Date: Sat, 27 Jul 2013 11:26:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: understanding speculative preallocation
Message-ID: <20130727012653.GR13468@dastard>
References: <1374823420041-35002.post@n7.nabble.com>
	<20130726115021.GO13468@dastard>
	<CAA+BczQesNL2VmFmrcBNKXcM-Sfx0bXkXPRP5xMx6=Bv+NWrUA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAA+BczQesNL2VmFmrcBNKXcM-Sfx0bXkXPRP5xMx6=Bv+NWrUA@mail.gmail.com>
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
To: Jason Rosenberg <jbr@squareup.com>
Cc: xfs@oss.sgi.com

On Fri, Jul 26, 2013 at 01:40:16PM -0400, Jason Rosenberg wrote:
> Hi Dave,
> 
> Thanks for your responses.  I'm a bit confused, as I didn't see your
> responses on the actual forum (only in my email inbox).

I'm replying from the list ;)

[ If you have a dup filter like I do, then I only get one copy of
anything that is sent to me when there are multiple cc's. My
procmail rules determine where it gets stored.... ]

> Anyway, I'm surprised that you don't have some list or other way to
> correlate version history of XFS, with os release versions.

Of course we do.

> I'm guessing
> the version I have is not using the latest/greatest.  We actually have
> another system that uses an older version of the kernel (2.6.32-279), and
> it behaves differently (it still preallocates space beyond what will ever
> be used, but not by quite as much).  When we rolled out our newer machines
> to 2.6.32-358, we started seeing a marked increase in disk full problems.

Disclaimer: I'm the primary RHEL XFS developer, employed by Red Hat.

CentOS is a rebadged RHEL product that is released for free. If you
want bugs fixed in CentOS, then generally you are on your own. If
you want paid support where people will fix problems you have, you
need to pay for RHEL.

You get what you pay for.

> If, say you tell me, the mainline xfs code has improved behavior, it would
> be nice to have a way to know which version of CentOS might include that?

Well, that depends on what Red Hat do with RHEL, because CentOS
simply rebuild what Red Hat releases.

>  Telling me to read source code across multiple kernel versions sounds like
> an interesting endeavor, but not something that is the most efficient use
> of my time, unless there truly is no one who can easily tell me anything
> about xfs version history.

So, you want me to read it for you instead, then document it for
you? i.e. spend a day not fixing bugs and developing new code to
document the history of something that you can find out by looking
in git and rpms yourself? Unless you are offering to pay someone to
do it, I don't see it happening...

Open source != free lunch.

> Do you have any plans to have some sort of improved documentation story
> around this?

No.

> This speculative preallocation behavior is truly unexpected
> and not transparent to the user.

Which is why we've been fixing it. The problems you are reporting
are already fixed in the mainline kernel.

> I can see that it's probably a great
> performance boost (especially for something like kafka), but kafka does
> have predictable log file rotation capped at fixed sizes, so it would be
> great if that could be factored in.

Mainline already does handle this, in a much more generic manner. If
any file with speculative prealloc beyond EOF remains clean for 5
minutes, then the specualtive prealloc is removed. Hence 5 minutes
after you log file is rotated, it will have the excess space
removed.

> I suppose using the allocsize setting might work in the short term.  But I
> probably don't want to set allocsize to 1Gb, since that would mean every
> single file created would start with that size, is that right?  Does the
> allocsize setting basically work by always keeping the file size ahead of
> consumed space by the allocsize amount?

Effectively.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
