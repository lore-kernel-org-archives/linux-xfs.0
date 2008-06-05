Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 04 Jun 2008 22:51:29 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m555pIee022245
	for <xfs@oss.sgi.com>; Wed, 4 Jun 2008 22:51:19 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8543A1EBE89
	for <xfs@oss.sgi.com>; Wed,  4 Jun 2008 22:52:13 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id MUHnp6DoiwI7GJqb for <xfs@oss.sgi.com>; Wed, 04 Jun 2008 22:52:13 -0700 (PDT)
Message-ID: <48477F0C.80000@sandeen.net>
Date: Thu, 05 Jun 2008 00:52:12 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] fix dir2 shortform structures on ARM old ABI
References: <47DB4181.7040603@sandeen.net> <480E89B5.8070006@sandeen.net> <481B7FD1.3030107@sandeen.net> <20080505070847.GH155679365@sgi.com> <481FDCD1.2010905@sgi.com> <4820609C.9090306@sandeen.net> <48477BD6.2020909@sandeen.net> <20080605054938.GA17690@puku.stupidest.org>
In-Reply-To: <20080605054938.GA17690@puku.stupidest.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Wedgwood <cw@f00f.org>
Cc: Timothy Shimmin <tes@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Chris Wedgwood wrote:
> On Thu, Jun 05, 2008 at 12:38:30AM -0500, Eric Sandeen wrote:
> 
>> Guys, this is SIMPLE, SAFE, and it fixes a CORRUPTION BUG.
> 
> [...]
> 
>>>> As it only defines __arch_pack for __arm__,
> 
> __arch_pack is a horrible name and not very intuitive, what's wrong
> with __on_disk or something else?
> 

because __on_disk implies that it's on disk.

__arch_pack means that it's packed on some arches.

Not the same thing.

If anyone wants to change the name to __purple_ponies or whatever that's
fine, but the intent is to pack these 3(?) and only these 3 structs on
this arch and only this arch, at least for now.

'til Jeff gets his all-singing all-dancing no-regression gcc annotation
in place anyway.

-Eric
