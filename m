Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9G5C7fX191300 for <xfs@oss.sgi.com>; Sat, 16 Oct 2010 00:12:08 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C7707F1B226
	for <xfs@oss.sgi.com>; Fri, 15 Oct 2010 22:27:53 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	EqAiS54DtnurM5da for <xfs@oss.sgi.com>;
	Fri, 15 Oct 2010 22:27:53 -0700 (PDT)
Date: Sat, 16 Oct 2010 16:13:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/11] xfstests: rework src/randholes.c
Message-ID: <20101016051313.GN4681@dastard>
References: <1287067771.2362.202.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1287067771.2362.202.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Oct 14, 2010 at 09:49:31AM -0500, Alex Elder wrote:
> Dave's recent "dynamic speculative EOF preallocation" changes
> caused test 008 to no longer produce the kinds of holes it was
> expecting to see, so it got me looking at the program it uses,
> "src/randholes.c".
> 
> Since 008 is the only test using this program, it probably
> doesn't deserve the attention I gave it yesterday, but I've
> done the work so I might as well submit the series for
> review and get my changes in.
> 
> The first patch in the series actually addresses two things
> that are bugs.
> 
> The remaining 10 are just cleanup and refactoring changes.
> Other than two bug fix changes and one change in output
> when running in very-verbose mode, the patched code should
> be pretty much functionally identical to before.

I haven't really looked at the whole series closely, but nothing
stands out as a red flag. Seeing it's test code, it's probably
OK to go as is. The bug fixes look fine.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
