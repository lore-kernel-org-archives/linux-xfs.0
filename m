Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 04 Oct 2007 01:16:22 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l948GFrW012998
	for <xfs@oss.sgi.com>; Thu, 4 Oct 2007 01:16:18 -0700
From: Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] XFS bitops to Linux again
Date: Thu, 4 Oct 2007 10:14:22 +0200
References: <200710040027.16926.ak@suse.de> <60338.192.168.3.1.1191452291.squirrel@mail.aconex.com>
In-Reply-To: <60338.192.168.3.1.1191452291.squirrel@mail.aconex.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710041014.22936.ak@suse.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: nscott@aconex.com
Cc: xfs@oss.sgi.com


> Several of these call sites are also compiled in userspace in libxfs.  It
> would
> be a good idea from that POV also to keep some level of abstraction so that
> these calls can be mapped to userspace routines as well.

Again the same argument applies -- there is no difference if you
map xfs_(high|low)bit or fls64/fls/find_find_bit() to something else.

> > The resulting xfs.ko is about 500 bytes smaller on x86-64
>
> Thats it?  

It's probably a little faster too (admittedly unlikely to be really 
measurable in a macro benchmark) and the source code is smaller.

> What testing was done?  Changes to some of these routines has introuced
> subtle log recovery bugs in the past - has recovery been tested at all?
> The QA
> suite has some log recovery tests, it'd be a good idea to verify with
> those..

I had a simple separate unit test to verify the 32bit space gave the same 
result. The only difference was the 0 case, but I checked all inputs
manually. Usually they had != 0 tests already or zero was impossible;
 in the few cases were not I added ASSERTs -- so if i got it wrong it should 
bomb out quickly.

I did also some simple tests using the QA suite -- i believe a few logs 
were recovered -- but not the full tests. 

> To be honest, this sounds like just code churn and risk 
> introduction.

Ok I got the message. I retract the patch. Sorry for bothering you
with lowly cleanups.

-Andi
