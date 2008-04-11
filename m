Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 11 Apr 2008 08:12:16 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3BFBtem010543
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 08:11:57 -0700
Received: from slurp.thebarn.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 123349B54F8
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 08:01:44 -0700 (PDT)
Received: from slurp.thebarn.com (cattelan-host202.dsl.visi.com [208.42.117.202]) by cuda.sgi.com with ESMTP id MPKy22OT2KoYBYwq for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 08:01:44 -0700 (PDT)
Message-ID: <47FF7D47.40007@thebarn.com>
Date: Fri, 11 Apr 2008 10:01:27 -0500
From: Russell Cattelan <cattelan@thebarn.com>
MIME-Version: 1.0
Subject: Re: Portability of libattr
References: <20080409184103.GD20142@album.bayer.ipv6ia.org> <20080409185445.GA30834@infradead.org>
In-Reply-To: <20080409185445.GA30834@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, petr.pisar@atlas.cz

Christoph Hellwig wrote:
> On Wed, Apr 09, 2008 at 08:41:08PM +0200, petr.pisar@atlas.cz wrote:
>   
>> Hello,
>>
>> I'm adding support for extended atributes into few applications.
>> Unfortunatetally API for EA manipulation is not standartized and every
>> operating system uses its own solution. I thought libattr from attr package
>> could help me. However attr seems running on Linux (and maybe IRIX) only.
>>
>> Therefore I've decided to use libc functions from every system directly. I've
>> succesfully ported my code to Linux, IRIX and Darwin (Max OS X). Their AE
>> syscalls are very similar. However FreeBSD API is more different. Because I'm
>> extending more applications I need to share the code.
>>
>> So, my qustions are: should I write my own library or should I extend libattr.
>> As I can understand libattr code it's designed to port IRIX application on
>> Linux. Am I right? Or are you going support more OS's in libattr? Or exists
>> here some similar library providing unified interface fro more systems?
>>     
>
> Note: I'm not the maintainer of libattr, so I'm not the one to decide.
>
> I think adding more systems is an excellent idea as it's a bit of a
> porting layer already.  Russell will have to add FreeBSD support anyway
> once he ports xfsdump to FreeBSD :)
>
>   
nod.

I have not looked closely at the FreeBSD EA stuff so I don't know how 
different things
are. I can't imagine they are that far off?

I thought the libattr code does compile on IRIX. There was an effort at 
one point to only
have one usespace code base that worked on both linux and irix.

I would be really cool if we got FreeBSD support into libattr.

-Russell
