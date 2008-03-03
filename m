Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 02 Mar 2008 20:48:28 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m234m7m8011242
	for <xfs@oss.sgi.com>; Sun, 2 Mar 2008 20:48:09 -0800
Received: from mail.sceen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 18E1CF035CF
	for <xfs@oss.sgi.com>; Sun,  2 Mar 2008 20:48:36 -0800 (PST)
Received: from mail.sceen.net (sceen.net [213.41.243.68]) by cuda.sgi.com with ESMTP id WdYDvQQgXa8Or2ms for <xfs@oss.sgi.com>; Sun, 02 Mar 2008 20:48:36 -0800 (PST)
From: Niv Sardi <xaiki@cxhome.ath.cx>
Subject: Re: [REVIEW] Don't make lazy counters default for mkfs
References: <op.t67mtawg3jf8g2@pc-bnaujok.melbourne.sgi.com>
	<1204166101.13569.102.camel@edge.scott.net.au>
	<47C87775.2010007@thebarn.com> <47C89137.3070805@sandeen.net>
	<47C89303.7070902@thebarn.com>
	<1204500895.10190.3.camel@edge.scott.net.au>
	<47CB434B.4040005@sgi.com> <47CB4696.1030304@sgi.com>
Date: Mon, 03 Mar 2008 15:47:39 +1100
In-Reply-To: <47CB4696.1030304@sgi.com> (Mark Goodwin's message of "Mon, 03
	Mar 2008 11:30:14 +1100")
Message-ID: <ncclk50ifbo.fsf@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: markgw@sgi.com
Cc: Timothy Shimmin <tes@sgi.com>, nscott@aconex.com, Russell Cattelan <cattelan@thebarn.com>, Eric Sandeen <sandeen@sandeen.net>, Barry Naujok <bnaujok@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Mark Goodwin <markgw@sgi.com> writes:

> Timothy Shimmin wrote:
>> Nathan Scott wrote:
>>> On Fri, 2008-02-29 at 17:19 -0600, Russell Cattelan wrote:
>>>>> I thought about that; xfs *could* stick someting in /proc/fs/xfs
>>>> with
>>>>> supported features or somesuch.
>>>>>
>>>>> But, the kernel you mkfs under isn't necessarily the one you're
>>>> going to
>>>>> need to fall back to tomorrow, though...
>>>>>
>>>>>   
>>>> True but at least it could make a bit of a intelligent decision.
>>>> and maybe a warning for a while about potentially incompatible
>>>> flags. 
>>>
>>> Might also be a good idea to require -f to force a mkfs of a filesystem
>>> which the kernel doesn't support.
>>>
>>      974981: mkfs.xfs should warn if it is about to create a fs that
>> cannot be mounted
>>
>> Ivan was wanting this in December last year. Remember, Mark?
>> He wanted to know what XFS features the running kernel supported?
>
> It was worse than that - IIRC, he wanted to know what features are
> supported by the XFS kernel module he just installed (this was part
> of an Appman upgrade scenario). I thought we rejected that bug ?
>
>>
>> I don't think Dave (dgc) and others were not so keen on it IIRC.
>
> anyone recall the reasons?

Yes, we got to the consensus that having mkfs check for kernel stuff is
plain wrong, and there are a load of reasons to that, the most
convincing is that you can have no XFS support in the kernel at mkfs
time (i.e. module, that'll be loaded only on mount). Others reasons go
along the line of:
* You could be mkfsing for another box/kernel.
* We want people to run latest kernels if they run latest xfsprogs =)

Cheers,
-- 
Niv Sardi
