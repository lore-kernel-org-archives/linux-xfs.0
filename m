Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:40236 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727245AbeH2NNr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Aug 2018 09:13:47 -0400
Received: by mail-wm0-f67.google.com with SMTP id 207-v6so4704299wme.5
        for <linux-xfs@vger.kernel.org>; Wed, 29 Aug 2018 02:17:49 -0700 (PDT)
Date: Wed, 29 Aug 2018 11:17:45 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: Trying to write to read-only block-device from XFS
Message-ID: <20180829091745.6cmbsn3qhyrmj6bj@odin.usersys.redhat.com>
References: <20180824233756.kkvmkmm5mdlx77je@two.firstfloor.org>
 <a4d32107-abc0-60d3-8306-b091fbffefd8@sandeen.net>
 <20180825140951.a3dsz3efwnjsj2pz@two.firstfloor.org>
 <c6bcbef0-0c5b-a7a1-adb6-38085db98ce9@sandeen.net>
 <20180827081254.zat4lvxqviwgd4zn@odin.usersys.redhat.com>
 <20180827164342.4vlg3zaehkzcj6od@two.firstfloor.org>
 <20180828075420.5zcww22du3kqkvmq@odin.usersys.redhat.com>
 <20180829024013.ptprd7o3h3o6j2m2@two.firstfloor.org>
 <20180829041957.GF1572@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180829041957.GF1572@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Andi Kleen <andi@firstfloor.org>, Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Wed, Aug 29, 2018 at 02:19:57PM +1000, Dave Chinner wrote:
> On Tue, Aug 28, 2018 at 07:40:25PM -0700, Andi Kleen wrote:
> > On Tue, Aug 28, 2018 at 09:54:20AM +0200, Carlos Maiolino wrote:
> > > > 
> > > > Ok, so the blame is assigned, but the question is still how to avoid the
> > > > warning:
> > > 
> > > I'd say, unless you are using a volume manager that is doing something weird,
> > > which essentially LVM did by keep writing to RO volumes for snapshots, you
> > 
> > I don't use any snapshots.
> > 
> > > should avoid the warning by checking why your device went into RO mode and
> > > fix it.
> > 
> > You seem to be very confused about the purpose of kernel warnings.
> > 
> > Users should never be able to cause warnings by any action. 
> > It's always a software bug of some sort.

The reason I asked you about snapshots is because the first problems reported
after the patches I mentioned previously were from LVM users, due the fact LVM use
(or used to) write to snapshot volumes even when they were set to RO and the
generic_make_request() wasn't honoring the RO status.

If you believe kernel warnings can't be triggered by users, I do apologize, but
I'm not the one confused here. You can assume warnings shouldn't be triggered by
users, but the reality is very different from it, and there are many ways users
can make kernel print out warnings.

As Dave mentioned, it's pretty straight forward to trigger such warning, setting
the block device to RO while the filesystem is still RW.

Have you ever tried to write random data directly to the block device while the
filesystem was still mounted? Try it, wait a few seconds and see the kernel
printing out warnings.

So, yes, there are several ways users can trigger warnings, as long as the user
has enough permissions to change some configuration which will lead to weird
behavior.
KERN_WARNING flags, in my humble view, means: "Something unexpected happened, but
not critical enough to shut down your system", which IMHO, doesn't necessarily
means users can't trigger it. And of course I can be wrong too.

But anyway, I kindly ask you to keep childish behavior off of the list, because
keep shooting people for no reason specially when they are trying to help isn't
neither professional nor is going to help you get help faster on next issues you
may have.

Cheers


> 
> I don't know why you're trying to pick a fight with Carlos, Andi.
> 
> Neither the warning nor whatever is triggering the device to go RO
> has anything to do with XFS, so taking potshots the messenger and
> those trying to help you is out of line. We're just trying to get
> enough information to be able to point you at the right people to
> get your issue fixed.
> 
> To do that, there's /one/ question we need answered. A question both
> Eric and Carlos have already asked you: how is the block device
> being changed to RO while a RW filesystem is mounted on it?
> 
> FYI, the warning is /trivial/ to provoke manually by turning a block
> device read only under an active filesystem with the blockdev
> command:
> 
> root@test4~# blockdev --setro /dev/vdc
> [515320.769159] ------------[ cut here ]------------
> [515320.770078] generic_make_request: Trying to write to read-only block-device vdc (partno 0)
> [515320.771611] WARNING: CPU: 11 PID: 8173 at block/blk-core.c:2171 generic_make_request_checks+0x308/0x4a0
> [515320.773349] CPU: 11 PID: 8173 Comm: xfs_io Not tainted 4.18.0-dgc+ #648
> [515320.774577] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.11.1-1 04/01/2014
> [515320.776122] RIP: 0010:generic_make_request_checks+0x308/0x4a0
> [515320.777187] Code: 6c 03 00 00 48 8d 74 24 08 48 89 df c6 05 6c de fa 00 01 e8 ea 91 01 00 48 c7 c7 10 90 30 82 48 89 c6 44 89 ea e8 28 3d 9c ff <0f> 0b 48 8b 43 08 e9 b5 fd ff ff 48 8b 53 28 49 03 3
> [515320.780642] RSP: 0018:ffffc90008e0faf8 EFLAGS: 00010282
> [515320.781617] RAX: 0000000000000000 RBX: ffff880829db8180 RCX: 0000000000000006
> [515320.782934] RDX: 0000000000000007 RSI: 0000000000000082 RDI: ffff88083fd15550
> [515320.784272] RBP: ffff88023fab2000 R08: ffffffff8183f550 R09: 000000000000004e
> [515320.785595] R10: ffffc90008e0fbc8 R11: ffffffff82e5c9ee R12: 0000000000001000
> [515320.786910] R13: 0000000000000000 R14: ffffc90008e0fc90 R15: ffff880828cba180
> [515320.788241] FS:  00007f6beac60840(0000) GS:ffff88083fd00000(0000) knlGS:0000000000000000
> [515320.789738] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [515320.790802] CR2: 0000559f72e98000 CR3: 0000000829f2f005 CR4: 0000000000060ee0
> [515320.792124] Call Trace:
> [515320.792649]  ? blk_queue_enter+0x212/0x240
> [515320.793423]  generic_make_request+0x78/0x450
> [515320.794231]  ? iov_iter_get_pages+0xbe/0x2a0
> [515320.795035]  ? submit_bio+0x6d/0x120
> [515320.795714]  submit_bio+0x6d/0x120
> [515320.796403]  iomap_dio_bio_actor+0x1b5/0x3a0
> [515320.797218]  ? iomap_page_release.part.29+0x40/0x40
> [515320.798136]  iomap_apply+0xb0/0x130
> [515320.798803]  iomap_dio_rw+0x2a6/0x3c0
> [515320.799504]  ? iomap_page_release.part.29+0x40/0x40
> [515320.800458]  ? xfs_file_dio_aio_write+0x117/0x2e0
> [515320.801345]  xfs_file_dio_aio_write+0x117/0x2e0
> [515320.802205]  xfs_file_write_iter+0x83/0xb0
> [515320.802988]  __vfs_write+0x109/0x190
> [515320.803695]  vfs_write+0xb6/0x180
> [515320.804535]  ksys_pwrite64+0x71/0x90
> [515320.805212]  do_syscall_64+0x5a/0x180
> [515320.805910]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> [515320.806852] RIP: 0033:0x7f6bebd5e024
> 
> That doesn't happen on a normal system under normal operation,
> though, so we really need to know where it is coming from.  It's
> likely something in userspace on your system is doing it but until
> we know the source it is not clear where the incorrect behaviour
> lies and what may need fixing.
> 
> So, can you please find what is changing the block device mode to RO
> for us?
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

-- 
Carlos
