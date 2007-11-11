Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 10 Nov 2007 20:48:40 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lAB4lu7o016633
	for <linux-xfs@oss.sgi.com>; Sat, 10 Nov 2007 20:48:01 -0800
Message-ID: <4736897F.4070202@sandeen.net>
Date: Sat, 10 Nov 2007 22:47:59 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: minor CPU wake-up question
References: <47364104.8020106@tlinx.org>
In-Reply-To: <47364104.8020106@tlinx.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linda Walsh <xfs@tlinx.org>
Cc: Linux-Xfs <linux-xfs@oss.sgi.com>

Linda Walsh wrote:
> I recently ran into "powertop" (fr. lesswatts.org) that shows how often
> interrupts awaken a processor under a tickless kernel.
> 
> The display indicates the counts are over a 10 second period. 
> Barring any disk activity, why would xfsbufd wake up each copy of itself
> up when there doesn't seem like there would be anything to do.
> 
> Is a separate process really needed for each partition (that seems to be
> the case)?  I don't know if it is 1 interrupt/bufd or 6 on 1, but
> it is fairly constant with 6 interrupts each period.
> FWIW, dirty_writeback_centiseconds is set to 1500(1499) and makes
> no difference in the count.
> 
> It doesn't seem to be a big deal, other than it is at the top of the
> interrupt-chart with usually 60% or more of the ticks.  Might be nice
> to not have it on top if it isn't necessary...

I think by default, xfsbufd wakes up each second for each filesystem.
See fs.xfs.xfsbufd_centisecs, default 100, or 1s.  I think powertop is
reporting wakeups/second, so it looks you have 6 filesystems mounted?

Honestly if that's your most frequent entry, you're probably doing
pretty well...

-Eric
