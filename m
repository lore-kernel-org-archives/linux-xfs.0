Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1D3047F96
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2014 18:25:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C434330405F
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2014 16:25:03 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	M1qpvw01IXBT44fW for <xfs@oss.sgi.com>;
	Thu, 26 Jun 2014 16:25:01 -0700 (PDT)
Date: Fri, 27 Jun 2014 09:18:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS CRC errors after a crash
Message-ID: <20140626231843.GU9508@dastard>
References: <20140625164939.GA27620@quack.suse.cz>
	<20140625215952.GM9508@dastard>
	<20140626202046.GA17707@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140626202046.GA17707@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: xfs@oss.sgi.com

On Thu, Jun 26, 2014 at 10:20:46PM +0200, Jan Kara wrote:
> On Thu 26-06-14 07:59:52, Dave Chinner wrote:
> > On Wed, Jun 25, 2014 at 06:49:39PM +0200, Jan Kara wrote:
> > >   Hello,
> > > 
> > >   so I've been crash-testing XFS (just killing KVM with XFS filesystem
> > > mounted) a bit with V5 superblock enabled in 3.16-rc1 and I can pretty
> > > easily hit CRC mismatches after that. Kernel complains like:
> > 
> > Yes, we had that reported yesterday by another person, using virtual
> > box. I've been unable to reproduce it on my local KVM VMs, so I'm
> > wondering what your configuration KVM configuration is?
>   I'm running the qemu as:
> qemu-kvm -m 2048 -smp 6 -drive file=/dev/sdb,if=virtio,cache=none -net
> nic,macaddr=00:16:3e:32:96:20,model=virtio -net
> tap,script=/root/tests/bin/qemu-setup-net -vnc :1 -serial file:serial.log
> -kernel /boot/vmlinuz-autotest -initrd /boot/initrd-autotest -append
> 'root=/dev/vda3 rootflags=relatime'

Ok, so you are testing directly on a block device via virtio, using
direct IO. Hmmm _ I'm using virtio,cache=none on image files on XFS,
so I can't see that there's be much difference there. Nothing else
stands out - I'm assuming that you're not using the "nobarrier"
mount option?

> > > [518184.794175] XFS (sdb3): Mounting V5 Filesystem
> > > [518184.902898] XFS (sdb3): Starting recovery (logdev: internal)
> > > [518187.118860] XFS (sdb3): Metadata CRC error detected at xfs_agf_read_verify+0x5a/0x100 [xfs], block 0x1
> > > [518187.118870] XFS (sdb3): Unmount and run xfs_repair
> > > [518187.118875] XFS (sdb3): First 64 bytes of corrupted metadata buffer:
> > > [518187.118882] ffff880136ffd600: 58 41 47 46 00 00 00 01 00 00 00 00 00 0f aa 40  XAGF...........@
> > > [518187.118887] ffff880136ffd610: 00 02 6d 53 00 02 77 f8 00 00 00 00 00 00 00 01  ..mS..w.........
> > > [518187.118891] ffff880136ffd620: 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 03  ................
> > > [518187.118895] ffff880136ffd630: 00 00 00 04 00 08 81 d0 00 08 81 a7 00 00 00 00  ................
> > > [518187.118923] XFS (sdb3): metadata I/O error: block 0x1 ("xfs_trans_read_buf_map") error 74 numblks 1
> > > 
> > > So it seem like the checksum doesn't get updated properly in all the cases.
> > > Looking into the logdump, there doesn't seem to be any modifications for
> > > this AGF block in unrelayed part of the log but there are some modifications
> > > in the older parts of the log - the latest LSN where block 1 was updated is
> > > 1,4639 (and the buffer contents in the log corresponds to the data I see in
> > > block 1). However the lsn field in AGF structure in that block shows 1,3616
> > > so that really seems stale (and I've checked and in that transaction the
> > > block has been modified as well).
> > 
> > That tallies with what has been reported -it was the AGI block,
> > however. What I know so far is that the CRC matches for the version
> > of the structure logged at the apparent LSN, but the data is more
> > recent.
>   Yes, this is the case with my corruption as well.
> 
> > Now the only way I can see the data getting updated without the LSN
> > being updates is through log recovery, the analysis is here:
>   Yes, that's what I originally though as well but for me:
> log tail: 8960 head: 10080 state: <DIRTY>
>   and the problematic AGF has last been modified in lsn 1,4639 (and it
> contains data logged there, while agf_lsn field is set to 1,3616). So it
> seems recovery shouldn't replay lsn 4639?

No, what that tells me is that a previous log recovery replayed the
change at lsn 4639. Log recovery does not update the lsn in the
object because if log recovery fails we need to run it completely
from tail to head again, and we want it to rewrite all the changes
appropriately. If we update the lsn each time we recover a change,
then this won't happen.

Hence a sign of an object that has been recovered is that there is
newer data than the LSN indicates. The issue here is that the CRC
does not appear to have been updated, and I can't work out how that
can occur - log recovery of a buffer will see the appropriate magic
number, add the correct verifier, and when the recovered data is
written it will recalc the CRC first.

That's why I send the debug patch to catch buffer writes that didn't
have verifier ops attached. (attached below again for you). If that
fires at any time, then we have a smoking gun. But if it doesn't
fire and you still see CRC mismatches then we've got something
extremely subtle

> And since in my case kernel
> complains about CRC mismatch during log recovery and log tail is updated
> only after successful replay, we should see log as it was before an attempt
> to mount the fs?

It depends. The log should be unchanged if it fails in the first phase of
recovery. It's not until the first checkpoint during the second
phase that the log tail gets updated on disk (after EFI recovery),
so a failure in EFI or unlinked inode recovery can result in the log
tail moving.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: spew warnings when writing cached buffers without a verifier

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c | 6 ++++++
 fs/xfs/xfs_log.c | 7 ++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index a6dc83e..95e5516 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1330,6 +1330,12 @@ _xfs_buf_ioapply(
 						   SHUTDOWN_CORRUPT_INCORE);
 				return;
 			}
+		} else if (bp->b_bn != -1LL) {
+			xfs_warn(bp->b_target->bt_mount,
+				"%s: no ops on block 0x%llx/0x%llx",
+				__func__, bp->b_bn, bp->b_maps[0].bm_bn);
+			xfs_hex_dump(bp->b_addr, 64);
+			dump_stack();
 		}
 	} else if (bp->b_flags & XBF_READ_AHEAD) {
 		rw = READA;
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 7647818..ecf2048 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1369,8 +1369,13 @@ xlog_alloc_log(
 
 	xlog_get_iclog_buffer_size(mp, log);
 
+	/*
+	 * Use a block number of -1 for the extra log buffer used during splits
+	 * so that it will trigger errors if we ever try to do IO on it without
+	 * first having set it up properly.
+	 */
 	error = -ENOMEM;
-	bp = xfs_buf_alloc(mp->m_logdev_targp, 0, BTOBB(log->l_iclog_size), 0);
+	bp = xfs_buf_alloc(mp->m_logdev_targp, -1LL, BTOBB(log->l_iclog_size), 0);
 	if (!bp)
 		goto out_free_log;
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
