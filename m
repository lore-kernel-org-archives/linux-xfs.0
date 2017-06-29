Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51616 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753039AbdF2MSU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Jun 2017 08:18:20 -0400
Date: Thu, 29 Jun 2017 08:18:18 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2] generic: test a race between dio reads and mapped
 writes
Message-ID: <20170629121818.GC3291@bfoster.bfoster>
References: <20170629053943.GK23360@eguan.usersys.redhat.com>
 <1498718201-3629-1-git-send-email-yangx.jy@cn.fujitsu.com>
 <20170629074550.GM23360@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170629074550.GM23360@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: Xiao Yang <yangx.jy@cn.fujitsu.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Thu, Jun 29, 2017 at 03:45:50PM +0800, Eryu Guan wrote:
> On Thu, Jun 29, 2017 at 02:36:41PM +0800, Xiao Yang wrote:
> > This test reproduces a race between a direct I/O read and
> > a mapped write to a hole in a file.  On xfs filesystem, it
> > will trigger a BUG_ON(), and this XFS bug has been fixed by:
> > 
> > 04197b3 ("xfs: don't BUG() on mixed direct and mapped I/O")
> > 
> > Signed-off-by: Xiao Yang <yangx.jy@cn.fujitsu.com>
> 
> Thanks for the updated version!
> 
> Add linux-xfs list to cc because I noticed an unexpected WARNING when
> testing on XFS. Please see below.
> 
> > ---
> >  tests/generic/445     | 89 +++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/445.out |  2 ++
> >  tests/generic/group   |  1 +
> >  3 files changed, 92 insertions(+)
> >  create mode 100755 tests/generic/445
> >  create mode 100644 tests/generic/445.out
> > 
> > diff --git a/tests/generic/445 b/tests/generic/445
> > new file mode 100755
> > index 0000000..28dfcbe
> > --- /dev/null
> > +++ b/tests/generic/445
> > @@ -0,0 +1,89 @@
> > +#! /bin/bash
> > +# FS QA Test No. 445
> > +#
> > +# Regression test for commit:
> > +# 04197b3 ("xfs: don't BUG() on mixed direct and mapped I/O")
> > +#
> > +# This case tests a race between a direct I/O read and a
> > +# mapped write to a hole in a file.  On xfs filesystem, it
> > +# will trigger a BUG_ON().
> > +#
> > +#-----------------------------------------------------------------------
> > +# Copyright (c) 2017 Fujitsu.  All Rights Reserved.
> > +# Author: Xiao Yang <yangx.jy@cn.fujitsu.com>
> > +#
> > +# This program is free software; you can redistribute it and/or
> > +# modify it under the terms of the GNU General Public License as
> > +# published by the Free Software Foundation.
> > +#
> > +# This program is distributed in the hope that it would be useful,
> > +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> > +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > +# GNU General Public License for more details.
> > +#
> > +# You should have received a copy of the GNU General Public License
> > +# along with this program; if not, write the Free Software Foundation,
> > +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> > +#-----------------------------------------------------------------------
> > +
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1    # failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +	rm -rf $tmp.*
> > +}
> > +
> > +# get standard environment and checks
> > +. ./common/rc
> > +
> > +# real QA test starts here
> > +_supported_os Linux
> > +_require_scratch
> > +_require_xfs_io_command "truncate"
> > +_require_xfs_io_command "fpunch"
> > +
> > +rm -f $seqres.full
> > +
> > +# format and mount
> > +_scratch_mkfs > $seqres.full 2>&1
> > +_scratch_mount >> $seqres.full 2>&1
> > +
> > +filesz=$((65536 * 2))
> > +
> > +# create a test file with a hole
> > +$XFS_IO_PROG -f -c "truncate $((filesz * 2))" $SCRATCH_MNT/file >> $seqres.full
> > +
> > +# run a background dio read to a hole in a loop
> > +while true; do
> > +	$XFS_IO_PROG -d -c "pread 0 $filesz" $SCRATCH_MNT/file > /dev/null 2>&1
> > +done &
> > +
> > +dread_pid=$!
> > +
> > +# run mapped write to the same hole as dio read
> > +for i in `seq 0 999`; do
> > +	$XFS_IO_PROG -c "mmap 0 $filesz" -c "mwrite 0 $filesz" $SCRATCH_MNT/file \
> > +		> /dev/null
> > +	$XFS_IO_PROG -c "fpunch 0 $filesz" $SCRATCH_MNT/file > /dev/null
> > +done
> > +
> > +kill -9 $dread_pid > /dev/null 2>&1
> > +wait $dread_pid > /dev/null 2>&1
> > +
> > +echo "Silence is golden"
> > +
> > +# check dmesg, filtering out expected XFS warnings about mixed mmap/dio
> 
> BTW, I added _scratch_unmount before _check_dmesg, in case umount
> triggers other warnings.
> 
> > +if [ "$FSTYP" == "xfs" ]; then
> > +	_check_dmesg _filter_xfs_dmesg
> > +else
> > +	_check_dmesg
> > +fi
> 
> I hit unexpected warning at fs/iomap.c:766 iomap_dio_actor+0xca/0x370,
> which indicates an unknown IOMAP type:
> 
>         switch (iomap->type) {
>         case IOMAP_HOLE:
>                 ...
>         case IOMAP_UNWRITTEN:
>                 ...
>         case IOMAP_MAPPED:
>                 ...
>         default:
> 766             WARN_ON_ONCE(1);
>                 return -EIO;
>         }
> 
> But shouldn't this be fixed by commit a008c31c7ef9 ("iomap_dio_rw: Prevent
> reading file data beyond iomap_dio->i_size")? Another code path that
> needs fix?
> 
> [   30.894989] ------------[ cut here ]------------
> [   30.895400] WARNING: CPU: 2 PID: 3456 at fs/iomap.c:766 iomap_dio_actor+0xca/0x370

Hmm, so I suspect this occurs due to a dio read to a delayed allocation
mapping..? This seems possible because the dio read (and associated
filemap flush) occurs under the shared iolock and mapped write occurs
under the separate mmap lock. IIRC, the patch mentioned in the commit
log above was to remove a BUG() caused by a known bad mix of dio/mapped
I/O to avoid a kernel crash, but that doesn't make the situation safe.
IOW, it seems to me that this warning and an accompanying dio error are
probably expected..?

Brian

> [   30.896025] Modules linked in: btrfs xor raid6_pq ppdev i2c_piix4 parport_pc sg virtio_balloon parport i2c_core pcspkr nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_tables xfs libcrc32c sd_mod ata_generic pata_acpi ata_piix virtio_scsi libata virtio_pci virtio_ring 8139too virtio 8139cp serio_raw mii floppy
> [   30.898224] CPU: 2 PID: 3456 Comm: xfs_io Tainted: G        W       4.12.0-rc7 #172
> [   30.898851] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2007
> [   30.899348] task: ffff880210e38000 task.stack: ffffc90004a28000
> [   30.899830] RIP: 0010:iomap_dio_actor+0xca/0x370
> [   30.900222] RSP: 0018:ffffc90004a2bc20 EFLAGS: 00010202
> [   30.900656] RAX: 0000000000000002 RBX: ffffc90004a2bcb0 RCX: 00000000006c1000
> [   30.901244] RDX: 00000000000001ff RSI: ffffc90004a2be30 RDI: ffffc90004a2be68
> [   30.901829] RBP: ffffc90004a2bc90 R08: ffffc90004a2bcb0 R09: ffff880213f965a0
> [   30.902428] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
> [   30.903020] R13: ffffffffa0169b60 R14: ffff880213f965a0 R15: 0000000000000009
> [   30.903604] FS:  00007f7570f77740(0000) GS:ffff88021fd00000(0000) knlGS:0000000000000000
> [   30.904541] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   30.905025] CR2: 00000000006c1000 CR3: 00000002145df000 CR4: 00000000000006e0
> [   30.905614] Call Trace:
> [   30.905820]  ? iomap_dio_zero+0x100/0x100
> [   30.906167]  iomap_apply+0xa1/0x110
> [   30.906464]  iomap_dio_rw+0x20b/0x390
> [   30.906764]  ? iomap_dio_zero+0x100/0x100
> [   30.907138]  xfs_file_dio_aio_read+0x6e/0xf0 [xfs]
> [   30.907560]  xfs_file_read_iter+0xab/0xc0 [xfs]
> [   30.907933]  __vfs_read+0xe0/0x150
> [   30.908236]  vfs_read+0x8c/0x130
> [   30.908790]  SyS_pread64+0x87/0xb0
> [   30.909093]  do_syscall_64+0x67/0x150
> [   30.909404]  entry_SYSCALL64_slow_path+0x25/0x25
> [   30.909776] RIP: 0033:0x7f7570b59f73
> [   30.910087] RSP: 002b:00007fffd34ce9a0 EFLAGS: 00000293 ORIG_RAX: 0000000000000011
> [   30.910705] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f7570b59f73
> [   30.911297] RDX: 0000000000001000 RSI: 00000000006c1000 RDI: 0000000000000003
> [   30.911875] RBP: 00007fffd34cea60 R08: 0000000000000000 R09: 0000000000000000
> [   30.912473] R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000000
> [   30.913062] R13: 0000000000020000 R14: 0000000000000000 R15: 0000000000000000
> [   30.913645] Code: e1 48 09 c1 48 85 ca 0f 85 82 02 00 00 0f b7 43 18 66 83 f8 03 0f 84 fb 01 00 00 66 83 f8 04 74 35 66 83 f8 01 0f 84 07 02 00 00 <0f> ff 48 c7 c0 fb ff ff ff 48 8b 4d d0 65 48 33 0c 25 28 00 00
> [   30.915181] ---[ end trace 82f9af72bfb35f21 ]---
> 
> Thanks,
> Eryu
> 
> > +status=$?
> > +exit
> > diff --git a/tests/generic/445.out b/tests/generic/445.out
> > new file mode 100644
> > index 0000000..44e55d2
> > --- /dev/null
> > +++ b/tests/generic/445.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 445
> > +Silence is golden
> > diff --git a/tests/generic/group b/tests/generic/group
> > index ced111c..39991b1 100644
> > --- a/tests/generic/group
> > +++ b/tests/generic/group
> > @@ -447,3 +447,4 @@
> >  442 blockdev
> >  443 auto quick rw
> >  444 auto quick acl
> > +445 auto quick dangerous
> > -- 
> > 1.8.3.1
> > 
> > 
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
