Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E8EDE7F54
	for <xfs@oss.sgi.com>; Thu, 12 Feb 2015 17:17:41 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 69C85AC002
	for <xfs@oss.sgi.com>; Thu, 12 Feb 2015 15:17:38 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	A68sZRG4i5jJimVr for <xfs@oss.sgi.com>;
	Thu, 12 Feb 2015 15:17:35 -0800 (PST)
Date: Fri, 13 Feb 2015 10:09:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_logprint segfault with external log
Message-ID: <20150212230940.GD12722@dastard>
References: <54DB5E70.80607@oracle.com> <20150211205406.GT4251@dastard>
	<54DC940D.4030009@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54DC940D.4030009@oracle.com>
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
To: Alexander Tsvetkov <alexander.tsvetkov@oracle.com>
Cc: Eric Sandee <sandeen@sandeen.net>, xfs@oss.sgi.com

On Thu, Feb 12, 2015 at 02:52:45PM +0300, Alexander Tsvetkov wrote:
> On 02/11/2015 11:54 PM, Dave Chinner wrote:
> >On Wed, Feb 11, 2015 at 04:51:44PM +0300, Alexander Tsvetkov wrote:
> >>Hello,
> >>
> >>I've obtained corrupted xfs log after some sanity xfs testing:
> >>
> >>"log=logfile
> >>log_size=855
> >>
> >>dd if=/dev/zero "of=$log" bs=4096 count=$log_size
> >>loopdev=$(losetup -f)
> >>losetup $loopdev $log
> >>
> >>mkfs.xfs -f -m crc=1 -llogdev=$loopdev,size=${log_size}b $SCRATCH_DEV
> >>mount -t xfs -ologdev=$loopdev $SCRATCH_DEV $SCRATCH_MNT
> >>./fdtree.sh  -l 4 -d 4 -C -o $SCRATCH_MNT
> >>sync
> >>umount $SCRATCH_MNT
> >>
> >>xfs_logprint -l $loopdev $SCRATCH_DEV"
> >>
> >>Test makes crc enabled xfs filesystem with the external log of
> >>minimal allowed size and then creates on this fs the small directory
> >>tree
> >>with sub directories and files of fixed depth and size with help of
> >>fdtree utility:
> >>https://computing.llnl.gov/?set=code&page=sio_downloads
> >Just take metadump image and put it somewhere we can down load it.
> >
> >>After that xfs_logprint stably reports bad data in log:

Please try the patch below, it fixes the problem on the image you
provided.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

logprint: fix inode fork print record overrun

From: Dave Chinner <dchinner@redhat.com>

logprint checks for whether the inode log item extends across a log
record boundary so that it doesn't try to dereference beyond the ned
of the buffer containing the log items. It doesn' however, take into
account log items with attribute forks in them, and so doesn't catch
the overrun in this case. Fix it.

reported-by: Alexander Tsvetkov <alexander.tsvetkov@oracle.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 logprint/log_misc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 521ab66..e4f2174 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -698,7 +698,7 @@ xlog_print_trans_inode(
     xlog_print_trans_inode_core(&dino);
     *ptr += xfs_icdinode_size(dino.di_version);
 
-    if (*i == num_ops-1 && f->ilf_size == 3)  {
+    if (*i == num_ops-1 && f->ilf_size >= 3) {
 	return 1;
     }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
