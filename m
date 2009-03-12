Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2CIp0Gt093974 for <xfs@oss.sgi.com>; Thu, 12 Mar 2009 13:51:20 -0500
Received: from idcmail-mo1so.shaw.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4E5921C3AA1E
	for <xfs@oss.sgi.com>; Thu, 12 Mar 2009 11:50:16 -0700 (PDT)
Received: from idcmail-mo1so.shaw.ca (idcmail-mo1so.shaw.ca [24.71.223.10]) by
	cuda.sgi.com with ESMTP id cgx0inihISv86DzK for
	<xfs@oss.sgi.com>; Thu, 12 Mar 2009 11:50:16 -0700 (PDT)
Received: from squirrel.kevinjamieson.com (localhost [127.0.0.1])
	by mail.kevinjamieson.com (Postfix) with ESMTP id 5FA6020146
	for <xfs@oss.sgi.com>; Thu, 12 Mar 2009 11:50:14 -0700 (PDT)
Message-ID: <64323.24.80.224.145.1236883814.squirrel@squirrel.kevinjamieson.com>
Date: Thu, 12 Mar 2009 11:50:14 -0700 (PDT)
Subject: Oops at xfs_bmbt_get_startoff in SLES 10 2.6.16
From: "Kevin Jamieson" <kevin@kevinjamieson.com>
MIME-Version: 1.0
Reply-To: kevin@kevinjamieson.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hello,

We have triggered the below oops in XFS several times on the SLES 10 SP2
kernel (2.6.16.60-0.21-smp). We've also seen it on earlier SLES 10 kernels
(2.6.16.21-0.8-smp).

The oops seems to occur with an application that backs up largish (~ 1GB)
files to the XFS file system over NFS, although it is not easily
reproducible (it happens about once a week on our test system). We have
run xfs_repair a few times afterwards, and it did not detect any problems
with the file system.

We will be reporting this to Novell support, of course, but I thought I'd
post it here too in case anyone had any ideas or has seen this before.

Thanks,
Kevin

Mar 11 13:10:26 gn1 kernel: Unable to handle kernel paging request at
virtual address 0301c39c
Mar 11 13:10:26 gn1 kernel:  printing eip:
Mar 11 13:10:26 gn1 kernel: f95899ab
Mar 11 13:10:26 gn1 kernel: *pde = 00000000
Mar 11 13:10:26 gn1 kernel: Oops: 0000 [#1]
Mar 11 13:10:26 gn1 kernel: SMP
Mar 11 13:10:26 gn1 kernel: last sysfs file:
/devices/pci0000:00/0000:00:06.0/0000:17:00.0/host1/target1:0:3/1:0:3:0/type
Mar 11 13:10:26 gn1 kernel: Modules linked in: nfsd exportfs lockd nfs_acl
sunrpc af_packet xfs_quota sg qla2xxx_conf qla2xxx intermodule bnx2
xt_pkttype ipt_LOG xt_limit bonding ip6t_REJECT xt_tcpudp ipt_REJECT
xt_state iptable_ma
ngle iptable_nat ip_nat iptable_filter ip6table_mangle ip_conntrack
nfnetlink ip_tables ip6table_filter ip6_tables x_tables ipv6 loop
xfs_dmapi xfs dmapi dm_mod usbhid hw_random shpchp pci_hotplug uhci_hcd
ehci_hcd ide_cd cdrom usbcore e10
00 ext3 jbd ata_piix ahci libata edd fan thermal processor firmware_class
scsi_transport_fc cciss piix sd_mod scsi_mod ide_disk ide_core
Mar 11 13:10:26 gn1 kernel: CPU:    0
Mar 11 13:10:26 gn1 kernel: EIP:    0060:[<f95899ab>]    Tainted: G     U VLI
Mar 11 13:10:26 gn1 kernel: EFLAGS: 00010202   (2.6.16.60-0.21-smp #1)
Mar 11 13:10:26 gn1 kernel: EIP is at xfs_bmbt_get_startoff+0x2/0x15 [xfs]
Mar 11 13:10:26 gn1 kernel: eax: 0301c398   ebx: ec9fc6d0   ecx: 0301c398 
 edx: 00001c39
Mar 11 13:10:26 gn1 kernel: esi: ec9fc680   edi: 0301c398   ebp: d9c1fe40 
 esp: d9c1fe24
Mar 11 13:10:26 gn1 kernel: ds: 007b   es: 007b   ss: 0068
Mar 11 13:10:26 gn1 kernel: Process nfsd (pid: 2178, threadinfo=d9c1e000
task=dfc80910)
Mar 11 13:10:26 gn1 kernel: Stack: <0>f957eb34 ec9fc680 ec9fc680 f651b000
00000000 f95a2f4e 00000000 dfc80910
Mar 11 13:10:26 gn1 kernel:        00100100 ec9fc680 ec9fc680 2f14a000
f95a3045 00000001 d0bcd800 ec9fc680
Mar 11 13:10:26 gn1 kernel:        00000000 0002f14a 00000000 f95bae44
2f14a000 00000000 00000fff 00000000
Mar 11 13:10:26 gn1 kernel: Call Trace:
Mar 11 13:10:26 gn1 kernel:  [<f957eb34>] xfs_bmap_last_offset+0xc0/0xdc
[xfs]
Mar 11 13:10:26 gn1 kernel:  [<f95a2f4e>] xfs_file_last_byte+0x1e/0xbc [xfs]
Mar 11 13:10:26 gn1 kernel:  [<f95a3045>] xfs_itruncate_start+0x59/0xa8 [xfs]
Mar 11 13:10:26 gn1 kernel:  [<f95bae44>] xfs_free_eofblocks+0x17a/0x276
[xfs]
Mar 11 13:10:26 gn1 kernel:  [<f95bf921>] xfs_release+0x115/0x175 [xfs]
Mar 11 13:10:26 gn1 kernel:  [<f95c51e7>] xfs_file_release+0x13/0x1a [xfs]
Mar 11 13:10:26 gn1 kernel:  [<c01645cd>] __fput+0x9d/0x170
Mar 11 13:10:26 gn1 kernel:  [<f9b588be>] nfsd_write+0xb6/0xbf [nfsd]
Mar 11 13:10:26 gn1 kernel:  [<f9b5ee1a>] nfsd3_proc_write+0xd0/0xe7 [nfsd]
Mar 11 13:10:26 gn1 kernel:  [<f973c76b>] svcauth_unix_accept+0xe1/0x18e
[sunrpc]
Mar 11 13:10:26 gn1 kernel:  [<f9b550cb>] nfsd_dispatch+0xbb/0x16c [nfsd]
Mar 11 13:10:26 gn1 kernel:  [<f9739518>] svc_process+0x388/0x616 [sunrpc]
Mar 11 13:10:26 gn1 kernel:  [<f9b55578>] nfsd+0x197/0x2ff [nfsd]
Mar 11 13:10:26 gn1 kernel:  [<f9b553e1>] nfsd+0x0/0x2ff [nfsd]
Mar 11 13:10:26 gn1 kernel:  [<c0102005>] kernel_thread_helper+0x5/0xb
Mar 11 13:10:26 gn1 kernel: Code: 53 89 c1 8b 00 31 d2 8b 59 0c 8b 49 08
25 ff 01 00 00 89 c2 b8 00 00 00 00 0f ac d9 15 c1 e2 0b 09 c8 c1 eb 15 09
da 5b c3 89 c1 <8b> 51 04 8b 00 81 e2 ff ff ff 7f 0f ac d0 09 c1 ea 09 c3
57 56

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
