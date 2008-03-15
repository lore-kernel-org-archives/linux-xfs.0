Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 14 Mar 2008 21:33:18 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2F4X7vn023491
	for <xfs@oss.sgi.com>; Fri, 14 Mar 2008 21:33:11 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 66C2AFA5E16
	for <xfs@oss.sgi.com>; Fri, 14 Mar 2008 21:33:39 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id NKc24bJCy2v6EUwn for <xfs@oss.sgi.com>; Fri, 14 Mar 2008 21:33:39 -0700 (PDT)
Message-ID: <47DB51A3.70200@sandeen.net>
Date: Fri, 14 Mar 2008 23:33:39 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] fix dir2 shortform structures on ARM old ABI
References: <47DB4181.7040603@sandeen.net> <20080315041722.GA25621@josefsipek.net> <47DB4F4F.8030407@sandeen.net> <20080315042703.GA28242@josefsipek.net>
In-Reply-To: <20080315042703.GA28242@josefsipek.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
Cc: xfs-oss <xfs@oss.sgi.com>

Josef 'Jeff' Sipek wrote:
> On Fri, Mar 14, 2008 at 11:23:43PM -0500, Eric Sandeen wrote:
>> Josef 'Jeff' Sipek wrote:

>>> Shouldn't this be unconditional? Just because it ends up being ok on x86
>>> doesn't mean that it won't break some time later on...(do we want another
>>> bad_features2 incident?)
>> I think that packing structures when they don't need to be can actually
>> be harmful, efficiency-wise.  I read a nice explanation of this....
>> which I can't find now.
> 
> Agreed. For in-memory only structures it makes sense to let the compiler do
> whatever is the best, but for structures that are on-disk, you really have
> no choice, you have to have the same layout in memory - which frequently
> means packed. Unless I missed it, the structs you modified are on-disk, and
> therefore _must_ be the way the docs say - which happens to be packed.

Well, the docs probably don't actually say "packed" :) ... they just
assume standard/predictable layout of the structures.

So on almost all architectures they _don't_ need to be explicitly
packed, and it's my understanding that doing so when it's not neccessary
is harmful.  But these 3 cases, on the odd arm abi, do need it.

A QA test to run pahole on all disk structures to look for proper sizes
/ no holes might be good... though it require debug xfs (well, xfs built
with -g).

-Eric
