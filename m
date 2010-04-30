Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3U39u3m123897 for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 22:09:56 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C697B8FED86
	for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 20:12:00 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id SO7WkswZ6S3sJaBH for
	<xfs@oss.sgi.com>; Thu, 29 Apr 2010 20:12:00 -0700 (PDT)
Message-ID: <4BDA4A7F.7040404@sandeen.net>
Date: Thu, 29 Apr 2010 22:11:59 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed: Argument list
	too	long
References: <i2hdb2d1ee61004291707k9ffebed2k4ff6eb72354cbe63@mail.gmail.com>
	<p2y25446eb91004291741k7e8e72cejc72093caf9cc99aa@mail.gmail.com>
In-Reply-To: <p2y25446eb91004291741k7e8e72cejc72093caf9cc99aa@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: James Braid <jamesb@loreland.org>
Cc: Benjamin Lau <benjamin.a.lau@gmail.com>, xfs@oss.sgi.com

James Braid wrote:
> On Fri, Apr 30, 2010 at 01:07, Benjamin Lau <benjamin.a.lau@gmail.com> wrote:
>> [2] Full output of xfs_growfs:
>> meta-data=/dev/mapper/vg00-lv_raid isize=256    agcount=40, agsize=61047552 blks
>>            =                       sectsz=512   attr=2
>> data     =                       bsize=4096   blocks=2441868288, imaxpct=25
>>         =                       sunit=0      swidth=0 blks
>> naming   =version 2              bsize=4096
>> log      =internal               bsize=4096   blocks=32768, version=2
>>         =                       sectsz=512   sunit=0 blks, lazy-count=0
>> realtime =none                   extsz=4096   blocks=0, rtextents=0
>> xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed: Argument list too long
>>
>> OS/Kernel Info:
>> Debian Lenny
>> Linux bigmama 2.6.30-2-686-bigmem #1 SMP Sat Sep 26 02:30:18 UTC 2009
>> i686 GNU/Linux
> 
> Filesystems >16TB aren't supported on 32-bit machines - it looks like
> your growfs is going to exceed that limit. Time to upgrade! ;)

We probably should, though, change the error from E2BIG to EFBIG so we
get "File too large" instead of "Argument list too long..."

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
