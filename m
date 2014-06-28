Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 326117F3F
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2014 19:29:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 01F258F807A
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2014 17:29:55 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	qdp7Ps0zPhtNpIJc for <xfs@oss.sgi.com>;
	Fri, 27 Jun 2014 17:29:50 -0700 (PDT)
Date: Sat, 28 Jun 2014 10:29:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS CRC errors after a crash
Message-ID: <20140628002947.GZ9508@dastard>
References: <20140625164939.GA27620@quack.suse.cz>
	<20140625215952.GM9508@dastard>
	<20140626202046.GA17707@quack.suse.cz>
	<20140626231843.GU9508@dastard>
	<20140627213524.GA11519@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140627213524.GA11519@quack.suse.cz>
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

On Fri, Jun 27, 2014 at 11:35:24PM +0200, Jan Kara wrote:
> On Fri 27-06-14 09:18:43, Dave Chinner wrote:
> > On Thu, Jun 26, 2014 at 10:20:46PM +0200, Jan Kara wrote:
> > > On Thu 26-06-14 07:59:52, Dave Chinner wrote:
> > > > On Wed, Jun 25, 2014 at 06:49:39PM +0200, Jan Kara wrote:
> > > > >   Hello,
> > > > > 
> > > > >   so I've been crash-testing XFS (just killing KVM with XFS filesystem
> > > > > mounted) a bit with V5 superblock enabled in 3.16-rc1 and I can pretty
> > > > > easily hit CRC mismatches after that. Kernel complains like:
> > > > 
> > > > Yes, we had that reported yesterday by another person, using virtual
> > > > box. I've been unable to reproduce it on my local KVM VMs, so I'm
> > > > wondering what your configuration KVM configuration is?
> > >   I'm running the qemu as:
> > > qemu-kvm -m 2048 -smp 6 -drive file=/dev/sdb,if=virtio,cache=none -net
> > > nic,macaddr=00:16:3e:32:96:20,model=virtio -net
> > > tap,script=/root/tests/bin/qemu-setup-net -vnc :1 -serial file:serial.log
> > > -kernel /boot/vmlinuz-autotest -initrd /boot/initrd-autotest -append
> > > 'root=/dev/vda3 rootflags=relatime'
> > 
> > Ok, so you are testing directly on a block device via virtio, using
> > direct IO. Hmmm _ I'm using virtio,cache=none on image files on XFS,
> > so I can't see that there's be much difference there. Nothing else
> > stands out - I'm assuming that you're not using the "nobarrier"
> > mount option?
>   No, I'm not using nobarrier.
> 
> > > > > [518184.794175] XFS (sdb3): Mounting V5 Filesystem
> > > > > [518184.902898] XFS (sdb3): Starting recovery (logdev: internal)
> > > > > [518187.118860] XFS (sdb3): Metadata CRC error detected at xfs_agf_read_verify+0x5a/0x100 [xfs], block 0x1
> > > > > [518187.118870] XFS (sdb3): Unmount and run xfs_repair
> > > > > [518187.118875] XFS (sdb3): First 64 bytes of corrupted metadata buffer:
> > > > > [518187.118882] ffff880136ffd600: 58 41 47 46 00 00 00 01 00 00 00 00 00 0f aa 40  XAGF...........@
> > > > > [518187.118887] ffff880136ffd610: 00 02 6d 53 00 02 77 f8 00 00 00 00 00 00 00 01  ..mS..w.........
> > > > > [518187.118891] ffff880136ffd620: 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 03  ................
> > > > > [518187.118895] ffff880136ffd630: 00 00 00 04 00 08 81 d0 00 08 81 a7 00 00 00 00  ................
> > > > > [518187.118923] XFS (sdb3): metadata I/O error: block 0x1 ("xfs_trans_read_buf_map") error 74 numblks 1
> > > > > 
> > > > > So it seem like the checksum doesn't get updated properly in all the cases.
> > > > > Looking into the logdump, there doesn't seem to be any modifications for
> > > > > this AGF block in unrelayed part of the log but there are some modifications
> > > > > in the older parts of the log - the latest LSN where block 1 was updated is
> > > > > 1,4639 (and the buffer contents in the log corresponds to the data I see in
> > > > > block 1). However the lsn field in AGF structure in that block shows 1,3616
> > > > > so that really seems stale (and I've checked and in that transaction the
> > > > > block has been modified as well).
> > > > 
> > > > That tallies with what has been reported -it was the AGI block,
> > > > however. What I know so far is that the CRC matches for the version
> > > > of the structure logged at the apparent LSN, but the data is more
> > > > recent.
> > >   Yes, this is the case with my corruption as well.
> > > 
> > > > Now the only way I can see the data getting updated without the LSN
> > > > being updates is through log recovery, the analysis is here:
> > >   Yes, that's what I originally though as well but for me:
> > > log tail: 8960 head: 10080 state: <DIRTY>
> > >   and the problematic AGF has last been modified in lsn 1,4639 (and it
> > > contains data logged there, while agf_lsn field is set to 1,3616). So it
> > > seems recovery shouldn't replay lsn 4639?
> > 
> > No, what that tells me is that a previous log recovery replayed the
> > change at lsn 4639. Log recovery does not update the lsn in the
> > object because if log recovery fails we need to run it completely
> > from tail to head again, and we want it to rewrite all the changes
> > appropriately. If we update the lsn each time we recover a change,
> > then this won't happen.
> > 
> > Hence a sign of an object that has been recovered is that there is
> > newer data than the LSN indicates. The issue here is that the CRC
> > does not appear to have been updated, and I can't work out how that
> > can occur - log recovery of a buffer will see the appropriate magic
> > number, add the correct verifier, and when the recovered data is
> > written it will recalc the CRC first.
> > 
> > That's why I send the debug patch to catch buffer writes that didn't
> > have verifier ops attached. (attached below again for you). If that
> > fires at any time, then we have a smoking gun. But if it doesn't
> > fire and you still see CRC mismatches then we've got something
> > extremely subtle
>   OK, so I've reproduced the issue again and after some investigation found
> at least one issue in log recovery code (your debug assertions have
> tripped):

Ok, I am going to make that debug patch a permanent "feature" seeing
as it proved useful in tracking down this bug.

> In the case reproduced now, I had a log with one transaction
> containing the AGF buffer however the AGF buffer on disk already had the data
> from that transaction written (and had agf_lsn set appropriately). Log
> replay then read-ahead the buffer (that leaves b_ops at NULL), then after
> investigation of the log item found it shouldn't be replayed and never
> ended up calling xlog_recover_validate_buf_type() to set proper b_ops.
> Later when we removed orphan inodes (I'm not sure about proper xfs
> terminology), AGF was modified and written without proper verifiers set.

Ok, that also explains why we've been seeing it in AGF, AGI and
related ABT/IBT buffers and not in any other type of buffer. So you
analysis definitely fits the symptoms reported.

> The attached patch fixes the problem for me (at least this particular case
> of corruption). Since I'm on vacation already and it's late I'll leave it for
> now. If the problem needs to be fixed differently, feel free to modify /
> discard the attached patch (since I will be scarcely on email for following
> two weeks).

I might end up fixing it differently, but you'll get the credit for
finding debugging the problem. Many thanks, Jan, I owe you a beer or
two for finding this. :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
