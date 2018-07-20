Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58600 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727028AbeGTIRb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Jul 2018 04:17:31 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w6K5sVUR046667
        for <linux-xfs@vger.kernel.org>; Fri, 20 Jul 2018 01:56:24 -0400
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2kb8wqjcnf-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Fri, 20 Jul 2018 01:56:24 -0400
Received: from localhost
        by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <vrbagal1@linux.vnet.ibm.com>;
        Thu, 19 Jul 2018 23:56:23 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Fri, 20 Jul 2018 11:32:21 +0530
From: vrbagal1 <vrbagal1@linux.vnet.ibm.com>
Subject: Re: [powerpc/powervm]Oops: Kernel access of bad area, sig: 11 [#1]
 while running stress-ng
In-Reply-To: <20180719133310.GA29404@bfoster>
References: <8595a4f915a7344210a8cc7ad6923a2b@linux.vnet.ibm.com>
 <20180710180708.6e0cd26b@roar.ozlabs.ibm.com>
 <920d9bc6a2c3449700dec191c271bdff@linux.vnet.ibm.com>
 <877em3b42f.fsf@concordia.ellerman.id.au>
 <fd8a991ffa7420613d4fe8e69e78d611@linux.vnet.ibm.com>
 <20180719133310.GA29404@bfoster>
Message-Id: <7655c7e90f4ece844f230e5bcfc44f2a@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: sachinp <sachinp@linux.vnet.ibm.com>, Linuxppc-dev <linuxppc-dev-bounces+vrbagal1=linux.vnet.ibm.com@lists.ozlabs.org>, Nicholas Piggin <npiggin@gmail.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>

On 2018-07-19 19:03, Brian Foster wrote:
> cc linux-xfs
> 
> On Thu, Jul 19, 2018 at 11:47:59AM +0530, vrbagal1 wrote:
>> On 2018-07-10 19:12, Michael Ellerman wrote:
>> > vrbagal1 <vrbagal1@linux.vnet.ibm.com> writes:
>> >
>> > > On 2018-07-10 13:37, Nicholas Piggin wrote:
>> > > > On Tue, 10 Jul 2018 11:58:40 +0530
>> > > > vrbagal1 <vrbagal1@linux.vnet.ibm.com> wrote:
>> > > >
>> > > > > Hi,
>> > > > >
>> > > > > Observing kernel oops on Power9(ZZ) box, running on PowerVM, while
>> > > > > running stress-ng.
>> > > > >
>> > > > >
>> > > > > Kernel: 4.18.0-rc4
>> > > > > Machine: Power9 ZZ (PowerVM)
>> > > > > Test: Stress-ng
>> > > > >
>> > > > > Attached is .config file
>> > > > >
>> > > > > Traces:
>> > > > >
>> > > > >   [12251.245209] Oops: Kernel access of bad area, sig: 11 [#1]
>> > > >
>> > > > Can you post the lines above this? Otherwise we don't know what
>> > > > address
>> > > > it tried to access (without decoding the instructions and
>> > > > reconstructing
>> > > > it from registers at least, which the XFS devs wouldn't be
>> > > > inclined to
>> > > > do).
>> > > >
>> > >
>> > > ah my bad.
>> > >
>> > >   [12251.245179] Unable to handle kernel paging request for data at
>> > > address 0x6000000060000000
>> > >   [12251.245199] Faulting instruction address: 0xc000000000319e2c
>> >
>> > Which matches the regs & disassembly:
>> >
>> > r4 = 6000000060000000
>> > r9 = 0
>> > ldx     r9,r4,r9	<- pop
>> >
>> > So object was 0x6000000060000000.
>> >
>> > That looks like two nops, ie. we got some code?
>> >
>> > And there's only one caller of prefetch_freepointer() in
>> > slab_alloc_node():
>> >
>> > 	prefetch_freepointer(s, next_object);
>> >
>> >
>> > So slab corruption is looking likely.
>> >
>> > Do you have slub_debug=FZP on the kernel command line?
>> 
>> I tried to reproduce this, but didnt succeed. But instead I got xfs
>> assertion.
>> 
>> Kernel: 4.18.0-rc5
>> Tree Head: 30b06abfb92bfd5f9b63ea6a2ffb0bd905d1a6da
>> 
>> Traces:
>> 
>>  [12290.993612] XFS: Assertion failed: flags & XFS_BMAPI_COWFORK, 
>> file:
>> fs/xfs/libxfs/xfs_bmap.c, line: 4370
> 
> This usually means we have a writeback of a page with delayed 
> allocation
> buffers over an extent map that reflects a hole in the file. This 
> should
> never happen for normal (non-reflink) data fork writes, hence the 
> assert
> failure and -EIO return.
> 
> We used to actually (accidentally) allocate a new block in this case,
> but more recent kernels generate the error. More interestingly, I think
> the pending iomap + writeback rework in XFS may simply drop this error
> on the floor because we refer to extent state to process the page 
> rather
> than the other way around (and buffer_delay() isn't a state in the 
> iomap
> bits). This of course depends on which state is actually valid, the
> buffer or extent map, which we don't know for sure.
> 
> Can you reliably reproduce this problem? If so, can you describe the
> reproducer? Also, what is the filesystem geometry ('xfs_info <mnt>')?
> And since this is a power kernel, I'm guessing you have 64k pages as
> well..?
> 
> Brian


I tried, but couldnt hit the issue. But this issue was hit running 
stress-ng test case, last time(saw some xfs traces) and this time.
More specific I was running: /bin/avocado run 
avocado-misc-tests/generic/stress-ng.py -m 
/root/avocado-fvt-wrapper/tests/avocado-misc-tests/generic/stress-ng.py.data/stress-ng-cpu.yaml

xfs_info o/p:

# xfs_info /dev/sdi2
meta-data=/dev/sdi2              isize=512    agcount=4, agsize=65536 
blks
          =                       sectsz=512   attr=2, projid32bit=1
          =                       crc=1        finobt=0 spinodes=0
data     =                       bsize=4096   blocks=262144, imaxpct=25
          =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal               bsize=4096   blocks=2560, version=2
          =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0


Yes, 64K pagesize.

Regards,
Venkat.


> 
>>  [12290.993668] ------------[ cut here ]------------
>>  [12290.993672] kernel BUG at fs/xfs/xfs_message.c:102!
>>  [12290.993676] Oops: Exception in kernel mode, sig: 5 [#1]
>>  [12290.993678] LE SMP NR_CPUS=2048 NUMA pSeries
>>  [12290.993697] Dumping ftrace buffer:
>>  [12290.993730]    (ftrace buffer empty)
>>  [12290.993735] Modules linked in: camellia_generic(E) 
>> cast6_generic(E)
>> cast_common(E) ppp_generic(E) serpent_generic(E) slhc(E) kvm_pr(E) 
>> kvm(E)
>> snd_seq(E) snd_seq_device(E) twofish_generic(E) snd_timer(E) snd(E)
>> soundcore(E) twofish_common(E) lrw(E) cuse(E) tgr192(E) hci_vhci(E)
>> vhost_net(E) bluetooth(E) ecdh_generic(E) wp512(E) rfkill(E)
>> vfio_iommu_spapr_tce(E) vfio_spapr_eeh(E) vfio(E) rmd320(E) uhid(E) 
>> tun(E)
>> tap(E) rmd256(E) rmd160(E) vhost_vsock(E) rmd128(E)
>> vmw_vsock_virtio_transport_common(E) vsock(E) vhost(E) uinput(E) 
>> md4(E)
>> unix_diag(E) dccp_ipv4(E) dccp(E) sha512_generic(E) binfmt_misc(E) 
>> fuse(E)
>> vfat(E) fat(E) btrfs(E) xor(E) zstd_decompress(E) zstd_compress(E) 
>> xxhash(E)
>> raid6_pq(E) ext4(E) mbcache(E) jbd2(E) fscrypto(E) loop(E) 
>> ip6t_rpfilter(E)
>> ipt_REJECT(E) nf_reject_ipv4(E) ip6t_REJECT(E)
>>  [12290.993784]  nf_reject_ipv6(E) xt_conntrack(E) ip_set(E) 
>> nfnetlink(E)
>> ebtable_nat(E) ebtable_broute(E) bridge(E) stp(E) llc(E) 
>> ip6table_nat(E)
>> nf_conntrack_ipv6(E) nf_defrag_ipv6(E) nf_nat_ipv6(E) 
>> ip6table_mangle(E)
>> ip6table_security(E) ip6table_raw(E) iptable_nat(E) 
>> nf_conntrack_ipv4(E)
>> nf_defrag_ipv4(E) nf_nat_ipv4(E) nf_nat(E) nf_conntrack(E) 
>> iptable_mangle(E)
>> iptable_security(E) iptable_raw(E) ebtable_filter(E) ebtables(E)
>> ip6table_filter(E) ip6_tables(E) iptable_filter(E) xts(E) sg(E)
>> vmx_crypto(E) pseries_rng(E) ip_tables(E) xfs(E) libcrc32c(E) 
>> sd_mod(E)
>> ibmvscsi(E) scsi_transport_srp(E) ibmveth(E) lpfc(E) mlx5_core(E)
>> nvmet_fc(E) nvmet(E) nvme_fc(E) nvme_fabrics(E) nvme_core(E)
>> scsi_transport_fc(E) mlxfw(E) devlink(E) dm_mirror(E) 
>> dm_region_hash(E)
>> dm_log(E) dm_mod(E) [last unloaded: torture]
>>  [12290.993834] CPU: 2 PID: 433 Comm: kswapd1 Tainted: G            E
>> 4.18.0-rc5-autotest-autotest #1
>>  [12290.993838] NIP:  d00000000ebcfb8c LR: d00000000ebcfb64 CTR:
>> c0000000005260a0
>>  [12290.993841] REGS: c000000feee7ef40 TRAP: 0700   Tainted: G         
>>    E
>> (4.18.0-rc5-autotest-autotest)
>>  [12290.993845] MSR:  800000010282b033
>> <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE,TM[E]>  CR: 22224044  XER: 0000000d
>>  [12290.993854] CFAR: d00000000ebcfb74 IRQMASK: 0
>>  [12290.993854] GPR00: d00000000ebcfb64 c000000feee7f1c0 
>> d00000000ec58700
>> ffffffffffffffea
>>  [12290.993854] GPR04: 000000000000000a c000000feee7f0c0 
>> ffffffffffffffc0
>> d00000000ec41620
>>  [12290.993854] GPR08: ffffffffffffffca 0000000000000001 
>> 0000000000000000
>> 0000000000000000
>>  [12290.993854] GPR12: c0000000005260a0 c00000001ec9d600 
>> c000000feee7f510
>> 0000000040000000
>>  [12290.993854] GPR16: 0000000020000000 0000000000000000 
>> c000000fc6308000
>> c000000feee7f4c0
>>  [12290.993854] GPR20: c000000feee7f520 c000000feee7f520 
>> 000ffffffffe0000
>> 0000000000000000
>>  [12290.993854] GPR24: 00000000001fffff 0000000000000001 
>> c000000f689c8800
>> 0000000000000000
>>  [12290.993854] GPR28: c000000f689c8848 c000000feee7f520 
>> 0000000000000001
>> 0000000000000400
>>  [12290.993907] NIP [d00000000ebcfb8c] assfail+0x5c/0x60 [xfs]
>>  [12290.993921] LR [d00000000ebcfb64] assfail+0x34/0x60 [xfs]
>>  [12290.993923] Call Trace:
>>  [12290.993936] [c000000feee7f1c0] [d00000000ebcfb64] 
>> assfail+0x34/0x60
>> [xfs] (unreliable)
>>  [12290.993947] [c000000feee7f220] [d00000000eb542f0]
>> xfs_bmapi_write+0x10f0/0x1260 [xfs]
>>  [12290.993961] [c000000feee7f450] [d00000000ebc34e8]
>> xfs_iomap_write_allocate+0x1b8/0x430 [xfs]
>>  [12290.993975] [c000000feee7f5c0] [d00000000eba0de4]
>> xfs_map_blocks+0x234/0x470 [xfs]
>>  [12290.993988] [c000000feee7f630] [d00000000eba2d4c]
>> xfs_do_writepage+0x27c/0x880 [xfs]
>>  [12290.994001] [c000000feee7f710] [d00000000eba3314]
>> xfs_do_writepage+0x844/0x880 [xfs]
>>  [12290.994007] [c000000feee7f780] [c00000000029df24]
>> pageout.isra.37+0x294/0x4a0
>>  [12290.994011] [c000000feee7f860] [c0000000002a0a28]
>> shrink_page_list+0x948/0x1090
>>  [12290.994015] [c000000feee7f980] [c0000000002a1c8c]
>> shrink_inactive_list+0x2ec/0x720
>>  [12290.994019] [c000000feee7fa40] [c0000000002a28d8]
>> shrink_node_memcg+0x238/0x7d0
>>  [12290.994024] [c000000feee7fb40] [c0000000002a2f94]
>> shrink_node+0x124/0x610
>>  [12290.994027] [c000000feee7fc10] [c0000000002a46d0]
>> balance_pgdat+0x200/0x460
>>  [12290.994031] [c000000feee7fcf0] [c0000000002a4afc] 
>> kswapd+0x1cc/0x5f0
>>  [12290.994036] [c000000feee7fdc0] [c00000000012ca6c] 
>> kthread+0x15c/0x1a0
>>  [12290.994040] [c000000feee7fe30] [c00000000000b65c]
>> ret_from_kernel_thread+0x5c/0x80
>>  [12290.994043] Instruction dump:
>>  [12290.994046] f821ffa1 4bfff8a9 3d220000 e929cb40 89290008 2f890000
>> 40de0018 0fe00000
>>  [12290.994053] 38210060 e8010010 7c0803a6 4e800020 <0fe00000> 
>> 3c4c0009
>> 38428b70 7c0802a6
>>  [12290.994061] ---[ end trace 84e4cce770c4d4e2 ]---
>>  [12290.996233]
>>  [12291.996258] Kernel panic - not syncing: Fatal exception
>>  [12292.006592] Dumping ftrace buffer:
>>  [12292.006637]    (ftrace buffer empty)
>>  [12292.013222] WARNING: CPU: 2 PID: 433 at drivers/tty/vt/vt.c:3885
>> do_unblank_screen+0x278/0x280
>>  [12292.013228] Modules linked in: camellia_generic(E) 
>> cast6_generic(E)
>> cast_common(E) ppp_generic(E) serpent_generic(E) slhc(E) kvm_pr(E) 
>> kvm(E)
>> snd_seq(E) snd_seq_device(E) twofish_generic(E) snd_timer(E) snd(E)
>> soundcore(E) twofish_common(E) lrw(E) cuse(E) tgr192(E) hci_vhci(E)
>> vhost_net(E) bluetooth(E) ecdh_generic(E) wp512(E) rfkill(E)
>> vfio_iommu_spapr_tce(E) vfio_spapr_eeh(E) vfio(E) rmd320(E) uhid(E) 
>> tun(E)
>> tap(E) rmd256(E) rmd160(E) vhost_vsock(E) rmd128(E)
>> vmw_vsock_virtio_transport_common(E) vsock(E) vhost(E) uinput(E) 
>> md4(E)
>> unix_diag(E) dccp_ipv4(E) dccp(E) sha512_generic(E) binfmt_misc(E) 
>> fuse(E)
>> vfat(E) fat(E) btrfs(E) xor(E) zstd_decompress(E) zstd_compress(E) 
>> xxhash(E)
>> raid6_pq(E) ext4(E) mbcache(E) jbd2(E) fscrypto(E) loop(E) 
>> ip6t_rpfilter(E)
>> ipt_REJECT(E) nf_reject_ipv4(E) ip6t_REJECT(E)
>>  [12292.013315]  nf_reject_ipv6(E) xt_conntrack(E) ip_set(E) 
>> nfnetlink(E)
>> ebtable_nat(E) ebtable_broute(E) bridge(E) stp(E) llc(E) 
>> ip6table_nat(E)
>> nf_conntrack_ipv6(E) nf_defrag_ipv6(E) nf_nat_ipv6(E) 
>> ip6table_mangle(E)
>> ip6table_security(E) ip6table_raw(E) iptable_nat(E) 
>> nf_conntrack_ipv4(E)
>> nf_defrag_ipv4(E) nf_nat_ipv4(E) nf_nat(E) nf_conntrack(E) 
>> iptable_mangle(E)
>> iptable_security(E) iptable_raw(E) ebtable_filter(E) ebtables(E)
>> ip6table_filter(E) ip6_tables(E) iptable_filter(E) xts(E) sg(E)
>> vmx_crypto(E) pseries_rng(E) ip_tables(E) xfs(E) libcrc32c(E) 
>> sd_mod(E)
>> ibmvscsi(E) scsi_transport_srp(E) ibmveth(E) lpfc(E) mlx5_core(E)
>> nvmet_fc(E) nvmet(E) nvme_fc(E) nvme_fabrics(E) nvme_core(E)
>> scsi_transport_fc(E) mlxfw(E) devlink(E) dm_mirror(E) 
>> dm_region_hash(E)
>> dm_log(E) dm_mod(E) [last unloaded: torture]
>>  [12292.013394] CPU: 2 PID: 433 Comm: kswapd1 Tainted: G      D     E
>> 4.18.0-rc5-autotest-autotest #1
>>  [12292.013400] NIP:  c0000000005e9cb8 LR: c0000000005e9a7c CTR:
>> c00000000002bcc0
>>  [12292.013406] REGS: c000000feee7e880 TRAP: 0700   Tainted: G      D  
>>    E
>> (4.18.0-rc5-autotest-autotest)
>>  [12292.013411] MSR:  8000000000021033 <SF,ME,IR,DR,RI,LE>  CR: 
>> 28222042
>> XER: 20040009
>>  [12292.013422] CFAR: c0000000005e9a90 IRQMASK: 3
>>  [12292.013422] GPR00: c0000000005e9c74 c000000feee7eb00 
>> c000000001150200
>> 0000000000000000
>>  [12292.013422] GPR04: 0000000000000003 000000000000000b 
>> 00000000646f6320
>> 3030303020726c20
>>  [12292.013422] GPR08: 0000000000000000 0000000000000000 
>> 0000000000000000
>> 3830303031303030
>>  [12292.013422] GPR12: c00000000002bcc0 c00000001ec9d600 
>> c000000feee7f510
>> 0000000040000000
>>  [12292.013422] GPR16: 0000000020000000 0000000000000000 
>> c000000fc6308000
>> c000000feee7f4c0
>>  [12292.013422] GPR20: c000000feee7f520 c000000feee7f520 
>> 000ffffffffe0000
>> 0000000000000000
>>  [12292.013422] GPR24: 00000000001fffff 0000000000000001 
>> c000000000ff9e60
>> c0000000013067e8
>>  [12292.013422] GPR28: c0000000013067c0 0000000000000000 
>> c000000001414f60
>> c0000000013067e8
>>  [12292.013483] NIP [c0000000005e9cb8] do_unblank_screen+0x278/0x280
>>  [12292.013488] LR [c0000000005e9a7c] do_unblank_screen+0x3c/0x280
>>  [12292.013492] Call Trace:
>>  [12292.013496] [c000000feee7eb00] [c0000000005e9c74]
>> do_unblank_screen+0x234/0x280 (unreliable)
>>  [12292.013505] [c000000feee7eb80] [c000000000513300]
>> bust_spinlocks+0x40/0x80
>>  [12292.013511] [c000000feee7eba0] [c0000000001003b0] 
>> panic+0x1b8/0x308
>>  [12292.013518] [c000000feee7ec30] [c000000000023a3c] 
>> oops_end+0x1ec/0x1f0
>>  [12292.013524] [c000000feee7ecb0] [c000000000023f54]
>> _exception_pkey+0x1c4/0x1f0
>>  [12292.013530] [c000000feee7ee50] [c000000000026020]
>> program_check_exception+0x2c0/0x3e0
>>  [12292.013537] [c000000feee7eed0] [c000000000008e94]
>> program_check_common+0x134/0x140
>>  [12292.013579] --- interrupt: 700 at assfail+0x5c/0x60 [xfs]
>>  [12292.013579]     LR = assfail+0x34/0x60 [xfs]
>>  [12292.013597] [c000000feee7f220] [d00000000eb542f0]
>> xfs_bmapi_write+0x10f0/0x1260 [xfs]
>>  [12292.013619] [c000000feee7f450] [d00000000ebc34e8]
>> xfs_iomap_write_allocate+0x1b8/0x430 [xfs]
>>  [12292.013641] [c000000feee7f5c0] [d00000000eba0de4]
>> xfs_map_blocks+0x234/0x470 [xfs]
>>  [12292.013662] [c000000feee7f630] [d00000000eba2d4c]
>> xfs_do_writepage+0x27c/0x880 [xfs]
>>  [12292.013682] [c000000feee7f710] [d00000000eba3314]
>> xfs_do_writepage+0x844/0x880 [xfs]
>>  [12292.013689] [c000000feee7f780] [c00000000029df24]
>> pageout.isra.37+0x294/0x4a0
>>  [12292.013696] [c000000feee7f860] [c0000000002a0a28]
>> shrink_page_list+0x948/0x1090
>>  [12292.013702] [c000000feee7f980] [c0000000002a1c8c]
>> shrink_inactive_list+0x2ec/0x720
>>  [12292.013708] [c000000feee7fa40] [c0000000002a28d8]
>> shrink_node_memcg+0x238/0x7d0
>>  [12292.013714] [c000000feee7fb40] [c0000000002a2f94]
>> shrink_node+0x124/0x610
>>  [12292.013720] [c000000feee7fc10] [c0000000002a46d0]
>> balance_pgdat+0x200/0x460
>>  [12292.013726] [c000000feee7fcf0] [c0000000002a4afc] 
>> kswapd+0x1cc/0x5f0
>>  [12292.013732] [c000000feee7fdc0] [c00000000012ca6c] 
>> kthread+0x15c/0x1a0
>>  [12292.013738] [c000000feee7fe30] [c00000000000b65c]
>> ret_from_kernel_thread+0x5c/0x80
>>  [12292.013743] Instruction dump:
>>  [12292.013748] 1d290064 3c62ffef 3863ab50 e94a0000 7d2407b4 7c845214
>> 4bbbacc9 60000000
>>  [12292.013758] 39200001 3d42003e 912adff8 4bfffe68 <0fe00000> 
>> 4bfffdd8
>> 3c4c00b6 38426540
>>  [12292.013769] ---[ end trace 84e4cce770c4d4e3 ]---
>>  [12292.013774] Rebooting in 10 seconds..
>> 
>> Regards,
>> Venkat.
>> >
>> > cheers
>> 

