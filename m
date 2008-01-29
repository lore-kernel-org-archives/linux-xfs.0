Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 29 Jan 2008 07:42:46 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0TFgdJ3013900
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2008 07:42:41 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DCBFBD2B921
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2008 07:42:56 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id uhWvE4ADc0Tj1jQV for <xfs@oss.sgi.com>; Tue, 29 Jan 2008 07:42:56 -0800 (PST)
Message-ID: <479F495E.4070700@sandeen.net>
Date: Tue, 29 Jan 2008 09:42:22 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: mkfs.xfs doesn't detect size of storage correctly
References: <20080129093201.GA16203@citd.de> <43347.192.168.3.1.1201601702.squirrel@mail.aconex.com> <20080129122051.GA18165@citd.de> <479F440F.2060506@sandeen.net> <20080129153337.GA20509@citd.de>
In-Reply-To: <20080129153337.GA20509@citd.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Matthias Schniedermeyer <ms@citd.de>
Cc: nscott@aconex.com, xfs@oss.sgi.com

Matthias Schniedermeyer wrote:
> On 29.01.2008 09:19, Eric Sandeen wrote:
>> Matthias Schniedermeyer wrote:
>>
>>> A maybe important detail, i forgot to mention in the original mail is:
>>> The machine has 8GB of RAM, so i compiled the kernel with "64bit=yes" 
>>> (formaly x86_64), BUT(!) the userspace is 32bit or plain old i386.
>> If you think that's the issue, I'd try compiling the above as a 32-bit
>> binary and re-run.
> 
> I don't think it's an issue, i just wanted to mention it.
> 
> But as soon as i get home i will connect the HDD to an all 32bit system 
> and see if it makes a difference. (I'm still undecided if i should hope 
> that it makes a difference. ;-) )
> 

well, this can't be hard to find, with a bit of investigation.  :)

As Nathan said, mkfs.xfs just uses standard ioctls to get device size,
so something is odd... you could sprinkle some printfs into the mkfs
code, too, to further debug.

-Eric

> 
> 
> Bis denn
> 
