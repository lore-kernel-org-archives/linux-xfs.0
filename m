Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33513 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755583AbeAHSd7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Jan 2018 13:33:59 -0500
Date: Mon, 8 Jan 2018 19:33:53 +0100
From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH v4 19/19] fs: handle inode->i_version more efficiently
Message-ID: <20180108183353.emiwsd4aic4gmytr@kozik-lap>
References: <20171222120556.7435-1-jlayton@kernel.org>
 <20171222120556.7435-20-jlayton@kernel.org>
 <CAJKOXPd8ojTjiGF3nKQKWtVrEsjWfjvg6rLL+RGnbu_SZMDu7g@mail.gmail.com>
 <1515416208.3486.14.camel@kernel.org>
 <CAJKOXPfv4eSERDiUuZuJ7KdpyGU0=Eqt_A+J6knp-FEW9BZoSw@mail.gmail.com>
 <1515418164.3486.18.camel@kernel.org>
 <20180108172928.aqndozcpljb73uj6@kozik-lap>
 <1515434419.3486.41.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1515434419.3486.41.camel@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-nfs@vger.kernel.org, bfields@fieldses.org, neilb@suse.de, jack@suse.de, linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, david@fromorbit.com, linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-integrity@vger.kernel.org, zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com, linux-afs@lists.infradead.org, dhowells@redhat.com, jaltman@auristor.com, linux-samsung-soc@vger.kernel.org, Marek Szyprowski <m.szyprowski@samsung.com>, =?utf-8?Q?Bart=C5=82omiej_=C5=BBo=C5=82nierkiewicz?= <b.zolnierkie@samsung.com>, Sylwester Nawrocki <s.nawrocki@samsung.com>

On Mon, Jan 08, 2018 at 01:00:19PM -0500, Jeff Layton wrote:
> On Mon, 2018-01-08 at 18:29 +0100, Krzysztof Kozlowski wrote:

(...)

> > > Ok, thanks. If you're seeing hangs then that might imply that we have
> > > some sort of excessive looping going on in the cmpxchg loops.
> > > 
> > > Could you apply the patch below and let me know if it causes either of
> > > the warnings to pop? That might at least point us in the right
> > > direction:
> > 
> > No new warnings with attached patch (except existing already lockdep:
> > "INFO: trying to register non-static key.").
> > 
> 
> Yeah, I saw that in the original logs and it looks unrelated (and
> harmless).
> 
> > Systemd timeouts on mounting /home but after entering rescue shell there
> > is no problem running mount /home:
> > 	Give root password for maintenance
> > 	(or press Control-D to continue): 
> > 	root@odroidxu3:~# mount /home
> > 	[  220.659331] EXT4-fs (mmcblk1p2): mounted filesystem with ordered data mode. Opts: (null)
> > 
> 
> Ok, thanks for testing it. So I guess we can probably rule out excessive
> looping in those functions as the issue.
> 
> To make sure I understand the problem: When systemd tries to do the
> initial mount of /home (which is an ext4 filesystem), it hangs. But once
> it drops to the shell, it works, if you do the mount by hand.
> 
> Is that correct?

Yes, although it also timeouts on setting up /dev/ttySAC2 (serial
console).

> If so, then is it possible to trigger sysrq commands during the hanging
> mount attempt? Maybe you could use e.g. sysrq-l, sysrq-w, etc. to
> determine what it's blocking on?

Yes, I have sysrq. Blocked state (w):
##################
[ ***  ] (2 of 4) A start job is running for…v-ttySAC2.device (1min / 1min 30s)
*** break sent ***
[***   ] (2 of 4) A start job is running for…v-ttySAC2.device (1min / 1min 30s)[  110.962917] sysrq: SysRq : Show Blocked State
[  110.965931]   task                PC stack   pid father
[  110.971360] lvm             D    0   219      1 0x00000000
[  110.976649] [<c087682c>] (__schedule) from [<c0876ca0>] (schedule+0x4c/0xac)
[  110.983643] [<c0876ca0>] (schedule) from [<c07ae19c>] (rpc_wait_bit_killable+0x2c/0xf0)
[  110.991621] [<c07ae19c>] (rpc_wait_bit_killable) from [<c0877328>] (__wait_on_bit+0x80/0xb4)
[  111.000025] [<c0877328>] (__wait_on_bit) from [<c08773e8>] (out_of_line_wait_on_bit+0x8c/0x94)
[  111.008603] [<c08773e8>] (out_of_line_wait_on_bit) from [<c07aec78>] (__rpc_execute+0x19c/0x274)
[  111.017370] [<c07aec78>] (__rpc_execute) from [<c07a5eb4>] (rpc_run_task+0x134/0x14c)
[  111.025164] [<c07a5eb4>] (rpc_run_task) from [<c0315b20>] (nfs4_call_sync_sequence+0x58/0x78)
[  111.033648] [<c0315b20>] (nfs4_call_sync_sequence) from [<c031c490>] (nfs4_proc_access+0xf4/0x12c)
[  111.042586] [<c031c490>] (nfs4_proc_access) from [<c02fe408>] (nfs_do_access+0x230/0x3e8)
[  111.050716] [<c02fe408>] (nfs_do_access) from [<c02fe88c>] (nfs_permission+0x2a0/0x2c0)
[  111.058694] [<c02fe88c>] (nfs_permission) from [<c0224aa4>] (link_path_walk+0x6c/0x508)
[  111.066658] [<c0224aa4>] (link_path_walk) from [<c0225030>] (path_lookupat+0x8c/0x1ec)
[  111.074541] [<c0225030>] (path_lookupat) from [<c02270fc>] (path_openat+0x770/0x964)
[  111.082253] [<c02270fc>] (path_openat) from [<c0227e78>] (do_filp_open+0x60/0xc4)
[  111.089711] [<c0227e78>] (do_filp_open) from [<c0215a14>] (do_sys_open+0x114/0x1c4)
[  111.097339] [<c0215a14>] (do_sys_open) from [<c0108880>] (ret_fast_syscall+0x0/0x28)
[  111.105036] udevadm         D    0   259      1 0x00000000
[  111.110482] [<c087682c>] (__schedule) from [<c0876ca0>] (schedule+0x4c/0xac)
[  111.117508] [<c0876ca0>] (schedule) from [<c07ae19c>] (rpc_wait_bit_killable+0x2c/0xf0)
[  111.125494] [<c07ae19c>] (rpc_wait_bit_killable) from [<c0877328>] (__wait_on_bit+0x80/0xb4)
[  111.133903] [<c0877328>] (__wait_on_bit) from [<c08773e8>] (out_of_line_wait_on_bit+0x8c/0x94)
[  111.142482] [<c08773e8>] (out_of_line_wait_on_bit) from [<c07aec78>] (__rpc_execute+0x19c/0x274)
[  111.151236] [<c07aec78>] (__rpc_execute) from [<c07a5eb4>] (rpc_run_task+0x134/0x14c)
[  111.159028] [<c07a5eb4>] (rpc_run_task) from [<c0315b20>] (nfs4_call_sync_sequence+0x58/0x78)
[  111.167523] [<c0315b20>] (nfs4_call_sync_sequence) from [<c031c68c>] (nfs4_proc_getattr+0xbc/0xe4)
[  111.176452] [<c031c68c>] (nfs4_proc_getattr) from [<c0303c90>] (__nfs_revalidate_inode+0x8c/0x130)
[  111.185378] [<c0303c90>] (__nfs_revalidate_inode) from [<c02fe758>] (nfs_permission+0x16c/0x2c0)
[  111.194132] [<c02fe758>] (nfs_permission) from [<c0224aa4>] (link_path_walk+0x6c/0x508)
[  111.202096] [<c0224aa4>] (link_path_walk) from [<c0225030>] (path_lookupat+0x8c/0x1ec)
[  111.209980] [<c0225030>] (path_lookupat) from [<c0227714>] (filename_lookup+0x8c/0xe8)
[  111.217865] [<c0227714>] (filename_lookup) from [<c0215014>] (SyS_faccessat+0x9c/0x208)
[  111.225839] [<c0215014>] (SyS_faccessat) from [<c0108880>] (ret_fast_syscall+0x0/0x28)
[***   ] (3 of 4) A start job is running for…l-home.device (1min 2s / 1min 30s)
##################

Another blocked (after few seconds):
[  125.364311] sysrq: SysRq : Show Blocked State
[  125.367292]   task                PC stack   pid father
[  125.372688] udevadm         D    0   259      1 0x00000000
[  125.377998] [<c087682c>] (__schedule) from [<c0876ca0>] (schedule+0x4c/0xac)
[  125.384990] [<c0876ca0>] (schedule) from [<c07ae19c>] (rpc_wait_bit_killable+0x2c/0xf0)
[  125.392961] [<c07ae19c>] (rpc_wait_bit_killable) from [<c0877328>] (__wait_on_bit+0x80/0xb4)
[  125.401365] [<c0877328>] (__wait_on_bit) from [<c08773e8>] (out_of_line_wait_on_bit+0x8c/0x94)
[  125.409944] [<c08773e8>] (out_of_line_wait_on_bit) from [<c07aec78>] (__rpc_execute+0x19c/0x274)
[  125.418711] [<c07aec78>] (__rpc_execute) from [<c07a5eb4>] (rpc_run_task+0x134/0x14c)
[  125.426505] [<c07a5eb4>] (rpc_run_task) from [<c0315b20>] (nfs4_call_sync_sequence+0x58/0x78)
[  125.434989] [<c0315b20>] (nfs4_call_sync_sequence) from [<c031eab0>] (nfs4_proc_lookup_common+0x100/0x354)
[  125.444608] [<c031eab0>] (nfs4_proc_lookup_common) from [<c031edac>] (nfs4_proc_lookup+0x3c/0x88)
[  125.453456] [<c031edac>] (nfs4_proc_lookup) from [<c02ff46c>] (nfs_lookup_revalidate+0x224/0x35c)
[  125.462294] [<c02ff46c>] (nfs_lookup_revalidate) from [<c02233c4>] (lookup_fast+0x294/0x478)
[  125.470689] [<c02233c4>] (lookup_fast) from [<c02235d4>] (walk_component+0x2c/0x2e0)
[  125.478395] [<c02235d4>] (walk_component) from [<c0224bd4>] (link_path_walk+0x19c/0x508)
[  125.486455] [<c0224bd4>] (link_path_walk) from [<c0225030>] (path_lookupat+0x8c/0x1ec)
[  125.494342] [<c0225030>] (path_lookupat) from [<c0227714>] (filename_lookup+0x8c/0xe8)
[  125.502226] [<c0227714>] (filename_lookup) from [<c021d074>] (SyS_readlinkat+0x44/0xec)
[  125.510208] [<c021d074>] (SyS_readlinkat) from [<c0108880>] (ret_fast_syscall+0x0/0x28)
[    **] (3 of 4) A start job is running for…-home.device (1min 20s / 1min 30s)

##################

Another blocked (after few seconds):
[    **] (3 of 4) A start job is running for…-home.device (1min 26s / 1min 30s)[  136.281417] sysrq: SysRq : Show Blocked State
[  136.284403]   task                PC stack   pid father
[  136.289818] udevadm         D    0   259      1 0x00000000
[  136.295116] [<c087682c>] (__schedule) from [<c0876ca0>] (schedule+0x4c/0xac)
[  136.302105] [<c0876ca0>] (schedule) from [<c07ae19c>] (rpc_wait_bit_killable+0x2c/0xf0)
[  136.310079] [<c07ae19c>] (rpc_wait_bit_killable) from [<c0877328>] (__wait_on_bit+0x80/0xb4)
[  136.318484] [<c0877328>] (__wait_on_bit) from [<c08773e8>] (out_of_line_wait_on_bit+0x8c/0x94)
[  136.327064] [<c08773e8>] (out_of_line_wait_on_bit) from [<c07aec78>] (__rpc_execute+0x19c/0x274)
[  136.335830] [<c07aec78>] (__rpc_execute) from [<c07a5eb4>] (rpc_run_task+0x134/0x14c)
[  136.343625] [<c07a5eb4>] (rpc_run_task) from [<c0315b20>] (nfs4_call_sync_sequence+0x58/0x78)
[  136.352110] [<c0315b20>] (nfs4_call_sync_sequence) from [<c031eab0>] (nfs4_proc_lookup_common+0x100/0x354)
[  136.361729] [<c031eab0>] (nfs4_proc_lookup_common) from [<c031edac>] (nfs4_proc_lookup+0x3c/0x88)
[  136.370576] [<c031edac>] (nfs4_proc_lookup) from [<c02ff46c>] (nfs_lookup_revalidate+0x224/0x35c)
[  136.379416] [<c02ff46c>] (nfs_lookup_revalidate) from [<c02233c4>] (lookup_fast+0x294/0x478)
[  136.387809] [<c02233c4>] (lookup_fast) from [<c02235d4>] (walk_component+0x2c/0x2e0)
[  136.395514] [<c02235d4>] (walk_component) from [<c0224bd4>] (link_path_walk+0x19c/0x508)
[  136.403575] [<c0224bd4>] (link_path_walk) from [<c02269f4>] (path_openat+0x68/0x964)
[  136.411285] [<c02269f4>] (path_openat) from [<c0227e78>] (do_filp_open+0x60/0xc4)
[  136.418743] [<c0227e78>] (do_filp_open) from [<c0215a14>] (do_sys_open+0x114/0x1c4)
[  136.426372] [<c0215a14>] (do_sys_open) from [<c0108880>] (ret_fast_syscall+0x0/0x28)

##################


And list of all CPU backtraces (l):

*** break sent ***
[   87.197309] sysrq: SysRq : Show backtrace of all active CPUs
[   87.201610] NMI backtrace for cpu 0
[   87.205044] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.15.0-rc3-00022-g3da7bcdd695b #1101
[   87.213297] Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
[   87.219399] [<c01103a4>] (unwind_backtrace) from [<c010cac0>] (show_stack+0x10/0x14)
[   87.227098] [<c010cac0>] (show_stack) from [<c08620ac>] (dump_stack+0x98/0xc4)
[   87.234280] [<c08620ac>] (dump_stack) from [<c0868078>] (nmi_cpu_backtrace+0x10c/0x110)
[   87.242251] [<c0868078>] (nmi_cpu_backtrace) from [<c0868184>] (nmi_trigger_cpumask_backtrace+0x108/0x150)
[   87.251884] [<c0868184>] (nmi_trigger_cpumask_backtrace) from [<c041f384>] (__handle_sysrq+0x170/0x264)
[   87.261237] [<c041f384>] (__handle_sysrq) from [<c0439888>] (s3c24xx_serial_rx_drain_fifo+0x1ec/0x214)
[   87.270506] [<c0439888>] (s3c24xx_serial_rx_drain_fifo) from [<c043a6b8>] (s3c24xx_serial_rx_chars+0x6c/0x1a0)
[   87.280473] [<c043a6b8>] (s3c24xx_serial_rx_chars) from [<c043a834>] (s3c64xx_serial_handle_irq+0x48/0x60)
[   87.290104] [<c043a834>] (s3c64xx_serial_handle_irq) from [<c017ceb0>] (__handle_irq_event_percpu+0x9c/0x128)
[   87.299975] [<c017ceb0>] (__handle_irq_event_percpu) from [<c017cf58>] (handle_irq_event_percpu+0x1c/0x58)
[   87.309589] [<c017cf58>] (handle_irq_event_percpu) from [<c017cfcc>] (handle_irq_event+0x38/0x5c)
[   87.318425] [<c017cfcc>] (handle_irq_event) from [<c0180740>] (handle_fasteoi_irq+0xb8/0x174)
[   87.326914] [<c0180740>] (handle_fasteoi_irq) from [<c017c15c>] (generic_handle_irq+0x24/0x34)
[   87.335492] [<c017c15c>] (generic_handle_irq) from [<c017c714>] (__handle_domain_irq+0x7c/0xec)
[   87.344159] [<c017c714>] (__handle_domain_irq) from [<c0101544>] (gic_handle_irq+0x58/0x9c)
[   87.352473] [<c0101544>] (gic_handle_irq) from [<c010d7b0>] (__irq_svc+0x70/0xb0)
[   87.359912] Exception stack(0xc0d01ee8 to 0xc0d01f30)
[   87.364927] 1ee0:                   c087cc70 c0d0bf80 00000000 00000000 eef6d3c0 00000000
[   87.373094] 1f00: ed4e8000 00000102 cfe02400 c0d08db8 ed491880 c0d01f6c 00000001 c0d01f38
[   87.381234] 1f20: c087cc70 c087cc74 60070013 ffffffff
[   87.386254] [<c010d7b0>] (__irq_svc) from [<c087cc74>] (_raw_spin_unlock_irq+0x28/0x5c)
[   87.394252] [<c087cc74>] (_raw_spin_unlock_irq) from [<c0144b94>] (finish_task_switch+0xa0/0x1b0)
[   87.403097] [<c0144b94>] (finish_task_switch) from [<c0876830>] (__schedule+0x238/0x65c)
[   87.411140] [<c0876830>] (__schedule) from [<c0877158>] (schedule_idle+0x38/0x78)
[   87.418591] [<c0877158>] (schedule_idle) from [<c0162030>] (cpu_startup_entry+0x18/0x1c)
[   87.426658] [<c0162030>] (cpu_startup_entry) from [<c0c00c88>] (start_kernel+0x39c/0x3a8)
[   87.434792] Sending NMI from CPU 0 to CPUs 1-7:
[   87.439278] NMI backtrace for cpu 3
[   87.439294] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 4.15.0-rc3-00022-g3da7bcdd695b #1101
[   87.439300] Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
[   87.439322] PC is at arch_cpu_idle+0x24/0x3c
[   87.439333] LR is at arch_cpu_idle+0x20/0x3c
[   87.439341] pc : [<c01093d8>]    lr : [<c01093d4>]    psr: 60000013
[   87.439348] sp : ee8d5fb8  ip : 00000001  fp : c0afe104
[   87.439354] r10: 00000000  r9 : 00000000  r8 : c0c65730
[   87.439363] r7 : 00000008  r6 : c0d08c8c  r5 : c0d08c20  r4 : ee8d4000
[   87.439370] r3 : 00000000  r2 : 00000000  r1 : 00000000  r0 : c01093d4
[   87.439381] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
[   87.439389] Control: 10c5387d  Table: 6cd4806a  DAC: 00000051
[   87.439399] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 4.15.0-rc3-00022-g3da7bcdd695b #1101
[   87.439405] Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
[   87.439425] [<c01103a4>] (unwind_backtrace) from [<c010cac0>] (show_stack+0x10/0x14)
[   87.439442] [<c010cac0>] (show_stack) from [<c08620ac>] (dump_stack+0x98/0xc4)
[   87.439460] [<c08620ac>] (dump_stack) from [<c086801c>] (nmi_cpu_backtrace+0xb0/0x110)
[   87.439476] [<c086801c>] (nmi_cpu_backtrace) from [<c010f2ac>] (handle_IPI+0xd8/0x1b0)
[   87.439492] [<c010f2ac>] (handle_IPI) from [<c0101584>] (gic_handle_irq+0x98/0x9c)
[   87.439506] [<c0101584>] (gic_handle_irq) from [<c010d7b0>] (__irq_svc+0x70/0xb0)
[   87.439514] Exception stack(0xee8d5f68 to 0xee8d5fb0)
[   87.439527] 5f60:                   c01093d4 00000000 00000000 00000000 ee8d4000 c0d08c20
[   87.439542] 5f80: c0d08c8c 00000008 c0c65730 00000000 00000000 c0afe104 00000001 ee8d5fb8
[   87.439552] 5fa0: c01093d4 c01093d8 60000013 ffffffff
[   87.439569] [<c010d7b0>] (__irq_svc) from [<c01093d8>] (arch_cpu_idle+0x24/0x3c)
[   87.439586] [<c01093d8>] (arch_cpu_idle) from [<c0161c20>] (do_idle+0x190/0x230)
[   87.439600] [<c0161c20>] (do_idle) from [<c0162030>] (cpu_startup_entry+0x18/0x1c)
[   87.439615] [<c0162030>] (cpu_startup_entry) from [<4010192c>] (0x4010192c)
[   87.439626] NMI backtrace for cpu 1
[   87.439641] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 4.15.0-rc3-00022-g3da7bcdd695b #1101
[   87.439647] Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
[   87.439659] PC is at arch_cpu_idle+0x24/0x3c
[   87.439669] LR is at arch_cpu_idle+0x20/0x3c
[   87.439677] pc : [<c01093d8>]    lr : [<c01093d4>]    psr: 600d0013
[   87.439684] sp : ee8d1fb8  ip : 00000001  fp : c0afe104
[   87.439691] r10: 00000000  r9 : 00000000  r8 : c0c65730
[   87.439699] r7 : 00000002  r6 : c0d08c8c  r5 : c0d08c20  r4 : ee8d0000
[   87.439707] r3 : 00000000  r2 : 00000000  r1 : 00000000  r0 : c01093d4
[   87.439715] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
[   87.439723] Control: 10c5387d  Table: 6cd4806a  DAC: 00000051
[   87.439733] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 4.15.0-rc3-00022-g3da7bcdd695b #1101
[   87.439738] Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
[   87.439758] [<c01103a4>] (unwind_backtrace) from [<c010cac0>] (show_stack+0x10/0x14)
[   87.439775] [<c010cac0>] (show_stack) from [<c08620ac>] (dump_stack+0x98/0xc4)
[   87.439793] [<c08620ac>] (dump_stack) from [<c086801c>] (nmi_cpu_backtrace+0xb0/0x110)
[   87.439808] [<c086801c>] (nmi_cpu_backtrace) from [<c010f2ac>] (handle_IPI+0xd8/0x1b0)
[   87.439824] [<c010f2ac>] (handle_IPI) from [<c0101584>] (gic_handle_irq+0x98/0x9c)
[   87.439838] [<c0101584>] (gic_handle_irq) from [<c010d7b0>] (__irq_svc+0x70/0xb0)
[   87.439845] Exception stack(0xee8d1f68 to 0xee8d1fb0)
[   87.439859] 1f60:                   c01093d4 00000000 00000000 00000000 ee8d0000 c0d08c20
[   87.439873] 1f80: c0d08c8c 00000002 c0c65730 00000000 00000000 c0afe104 00000001 ee8d1fb8
[   87.439884] 1fa0: c01093d4 c01093d8 600d0013 ffffffff
[   87.439901] [<c010d7b0>] (__irq_svc) from [<c01093d8>] (arch_cpu_idle+0x24/0x3c)
[   87.439917] [<c01093d8>] (arch_cpu_idle) from [<c0161c20>] (do_idle+0x190/0x230)
[   87.439931] [<c0161c20>] (do_idle) from [<c0162030>] (cpu_startup_entry+0x18/0x1c)
[   87.439944] [<c0162030>] (cpu_startup_entry) from [<4010192c>] (0x4010192c)
[   87.439955] NMI backtrace for cpu 2
[   87.439968] CPU: 2 PID: 0 Comm: swapper/2 Not tainted 4.15.0-rc3-00022-g3da7bcdd695b #1101
[   87.439979] Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
[   87.439993] PC is at arch_cpu_idle+0x24/0x3c
[   87.440003] LR is at arch_cpu_idle+0x20/0x3c
[   87.440011] pc : [<c01093d8>]    lr : [<c01093d4>]    psr: 60070013
[   87.440019] sp : ee8d3fb8  ip : 00000001  fp : c0afe104
[   87.440027] r10: 00000000  r9 : 00000000  r8 : c0c65730
[   87.440036] r7 : 00000004  r6 : c0d08c8c  r5 : c0d08c20  r4 : ee8d2000
[   87.440044] r3 : 00000000  r2 : 00000000  r1 : 00000000  r0 : c01093d4
[   87.440054] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
[   87.440064] Control: 10c5387d  Table: 6cd3006a  DAC: 00000051
[   87.440076] CPU: 2 PID: 0 Comm: swapper/2 Not tainted 4.15.0-rc3-00022-g3da7bcdd695b #1101
[   87.440082] Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
[   87.440102] [<c01103a4>] (unwind_backtrace) from [<c010cac0>] (show_stack+0x10/0x14)
[   87.440118] [<c010cac0>] (show_stack) from [<c08620ac>] (dump_stack+0x98/0xc4)
[   87.440135] [<c08620ac>] (dump_stack) from [<c086801c>] (nmi_cpu_backtrace+0xb0/0x110)
[   87.440153] [<c086801c>] (nmi_cpu_backtrace) from [<c010f2ac>] (handle_IPI+0xd8/0x1b0)
[   87.440169] [<c010f2ac>] (handle_IPI) from [<c0101584>] (gic_handle_irq+0x98/0x9c)
[   87.440184] [<c0101584>] (gic_handle_irq) from [<c010d7b0>] (__irq_svc+0x70/0xb0)
[   87.440192] Exception stack(0xee8d3f68 to 0xee8d3fb0)
[   87.440206] 3f60:                   c01093d4 00000000 00000000 00000000 ee8d2000 c0d08c20
[   87.440221] 3f80: c0d08c8c 00000004 c0c65730 00000000 00000000 c0afe104 00000001 ee8d3fb8
[   87.440233] 3fa0: c01093d4 c01093d8 60070013 ffffffff
[   87.440251] [<c010d7b0>] (__irq_svc) from [<c01093d8>] (arch_cpu_idle+0x24/0x3c)
[   87.440269] [<c01093d8>] (arch_cpu_idle) from [<c0161c20>] (do_idle+0x190/0x230)
[   87.440285] [<c0161c20>] (do_idle) from [<c0162030>] (cpu_startup_entry+0x18/0x1c)
[   87.440299] [<c0162030>] (cpu_startup_entry) from [<4010192c>] (0x4010192c)
[   87.440323] NMI backtrace for cpu 4
[   87.440359] CPU: 4 PID: 0 Comm: swapper/4 Not tainted 4.15.0-rc3-00022-g3da7bcdd695b #1101
[   87.440375] Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
[   87.440422] PC is at arch_cpu_idle+0x24/0x3c
[   87.440450] LR is at arch_cpu_idle+0x20/0x3c
[   87.440469] pc : [<c01093d8>]    lr : [<c01093d4>]    psr: 600d0013
[   87.440487] sp : ee8d7fb8  ip : 00000001  fp : c0afe104
[   87.440504] r10: 00000000  r9 : 00000000  r8 : c0c65730
[   87.440523] r7 : 00000010  r6 : c0d08c8c  r5 : c0d08c20  r4 : ee8d6000
[   87.440541] r3 : 00000000  r2 : 00000000  r1 : 00000000  r0 : c01093d4
[   87.440565] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
[   87.440586] Control: 10c5387d  Table: 6cd5006a  DAC: 00000051
[   87.440615] CPU: 4 PID: 0 Comm: swapper/4 Not tainted 4.15.0-rc3-00022-g3da7bcdd695b #1101
[   87.440629] Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
[   87.440690] [<c01103a4>] (unwind_backtrace) from [<c010cac0>] (show_stack+0x10/0x14)
[   87.440736] [<c010cac0>] (show_stack) from [<c08620ac>] (dump_stack+0x98/0xc4)
[   87.440782] [<c08620ac>] (dump_stack) from [<c086801c>] (nmi_cpu_backtrace+0xb0/0x110)
[   87.440822] [<c086801c>] (nmi_cpu_backtrace) from [<c010f2ac>] (handle_IPI+0xd8/0x1b0)
[   87.440859] [<c010f2ac>] (handle_IPI) from [<c0101584>] (gic_handle_irq+0x98/0x9c)
[   87.440891] [<c0101584>] (gic_handle_irq) from [<c010d7b0>] (__irq_svc+0x70/0xb0)
[   87.440908] Exception stack(0xee8d7f68 to 0xee8d7fb0)
[   87.440944] 7f60:                   c01093d4 00000000 00000000 00000000 ee8d6000 c0d08c20
[   87.440979] 7f80: c0d08c8c 00000010 c0c65730 00000000 00000000 c0afe104 00000001 ee8d7fb8
[   87.441003] 7fa0: c01093d4 c01093d8 600d0013 ffffffff
[   87.441048] [<c010d7b0>] (__irq_svc) from [<c01093d8>] (arch_cpu_idle+0x24/0x3c)
[   87.441089] [<c01093d8>] (arch_cpu_idle) from [<c0161c20>] (do_idle+0x190/0x230)
[   87.441124] [<c0161c20>] (do_idle) from [<c0162030>] (cpu_startup_entry+0x18/0x1c)
[   87.441155] [<c0162030>] (cpu_startup_entry) from [<4010192c>] (0x4010192c)
[   87.441181] NMI backtrace for cpu 5
[   87.441216] CPU: 5 PID: 0 Comm: swapper/5 Not tainted 4.15.0-rc3-00022-g3da7bcdd695b #1101
[   87.441232] Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
[   87.441269] PC is at arch_cpu_idle+0x24/0x3c
[   87.441298] LR is at arch_cpu_idle+0x20/0x3c
[   87.441318] pc : [<c01093d8>]    lr : [<c01093d4>]    psr: 60010113
[   87.441336] sp : ee8e1fb8  ip : 00000001  fp : c0afe104
[   87.441352] r10: 00000000  r9 : 00000000  r8 : c0c65730
[   87.441372] r7 : 00000020  r6 : c0d08c8c  r5 : c0d08c20  r4 : ee8e0000
[   87.441389] r3 : 00000000  r2 : 00000000  r1 : 00000000  r0 : c01093d4
[   87.441412] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
[   87.441433] Control: 10c5387d  Table: 6ccd406a  DAC: 00000051
[   87.441461] CPU: 5 PID: 0 Comm: swapper/5 Not tainted 4.15.0-rc3-00022-g3da7bcdd695b #1101
[   87.441476] Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
[   87.441528] [<c01103a4>] (unwind_backtrace) from [<c010cac0>] (show_stack+0x10/0x14)
[   87.441574] [<c010cac0>] (show_stack) from [<c08620ac>] (dump_stack+0x98/0xc4)
[   87.441619] [<c08620ac>] (dump_stack) from [<c086801c>] (nmi_cpu_backtrace+0xb0/0x110)
[   87.441659] [<c086801c>] (nmi_cpu_backtrace) from [<c010f2ac>] (handle_IPI+0xd8/0x1b0)
[   87.441694] [<c010f2ac>] (handle_IPI) from [<c0101584>] (gic_handle_irq+0x98/0x9c)
[   87.441727] [<c0101584>] (gic_handle_irq) from [<c010d7b0>] (__irq_svc+0x70/0xb0)
[   87.441745] Exception stack(0xee8e1f68 to 0xee8e1fb0)
[   87.441780] 1f60:                   c01093d4 00000000 00000000 00000000 ee8e0000 c0d08c20
[   87.441815] 1f80: c0d08c8c 00000020 c0c65730 00000000 00000000 c0afe104 00000001 ee8e1fb8
[   87.441839] 1fa0: c01093d4 c01093d8 60010113 ffffffff
[   87.441884] [<c010d7b0>] (__irq_svc) from [<c01093d8>] (arch_cpu_idle+0x24/0x3c)
[   87.441925] [<c01093d8>] (arch_cpu_idle) from [<c0161c20>] (do_idle+0x190/0x230)
[   87.441959] [<c0161c20>] (do_idle) from [<c0162030>] (cpu_startup_entry+0x18/0x1c)
[   87.441992] [<c0162030>] (cpu_startup_entry) from [<4010192c>] (0x4010192c)
[   87.442017] NMI backtrace for cpu 6
[   87.442051] CPU: 6 PID: 0 Comm: swapper/6 Not tainted 4.15.0-rc3-00022-g3da7bcdd695b #1101
[   87.442067] Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
[   87.442103] PC is at arch_cpu_idle+0x24/0x3c
[   87.442132] LR is at arch_cpu_idle+0x20/0x3c
[   87.442152] pc : [<c01093d8>]    lr : [<c01093d4>]    psr: 60010013
[   87.442169] sp : ee8e3fb8  ip : 00000001  fp : c0afe104
[   87.442185] r10: 00000000  r9 : 00000000  r8 : c0c65730
[   87.442204] r7 : 00000040  r6 : c0d08c8c  r5 : c0d08c20  r4 : ee8e2000
[   87.442222] r3 : 00000000  r2 : 00000000  r1 : 00000000  r0 : c01093d4
[   87.442244] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
[   87.442264] Control: 10c5387d  Table: 6ccd006a  DAC: 00000051
[   87.442292] CPU: 6 PID: 0 Comm: swapper/6 Not tainted 4.15.0-rc3-00022-g3da7bcdd695b #1101
[   87.442306] Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
[   87.442359] [<c01103a4>] (unwind_backtrace) from [<c010cac0>] (show_stack+0x10/0x14)
[   87.442404] [<c010cac0>] (show_stack) from [<c08620ac>] (dump_stack+0x98/0xc4)
[   87.442448] [<c08620ac>] (dump_stack) from [<c086801c>] (nmi_cpu_backtrace+0xb0/0x110)
[   87.442486] [<c086801c>] (nmi_cpu_backtrace) from [<c010f2ac>] (handle_IPI+0xd8/0x1b0)
[   87.442522] [<c010f2ac>] (handle_IPI) from [<c0101584>] (gic_handle_irq+0x98/0x9c)
[   87.442555] [<c0101584>] (gic_handle_irq) from [<c010d7b0>] (__irq_svc+0x70/0xb0)
[   87.442572] Exception stack(0xee8e3f68 to 0xee8e3fb0)
[   87.442605] 3f60:                   c01093d4 00000000 00000000 00000000 ee8e2000 c0d08c20
[   87.442642] 3f80: c0d08c8c 00000040 c0c65730 00000000 00000000 c0afe104 00000001 ee8e3fb8
[   87.442666] 3fa0: c01093d4 c01093d8 60010013 ffffffff
[   87.442708] [<c010d7b0>] (__irq_svc) from [<c01093d8>] (arch_cpu_idle+0x24/0x3c)
[   87.442747] [<c01093d8>] (arch_cpu_idle) from [<c0161c20>] (do_idle+0x190/0x230)
[   87.442783] [<c0161c20>] (do_idle) from [<c0162030>] (cpu_startup_entry+0x18/0x1c)
[   87.442814] [<c0162030>] (cpu_startup_entry) from [<4010192c>] (0x4010192c)
[   87.442839] NMI backtrace for cpu 7
[   87.442873] CPU: 7 PID: 0 Comm: swapper/7 Not tainted 4.15.0-rc3-00022-g3da7bcdd695b #1101
[   87.442888] Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
[   87.442925] PC is at arch_cpu_idle+0x24/0x3c
[   87.442954] LR is at arch_cpu_idle+0x20/0x3c
[   87.442973] pc : [<c01093d8>]    lr : [<c01093d4>]    psr: 60000013
[   87.442990] sp : ee8e5fb8  ip : 00000001  fp : c0afe104
[   87.443007] r10: 00000000  r9 : 00000000  r8 : c0c65730
[   87.443025] r7 : 00000080  r6 : c0d08c8c  r5 : c0d08c20  r4 : ee8e4000
[   87.443043] r3 : 00000000  r2 : 00000000  r1 : 00000000  r0 : c01093d4
[   87.443065] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
[   87.443086] Control: 10c5387d  Table: 6ccb006a  DAC: 00000051
[   87.443113] CPU: 7 PID: 0 Comm: swapper/7 Not tainted 4.15.0-rc3-00022-g3da7bcdd695b #1101
[   87.443127] Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
[   87.443179] [<c01103a4>] (unwind_backtrace) from [<c010cac0>] (show_stack+0x10/0x14)
[   87.443223] [<c010cac0>] (show_stack) from [<c08620ac>] (dump_stack+0x98/0xc4)
[   87.443265] [<c08620ac>] (dump_stack) from [<c086801c>] (nmi_cpu_backtrace+0xb0/0x110)
[   87.443303] [<c086801c>] (nmi_cpu_backtrace) from [<c010f2ac>] (handle_IPI+0xd8/0x1b0)
[   87.443340] [<c010f2ac>] (handle_IPI) from [<c0101584>] (gic_handle_irq+0x98/0x9c)
[   87.443374] [<c0101584>] (gic_handle_irq) from [<c010d7b0>] (__irq_svc+0x70/0xb0)
[   87.443391] Exception stack(0xee8e5f68 to 0xee8e5fb0)
[   87.443424] 5f60:                   c01093d4 00000000 00000000 00000000 ee8e4000 c0d08c20
[   87.443459] 5f80: c0d08c8c 00000080 c0c65730 00000000 00000000 c0afe104 00000001 ee8e5fb8
[   87.443482] 5fa0: c01093d4 c01093d8 60000013 ffffffff
[   87.443527] [<c010d7b0>] (__irq_svc) from [<c01093d8>] (arch_cpu_idle+0x24/0x3c)
[   87.443568] [<c01093d8>] (arch_cpu_idle) from [<c0161c20>] (do_idle+0x190/0x230)
[   87.443604] [<c0161c20>] (do_idle) from [<c0162030>] (cpu_startup_entry+0x18/0x1c)
[   87.443634] [<c0162030>] (cpu_startup_entry) from [<4010192c>] (0x4010192c)
[   89.892591] systemd-journald[225]: Received request to flush runtime journal from PID 1
[   90.289569] systemd-journald[225]: File /var/log/journal/7a4e9999283c4067874e93fe7b5d73eb/system.journal corrupted or uncleanly shut down




Best regards,
Krzysztof

