Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8155F7CA6
	for <xfs@oss.sgi.com>; Sun, 22 May 2016 16:39:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DE39DAC002
	for <xfs@oss.sgi.com>; Sun, 22 May 2016 14:38:57 -0700 (PDT)
Date: Mon, 23 May 2016 07:38:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs trace in 4.4.2 / also in 4.3.3 WARNING
	fs/xfs/xfs_aops.c:1232 xfs_vm_releasepage
Message-ID: <20160522213850.GE26977@dastard>
References: <20160324122417.GB4068@bfoster.bfoster> <57332508.307@profihost.ag>
	<20160511133417.GA42410@bfoster.bfoster>
	<57333BA4.4040402@profihost.ag>
	<20160511155951.GF42410@bfoster.bfoster>
	<5738576B.4010208@profihost.ag>
	<20160515115017.GA6433@laptop.bfoster>
	<57386E84.3090606@profihost.ag>
	<20160516010602.GA24980@bfoster.bfoster>
	<57420A47.2000700@profihost.ag>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <57420A47.2000700@profihost.ag>
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
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: "xfs-masters@oss.sgi.com" <xfs-masters@oss.sgi.com>, Brian Foster <bfoster@redhat.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Sun, May 22, 2016 at 09:36:39PM +0200, Stefan Priebe - Profihost AG wrote:
> Am 16.05.2016 um 03:06 schrieb Brian Foster:
> >> sd_mod ehci_pci ehci_hcd usbcore usb_common igb ahci i2c_algo_bit libahci
> >> i2c_core ptp mpt3sas pps_core raid_class scsi_transport_sas
> >> [Sun May 15 07:00:44 2016] CPU: 2 PID: 108 Comm: kswapd0 Tainted: G       O
> >> 4.4.10+25-ph #1
> > 
> > How close is this to an upstream kernel? Upstream XFS? Have you tried to
> > reproduce this on an upstream kernel?
> 
> It's a vanilla 4.4.10 + a new adaptec driver and some sched and wq
> patches from 4.5 and 4.6 but i can try to replace the kernel on one
> machine with a 100% vanilla one if this helps.

Please do.

> >> [295086.353473] XFS (md127p3): ino 0x600204f delalloc 1 unwritten 0 pgoff
> >> 0x52000 size 0x13d1c8
> >> [295086.353476] XFS (md127p3): ino 0x600204f delalloc 1 unwritten 0 pgoff
> >> 0x53000 size 0x13d1c8
> >> [295086.353478] XFS (md127p3): ino 0x600204f delalloc 1 unwritten 0 pgoff
> >> 0x54000 size 0x13d1c8
> > ...
> >> [295086.567508] XFS (md127p3): ino 0x600204f delalloc 1 unwritten 0 pgoff
> >> 0xab000 size 0x13d1c8
> >> [295086.567510] XFS (md127p3): ino 0x600204f delalloc 1 unwritten 0 pgoff
> >> 0xac000 size 0x13d1c8
> >> [295086.567515] XFS (md127p3): ino 0x600204f delalloc 1 unwritten 0 pgoff
> >> 0xad000 size 0x13d1c8
> >>
> >> The file to the inode number is:
> >> /var/lib/apt/lists/security.debian.org_dists_wheezy_updates_main_i18n_Translation-en
> >>
> > 
> > xfs_bmap -v might be interesting here as well.
> 
> # xfs_bmap -v
> /var/lib/apt/lists/security.debian.org_dists_wheezy_updates_main_i18n_Translation-en
> /var/lib/apt/lists/security.debian.org_dists_wheezy_updates_main_i18n_Translation-en:
>  EXT: FILE-OFFSET      BLOCK-RANGE        AG AG-OFFSET        TOTAL
>    0: [0..2567]:       41268928..41271495  3 (374464..377031)  2568

So the last file offset with a block is 0x140e00. This means the
file is fully allocated. However, the pages inside the file range
are still marked delayed allocation. That implies that we've failed
to write the pages over a delayed allocation region after we've
allocated the space.

That, in turn, tends to indicate a problem in page writeback - the
first page to be written has triggered delayed allocation of the
entire range, but then the subsequent pages have not been written
(for some as yet unknown reason). When a page is written, we map it
to the current block via xfs_map_at_offset(), and that clears both
the buffer delay and unwritten flags.

This clearly isn't happening which means either the VFS doesn't
think the inode is dirty anymore, writeback is never asking for
these pages to be written, or XFs is screwing something up in
->writepage. The XFS writepage code changed significantly in 4.6, so
it might be worth seeing if a 4.6 kernel reproduces this same
problem....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
