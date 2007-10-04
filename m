Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 04 Oct 2007 13:44:29 -0700 (PDT)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l94KiNbA004107
	for <xfs@oss.sgi.com>; Thu, 4 Oct 2007 13:44:24 -0700
Message-ID: <34787.192.168.3.1.1191530551.squirrel@mail.aconex.com>
In-Reply-To: <200710041014.22936.ak@suse.de>
References: <200710040027.16926.ak@suse.de>
    <60338.192.168.3.1.1191452291.squirrel@mail.aconex.com>
    <200710041014.22936.ak@suse.de>
Date: Fri, 5 Oct 2007 06:42:31 +1000 (EST)
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

Hi Andi,

>> Several of these call sites are also compiled in userspace in libxfs.
>> It
>> would
>> be a good idea from that POV also to keep some level of abstraction so
>> that
>> these calls can be mapped to userspace routines as well.
>
> Again the same argument applies -- there is no difference if you
> map xfs_(high|low)bit or fls64/fls/find_find_bit() to something else.

Yep, indeed.  I guess what I'm saying is "just make sure userspace is
fixed up
too".  So, when you say "if you map...", instead say "when I did that
mapping it
wasn't a problem... patch is included" so that other people (i.e. Barry
here) get
less work to do to on the merge (and don't have to cleanup your cleanup).

>
>> What testing was done?  Changes to some of these routines has introuced
>> subtle log recovery bugs in the past - has recovery been tested at all?
>> The QA
>> suite has some log recovery tests, it'd be a good idea to verify with
>> those..
>
> I had a simple separate unit test to verify the 32bit space gave the same
> result. The only difference was the 0 case, but I checked all inputs
> manually. Usually they had != 0 tests already or zero was impossible;
>  in the few cases were not I added ASSERTs -- so if i got it wrong it
> should
> bomb out quickly.

Great.  You're light years ahead of the rest of the cleanup brigade. :)

> I did also some simple tests using the QA suite -- i believe a few logs
> were recovered -- but not the full tests.

>From a quick look, tests 085, 086 and 087 are the ones I was thinking of
yesterday.

>> To be honest, this sounds like just code churn and risk
>> introduction.
>
> Ok I got the message. I retract the patch. Sorry for bothering you
> with lowly cleanups.

Hey, I like cleanup as much as the next guy (as long as the next guy isn't
Eric,
he just lives to clean ;) - also always ignores userspace despite knowing
better)
- I just don't like seeing more work introduced for the people really
fixing stuff.
I'm sure the patch could be merged (given its been tested) if either
userspace is
updated too, or the same xfs_* naming convention was kept so that userspace
needs no changes.

cheers.

--
Nathan
