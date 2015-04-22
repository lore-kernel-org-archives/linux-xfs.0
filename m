Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1631B7F3F
	for <xfs@oss.sgi.com>; Wed, 22 Apr 2015 12:45:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9FE34AC002
	for <xfs@oss.sgi.com>; Wed, 22 Apr 2015 10:45:26 -0700 (PDT)
Received: from g1t5424.austin.hp.com (g1t5424.austin.hp.com [15.216.225.54])
	by cuda.sgi.com with ESMTP id GcYHEzPnpU95yZuH (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 22 Apr 2015 10:45:24 -0700 (PDT)
Message-ID: <5537DE31.3030609@hp.com>
Date: Wed, 22 Apr 2015 13:45:21 -0400
From: Waiman Long <waiman.long@hp.com>
MIME-Version: 1.0
Subject: Re: 4.0 kernel XFS filesystem crash when running AIM7's disk workload
References: <55314529.7060202@hp.com> <20150417234541.GG21261@dastard>
	<5536B895.1040107@hp.com> <20150421215927.GK21261@dastard>
In-Reply-To: <20150421215927.GK21261@dastard>
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

On 04/21/2015 05:59 PM, Dave Chinner wrote:
> On Tue, Apr 21, 2015 at 04:52:37PM -0400, Waiman Long wrote:
>> On 04/17/2015 07:45 PM, Dave Chinner wrote:
>>> On Fri, Apr 17, 2015 at 01:38:49PM -0400, Waiman Long wrote:
>>>> Hi Dave,
>>>>
>>>> When I was running the AIM7's disk workload on a 8-socket
>>>> Westmere-EX server with 4.0 kernel, the kernel crash. A set of small
>>>> ramdisks were created (ramdisk_size=271072). Those ramdisks were
>>>> formatted with XFS filesystem before the test began. The kernel log
>>>> was:
>>>>
>>>> XFS (ram12): Mounting V4 Filesystem
>>>> XFS (ram12): Log size 1424 blocks too small, minimum size is 1596 blocks
>>>> XFS (ram12): Log size out of supported range. Continuing onwards,
>>>> but if log hangs are
>>>> experienced then please report this message in the bug report.
>>> First thing you need to do is upgrade xfsprogs so that this message
>>> goes away. or use "mkfs.xfs -l size=10m" so that the log is larger
>>> than the minimum.
>>>
>>>> XFS (ram15): Ending clean mount
>>>> BUG: unable to handle kernel NULL pointer dereference at           (null)
>>>> IP: [<ffffffff812abd6d>] __memcpy+0xd/0x110
>>>> PGD 29f7655f067 PUD 29f75a80067 PMD 0
>>>> Oops: 0000 [#1] SMP
>>>> Modules linked in: xfs exportfs libcrc32c ebtable_nat ebtables
>>>> xt_CHECKSUM iptable_mangle bridge stp llc autofs4 ipt_REJECT
>>>> nf_reject_ipv4 nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter
>>>> ip_tables ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6
>>>> nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6
>>>> vhost_net macvtap macvlan vhost tun kvm_intel kvm ipmi_si
>>>> ipmi_msghandler tpm_infineon iTCO_wdt iTCO_vendor_support wmi
>>>> acpi_cpufreq microcode pcspkr serio_raw qlcnic be2net vxlan
>>>> udp_tunnel ip6_udp_tunnel ses enclosure igb dca ptp pps_core lpc_ich
>>>> mfd_core hpilo hpwdt sg i7core_edac edac_core netxen_nic ext4(E)
>>>> jbd2(E) mbcache(E) sr_mod(E) cdrom(E) sd_mod(E) lpfc(E) qla2xxx(E)
>>>> scsi_transport_fc(E) pata_acpi(E) ata_generic(E) ata_piix(E) hpsa(E)
>>>> radeon(E) ttm(E) drm_kms_helper(E) drm(E) i2c_algo_bit(E)
>>>> i2c_core(E) dm_mirror(E) dm_region_hash(E) dm_log(E) dm_mod(E)
>>> Why do you have a mix of signed and unsigned modules loaded?
>> I did the test on a RHEL 6.6 system. The 4.0 kernel is unsigned, but
>> there are some additional RHEL modules loaded at boot up time.
> Wait, what?
>
> Do you have rhel 6.6 modules loaded into a 4.0 kernel? If so, I'd
> suggest you fix things so that doesn't happen before running any
> more tests...

No, I didn't. I thought the system startup scripts may have loaded some 
additional kernel modules, but I didn't check to see if it is really the 
case. Anyway, this is not the issue that was causing problem that I saw.


>>> 823        case XFS_DINODE_FMT_LOCAL:
>>> 824            if ((iip->ili_fields&   dataflag[whichfork])&&
>>>     0x00000000000023c0<+336>:    movslq %ecx,%rcx
>>>     0x00000000000023c3<+339>:    movswl 0x0(%rcx,%rcx,1),%eax
>>>     0x00000000000023cb<+347>:    test   %eax,0x90(%rdx)
>>>     0x00000000000023d1<+353>:    je     0x2350<xfs_iflush_fork+224>
>>>
>>> 825                (ifp->if_bytes>   0)) {
>>>     0x00000000000023d7<+359>:    mov    (%r10),%edx
>>>     0x00000000000023da<+362>:    test   %edx,%edx
>>>     0x00000000000023dc<+364>:    jle    0x2350<xfs_iflush_fork+224>
>>> So the contents of rdx says that the inode fork size is 6 bytes in
>>> local format. The call location also indicates that it is the
>>> attribute fork that is in being flushed. The minimum size of the
>>> attr fork is 3 bytes - an empty header. However, then ext valid size
>>> has a second header that adds 4 bytes to the size, plus the bytes
>>> inteh attr name and value.
>>>
>>> Hence a size of 6 bytes is invalid, and probably indicates that
>>> there is some form of memory corruption going on here.
>>>
>>> IIRC, we haven't touched this code for a while - can you test 3.19
>>> and see if it has the same problem? If it doesn't have the problem,
>>> and given you can reliably reproduce the crash, can you run a
>>> bisect to find the cause?
>> I have done the bisection and the following commit in 3.13 is the
>> one that cause the problem, I think:
>>
>> f7be2d7f594cbc7a00902b5427332a1ad519a528
>> xfs: push down inactive transaction mgmt for truncate
>>
>> I looked at the patch, and it didn't seem quite right,
> In what way?
>
>> but I don't
>> know much about the XFS internal to be sure. Maybe you can take a
>> look at that.
> Doesn't actually seem very likely - that's mostly just a factoring
> patch, and it is called on every inode that is reclaimed from
> memory, so it's not like that code path doesn't get well tested....
>
> So, I'm confused - I thought you were reporting a recent regression.
> Are you actually reporting a regression between a RHEL 6.6 kernel
> and the current mainline kernel?  Is this the first time you've run
> this test on XFS on a kernel more recent than RHEL6.6?
>
> Details, please; they are important.
>
> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
>
> Cheers,
>
> Dave.

I have just sent out a patch to fix this problem. Please let me know if 
there is any problem with the patch.

Cheers,
Longman

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
