Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 02 Mar 2008 16:31:41 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m230VIjx030322
	for <xfs@oss.sgi.com>; Sun, 2 Mar 2008 16:31:20 -0800
Message-ID: <47CB4696.1030304@sgi.com>
Date: Mon, 03 Mar 2008 11:30:14 +1100
From: Mark Goodwin <markgw@sgi.com>
Reply-To: markgw@sgi.com
MIME-Version: 1.0
Subject: Re: [REVIEW] Don't make lazy counters default for mkfs
References: <op.t67mtawg3jf8g2@pc-bnaujok.melbourne.sgi.com>	 <1204166101.13569.102.camel@edge.scott.net.au>	 <47C87775.2010007@thebarn.com> <47C89137.3070805@sandeen.net>	 <47C89303.7070902@thebarn.com> <1204500895.10190.3.camel@edge.scott.net.au> <47CB434B.4040005@sgi.com>
In-Reply-To: <47CB434B.4040005@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: nscott@aconex.com, Russell Cattelan <cattelan@thebarn.com>, Eric Sandeen <sandeen@sandeen.net>, Barry Naujok <bnaujok@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>



Timothy Shimmin wrote:
> Nathan Scott wrote:
>> On Fri, 2008-02-29 at 17:19 -0600, Russell Cattelan wrote:
>>>> I thought about that; xfs *could* stick someting in /proc/fs/xfs
>>> with
>>>> supported features or somesuch.
>>>>
>>>> But, the kernel you mkfs under isn't necessarily the one you're
>>> going to
>>>> need to fall back to tomorrow, though...
>>>>
>>>>   
>>> True but at least it could make a bit of a intelligent decision.
>>> and maybe a warning for a while about potentially incompatible flags. 
>>
>> Might also be a good idea to require -f to force a mkfs of a filesystem
>> which the kernel doesn't support.
>>
>      
> 974981: mkfs.xfs should warn if it is about to create a fs that cannot 
> be mounted
> 
> Ivan was wanting this in December last year. Remember, Mark?
> He wanted to know what XFS features the running kernel supported?

It was worse than that - IIRC, he wanted to know what features are
supported by the XFS kernel module he just installed (this was part
of an Appman upgrade scenario). I thought we rejected that bug ?

> 
> I don't think Dave (dgc) and others were not so keen on it IIRC.

anyone recall the reasons?

Maybe I'm missing something, but if we export all the feature bits,
both new and old, then (a) an old mkfs will continue to ignore them,
and (b) future versions of mkfs will have all the information needed,
but will need t be smart about how that information is used.

Cheers

-- 

  Mark Goodwin                                  markgw@sgi.com
  Engineering Manager for XFS and PCP    Phone: +61-3-99631937
  SGI Australian Software Group           Cell: +61-4-18969583
-------------------------------------------------------------
