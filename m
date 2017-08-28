Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:45245 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751781AbdH1KKh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Aug 2017 06:10:37 -0400
Date: Mon, 28 Aug 2017 20:10:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] ext4: introduce per-inode DAX flag
Message-ID: <20170828101014.GD17782@dastard>
References: <20170811100147.GB7064@infradead.org>
 <20170811121132.bj5y77scrvkgy7uo@rh_laptop>
 <20170811125849.GA15300@infradead.org>
 <20170811134130.o46y5jpekrpj5qvw@rh_laptop>
 <20170824182057.amdirlrbugezrahy@thunk.org>
 <20170825075415.GA748@infradead.org>
 <20170825151445.ycf5xomoxvebgaez@thunk.org>
 <20170825154032.GA1827@infradead.org>
 <20170825233358.GC17782@dastard>
 <20170828073853.GA23262@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170828073853.GA23262@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>, linux-xfs@vger.kernel.org

On Mon, Aug 28, 2017 at 12:38:54AM -0700, Christoph Hellwig wrote:
> On Sat, Aug 26, 2017 at 09:33:58AM +1000, Dave Chinner wrote:
> > > Nah, -o dax works very well.  It's just the flag instead of the -o dax
> > > option or rather switching it on a mapped file will probably be very dangerous.
> > 
> > In what way is it dangerous, Christoph?
> 
> When I run the following script as a normal user:
> 
> FSXDIR=~/xfstests/ltp/
> FILE=/mnt/foo
> 
> ${FSXDIR}/fsx $FILE &
> 
> while true; do
>     xfs_io -c 'chattr +x' $FILE
>     xfs_io -c 'chattr -x' $FILE
> done
>
> I get this nice little crash:

Can you please package that up into an xfstest?

> root@testvm:~# sh test.sh
> skipping zero size read
> skipping insert range behind EOF
> truncating to largest ever: 0x3a290
> zero_range to largest ever: 0x3a8d1
> zero_range to largest ever: 0x3fe3e
> zero_range to largest ever: 0x40000
> [  344.898390] BUG: unable to handle kernel NULL pointer dereference at 0000000000000020
> [  344.899306] IP: iomap_page_mkwrite+0x17/0xf0
> [  344.899795] PGD 7db37067
> [  344.899796] P4D 7db37067
> [  344.900099] PUD 78c61067
> [  344.900389] PMD 0
> [  344.900665]
> [  344.901075] Oops: 0000 [#1] SMP
> [  344.901536] Modules linked in:
> [  344.901716] CPU: 3 PID: 6052 Comm: fsx Not tainted 4.12.0+ #2199
> [  344.901716] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.10.2-0-g5f4c7b1-prebuilt.qemu-project.org 04/01/2014
> [  344.901716] task: ffff880079a0da00 task.stack: ffffc900068a4000
> [  344.901716] RIP: 0010:iomap_page_mkwrite+0x17/0xf0
> [  344.901716] RSP: 0000:ffffc900068a7d38 EFLAGS: 00010246
> [  344.901716] RAX: ffff8800798dd0d0 RBX: 0000000000000200 RCX: 0000000000000001
> [  344.901716] RDX: 0000000070eb898e RSI: ffffffff82109010 RDI: ffffc900068a7df0
> [  344.901716] RBP: ffffc900068a7d60 R08: ffffffff82ff9fa8 R09: 0000000000000000
> [  344.901716] R10: ffffc900068a7cb0 R11: ffffffff8159b5cc R12: ffffffff82109010
> [  344.901716] R13: 0000000000000000 R14: ffffc900068a7df0 R15: ffff88007da89580
                      ^^^^^^^^^^^^^^^^

vmf->page is null.

Which means IS_DAX changed half way through a fault, despite us
holding the MMAPLOCK and protecting all the filesystem side of the
fault code from races.

Seems to me that even allowing filesystems to switch between
different mapping tree behaviours based on an inode flag is a
fundamentally broken model. The fault action that needs to taken by
the filesystem has already been predetermined by the fault
processing that has already occurred and placed into the contents of
the vmf we've been passed.

Hence I think that if we need to process the fault as a DAX fault
then the vmf needs to tell us that, not require us to look up an
inode flag to determine what to do. ANd if the inode flag changes,
then that needs to be propagated through the mapping and VMAs in a
sane fashion, not just run an invalidation from the filesystem. I
don't know enough about the VM code to say anything useful about how
this needs to be set up, but it's clear that mapping invalidation
and behaviour swaps can't be completely serialised against page
faults from the filesystem side.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
