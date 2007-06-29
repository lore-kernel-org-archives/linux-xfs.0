Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 29 Jun 2007 00:23:52 -0700 (PDT)
Received: from zebday.corky.net (corky.net [212.150.53.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5T7NitL015907
	for <xfs@oss.sgi.com>; Fri, 29 Jun 2007 00:23:46 -0700
Message-ID: <4684B1CC.60004@corky.net>
Date: Fri, 29 Jun 2007 08:16:28 +0100
From: Just Marc <marc@corky.net>
MIME-Version: 1.0
Subject: Re: xfs_fsr, performance related tweaks
References: <4683ADEB.3010106@corky.net> <46841C60.5030207@sandeen.net> <4684A506.4030705@corky.net> <op.tun7i8wd3jf8g2@pc-bnaujok.melbourne.sgi.com> <4684A98B.1030000@corky.net> <20070629070814.GR31489@sgi.com>
In-Reply-To: <20070629070814.GR31489@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Barry Naujok <bnaujok@sgi.com>, xfs@oss.sgi.com

David,

In my first post I already said something like that can be done but it's 
just an ugly hack.   Don't you think it would best be handled cleanly 
and correctly by fsr itself?



David Chinner wrote:
> On Fri, Jun 29, 2007 at 07:41:15AM +0100, Just Marc wrote:
>   
>> Barry Naujok wrote:
>>     
>>> You can use the xfs_io chattr command to mark known files as
>>> nodefrag. Using the chattr -R option can be used to recurse
>>> directories.
>>>       
>> That's right but I can't do this on a filesystem that's just been 
>> defragged say a minute ago, and in the mean time 20 new files got added 
>> (I don't know what these files are... ).
>>     
>
> So walk the filesystem with a script that queries the number of
> extents in each file, and if they have a single extent then
> run the xfs_io on them.
>
> Cheers,
>
> Dave.
>   
