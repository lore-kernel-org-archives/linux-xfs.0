Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 30 Jun 2007 10:17:37 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5UHHXtL015366
	for <xfs@oss.sgi.com>; Sat, 30 Jun 2007 10:17:34 -0700
Message-ID: <46869029.3040704@sandeen.net>
Date: Sat, 30 Jun 2007 13:17:29 -0400
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_fsr, performance related tweaks
References: <4683ADEB.3010106@corky.net> <46841C60.5030207@sandeen.net> <4684A506.4030705@corky.net> <op.tun7i8wd3jf8g2@pc-bnaujok.melbourne.sgi.com> <4684A98B.1030000@corky.net> <20070629070814.GR31489@sgi.com> <4684B1CC.60004@corky.net> <20070629074114.GS31489@sgi.com>
In-Reply-To: <20070629074114.GS31489@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Just Marc <marc@corky.net>, Barry Naujok <bnaujok@sgi.com>, xfs@oss.sgi.com

David Chinner wrote:
> On Fri, Jun 29, 2007 at 08:16:28AM +0100, Just Marc wrote:
>> David,
>>
>> In my first post I already said something like that can be done but it's 
>> just an ugly hack.   Don't you think it would best be handled cleanly 
>> and correctly by fsr itself?
> 
> No, I don't - if you want files not to be defragmented, then you
> have to set the flags yourself in some way. You have a specific need
> that can be solved by some scripting to describe your defrag/no
> defrag policy. xfs_fsr has no place is setting defrag policy; it's
> function is simply to find and defrag files.

I wouldn't mind seeing a way to tell fsr to not worry about defragging
some files based on current layout; say if the avg extent in the file is
> 100MB, or > 1G, don't bother... if today you have a 4.7G DVD iso image
in 3 extents (not bad) fsr will try to "fix" it for you right?

-eric


> Cheers,
> 
> Dave.
