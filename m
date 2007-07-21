Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 21 Jul 2007 13:53:03 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6LKr0bm004520
	for <linux-xfs@oss.sgi.com>; Sat, 21 Jul 2007 13:53:01 -0700
Message-ID: <46A27230.2060908@sandeen.net>
Date: Sat, 21 Jul 2007 15:53:04 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs-cmds doesn't build... (cvs & 2.9.2...)
References: <46A2209F.2030108@sandeen.net> (sfid-20070721_185105_539562_E01EA719) <200707212141.10101.Martin@lichtvoll.de>
In-Reply-To: <200707212141.10101.Martin@lichtvoll.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-xfs@oss.sgi.com

Martin Steigerwald wrote:
> Am Samstag 21 Juli 2007 schrieb Eric Sandeen:
>> cvs:
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
>> make[1]: *** [mdrestore] Error 2
>> make[1]: Leaving directory `/src/cvs/xfs-cmds/xfsprogs'
>> [sandeen@sandeen xfs-cmds]$ grep -B1 mdrestore xfsprogs/Makefile
>> SUBDIRS = include libxfs libxlog libxcmd libhandle libdisk \
>>         copy db fsck growfs io logprint mkfs quota mdrestore repair
>> rtcp \ [sandeen@sandeen xfs-cmds]$ ls xfsprogs/mdrestore
>> ls: xfsprogs/mdrestore: No such file or directory
> 
> Hi Eric,
> 
> did work here a bit before Sa 21. Jul 21:40:50 CEST 2007.
> 
> Regards,

Yep, if I cd into xfs-cmds it's ok.  Looks like just "make" from the top
dir is busted.  (the tarball *is* busted too, missing a header file)

thanks,

-eric
