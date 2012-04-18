Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3I1wMmA134374 for <xfs@oss.sgi.com>; Tue, 17 Apr 2012 20:58:22 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	FMo0QMCy6lfvCnXY for <xfs@oss.sgi.com>;
	Tue, 17 Apr 2012 18:58:20 -0700 (PDT)
Date: Wed, 18 Apr 2012 11:58:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 03/18] xfs: Do background CIL flushes via a workqueue
Message-ID: <20120418015818.GN6734@dastard>
References: <1334319061-12968-1-git-send-email-david@fromorbit.com>
	<1334319061-12968-4-git-send-email-david@fromorbit.com>
	<20120417212155.GA16881@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120417212155.GA16881@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Apr 17, 2012 at 04:21:55PM -0500, Ben Myers wrote:
> On Fri, Apr 13, 2012 at 10:10:46PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Doing background CIL flushes adds significant latency to whatever
> > async transaction that triggers it. To avoid blocking async
> > transactions on things like waiting for log buffer IO to complete,
> > move the CIL push off into a workqueue.  By moving the push work
> > into a workqueue, we remove all the latency that the commit adds
> > from the foreground transaction commit path. This also means that
> > single threaded workloads won't do the CIL push procssing, leaving
> > them more CPU to do more async transactions.
> > 
> > To do this, we need to keep track of the sequence number we have
> > pushed work for. This avoids having many transaction commits
> > attempting to schedule work for the same sequence, and ensures that
> > we only ever have one push (background or forced) in progress at a
> > time. It also means that we don't need to take the CIL lock in write
> > mode to check for potential background push races, which reduces
> > lock contention.
> > 
> > To avoid potential issues with "smart" IO schedulers, don't use the
> > workqueue for log force triggered flushes. Instead, do them directly
> > so that the log IO is done directly by the process issuing the log
> > force and so doesn't get stuck on IO elevator queue idling
> > incorrectly delaying the log IO from the workqueue.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
.....
> Gah! I just hit this assert.  
> 
> v3.4-rc2-3-g8a00ebe with:
> Christoph's ilock series
> Christoph's xfsbufd series
> Jan's freeze series
> Dave's queue.
> 
> nfs7 login: [ 1175.172406] XFS: Assertion failed: push_seq > 0 && push_seq <= ctx->sequence, file: /root/xfs/fs/xfs/xfs_log_cil.c, line: 406
> [ 1175.183766] ------------[ cut here ]------------
> [ 1175.188010] kernel BUG at /root/xfs/fs/xfs/xfs_message.c:101!
> [ 1175.188010] invalid opcode: 0000 [#1] PREEMPT SMP 
> [ 1175.188010] Modules linked in: xfs(O) exportfs af_packet dm_mod floppy iTCO_wdt sg i2c_i801 iTCO_vendor_support e7xxx_edac edac_core sr_mod e100 cdrom e1000 shpchp pci_hotplug button serio_raw pcspkr autofs4 processor thermal_sys ata_generic
> [ 1175.188010] 
> [ 1175.188010] Pid: 2760, comm: kworker/3:2 Tainted: G           O 3.4.0-rc2-1.2-desktop+ #15 TYAN Computer Corp. S2721-533 Thunder i7501 Pro/S2721-533 Thunder i7501 Pro
> [ 1175.188010] EIP: 0060:[<faa4f966>] EFLAGS: 00010296 CPU: 3
> [ 1175.188010] EIP is at assfail+0x26/0x30 [xfs]
> [ 1175.188010] EAX: 00000087 EBX: f1f10980 ECX: 00000079 EDX: 00000046
> [ 1175.188010] ESI: f1f10780 EDI: 00000000 EBP: f1d93ec4 ESP: f1d93eb0
> [ 1175.188010]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> [ 1175.188010] CR0: 8005003b CR2: b770ee20 CR3: 2779c000 CR4: 000007f0
> [ 1175.188010] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> [ 1175.188010] DR6: ffff0ff0 DR7: 00000400

Ah, that's a 32 bit machine. The sequence numbers are 64 bit values
- I wonder if there's an issue with reading/writing
xc_current_sequence without a spinlock held...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
