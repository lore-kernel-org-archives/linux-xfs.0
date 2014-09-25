Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 72AC37F80
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 02:19:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 43E088F8035
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 00:19:19 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	VFR3PpyQKDikm9hn for <xfs@oss.sgi.com>;
	Thu, 25 Sep 2014 00:19:07 -0700 (PDT)
Date: Thu, 25 Sep 2014 17:18:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Occassional problems with unfreeze
Message-ID: <20140925071852.GE4758@dastard>
References: <CAD2VtSjwu3eB+mrs2vX0G4+MJbHyNGVXvVR+P_ssNY6rydvijA@mail.gmail.com>
	<20140716124757.GC36312@bfoster.bfoster>
	<CAD2VtShVThd0j0-YgGE6fAe28DJ1U-CCRR3Sj9eNjTLKp7FygA@mail.gmail.com>
	<CAD2VtSgdYt2zxmEeWEXmK2B44BKuB-wRKvX4H=jRA9Rj7pyamA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAD2VtSgdYt2zxmEeWEXmK2B44BKuB-wRKvX4H=jRA9Rj7pyamA@mail.gmail.com>
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
To: Hrishikesh Barua <talonx@gmail.com>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Thu, Sep 25, 2014 at 11:37:47AM +0530, Hrishikesh Barua wrote:
> This happened again yesterday and I took the "echo w >
> /proc/sysrq-trigger".
> Output - http://pastebin.com/rpKNSYY7

How long have you been ignoring these messages for?

[30278027.798067] XFS (xvdj): xlog_space_left: head behind tail
[30278027.798069]   tail_cycle = 1085, tail_bytes = 1041920
[30278027.798070]   GH   cycle = 1085, GH   bytes = 1039296

XFS is emitting that warning several times a second. Isn't that a
pretty good sign that there's something not quite right and is worth
reporting?

Indeed, you are running an old kern (3.2.0-54) which means it won't
have this fix:

3948659 xfs: Account log unmount transaction correctly

And that's likely to be the source of all your freeze/unfreeze
problems because it will eventually hang the log when it's leaked
all it's space in the ether....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
