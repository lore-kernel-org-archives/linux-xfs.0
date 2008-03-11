Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 11 Mar 2008 13:09:37 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2BK9R6Y020972
	for <xfs@oss.sgi.com>; Tue, 11 Mar 2008 13:09:30 -0700
Received: from postoffice.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6FFBDF6983F
	for <xfs@oss.sgi.com>; Tue, 11 Mar 2008 13:09:57 -0700 (PDT)
Received: from postoffice.aconex.com (prod.aconex.com [203.89.192.138]) by cuda.sgi.com with ESMTP id fnouEMqIAVCFG0Jo for <xfs@oss.sgi.com>; Tue, 11 Mar 2008 13:09:57 -0700 (PDT)
Message-ID: <34665.192.168.3.1.1205266196.squirrel@mail.aconex.com>
In-Reply-To: <47D5DE13.8030902@sandeen.net>
References: <47D20F78.7000103@sandeen.net>
    <1205196252.15982.69.camel@edge.scott.net.au>
    <47D5DE13.8030902@sandeen.net>
Date: Wed, 12 Mar 2008 07:09:56 +1100 (EST)
Subject: Re: [PATCH, RFC] - remove mounpoint UUID code
From: nscott@aconex.com
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

> Nathan Scott wrote:
>
>
> (hope you didn't too much mind my quoting you in this thread) ;)

(hope you didn't mind too much my dissing your cleanup) :)

>> Since effectively all versions of XFS support this feature ondisk,
>> including complete support in recovery, it would be better IMO to
>> leave it in for someone to implement/experiment with the syscall
>> and auto-mounting userspace support.  That would then require no
>> new feature bits, mkfs/repair changes, etc.  There is effectively
>> zero cost to leaving it there - and non-zero cost in removing it,
>> if our seriously bad regression-via-cleanup history is anything
>> to go by ... :|
>
> the only cost to leaving it is having another instance of "ok now what
> the heck is THIS?!" ... death by a thousand cuts of xfs complexity.  But
> yeah, removing it has some risk too.

So, document it and move on.  It would be a fun little project to go and
experiment with this code a bit.  It amounts to a trivial amount of code
at the end of the day, and theres certainly nothing "complex" about it.

>> It would be really unfortunate to remove this, and then find that
>> it was useful to someone (who didn't know about it at this time).
>> OTOH, if there is definately never ever any chance this can ever
>> be useful, then it should indeed be removed. :)
>
> Well I'm not hung up about it.  If anyone thinks it'll be useful, I'm
> not bothered by leaving it as is.  So, Nathan, what are your plans for
> this code? *grin*

I don't have any immediate plans.  I can imagine it could be used to
stitch parts of the namespace together in a filesystem that supports
multiple devices (in a chunkfs kinda way) ... or maybe more simply
just an in-filesystem auto-mounter.  *shrug*.  But its there, the tools
support it (once again, I didn't see a userspace patch - hohum), so I
would vote for leaving it in its current form so some enterprising,
constructive young coder can try to make something useful from it
at some point.  :)

cheers.
