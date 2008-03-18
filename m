Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 17 Mar 2008 21:30:46 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2I4UYwX023602
	for <xfs@oss.sgi.com>; Mon, 17 Mar 2008 21:30:37 -0700
Message-ID: <47DF4584.8000002@sgi.com>
Date: Tue, 18 Mar 2008 15:31:00 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] fix dir2 shortform structures on ARM old ABI
References: <47DB4181.7040603@sandeen.net> <20080315041722.GA25621@josefsipek.net> <47DB4F4F.8030407@sandeen.net> <20080315042703.GA28242@josefsipek.net> <47DB51A3.70200@sandeen.net> <20080315045147.GB28242@josefsipek.net> <47DEB930.7020108@sandeen.net> <47DF0044.6080704@sgi.com> <20080317234219.GD16500@josefsipek.net>
In-Reply-To: <20080317234219.GD16500@josefsipek.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

Josef 'Jeff' Sipek wrote:
> On Tue, Mar 18, 2008 at 10:35:32AM +1100, Timothy Shimmin wrote:
>> Eric Sandeen wrote:
>>> Josef 'Jeff' Sipek wrote:
>>>> Josef 'Jeff' Sipek, wondering exactly how passionate one can get about
>>>> structure member alignment :)
>>> Very.  ;)
>>> Tossing packed at all the ondisk stuctures bloats things badly on ia64.
>>> cvs/linux-2.6-xfs> wc -l before.dis
>>> 166688 before.dis
>>> cvs/linux-2.6-xfs> wc -l after.dis
>>> 182294 after.dis
>>> That's +15606 lines.
>>> http://digitalvampire.org/blog/index.php/2006/07/31/why-you-shouldnt-use-__attribute__packed/
>> Interesting.
>> So the problem there is that gcc is doing the wrong thing
>> on some arches (the example being ia64, sparc64).
> 
> Actually, it's not doing the wrong thing...
> 
> __attribute__((packed)) means:
> 
> 1) condense the members of the struct leaving NO padding bytes
> 
> 2) do NOT assume the entire structure is aligned on any boundary
>
Okay I only knew about (1) - cause that sounds more like "pack"ing to me.
So you can't assume alignment for the start of the variable
without aligned() if you use packed - Ok.

Thanks,
--Tim

> This means, that even if you have a member that'd be nicely aligned without
> the packed attribute (see below), the compiler will generate worst case
> alignment code.
> 
> struct foo {
> 	u64 a;
> } __attribute__((packed));
> 
> You can put struct foo anywhere in memory, and the code accessing ->a will
> _always_ work.
> 
> Using __attribute((packed,aligned(4))), tells it that the structure as a
> whole will be aligned on a 4-byte boundary, but there should be no padding
> bytes inserted.
> 
> Josef 'Jeff' Sipek.
> 
