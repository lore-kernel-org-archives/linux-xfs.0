Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1KMU6Zk114352 for <xfs@oss.sgi.com>; Mon, 20 Feb 2012 16:30:06 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	D249xrWe09rHSbx3 for <xfs@oss.sgi.com>;
	Mon, 20 Feb 2012 14:30:05 -0800 (PST)
Date: Tue, 21 Feb 2012 09:29:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [help] xfs quotacheck problem when xfs filesystem mount
Message-ID: <20120220222938.GF3592@dastard>
References: <CAJ-WH_ydP-_k5zhcUh5QptkDkjvFQRNGUihgU1=yb8VX0Qp4Cg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAJ-WH_ydP-_k5zhcUh5QptkDkjvFQRNGUihgU1=yb8VX0Qp4Cg@mail.gmail.com>
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
To: "Guk-Bong, Kwon" <gbkwon@gmail.com>
Cc: xfs@oss.sgi.com

On Mon, Feb 20, 2012 at 03:06:48PM +0900, Guk-Bong, Kwon wrote:
> [help] xfs quotacheck problem when xfs filesystem mount
> 
> hi all..
> 
> i test xfs project quota with various version vanilla kernel
> 
> 
> Test Scenario
> 
> 1. mkfs.xfs -i size=512 -l lazy-count=1 /dev/ld/lv1
> 2. xfs filesystem mount with project quota. and setting project quota
> 3. make many file into xfs filesystem (eg. 1K~1M size, number 300 million over)
> 4. xfs filesystem umount
> 5. xfs filesystem mount without project quota
> 6. make some file
> 7. umount xfs filesystem
> 8. again mount with project quota
> 
> 
> some kernel is ok when mount with project quota
> 
> some kernel is occurs oom-killer when mount with project quota
> 
> i tested kernel version 2.6.27.59, 2.6.32.46, 3.1.10.
> 
> only 2.6.27.59 kernel is not occurs oom-killer.

Hmmm. I thought we fixed that problem. Indeed:

$ glo -n 1 704b290
704b290 xfs: register the inode cache shrinker before quotachecks
$ git describe --contains 704b290
v2.6.39-rc1~15^2~1

So it was fixed in 2.6.39. Why is 3.1 seeing this problem? Oh:

$ glo -n 1 8daaa83
8daaa83 xfs: make use of new shrinker callout for the inode cache

Which makes XFS use the superblock shrinker infrastructure seems to
be causing the problem. quotacheck is called during
xfs_fs_fill_super(), which is called with the sb->s_umount locked in
exclusive mode, and the shrinker (prune_super()) needs to get the
lock in shared mode to run. Hence the shrinker doesn't run while
quotacheck is in progress.

I'll have to think about this one for a bit - I'm not sure what the
best way to solve it is yet.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
