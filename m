Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3T1nRi0026882 for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 20:49:27 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AE2482FC8CD
	for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 18:51:31 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id EvdAZyr5JxFVQ1FB for
	<xfs@oss.sgi.com>; Wed, 28 Apr 2010 18:51:31 -0700 (PDT)
Message-ID: <4BD8E622.80100@sandeen.net>
Date: Wed, 28 Apr 2010 20:51:30 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Enabling lazy counters damages filesystem
References: <4BD84771.4030804@mejor.pl> <20100428230447.GJ9783@dastard>
	<20100429014312.GA2512@dastard>
In-Reply-To: <20100429014312.GA2512@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: =?UTF-8?B?TWFyY2luIE1pcm9zxYJhdw==?= <marcin@mejor.pl>, xfs@oss.sgi.com

Dave Chinner wrote:

...

> Actually, 3.1.0 was the first release with the fix to xfs_db that
> prevents this problem.
> 
> Cheers,
> 
> Dave.

not so sure:

# rpm -q xfsprogs
xfsprogs-3.1.1-7

# mkfs.xfs -dfile,name=fsfile,size=10g -llazy-count=0
meta-data=fsfile                 isize=256    agcount=4, agsize=655360 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=2621440, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0

# xfs_admin -c 1 fsfile 
Enabling lazy-counters

# xfs_check fsfile 
sb_features2 (0xa) not same as sb_bad_features2 (0x8)

# xfs_repair fsfile 
Phase 1 - find and verify superblock...
superblock has a features2 mismatch, correcting
writing modified primary superblock
...

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
