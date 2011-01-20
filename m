Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0KAliDG070096 for <xfs@oss.sgi.com>; Thu, 20 Jan 2011 04:47:44 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 85C6719F3826
	for <xfs@oss.sgi.com>; Thu, 20 Jan 2011 02:50:02 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	ZIHzHbt0Rl7Tfcpv for <xfs@oss.sgi.com>;
	Thu, 20 Jan 2011 02:50:02 -0800 (PST)
Date: Thu, 20 Jan 2011 21:49:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS - issues with writes using sync
Message-ID: <20110120104958.GT16267@dastard>
References: <AANLkTin22efc0cHSmM+2rNQpE2aJoobQCnMwbNUjw617@mail.gmail.com>
	<20110120051720.GR16267@dastard>
	<AANLkTik0KUQaRzLeBNR8M=u+ijO6gAZu601zyCp2zmDS@mail.gmail.com>
	<AANLkTi=yvf0ww4_C+H8xz6-5UWHKYSV2amCC9p-0tXrr@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTi=yvf0ww4_C+H8xz6-5UWHKYSV2amCC9p-0tXrr@mail.gmail.com>
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
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: xfs@oss.sgi.com

On Thu, Jan 20, 2011 at 12:08:21PM +0530, Amit Sahrawat wrote:
> Hi,
> I tried with the same test case - just removed 'sync' command from the
> script(please check script below) to check the behaviour.
....
> I really doubt about the stability of 2.6.35.9, it is not passing our basic
> tests. Checking few more things, before deciding about the patches which got
> introduced between 2.6.34 ~ 2.6.35.9(around 102).

2.6.35 is perfectly fine on x86, so I suspect that it is something
ARM specific. Most likely it is related to the VIVT platform support
changes, but you really need to bisect so we know exactly waht
change has broken such basic functionality on your platform.

Note that the bug may not even be in XFS, so you really need to do a
full bisect, not just of the changes in xfs in that time...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
