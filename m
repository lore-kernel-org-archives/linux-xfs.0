Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9626F7F89
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2014 15:20:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 501538F807A
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2014 13:20:50 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id unHmZqQ0RaXWBEXG (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 26 Jun 2014 13:20:48 -0700 (PDT)
Date: Thu, 26 Jun 2014 22:20:46 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: XFS CRC errors after a crash
Message-ID: <20140626202046.GA17707@quack.suse.cz>
References: <20140625164939.GA27620@quack.suse.cz>
	<20140625215952.GM9508@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140625215952.GM9508@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On Thu 26-06-14 07:59:52, Dave Chinner wrote:
> On Wed, Jun 25, 2014 at 06:49:39PM +0200, Jan Kara wrote:
> >   Hello,
> > 
> >   so I've been crash-testing XFS (just killing KVM with XFS filesystem
> > mounted) a bit with V5 superblock enabled in 3.16-rc1 and I can pretty
> > easily hit CRC mismatches after that. Kernel complains like:
> 
> Yes, we had that reported yesterday by another person, using virtual
> box. I've been unable to reproduce it on my local KVM VMs, so I'm
> wondering what your configuration KVM configuration is?
  I'm running the qemu as:
qemu-kvm -m 2048 -smp 6 -drive file=/dev/sdb,if=virtio,cache=none -net
nic,macaddr=00:16:3e:32:96:20,model=virtio -net
tap,script=/root/tests/bin/qemu-setup-net -vnc :1 -serial file:serial.log
-kernel /boot/vmlinuz-autotest -initrd /boot/initrd-autotest -append
'root=/dev/vda3 rootflags=relatime'

> > [518184.794175] XFS (sdb3): Mounting V5 Filesystem
> > [518184.902898] XFS (sdb3): Starting recovery (logdev: internal)
> > [518187.118860] XFS (sdb3): Metadata CRC error detected at xfs_agf_read_verify+0x5a/0x100 [xfs], block 0x1
> > [518187.118870] XFS (sdb3): Unmount and run xfs_repair
> > [518187.118875] XFS (sdb3): First 64 bytes of corrupted metadata buffer:
> > [518187.118882] ffff880136ffd600: 58 41 47 46 00 00 00 01 00 00 00 00 00 0f aa 40  XAGF...........@
> > [518187.118887] ffff880136ffd610: 00 02 6d 53 00 02 77 f8 00 00 00 00 00 00 00 01  ..mS..w.........
> > [518187.118891] ffff880136ffd620: 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 03  ................
> > [518187.118895] ffff880136ffd630: 00 00 00 04 00 08 81 d0 00 08 81 a7 00 00 00 00  ................
> > [518187.118923] XFS (sdb3): metadata I/O error: block 0x1 ("xfs_trans_read_buf_map") error 74 numblks 1
> > 
> > So it seem like the checksum doesn't get updated properly in all the cases.
> > Looking into the logdump, there doesn't seem to be any modifications for
> > this AGF block in unrelayed part of the log but there are some modifications
> > in the older parts of the log - the latest LSN where block 1 was updated is
> > 1,4639 (and the buffer contents in the log corresponds to the data I see in
> > block 1). However the lsn field in AGF structure in that block shows 1,3616
> > so that really seems stale (and I've checked and in that transaction the
> > block has been modified as well).
> 
> That tallies with what has been reported -it was the AGI block,
> however. What I know so far is that the CRC matches for the version
> of the structure logged at the apparent LSN, but the data is more
> recent.
  Yes, this is the case with my corruption as well.

> Now the only way I can see the data getting updated without the LSN
> being updates is through log recovery, the analysis is here:
  Yes, that's what I originally though as well but for me:
log tail: 8960 head: 10080 state: <DIRTY>
  and the problematic AGF has last been modified in lsn 1,4639 (and it
contains data logged there, while agf_lsn field is set to 1,3616). So it
seems recovery shouldn't replay lsn 4639? And since in my case kernel
complains about CRC mismatch during log recovery and log tail is updated
only after successful replay, we should see log as it was before an attempt
to mount the fs? Anyway, I'll try to reproduce with the procedure you
describe in the email below to make things clearer.

> http://oss.sgi.com/pipermail/xfs/2014-June/036938.html
> 
> At the bottom of the email is a request for a information resulting
> from a reproduction cycle. Can you run that cycle and provide the
> metadumps and dmesg when a problem is first found?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
