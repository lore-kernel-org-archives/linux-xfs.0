Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F147C7F3F
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2014 03:26:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B77EA8F8039
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2014 01:26:08 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	UhqPQnWWDWGf1TyJ for <xfs@oss.sgi.com>;
	Wed, 23 Apr 2014 01:26:06 -0700 (PDT)
Date: Wed, 23 Apr 2014 18:25:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: rm -f * on large files very slow on XFS + MD RAID 6 volume of
	15x 4TB of HDDs (52TB)
Message-ID: <20140423082538.GR18672@dastard>
References: <CAHuzUScfp19c_th_pfsZs05+yDz34MuEH-P1f+FF1dcivfH=5Q@mail.gmail.com>
	<20140423021835.GI15995@dastard> <53576A7D.9020303@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53576A7D.9020303@gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Ivan Pantovic <gyro.ivan@gmail.com>
Cc: linux-kernel@vger.kernel.org, Speedy Milan <speedy.milan@gmail.com>, xfs@oss.sgi.com

On Wed, Apr 23, 2014 at 09:23:41AM +0200, Ivan Pantovic wrote:
> 
> >[root@drive-b ~]# xfs_db -r /dev/md0
> >xfs_db> frag
> >actual 11157932, ideal 11015175, fragmentation factor 1.28%
> >xfs_db>
> 
> this is current level of fragmentation ... is it bad?

http://xfs.org/index.php/XFS_FAQ#Q:_The_xfs_db_.22frag.22_command_says_I.27m_over_50.25._Is_that_bad.3F

> some say over 1% is candidate for defrag? ...

Some say that over 70% is usually not a problem:

http://www.mythtv.org/wiki/XFS_Filesystem#Defragmenting_XFS_Partitions

i.e. the level that becomes are problem is highly workload specific.
So, you can't read *anything* in that number without know exactly
what is in your filesystem, how the application(s) interact with it
and so on. 

Besides, I was asking specifically about the files you removed, not
the files that remain in the filesystem. Given that you have 11
million inodes in the filesystem, you probably removed the only
significantly large files in the filesystem....

So, the files your removed are now free space, so free space
fragmentation is what we need to look at.  i.e. use the freesp
command to dump the histogram and summary of the free space...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
