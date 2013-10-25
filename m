Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 034B27F3F
	for <xfs@oss.sgi.com>; Fri, 25 Oct 2013 04:16:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E43E1304064
	for <xfs@oss.sgi.com>; Fri, 25 Oct 2013 02:16:07 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id HsLKJ0htx3sVqsZj for
	<xfs@oss.sgi.com>; Fri, 25 Oct 2013 02:16:06 -0700 (PDT)
Date: Fri, 25 Oct 2013 05:15:52 -0400
From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] xfs: fix possible NULL dereference
Message-ID: <20131025091552.GB26384@redhat.com>
References: <20131021231849.GL10553@sgi.com> <20131021235601.GG4446@dastard>
	<5265C03B.50701@sandeen.net> <20131022001732.GI4446@dastard>
	<CAGG-pUTh-PJJ4Nzo0r-f3VDPMc81U2z_NMX+Wcex3KzGs=U8cA@mail.gmail.com>
	<20131022203946.GB2797@dastard> <5266E4BD.8030601@sandeen.net>
	<20131022210300.GC2797@dastard> <5266EBF0.901@sandeen.net>
	<20131022220254.GD2797@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131022220254.GD2797@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Alex Elder <elder@kernel.org>, Eric Sandeen <sandeen@sandeen.net>, open list <linux-kernel@vger.kernel.org>, XFS FILESYSTEM <xfs@oss.sgi.com>, Ben Myers <bpm@sgi.com>, Geyslan =?iso-8859-1?Q?Greg=F3rio?= Bem <geyslan@gmail.com>

On Wed, Oct 23, 2013 at 09:02:54AM +1100, Dave Chinner wrote:

 > > it looks suspicious to pretty much anyone.  I don't think Geyslan
 > > sent it to shut Coverity up, he sent it because it looked like
 > > a bug worth fixing (after Coverity spotted it).
 > > 
 > > Let's not be too hard on him for trying; I appreciate it more
 > > than spelling fixes and whitespace cleanups.  ;)
 > 
 > True, point taken. 

So another reason you're seeing an uptick in coverity reports lately
is that back in June they gave me admin rights for the project at scan.coverity.com
so I've been doing daily builds since then. (Previously they only did one per point release).

The Coverity guys did a write-up on this thread at http://security.coverity.com/blog/2013/Oct/deliberate-null-pointer-dereferences-in-the-linux-kernel.html 
The point about modelling is the pertinent part.  I'm still trying to get my
head around a lot of how that stuff works, but that's the sort of thing
that I have rights to do on their site too.

If you or anyone else wants access to their bugs, I can approve that
easily enough.  I've been going through and trying to filter out as many of
the intentional[*] issues as possible, and do things like sorting into components
so that you're able to look at just XFS bugs for eg.

I know Eric has been looking at their bugs when he has had time, but if there's
something I can do to make things easier for you guys, let me know.
(I could email you new issue reports as they come in for eg)

To end on a high note, XFS is actually one of the better subsystems from the
POV of number of issues they've found. Only 38 'New' issues right now, which
given the complexity in XFS, is pretty darn good, and I bet a bunch of those
are actually non-issues too.  The painful part is going through and sorting
through the non-issues to get to the real meaty bugs, which is what I've slowly
been doing over the last couple months. (Down from 5900 or so, to 5305,
thanks to help from others)

	Dave

[*] From what I've seen so far, a lot of issues it finds are the checker
getting tricked by idioms we use in the kernel rather than actual "false positives"
(in terms of "this is a bug in the checker"). As the url above points out,
sometimes we can help the checker out through modelling, but some of the code
I've seen it get tripped up is hard enough for a human to parse, so I don't 
really blame the checker for getting confused ;)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
