Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 23 Jul 2007 06:52:51 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6NDqgbm018284
	for <xfs@oss.sgi.com>; Mon, 23 Jul 2007 06:52:45 -0700
Message-ID: <46A4B2AA.7030304@sandeen.net>
Date: Mon, 23 Jul 2007 08:52:42 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs-cmds doesn't build... (cvs & 2.9.2...)
References: <46A2209F.2030108@sandeen.net> <1185160946.10702.12.camel@edge.yarra.acx>
In-Reply-To: <1185160946.10702.12.camel@edge.yarra.acx>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: nscott@aconex.com
Cc: xfs-oss <xfs@oss.sgi.com>, Barry Naujok <bnaujok@sgi.com>

Nathan Scott wrote:
> On Sat, 2007-07-21 at 10:05 -0500, Eric Sandeen wrote:
>>
>> [sandeen@sandeen xfs-cmds]$ make
>> ....
>> == Building xfsprogs
>> == clean, log is Logs/clean
>> make: *** [cmds] Error 1
>> [sandeen@sandeen xfs-cmds]$ cat xfsprogs/Logs/clean
>> make[1]: Entering directory `/src/cvs/xfs-cmds/xfsprogs'
>> === include ===
>> gmake[2]: *** No rule to make target `mdrestore'.  Stop.
> 
> Did you use -d on your cvs update line?  My cvs update found it ok.

Ugh... that's probably it.  *grumble*

>> make[1]: *** [mdrestore] Error 2
>> make[1]: Leaving directory `/src/cvs/xfs-cmds/xfsprogs'
>> [sandeen@sandeen xfs-cmds]$ grep -B1 mdrestore xfsprogs/Makefile
>> SUBDIRS = include libxfs libxlog libxcmd libhandle libdisk \
>>         copy db fsck growfs io logprint mkfs quota mdrestore repair
>> rtcp \
>> [sandeen@sandeen xfs-cmds]$ ls xfsprogs/mdrestore
>> ls: xfsprogs/mdrestore: No such file or directory
>>
> 
> On Sat, 2007-07-21 at 10:05 -0500, Eric Sandeen wrote:
>>
>> 2.9.2 tarball:
>> [sandeen@sandeen xfsprogs-2.9.2]$ make
>> ....
>> metadump.c:28:26: xfs_metadump.h: No such file or directory 
>>
> 
> This should be fixed now (with Barrys last change).

Ok, cool.

Thanks!
-Eric

> cheers.
> 
> --
> Nathan
> 
