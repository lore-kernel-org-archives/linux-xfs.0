Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 02 Mar 2008 20:19:29 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m234JJPc008659
	for <xfs@oss.sgi.com>; Sun, 2 Mar 2008 20:19:21 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4DDE1F03727
	for <xfs@oss.sgi.com>; Sun,  2 Mar 2008 20:19:48 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id f2F3OcpDO8FwuXXn for <xfs@oss.sgi.com>; Sun, 02 Mar 2008 20:19:48 -0800 (PST)
Message-ID: <47CB7C44.2030508@sandeen.net>
Date: Sun, 02 Mar 2008 22:19:16 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [REVIEW] Don't make lazy counters default for mkfs
References: <op.t67mtawg3jf8g2@pc-bnaujok.melbourne.sgi.com> <1204166101.13569.102.camel@edge.scott.net.au> <47C87775.2010007@thebarn.com> <47C89137.3070805@sandeen.net> <47C89303.7070902@thebarn.com> <1204500895.10190.3.camel@edge.scott.net.au> <47CB434B.4040005@sgi.com> <47CB4696.1030304@sgi.com> <20080303011559.GB13879@josefsipek.net> <47CB7702.5080905@sandeen.net> <20080303041409.GC13879@josefsipek.net>
In-Reply-To: <20080303041409.GC13879@josefsipek.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
Cc: Mark Goodwin <markgw@sgi.com>, Timothy Shimmin <tes@sgi.com>, nscott@aconex.com, Russell Cattelan <cattelan@thebarn.com>, Barry Naujok <bnaujok@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Josef 'Jeff' Sipek wrote:
> On Sun, Mar 02, 2008 at 09:56:50PM -0600, Eric Sandeen wrote:
>> Josef 'Jeff' Sipek wrote:
>>> On Mon, Mar 03, 2008 at 11:30:14AM +1100, Mark Goodwin wrote:
>>> ...
>>>> Maybe I'm missing something, but if we export all the feature bits,
>>>> both new and old, then (a) an old mkfs will continue to ignore them,
>>>> and (b) future versions of mkfs will have all the information needed,
>>>> but will need t be smart about how that information is used.
>>> IMHO:
>>>
>>> 1) mkfs should make a filesystem, the defaults should be conservative (say
>>>    using features that have been around >1 year)
>> I suppose I have to agree, unfortunately that means most competetive
>> benchmarks will be using sub-optimal mkfs's, but...
>  
> Benchmarks that use default mkfs options on xfs, but non-default on other
> fs?

most benchmarks I see tune the heck out of "the home team" and leave the
rest ;)

> If you want, have a simple printf in mkfs that tells the user that he's not
> using the latest and greatest features (e.g., lazy-count); that should be
> enough to make it obvious that there're better options than the default.

eh, nobody reads that stuff :)

-Eric
