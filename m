Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAFLEAfE029222 for <xfs@oss.sgi.com>; Thu, 15 Nov 2012 15:14:10 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	HbeUeRSHHb0OnVC1 for <xfs@oss.sgi.com>;
	Thu, 15 Nov 2012 13:16:14 -0800 (PST)
Date: Fri, 16 Nov 2012 08:16:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 17/32 V2] xfs: verify dquot blocks as they are read from
	disk
Message-ID: <20121115211608.GI14281@dastard>
References: <1352721264-3700-1-git-send-email-david@fromorbit.com>
	<1352721264-3700-18-git-send-email-david@fromorbit.com>
	<20121114065013.GE1710@dastard> <50A52CA3.3060604@sgi.com>
	<20121115204830.GG14281@dastard> <50A5583D.5070101@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50A5583D.5070101@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Nov 15, 2012 at 03:01:49PM -0600, Mark Tinguely wrote:
> On 11/15/12 14:48, Dave Chinner wrote:
> >On Thu, Nov 15, 2012 at 11:55:47AM -0600, Mark Tinguely wrote:
> >>The xfs_quota program does not generate output with V2 which causes
> >>xfstest 050 to fails.
> >
> >I don't think that has anything to do with this patch orthechange
> >for V2 - V2 only changes quotacheck behaviour, and that doesn't
> >impact xfs_quota behaviour. The test passes just fine here:
> >
> >$ sudo ./check 050
> >FSTYP         -- xfs (debug)
> >PLATFORM      -- Linux/x86_64 test-2 3.7.0-rc5-dgc+
> >MKFS_OPTIONS  -- -f -bsize=4096 /dev/vdb
> >MOUNT_OPTIONS -- /dev/vdb /mnt/scratch
> >
> >050 14s ... 15s
> >Ran: 050
> >Passed all 1 tests
> >
> >So perhaps there's something else going wrong on your machine?
> 
> I will do more investigating. With V2 050 output:
> 
> QA output created by 050
> *** user
> meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
> data     = bsize=XXX blocks=XXX, imaxpct=PCT
>          = sunit=XXX swidth=XXX, unwritten=X
> naming   =VERN bsize=XXX
> log      =LDEV bsize=XXX blocks=XXX
> realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
> 
> *** report no quota settings
> 
> *** report initial settings
> 
> *** push past the soft inode limit
> 
> *** push past the soft block limit

Curious. There aren't any errors in the syslog/dmesg saying that
buffers failed verification during the quota check runs, are there?
Also, what platform are you testing on?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
