Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 18 Jan 2008 13:23:16 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0ILNC9S025858
	for <xfs@oss.sgi.com>; Fri, 18 Jan 2008 13:23:13 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5E15D5376AA
	for <xfs@oss.sgi.com>; Fri, 18 Jan 2008 13:23:30 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id XJ9DjuHwsfc9J9Qr for <xfs@oss.sgi.com>; Fri, 18 Jan 2008 13:23:30 -0800 (PST)
Message-ID: <479118CF.1020302@sandeen.net>
Date: Fri, 18 Jan 2008 15:23:27 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [REVIEW 2/2] Case insensitive support for XFS - user-space
References: <op.t43zfeiz3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <op.t43zfeiz3jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

Barry Naujok wrote:
> This patch relies on the dinode.c refactoring patch posted recently.
> I have attached the latest version (with fixes pointed out by Chandan).

So, new mkfs.xfs -h output says:

/* naming */		[-n log=n|size=num,version=n,utf8=none|default|turkic]

so I tried:

mkfs.xfs -dfile,name=fsfile,size=500m -nutf8=none

and got:

Illegal value none for -n utf8 option

(are there man page updates lurking somewhere?  Pls also update
Documentation/filesystems/xfs.txt in the kernel)

....

Also, if I specify -nutf8=default on a 500m fs:

# mkfs.xfs -dfile,name=fsfile,size=500m -nutf8=default
meta-data=fsfile                 isize=256    agcount=4, agsize=32000 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=128000, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   utf8=default
log      =internal log           bsize=4096   blocks=1200, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0
mkfs.xfs: cannot reserve space: No space left on device

However this works:

# mkfs.xfs -dfile,name=fsfile,size=500m

as does this:

# mkfs.xfs -dfile,name=fsfile,size=1000m -nutf8=default

eh? :)

-Eric
