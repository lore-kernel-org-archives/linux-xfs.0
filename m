Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 365E57CBE
	for <xfs@oss.sgi.com>; Tue, 21 Apr 2015 15:52:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2AE2030404E
	for <xfs@oss.sgi.com>; Tue, 21 Apr 2015 13:52:42 -0700 (PDT)
Received: from g4t3427.houston.hp.com (g4t3427.houston.hp.com [15.201.208.55])
	by cuda.sgi.com with ESMTP id TDJI3UaXpyF0zrWO (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 21 Apr 2015 13:52:40 -0700 (PDT)
Message-ID: <5536B895.1040107@hp.com>
Date: Tue, 21 Apr 2015 16:52:37 -0400
From: Waiman Long <waiman.long@hp.com>
MIME-Version: 1.0
Subject: Re: 4.0 kernel XFS filesystem crash when running AIM7's disk workload
References: <55314529.7060202@hp.com> <20150417234541.GG21261@dastard>
In-Reply-To: <20150417234541.GG21261@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On 04/17/2015 07:45 PM, Dave Chinner wrote:
> On Fri, Apr 17, 2015 at 01:38:49PM -0400, Waiman Long wrote:
>> Hi Dave,
>>
>> When I was running the AIM7's disk workload on a 8-socket
>> Westmere-EX server with 4.0 kernel, the kernel crash. A set of small
>> ramdisks were created (ramdisk_size=271072). Those ramdisks were
>> formatted with XFS filesystem before the test began. The kernel log
>> was:
>>
>> XFS (ram12): Mounting V4 Filesystem
>> XFS (ram12): Log size 1424 blocks too small, minimum size is 1596 blocks
>> XFS (ram12): Log size out of supported range. Continuing onwards,
>> but if log hangs are
>> experienced then please report this message in the bug report.
> First thing you need to do is upgrade xfsprogs so that this message
> goes away. or use "mkfs.xfs -l size=10m" so that the log is larger
> than the minimum.
>
>> XFS (ram15): Ending clean mount
>> BUG: unable to handle kernel NULL pointer dereference at           (null)
>> IP: [<ffffffff812abd6d>] __memcpy+0xd/0x110
>> PGD 29f7655f067 PUD 29f75a80067 PMD 0
>> Oops: 0000 [#1] SMP
>> Modules linked in: xfs exportfs libcrc32c ebtable_nat ebtables
>> xt_CHECKSUM iptable_mangle bridge stp llc autofs4 ipt_REJECT
>> nf_reject_ipv4 nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter
>> ip_tables ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6
>> nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6
>> vhost_net macvtap macvlan vhost tun kvm_intel kvm ipmi_si
>> ipmi_msghandler tpm_infineon iTCO_wdt iTCO_vendor_support wmi
>> acpi_cpufreq microcode pcspkr serio_raw qlcnic be2net vxlan
>> udp_tunnel ip6_udp_tunnel ses enclosure igb dca ptp pps_core lpc_ich
>> mfd_core hpilo hpwdt sg i7core_edac edac_core netxen_nic ext4(E)
>> jbd2(E) mbcache(E) sr_mod(E) cdrom(E) sd_mod(E) lpfc(E) qla2xxx(E)
>> scsi_transport_fc(E) pata_acpi(E) ata_generic(E) ata_piix(E) hpsa(E)
>> radeon(E) ttm(E) drm_kms_helper(E) drm(E) i2c_algo_bit(E)
>> i2c_core(E) dm_mirror(E) dm_region_hash(E) dm_log(E) dm_mod(E)
> Why do you have a mix of signed and unsigned modules loaded?

I did the test on a RHEL 6.6 system. The 4.0 kernel is unsigned, but 
there are some additional RHEL modules loaded at boot up time.

>> CPU: 69 PID: 116603 Comm: xfsaild/ram5 Tainted: G            E   4.0.0 #2
>> Hardware name: HP ProLiant DL980 G7, BIOS P66 07/30/2012
>> task: ffff8b9f7eeb4f80 ti: ffff8b9f7f1ac000 task.ti: ffff8b9f7f1ac000
>> RIP: 0010:[<ffffffff812abd6d>]  [<ffffffff812abd6d>] __memcpy+0xd/0x110
>> RSP: 0018:ffff8b9f7f1afc10  EFLAGS: 00010206
>> RAX: ffff88102476a3cc RBX: ffff889ff2ab5000 RCX: 0000000000000005
>> RDX: 0000000000000006 RSI: 0000000000000000 RDI: ffff88102476a3cc
> edx = 6 bytes.
>
>> RBP: ffff8b9f7f1afc18 R08: 0000000000000001 R09: ffff88102476a3cc
>> R10: ffff8a1f6c03ea80 R11: 0000000000000000 R12: ffff8b1ff1269400
>> R13: ffff8b1f64837c98 R14: ffff881038701200 R15: ffff88102476a300
>> FS:  0000000000000000(0000) GS:ffff8b1fffa40000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>> CR2: 0000000000000000 CR3: 0000029f7655e000 CR4: 00000000000006e0
>> Stack:
>>   ffffffffa0ca8c41 ffff8b9f7f1afc68 ffffffffa0cc4803 ffff8b9f7f1afc68
>>   ffffffffa0cd2777 ffff8b9f7f1afc68 ffff8b1ff1269400 ffff8a9f59022800
>>   ffff8b1f7c932718 0000000000000003 ffff8a9f590228e4 ffff8b9f7f1afce8
>> Call Trace:
>>   [<ffffffffa0ca8c41>] ? xfs_iflush_fork+0x181/0x240 [xfs]
>>   [<ffffffffa0cc4803>] xfs_iflush_int+0x1f3/0x320 [xfs]
>>   [<ffffffffa0cd2777>] ? kmem_alloc+0x87/0x100 [xfs]
>>   [<ffffffffa0cc60a5>] xfs_iflush_cluster+0x295/0x380 [xfs]
>>   [<ffffffffa0cc8ff4>] xfs_iflush+0xf4/0x1f0 [xfs]
>>   [<ffffffffa0cda22a>] xfs_inode_item_push+0xea/0x130 [xfs]
>>   [<ffffffffa0ce140d>] xfsaild_push+0x10d/0x500 [xfs]
>>   [<ffffffff810b7c20>] ? lock_timer_base+0x70/0x70
>>   [<ffffffffa0ce1898>] xfsaild+0x98/0x130 [xfs]
>>   [<ffffffffa0ce1800>] ? xfsaild_push+0x500/0x500 [xfs]
>>   [<ffffffffa0ce1800>] ? xfsaild_push+0x500/0x500 [xfs]
>>   [<ffffffffa0ce1800>] ? xfsaild_push+0x500/0x500 [xfs]
>>   [<ffffffff81074b50>] ? kthread_freezable_should_stop+0x70/0x70
>>   [<ffffffff815c5748>] ret_from_fork+0x58/0x90
>>   [<ffffffff81074b50>] ? kthread_freezable_should_stop+0x70/0x70
>> Code: 0f b6 c0 5b c9 c3 0f 1f 84 00 00 00 00 00 e8 2b f9 ff ff 80 7b
>> 25 00 74 c8 eb d3 90 90 90 48 89 f8 48 89 d1 48 c1 e9 03 83 e2 07
>> <f3>  48 a5 89 d1 f3 a4 c3 20 4c 8b 06 4c 8b 4e 08 4c 8b 56 10 4c
>> RIP  [<ffffffff812abd6d>] __memcpy+0xd/0x110
>>   RSP<ffff8b9f7f1afc10>
>> CR2: 0000000000000000
>> ---[ end trace fb8a4add69562a76 ]---
>>
>> The xfs_iflush_fork+0x181/0x240 (385) IP address is at:
>>
> (rearrange slightly to make more sense)
>
>> 823        case XFS_DINODE_FMT_LOCAL:
>> 824            if ((iip->ili_fields&  dataflag[whichfork])&&
>>     0x00000000000023c0<+336>:    movslq %ecx,%rcx
>>     0x00000000000023c3<+339>:    movswl 0x0(%rcx,%rcx,1),%eax
>>     0x00000000000023cb<+347>:    test   %eax,0x90(%rdx)
>>     0x00000000000023d1<+353>:    je     0x2350<xfs_iflush_fork+224>
>>
>> 825                (ifp->if_bytes>  0)) {
>>     0x00000000000023d7<+359>:    mov    (%r10),%edx
>>     0x00000000000023da<+362>:    test   %edx,%edx
>>     0x00000000000023dc<+364>:    jle    0x2350<xfs_iflush_fork+224>
> So the contents of rdx says that the inode fork size is 6 bytes in
> local format. The call location also indicates that it is the
> attribute fork that is in being flushed. The minimum size of the
> attr fork is 3 bytes - an empty header. However, then ext valid size
> has a second header that adds 4 bytes to the size, plus the bytes
> inteh attr name and value.
>
> Hence a size of 6 bytes is invalid, and probably indicates that
> there is some form of memory corruption going on here.
>
> IIRC, we haven't touched this code for a while - can you test 3.19
> and see if it has the same problem? If it doesn't have the problem,
> and given you can reliably reproduce the crash, can you run a
> bisect to find the cause?

I have done the bisection and the following commit in 3.13 is the one 
that cause the problem, I think:

f7be2d7f594cbc7a00902b5427332a1ad519a528
xfs: push down inactive transaction mgmt for truncate

I looked at the patch, and it didn't seem quite right, but I don't know 
much about the XFS internal to be sure. Maybe you can take a look at that.

Cheers,
Longman


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
