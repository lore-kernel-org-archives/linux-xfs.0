Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 25 Oct 2008 06:07:33 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9PD7RPb022076
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 06:07:27 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8215812A7E6C
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 06:07:26 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id mQnrrXwMZtZZURGy for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 06:07:26 -0700 (PDT)
Message-ID: <49031A0D.9040906@sandeen.net>
Date: Sat, 25 Oct 2008 08:07:25 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_db: out of memory (2.9.8)
References: <alpine.DEB.1.10.0810250801360.5019@p34.internal.lan> <4903161D.9040204@sandeen.net> <alpine.DEB.1.10.0810250855430.5734@p34.internal.lan>
In-Reply-To: <alpine.DEB.1.10.0810250855430.5734@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: xfs@oss.sgi.com

Justin Piszcz wrote:
> 
> On Sat, 25 Oct 2008, Eric Sandeen wrote:
> 
>> Justin Piszcz wrote:
>>> For the root partition I get "out of memory" when I try to check for
>>> fragmentation.
>>>
>>> # xfs_db -c frag -f /dev/md2
>>> xfs_db: out of memory
>> "-f" means "stored in a file"
>>
>>> # mount | grep "/dev/md2"
>>> /dev/md2 on / type xfs (rw,noatime)
>> It looks like you're cheating your way around:
>>
>> xfs_db: /dev/md2 contains a mounted filesystem
>>
>> fatal error -- couldn't initialize XFS library
>>
>> I'm not sure if that matters in this respect, though.
>>
>> You could use gdb to find out which allocation is failing.
>>
>>> # xfs_db -V
>>> xfs_db version 2.9.8
>>>
>>> Any idea?
>> Don't worry so much about that fragmentation stat? :)
>>
>> -Eric
>>
>>> Justin.
>>>
>>>
> 
> .. but it used to work :(

if you can find out when it changed, maybe it can change back.

> Loaded symbols for /lib/libgcc_s.so.1
> Error while mapping shared library sections:
> ease: No such file or directory.
> (no debugging symbols found)

... so the output isn't so useful here

> mmap(NULL, 31221911552, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = -1 ENOMEM (Cannot allocate memory)

32G...

-Eric
