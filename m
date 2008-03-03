Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 02 Mar 2008 16:18:51 -0800 (PST)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m230Iglo024341
	for <xfs@oss.sgi.com>; Sun, 2 Mar 2008 16:18:43 -0800
Message-ID: <47CB43EE.3060405@sgi.com>
Date: Mon, 03 Mar 2008 11:18:54 +1100
From: Donald Douwsma <donaldd@sgi.com>
MIME-Version: 1.0
Subject: Re: [REVIEW] Don't make lazy counters default for mkfs
References: <op.t67mtawg3jf8g2@pc-bnaujok.melbourne.sgi.com>	 <1204166101.13569.102.camel@edge.scott.net.au>	 <47C87775.2010007@thebarn.com> <47C89137.3070805@sandeen.net>	 <47C89303.7070902@thebarn.com> <1204500895.10190.3.camel@edge.scott.net.au>
In-Reply-To: <1204500895.10190.3.camel@edge.scott.net.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: nscott@aconex.com
Cc: Russell Cattelan <cattelan@thebarn.com>, Eric Sandeen <sandeen@sandeen.net>, Barry Naujok <bnaujok@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Nathan Scott wrote:
> On Fri, 2008-02-29 at 17:19 -0600, Russell Cattelan wrote:
>>> I thought about that; xfs *could* stick someting in /proc/fs/xfs
>> with
>>> supported features or somesuch.
>>>
>>> But, the kernel you mkfs under isn't necessarily the one you're
>> going to
>>> need to fall back to tomorrow, though...
>>>
>>>   
>> True but at least it could make a bit of a intelligent decision.
>> and maybe a warning for a while about potentially incompatible flags. 
> 
> Might also be a good idea to require -f to force a mkfs of a filesystem
> which the kernel doesn't support.

Could work but I dont like the idea of using -f for anything but mkfsing an
existing filesystem. If that becomes habit for people it could lead to disasters.

Don
