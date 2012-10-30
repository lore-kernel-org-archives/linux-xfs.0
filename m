Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9UJn2Gq068817 for <xfs@oss.sgi.com>; Tue, 30 Oct 2012 14:49:02 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	1h8ySK7OvA2ittgG for <xfs@oss.sgi.com>;
	Tue, 30 Oct 2012 12:50:51 -0700 (PDT)
Date: Tue, 30 Oct 2012 12:33:09 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Problems with kernel 3.6.x (vm ?) (was : Is kernel 3.6.1 or
	filestreams option toxic ?)
Message-ID: <20121030013309.GX29378@dastard>
References: <508554AF.5050005@univ-nantes.fr> <50865453.5080708@univ-nantes.fr>
	<508958FF.4000007@univ-nantes.fr> <20121025211047.GD29378@dastard>
	<508A600C.1020109@univ-nantes.fr> <508B092E.6070209@univ-nantes.fr>
	<20121028234802.GE4353@dastard> <20121029012540.GO29378@dastard>
	<20121029121851.GQ29378@dastard> <508E79D4.5090507@univ-nantes.fr>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <508E79D4.5090507@univ-nantes.fr>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Yann Dupont <Yann.Dupont@univ-nantes.fr>
Cc: xfs@oss.sgi.com

On Mon, Oct 29, 2012 at 01:43:00PM +0100, Yann Dupont wrote:
> Le 29/10/2012 13:18, Dave Chinner a =E9crit :
> >On Mon, Oct 29, 2012 at 12:25:40PM +1100, Dave Chinner wrote:
> >>On Mon, Oct 29, 2012 at 10:48:02AM +1100, Dave Chinner wrote:
> >>>On Sat, Oct 27, 2012 at 12:05:34AM +0200, Yann Dupont wrote:
> >>>>Le 26/10/2012 12:03, Yann Dupont a =E9crit :
> >>>>>Le 25/10/2012 23:10, Dave Chinner a =E9crit :
> >>>>- mkfs.xfs on it, with default options
> >>>>- mounted with default options
> >>>>- launch something that hammers this volume. I launched compilebench
> >>>>0.6  on it
> >>>>- wait some time to fill memory,buffers, and be sure your disks are
> >>>>really busy. I waited some minutes after the initial 30 kernel
> >>>>unpacking in compilebench
> >>>>- hard reset the server (I'm using the Idrac of the server to
> >>>>generate a power cycle)
> >>>>- After some try, I finally had the impossibility to mount the xfs
> >>>>volume, with the error reported in previous mails. So far this is
> >>>>normal .
> >>>So it doesn't happen every time, and it may be power cycle related.
> >>>What is your "local disk"?
> >>I can't reproduce this with a similar setup but using KVM (i.e.
> >>killing the VM instead of power cycling) or forcing a shutdown of
> >>the filesystem without flushing the log. The second case is very
> >>much the same as power cycling, but without the potential "power
> >>failure caused partial IOs to be written" problem.
> >>
> >>The only thing I can see in the logprint that I haven't seen so far
> >>in my testing is that your log print indicates a checkpoint that
> >>wraps the end of the log. I haven't yet hit that situation by
> >>chance, so I'll keep trying to see if that's the case that is
> >>causing the problem....
> >Well, it's taken about 12 hours of random variation of parameters
> >in the loop of:
> >
> >mount /dev/vdb /mnt/scratch
> >./compilebench -D /mnt/scratch &
> >sleep <some period>
> >/home/dave/src/xfstests-dev/src/godown /mnt/scratch
> >sleep 5
> >umount /mnt/scratch
> >xfs_logprint -d /dev/vdb
.....
> >Ok, xfs_logprint failed to decode the wrapped transaction at the end
> >of the log. I can't see anything obviously wrong with the contents
> >of the log off the top of my head (logprint is notoriously buggy),
> >but the above command can reproduce the problem (3 out of 3 so far),
> >so I should be able to track down the bug from this.
> >
> OK, very glad to hear you were able to reproduce it.
> Good luck, and now let the chase begin :)

Not really a huge chase, just a simple matter of isolation. The
patch below should fix the problem.

However, the fact that recovery succeeded on 3.4 means you may have
a corrupted filesystem. The bug has been present since 3.0-rc1
(which was a fix for vmap memory leaks), and recovery is trying to
replay stale items from the previous log buffer. As such, it is
possible that changes from a previous checkpoint to have overwritten
more recent changes in the current checkpoint. As such, you should
probably run xfs_repair -n over the filesystems that you remounted
on 3.4 that failed on 3.6 just to make sure they are OK.

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

xfs: fix reading of wrapped log data

From: Dave Chinner <dchinner@redhat.com>

Commit 4439647 ("xfs: reset buffer pointers before freeing them") in
3.0-rc1 introduced a regression when recovering log buffers that
wrapped around the end of log. The second part of the log buffer at
the start of the physical log was being read into the header buffer
rather than the data buffer, and hence recovery was seeing garbage
in the data buffer when it got to the region of the log buffer that
was incorrectly read.

Cc: <stable@vger.kernel.org> # 3.0.x, 3.2.x, 3.4.x 3.6.x
Reported-by: Torsten Kaiser <just.for.lkml@googlemail.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_recover.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index e445550..02ff9a8 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3646,7 +3646,7 @@ xlog_do_recovery_pass(
 				 *   - order is important.
 				 */
 				error =3D xlog_bread_offset(log, 0,
-						bblks - split_bblks, hbp,
+						bblks - split_bblks, dbp,
 						offset + BBTOB(split_bblks));
 				if (error)
 					goto bread_err2;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
