Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 10 Feb 2008 20:52:41 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1B4qXCd014269
	for <xfs@oss.sgi.com>; Sun, 10 Feb 2008 20:52:35 -0800
Message-ID: <47AFD5B5.7040506@sgi.com>
Date: Mon, 11 Feb 2008 15:57:25 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [GIT PULL] XFS update for 2.6.25
References: <20080208022705.0DB1058C4C11@chook.melbourne.sgi.com> <47AD284F.7080603@sandeen.net>
In-Reply-To: <47AD284F.7080603@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

Eric,

The other makefile changes caused a merge failure because of changes we
keep in our development tree that are not in mainline.  I didn't have
time to fix them for rc1 so I'll get them out in rc2.  I know the changes
are good and very useful so sorry for the delay.

Lachlan

Eric Sandeen wrote:
> Lachlan McIlroy wrote:
>> Please pull from the for-linus branch:
>>     git pull git://oss.sgi.com:8090/xfs/xfs-2.6.git for-linus
>>
>> This will update the following files:
>>
>>  fs/xfs/Makefile-linux-2.6      |    1 -
> 
> Is there a reason the other various makefile updates still haven't been
> pushed?  They're a lot tidier now, and they facilitate out-of-tree
> building...
> 
> Thanks,
> -Eric
> 
> Remove Makefile wrappers in XFS
> 
> Makefile (and Kbuild) would include Makefile-linux-26
> I doubt XFS will really still compile on 2.4; so drop that. This
> moves Makefile-linux-26 into Makefile and drops Kbuild.
> Also having wrappers as both Kbuild and Makefile seemed redundant
> anyways.
> 
> The patch is relatively large because it renames a file, but
> no functional changes.
> 
> Signed-off-by: Andi Kleen <ak@suse.de>
> Merge of xfs-linux-melb:xfs-kern:29781a by kenmcd.
> 
>   Remove Makefile wrappers in XFS.
> 
> Fix up xfs out-of-tree builds. (a.k.a. external modules)
> 
> Change -I include directives to find headers in the out-of-tree spot.
> This allows a directory containing only xfs files to be built as:
> 
>   # make -C /path/to/kernel M=`pwd`
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> Merge of xfs-linux-melb:xfs-kern:29878a by kenmcd.
> 
>   fix up out-of-tree xfs builds.
> 
> 
