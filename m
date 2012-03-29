Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2TN3KXR205600 for <xfs@oss.sgi.com>; Thu, 29 Mar 2012 18:03:21 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	NFMykpz0xc93ZnoI for <xfs@oss.sgi.com>;
	Thu, 29 Mar 2012 16:03:19 -0700 (PDT)
Date: Fri, 30 Mar 2012 10:03:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Buffalo LS-Q4.0 Raid 5 XFS errors
Message-ID: <20120329230317.GD18323@dastard>
References: <004b01cd0d3f$c6d4fbc0$547ef340$@tx.rr.com>
	<20120329064054.GP5091@dastard>
	<002501cd0dbe$24be21c0$6e3a6540$@tx.rr.com>
	<20120329213100.GA18323@dastard>
	<005101cd0df9$67f61250$37e236f0$@tx.rr.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <005101cd0df9$67f61250$37e236f0$@tx.rr.com>
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
To: Kirk Anderson <kirkande@tx.rr.com>
Cc: xfs@oss.sgi.com

On Thu, Mar 29, 2012 at 05:15:08PM -0500, Kirk Anderson wrote:
> Thank you again for your help.  Please let me know what my next step should
> be.
> 
> Here is the output from the dd command.  My understanding is that I use the
> /dev/sd[a-d]6 for mine as the  cat /proc/mdstat indicated that 
> md2 : active raid5 sda6[0] sdd6[3] sdc6[2] sdb6[1]
>       2906278656 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]
> 
> root@LS-QLF55:~# dd if=/dev/sda6 bs=512 count=1 2> /dev/null | hexdump -C
> 00000000  58 46 53 42 00 00 10 00  00 00 00 00 2b 4e 92 c0 |XFSB........+N..|
.....

Ok, so that's a superblock. Does it match the output of

# dd if=/dev/md2 bs=512 count=1 2> /dev/null | hexdump -C

It should match according to the above, but it doesn't hurt to
confirm.  If it doesn't then your RAID device has been SBTW and
that's what you need to fix first.

If it does match, can you dump the output of

# dd if=/dev/md2 bs=512 count=4 2> /dev/null | hexdump -C

and

# xfs_db -c "sb 0" -c p -c "agf 0" -c p -c "agi 0" -c p /dev/md2

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
