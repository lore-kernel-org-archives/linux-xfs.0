Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Jul 2006 15:57:57 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [66.45.37.187])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6KMvXDW001463
	for <xfs@oss.sgi.com>; Thu, 20 Jul 2006 15:57:34 -0700
Date: Thu, 20 Jul 2006 18:57:11 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: FAQ updated (was Re: XFS breakage...)
In-Reply-To: <Pine.LNX.4.64.0607201855270.2652@p34.internal.lan>
Message-ID: <Pine.LNX.4.64.0607201856320.2652@p34.internal.lan>
References: <20060718222941.GA3801@stargate.galaxy>
 <20060719085731.C1935136@wobbly.melbourne.sgi.com> <1153304468.3706.4.camel@localhost>
 <20060720171310.B1970528@wobbly.melbourne.sgi.com> <44BF8500.1010708@dgreaves.com>
 <20060720161121.GA26748@tuatara.stupidest.org> <20060721081452.B1990742@wobbly.melbourne.sgi.com>
 <Pine.LNX.4.64.0607201817450.23697@p34.internal.lan>
 <20060721082448.C1990742@wobbly.melbourne.sgi.com>
 <Pine.LNX.4.64.0607201843020.2619@p34.internal.lan>
 <20060721085230.F1990742@wobbly.melbourne.sgi.com>
 <Pine.LNX.4.64.0607201855270.2652@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nathans@sgi.com>
Cc: Chris Wedgwood <cw@f00f.org>, David Greaves <david@dgreaves.com>, Kasper Sandberg <lkml@metanurb.dk>, Torsten Landschoff <torsten@debian.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, ml@magog.se, radsaq@gmail.com

Erm, the xfs_repair -n only prints out what it needs to fix, I read 
somewhere that xfs_repair may make things worse?

What is the 'correct' fix?

On Thu, 20 Jul 2006, Justin Piszcz wrote:

> Nasty!
>
>        - agno = 37
> No modify flag set, skipping phase 5
> Phase 6 - check inode connectivity...
>        - traversing filesystem starting at / ...
> free block 16777216 for directory inode 2684356622 bad nused
> free block 16777216 for directory inode 2147485710 bad nused
>        - traversal finished ...
>        - traversing all unattached subtrees ...
>        - traversals finished ...
>        - moving disconnected inodes to lost+found ...
> Phase 7 - verify link counts...
> No modify flag set, skipping filesystem flush and exiting.
> p34:~#
>
> I applied the "one line fix" - I should be ok now?
>
>
>
> On Fri, 21 Jul 2006, Nathan Scott wrote:
>
>> On Thu, Jul 20, 2006 at 06:43:34PM -0400, Justin Piszcz wrote:
>>> p34:~# xfs_check -v /dev/md3
>>> xfs_check: out of memory
>>> p34:~#
>>> 
>>> D'oh...
>> 
>> xfs_repair -n is another option, it has a cheaper (memory wise,
>> usually) checking algorithm.
>> 
>>> As long as it mounted ok with the patched kernel, should one be ok?
>> 
>> Not necessarily, no - mount will only read the root inode.
>> 
>> cheers.
>> 
>> -- 
>> Nathan
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>> 
>
