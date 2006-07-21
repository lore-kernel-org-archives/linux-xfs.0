Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 21 Jul 2006 16:00:32 -0700 (PDT)
Received: from lilly.ping.de (lilly.ping.de [83.97.42.2])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6LMxWDW012337
	for <xfs@oss.sgi.com>; Fri, 21 Jul 2006 15:59:39 -0700
Date: Sat, 22 Jul 2006 00:53:04 +0200
From: Jochen Heuer <jogi-kernel@planetzork.ping.de>
Subject: Re: BUG: soft lockup detected on CPU#1!
Message-ID: <20060721225304.GA12184@planetzork.ping.de>
References: <20060717125216.GA15481@planetzork.ping.de> <1153146608.1218.9.camel@localhost.localdomain> <20060717144831.GA28284@planetzork.ping.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060717144831.GA28284@planetzork.ping.de>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>, nathans@sgi.com, xfs@oss.sgi.com

On Mon, Jul 17, 2006 at 04:48:31PM +0200, Jochen Heuer wrote:
> On Mon, Jul 17, 2006 at 10:30:08AM -0400, Steven Rostedt wrote:
> > 
> > Jochen, you didn't say whether or not the 2.6.18-rc2 locked up. I'm
> > assuming it did. But did it?
> 
> Hi Steven,
> 
> no, it did not lock up yet but I did not do any "serious" webbrowsing
> with 2.6.18-rc2 so far.

Hi,

well, it locks up with 2.6.18-rc2 too. Three times today. And always during
webbrowsing ... What's so special about it? Could it be because it accesses
network and disk at the same time?

The system has been pretty busy compiling the last days because I did setup a
new Gentoo system in chroot environment. No problem whatsoever. I did run
2 x mprime for a day and also no problem.

Is there anything I can test? Disable irq balancing? Disabling preemption did
not help. Disabling IO-APIC? What can I do to help isolate the problem because
it really is annoying and I don't like pushing the reset button. Because if the
system locks up *really* nothing works. The screen is frozen, no mouse, no
keyboard, no sys-rq, no network ... nothing.

Thanks for your help and best regards,

   Jochen
