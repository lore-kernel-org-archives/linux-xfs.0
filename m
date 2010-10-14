Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9EEmwYp024132 for <xfs@oss.sgi.com>; Thu, 14 Oct 2010 09:48:58 -0500
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E9A108F8050
	for <xfs@oss.sgi.com>; Thu, 14 Oct 2010 07:50:04 -0700 (PDT)
Subject: [PATCH 00/11] xfstests: rework src/randholes.c
From: Alex Elder <aelder@sgi.com>
Date: Thu, 14 Oct 2010 09:49:31 -0500
Message-ID: <1287067771.2362.202.camel@doink>
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
To: xfs@oss.sgi.com

Dave's recent "dynamic speculative EOF preallocation" changes
caused test 008 to no longer produce the kinds of holes it was
expecting to see, so it got me looking at the program it uses,
"src/randholes.c".

Since 008 is the only test using this program, it probably
doesn't deserve the attention I gave it yesterday, but I've
done the work so I might as well submit the series for
review and get my changes in.

The first patch in the series actually addresses two things
that are bugs.

The remaining 10 are just cleanup and refactoring changes.
Other than two bug fix changes and one change in output
when running in very-verbose mode, the patched code should
be pretty much functionally identical to before.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
