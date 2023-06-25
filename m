Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 387A5EB64DA
	for <linux-xfs@archiver.kernel.org>; Sun, 25 Jun 2023 02:58:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbjFYC6W (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 24 Jun 2023 22:58:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbjFYC6V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 24 Jun 2023 22:58:21 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 177FEE6A
        for <linux-xfs@vger.kernel.org>; Sat, 24 Jun 2023 19:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=qPL9/shs39uE+MzoDsPBytUvAg0ntFA6zH8yvLz1he4=; b=P4PfdYYwYgSgCnhvlrz6i2y6LP
        Q/7hydn/v8iTsP5ONrYC38I+oH9ZFv6ts2MHb4IyLfywLW4VDaRM04+FRvWvBaf92F95/gbSP+NIy
        eZ1Fzmdk3JzVrQFgmZ21BnrfOXli4eSFF2Wq0St2pqFNj83VJIy01pSoGeo9rhqumrLH644cwahOU
        ROMnleVENo6BXYotx4t5amhT/WppOI1nZtGWGo+OeA5xn2kD7NX7iEQFP6nuLI5RoHltJosMCsAMq
        wX/KJqwckTdJdOoTgUaSJjyU2ZTAEdohaR/bdHkj074GMXn0lt6T42qDwDW/2TRdbmZaDAwEqSep6
        LWLJLOvw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qDFx9-000JTp-Bv; Sun, 25 Jun 2023 02:58:15 +0000
Date:   Sun, 25 Jun 2023 03:58:15 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: fix AGF vs inode cluster buffer deadlock
Message-ID: <ZJetR4WyR33vzjsj@casper.infradead.org>
References: <20230517000449.3997582-1-david@fromorbit.com>
 <20230517000449.3997582-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230517000449.3997582-5-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 17, 2023 at 10:04:49AM +1000, Dave Chinner wrote:
> Lock order in XFS is AGI -> AGF, hence for operations involving
> inode unlinked list operations we always lock the AGI first. Inode
> unlinked list operations operate on the inode cluster buffer,
> so the lock order there is AGI -> inode cluster buffer.

Hi Dave,

This commit reliably produces an assertion failure for me.  I haven't
tried to analyse why.  It's pretty clear though; I can run generic/426
in a loop for hundreds of seconds on the parent commit (cb042117488d),
but it'll die within 30 seconds on commit 82842fee6e59.

    export MKFS_OPTIONS=3D"-m reflink=3D1,rmapbt=3D1 -i sparse=3D1 -b size=
=3D1024"

I suspect the size=3D1024 is the important thing, but I haven't tested
that hypothesis.  This is on an x86-64 virtual machine; full qemu
command line at the end [1]

00028 FSTYP         -- xfs (debug)
00028 PLATFORM      -- Linux/x86_64 pepe-kvm 6.4.0-rc5-00004-g82842fee6e59 =
#182 SMP PREEMPT_DYNAMIC Sat Jun 24 22:51:32 EDT 2023
00028 MKFS_OPTIONS  -- -f -m reflink=3D1,rmapbt=3D1 -i sparse=3D1 -b size=
=3D1024 /dev/sdc
00028 MOUNT_OPTIONS -- /dev/sdc /mnt/scratch
00028
00028 XFS (sdc): Mounting V5 Filesystem 591c2048-7cce-4eda-acf7-649e19cd8554
00028 XFS (sdc): Ending clean mount
00028 XFS (sdc): Unmounting Filesystem 591c2048-7cce-4eda-acf7-649e19cd8554
00028 XFS (sdb): EXPERIMENTAL online scrub feature in use. Use at your own =
risk!
00028 XFS (sdb): Unmounting Filesystem 9db9e0a2-c05b-4690-a938-ae8f7b70be8e
00028 XFS (sdb): Mounting V5 Filesystem 9db9e0a2-c05b-4690-a938-ae8f7b70be8e
00028 XFS (sdb): Ending clean mount
00028 generic/426       run fstests generic/426 at 2023-06-25 02:52:07
00029 XFS: Assertion failed: bp->b_flags & XBF_DONE, file: fs/xfs/xfs_trans=
_buf.c, line: 241
00029 ------------[ cut here ]------------
00029 kernel BUG at fs/xfs/xfs_message.c:102!
00029 invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
00029 CPU: 1 PID: 62 Comm: kworker/1:1 Kdump: loaded Not tainted 6.4.0-rc5-=
00004-g82842fee6e59 #182
00029 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debia=
n-1.16.2-1 04/01/2014
00029 Workqueue: xfs-inodegc/sdb xfs_inodegc_worker
00029 RIP: 0010:assfail+0x30/0x40
00029 Code: c9 48 c7 c2 48 f8 ea 81 48 89 f1 48 89 e5 48 89 fe 48 c7 c7 b9 =
cc e5 81 e8 fd fd ff ff 80 3d f6 2f d3 00 00 75 04 0f 0b 5d c3 <0f> 0b 66 6=
6 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 55 48 63 f6 49 89
00029 RSP: 0018:ffff88800317bc78 EFLAGS: 00010202
00029 RAX: 00000000ffffffea RBX: ffff88800611e000 RCX: 000000007fffffff
00029 RDX: 0000000000000021 RSI: 0000000000000000 RDI: ffffffff81e5ccb9
00029 RBP: ffff88800317bc78 R08: 0000000000000000 R09: 000000000000000a
00029 R10: 000000000000000a R11: 0fffffffffffffff R12: ffff88800c780800
00029 R13: ffff88800317bce0 R14: 0000000000000001 R15: ffff88800c73d000
00029 FS:  0000000000000000(0000) GS:ffff88807d840000(0000) knlGS:000000000=
0000000
00029 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
00029 CR2: 00005623b1911068 CR3: 000000000ee28003 CR4: 0000000000770ea0
00029 PKRU: 55555554
00029 Call Trace:
00029  <TASK>
00029  ? show_regs+0x5c/0x70
00029  ? die+0x32/0x90
00029  ? do_trap+0xbb/0xe0
00029  ? do_error_trap+0x67/0x90
00029  ? assfail+0x30/0x40
00029  ? exc_invalid_op+0x52/0x70
00029  ? assfail+0x30/0x40
00029  ? asm_exc_invalid_op+0x1b/0x20
00029  ? assfail+0x30/0x40
00029  ? assfail+0x23/0x40
00029  xfs_trans_read_buf_map+0x2d9/0x480
00029  xfs_imap_to_bp+0x3d/0x40
00029  xfs_inode_item_precommit+0x176/0x200
00029  xfs_trans_run_precommits+0x65/0xc0
00029  __xfs_trans_commit+0x3d/0x360
00029  xfs_trans_commit+0xb/0x10
00029  xfs_inactive_ifree.isra.0+0xea/0x200
00029  xfs_inactive+0x132/0x230
00029  xfs_inodegc_worker+0xb6/0x1a0
00029  process_one_work+0x1a9/0x3a0
00029  worker_thread+0x4e/0x3a0
00029  ? process_one_work+0x3a0/0x3a0
00029  kthread+0xf9/0x130

In case things have moved around since that commit, the particular line
throwing the assertion is in this paragraph:

        if (bp) {
                ASSERT(xfs_buf_islocked(bp));
                ASSERT(bp->b_transp =3D=3D tp);
                ASSERT(bp->b_log_item !=3D NULL);
                ASSERT(!bp->b_error);
                ASSERT(bp->b_flags & XBF_DONE);

It's the last one that trips.  Sorry for not catching this earlier; my
test suite experienced a bit of a failure and I only just got around to
fixing it enough to run all the way through.

[1] qemu-system-x86_64 -nodefaults -nographic -cpu host -machine type=3Dq35=
,accel=3Dkvm,nvdimm=3Don -m 2G,slots=3D8,maxmem=3D256G -smp 8 -kernel /home=
/willy/kernel/linux-next/.build_test_kernel-x86_64/kpgk/vmlinuz -append mit=
igations=3Doff console=3Dhvc0 root=3D/dev/sda rw log_buf_len=3D8M ktest.dir=
=3D/home/willy/kernel/ktest ktest.env=3D/tmp/build-test-kernel-FzOfFCHDVD/e=
nv crashkernel=3D128M no_console_suspend page_owner=3Don -device virtio-ser=
ial -chardev stdio,id=3Dconsole -device virtconsole,chardev=3Dconsole -seri=
al unix:/tmp/build-test-kernel-FzOfFCHDVD/vm-kgdb,server,nowait -monitor un=
ix:/tmp/build-test-kernel-FzOfFCHDVD/vm-mon,server,nowait -gdb unix:/tmp/bu=
ild-test-kernel-FzOfFCHDVD/vm-gdb,server,nowait -device virtio-rng-pci -vir=
tfs local,path=3D/,mount_tag=3Dhost,security_model=3Dnone -device virtio-sc=
si-pci,id=3Dhba -nic user,model=3Dvirtio,hostfwd=3Dtcp:127.0.0.1:28201-:22 =
-drive if=3Dnone,format=3Draw,id=3Ddisk0,file=3D/var/lib/ktest/root.amd64,s=
napshot=3Don -device scsi-hd,bus=3Dhba.0,drive=3Ddisk0 -drive if=3Dnone,for=
mat=3Draw,id=3Ddisk1,file=3D/tmp/build-test-kernel-FzOfFCHDVD/dev-1,cache=
=3Dunsafe -device scsi-hd,bus=3Dhba.0,drive=3Ddisk1 -drive if=3Dnone,format=
=3Draw,id=3Ddisk2,file=3D/tmp/build-test-kernel-FzOfFCHDVD/dev-2,cache=3Dun=
safe -device scsi-hd,bus=3Dhba.0,drive=3Ddisk2 -drive if=3Dnone,format=3Dra=
w,id=3Ddisk3,file=3D/tmp/build-test-kernel-FzOfFCHDVD/dev-3,cache=3Dunsafe =
-device scsi-hd,bus=3Dhba.0,drive=3Ddisk3 -drive if=3Dnone,format=3Draw,id=
=3Ddisk4,file=3D/tmp/build-test-kernel-FzOfFCHDVD/dev-4,cache=3Dunsafe -dev=
ice scsi-hd,bus=3Dhba.0,drive=3Ddisk4
