Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 17 Mar 2008 16:43:49 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2HNhc3u024422
	for <xfs@oss.sgi.com>; Mon, 17 Mar 2008 16:43:40 -0700
Received: from filer.fsl.cs.sunysb.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 36067FBDE83
	for <xfs@oss.sgi.com>; Mon, 17 Mar 2008 16:44:10 -0700 (PDT)
Received: from filer.fsl.cs.sunysb.edu (filer.fsl.cs.sunysb.edu [130.245.126.2]) by cuda.sgi.com with ESMTP id zVeUAeq5zakjjx95 for <xfs@oss.sgi.com>; Mon, 17 Mar 2008 16:44:10 -0700 (PDT)
Date: Mon, 17 Mar 2008 19:42:19 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [PATCH] fix dir2 shortform structures on ARM old ABI
Message-ID: <20080317234219.GD16500@josefsipek.net>
References: <47DB4181.7040603@sandeen.net> <20080315041722.GA25621@josefsipek.net> <47DB4F4F.8030407@sandeen.net> <20080315042703.GA28242@josefsipek.net> <47DB51A3.70200@sandeen.net> <20080315045147.GB28242@josefsipek.net> <47DEB930.7020108@sandeen.net> <47DF0044.6080704@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47DF0044.6080704@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On Tue, Mar 18, 2008 at 10:35:32AM +1100, Timothy Shimmin wrote:
> Eric Sandeen wrote:
>> Josef 'Jeff' Sipek wrote:
>>> Josef 'Jeff' Sipek, wondering exactly how passionate one can get about
>>> structure member alignment :)
>> Very.  ;)
>> Tossing packed at all the ondisk stuctures bloats things badly on ia64.
>> cvs/linux-2.6-xfs> wc -l before.dis
>> 166688 before.dis
>> cvs/linux-2.6-xfs> wc -l after.dis
>> 182294 after.dis
>> That's +15606 lines.
>> http://digitalvampire.org/blog/index.php/2006/07/31/why-you-shouldnt-use-__attribute__packed/
> Interesting.
> So the problem there is that gcc is doing the wrong thing
> on some arches (the example being ia64, sparc64).

Actually, it's not doing the wrong thing...

__attribute__((packed)) means:

1) condense the members of the struct leaving NO padding bytes

2) do NOT assume the entire structure is aligned on any boundary

This means, that even if you have a member that'd be nicely aligned without
the packed attribute (see below), the compiler will generate worst case
alignment code.

struct foo {
	u64 a;
} __attribute__((packed));

You can put struct foo anywhere in memory, and the code accessing ->a will
_always_ work.

Using __attribute((packed,aligned(4))), tells it that the structure as a
whole will be aligned on a 4-byte boundary, but there should be no padding
bytes inserted.

Josef 'Jeff' Sipek.

-- 
Penguin : Linux version 2.6.23.1 on an i386 machine (6135.23 BogoMips).
