Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C9C6C7F5A
	for <xfs@oss.sgi.com>; Mon, 30 Mar 2015 14:45:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B1B8C304032
	for <xfs@oss.sgi.com>; Mon, 30 Mar 2015 12:45:13 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	jj5ffespHNowqm8E for <xfs@oss.sgi.com>;
	Mon, 30 Mar 2015 12:45:11 -0700 (PDT)
Date: Tue, 31 Mar 2015 06:45:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Slightly Urgent:  XFS No Space Left On Device
Message-ID: <20150330194510.GD28621@dastard>
References: <551993CF.4060908@binghamton.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <551993CF.4060908@binghamton.edu>
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
To: Dave Hall <kdhall@binghamton.edu>
Cc: xfs@oss.sgi.com

On Mon, Mar 30, 2015 at 02:19:59PM -0400, Dave Hall wrote:
> Hello,
> 
> I have an XFS file system that's getting 'No space left on device'
> errors.  xfs_fsr also complains of 'No space left'.  The XFS Info
> is:
> 
>    # xfs_info /data
>    meta-data=/dev/sdb1              isize=256    agcount=19,
>    agsize=268435440 blks
>              =                       sectsz=512   attr=2
>    data     =                       bsize=4096 blocks=4882431488, imaxpct=5
>              =                       sunit=16     swidth=160 blks
>    naming   =version 2              bsize=4096   ascii-ci=0
>    log      =internal               bsize=4096   blocks=521728, version=2
>              =                       sectsz=512   sunit=16 blks,
>    lazy-count=1
>    realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
>    # df -h .
>    Filesystem            Size  Used Avail Use% Mounted on
>    /dev/sdb1              19T   12T  7.0T  62% /data
>    # df -ih .
>    Filesystem            Inodes   IUsed   IFree IUse% Mounted on
>    /dev/sdb1               3.7G    4.7M    3.7G    1% /data
> 
> 
> xfs_db freesp shows that AG 0 seems to be full.  I've included the
> freesp for the first few AGs, but the rest seem pretty consistent
> with AGs 1 - 4 that I've included below.
> 
>    xfs_db> freesp -s -e 1000000000 -a 0

Can you please drop the "-e 1000000" from these commands and post it
again?  The histogram of differing free space sizes is information
we actually need to diagnose the problem...

Also, kernel version, mount options and machine details are
necessary to determine why AG0 might be full (e.g. allocation policy
in use).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
