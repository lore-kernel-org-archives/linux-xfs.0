Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 29 Jul 2006 15:24:54 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6TMNTDW010676
	for <xfs@oss.sgi.com>; Sat, 29 Jul 2006 15:23:29 -0700
Message-ID: <44CBDFC9.3040202@sandeen.net>
Date: Sat, 29 Jul 2006 17:23:05 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] kill leftover WANT_FUNCS macro indirection
References: <44CAE247.6020608@sandeen.net> <p73k65w41je.fsf@verdi.suse.de>
In-Reply-To: <p73k65w41je.fsf@verdi.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andi Kleen <ak@suse.de>, xfs@oss.sgi.com

Andi Kleen wrote:
> Eric Sandeen <sandeen@sandeen.net> writes:
> 
>> This gets rid of some pointless macro defines... I had a version that
>> lower-cased it all too but Nathan liked this better, and he's the man!
>> :)
> 
> Shouted function names is not exactly Linux code style at least.
> 
> -Andi
> 

well, *shrug* I have both versions, Nathan can take his pick :)

honestly, one-liner static inlines isn't exactly linux code style either, tho 
the typechecking is nice.

I guess I shouldn't have said "Nathan liked this better" - I think he was being 
pragmatic about the scope of the change.

-Eric
