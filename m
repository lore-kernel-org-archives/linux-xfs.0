Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:6843 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751374AbdH2W5V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 18:57:21 -0400
Date: Wed, 30 Aug 2017 08:57:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] ext4: introduce per-inode DAX flag
Message-ID: <20170829225717.GG10621@dastard>
References: <20170811125849.GA15300@infradead.org>
 <20170811134130.o46y5jpekrpj5qvw@rh_laptop>
 <20170824182057.amdirlrbugezrahy@thunk.org>
 <20170825075415.GA748@infradead.org>
 <20170825151445.ycf5xomoxvebgaez@thunk.org>
 <20170825154032.GA1827@infradead.org>
 <20170825233358.GC17782@dastard>
 <20170828073853.GA23262@infradead.org>
 <20170828101014.GD17782@dastard>
 <20170829154922.GA24592@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170829154922.GA24592@quack2.suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>, linux-xfs@vger.kernel.org

On Tue, Aug 29, 2017 at 05:49:22PM +0200, Jan Kara wrote:
> On Mon 28-08-17 20:10:14, Dave Chinner wrote:
> > On Mon, Aug 28, 2017 at 12:38:54AM -0700, Christoph Hellwig wrote:
> > > On Sat, Aug 26, 2017 at 09:33:58AM +1000, Dave Chinner wrote:
> > > > > Nah, -o dax works very well.  It's just the flag instead of the -o dax
> > > > > option or rather switching it on a mapped file will probably be very dangerous.
> > > > 
> > > > In what way is it dangerous, Christoph?
> > > 
> > > When I run the following script as a normal user:
> > > 
> > > FSXDIR=~/xfstests/ltp/
> > > FILE=/mnt/foo
> > > 
> > > ${FSXDIR}/fsx $FILE &
> > > 
> > > while true; do
> > >     xfs_io -c 'chattr +x' $FILE
> > >     xfs_io -c 'chattr -x' $FILE
> > > done
> > >
> > > I get this nice little crash:
> > 
> > Can you please package that up into an xfstest?
> > 
> > > root@testvm:~# sh test.sh
> > > skipping zero size read
> > > skipping insert range behind EOF
> > > truncating to largest ever: 0x3a290
> > > zero_range to largest ever: 0x3a8d1
> > > zero_range to largest ever: 0x3fe3e
> > > zero_range to largest ever: 0x40000
> > > [  344.898390] BUG: unable to handle kernel NULL pointer dereference at 0000000000000020
> > > [  344.899306] IP: iomap_page_mkwrite+0x17/0xf0
> > > [  344.899795] PGD 7db37067
> > > [  344.899796] P4D 7db37067
> > > [  344.900099] PUD 78c61067
> > > [  344.900389] PMD 0
> > > [  344.900665]
> > > [  344.901075] Oops: 0000 [#1] SMP
> > > [  344.901536] Modules linked in:
> > > [  344.901716] CPU: 3 PID: 6052 Comm: fsx Not tainted 4.12.0+ #2199
> > > [  344.901716] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.10.2-0-g5f4c7b1-prebuilt.qemu-project.org 04/01/2014
> > > [  344.901716] task: ffff880079a0da00 task.stack: ffffc900068a4000
> > > [  344.901716] RIP: 0010:iomap_page_mkwrite+0x17/0xf0
> > > [  344.901716] RSP: 0000:ffffc900068a7d38 EFLAGS: 00010246
> > > [  344.901716] RAX: ffff8800798dd0d0 RBX: 0000000000000200 RCX: 0000000000000001
> > > [  344.901716] RDX: 0000000070eb898e RSI: ffffffff82109010 RDI: ffffc900068a7df0
> > > [  344.901716] RBP: ffffc900068a7d60 R08: ffffffff82ff9fa8 R09: 0000000000000000
> > > [  344.901716] R10: ffffc900068a7cb0 R11: ffffffff8159b5cc R12: ffffffff82109010
> > > [  344.901716] R13: 0000000000000000 R14: ffffc900068a7df0 R15: ffff88007da89580
> >                       ^^^^^^^^^^^^^^^^
> > 
> > vmf->page is null.
> > 
> > Which means IS_DAX changed half way through a fault, despite us
> > holding the MMAPLOCK and protecting all the filesystem side of the
> > fault code from races.
> > 
> > Seems to me that even allowing filesystems to switch between
> > different mapping tree behaviours based on an inode flag is a
> > fundamentally broken model. The fault action that needs to taken by
> > the filesystem has already been predetermined by the fault
> > processing that has already occurred and placed into the contents of
> > the vmf we've been passed.
> 
> I don't think the problem is actually within MM in this particular case.
> The problem seems to be that xfs_filemap_fault() checks IS_DAX without
> holding MMAPLOCK and so it can change after that test and before the test
> in xfs_filemap_page_mkwrite().

First thing I did was fix that, and it still paniced with vmf->page
= null in iomap_page_mkwrite, then I realised it was irrelevant
because if it can change between xfs_filemap_fault() and
xfs_filemap_page_mkwrite() it can change anytime in the fault path
we are not holding the MMAPLOCK....

> > Hence I think that if we need to process the fault as a DAX fault
> > then the vmf needs to tell us that, not require us to look up an
> > inode flag to determine what to do. ANd if the inode flag changes,
> > then that needs to be propagated through the mapping and VMAs in a
> > sane fashion, not just run an invalidation from the filesystem. I
> > don't know enough about the VM code to say anything useful about how
> > this needs to be set up, but it's clear that mapping invalidation
> > and behaviour swaps can't be completely serialised against page
> > faults from the filesystem side.
> 
> But there is no difference in vmf setup from generic MM side. In particular
> vmf->page is set by the ->fault handler and then it is passed to
> ->page_mkwrite handler.

Yes there is. DAX can call the .fault() handler directly from
handle_pte_fault() for write faults on DAX when there is no pte
installed. In which case vmf->page is null because we don't go
through do_wp_page() to install the page we faulted on in the vmf
before calling .page_mkwrite().

IOWs, if we fault between the invalidation in the IS_DAX changing
code and dropping the MMAPLOCK once the transaction inode change is
complete, then that fault will find an empty pte. It will then call
->filemap_fault with vmf->page = NULL, and block on the MMAPLOCK
until the filesystem transaction is complete. Then it checks
IS_DAX, finds it's not set, so assumes that we have a page cache
fault, not a DAX fault....

It appears to me that we can't prevent this invalidation vs fault
race condition with filesystem-only locking and that means we can't
use filesystem side configuration flags to determine what action to
take in the filesystem side of the fault path. I have no idea what
mm/ side lock is needed to prevent this invalidation vs fault race
condition from occurring, nor whether it is even possible to take
and hold that lock in the filesysetm code where we would need to.

> And changes to mapping behavior between these two
> callbacks should be prevented by the page lock / radix entry lock...

No page, no page lock. We're above the mapping code, too, so no
radix entry lock is held here, either...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
