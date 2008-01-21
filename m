Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Jan 2008 09:14:09 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0LHE0u5018758
	for <linux-xfs@oss.sgi.com>; Mon, 21 Jan 2008 09:14:03 -0800
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7FE04CB275B
	for <linux-xfs@oss.sgi.com>; Mon, 21 Jan 2008 09:14:20 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id rttnTGE2kfDAHyYI for <linux-xfs@oss.sgi.com>; Mon, 21 Jan 2008 09:14:20 -0800 (PST)
Subject: Re: Known prob: MAX_LOCK_DEPTH too low?
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <4794C7C0.8030207@tlinx.org>
References: <47914FA7.1000807@tlinx.org> <1200918448.6341.5.camel@lappy>
	 <4794C7C0.8030207@tlinx.org>
Content-Type: text/plain
Date: Mon, 21 Jan 2008 18:13:49 +0100
Message-Id: <1200935629.6341.9.camel@lappy>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linda Walsh <lkml@tlinx.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux-Xfs <linux-xfs@oss.sgi.com>, Ingo Molnar <mingo@elte.hu>


On Mon, 2008-01-21 at 08:26 -0800, Linda Walsh wrote:
> Peter Zijlstra wrote:
> > On Fri, 2008-01-18 at 17:17 -0800, Linda Walsh wrote:
> >   
> >> On my x86_64 machine, I got the following message
> >> in log (kern = 2.6.23.14)
> >>
> >> Jan 16 04:08:38 Astara kernel: BUG: MAX_LOCK_DEPTH too low!
> >> Jan 16 04:08:38 Astara kernel: turning off the locking correctness 
> >> validator.
> >>
> >> Have no idea what caused it as I found the message on my console
> >> somewhat after the fact.  The system had been up over 24 hours and
> >> is still running.  System still seems 'fine' (been up 3 days now),
> >> so you can treat this as a "data point".
> >>     
> >
> > Are you perhaps an XFS user?
> >
> >   
> ----
>     Funny you should mention that...  yes.  However, there were no
> other messages that seem to indicate that the message had anything
> to do with XFS.  Nice shot in the dark.

:-), know issue, I guess I'll up the MAX_LOCK_DEPTH for the next
release. I looked at dynamically allocating that stuff, but that gets
awfully painful.
