Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id ECDB27F37
	for <xfs@oss.sgi.com>; Thu, 24 Oct 2013 16:23:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CC642304062
	for <xfs@oss.sgi.com>; Thu, 24 Oct 2013 14:23:12 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	rK2OeNCfDhCsC03G for <xfs@oss.sgi.com>;
	Thu, 24 Oct 2013 14:23:10 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>) id 1VZSN1-00069z-Db
	for xfs@oss.sgi.com; Fri, 25 Oct 2013 08:23:07 +1100
Date: Fri, 25 Oct 2013 08:23:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: src/feature.c: print a number of online CPUs
Message-ID: <20131024212307.GV2797@dastard>
References: <20131023213152.GP2797@dastard>
	<1382604998-11037-1-git-send-email-stanislav.kholmanskikh@oracle.com>
	<20131024104042.GT2797@dastard>
	<20131024131800.GA27701@orion.maiolino.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131024131800.GA27701@orion.maiolino.org>
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
To: xfs@oss.sgi.com

[ insert comment about not top-posting on mainling lists ]

On Thu, Oct 24, 2013 at 11:18:01AM -0200, Carlos Maiolino wrote:
> > Actually, I'd say we shoul default to 1 cpu if we can't get the
> > number of CPUs. Clearly we have at least one if we can run this
> > code. :)
>
> I'm not sure about setting the default to 1 cpu might me a good behavior. My
> apologies if I'm saying something wrong, but, if the 'tester' are trying to do
> some test trusting on the amount of cpus, it might not be a good behavior.
> I was thinking, how about issue an error message if xfstests can't properly
> detect the amount of cpus from the system, and add any kind of usage option to
> specify the numbers of cpus? So in case of a error while detecting the amount of
> cpus.

I'd much prefer the test runs with a single CPU as a default rather
than not run at all. Most systems the tests run on support these
sysconf parameters, so it's going to do what we expect, but quite
frankly most tests shoul dnot need to know the number of CPUs.

This one is probably misguided, anyway, in what it's doing - if we
want to scale the load the test generates, then that's what
$LOAD_FACTOR is for. Also, it' multiplies the number of CPUs by 50,
then caps the result at 200, so in reality it's only scaling for up
to 4 CPUs which doesn't really take into account the range of
machines that we test on.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
