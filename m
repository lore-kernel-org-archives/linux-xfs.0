Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 03 Oct 2007 11:20:23 -0700 (PDT)
Received: from slurp.thebarn.com (cattelan-host202.dsl.visi.com [208.42.117.202])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l93IKHtg027754
	for <xfs@oss.sgi.com>; Wed, 3 Oct 2007 11:20:19 -0700
Message-ID: <4703DD5F.8080906@thebarn.com>
Date: Wed, 03 Oct 2007 13:20:15 -0500
From: Russell Cattelan <cattelan@thebarn.com>
MIME-Version: 1.0
Subject: Re: [PATCH] Replace XFS bit functions with Linux functions
References: <200710021010.58284.ak@suse.de> <470273C1.60300@thebarn.com> <200710031958.13422.ak@suse.de>
In-Reply-To: <200710031958.13422.ak@suse.de>
Content-Type: multipart/mixed;
 boundary="------------070300080201010504070703"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andi Kleen <ak@suse.de>
Cc: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------070300080201010504070703
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Andi Kleen wrote:
>> I would like to keep thing abstracted enough such that it is won't be to
>> difficult keep to map to the FreeBSD bit functions.
>>     
>
> It's no different to map linux bit functions to FreeBSD than mapping
> XFS bit functions to FreeBSD. Besides I expect it has fls already -- 
> that is actually a BSDism.
>
>   
Yes but for the most part the common code does not play favorites
to linux or bsd or X in terms of which platform is favored. (with some 
execptions).
I have been working getting the freebsd xfs code based updated and I've 
come
across calls to spin_lock that may need to redone.  I need to look at 
the XFS code
paths more to figure out which freebsd lock is needed.
For the most part freebsd tries not to use mutex spin_lock (disable 
interrupts and spin) since it is
more expensive that just mtx_lock (do not disable interrupts and spin 
for awhile then sleep)
and unless there is a good reason to disable interrupts they try 
avoiding doing so.

Playing favorites is kinda what has fueled this whole "ported half of 
irix to linux" FUD
that has dogged xfs forever.
So for the same reason that people complained about mapping irix calls 
to linux calls
I don't like the argument that linux calls should just be mapped to bsd 
calls.

And I agree with Dave the -1 adjustments are bit hard to follow and would
be better encapsulated in a inline call where it can be documented.

Having the xfs_ call in the common code would also allow the fbsd port 
to catch up with
this optimization  as some point vs having to back stitch the current 
code into  common layer
and eventually having to realign.

> -Andi
>
>   


--------------070300080201010504070703
Content-Type: text/x-vcard; charset=utf-8;
 name="cattelan.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="cattelan.vcf"

begin:vcard
fn:Russell Cattelan
n:Cattelan;Russell
email;internet:cattelan@thebarn.com
x-mozilla-html:FALSE
version:2.1
end:vcard


--------------070300080201010504070703--
