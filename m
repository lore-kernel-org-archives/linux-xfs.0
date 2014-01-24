Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5F0A57F84
	for <xfs@oss.sgi.com>; Fri, 24 Jan 2014 16:39:36 -0600 (CST)
Date: Fri, 24 Jan 2014 16:39:36 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: assert in xfs_log_commit_cil
Message-ID: <20140124223936.GX26064@sgi.com>
References: <20140124193702.GM26064@sgi.com> <20140124222017.GB26397@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140124222017.GB26397@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Sat, Jan 25, 2014 at 09:20:17AM +1100, Dave Chinner wrote:
> On Fri, Jan 24, 2014 at 01:37:02PM -0600, Ben Myers wrote:
> > Hi Folks,
> > 
> > I hit this assertion on one of my test boxes today:
> > 
> > [1167966.151275] XFS: Assertion failed: !list_empty(&cil->xc_cil), file: /root/xfs/fs/xfs/xfs_log_cil.c, line: 636
> 
> I suppose that can happen if we are committing a transaction that
> has no dirty objects in it. But that can't happen from
> xfs_setfilesize(). That implies memory corruption or that someone has
> busted rwsem behaviour.
> 
> > [1167966.162659] ------------[ cut here ]------------
> > [1167966.168021] kernel BUG at /root/xfs/fs/xfs/xfs_message.c:107!
> > [1167966.168026] invalid opcode: 0000 [#4] SMP
> > [1167966.168081] Modules linked in: xfs(OF) ext2(F) dm_flakey(F) crc32c(F) libcrc32c(F) autofs4(F) cpufreq_conservative(F) cpufreq_userspace(F) cpufreq_powersave(F) microcode(F) fuse(F) loop(F) dm_mod(F) joydev(F) hid_generic(F) usbhid(F) hid(F) ehci_pci(F) ehci_hcd(F) iTCO_wdt(F) iTCO_vendor_support(F) ipv6(F) usbcore(F) sg(F) igb(F) isci(F) sr_mod(F) pcspkr(F) mptctl(F) cdrom(F) libsas(F) usb_common(F) ioatdma(F) ptp(F) i2c_i801(F) lpc_ich(F) mfd_core(F) pps_core(F) dca(F) rtc_cmos(F) acpi_cpufreq(F) wmi(F) button(F) mgag200(F) ttm(F) drm_kms_helper(F) drm(F) i2c_algo_bit(F) sysimgblt(F) sysfillrect(F) i2c_core(F) syscopyarea(F) sd_mod(F) crc_t10dif(F) crct10dif_common(F) mpt2sas(F) raid_class(F) scsi_dh_emc(F) scsi_dh_rdac(F) scsi_dh_alua(F) scsi_dh_hp_sw(F) scsi_dh(F) thermal(F) sata_nv(F) processor(F) piix(F) mptsas(F) mptscsih(F) scsi_transport_sas(F) mptbase(F) megaraid_sas(F) ide_generic(F) ide_core(F) fan(F) thermal_sys(F) hwmon(F) ext3(F) jbd(F) mbcache(F) edd(F
 ) at
> >  a_piix(F) ahci(F) libahci(F) libata(F) scsi_mod(F) [last unloaded: scsi_debug]
> > [1167966.168102] CPU: 10 PID: 13005 Comm: kworker/10:3 Tainted: GF     D   IO 3.13.0-rc2-0.9-default #28
> 
> That's a rather heavily tainted kernel you are testing there. It's
> got forced module loads, TAINT_DIE which means this isn't the first
> oops the kernel has had, TAINT_FIRMWARE_WORKAROUND which means the
> hardware has bios/errata issues that need fixing, and you're
> building and using out-of-tree modules that are force loaded so
> there's no guarantee that all kernel/module ABIs match precisely....
> 
> The key one is that TAINT_DIE is already set. Something has already
> paniced on the machine, and once that happens all bets are off. Can
> you reproduce this on a clean, untainted kernel?

I'll give it a try...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
