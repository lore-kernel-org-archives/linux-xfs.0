Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q55Nm7Gs137875 for <xfs@oss.sgi.com>; Tue, 5 Jun 2012 18:48:07 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	fBycpJcUOl8LD3oG for <xfs@oss.sgi.com>;
	Tue, 05 Jun 2012 16:48:05 -0700 (PDT)
Date: Wed, 6 Jun 2012 09:48:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstest 285: userspace vs. fragmented multiblock dir2
Message-ID: <20120605234803.GE22848@dastard>
References: <4FBABC41.5040001@redhat.com>
 <20120605224600.GN4721@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120605224600.GN4721@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, Jun 05, 2012 at 05:46:00PM -0500, Ben Myers wrote:
> Hey Eric,
> 
> On Mon, May 21, 2012 at 05:05:53PM -0500, Eric Sandeen wrote:
> > Current xfs_repair is unhappy with fragmented multiblock
> > v2 directories.  This test shows it ... patches to fix
> > it soon to follow.
> > 
> > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> This failed on my system... looks like it's just PEBKAC.  My partitions
> are too small?
> 
> # ./check 287
> No patches applied
> KERNEL_TOPDIR -- /root/xfs
> BRANCH        -- refs/heads/master2
> DESC          -- v3.4-10158-gf8f5701
> PATCHES:
> FSTYP         -- xfs (debug)
> PLATFORM      -- Linux/x86_64 nfs10 3.5.0-rc1-0.7-default+
> MKFS_OPTIONS  -- -f -bsize=4096 /dev/sdb4
> MOUNT_OPTIONS -- /dev/sdb4 /mnt/scratch
> 
> 287      - no qualified output

It failed because there is not 287.out file in the patch. Every test
has to have a golden image to compare the result against...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
