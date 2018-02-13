Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40214 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935175AbeBMNP1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 13 Feb 2018 08:15:27 -0500
Date: Tue, 13 Feb 2018 08:15:26 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2] xfs: byte range buffer dirty region tracking
Message-ID: <20180213131525.GA38210@bfoster.bfoster>
References: <20180201010514.30233-1-david@fromorbit.com>
 <20180205003415.dn6elcqb4kae3xle@destitution>
 <20180206162141.GA3862@bfoster.bfoster>
 <20180212024138.GB6778@dastard>
 <20180212142619.GA33694@bfoster.bfoster>
 <20180212211824.GC6778@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180212211824.GC6778@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Feb 13, 2018 at 08:18:24AM +1100, Dave Chinner wrote:
> On Mon, Feb 12, 2018 at 09:26:19AM -0500, Brian Foster wrote:
> > On Mon, Feb 12, 2018 at 01:41:38PM +1100, Dave Chinner wrote:
> > > On Tue, Feb 06, 2018 at 11:21:41AM -0500, Brian Foster wrote:
> > > > On Mon, Feb 05, 2018 at 11:34:15AM +1100, Dave Chinner wrote:
> > > > > -static void
> > > > > -xfs_buf_item_log_segment(
> > > > > +void
> > > > > +xfs_buf_item_log(
> > > > > +	struct xfs_buf_log_item	*bip,
> > > > >  	uint			first,
> > > > > -	uint			last,
> > > > > -	uint			*map)
> > > > > +	uint			last)
> > > > >  {
> > > > > -	uint		first_bit;
> > > > > -	uint		last_bit;
> > > > > -	uint		bits_to_set;
> > > > > -	uint		bits_set;
> > > > > -	uint		word_num;
> > > > > -	uint		*wordp;
> > > > > -	uint		bit;
> > > > > -	uint		end_bit;
> > > > > -	uint		mask;
> > > > > +	struct xfs_bli_range	*rp = NULL;
> > > > > +	int			i;
> > > > > +	ASSERT(last != 0);
> > > > 
> > > > The current code looks like it implicitly handles this case.
> > > 
> > > Yes, it may, but logging a zero size dirty region is simply wrong.
> > > 
> > 
> > That's not the case I'm referring to. If the range is inclusive, how
> > would you propose to log the first byte of a buffer?
> 
> We don't. No structure on disk has a single byte that needs to be
> logged individually as it's first member. Hence we don't ever do
> this.
> 

Drumroll please...

> If we ever happen to screw up an on-disk structure such that it
> doesn't have a 4 byte magic number and a chunk of self describing
> metadata as it's first 20-30 bytes in a buffer and we try to log
> just the first byte, then these asserts will fire to tell us that
> we've screwed up a new on-disk structure....
> 

For one, the asserts you've added don't sufficiently cover verification
of a 4 byte magic at the top of every logged buffer. By this logic, we'd
be just as broken by attempting to the log just the second or third byte
(or some other non-4 byte permutation) rather than the first. The
asserts won't catch that, though the logging infrastructure will do the
right thing in terms of ensuring the associated range is logged.

Beyond that, this simply isn't the responsibility of this code.

...
> > :/ So it seems to
> > me this breaks a technically valid case in weird/subtle ways. For
> > example, why assert about last == 0, but then go on to add the range
> > anyways, explicitly not size it correctly, but then format it as if
> > nothing is wrong? If it were really wrong/invalid (which I don't think
> > it is), why not put the check in the log side and skip adding the range
> > rather than add it, skip sizing it, and then format it.
> 
> So what you're really concerned about is that I put asserts into the
> code to catch broken development code, but then allow production
> systems through without caring whether it works correctly because
> that boundary condition will never occur during runtime on
> production systems?
> 

No. As already mentioned in my previous mail, I care little about the
asserts. Asserts can easily be removed if they turn out to be bogus.
Wrong asserts tend to have little negative effect on production users
because along with only affecting debug kernels, they'd have to be
fairly rare to slip through our testing. So I'm perfectly _happy_ to be
cautious with regard to asserts.

What I care much more about is not leaving latent bugs around in the
code. IMO, there is very rarely good enough justification to knowingly
commit buggy/fragile code to the kernel, regardless of whether
associated problems can be triggered or not in the broader codebase. The
tradeoff is a few minutes of due diligence now to save somebody else
potentially hours of pain associated with debugging shit/broken code
down the road, particularly in subsystems that are highly complex as it
is. So for future reference: having spent a fair amount of time doing
the latter, it's highly unlikely I'll offer an r-b on any patch that
does such a thing based on the argument offered here.

... having said all that and having already wasted more time on this
than it would have taken for you to just fix the patch, I'll end my rant
with this splat[1]. It demonstrates the "boundary condition" that "will
never occur during runtime on production systems" (production system
level output included for extra fun ;P). Note that this is a real
incantation of a problem (not something I've modified the code to
manufacture) and something that the current code handles correctly. So
the entire argument above is not only dubious, but also incorrect.

Brian

[1]

BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
IP: xlog_cil_push+0x184/0x400 [xfs]
PGD 0 P4D 0 
Oops: 0000 [#1] SMP
Modules linked in: xfs(O) ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute bridge stp llc ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack libcrc32c iptable_mangle iptable_raw iptable_security ebtable_filter ebtables ip6table_filter ip6_tables snd_hda_codec_generic snd_hda_intel snd_hda_codec snd_hwdep snd_hda_core snd_pcsp snd_pcm joydev virtio_balloon snd_timer snd e1000 soundcore i2c_piix4 virtio_scsi virtio_console virtio_blk serio_raw qxl sym53c8xx drm_kms_helper ttm scsi_transport_spi virtio_pci virtio_ring virtio ata_generic pata_acpi drm [last unloaded: xfs]
CPU: 2 PID: 162 Comm: kworker/2:2 Tainted: G           O     4.15.0-rc7+ #95
Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
Workqueue: xfs-cil/dm-3 xlog_cil_push_work [xfs]
RIP: 0010:xlog_cil_push+0x184/0x400 [xfs]
RSP: 0018:ffffa79d40f93d90 EFLAGS: 00010286
RAX: ffff8b5e55a15110 RBX: ffff8b5e57776900 RCX: dead000000000200
RDX: ffff8b5e4b6bb9d0 RSI: ffff8b5e4b6bb9d0 RDI: ffff8b5e55a15110
RBP: ffff8b5e5317b240 R08: 000000940b01765e R09: 0000000000000001
R10: 0000000000000001 R11: 0000000000000000 R12: ffff8b5e4af13000
R13: 0000000000000000 R14: ffff8b5e54e2f400 R15: 000000000000000e
FS:  0000000000000000(0000) GS:ffff8b5e5b200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000008 CR3: 000000010b6a5000 CR4: 00000000000006e0
Call Trace:
 ? lock_acquire+0x9f/0x1f0
 process_one_work+0x23e/0x680
 worker_thread+0x35/0x380
 ? process_one_work+0x680/0x680
 kthread+0x11a/0x130
 ? kthread_create_worker_on_cpu+0x70/0x70
 ret_from_fork+0x24/0x30
Code: 31 ff e8 90 6e f9 fa 49 8b 46 08 48 39 44 24 10 74 64 45 31 ed eb 1f 49 89 45 00 4c 8b 6a 10 48 c7 42 10 00 00 00 00 49 8b 46 08 <45> 03 7d 08 48 39 44 24 10 74 40 49 8b 56 08 48 89 d7 48 89 54 
RIP: xlog_cil_push+0x184/0x400 [xfs] RSP: ffffa79d40f93d90
CR2: 0000000000000008
---[ end trace ead0e466843c4bf9 ]---
BUG: sleeping function called from invalid context at ./include/linux/percpu-rwsem.h:34
in_atomic(): 0, irqs_disabled(): 1, pid: 162, name: kworker/2:2
INFO: lockdep is turned off.
irq event stamp: 162680
hardirqs last  enabled at (162679): [<00000000645f1f5e>] __slab_alloc+0x54/0x90
hardirqs last disabled at (162680): [<00000000e7a1d8b6>] error_entry+0x82/0xe0
softirqs last  enabled at (162664): [<0000000047a13c56>] process_one_work+0x23e/0x680
softirqs last disabled at (162660): [<00000000e6aa07a5>] neigh_periodic_work+0x2c/0x300
CPU: 2 PID: 162 Comm: kworker/2:2 Tainted: G      D    O     4.15.0-rc7+ #95
Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
Workqueue: xfs-cil/dm-3 xlog_cil_push_work [xfs]
Call Trace:
 dump_stack+0x85/0xc5
 ___might_sleep+0x156/0x240
 exit_signals+0x2b/0x240
 do_exit+0xb3/0xd00
 ? process_one_work+0x680/0x680
 ? kthread+0x11a/0x130
 rewind_stack_do_exit+0x17/0x20
