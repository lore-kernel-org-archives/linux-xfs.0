Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2L5KVa3054102 for <xfs@oss.sgi.com>; Wed, 21 Mar 2012 00:20:32 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	44IjuMXVG8SHvn6B for <xfs@oss.sgi.com>;
	Tue, 20 Mar 2012 22:20:30 -0700 (PDT)
Date: Wed, 21 Mar 2012 16:20:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: kernel: XFS (dm-7): xlog_space_left: head behind tail
Message-ID: <20120321052027.GX5091@dastard>
References: <CAJzjPKkUm-uWuGs2xPLF9yZ71uUV8QwPApjGAf6EKDoGqQYqBA@mail.gmail.com>
	<20120321043031.GW5091@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120321043031.GW5091@dastard>
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
To: Gregory Machin <gdm@linuxpro.co.za>
Cc: xfs@oss.sgi.com

On Wed, Mar 21, 2012 at 03:30:31PM +1100, Dave Chinner wrote:
> On Wed, Mar 21, 2012 at 05:00:02PM +1300, Gregory Machin wrote:
> > I have a CentOS 6.2 virtual machine in a vmware ESXi 4.0 host 4G Ram 4
> > virtaul cpus and with about 4 TB of disk space formatted with XFS .
> > I'm seeing a lot of :
> > 
> > Mar 21 10:49:42 nzhmlfpr05 kernel: XFS (dm-4): xlog_space_left: head behind tail
> > Mar 21 10:49:42 nzhmlfpr05 kernel:  tail_cycle = 129, tail_bytes = 20163072
> > Mar 21 10:49:42 nzhmlfpr05 kernel:  GH   cycle = 129, GH   bytes = 20162880
> > Mar 21 10:49:42 nzhmlfpr05 kernel: XFS (dm-7): xlog_space_left: head behind tail
> > Mar 21 10:49:42 nzhmlfpr05 kernel:  tail_cycle = 5, tail_bytes = 333417984
> > Mar 21 10:49:42 nzhmlfpr05 kernel:  GH   cycle = 5, GH   bytes = 333417792
> > Mar 21 10:49:42 nzhmlfpr05 kernel: XFS (dm-7): xlog_space_left: head behind tail
> > Mar 21 10:49:42 nzhmlfpr05 kernel:  tail_cycle = 5, tail_bytes = 333417984
> > Mar 21 10:49:42 nzhmlfpr05 kernel:  GH   cycle = 5, GH   bytes = 333417792
> 
> can you send the complete set of output, including the first
> occurrence of it?
> 
> What workload are you running? Are you freezing you filesystem
> frequently?

If you are freezing regularly, then the patch below should fix the
problem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: Account log unmount transaction correctly

From: Dave Chinner <dchinner@redhat.com>

There have been a few reports of this warning appearing recently:

XFS (dm-4): xlog_space_left: head behind tail
 tail_cycle = 129, tail_bytes = 20163072
 GH   cycle = 129, GH   bytes = 20162880

The common cause appears to be lots of freeze and unfreeze cycles,
and the output from the warnings indicates that we are leaking
around 8 bytes of log space per freeze/unfreeze cycle.

When we freeze the filesystem, we write an unmount record and that
uses xlog_write directly - a special type of transaction,
effectively. What it doesn't do, however, is correctly acocunt for
the log space it uses. The unmount record writes an 8 byte structure
with a special magic number into the log, and the space this
consumes is not accounted for in the log ticket tracking the
operation. Hence we leak 8 bytes every unmount record that is
written.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 98a9cb5..6db1fef 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -726,8 +726,9 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 				.lv_iovecp = &reg,
 			};
 
-			/* remove inited flag */
+			/* remove inited flag, and account for space used */
 			tic->t_flags = 0;
+			tic->t_curr_res -= sizeof(magic);
 			error = xlog_write(log, &vec, tic, &lsn,
 					   NULL, XLOG_UNMOUNT_TRANS);
 			/*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
