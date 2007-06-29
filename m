Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Jun 2007 23:48:38 -0700 (PDT)
Received: from zebday.corky.net (corky.net [212.150.53.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5T6mWtL000920
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2007 23:48:33 -0700
Message-ID: <4684A98B.1030000@corky.net>
Date: Fri, 29 Jun 2007 07:41:15 +0100
From: Just Marc <marc@corky.net>
MIME-Version: 1.0
Subject: Re: xfs_fsr, performance related tweaks
References: <4683ADEB.3010106@corky.net> <46841C60.5030207@sandeen.net> <4684A506.4030705@corky.net> <op.tun7i8wd3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <op.tun7i8wd3jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: xfs@oss.sgi.com

Barry Naujok wrote:
> On Fri, 29 Jun 2007 16:21:58 +1000, Just Marc <marc@corky.net> wrote:
>
>> Hi Eric,
>>
>> In my particular case, and I'm sure for many other people, files that 
>> are stored never change again until they deleted.  I hinted that 
>> there could be a command line switch to turn this functionality on, 
>> as it may not be perfect for everyone's use cases.
>>
>> If nobody likes this still, I would appreciate some hints on how to 
>> mark files as no-defrag from within fsr itself given that I only have 
>> the file descriptor ... A hack like looking up the descriptor in 
>> /proc/self/fd should work, but is linux specific and is too hackish 
>> in my opinion.   I'd like to at least have a nice simple patch for my 
>> own uses.
>
> Eric,
>
> You can use the xfs_io chattr command to mark known files as
> nodefrag. Using the chattr -R option can be used to recurse
> directories.
>
>

Barry,

That's right but I can't do this on a filesystem that's just been 
defragged say a minute ago, and in the mean time 20 new files got added 
(I don't know what these files are... ).

The whole filesystem has to be scanned again and here comes the issue: 
fsr wants to try and reduce the extents of many files for which it can't 
do it thus incurring lots of work and load until it can even reach the 
new files do defrag them...

Marc
