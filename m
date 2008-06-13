Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 12 Jun 2008 20:43:47 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5D3hheT024452
	for <xfs@oss.sgi.com>; Thu, 12 Jun 2008 20:43:43 -0700
Message-ID: <4851EC2D.6010504@melbourne.sgi.com>
Date: Fri, 13 Jun 2008 13:40:29 +1000
From: Greg Banks <gnb@melbourne.sgi.com>
MIME-Version: 1.0
Subject: Re: Filestreams (and 64bit inodes)
References: <484B15A3.4030505@sauce.co.nz> <484CA425.3080606@sandeen.net> <484DDDB3.70000@sgi.com> <484F0998.90306@sauce.co.nz> <484F2CD7.9070506@sgi.com> <484F452A.8090909@sandeen.net> <48512A34.1020604@sandeen.net> <4851CD32.7080106@melbourne.sgi.com> <4851E774.2070401@sgi.com>
In-Reply-To: <4851E774.2070401@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: markgw@sgi.com
Cc: Eric Sandeen <sandeen@sandeen.net>, Timothy Shimmin <tes@sgi.com>, Richard Scobie <richard@sauce.co.nz>, xfs@oss.sgi.com

Mark Goodwin wrote:
>
>
> Greg Banks wrote:
>> Eric Sandeen wrote:
>>>    4070 29.1% are scripts (shell, perl, whatever)
>>>    6598 47.2% don't use any stat() family calls at all
>>>    1829 13.1% use 32-bit stat() family interfaces only
>>>    1312  9.4% use 64-bit stat64() family interfaces only
>>>     180  1.3% use both 32-bit and 64-bit stat() family interfaces
>>>
>> Ouch.  That's over two thousand executables to patch, rebuild, and ship.
>>> list of packages, sorted by the semi-lame "number of files in package
>>> which call a 32-bit stat variant" metric:
>>>
>>> http://sandeen.fedorapeople.org/stat32-ers
>
> struct dirent has an embedded ino_t too, so for completeness we should
> also
> be looking for readdir(), readdir64(), getdirentries(),
> getdirentries64(), etc.
Good point.  Looking in the code, it seems the getdents common code in
glibc will fail with EOVERFLOW if the inode number gets truncated during
64b-32b translation, just like the stat() family.  I'll need to improve
the scanning tool :-)
>
>>> I'm going to see if I can't leverage Fedora to clean some of this up.
>>>
>>> -Eric
>>>
>> Good luck with that.
>
> Yes good luck :)
> (and the plan for statically linked apps? ...)

Perhaps Fedora could enable the glibc magic for issuing warnings at link
time when those symbols are used, like what happens today if you use the
old unsafe gets() function:

gnb@inara 1058> gcc -o fmeh x.c
/tmp/ccQhxIIo.o: In function `main':
x.c:(.text+0x18): warning: the `gets' function is dangerous and should not be used.




-- 
Greg Banks, P.Engineer, SGI Australian Software Group.
The cake is *not* a lie.
I don't speak for SGI.
