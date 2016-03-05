Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9A13B7F5D
	for <xfs@oss.sgi.com>; Sat,  5 Mar 2016 16:49:01 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 01D42AC003
	for <xfs@oss.sgi.com>; Sat,  5 Mar 2016 14:48:57 -0800 (PST)
Date: Sun, 6 Mar 2016 09:48:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs trace in 4.4.2 / also in 4.3.3 WARNING
	fs/xfs/xfs_aops.c:1232 xfs_vm_releasepage
Message-ID: <20160305224845.GR30721@dastard>
References: <56C81D94.7090603@profihost.ag>
	<20160220144533.GA36182@bfoster.bfoster>
	<B833B258-1140-464C-94CD-09B840BD4220@profihost.ag>
	<56D9D834.2000303@profihost.ag>
	<20160304191329.GC3758@bfoster.bfoster>
	<56D9E9BE.40101@profihost.ag>
	<20160304210341.GA8035@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160304210341.GA8035@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, "xfs-masters@oss.sgi.com" <xfs-masters@oss.sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, Stefan Priebe <s.priebe@profihost.ag>

On Fri, Mar 04, 2016 at 04:03:42PM -0500, Brian Foster wrote:
> On Fri, Mar 04, 2016 at 09:02:06PM +0100, Stefan Priebe wrote:
> > Am 04.03.2016 um 20:13 schrieb Brian Foster:
> > >On Fri, Mar 04, 2016 at 07:47:16PM +0100, Stefan Priebe wrote:
> > >>Am 20.02.2016 um 19:02 schrieb Stefan Priebe - Profihost AG:
> > >>>
> > >>>>Am 20.02.2016 um 15:45 schrieb Brian Foster <bfoster@redhat.com>:
> > >>>>
> > >>>>>On Sat, Feb 20, 2016 at 09:02:28AM +0100, Stefan Priebe wrote:
> > >>>>>Hi,
> > >>>>>
> > >>>>>got this one today. Not sure if this is a bug.
> > >>>>
> > >>>>That looks like the releasepage() delayed allocation block warning. I'm
> > >>>>not sure we've had any fixes for (or reports of) that issue since the
> > >>>>v4.2 timeframe.
> > >>>>
> > >>>>What is the xfs_info of the associated filesystem? Also, do you have any
> > >>>>insight as to the possible reproducer application or workload? Is this
> > >>>>reproducible at all? Note that this is a WARN_ON_ONCE(), so the warning
> > >>>>won't fire again regardless until after a reboot.
> > >>
> > >>Toda i got this one running 4.3.3.
> > >>
> > >>[154152.949610] ------------[ cut here ]------------
> > >>[154152.950704] WARNING: CPU: 0 PID: 79 at fs/xfs/xfs_aops.c:1232
> > >>xfs_vm_releasepage+0xc3/0xf0()
> > >>[154152.952596] Modules linked in: netconsole mpt3sas raid_class
> > >>nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack xt_tcpudp ipt_REJECT
> > >>nf_reject_ipv4 xt_owner xt_multiport iptable_filter ip_tables x_tables 8021q
> > >>garp coretemp k8temp ehci_pci ehci_hcd sb_edac ipmi_si usbcore edac_core
> > >>ipmi_msghandler i2c_i801 usb_common button btrfs xor raid6_pq sg igb sd_mod
> > >>i2c_algo_bit isci i2c_core libsas ahci ptp libahci scsi_transport_sas
> > >>megaraid_sas pps_core
> > >>[154152.963240] CPU: 0 PID: 79 Comm: kswapd0 Not tainted 4.4.3+3-ph #1
> > >>[154152.964625] Hardware name: Supermicro
> > >>X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SRE/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 1.0a
> > >>03/06/2012
> > >>[154152.967029]  0000000000000000 ffff88103dd67a98 ffffffffa73c3b5f
> > >>0000000000000000
> > >>[154152.968836]  ffffffffa7a5063b ffff88103dd67ad8 ffffffffa7083757
> > >>0000000000000000
> > >>[154152.970641]  0000000000000001 ffffea0001e7bfc0 ffff88071ef72dd0
> > >>ffffea0001e7bfe0
> > >>[154152.972447] Call Trace:
> > >>[154152.973011]  [<ffffffffa73c3b5f>] dump_stack+0x63/0x84
> > >>[154152.974167]  [<ffffffffa7083757>] warn_slowpath_common+0x97/0xe0
> > >>[154152.975515]  [<ffffffffa70837ba>] warn_slowpath_null+0x1a/0x20
> > >>[154152.976826]  [<ffffffffa7324f23>] xfs_vm_releasepage+0xc3/0xf0
> > >>[154152.978137]  [<ffffffffa71510b2>] try_to_release_page+0x32/0x50
> > >>[154152.979467]  [<ffffffffa71659be>] shrink_active_list+0x3ce/0x3e0
> > >>[154152.980816]  [<ffffffffa7166057>] shrink_lruvec+0x687/0x7d0
> > >>[154152.982068]  [<ffffffffa716627c>] shrink_zone+0xdc/0x2c0
> > >>[154152.983262]  [<ffffffffa7167399>] kswapd+0x4f9/0x970
> > >>[154152.984380]  [<ffffffffa7166ea0>] ?
> > >>mem_cgroup_shrink_node_zone+0x1a0/0x1a0
> > >>[154152.985942]  [<ffffffffa70a0ac9>] kthread+0xc9/0xe0
> > >>[154152.987040]  [<ffffffffa70a0a00>] ? kthread_stop+0x100/0x100
> > >>[154152.988313]  [<ffffffffa76b03cf>] ret_from_fork+0x3f/0x70
> > >>[154152.989527]  [<ffffffffa70a0a00>] ? kthread_stop+0x100/0x100
> > >>[154152.990818] ---[ end trace 3fac2515e92c7cb1 ]---
> > >>
> > >>This time with an xfs info:
> > >># xfs_info /
> > >>meta-data=/dev/disk/by-uuid/9befe321-e9cc-4e31-82df-efabb3211bac isize=256
> > >>agcount=4, agsize=58224256 blks
> > >>          =                       sectsz=512   attr=2, projid32bit=0
> > >>          =                       crc=0        finobt=0
> > >>data     =                       bsize=4096   blocks=232897024, imaxpct=25
> > >>          =                       sunit=64     swidth=384 blks
> > >>naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
> > >>log      =internal               bsize=4096   blocks=113728, version=2
> > >>          =                       sectsz=512   sunit=64 blks, lazy-count=1
> > >>realtime =none                   extsz=4096   blocks=0, rtextents=0
> > >>
> > >
> > >Can you describe the workload to the filesystem?
> > 
> > At the time of this trace the rsync backup of the fs has started. So the
> > workload was going from nearly idle to 4000 iop/s read at 60 MB/s peak.
> > 
> 
> Interesting. The warning is associated with releasing a page that has a
> delayed allocation when it shouldn't. That means something had written
> to a file to cause the delalloc in the first place. Any idea what could
> have been writing at the time or shortly before the rsync read workload
> had kicked in?

It's memory reclaim that tripped over it, so the cause is long gone
- couple have been anything in the previous 24 hours that caused the
issue. i.e. rsync has triggered memory reclaim which triggered the
warning, but I don't think rsync has anything to do with causing the
page to be in a state that caused the warning.

I'd be interested to know if there are any other warnings in the
logs - stuff like IO errors, page discards, ENOSPC issues, etc that
could trigger less travelled write error paths...

-Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
