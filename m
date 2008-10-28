Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 28 Oct 2008 00:38:27 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9S7cIxZ003169
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 00:38:20 -0700
Received: from smtp.welcomes-you.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0355A55093C
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 00:38:15 -0700 (PDT)
Received: from smtp.welcomes-you.com (welcomes-you.com [85.214.50.128]) by cuda.sgi.com with ESMTP id L1ypm2jw7ZDBKUHs for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 00:38:15 -0700 (PDT)
Message-ID: <4906C164.6090704@aei.mpg.de>
Date: Tue, 28 Oct 2008 08:38:12 +0100
From: Carsten Aulbert <carsten.aulbert@aei.mpg.de>
MIME-Version: 1.0
Subject: Re: Map a disk LBA to filename?
References: <4905A3FB.6080709@aei.mpg.de> <20081027114945.GE4985@disturbed> <4905B48A.8010108@aei.mpg.de> <4905BC13.3030402@drutsystem.com> <20081027233516.GG4985@disturbed> <4906BB32.8080403@aei.mpg.de> <20081028072105.GW4985@disturbed>
In-Reply-To: <20081028072105.GW4985@disturbed>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Carsten Aulbert <carsten.aulbert@aei.mpg.de>, Michal Soltys <nozo@drutsystem.com>, xfs@oss.sgi.com



Dave Chinner wrote:

> Shouldn't be a problem with a filesystem that size. It's when you're
> dealing with tens of terabytes in a single filesystem that it can
> be a problem...

It used a bit less than 900MB, so no problem at all.

But I think I'm a bit stuck now, because I know not enough about the
conventions used:

# xfs_info /dev/sda6
meta-data=/dev/sda6              isize=256    agcount=16, agsize=7388267
blks
         =                       sectsz=512   attr=1
data     =                       bsize=4096   blocks=118212272, imaxpct=25
         =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=32768, version=1
         =                       sectsz=512   sunit=0 blks
realtime =none                   extsz=65536  blocks=0, rtextents=0

>From this I gather that this file system as about 118 million blocks for
data, each holding 4096 bytes, this is consistent with the file system
size as reported by df and the like.

However, when I look at a file on this FS, e.g.
ls -l /local/MCP/root/root.tar.bz2
---xr-xr-- 1 root root 134 Sep 26 15:20 /local/MCP/root/root.tar.bz2

where /local is in /dev/sda6 (nevermind the weird permissions).

Running xfs_bmap on this file  gives:

# xfs_bmap -l /local/MCP/root/root.tar.bz2
/local/MCP/root/root.tar.bz2:
        0: [0..7]: 847868600..847868607 8 blocks

But somehow this does not work out since 847868600>118212272.

Any idea where my logical error is?

Thanks

puzzled Carsten
