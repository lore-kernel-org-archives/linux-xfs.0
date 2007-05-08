Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 May 2007 22:03:13 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l48539fB010772
	for <xfs@oss.sgi.com>; Mon, 7 May 2007 22:03:10 -0700
Message-ID: <4640048B.6070803@sandeen.net>
Date: Tue, 08 May 2007 00:03:07 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: RESVSP problems
References: <200705072004.22848.lucke@o2.pl> <463F7368.8090101@sandeen.net> <200705072058.32679.lucke@o2.pl> <20070508005923.GS77450368@melbourne.sgi.com>
In-Reply-To: <20070508005923.GS77450368@melbourne.sgi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: =?UTF-8?B?xYF1a2FzeiBGaWJpbmdlcg==?= <lucke@o2.pl>, xfs@oss.sgi.com

David Chinner wrote:

>>> yeah... ISTR that the arguments are funky.  I can't remember if it's a
>>> bug or not.  :)  FWIW, allocsp just writes zeros to the file, so you
>>> could do it just as well from userspace w/ no fancy ioctls...  ALLOCSP
>>> is a bit pointless if you ask me... though maybe someone knows why it's
>>> there :)
>> Let me say that I have noticed that using ALLOCSP seems to create less extents 
>> than posix_fallocate/manual zeroing.
> 
> Yes, that's likely ;)
> 
> There's work currently active to make posix_fallocate() do the same thing
> as ALLOCSP (i.e. call into the filesystem and let it do smart stuff), but
> that's a ways off yet...

Dave, doesn't ALLOCSP actually create actual zeroed space though? 
Pretty much as posix_fallocate from userspace does today, maybe with 
better allocation... And "smart stuff" would be *not* needing to write 
zeros.... i.e. what RESVSP does.

-Eric
