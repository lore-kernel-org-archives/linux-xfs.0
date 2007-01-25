Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 25 Jan 2007 16:10:16 -0800 (PST)
Received: from sigma957.cis.mcmaster.ca (sigma957.CIS.McMaster.CA [130.113.64.83])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0Q0A7qw004437
	for <xfs@oss.sgi.com>; Thu, 25 Jan 2007 16:10:08 -0800
Date: Thu, 25 Jan 2007 17:34:31 -0500 (EST)
From: Mark Hahn <hahn@mcmaster.ca>
Subject: Re: 2.6.20-rc5: cp 18gb 18gb.2 = OOM killer, reproducible just like
 2.16.19.2
In-Reply-To: <Pine.LNX.4.64.0701250407590.3673@p34.internal.lan>
Message-ID: <Pine.LNX.4.64.0701251731160.20455@coffee.psychology.mcmaster.ca>
References: <Pine.LNX.4.64.0701211424170.2552@p34.internal.lan>
 <20070122133735.GB4493@ucw.cz> <Pine.LNX.4.64.0701221348020.11525@p34.internal.lan>
 <Pine.LNX.4.64.0701241837550.2930@p34.internal.lan> <20070125003242.GA23343@elf.ucw.cz>
 <Pine.LNX.4.64.0701250407590.3673@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com

> Something is seriously wrong with that OOM killer.

do you know you don't have to operate in OOM-slaughter mode?

"vm.overcommit_memory = 2" in your /etc/sysctl.conf puts you 
into a mode where the kernel tracks your "committed" memory 
needs, and will eventually cause some allocations to fail.
this is often much nicer than the default random OOM slaughter.
(you probably also need to adjust vm.overcommit_ratio with 
some knowlege of your MemTotal and SwapTotal.)

regards, mark hahn.
