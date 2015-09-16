Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8A54B7F37
	for <xfs@oss.sgi.com>; Wed, 16 Sep 2015 05:50:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 663968F8037
	for <xfs@oss.sgi.com>; Wed, 16 Sep 2015 03:50:26 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ycNIrhD4EjKhvG24 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 16 Sep 2015 03:50:25 -0700 (PDT)
Date: Wed, 16 Sep 2015 06:50:23 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: rm Tainted warning after kernel update.
Message-ID: <20150916105022.GA37016@bfoster.bfoster>
References: <55F718A1.10801@sonic.com> <20150915110042.GA21323@bfoster.bfoster>
	<55F89C76.4090808@sonic.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <55F89C76.4090808@sonic.com>
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
To: Grant Keller <grant.keller@sonic.com>
Cc: lczerner@redhat.com, xfs@oss.sgi.com

cc Lukas

On Tue, Sep 15, 2015 at 03:32:22PM -0700, Grant Keller wrote:
> On 09/15/2015 04:00 AM, Brian Foster wrote:
> > On Mon, Sep 14, 2015 at 11:57:37AM -0700, Grant Keller wrote:
> >> Hello,
> >>
> >> I have a server running Scientific Linux 6.7, and since updating to
> >> kernel 2.6.32-573.3.1.el6.x86_64 the following error has begun appearing
> >> in our message logs:
> >>
> >> Sep 14 11:43:03 localhost kernel: ------------[ cut here ]------------
> >> Sep 14 11:43:03 localhost kernel: WARNING: at fs/dcache.c:758
> >> d_delete+0x260/0x2c0() (Tainted: G        W  -- ------------   )
> >> Sep 14 11:43:03 localhost kernel: Hardware name: X7DB8
> >> Sep 14 11:43:03 localhost kernel: Modules linked in: nfsd nfs_acl
> >> auth_rpcgss autofs4 lockd sunrpc p4_clockmod freq_table speedstep_lib
> >> nf_conntrack_ftp iptable_mangle xt_comment nf_conntrack_ipv4
> >> nf_defrag_ipv4 xt_multiport iptable_filter ip_tables ip6t_REJECT
> >> nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter
> >> ip6_tables ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm
> >> iw_cm ib_sa ib_mad ib_core ib_addr ipv6 xfs exportfs ppdev parport_pc
> >> parport sg e1000e microcode serio_raw iTCO_wdt iTCO_vendor_support ixgbe
> >> ptp pps_core mdio i2c_i801 lpc_ich mfd_core i5000_edac edac_core i5k_amb
> >> ioatdma dca shpchp ext4 jbd2 mbcache sd_mod crc_t10dif 3w_9xxx pata_acpi
> >> ata_generic ata_piix radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core
> >> dm_mirror dm_region_hash dm_log dm_mod [last unloaded: ipmi_msghandler]
> >> Sep 14 11:43:03 localhost kernel: Pid: 15893, comm: rm Tainted: G       
> >> W  -- ------------    2.6.32-573.3.1.el6.x86_64 #1
> >> Sep 14 11:43:03 localhost kernel: Call Trace:
> >> Sep 14 11:43:03 localhost kernel: [<ffffffff81077491>] ?
> >> warn_slowpath_common+0x91/0xe0
> >> Sep 14 11:43:03 localhost kernel: [<ffffffff810774fa>] ?
> >> warn_slowpath_null+0x1a/0x20
> >> Sep 14 11:43:03 localhost kernel: [<ffffffff811ae660>] ?
> >> d_delete+0x260/0x2c0
> >> Sep 14 11:43:03 localhost kernel: [<ffffffff811a0908>] ? vfs_rmdir+0xe8/0xf0
> >> Sep 14 11:43:03 localhost kernel: [<ffffffff811a3b64>] ?
> >> do_rmdir+0x184/0x1f0
> >> Sep 14 11:43:03 localhost kernel: [<ffffffff81193511>] ? __fput+0x1a1/0x210
> >> Sep 14 11:43:03 localhost kernel: [<ffffffff810e8ab7>] ?
> >> audit_syscall_entry+0x1d7/0x200
> >> Sep 14 11:43:03 localhost kernel: [<ffffffff811a3bfd>] ?
> >> sys_unlinkat+0x2d/0x40
> >> Sep 14 11:43:03 localhost kernel: [<ffffffff8100b0d2>] ?
> >> system_call_fastpath+0x16/0x1b
> >> Sep 14 11:43:03 localhost kernel: ---[ end trace 6080ec4a7ec5ec25 ]---
> >>
> >> This happens when we are expiring older backups from the archives, so I
> >> have quite a few of these. We have xfsprogs 3.1.1-16.el6.x86_64
> >> installed. Looking for advice on how to proceed.
> >>
> > This looks like something funky going on in the vfs. The warning is from
> > unhash_offsprings() and it appears to be complaining about a refcount on
> > a dentry that is a child of a directory being removed. It checks a
> > refcount on a dentry in one loop and either drops it or moves it to
> > another list for apparent deletion. The second iteration of the
> > aforementioned list sees a refcount on an object that wasn't there
> > before.
> >
> > I suspect this means something is going from 0->1 unexpectedly, but I'm
> > not familiar enough with that code to grok why that shouldn't happen and
> > how it could without reproducing it and digging into it from there. Have
> > you identified an explicit reproducer? I assume files are simply being
> > removed with 'rm -rf' here..? If so, does anything else have access to
> > this directory structure (e.g., separate commands, a running backup
> > application?) at the the time of removal.
> There could be something else running, but I would have to investigate
> the next time this happens. The rm -rf is called by our backup program
> expiring older backups from the filesystem.  The thing is, the
> expirations happen on a nightly basis, but we don't always see these
> warnings in the logs. On the nights we do, there are 1000+ warnings.
> >
> > Also, what kernel were you running before this started to occur?
>  2.6.32-573.el6.x86_64 was the previous kernel.

Interesting... there are only a few fs changes between this kernel and
the current. One of them is this:

  959c503 [fs] vfs: Unhash and evict unused children dentries after rmdir

... which actually introduces the unhash_offsprings() thing. I've cc'd
Lukas who is probably more familiar with this code.

FWIW, I suspect the more you can elaborate on what the backup
application might be doing here (beyond just the rm -rf), the more
likely this can be reproduced and resolved.

Brian

> >
> > Brian
> >
> >
> 
> -- 
> Grant Keller
> System Operations
> 707-237-2451
> grant.keller@sonic.com
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
