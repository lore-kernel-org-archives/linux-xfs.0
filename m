Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 424F67F53
	for <xfs@oss.sgi.com>; Sun, 20 Jul 2014 19:04:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D3778AC001
	for <xfs@oss.sgi.com>; Sun, 20 Jul 2014 17:04:23 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	x5uFBCyxAptv0C3d for <xfs@oss.sgi.com>;
	Sun, 20 Jul 2014 17:04:18 -0700 (PDT)
Date: Mon, 21 Jul 2014 10:04:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: assert in xfs_log_commit_cil
Message-ID: <20140721000415.GI20518@dastard>
References: <20140124193702.GM26064@sgi.com> <20140124222017.GB26397@dastard>
	<20140719210245.GL17283@slnx.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140719210245.GL17283@slnx.de>
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
To: Andre Noll <maan@systemlinux.org>
Cc: Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com

On Sat, Jul 19, 2014 at 11:02:45PM +0200, Andre Noll wrote:
> On Sat, Jan 25, 09:20, Dave Chinner wrote:
> > > I hit this assertion on one of my test boxes today:
> > > 
> > > [1167966.151275] XFS: Assertion failed: !list_empty(&cil->xc_cil), file: /root/xfs/fs/xfs/xfs_log_cil.c, line: 636
> > 
> > I suppose that can happen if we are committing a transaction that
> > has no dirty objects in it. But that can't happen from
> > xfs_setfilesize(). That implies memory corruption or that someone has
> > busted rwsem behaviour.
> > 
> > > [1167966.162659] ------------[ cut here ]------------
> > > [1167966.168021] kernel BUG at /root/xfs/fs/xfs/xfs_message.c:107!
> > > [1167966.168026] invalid opcode: 0000 [#4] SMP
> > > [1167966.168081] Modules linked in: xfs(OF) ext2(F) dm_flakey(F) crc32c(F) libcrc32c(F) autofs4(F) cpufreq_conservative(F) cpufreq_userspace(F) cpufreq_powersave(F) microcode(F) fuse(F) loop(F) dm_mod(F) joydev(F) hid_generic(F) usbhid(F) hid(F) ehci_pci(F) ehci_hcd(F) iTCO_wdt(F) iTCO_vendor_support(F) ipv6(F) usbcore(F) sg(F) igb(F) isci(F) sr_mod(F) pcspkr(F) mptctl(F) cdrom(F) libsas(F) usb_common(F) ioatdma(F) ptp(F) i2c_i801(F) lpc_ich(F) mfd_core(F) pps_core(F) dca(F) rtc_cmos(F) acpi_cpufreq(F) wmi(F) button(F) mgag200(F) ttm(F) drm_kms_helper(F) drm(F) i2c_algo_bit(F) sysimgblt(F) sysfillrect(F) i2c_core(F) syscopyarea(F) sd_mod(F) crc_t10dif(F) crct10dif_common(F) mpt2sas(F) raid_class(F) scsi_dh_emc(F) scsi_dh_rdac(F) scsi_dh_alua(F) scsi_dh_hp_sw(F) scsi_dh(F) thermal(F) sata_nv(F) processor(F) piix(F) mptsas(F) mptscsih(F) scsi_transport_sas(F) mptbase(F) megaraid_sas(F) ide_generic(F) ide_core(F) fan(F) thermal_sys(F) hwmon(F) ext3(F) jbd(F) mbcache(F) edd
 (F) 
> >  at
> > >  a_piix(F) ahci(F) libahci(F) libata(F) scsi_mod(F) [last unloaded: scsi_debug]
> > > [1167966.168102] CPU: 10 PID: 13005 Comm: kworker/10:3 Tainted: GF     D   IO 3.13.0-rc2-0.9-default #28
> > 
> > That's a rather heavily tainted kernel you are testing there.
> 
> FWIW, I'm also seeing this on an untainted 3.14.11 kernel:
> 
> [95004.073063] XFS: Assertion failed: !list_empty(&cil->xc_cil), file: fs/xfs/xfs_log_cil.c, line: 647
> [95004.073068] ------------[ cut here ]------------
> [95004.073079] WARNING: CPU: 5 PID: 13368 at fs/xfs/xfs_message.c:99 xfs_log_commit_cil+0x371/0x5a0()
> [95004.073081] Modules linked in: af_packet
> [95004.073087] CPU: 5 PID: 13368 Comm: kworker/5:4 Not tainted 3.14.11 #18
> [95004.073088] Hardware name: Supermicro H8DG6/H8DGi/H8DG6/H8DGi, BIOS 2.0b       03/01/2012
> [95004.073094] Workqueue: xfs-data/dm-1 xfs_end_io
> [95004.073096]  0000000000000000 ffffffff81760b6c ffffffff815b37a1 0000000000000000
> [95004.073098]  ffffffff8103c3f2 ffff880fe098b900 ffff881e6fcb0d00 ffff880fe098b900
> [95004.073100]  ffff881e6fcb0dd8 ffff8823bc512600 ffffffff81262db1 0000000000000000
> [95004.073103] Call Trace:
> [95004.073110]  [<ffffffff815b37a1>] ? dump_stack+0x41/0x51
> [95004.073114]  [<ffffffff8103c3f2>] ? warn_slowpath_common+0x82/0xb0
> [95004.073117]  [<ffffffff81262db1>] ? xfs_log_commit_cil+0x371/0x5a0
> [95004.073120]  [<ffffffff8121687b>] ? xfs_trans_commit+0xcb/0x2c0
> [95004.073123]  [<ffffffff811f8c9c>] ? xfs_end_io+0x6c/0xe0
> [95004.073126]  [<ffffffff8105138e>] ? process_one_work+0x13e/0x3b0
> [95004.073129]  [<ffffffff81051e39>] ? worker_thread+0x109/0x350
> [95004.073131]  [<ffffffff81051d30>] ? manage_workers.isra.28+0x2c0/0x2c0
> [95004.073134]  [<ffffffff81057f0c>] ? kthread+0xbc/0xe0
> [95004.073136]  [<ffffffff81057e50>] ? kthread_freezable_should_stop+0x60/0x60
> [95004.073139]  [<ffffffff815b92fc>] ? ret_from_fork+0x7c/0xb0
> [95004.073141]  [<ffffffff81057e50>] ? kthread_freezable_should_stop+0x60/0x60
> [95004.073142] ---[ end trace b591fe6842af909e ]---
> 
> Any hints?

More information required.

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
