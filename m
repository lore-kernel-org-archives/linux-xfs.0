Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 25 Jan 2007 16:23:05 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0Q0Mwqw011796
	for <xfs@oss.sgi.com>; Thu, 25 Jan 2007 16:23:00 -0800
Date: Thu, 25 Jan 2007 19:22:04 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 2.6.20-rc5: cp 18gb 18gb.2 = OOM killer, reproducible just like
 2.16.19.2
In-Reply-To: <Pine.LNX.4.64.0701251731160.20455@coffee.psychology.mcmaster.ca>
Message-ID: <Pine.LNX.4.64.0701251921430.30148@p34.internal.lan>
References: <Pine.LNX.4.64.0701211424170.2552@p34.internal.lan>
 <20070122133735.GB4493@ucw.cz> <Pine.LNX.4.64.0701221348020.11525@p34.internal.lan>
 <Pine.LNX.4.64.0701241837550.2930@p34.internal.lan> <20070125003242.GA23343@elf.ucw.cz>
 <Pine.LNX.4.64.0701250407590.3673@p34.internal.lan>
 <Pine.LNX.4.64.0701251731160.20455@coffee.psychology.mcmaster.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mark Hahn <hahn@mcmaster.ca>
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com



On Thu, 25 Jan 2007, Mark Hahn wrote:

> > Something is seriously wrong with that OOM killer.
> 
> do you know you don't have to operate in OOM-slaughter mode?
> 
> "vm.overcommit_memory = 2" in your /etc/sysctl.conf puts you into a mode where
> the kernel tracks your "committed" memory needs, and will eventually cause
> some allocations to fail.
> this is often much nicer than the default random OOM slaughter.
> (you probably also need to adjust vm.overcommit_ratio with some knowlege of
> your MemTotal and SwapTotal.)
> 
> regards, mark hahn.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

# sysctl -a | grep vm.over
vm.overcommit_ratio = 50
vm.overcommit_memory = 0

I'll have to experiment with these options, thanks for the info!

Justin.
