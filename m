Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5LGH4sW092005 for <xfs@oss.sgi.com>; Thu, 21 Jun 2012 11:17:04 -0500
Date: Thu, 21 Jun 2012 11:17:28 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: Possible memory allocation deadlock - kernel 3.2.1
Message-ID: <20120621161728.GD2503@sgi.com>
References: <34049469.post@talk.nabble.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <34049469.post@talk.nabble.com>
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
To: pkamala <priya.kamala@perpetual-data.com>
Cc: xfs@oss.sgi.com

Hi Priya,

On Thu, Jun 21, 2012 at 08:51:38AM -0700, pkamala wrote:
> I am testing the kernel 3.2.1 (32-bit) XFS filesystem on a 1 TB LVM logical
> volume. The volume currently has 3653816 files, 3655726 used inodes and 782G
> free space. When the volume is mounted, quotacheck starts up and after about
> 5 minutes the oom-killer is triggered and starts killing processes. From the
> message log, it looks like the system is running out of Normal memory. After
> a while I see the following messages after which I power cycle the system:
> 
> XFS: possible memory allocation deadlock in kmem_zone_alloc (mode: 0x2d0)
> XFS: possible memory allocation deadlock in xfs_buf_allocate_memory (mode:
> 0x250)

That sounds familiar.  Take a look at /proc/slabinfo and see if the
xfs_inode cache is using up all of your memory.  If so, here is a fix
for this from Dave that works by allowing inode reclaim to work during
mount:

commit 8a00ebe4cfc90eda9ecb575ba97e22021cd8cf70
Author: Dave Chinner <david@fromorbit.com>
Date:   Fri Apr 13 12:10:44 2012 +0000

    xfs: Ensure inode reclaim can run during quotacheck

There is a related fix that you will want:

commit 1307bbd2af67283131728637e9489002adb26f10
Author: Ben Myers <bpm@sgi.com>
Date:   Tue May 15 14:26:55 2012 -0500

    xfs: protect xfs_sync_worker with s_umount semaphore

The above made the 3.5 merge window.  The latter commit is functional
but we're not very happy with using the s_umount semaphore here, so it
is being replaced with something that is a bit cleaner very soon.   I
will propose them for the 3.2-stable branch.

Regards,
Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
