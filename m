Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 03 Oct 2007 15:57:57 -0700 (PDT)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l93MvqwY000703
	for <xfs@oss.sgi.com>; Wed, 3 Oct 2007 15:57:54 -0700
Message-ID: <60338.192.168.3.1.1191452291.squirrel@mail.aconex.com>
In-Reply-To: <200710040027.16926.ak@suse.de>
References: <200710040027.16926.ak@suse.de>
Date: Thu, 4 Oct 2007 08:58:11 +1000 (EST)
Subject: Re: [PATCH] XFS bitops to Linux again
From: nscott@aconex.com
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andi Kleen <ak@suse.de>
Cc: xfs@oss.sgi.com

>
> This time against CVS
>
> Replace XFS bit functions with call Linux functions
>
> XFS had some own functions to find high and low bits.
>
> This patch replaces them with a call to the respective Linux functions.
> The semantics of the Linux functions differ a little, but i checked
> all call sites that they can deal with that.

Several of these call sites are also compiled in userspace in libxfs.  It
would
be a good idea from that POV also to keep some level of abstraction so that
these calls can be mapped to userspace routines as well.

> The resulting xfs.ko is about 500 bytes smaller on x86-64

Thats it?  To be honest, this sounds like just code churn and risk
introduction.
What testing was done?  Changes to some of these routines has introuced
subtle log recovery bugs in the past - has recovery been tested at all? 
The QA
suite has some log recovery tests, it'd be a good idea to verify with those..

cheers.

--
Nathan
