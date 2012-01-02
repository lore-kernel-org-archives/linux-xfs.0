Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q02LbBPF239029
	for <linux-xfs@oss.sgi.com>; Mon, 2 Jan 2012 15:37:11 -0600
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	zmuoSzZQ7xcfqw1X for <linux-xfs@oss.sgi.com>;
	Mon, 02 Jan 2012 13:37:08 -0800 (PST)
Date: Tue, 3 Jan 2012 08:37:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Why does xfsdump encounter "WARNING: could not get list of
	non-root attributes for nondir ino nnnn: Cannot allocate memory (12)"?
Message-ID: <20120102213706.GQ23662@dastard>
References: <jdo01m$62j$1@dough.gmane.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <jdo01m$62j$1@dough.gmane.org>
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
To: Michael Lueck <mlueck@lueckdatasystems.com>
Cc: linux-xfs@oss.sgi.com

On Sat, Dec 31, 2011 at 04:50:27PM -0500, Michael Lueck wrote:
> Greetings,
> 
> Happy old year! ;-)
> 
> Running XFS on Ununtu 10.04 LTS, I have noticed more warnings with
> XFS dump the longer the system has been up. A reboot cuts down on
> the number of warnings xfsdump encounters. An example run of xfsdump
> is as follows:
> 
> /usr/sbin/xfsdump: using file dump (drive_simple) strategy
> /usr/sbin/xfsdump: version 3.0.4 (dump format 3.0) - Running single-threaded
> /usr/sbin/xfsdump: level 0 dump of ldslnx01:/srv
> /usr/sbin/xfsdump: dump date: Sat Dec 31 15:25:42 2011
> /usr/sbin/xfsdump: session id: b56b3cd7-30d6-44b4-a8a4-e131ee70b60d
> /usr/sbin/xfsdump: session label: "data"
> /usr/sbin/xfsdump: ino map phase 1: constructing initial dump list
> /usr/sbin/xfsdump: ino map phase 2: skipping (no pruning necessary)
> /usr/sbin/xfsdump: ino map phase 3: skipping (only one dump stream)
> /usr/sbin/xfsdump: ino map construction complete
> /usr/sbin/xfsdump: estimated dump size: 115786343168 bytes
> /usr/sbin/xfsdump: WARNING: no media label specified
> /usr/sbin/xfsdump: creating dump session media file 0 (media 0, file 0)
> /usr/sbin/xfsdump: dumping ino map
> /usr/sbin/xfsdump: dumping directories
> /usr/sbin/xfsdump: dumping non-directory files
> /usr/sbin/xfsdump: WARNING: could not get list of non-root attributes for nondir ino 234778: Cannot allocate memory (12)
> /usr/sbin/xfsdump: WARNING: could not get list of non-root attributes for nondir ino 234813: Cannot allocate memory (12)
> /usr/sbin/xfsdump: WARNING: could not get list of non-root attributes for nondir ino 1828443: Cannot allocate memory (12)
> /usr/sbin/xfsdump: WARNING: could not get list of root attributes for nondir ino 1828443: Cannot allocate memory (12)
> /usr/sbin/xfsdump: WARNING: could not get list of non-root attributes for nondir ino 2234019: Cannot allocate memory (12)

It's getting ENOMEM from the kernel.

xfsdump is asking for the list of attributes from the file, and
passing in a buffer of XATTR_LIST_MAX bytes, which the
xfs_attrmulti_attr_get() function immeidately kmalloc()s for a
working buffer. That kmalloc is likely to be failing randomly as it
is asking for a contiguous 64k allocation, and that may not be
available given memory gets fragmented over time.

> /usr/sbin/xfsdump: ending media file
> /usr/sbin/xfsdump: media file size 115563111376 bytes
> /usr/sbin/xfsdump: dump size (non-dir files) : 115472209824 bytes
> /usr/sbin/xfsdump: dump complete: 4099 seconds elapsed
> /usr/sbin/xfsdump: Dump Status: SUCCESS
> 
> Could someone please explain what is going on, and why a freshly rebooted system would result in less / no errors?

Memory is less fragmented, hence more likely to have a order-5
allocation succeed. Try the patch below, and see if that helps.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com


xfs: handle kmalloc failure when reading attrs

From: Dave Chinner <dchinner@redhat.com>

xfsdump uses for a large buffer for extended attributes, which has a
kmalloc'd shadow buffer in the kernel. This can fail after the
system has been running for some time as it is a high order
allocation. Convert this to a vmalloc so that it doesn't require
contiguous memory and so won't randomly fail while xfsdump is
running.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_ioctl.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 2f3f56a..0f3fab1 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -448,7 +448,7 @@ xfs_attrmulti_attr_get(
 
 	if (*len > XATTR_SIZE_MAX)
 		return EINVAL;
-	kbuf = kmalloc(*len, GFP_KERNEL);
+	kbuf = vmalloc(*len, GFP_KERNEL);
 	if (!kbuf)
 		return ENOMEM;
 
@@ -460,7 +460,7 @@ xfs_attrmulti_attr_get(
 		error = EFAULT;
 
  out_kfree:
-	kfree(kbuf);
+	vfree(kbuf);
 	return error;
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
