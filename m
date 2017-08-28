Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:33999 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750767AbdH1Hi4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Aug 2017 03:38:56 -0400
Date: Mon, 28 Aug 2017 00:38:54 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] ext4: introduce per-inode DAX flag
Message-ID: <20170828073853.GA23262@infradead.org>
References: <20170808090016.lxfbcrhoybmyfvlc@rh_laptop>
 <20170811100147.GB7064@infradead.org>
 <20170811121132.bj5y77scrvkgy7uo@rh_laptop>
 <20170811125849.GA15300@infradead.org>
 <20170811134130.o46y5jpekrpj5qvw@rh_laptop>
 <20170824182057.amdirlrbugezrahy@thunk.org>
 <20170825075415.GA748@infradead.org>
 <20170825151445.ycf5xomoxvebgaez@thunk.org>
 <20170825154032.GA1827@infradead.org>
 <20170825233358.GC17782@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170825233358.GC17782@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>, linux-xfs@vger.kernel.org

On Sat, Aug 26, 2017 at 09:33:58AM +1000, Dave Chinner wrote:
> > Nah, -o dax works very well.  It's just the flag instead of the -o dax
> > option or rather switching it on a mapped file will probably be very dangerous.
> 
> In what way is it dangerous, Christoph?

When I run the following script as a normal user:

FSXDIR=~/xfstests/ltp/
FILE=/mnt/foo

${FSXDIR}/fsx $FILE &

while true; do
    xfs_io -c 'chattr +x' $FILE
    xfs_io -c 'chattr -x' $FILE
done

I get this nice little crash:

root@testvm:~# sh test.sh
skipping zero size read
skipping insert range behind EOF
truncating to largest ever: 0x3a290
zero_range to largest ever: 0x3a8d1
zero_range to largest ever: 0x3fe3e
zero_range to largest ever: 0x40000
[  344.898390] BUG: unable to handle kernel NULL pointer dereference at 0000000000000020
[  344.899306] IP: iomap_page_mkwrite+0x17/0xf0
[  344.899795] PGD 7db37067
[  344.899796] P4D 7db37067
[  344.900099] PUD 78c61067
[  344.900389] PMD 0
[  344.900665]
[  344.901075] Oops: 0000 [#1] SMP
[  344.901536] Modules linked in:
[  344.901716] CPU: 3 PID: 6052 Comm: fsx Not tainted 4.12.0+ #2199
[  344.901716] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.10.2-0-g5f4c7b1-prebuilt.qemu-project.org 04/01/2014
[  344.901716] task: ffff880079a0da00 task.stack: ffffc900068a4000
[  344.901716] RIP: 0010:iomap_page_mkwrite+0x17/0xf0
[  344.901716] RSP: 0000:ffffc900068a7d38 EFLAGS: 00010246
[  344.901716] RAX: ffff8800798dd0d0 RBX: 0000000000000200 RCX: 0000000000000001
[  344.901716] RDX: 0000000070eb898e RSI: ffffffff82109010 RDI: ffffc900068a7df0
[  344.901716] RBP: ffffc900068a7d60 R08: ffffffff82ff9fa8 R09: 0000000000000000
[  344.901716] R10: ffffc900068a7cb0 R11: ffffffff8159b5cc R12: ffffffff82109010
[  344.901716] R13: 0000000000000000 R14: ffffc900068a7df0 R15: ffff88007da89580
[  344.901716] FS:  00007f76bc863700(0000) GS:ffff88007fd80000(0000) knlGS:0000000000000000
[  344.901716] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  344.901716] CR2: 0000000000000020 CR3: 000000007d90b000 CR4: 00000000000006e0
[  344.901716] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  344.901716] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  344.901716] Call Trace:
[  344.901716]  xfs_filemap_page_mkwrite+0x90/0x1d0
[  344.901716]  xfs_filemap_fault+0x114/0x180
[  344.901716]  __do_fault+0x19/0x60
[  344.901716]  __handle_mm_fault+0x68f/0xaf0
[  344.901716]  handle_mm_fault+0x82/0x130
[  344.901716]  __do_page_fault+0x222/0x4d0
[  344.901716]  trace_do_page_fault+0x85/0x210
[  344.901716]  do_async_page_fault+0x14/0x60
[  344.901716]  async_page_fault+0x28/0x30
[  344.901716] RIP: 0033:0x7f76bbd14049
[  344.901716] RSP: 002b:00007ffcdd6c7fe8 EFLAGS: 00010206
[  344.901716] RAX: 000000000002f144 RBX: 0000000000000fd9 RCX: 000000000000fd98
[  344.901716] RDX: 0000000000007ecc RSI: 00007f76bc80efe9 RDI: 00007f76bc7d7fd9
[  344.901716] RBP: 00007f76bc7d7000 R08: 0000000000000003 R09: 000000000002e000
[  344.901716] R10: 0000000000000001 R11: 0000000000000206 R12: 0000000000007ecc
[  344.901716] R13: 000000000002efd9 R14: 0000000000008ea5 R15: 0000000000000000
[  344.901716] Code: 50 ff ff ff 5d c3 0f 1f 40 00 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 41 57 41 56 41 55 41 54 49 89 f4 53 4c 8b 6f 48 48 8b 07 <49> 8b 55 20 48 8b 80 a0 00 00 00 4c 8b 70 20 48 8d 42 ff 83 e2
[  344.901716] RIP: iomap_page_mkwrite+0x17/0xf0 RSP: ffffc900068a7d38
[  344.901716] CR2: 0000000000000020
[  344.924264] ---[ end trace c4e8d3bdccf6912b ]---
[  344.924834] Kernel panic - not syncing: Fatal exception
[  344.925504] Kernel Offset: disabled
[  344.925884] ---[ end Kernel panic - not syncing: Fatal exception

