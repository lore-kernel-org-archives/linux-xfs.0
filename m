Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 12 Jun 2008 21:00:52 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5D40foY026016
	for <xfs@oss.sgi.com>; Thu, 12 Jun 2008 21:00:41 -0700
Message-ID: <4851F024.7020508@melbourne.sgi.com>
Date: Fri, 13 Jun 2008 13:57:24 +1000
From: Greg Banks <gnb@melbourne.sgi.com>
MIME-Version: 1.0
Subject: Re: Filestreams (and 64bit inodes)
References: <484B15A3.4030505@sauce.co.nz> <484CA425.3080606@sandeen.net> <484DDDB3.70000@sgi.com> <484F0998.90306@sauce.co.nz> <484F2CD7.9070506@sgi.com> <484F452A.8090909@sandeen.net> <48512A34.1020604@sandeen.net> <4851CD32.7080106@melbourne.sgi.com> <4851E774.2070401@sgi.com> <4851EC2D.6010504@melbourne.sgi.com> <4851EDB3.1010601@sandeen.net>
In-Reply-To: <4851EDB3.1010601@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: markgw@sgi.com, Timothy Shimmin <tes@sgi.com>, Richard Scobie <richard@sauce.co.nz>, xfs@oss.sgi.com

Eric Sandeen wrote:
> Greg Banks wrote:
>
>   
>>> (and the plan for statically linked apps? ...)
>>>       
>> Perhaps Fedora could enable the glibc magic for issuing warnings at link
>> time when those symbols are used, like what happens today if you use the
>> old unsafe gets() function:
>>
>> gnb@inara 1058> gcc -o fmeh x.c
>> /tmp/ccQhxIIo.o: In function `main':
>> x.c:(.text+0x18): warning: the `gets' function is dangerous and should not be used.
>>     
>
>
> It wouldn't help the automated builds (nobody'd see it)
Hmm.  I don't see a way in glibc to upgrade that warning to an error to
make those builds fail, at least in glibc 2.4.
>  but for normal
> user compilations that might be an option...
>
>   

Indeed.

-- 
Greg Banks, P.Engineer, SGI Australian Software Group.
The cake is *not* a lie.
I don't speak for SGI.
