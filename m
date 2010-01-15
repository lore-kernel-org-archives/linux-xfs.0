Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0F7ID30077435 for <xfs@oss.sgi.com>; Fri, 15 Jan 2010 01:18:13 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C646B1C51D38
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 23:19:09 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	s3XihuHhOeD7AWt9 for <xfs@oss.sgi.com>;
	Thu, 14 Jan 2010 23:19:09 -0800 (PST)
Date: Fri, 15 Jan 2010 18:19:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] remove bashisms from xfstests
Message-ID: <20100115071906.GF28498@discord.disaster>
References: <alpine.DEB.2.01.1001030125040.3483@bogon.housecafe.de>
	<87vdfjceke.fsf@basil.nowhere.org>
	<alpine.DEB.2.01.1001032307210.3483@bogon.housecafe.de>
	<alpine.DEB.2.01.1001032348240.3483@bogon.housecafe.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.1001032348240.3483@bogon.housecafe.de>
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
To: Christian Kujau <lists@nerdbynature.de>
Cc: Andi Kleen <andi@firstfloor.org>, xfs@oss.sgi.com

On Sun, Jan 03, 2010 at 11:56:45PM -0800, Christian Kujau wrote:
> On Sun, 3 Jan 2010 at 23:27, Christian Kujau wrote:
> > OK, here's one with only changing /bin/sh to /bin/bash, for all scripts 
> > carrying bashisms according to checkbashisms(1). With this patch applied, 
> > I can now run xfstests w/o changing my /bin/sh to something else.
> 
> Well, almost - I'm still getting errors, because some of the scripts are 
> not executed but sourced. Although the ./check script is /bin/bash now, 
> the sourced scripts seem to get executed via /bin/sh, at least that's what 
> I've experienced. Here's an additional patch, changing only the common.* 
> scripts, for they are being sourced. Right now xfstests is running test 
> 013 and no errors so far.

Even with this patch I notice that 005 fails, 007 hangs, mkfs fails in
015 and 016 because of some kind of parameter passing problem
fail, and and all of these work by specifying /bin/bash rather than
/bin/sh.

I haven't got any further than this - it's painfully slow having to
test them one at a time because I'm getting lots of failures since
upgrading my test box from xfsprogs 3.0.4 to 3.1.0 this morning as
well as to the latest debian unstable.

Right now, considering the apparent widespread dependency on bash in
these test scripts, I'm proposing that we just change every single
test to run /bin/bash and hence avoid all these problems without
needing extra changes to the tests.

Comments?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
