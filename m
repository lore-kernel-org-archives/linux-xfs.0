Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Jul 2006 16:15:54 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [66.45.37.187])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6KNFWDW004961
	for <xfs@oss.sgi.com>; Thu, 20 Jul 2006 16:15:33 -0700
Date: Thu, 20 Jul 2006 19:15:10 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: FAQ updated (was Re: XFS breakage...)
In-Reply-To: <20060720231245.GA32195@tuatara.stupidest.org>
Message-ID: <Pine.LNX.4.64.0607201914530.20652@p34.internal.lan>
References: <44BF8500.1010708@dgreaves.com> <20060720161121.GA26748@tuatara.stupidest.org>
 <20060721081452.B1990742@wobbly.melbourne.sgi.com>
 <Pine.LNX.4.64.0607201817450.23697@p34.internal.lan>
 <20060721082448.C1990742@wobbly.melbourne.sgi.com>
 <Pine.LNX.4.64.0607201843020.2619@p34.internal.lan>
 <20060721085230.F1990742@wobbly.melbourne.sgi.com>
 <Pine.LNX.4.64.0607201855270.2652@p34.internal.lan>
 <20060721090015.G1990742@wobbly.melbourne.sgi.com>
 <Pine.LNX.4.64.0607201910010.20652@p34.internal.lan>
 <20060720231245.GA32195@tuatara.stupidest.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Wedgwood <cw@f00f.org>
Cc: Nathan Scott <nathans@sgi.com>, David Greaves <david@dgreaves.com>, Kasper Sandberg <lkml@metanurb.dk>, Torsten Landschoff <torsten@debian.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, ml@magog.se, radsaq@gmail.com

Thanks, that was it, after removing the lost+found directory & re-running 
xfs_repair, I no longer have any errors, onthat device anyway.


On Thu, 20 Jul 2006, Chris Wedgwood wrote:

> On Thu, Jul 20, 2006 at 07:10:46PM -0400, Justin Piszcz wrote:
>
>> I can run this over and over, and the result is the same?
>
> lost+found is recreated every time, rename it and you'll get less
> output
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
