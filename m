Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 34F4D7CA0
	for <xfs@oss.sgi.com>; Tue,  1 Mar 2016 02:01:12 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EA846304043
	for <xfs@oss.sgi.com>; Tue,  1 Mar 2016 00:01:11 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id r5IO0qB7CTPwusl9 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 01 Mar 2016 00:01:08 -0800 (PST)
Date: Tue, 1 Mar 2016 16:00:57 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: generic/320 triggers "list_add attempted on force-poisoned
	entry" warning on XFS
Message-ID: <20160301080057.GL11419@eguan.usersys.redhat.com>
References: <20160227130256.GJ11419@eguan.usersys.redhat.com>
	<CAPcyv4gZKzUsch2RQm-QQWuUHtmtQerz2fstCwbwaMjyzYvwrA@mail.gmail.com>
	<20160228053158.GK11419@eguan.usersys.redhat.com>
	<CAPcyv4jNhCkStvwtS54FjJVWAfvMv-gEDjHWq3V7_YTOmk+W2g@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4jNhCkStvwtS54FjJVWAfvMv-gEDjHWq3V7_YTOmk+W2g@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, XFS Developers <xfs@oss.sgi.com>

On Mon, Feb 29, 2016 at 10:22:06AM -0800, Dan Williams wrote:
> On Sat, Feb 27, 2016 at 9:31 PM, Eryu Guan <eguan@redhat.com> wrote:
> > On Sat, Feb 27, 2016 at 12:10:51PM -0800, Dan Williams wrote:
> >> On Sat, Feb 27, 2016 at 5:02 AM, Eryu Guan <eguan@redhat.com> wrote:
> >> > Hi,
> >> >
> >> > Starting from 4.5-rc1 kernel, I sometimes see generic/320 triggers
> >> > "list_add attempted on force-poisoned entry" warnings on XFS, test hosts
> >> > are arm64/ppc64/ppc64le, haven't seen it on x86_64 hosts.
> >>
> >> Hmm, this triggers when a list_head has ->next or ->prev pointing at
> >> the address of force_poison which is only defined in lib/list_debug.c.
> >> The only call site that uses list_force_poison() is in
> >> devm_memremap_pages().  That currently depends on CONFIG_ZONE_DEVICE
> >> which in turn depends on X86_64.
> >>
> >> So, this appears to be a false positive and the address of
> >> force_poison is somehow ending up on the stack by accident as that is
> >> the random value being passed in from __down_common:
> >>
> >>     struct semaphore_waiter waiter;
> >>
> >>     list_add_tail(&waiter.list, &sem->wait_list);
> >>
> >> So, I think we need a more unique poison value that should never
> >> appear on the stack:
> >
> > Unfortunately I can still see the warning after applying this test patch.
> >
> > Then I added debug code to print the pointer value and re-ran the test.
> > All five failures printed the same pointer value, failed in the same
> > pattern:
> >
> > list_add attempted on force-poisoned entry(0000000000000500), new->next = c00000000136bc00, new->prev = 0000000000000500
> >
> 
> I think this means that no matter what we do the stack will pick up
> these poison values unless the list_head is explicitly initialized.
> Something like the following:

Umm, it's still reproducible... but seems harder than before, it took me
200+ iterations to hit (less than 10 iterations in previous runs)

[ 5465.401191] run fstests generic/320 at 2016-03-01 00:11:13
[ 5465.561754] XFS (sda5): Unmounting Filesystem
[ 5466.202130] XFS (sda5): Mounting V4 Filesystem
[ 5466.260396] XFS (sda5): Ending clean mount
[ 5482.629036] list_add attempted on force-poisoned entry(0000000000000500), new->next == d0000000059ecdb0, new->prev == 0000000000000500
[ 5482.629070] ------------[ cut here ]------------
[ 5482.629077] WARNING: at lib/list_debug.c:33
[ 5482.629082] Modules linked in: pseries_rng(E) sg(E) nfsd(E) auth_rpcgss(E) nfs_acl(E) lockd(E) sunrpc(E) grace(E) ip_tables(E) xfs(E) libcrc32c(E) sd_mod(E) ibmvscsi(E) scsi_transport_srp(E) ibmveth(E)
[ 5482.629121] CPU: 4 PID: 7203 Comm: rm Tainted: G            E   4.5.0-rc5+ #4
[ 5482.629129] task: c0000005f0712d00 ti: c0000004c749c000 task.ti: c0000004c749c000
[ 5482.629136] NIP: c00000000042db78 LR: c00000000042db74 CTR: 00000000013abb8c
[ 5482.629144] REGS: c0000004c749f3a0 TRAP: 0700   Tainted: G            E    (4.5.0-rc5+)
[ 5482.629150] MSR: 8000000100029032 <SF,EE,ME,IR,DR,RI,TM[E]>  CR: 22002822  XER: 0000000b
[ 5482.629173] CFAR: c00000000080a5e4 SOFTE: 0
GPR00: c00000000042db74 c0000004c749f620 c00000000136bc00 000000000000007a
GPR04: c0000005ffc09c58 c0000005ffc1b490 000005cf29ac0100 0000000000000000
GPR08: 0000000000000000 c000000000c3b27c 00000005fefd0000 0000000000000f97
GPR12: 0000000042002844 c00000000e822400 0000000000000002 0000000000000000
GPR16: 000000001000da78 000000001000d758 0000010018009cd0 000000001000dab8
GPR20: 0000000000000001 c0000004c749f960 c0000005f5931e00 c0000005f5931e80
GPR24: c0000000fd01c000 c0000000fbe0a400 fffffffffffff000 0000000000000000
GPR28: c0000005ea59f938 c0000005f5931e88 c0000005f1f6b890 c0000004c749f720
[ 5482.629270] NIP [c00000000042db78] .__list_add+0xa8/0x140
[ 5482.629277] LR [c00000000042db74] .__list_add+0xa4/0x140
[ 5482.629282] Call Trace:
[ 5482.629288] [c0000004c749f620] [c00000000042db74] .__list_add+0xa4/0x140 (unreliable)
[ 5482.629299] [c0000004c749f6b0] [c0000000008010ec] .rwsem_down_read_failed+0x6c/0x1a0
[ 5482.629310] [c0000004c749f760] [c000000000800828] .down_read+0x58/0x60
[ 5482.629396] [c0000004c749f7e0] [d000000005a1a6bc] .xfs_log_commit_cil+0x7c/0x600 [xfs]
[ 5482.629482] [c0000004c749f8f0] [d000000005a12848] .__xfs_trans_commit+0x178/0x300 [xfs]
[ 5482.629567] [c0000004c749f990] [d000000005a12f14] .__xfs_trans_roll+0x74/0x130 [xfs]
[ 5482.629653] [c0000004c749fa30] [d0000000059e8994] .xfs_bmap_finish+0xd4/0x1e0 [xfs]
[ 5482.629738] [c0000004c749fae0] [d000000005a06acc] .xfs_inactive_ifree+0x20c/0x2a0 [xfs]
[ 5482.629830] [c0000004c749fb90] [d000000005a06c14] .xfs_inactive+0xb4/0x190 [xfs]
[ 5482.629913] [c0000004c749fc10] [d000000005a0d8f8] .xfs_fs_evict_inode+0xd8/0x170 [xfs]
[ 5482.629923] [c0000004c749fca0] [c0000000002b60d8] .evict+0xe8/0x220
[ 5482.629932] [c0000004c749fd30] [c0000000002a9278] .do_unlinkat+0x248/0x360
[ 5482.629942] [c0000004c749fe30] [c000000000009204] system_call+0x38/0xb4
[ 5482.629948] Instruction dump:
[ 5482.629953] e8010010 eba1ffe8 ebc1fff0 ebe1fff8 7c0803a6 4e800020 3c62ff77 38800500
[ 5482.629969] 38632550 7d254b78 483dca15 60000000 <0fe00000> 4bffff90 3c62ff77 7fe4fb78
[ 5482.629985] ---[ end trace 71e305f825b24cc9 ]---

Thanks,
Eryu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
