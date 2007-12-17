Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 17 Dec 2007 05:39:15 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBHDd4ZS008206
	for <xfs@oss.sgi.com>; Mon, 17 Dec 2007 05:39:06 -0800
Received: from sargon.lncsa.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 99B6248F54D
	for <xfs@oss.sgi.com>; Mon, 17 Dec 2007 05:39:11 -0800 (PST)
Received: from sargon.lncsa.com (sargon.lncsa.com [212.99.8.251]) by cuda.sgi.com with ESMTP id k1Krrb3pUZ8GFTBl for <xfs@oss.sgi.com>; Mon, 17 Dec 2007 05:39:11 -0800 (PST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by sargon.lncsa.com (Postfix) with ESMTP id DEB223026401
	for <xfs@oss.sgi.com>; Mon, 17 Dec 2007 14:39:07 +0100 (CET)
Received: from sargon.lncsa.com ([127.0.0.1])
	by localhost (sargon.lncsa.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2l8Z8xzLdFi5 for <xfs@oss.sgi.com>;
	Mon, 17 Dec 2007 14:39:07 +0100 (CET)
Date: Mon, 17 Dec 2007 14:39:07 +0100
From: Laurent Caron <lcaron@lncsa.com>
Subject: Issue with 2.6.23 and drbd 8.0.7
Message-ID: <20071217143655.chiehahh@trusted.lncsa.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


Hi,

I'm still experiencing a strange behavior on one of my DRBD setup.

It basically consists in:

2 servers with XFS filesystems on top of DRBD, itself on top of MD (aka
soft raid).

The two servers exhibit the same behavior. This strange behavior might
appear between 1 day and 3 weeks after having started the machines.

Slab debugging is turned on.
CONFIG_SLAB=y
CONFIG_DEBUG_SLAB=y
CONFIG_DEBUG_SLAB_LEAK=y

Do anyone have a clue about that problem?

I already posted about it some time ago, and was asked to turn slab debugging on.

Thanks

Laurent

----------------------------------------------------------------------------
$ lspci
00:00.0 Host bridge: Intel Corporation 5000P Chipset Memory Controller Hub (rev b1)
00:02.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x4 Port 2 (rev b1)
00:03.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x4 Port 3 (rev b1)
00:04.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x8 Port 4-5 (rev b1)
00:05.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x4 Port 5 (rev b1)
00:06.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x8 Port 6-7 (rev b1)
00:07.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x4 Port 7 (rev b1)
00:10.0 Host bridge: Intel Corporation 5000 Series Chipset FSB Registers (rev b1)
00:10.1 Host bridge: Intel Corporation 5000 Series Chipset FSB Registers (rev b1)
00:10.2 Host bridge: Intel Corporation 5000 Series Chipset FSB Registers (rev b1)
00:11.0 Host bridge: Intel Corporation 5000 Series Chipset Reserved Registers (rev b1)
00:13.0 Host bridge: Intel Corporation 5000 Series Chipset Reserved Registers (rev b1)
00:15.0 Host bridge: Intel Corporation 5000 Series Chipset FBD Registers (rev b1)
00:16.0 Host bridge: Intel Corporation 5000 Series Chipset FBD Registers (rev b1)
00:1c.0 PCI bridge: Intel Corporation 631xESB/632xESB/3100 Chipset PCI Express Root Port 1 (rev 09)
00:1c.1 PCI bridge: Intel Corporation 631xESB/632xESB/3100 Chipset PCI Express Root Port 2 (rev 09)
00:1d.0 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset UHCI USB Controller #1 (rev 09)
00:1d.1 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset UHCI USB Controller #2 (rev 09)
00:1d.2 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset UHCI USB Controller #3 (rev 09)
00:1d.3 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset UHCI USB Controller #4 (rev 09)
00:1d.7 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset EHCI USB2 Controller (rev 09)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev d9)
00:1f.0 ISA bridge: Intel Corporation 631xESB/632xESB/3100 Chipset LPC Interface Controller (rev 09)
00:1f.1 IDE interface: Intel Corporation 631xESB/632xESB IDE Controller (rev 09)
01:03.0 VGA compatible controller: ATI Technologies Inc ES1000 (rev 02)
01:04.0 System peripheral: Compaq Computer Corporation Integrated Lights Out Controller (rev 03)
01:04.2 System peripheral: Compaq Computer Corporation Integrated Lights Out  Processor (rev 03)
01:04.4 USB Controller: Hewlett-Packard Company Proliant iLO2 virtual USB controller
01:04.6 IPMI SMIC interface: Hewlett-Packard Company Proliant iLO2 virtual UART
02:00.0 PCI bridge: Broadcom EPB PCI-Express to PCI-X Bridge (rev c3)
03:00.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5708 Gigabit Ethernet (rev 12)
04:00.0 PCI bridge: Broadcom EPB PCI-Express to PCI-X Bridge (rev c3)
05:00.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5708 Gigabit Ethernet (rev 12)
06:00.0 RAID bus controller: Hewlett-Packard Company Smart Array Controller (rev 01)
09:00.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express Upstream Port (rev 01)
09:00.3 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express to PCI-X Bridge (rev 01)
0a:00.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express Downstream Port E1 (rev 01)
0a:01.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express Downstream Port E2 (rev 01)
0a:02.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express Downstream Port E3 (rev 01)
11:00.0 PCI bridge: Intel Corporation 6702PXH PCI Express-to-PCI Bridge A (rev 09)
12:01.0 PCI bridge: Pericom Semiconductor PI7C21P100 PCI to PCI Bridge (rev 01)
13:04.0 Ethernet controller: Intel Corporation 82546GB Gigabit Ethernet Controller (Copper) (rev 03)
13:04.1 Ethernet controller: Intel Corporation 82546GB Gigabit Ethernet Controller (Copper) (rev 03)
13:06.0 Ethernet controller: Intel Corporation 82546GB Gigabit Ethernet Controller (Copper) (rev 03)
13:06.1 Ethernet controller: Intel Corporation 82546GB Gigabit Ethernet Controller (Copper) (rev 03)
-----------------------------------------------------------------------------

$ cat /etc/sysctl.conf
net.ipv4.tcp_syncookies=0
net.ipv4.conf.default.forwarding=1
kernel.shmall = 2097152
kernel.shmmax = 1147483648
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.ipv4.tcp_rmem = 8192 174760 2097152
net.ipv4.tcp_wmem = 8192 174760 2097152
net.ipv4.tcp_window_scaling = 0
net.ipv4.tcp_ecn=0
vm.swappiness = 60
vm.dirty_background_ratio = 3
vm.dirty_ratio = 40
-----------------------------------------------------------------------------

$ grep -i xfs /var/log/syslog | wc -l
138
------------------------------------------------------------------------------

$ cat /proc/drbd
version: 8.0.7 (api:86/proto:86)
GIT-hash: cf14288833afe95db396075f8530a5960d29e498 build by root@picsou, 2007-11-27 17:02:26
 0: cs:Connected st:Primary/Secondary ds:UpToDate/UpToDate C r---
    ns:155783300 nr:0 dw:155790066 dr:550407420 al:5567705 bm:2877 lo:0 pe:0 ua:0 ap:0
        resync: used:0/31 hits:13073 misses:1356 starving:0 dirty:0 changed:1356
        act_log: used:0/509 hits:36066841 misses:7287481 starving:0 dirty:1719776 changed:5567705
------------------------------------------------------------------------------
$ cat /var/log/syslog (partial)
Dec 16 01:12:25 mailserver-1 kernel: CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 01:12:25 mailserver-1 kernel: CPU    4: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 01:12:25 mailserver-1 kernel: CPU    5: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 01:12:25 mailserver-1 kernel: CPU    6: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 01:12:25 mailserver-1 kernel: CPU    7: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 01:12:25 mailserver-1 kernel: Normal per-cpu:
Dec 16 01:12:25 mailserver-1 kernel: CPU    0: Hot: hi:  186, btch:  31 usd:  35   Cold: hi:   62, btch:  15 usd:  56
Dec 16 01:12:25 mailserver-1 kernel: CPU    1: Hot: hi:  186, btch:  31 usd:  12   Cold: hi:   62, btch:  15 usd:  57
Dec 16 01:12:25 mailserver-1 kernel: CPU    2: Hot: hi:  186, btch:  31 usd:   1   Cold: hi:   62, btch:  15 usd:  57
Dec 16 01:12:27 mailserver-1 kernel: CPU    3: Hot: hi:  186, btch:  31 usd:  92   Cold: hi:   62, btch:  15 usd:  53
Dec 16 01:12:27 mailserver-1 kernel: CPU    4: Hot: hi:  186, btch:  31 usd:   7   Cold: hi:   62, btch:  15 usd:  52
Dec 16 01:12:27 mailserver-1 kernel: CPU    5: Hot: hi:  186, btch:  31 usd:  18   Cold: hi:   62, btch:  15 usd:  51
Dec 16 01:12:27 mailserver-1 kernel: CPU    6: Hot: hi:  186, btch:  31 usd:  37   Cold: hi:   62, btch:  15 usd:  48
Dec 16 01:12:27 mailserver-1 kernel: CPU    7: Hot: hi:  186, btch:  31 usd:  12   Cold: hi:   62, btch:  15 usd:  49
Dec 16 01:12:27 mailserver-1 kernel: HighMem per-cpu:
Dec 16 01:12:27 mailserver-1 kernel: CPU    0: Hot: hi:  186, btch:  31 usd: 130   Cold: hi:   62, btch:  15 usd:   8
Dec 16 01:12:27 mailserver-1 kernel: CPU    1: Hot: hi:  186, btch:  31 usd:  13   Cold: hi:   62, btch:  15 usd:   9
Dec 16 01:12:27 mailserver-1 kernel: CPU    2: Hot: hi:  186, btch:  31 usd:   7   Cold: hi:   62, btch:  15 usd:   5
Dec 16 01:12:27 mailserver-1 kernel: CPU    3: Hot: hi:  186, btch:  31 usd: 182   Cold: hi:   62, btch:  15 usd:   5
Dec 16 01:12:27 mailserver-1 kernel: CPU    4: Hot: hi:  186, btch:  31 usd:  36   Cold: hi:   62, btch:  15 usd:  14
Dec 16 01:12:27 mailserver-1 kernel: CPU    5: Hot: hi:  186, btch:  31 usd:  42   Cold: hi:   62, btch:  15 usd:   8
Dec 16 01:12:27 mailserver-1 kernel: CPU    6: Hot: hi:  186, btch:  31 usd: 159   Cold: hi:   62, btch:  15 usd:   8
Dec 16 01:12:27 mailserver-1 kernel: CPU    7: Hot: hi:  186, btch:  31 usd:  42   Cold: hi:   62, btch:  15 usd:  14
Dec 16 01:12:27 mailserver-1 kernel: Active:503378 inactive:8864 dirty:159 writeback:0 unstable:0
Dec 16 01:12:27 mailserver-1 kernel: free:2397083 slab:24412 mapped:6930 pagetables:2002 bounce:0
Dec 16 01:12:27 mailserver-1 kernel: DMA free:3532kB min:68kB low:84kB high:100kB active:0kB inactive:0kB present:16256kB pages_scanned:20 all_unreclaimable? yes
Dec 16 01:12:27 mailserver-1 kernel: lowmem_reserve[]: 0 873 12938 12938
Dec 16 01:12:27 mailserver-1 kernel: Normal free:3692kB min:3744kB low:4680kB high:5616kB active:64kB inactive:0kB present:894080kB pages_scanned:13 all_unreclaimable? no
Dec 16 01:12:27 mailserver-1 kernel: lowmem_reserve[]: 0 0 96520 96520
Dec 16 01:12:27 mailserver-1 kernel: HighMem free:9581108kB min:512kB low:13456kB high:26404kB active:2013452kB inactive:35524kB present:12354560kB pages_scanned:0 all_unreclaimable? no
Dec 16 01:12:27 mailserver-1 kernel: lowmem_reserve[]: 0 0 0 0
Dec 16 01:12:27 mailserver-1 kernel: DMA: 5*4kB 11*8kB 7*16kB 2*32kB 2*64kB 0*128kB 0*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3484kB
Dec 16 01:12:27 mailserver-1 kernel: Normal: 195*4kB 82*8kB 5*16kB 9*32kB 1*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 3788kB
Dec 16 01:12:27 mailserver-1 kernel: HighMem: 37376*4kB 104969*8kB 97167*16kB 61944*32kB 34197*64kB 13138*128kB 3479*256kB 502*512kB 24*1024kB 2*2048kB 2*4096kB = 9580920kB
Dec 16 01:12:27 mailserver-1 kernel: Swap cache: add 28, delete 28, find 0/0, race 0+0
Dec 16 01:12:27 mailserver-1 kernel: Free swap  = 1441668kB
Dec 16 01:12:27 mailserver-1 kernel: Total swap = 1441776kB
Dec 16 01:12:27 mailserver-1 kernel: Free swap:       1441668kB
Dec 16 01:12:27 mailserver-1 kernel: syslog-ng invoked oom-killer: gfp_mask=0xd0, order=0, oomkilladj=0
Dec 16 01:12:27 mailserver-1 kernel: [<c01511e9>] out_of_memory+0x69/0x1a4
Dec 16 01:12:27 mailserver-1 kernel: [<c01528d7>] __alloc_pages+0x20a/0x291
Dec 16 01:12:27 mailserver-1 kernel: [<c012bd38>] __capable+0xc/0x1f
Dec 16 01:12:27 mailserver-1 kernel: [<c0152997>] __get_free_pages+0x39/0x47
Dec 16 01:12:27 mailserver-1 kernel: [<c0177f78>] __pollwait+0x44/0xac
Dec 16 01:12:27 mailserver-1 kernel: [<c0328bda>] unix_poll+0x17/0x8b
Dec 16 01:12:27 mailserver-1 kernel: [<c02cdd68>] sock_poll+0xc/0xe
Dec 16 01:12:27 mailserver-1 kernel: [<c01774f8>] do_sys_poll+0x19a/0x327
Dec 16 01:12:27 mailserver-1 kernel: [<c0177f34>] __pollwait+0x0/0xac
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c01776b9>] sys_poll+0x34/0x37
Dec 16 01:12:27 mailserver-1 kernel: [<c0103e0e>] sysenter_past_esp+0x6b/0xa1
Dec 16 01:12:27 mailserver-1 kernel: =======================
Dec 16 01:12:27 mailserver-1 kernel: Mem-info:
Dec 16 01:12:27 mailserver-1 kernel: DMA per-cpu:
Dec 16 01:12:27 mailserver-1 kernel: CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 01:12:27 mailserver-1 kernel: CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 01:12:27 mailserver-1 kernel: CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 01:12:27 mailserver-1 kernel: CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 01:12:27 mailserver-1 kernel: CPU    4: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 01:12:27 mailserver-1 kernel: CPU    5: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 01:12:27 mailserver-1 kernel: CPU    6: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 01:12:27 mailserver-1 kernel: CPU    7: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 01:12:27 mailserver-1 kernel: Normal per-cpu:
Dec 16 01:12:27 mailserver-1 kernel: CPU    0: Hot: hi:  186, btch:  31 usd:  35   Cold: hi:   62, btch:  15 usd:  56
Dec 16 01:12:27 mailserver-1 kernel: CPU    1: Hot: hi:  186, btch:  31 usd:  12   Cold: hi:   62, btch:  15 usd:  57
Dec 16 01:12:27 mailserver-1 kernel: CPU    2: Hot: hi:  186, btch:  31 usd:   1   Cold: hi:   62, btch:  15 usd:  57
Dec 16 01:12:27 mailserver-1 kernel: CPU    3: Hot: hi:  186, btch:  31 usd:  92   Cold: hi:   62, btch:  15 usd:  53
Dec 16 01:12:27 mailserver-1 kernel: CPU    4: Hot: hi:  186, btch:  31 usd:   7   Cold: hi:   62, btch:  15 usd:  52
Dec 16 01:12:27 mailserver-1 kernel: CPU    5: Hot: hi:  186, btch:  31 usd:  18   Cold: hi:   62, btch:  15 usd:  53
Dec 16 01:12:27 mailserver-1 kernel: CPU    6: Hot: hi:  186, btch:  31 usd:  37   Cold: hi:   62, btch:  15 usd:  48
Dec 16 01:12:27 mailserver-1 kernel: CPU    7: Hot: hi:  186, btch:  31 usd:  12   Cold: hi:   62, btch:  15 usd:  49
Dec 16 01:12:27 mailserver-1 kernel: HighMem per-cpu:
Dec 16 01:12:27 mailserver-1 kernel: CPU    0: Hot: hi:  186, btch:  31 usd: 130   Cold: hi:   62, btch:  15 usd:   8
Dec 16 01:12:27 mailserver-1 kernel: CPU    1: Hot: hi:  186, btch:  31 usd:  13   Cold: hi:   62, btch:  15 usd:   9
Dec 16 01:12:27 mailserver-1 kernel: CPU    2: Hot: hi:  186, btch:  31 usd:   7   Cold: hi:   62, btch:  15 usd:   5
Dec 16 01:12:27 mailserver-1 kernel: CPU    3: Hot: hi:  186, btch:  31 usd: 182   Cold: hi:   62, btch:  15 usd:   5
Dec 16 01:12:27 mailserver-1 kernel: CPU    4: Hot: hi:  186, btch:  31 usd:  36   Cold: hi:   62, btch:  15 usd:  14
Dec 16 01:12:27 mailserver-1 kernel: CPU    5: Hot: hi:  186, btch:  31 usd:  42   Cold: hi:   62, btch:  15 usd:   8
Dec 16 01:12:27 mailserver-1 kernel: CPU    6: Hot: hi:  186, btch:  31 usd: 159   Cold: hi:   62, btch:  15 usd:   8
Dec 16 01:12:27 mailserver-1 kernel: CPU    7: Hot: hi:  186, btch:  31 usd:  42   Cold: hi:   62, btch:  15 usd:  14
Dec 16 01:12:27 mailserver-1 kernel: Active:503378 inactive:8864 dirty:159 writeback:0 unstable:0
Dec 16 01:12:27 mailserver-1 kernel: free:2397083 slab:24412 mapped:6930 pagetables:2002 bounce:0
Dec 16 01:12:27 mailserver-1 kernel: DMA free:3532kB min:68kB low:84kB high:100kB active:0kB inactive:0kB present:16256kB pages_scanned:20 all_unreclaimable? yes
Dec 16 01:12:27 mailserver-1 kernel: lowmem_reserve[]: 0 873 12938 12938
Dec 16 01:12:27 mailserver-1 kernel: Normal free:3692kB min:3744kB low:4680kB high:5616kB active:64kB inactive:0kB present:894080kB pages_scanned:130 all_unreclaimable? yes
Dec 16 01:12:27 mailserver-1 kernel: lowmem_reserve[]: 0 0 96520 96520
Dec 16 01:12:27 mailserver-1 kernel: HighMem free:9581108kB min:512kB low:13456kB high:26404kB active:2013452kB inactive:35524kB present:12354560kB pages_scanned:0 all_unreclaimable? no
Dec 16 01:12:27 mailserver-1 kernel: lowmem_reserve[]: 0 0 0 0
Dec 16 01:12:27 mailserver-1 kernel: DMA: 5*4kB 11*8kB 7*16kB 2*32kB 2*64kB 0*128kB 0*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3484kB
Dec 16 01:12:27 mailserver-1 kernel: Normal: 195*4kB 82*8kB 5*16kB 9*32kB 1*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 3788kB
Dec 16 01:12:27 mailserver-1 kernel: HighMem: 37376*4kB 104969*8kB 97167*16kB 61944*32kB 34197*64kB 13138*128kB 3479*256kB 502*512kB 24*1024kB 2*2048kB 2*4096kB = 9580920kB
Dec 16 01:12:27 mailserver-1 kernel: Swap cache: add 28, delete 28, find 0/0, race 0+0
Dec 16 01:12:27 mailserver-1 kernel: Free swap  = 1441668kB
Dec 16 01:12:27 mailserver-1 kernel: Total swap = 1441776kB
Dec 16 01:12:27 mailserver-1 kernel: Free swap:       1441668kB
Dec 16 01:12:27 mailserver-1 kernel: 3342335 pages of RAM
Dec 16 01:12:27 mailserver-1 kernel: 3112959 pages of HIGHMEM
Dec 16 01:12:27 mailserver-1 kernel: 224378 reserved pages
Dec 16 01:12:27 mailserver-1 kernel: 230264 pages shared
Dec 16 01:12:27 mailserver-1 kernel: 0 pages swap cached
Dec 16 01:12:27 mailserver-1 kernel: 159 pages dirty
Dec 16 01:12:27 mailserver-1 kernel: 0 pages writeback
Dec 16 01:12:27 mailserver-1 kernel: 6930 pages mapped
Dec 16 01:12:27 mailserver-1 kernel: 24412 pages slab
Dec 16 01:12:27 mailserver-1 kernel: 2002 pages pagetables
Dec 16 01:12:27 mailserver-1 kernel: Out of memory: kill process 18429 (spamd) score 13454 or a child
Dec 16 01:12:27 mailserver-1 kernel: Killed process 18429 (spamd)
Dec 16 01:12:27 mailserver-1 kernel: 3342335 pages of RAM
Dec 16 01:12:27 mailserver-1 kernel: 3112959 pages of HIGHMEM
Dec 16 01:12:27 mailserver-1 kernel: 224378 reserved pages
Dec 16 01:12:27 mailserver-1 kernel: 225585 pages shared
Dec 16 01:12:27 mailserver-1 kernel: 0 pages swap cached
Dec 16 01:12:27 mailserver-1 kernel: 159 pages dirty
Dec 16 01:12:27 mailserver-1 kernel: 0 pages writeback
Dec 16 01:12:27 mailserver-1 kernel: 6930 pages mapped
Dec 16 01:12:27 mailserver-1 kernel: 24412 pages slab
Dec 16 01:12:27 mailserver-1 kernel: 1953 pages pagetables
Dec 16 01:12:27 mailserver-1 kernel: Out of memory: kill process 12086 (spamd) score 13244 or a child
Dec 16 01:12:27 mailserver-1 kernel: Killed process 12086 (spamd)
Dec 16 01:12:27 mailserver-1 kernel: named invoked oom-killer: gfp_mask=0xd0, order=0, oomkilladj=0
Dec 16 01:12:27 mailserver-1 kernel: [<c01511e9>] out_of_memory+0x69/0x1a4
Dec 16 01:12:27 mailserver-1 kernel: [<c01528d7>] __alloc_pages+0x20a/0x291
Dec 16 01:12:27 mailserver-1 kernel: [<c0152997>] __get_free_pages+0x39/0x47
Dec 16 01:12:27 mailserver-1 kernel: [<c0177f78>] __pollwait+0x44/0xac
Dec 16 01:12:27 mailserver-1 kernel: [<c02d58bc>] datagram_poll+0x14/0xb1
Dec 16 01:12:27 mailserver-1 kernel: [<c03103ed>] udp_poll+0x10/0xd5
Dec 16 01:12:27 mailserver-1 kernel: [<c02cdd68>] sock_poll+0xc/0xe
Dec 16 01:12:27 mailserver-1 kernel: [<c01778e5>] do_select+0x229/0x3c9
Dec 16 01:12:27 mailserver-1 kernel: [<c0177f34>] __pollwait+0x0/0xac
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0177d0a>] core_sys_select+0x285/0x2a2
Dec 16 01:12:27 mailserver-1 kernel: [<c011e9f4>] __wake_up+0x32/0x43
Dec 16 01:12:27 mailserver-1 kernel: [<c013dcf9>] wake_futex+0x3b/0x45
Dec 16 01:12:27 mailserver-1 kernel: [<c013ee5a>] futex_wake+0xa5/0xaf
Dec 16 01:12:27 mailserver-1 kernel: [<c013eee0>] do_futex+0x7c/0x937
Dec 16 01:12:27 mailserver-1 kernel: [<c01780b6>] sys_select+0xd6/0x187
Dec 16 01:12:27 mailserver-1 kernel: [<c013f85d>] sys_futex+0xc2/0xd4
Dec 16 01:12:27 mailserver-1 kernel: [<c016d62a>] sys_read+0x5f/0x67
Dec 16 01:12:27 mailserver-1 kernel: [<c0103e0e>] sysenter_past_esp+0x6b/0xa1
Dec 16 01:12:27 mailserver-1 kernel: =======================
Dec 16 01:12:27 mailserver-1 kernel: Mem-info:
Dec 16 01:12:27 mailserver-1 kernel: DMA per-cpu:
Dec 16 01:12:27 mailserver-1 kernel: CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 01:12:27 mailserver-1 kernel: CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 01:12:27 mailserver-1 kernel: CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 01:12:27 mailserver-1 kernel: CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 01:12:27 mailserver-1 kernel: CPU    4: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 01:12:27 mailserver-1 kernel: CPU    5: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 01:12:27 mailserver-1 kernel: CPU    6: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 01:12:27 mailserver-1 kernel: CPU    7: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 01:12:27 mailserver-1 kernel: Normal per-cpu:
Dec 16 01:12:27 mailserver-1 kernel: CPU    0: Hot: hi:  186, btch:  31 usd:  67   Cold: hi:   62, btch:  15 usd:  56
Dec 16 01:12:27 mailserver-1 kernel: CPU    1: Hot: hi:  186, btch:  31 usd:  12   Cold: hi:   62, btch:  15 usd:  57
Dec 16 01:12:27 mailserver-1 kernel: CPU    2: Hot: hi:  186, btch:  31 usd:   1   Cold: hi:   62, btch:  15 usd:  57
Dec 16 01:12:27 mailserver-1 kernel: CPU    3: Hot: hi:  186, btch:  31 usd:  92   Cold: hi:   62, btch:  15 usd:  53
Dec 16 01:12:27 mailserver-1 kernel: CPU    4: Hot: hi:  186, btch:  31 usd:  39   Cold: hi:   62, btch:  15 usd:  52
Dec 16 01:12:27 mailserver-1 kernel: CPU    5: Hot: hi:  186, btch:  31 usd:  20   Cold: hi:   62, btch:  15 usd:  53
Dec 16 01:12:27 mailserver-1 kernel: CPU    6: Hot: hi:  186, btch:  31 usd:  38   Cold: hi:   62, btch:  15 usd:  58
Dec 16 01:12:27 mailserver-1 kernel: CPU    7: Hot: hi:  186, btch:  31 usd:  17   Cold: hi:   62, btch:  15 usd:  49
Dec 16 01:12:27 mailserver-1 kernel: HighMem per-cpu:
Dec 16 01:12:27 mailserver-1 kernel: CPU    0: Hot: hi:  186, btch:  31 usd: 166   Cold: hi:   62, btch:  15 usd:   8
Dec 16 01:12:27 mailserver-1 kernel: CPU    1: Hot: hi:  186, btch:  31 usd:  29   Cold: hi:   62, btch:  15 usd:   9
Dec 16 01:12:27 mailserver-1 kernel: CPU    2: Hot: hi:  186, btch:  31 usd:   7   Cold: hi:   62, btch:  15 usd:   5
Dec 16 01:12:27 mailserver-1 kernel: CPU    3: Hot: hi:  186, btch:  31 usd: 182   Cold: hi:   62, btch:  15 usd:   5
Dec 16 01:12:27 mailserver-1 kernel: CPU    4: Hot: hi:  186, btch:  31 usd: 174   Cold: hi:   62, btch:  15 usd:  14
Dec 16 01:12:27 mailserver-1 kernel: CPU    5: Hot: hi:  186, btch:  31 usd:  42   Cold: hi:   62, btch:  15 usd:   8
Dec 16 01:12:27 mailserver-1 kernel: CPU    6: Hot: hi:  186, btch:  31 usd: 159   Cold: hi:   62, btch:  15 usd:   8
Dec 16 01:12:27 mailserver-1 kernel: CPU    7: Hot: hi:  186, btch:  31 usd:  42   Cold: hi:   62, btch:  15 usd:  14
Dec 16 01:12:27 mailserver-1 kernel: Active:488537 inactive:8843 dirty:159 writeback:0 unstable:0
Dec 16 01:12:27 mailserver-1 kernel: free:2411717 slab:24412 mapped:6930 pagetables:1953 bounce:0
Dec 16 01:12:27 mailserver-1 kernel: DMA free:3568kB min:68kB low:84kB high:100kB active:0kB inactive:0kB present:16256kB pages_scanned:15 all_unreclaimable? yes
Dec 16 01:12:27 mailserver-1 kernel: lowmem_reserve[]: 0 873 12938 12938
Dec 16 01:12:27 mailserver-1 kernel: Normal free:3692kB min:3744kB low:4680kB high:5616kB active:64kB inactive:0kB present:894080kB pages_scanned:132 all_unreclaimable? yes
Dec 16 01:12:27 mailserver-1 kernel: lowmem_reserve[]: 0 0 96520 96520
Dec 16 01:12:27 mailserver-1 kernel: HighMem free:9639608kB min:512kB low:13456kB high:26404kB active:1954088kB inactive:35524kB present:12354560kB pages_scanned:0 all_unreclaimable? no
Dec 16 01:12:27 mailserver-1 kernel: lowmem_reserve[]: 0 0 0 0
Dec 16 01:12:27 mailserver-1 kernel: DMA: 16*4kB 15*8kB 7*16kB 2*32kB 2*64kB 0*128kB 0*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3560kB
Dec 16 01:12:27 mailserver-1 kernel: Normal: 195*4kB 106*8kB 5*16kB 9*32kB 1*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 3980kB
Dec 16 01:12:27 mailserver-1 kernel: HighMem: 50533*4kB 105248*8kB 97284*16kB 61970*32kB 34204*64kB 13139*128kB 3481*256kB 502*512kB 24*1024kB 2*2048kB 2*4096kB = 9639572kB
Dec 16 01:12:27 mailserver-1 kernel: Swap cache: add 28, delete 28, find 0/0, race 0+0
Dec 16 01:12:27 mailserver-1 kernel: Free swap  = 1441668kB
Dec 16 01:12:27 mailserver-1 kernel: Total swap = 1441776kB
Dec 16 01:12:27 mailserver-1 kernel: Free swap:       1441668kB
Dec 16 01:12:27 mailserver-1 kernel: syslog-ng invoked oom-killer: gfp_mask=0xd0, order=0, oomkilladj=0
Dec 16 01:12:27 mailserver-1 kernel: [<c01511e9>] out_of_memory+0x69/0x1a4
Dec 16 01:12:27 mailserver-1 kernel: [<c01528d7>] __alloc_pages+0x20a/0x291
Dec 16 01:12:27 mailserver-1 kernel: [<c012bd38>] __capable+0xc/0x1f
Dec 16 01:12:27 mailserver-1 kernel: [<c0152997>] __get_free_pages+0x39/0x47
Dec 16 01:12:27 mailserver-1 kernel: [<c0177f78>] __pollwait+0x44/0xac
Dec 16 01:12:27 mailserver-1 kernel: [<c0328bda>] unix_poll+0x17/0x8b
Dec 16 01:12:27 mailserver-1 kernel: [<c02cdd68>] sock_poll+0xc/0xe
Dec 16 01:12:27 mailserver-1 kernel: [<c01774f8>] do_sys_poll+0x19a/0x327
Dec 16 01:12:27 mailserver-1 kernel: [<c0177f34>] __pollwait+0x0/0xac
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c01776b9>] sys_poll+0x34/0x37
Dec 16 01:12:27 mailserver-1 kernel: [<c0103e0e>] sysenter_past_esp+0x6b/0xa1
Dec 16 01:12:27 mailserver-1 kernel: =======================
Dec 16 01:12:27 mailserver-1 kernel: Mem-info:
Dec 16 01:12:27 mailserver-1 kernel: DMA per-cpu:
Dec 16 01:12:27 mailserver-1 kernel: CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 01:12:27 mailserver-1 kernel: CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 01:12:27 mailserver-1 kernel: CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 01:12:27 mailserver-1 kernel: CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 01:12:27 mailserver-1 kernel: CPU    4: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 01:12:27 mailserver-1 kernel: CPU    5: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 01:12:27 mailserver-1 kernel: CPU    6: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 01:12:27 mailserver-1 kernel: CPU    7: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 01:12:27 mailserver-1 kernel: Normal per-cpu:
Dec 16 01:12:27 mailserver-1 kernel: CPU    0: Hot: hi:  186, btch:  31 usd:  67   Cold: hi:   62, btch:  15 usd:  56
Dec 16 01:12:27 mailserver-1 kernel: CPU    1: Hot: hi:  186, btch:  31 usd:  12   Cold: hi:   62, btch:  15 usd:  57
Dec 16 01:12:27 mailserver-1 kernel: CPU    2: Hot: hi:  186, btch:  31 usd:   1   Cold: hi:   62, btch:  15 usd:  57
Dec 16 01:12:27 mailserver-1 kernel: CPU    3: Hot: hi:  186, btch:  31 usd:  92   Cold: hi:   62, btch:  15 usd:  53
Dec 16 01:12:27 mailserver-1 kernel: CPU    4: Hot: hi:  186, btch:  31 usd:  39   Cold: hi:   62, btch:  15 usd:  52
Dec 16 01:12:27 mailserver-1 kernel: CPU    5: Hot: hi:  186, btch:  31 usd:  20   Cold: hi:   62, btch:  15 usd:  53
Dec 16 01:12:27 mailserver-1 kernel: CPU    6: Hot: hi:  186, btch:  31 usd:  38   Cold: hi:   62, btch:  15 usd:  58
Dec 16 01:12:27 mailserver-1 kernel: CPU    7: Hot: hi:  186, btch:  31 usd:  17   Cold: hi:   62, btch:  15 usd:  49
Dec 16 01:12:27 mailserver-1 kernel: HighMem per-cpu:
Dec 16 01:12:27 mailserver-1 kernel: CPU    0: Hot: hi:  186, btch:  31 usd: 166   Cold: hi:   62, btch:  15 usd:   8
Dec 16 01:12:27 mailserver-1 kernel: CPU    1: Hot: hi:  186, btch:  31 usd:  29   Cold: hi:   62, btch:  15 usd:   9
Dec 16 01:12:27 mailserver-1 kernel: CPU    2: Hot: hi:  186, btch:  31 usd:  11   Cold: hi:   62, btch:  15 usd:   5
Dec 16 01:12:27 mailserver-1 kernel: CPU    3: Hot: hi:  186, btch:  31 usd: 184   Cold: hi:   62, btch:  15 usd:   5
Dec 16 01:12:27 mailserver-1 kernel: CPU    4: Hot: hi:  186, btch:  31 usd: 174   Cold: hi:   62, btch:  15 usd:  14
Dec 16 01:12:27 mailserver-1 kernel: CPU    5: Hot: hi:  186, btch:  31 usd:  42   Cold: hi:   62, btch:  15 usd:   8
Dec 16 01:12:27 mailserver-1 kernel: CPU    6: Hot: hi:  186, btch:  31 usd: 159   Cold: hi:   62, btch:  15 usd:   8
Dec 16 01:12:27 mailserver-1 kernel: CPU    7: Hot: hi:  186, btch:  31 usd:  42   Cold: hi:   62, btch:  15 usd:  14
Dec 16 01:12:27 mailserver-1 kernel: Active:488537 inactive:8856 dirty:159 writeback:0 unstable:0
Dec 16 01:12:27 mailserver-1 kernel: free:2411708 slab:24412 mapped:6930 pagetables:1953 bounce:0
Dec 16 01:12:27 mailserver-1 kernel: DMA free:3532kB min:68kB low:84kB high:100kB active:0kB inactive:0kB present:16256kB pages_scanned:47 all_unreclaimable? yes
Dec 16 01:12:27 mailserver-1 kernel: lowmem_reserve[]: 0 873 12938 12938
Dec 16 01:12:27 mailserver-1 kernel: Normal free:3692kB min:3744kB low:4680kB high:5616kB active:64kB inactive:0kB present:894080kB pages_scanned:165 all_unreclaimable? yes
Dec 16 01:12:27 mailserver-1 kernel: lowmem_reserve[]: 0 0 96520 96520
Dec 16 01:12:27 mailserver-1 kernel: HighMem free:9639608kB min:512kB low:13456kB high:26404kB active:1954088kB inactive:35524kB present:12354560kB pages_scanned:0 all_unreclaimable? no
Dec 16 01:12:27 mailserver-1 kernel: lowmem_reserve[]: 0 0 0 0
Dec 16 01:12:27 mailserver-1 kernel: DMA: 0*4kB 15*8kB 7*16kB 2*32kB 2*64kB 0*128kB 0*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3496kB
Dec 16 01:12:27 mailserver-1 kernel: Normal: 195*4kB 106*8kB 5*16kB 9*32kB 1*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 3980kB
Dec 16 01:12:27 mailserver-1 kernel: HighMem: 50533*4kB 105248*8kB 97284*16kB 61970*32kB 34204*64kB 13139*128kB 3481*256kB 502*512kB 24*1024kB 2*2048kB 2*4096kB = 9639572kB
Dec 16 01:12:27 mailserver-1 kernel: Swap cache: add 28, delete 28, find 0/0, race 0+0
Dec 16 01:12:27 mailserver-1 kernel: Free swap  = 1441668kB
Dec 16 01:12:27 mailserver-1 kernel: Total swap = 1441776kB
Dec 16 01:12:27 mailserver-1 kernel: Free swap:       1441668kB
Dec 16 01:12:27 mailserver-1 kernel: 3342335 pages of RAM
Dec 16 01:12:27 mailserver-1 kernel: 3112959 pages of HIGHMEM
Dec 16 01:12:27 mailserver-1 kernel: 224378 reserved pages
Dec 16 01:12:27 mailserver-1 kernel: 220898 pages shared
Dec 16 01:12:27 mailserver-1 kernel: 0 pages swap cached
Dec 16 01:12:27 mailserver-1 kernel: 159 pages dirty
Dec 16 01:12:27 mailserver-1 kernel: 0 pages writeback
Dec 16 01:12:27 mailserver-1 kernel: 6930 pages mapped
Dec 16 01:12:27 mailserver-1 kernel: 24412 pages slab
Dec 16 01:12:27 mailserver-1 kernel: 1953 pages pagetables
Dec 16 01:12:27 mailserver-1 kernel: Out of memory: kill process 1324 (amavisd-new) score 8082 or a child
Dec 16 01:12:27 mailserver-1 kernel: Killed process 1324 (amavisd-new)
Dec 16 01:12:27 mailserver-1 kernel: named invoked oom-killer: gfp_mask=0xd0, order=0, oomkilladj=0
Dec 16 01:12:27 mailserver-1 kernel: [<c01511e9>] out_of_memory+0x69/0x1a4
Dec 16 01:12:27 mailserver-1 kernel: [<c01528d7>] __alloc_pages+0x20a/0x291
Dec 16 01:12:27 mailserver-1 kernel: [<c0152997>] __get_free_pages+0x39/0x47
Dec 16 01:12:27 mailserver-1 kernel: [<c0177f78>] __pollwait+0x44/0xac
Dec 16 01:12:27 mailserver-1 kernel: [<c02d58bc>] datagram_poll+0x14/0xb1
Dec 16 01:12:27 mailserver-1 kernel: [<c03103ed>] udp_poll+0x10/0xd5
Dec 16 01:12:27 mailserver-1 kernel: [<c02cdd68>] sock_poll+0xc/0xe
Dec 16 01:12:27 mailserver-1 kernel: [<c01778e5>] do_select+0x229/0x3c9
Dec 16 01:12:27 mailserver-1 kernel: [<c0177f34>] __pollwait+0x0/0xac
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0177d0a>] core_sys_select+0x285/0x2a2
Dec 16 01:12:27 mailserver-1 kernel: [<c011e9f4>] __wake_up+0x32/0x43
Dec 16 01:12:27 mailserver-1 kernel: [<c013dcf9>] wake_futex+0x3b/0x45
Dec 16 01:12:27 mailserver-1 kernel: [<c013ee5a>] futex_wake+0xa5/0xaf
Dec 16 01:12:27 mailserver-1 kernel: [<c013eee0>] do_futex+0x7c/0x937
Dec 16 01:12:27 mailserver-1 kernel: [<c01780b6>] sys_select+0xd6/0x187
Dec 16 01:12:27 mailserver-1 kernel: [<c013f85d>] sys_futex+0xc2/0xd4
Dec 16 01:12:27 mailserver-1 kernel: [<c016d62a>] sys_read+0x5f/0x67
Dec 16 01:12:27 mailserver-1 kernel: [<c0103e0e>] sysenter_past_esp+0x6b/0xa1
Dec 16 01:12:27 mailserver-1 kernel: =======================
Dec 16 01:12:27 mailserver-1 kernel: Mem-info:
Dec 16 01:12:27 mailserver-1 kernel: DMA per-cpu:
Dec 16 01:12:27 mailserver-1 kernel: CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 01:12:27 mailserver-1 kernel: CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 01:12:27 mailserver-1 kernel: CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 01:12:27 mailserver-1 kernel: CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 01:12:27 mailserver-1 kernel: CPU    4: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 01:12:27 mailserver-1 kernel: CPU    5: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 01:12:27 mailserver-1 kernel: CPU    6: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 01:12:27 mailserver-1 kernel: CPU    7: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 01:12:27 mailserver-1 kernel: Normal per-cpu:
Dec 16 01:12:27 mailserver-1 kernel: CPU    0: Hot: hi:  186, btch:  31 usd:  67   Cold: hi:   62, btch:  15 usd:  56
Dec 16 01:12:27 mailserver-1 kernel: CPU    1: Hot: hi:  186, btch:  31 usd:  12   Cold: hi:   62, btch:  15 usd:  57
Dec 16 01:12:27 mailserver-1 kernel: CPU    2: Hot: hi:  186, btch:  31 usd:   1   Cold: hi:   62, btch:  15 usd:  57
Dec 16 01:12:27 mailserver-1 kernel: CPU    3: Hot: hi:  186, btch:  31 usd:  92   Cold: hi:   62, btch:  15 usd:  53
Dec 16 01:12:27 mailserver-1 kernel: CPU    4: Hot: hi:  186, btch:  31 usd:  39   Cold: hi:   62, btch:  15 usd:  52
Dec 16 01:12:27 mailserver-1 kernel: CPU    5: Hot: hi:  186, btch:  31 usd:  20   Cold: hi:   62, btch:  15 usd:  53
Dec 16 01:12:27 mailserver-1 kernel: CPU    6: Hot: hi:  186, btch:  31 usd:  50   Cold: hi:   62, btch:  15 usd:  58
Dec 16 01:12:27 mailserver-1 kernel: CPU    7: Hot: hi:  186, btch:  31 usd:  17   Cold: hi:   62, btch:  15 usd:  49
Dec 16 01:12:27 mailserver-1 kernel: HighMem per-cpu:
Dec 16 01:12:27 mailserver-1 kernel: CPU    0: Hot: hi:  186, btch:  31 usd: 166   Cold: hi:   62, btch:  15 usd:   8
Dec 16 01:12:27 mailserver-1 kernel: CPU    1: Hot: hi:  186, btch:  31 usd:  29   Cold: hi:   62, btch:  15 usd:   9
Dec 16 01:12:27 mailserver-1 kernel: CPU    2: Hot: hi:  186, btch:  31 usd:  11   Cold: hi:   62, btch:  15 usd:   5
Dec 16 01:12:27 mailserver-1 kernel: CPU    3: Hot: hi:  186, btch:  31 usd: 184   Cold: hi:   62, btch:  15 usd:   5
Dec 16 01:12:27 mailserver-1 kernel: CPU    4: Hot: hi:  186, btch:  31 usd: 174   Cold: hi:   62, btch:  15 usd:  14
Dec 16 01:12:27 mailserver-1 kernel: CPU    5: Hot: hi:  186, btch:  31 usd:  42   Cold: hi:   62, btch:  15 usd:   8
Dec 16 01:12:27 mailserver-1 kernel: CPU    6: Hot: hi:  186, btch:  31 usd: 183   Cold: hi:   62, btch:  15 usd:   8
Dec 16 01:12:27 mailserver-1 kernel: CPU    7: Hot: hi:  186, btch:  31 usd:  42   Cold: hi:   62, btch:  15 usd:  14
Dec 16 01:12:27 mailserver-1 kernel: Active:486985 inactive:8858 dirty:159 writeback:0 unstable:0
Dec 16 01:12:27 mailserver-1 kernel: free:2413203 slab:24412 mapped:6930 pagetables:1953 bounce:0
Dec 16 01:12:27 mailserver-1 kernel: DMA free:3532kB min:68kB low:84kB high:100kB active:0kB inactive:0kB present:16256kB pages_scanned:30 all_unreclaimable? yes
Dec 16 01:12:27 mailserver-1 kernel: lowmem_reserve[]: 0 873 12938 12938
Dec 16 01:12:27 mailserver-1 kernel: Normal free:3692kB min:3744kB low:4680kB high:5616kB active:64kB inactive:0kB present:894080kB pages_scanned:198 all_unreclaimable? yes
Dec 16 01:12:27 mailserver-1 kernel: lowmem_reserve[]: 0 0 96520 96520
Dec 16 01:12:27 mailserver-1 kernel: 3342335 pages of RAM
Dec 16 01:12:27 mailserver-1 kernel: 3112959 pages of HIGHMEM
Dec 16 01:12:27 mailserver-1 kernel: 224378 reserved pages
Dec 16 01:12:27 mailserver-1 kernel: 219240 pages shared
Dec 16 01:12:27 mailserver-1 kernel: 0 pages swap cached
Dec 16 01:12:27 mailserver-1 kernel: 159 pages dirty
Dec 16 01:12:27 mailserver-1 kernel: 0 pages writeback
Dec 16 01:12:27 mailserver-1 kernel: 6930 pages mapped
Dec 16 01:12:27 mailserver-1 kernel: 24412 pages slab
Dec 16 01:12:27 mailserver-1 kernel: 1953 pages pagetables
Dec 16 01:12:27 mailserver-1 kernel: HighMem free:9645588kB min:512kB low:13456kB high:26404kB active:1947880kB inactive:35524kB present:12354560kB pages_scanned:0 all_unreclaimable? no
Dec 16 01:12:27 mailserver-1 kernel: lowmem_reserve[]: 0 0 0 0
Dec 16 01:12:27 mailserver-1 kernel: DMA: 2*4kB <3>Out of memory: kill process 1530 (amavisd-new) score 8080 or a child
Dec 16 01:12:27 mailserver-1 kernel: 15*8kB 7*16kB 2*32kB 2*64kB 0*128kB 0*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3504kB
Dec 16 01:12:27 mailserver-1 kernel: Normal: 195*4kB 106*8kB 5*16kB 9*32kB 1*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 3980kB
Dec 16 01:12:27 mailserver-1 kernel: HighMem: 52003*4kB 105266*8kB 97289*16kB 61973*32kB 34204*64kB 13139*128kB 3481*256kB 502*512kB 24*1024kB 2*2048kB 2*4096kB = 9645772kB
Dec 16 01:12:27 mailserver-1 kernel: Swap cache: add 28, delete 28, find 0/0, race 0+0
Dec 16 01:12:27 mailserver-1 kernel: Free swap  = 1441668kB
Dec 16 01:12:27 mailserver-1 kernel: Total swap = 1441776kB
Dec 16 01:12:27 mailserver-1 kernel: Free swap:       1441668kB
Dec 16 01:12:27 mailserver-1 kernel: Killed process 1530 (amavisd-new)
Dec 16 01:12:27 mailserver-1 kernel: syslog-ng invoked oom-killer: gfp_mask=0xd0, order=0, oomkilladj=0
Dec 16 01:12:27 mailserver-1 kernel: [<c01511e9>] out_of_memory+0x69/0x1a4
Dec 16 01:12:27 mailserver-1 kernel: [<c01528d7>] __alloc_pages+0x20a/0x291
Dec 16 01:12:27 mailserver-1 kernel: [<c012bd38>] __capable+0xc/0x1f
Dec 16 01:12:27 mailserver-1 kernel: [<c0152997>] __get_free_pages+0x39/0x47
Dec 16 01:12:27 mailserver-1 kernel: [<c0177f78>] __pollwait+0x44/0xac
Dec 16 01:12:27 mailserver-1 kernel: [<c0328bda>] unix_poll+0x17/0x8b
Dec 16 01:12:27 mailserver-1 kernel: [<c02cdd68>] sock_poll+0xc/0xe
Dec 16 01:12:27 mailserver-1 kernel: [<c01774f8>] do_sys_poll+0x19a/0x327
Dec 16 01:12:27 mailserver-1 kernel: [<c0177f34>] __pollwait+0x0/0xac
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
Dec 16 01:12:27 mailserver-1 kernel: [<c0120144>] default_wake_function+0x0/0xc
......................
.....................
Dec 16 02:55:04 mailserver-1 kernel: printk: 8 messages suppressed.
Dec 16 02:55:05 mailserver-1 kernel: sh invoked oom-killer: gfp_mask=0x84d0, order=0, oomkilladj=0
Dec 16 02:55:05 mailserver-1 kernel: [<c01511e9>] out_of_memory+0x69/0x1a4
Dec 16 02:55:05 mailserver-1 kernel: [<c01528d7>] __alloc_pages+0x20a/0x291
Dec 16 02:55:05 mailserver-1 kernel: [<c015a1a5>] __pte_alloc+0x16/0xfa
Dec 16 02:55:05 mailserver-1 kernel: [<c014e59d>] file_read_actor+0x0/0xca
Dec 16 02:55:05 mailserver-1 kernel: [<c015b69a>] handle_mm_fault+0x12b/0xca2
Dec 16 02:55:05 mailserver-1 kernel: [<c02008e2>] xfs_iunlock+0x2a/0x6d
Dec 16 02:55:05 mailserver-1 kernel: [<c0229db2>] xfs_read+0x303/0x326
Dec 16 02:55:05 mailserver-1 kernel: [<c0226b04>] xfs_file_aio_read+0x66/0x6e
Dec 16 02:55:05 mailserver-1 kernel: [<c016c9f9>] do_sync_read+0xc7/0x10a
Dec 16 02:55:05 mailserver-1 kernel: [<c015c496>] get_user_pages+0x285/0x363
Dec 16 02:55:05 mailserver-1 kernel: [<c016fc7f>] get_arg_page+0x42/0x8c
Dec 16 02:55:05 mailserver-1 kernel: [<c016fd96>] copy_strings+0xcd/0x173
Dec 16 02:55:05 mailserver-1 kernel: [<c016fe55>] copy_strings_kernel+0x19/0x27
Dec 16 02:55:05 mailserver-1 kernel: [<c0171114>] do_execve+0xdf/0x1a4
Dec 16 02:55:05 mailserver-1 kernel: [<c01026ed>] sys_execve+0x2f/0x7b
Dec 16 02:55:05 mailserver-1 kernel: [<c0103e0e>] sysenter_past_esp+0x6b/0xa1
Dec 16 02:55:05 mailserver-1 kernel: [<c0330000>] wait_for_completion_timeout+0x7f/0xd6
Dec 16 02:55:05 mailserver-1 kernel: =======================
Dec 16 02:55:05 mailserver-1 kernel: Mem-info:
Dec 16 02:55:05 mailserver-1 kernel: DMA per-cpu:
Dec 16 02:55:05 mailserver-1 kernel: CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 02:55:05 mailserver-1 kernel: CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 02:55:05 mailserver-1 kernel: CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 02:55:05 mailserver-1 kernel: CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 02:55:05 mailserver-1 kernel: CPU    4: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 02:55:05 mailserver-1 kernel: CPU    5: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 02:55:05 mailserver-1 kernel: CPU    6: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 02:55:05 mailserver-1 kernel: CPU    7: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 02:55:05 mailserver-1 kernel: Normal per-cpu:
Dec 16 02:55:05 mailserver-1 kernel: CPU    0: Hot: hi:  186, btch:  31 usd:  30   Cold: hi:   62, btch:  15 usd:  51
Dec 16 02:55:05 mailserver-1 kernel: CPU    1: Hot: hi:  186, btch:  31 usd:  28   Cold: hi:   62, btch:  15 usd:  58
Dec 16 02:55:05 mailserver-1 kernel: CPU    2: Hot: hi:  186, btch:  31 usd:  30   Cold: hi:   62, btch:  15 usd:  54
Dec 16 02:55:05 mailserver-1 kernel: CPU    3: Hot: hi:  186, btch:  31 usd:  25   Cold: hi:   62, btch:  15 usd:  48
Dec 16 02:55:05 mailserver-1 kernel: CPU    4: Hot: hi:  186, btch:  31 usd:  16   Cold: hi:   62, btch:  15 usd:  50
Dec 16 02:55:05 mailserver-1 kernel: CPU    5: Hot: hi:  186, btch:  31 usd:  24   Cold: hi:   62, btch:  15 usd:  57
Dec 16 02:55:05 mailserver-1 kernel: CPU    6: Hot: hi:  186, btch:  31 usd:  21   Cold: hi:   62, btch:  15 usd:  55
Dec 16 02:55:05 mailserver-1 kernel: CPU    7: Hot: hi:  186, btch:  31 usd:  24   Cold: hi:   62, btch:  15 usd:  50
Dec 16 02:55:05 mailserver-1 kernel: HighMem per-cpu:
Dec 16 02:55:05 mailserver-1 kernel: CPU    0: Hot: hi:  186, btch:  31 usd:  26   Cold: hi:   62, btch:  15 usd:   1
Dec 16 02:55:05 mailserver-1 kernel: CPU    1: Hot: hi:  186, btch:  31 usd:  58   Cold: hi:   62, btch:  15 usd:  14
Dec 16 02:55:05 mailserver-1 kernel: CPU    2: Hot: hi:  186, btch:  31 usd:  13   Cold: hi:   62, btch:  15 usd:   9
Dec 16 02:55:05 mailserver-1 kernel: CPU    3: Hot: hi:  186, btch:  31 usd:  83   Cold: hi:   62, btch:  15 usd:   4
Dec 16 02:55:05 mailserver-1 kernel: CPU    4: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   4
Dec 16 02:55:05 mailserver-1 kernel: CPU    5: Hot: hi:  186, btch:  31 usd: 121   Cold: hi:   62, btch:  15 usd:  11
Dec 16 02:55:05 mailserver-1 kernel: CPU    6: Hot: hi:  186, btch:  31 usd:  79   Cold: hi:   62, btch:  15 usd:  11
Dec 16 02:55:05 mailserver-1 kernel: CPU    7: Hot: hi:  186, btch:  31 usd:  38   Cold: hi:   62, btch:  15 usd:   8
Dec 16 02:55:05 mailserver-1 kernel: Active:506772 inactive:7227 dirty:18 writeback:0 unstable:0
Dec 16 02:55:05 mailserver-1 kernel: free:2395747 slab:23425 mapped:6651 pagetables:1663 bounce:0
Dec 16 02:55:05 mailserver-1 kernel: DMA free:3556kB min:68kB low:84kB high:100kB active:0kB inactive:0kB present:16256kB pages_scanned:0 all_unreclaimable? yes
Dec 16 02:55:05 mailserver-1 kernel: lowmem_reserve[]: 0 873 12938 12938
Dec 16 02:55:05 mailserver-1 kernel: Normal free:3652kB min:3744kB low:4680kB high:5616kB active:104kB inactive:0kB present:894080kB pages_scanned:63 all_unreclaimable? no
Dec 16 02:55:05 mailserver-1 kernel: lowmem_reserve[]: 0 0 96520 96520
Dec 16 02:55:05 mailserver-1 kernel: HighMem free:9575780kB min:512kB low:13456kB high:26404kB active:2026984kB inactive:28928kB present:12354560kB pages_scanned:0 all_unreclaimable? no
Dec 16 02:55:05 mailserver-1 kernel: lowmem_reserve[]: 0 0 0 0
Dec 16 02:55:05 mailserver-1 kernel: DMA: 17*4kB 10*8kB 9*16kB 2*32kB 2*64kB 0*128kB 0*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3556kB
Dec 16 02:55:05 mailserver-1 kernel: Normal: 138*4kB 48*8kB 38*16kB 8*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 3848kB
Dec 16 02:55:05 mailserver-1 kernel: HighMem: 29918*4kB 106008*8kB 97484*16kB 62058*32kB 34230*64kB 13152*128kB 3490*256kB 502*512kB 24*1024kB 2*2048kB 2*4096kB = 9574840kB
Dec 16 02:55:05 mailserver-1 kernel: Swap cache: add 28, delete 28, find 0/0, race 0+0
Dec 16 02:55:05 mailserver-1 kernel: Free swap  = 1441668kB
Dec 16 02:55:05 mailserver-1 kernel: Total swap = 1441776kB
Dec 16 02:55:05 mailserver-1 kernel: Free swap:       1441668kB
Dec 16 02:55:05 mailserver-1 kernel: sh invoked oom-killer: gfp_mask=0x84d0, order=0, oomkilladj=0
Dec 16 02:55:05 mailserver-1 kernel: [<c01511e9>] out_of_memory+0x69/0x1a4
Dec 16 02:55:05 mailserver-1 kernel: [<c01528d7>] __alloc_pages+0x20a/0x291
Dec 16 02:55:05 mailserver-1 kernel: i:  186, btch:  31 usd:  24   Cold: hi:   62, btch:  15 usd:  57
Dec 16 02:55:05 mailserver-1 kernel: CPU    6: Hot: hi:  186, btch:  31 usd:  21   Cold: hi:   62, btch:  15 usd:  55
Dec 16 02:55:05 mailserver-1 kernel: CPU    7: Hot: hi:  186, btch:  31 usd:  24   Cold: hi:   62, btch:  15 usd:  50
Dec 16 02:55:05 mailserver-1 kernel: HighMem per-cpu:
Dec 16 02:55:05 mailserver-1 kernel: CPU    0: Hot: hi:  186, btch:  31 usd:  26   Cold: hi:   62, btch:  15 usd:   1
Dec 16 02:55:05 mailserver-1 kernel: CPU    1: Hot: hi:  186, btch:  31 usd:  58   Cold: hi:   62, btch:  15 usd:  14
Dec 16 02:55:05 mailserver-1 kernel: CPU    2: Hot: hi:  186, btch:  31 usd:  13   Cold: hi:   62, btch:  15 usd:   9
Dec 16 02:55:05 mailserver-1 kernel: CPU    3: Hot: hi:  186, btch:  31 usd:  83   Cold: hi:   62, btch:  15 usd:   4
Dec 16 02:55:05 mailserver-1 kernel: CPU    4: Hot: hi:  186, btch:  31 usd:   4   Cold: hi:   62, btch:  15 usd:   4
Dec 16 02:55:05 mailserver-1 kernel: CPU    5: Hot: hi:  186, btch:  31 usd: 121   Cold: hi:   62, btch:  15 usd:  11
Dec 16 02:55:05 mailserver-1 kernel: CPU    6: Hot: hi:  186, btch:  31 usd:  79   Cold: hi:   62, btch:  15 usd:  11
Dec 16 02:55:05 mailserver-1 kernel: CPU    7: Hot: hi:  186, btch:  31 usd:  38   Cold: hi:   62, btch:  15 usd:   8
Dec 16 02:55:05 mailserver-1 kernel: Active:506772 inactive:7276 dirty:18 writeback:0 unstable:0
Dec 16 02:55:05 mailserver-1 kernel: free:2395747 slab:23425 mapped:6651 pagetables:1663 bounce:0
Dec 16 02:55:05 mailserver-1 kernel: DMA free:3556kB min:68kB low:84kB high:100kB active:0kB inactive:0kB present:16256kB pages_scanned:0 all_unreclaimable? yes
Dec 16 02:55:05 mailserver-1 kernel: lowmem_reserve[]: 0 873 12938 12938
Dec 16 02:55:05 mailserver-1 kernel: Normal free:3652kB min:3744kB low:4680kB high:5616kB active:104kB inactive:176kB present:894080kB pages_scanned:765 all_unreclaimable? yes
Dec 16 02:55:05 mailserver-1 kernel: lowmem_reserve[]: 0 0 96520 96520
Dec 16 02:55:05 mailserver-1 kernel: HighMem free:9575780kB min:512kB low:13456kB high:26404kB active:2026984kB inactive:28928kB present:12354560kB pages_scanned:0 all_unreclaimable? no
Dec 16 02:55:05 mailserver-1 kernel: lowmem_reserve[]: 0 0 0 0
Dec 16 02:55:05 mailserver-1 kernel: DMA: Active:506772 inactive:7276 dirty:18 writeback:0 unstable:0
Dec 16 02:55:05 mailserver-1 kernel: free:2395747 slab:23425 mapped:6651 pagetables:1663 bounce:0
Dec 16 02:55:05 mailserver-1 kernel: DMA free:3556kB min:68kB low:84kB high:100kB active:0kB inactive:0kB present:16256kB pages_scanned:0 all_unreclaimable? yes
Dec 16 02:55:05 mailserver-1 kernel: lowmem_reserve[]: 0 873 12938 12938
Dec 16 02:55:05 mailserver-1 kernel: Normal free:3652kB min:3744kB low:4680kB high:5616kB active:104kB inactive:176kB present:894080kB pages_scanned:765 all_unreclaimable? yes
Dec 16 02:55:05 mailserver-1 kernel: lowmem_reserve[]: 0 0 96520 96520
Dec 16 02:55:05 mailserver-1 kernel: HighMem free:9575780kB min:512kB low:13456kB high:26404kB active:2026984kB inactive:28928kB present:12354560kB pages_scanned:0 all_unreclaimable? no
Dec 16 02:55:05 mailserver-1 kernel: lowmem_reserve[]: 0 0 0 0
Dec 16 02:55:05 mailserver-1 kernel: DMA: 17*4kB 10*8kB 9*16kB 2*32kB 2*64kB 0*128kB 0*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3556kB
Dec 16 02:55:05 mailserver-1 kernel: Normal: 138*4kB 48*8kB 38*16kB 8*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 3848kB
Dec 16 02:55:05 mailserver-1 kernel: HighMem: 17*4kB 10*8kB 9*16kB 2*32kB 2*64kB 0*128kB 0*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3556kB
Dec 16 02:55:05 mailserver-1 kernel: Normal:  [<c011cc3c>]  [<c016fe55>]  [<c016fc7f>] kunmap_atomic+0x49/0x61
Dec 16 02:55:05 mailserver-1 kernel: get_arg_page+0x42/0x8c
Dec 16 02:55:05 mailserver-1 kernel: copy_strings_kernel+0x19/0x27
Dec 16 02:55:05 mailserver-1 kernel: 138*4kB 48*8kB 38*16kB 8*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 3848kB
Dec 16 02:55:05 mailserver-1 kernel: HighMem: 29918*4kB 106008*8kB 97484*16kB 62058*32kB 34230*64kB 13152*128kB 3490*256kB 502*512kB 24*1024kB 2*2048kB 2*4096kB = 9574840kB
Dec 16 02:55:05 mailserver-1 kernel: 29918*4kB 106008*8kB 97484*16kB 62058*32kB 34230*64kB 13152*128kB 3490*256kB 502*512kB 24*1024kB 2*2048kB 2*4096kB = 9574840kB
Dec 16 02:55:05 mailserver-1 kernel: Swap cache: add 28, delete 28, find 0/0, race 0+0
Dec 16 02:55:05 mailserver-1 kernel: Free swap  = 1441668kB
Dec 16 02:55:05 mailserver-1 kernel: Total swap = 1441776kB
Dec 16 02:55:05 mailserver-1 kernel: Free swap:       1441668kB
Dec 16 02:55:05 mailserver-1 kernel: Swap cache: add 28, delete 28, find 0/0, race 0+0
Dec 16 02:55:05 mailserver-1 kernel: Free swap  = 1441668kB
Dec 16 02:55:05 mailserver-1 kernel: Total swap = 1441776kB
Dec 16 02:55:05 mailserver-1 kernel: Free swap:       1441668kB
Dec 16 02:55:05 mailserver-1 kernel: [<c0171114>] do_execve+0xdf/0x1a4
Dec 16 02:55:05 mailserver-1 kernel: [<c016fd96>] copy_strings+0xcd/0x173
Dec 16 02:55:05 mailserver-1 kernel: [<c01026ed>] sys_execve+0x2f/0x7b
Dec 16 02:55:05 mailserver-1 kernel: [<c025697b>]  [<c0103e0e>] sysenter_past_esp+0x6b/0xa1
Dec 16 02:55:05 mailserver-1 kernel: prio_tree_insert+0x11e/0x1e3
Dec 16 02:55:05 mailserver-1 kernel: [<c016fe55>] copy_strings_kernel+0x19/0x27
Dec 16 02:55:05 mailserver-1 kernel: [<c0171114>] do_execve+0xdf/0x1a4
Dec 16 02:55:05 mailserver-1 kernel: [<c011b51a>]  [<c0330000>] do_page_fault+0x0/0x876
Dec 16 02:55:05 mailserver-1 kernel: wait_for_completion_timeout+0x7f/0xd6
Dec 16 02:55:05 mailserver-1 kernel: [<c01026ed>] sys_execve+0x2f/0x7b
Dec 16 02:55:05 mailserver-1 kernel: [<c0103e0e>]  [<c011b8dd>] sysenter_past_esp+0x6b/0xa1
Dec 16 02:55:05 mailserver-1 kernel: do_page_fault+0x3c3/0x876
Dec 16 02:55:05 mailserver-1 kernel: [<c0156cb6>]  =======================
Dec 16 02:55:05 mailserver-1 kernel: vma_prio_tree_insert+0x17/0x2a
Dec 16 02:55:05 mailserver-1 kernel: Mem-info:
Dec 16 02:55:05 mailserver-1 kernel: DMA per-cpu:
Dec 16 02:55:05 mailserver-1 kernel: CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 02:55:05 mailserver-1 kernel: CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 02:55:05 mailserver-1 kernel: CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 02:55:05 mailserver-1 kernel: CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 02:55:05 mailserver-1 kernel: CPU    4: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 02:55:05 mailserver-1 kernel: CPU    5: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 02:55:05 mailserver-1 kernel: CPU    6: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 02:55:05 mailserver-1 kernel: CPU    7: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 02:55:05 mailserver-1 kernel: Normal per-cpu:
Dec 16 02:55:05 mailserver-1 kernel: CPU    0: Hot: hi:  186, btch:  31 usd:  30   Cold: hi:   62, btch:  15 usd:  51
Dec 16 02:55:05 mailserver-1 kernel: CPU    1: Hot: hi:  186, btch:  31 usd:  29   Cold: hi:   62, btch:  15 usd:  58
Dec 16 02:55:05 mailserver-1 kernel: CPU    2: Hot: hi:  186, btch:  31 usd:  30   Cold: hi:   62, btch:  15 usd:  54
Dec 16 02:55:05 mailserver-1 kernel: [<c015e72e>]  [<c0330000>] CPU    3: Hot: hi:  186, btch:  31 usd:  25   Cold: hi:   62, btch:  15 usd:  48
Dec 16 02:55:05 mailserver-1 kernel: vma_link+0xab/0xc7
Dec 16 02:55:05 mailserver-1 kernel: wait_for_completion_timeout+0x7f/0xd6
Dec 16 02:55:05 mailserver-1 kernel: CPU    4: Hot: hi:  186, btch:  31 usd:  16   Cold: hi:   62, btch:  15 usd:  52
Dec 16 02:55:05 mailserver-1 kernel: CPU    5: Hot: hi:  186, btch:  31 usd:  24   Cold: hi:   62, btch:  15 usd:  57
Dec 16 02:55:05 mailserver-1 kernel: CPU    6: Hot: hi:  186, btch:  31 usd:  21   Cold: hi:   62, btch:  15 usd:  55
Dec 16 02:55:05 mailserver-1 kernel: CPU    7: Hot: hi:  186, btch:  31 usd:  24   Cold: hi:   62, btch:  15 usd:  50
Dec 16 02:55:05 mailserver-1 kernel: HighMem per-cpu:
Dec 16 02:55:05 mailserver-1 kernel: CPU    0: Hot: hi:  186, btch:  31 usd:  26   Cold: hi:   62, btch:  15 usd:   1
Dec 16 02:55:05 mailserver-1 kernel: CPU    1: Hot: hi:  186, btch:  31 usd:  58   Cold: hi:   62, btch:  15 usd:  14
Dec 16 02:55:05 mailserver-1 kernel: CPU    2: Hot: hi:  186, btch:  31 usd:  13   Cold: hi:   62, btch:  15 usd:   9
Dec 16 02:55:05 mailserver-1 kernel: CPU    3: Hot: hi:  186, btch:  31 usd:  83   Cold: hi:   62, btch:  15 usd:   4
Dec 16 02:55:05 mailserver-1 kernel: CPU    4: Hot: hi:  186, btch:  31 usd:   4   Cold: hi:   62, btch:  15 usd:   4
Dec 16 02:55:05 mailserver-1 kernel: CPU    5: Hot: hi:  186, btch:  31 usd: 121   Cold: hi:   62, btch:  15 usd:  11
Dec 16 02:55:05 mailserver-1 kernel: CPU    6: Hot: hi:  186, btch:  31 usd:  79   Cold: hi:   62, btch:  15 usd:  11
Dec 16 02:55:05 mailserver-1 kernel: CPU    7: Hot: hi:  186, btch:  31 usd:  38   Cold: hi:   62, btch:  15 usd:   8
Dec 16 02:55:05 mailserver-1 kernel: Active:506772 inactive:7276 dirty:18 writeback:0 unstable:0
Dec 16 02:55:05 mailserver-1 kernel: free:2395747 slab:23425 mapped:6651 pagetables:1663 bounce:0
Dec 16 02:55:05 mailserver-1 kernel: DMA free:3556kB min:68kB low:84kB high:100kB active:0kB inactive:0kB present:16256kB pages_scanned:0 all_unreclaimable? yes
Dec 16 02:55:05 mailserver-1 kernel: lowmem_reserve[]: 0 873 12938 12938
Dec 16 02:55:05 mailserver-1 kernel: =======================
Dec 16 02:55:05 mailserver-1 kernel: Mem-info:
Dec 16 02:55:05 mailserver-1 kernel: Normal free:3652kB min:3744kB low:4680kB high:5616kB active:104kB inactive:176kB present:894080kB pages_scanned:765 all_unreclaimable? yes
Dec 16 02:55:05 mailserver-1 kernel: lowmem_reserve[]: 0 0 96520 96520
Dec 16 02:55:05 mailserver-1 kernel: HighMem free:9575780kB min:512kB low:13456kB high:26404kB active:2026984kB inactive:28928kB present:12354560kB pages_scanned:0 all_unreclaimable? no
Dec 16 02:55:05 mailserver-1 kernel: lowmem_reserve[]: 0 0 0 0
Dec 16 02:55:05 mailserver-1 kernel: DMA: DMA per-cpu:
Dec 16 02:55:05 mailserver-1 kernel: [<c0168b68>] 17*4kB 10*8kB 9*16kB 2*32kB 2*64kB cache_alloc_debugcheck_after+0xf3/0x169
Dec 16 02:55:05 mailserver-1 kernel: CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 02:55:05 mailserver-1 kernel: 0*128kB 0*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3556kB
Dec 16 02:55:05 mailserver-1 kernel: Normal: CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 02:55:05 mailserver-1 kernel: CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 02:55:05 mailserver-1 kernel: CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 02:55:05 mailserver-1 kernel: CPU    4: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 02:55:05 mailserver-1 kernel: CPU    5: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 02:55:05 mailserver-1 kernel: CPU    6: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 02:55:05 mailserver-1 kernel: CPU    7: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 02:55:05 mailserver-1 kernel: 138*4kB 48*8kB 38*16kB 8*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 3848kB
Dec 16 02:55:05 mailserver-1 kernel: HighMem: Normal per-cpu:
Dec 16 02:55:05 mailserver-1 kernel: CPU    0: Hot: hi:  186, btch:  31 usd:  30   Cold: hi:   62, btch:  15 usd:  51
Dec 16 02:55:05 mailserver-1 kernel: CPU    1: Hot: hi:  186, btch:  31 usd:  29   Cold: hi:   62, btch:  15 usd:  58
Dec 16 02:55:05 mailserver-1 kernel: 29918*4kB 106008*8kB 97484*16kB 62058*32kB 34230*64kB 13152*128kB 3490*256kB 502*512kB 24*1024kB 2*2048kB 2*4096kB = 9574840kB
Dec 16 02:55:05 mailserver-1 kernel: CPU    2: Hot: hi:  186, btch:  31 usd:  30   Cold: hi:   62, btch:  15 usd:  54
Dec 16 02:55:05 mailserver-1 kernel: CPU    3: Hot: hi:  186, btch:  31 usd:  25   Cold: hi:   62, btch:  15 usd:  48
Dec 16 02:55:05 mailserver-1 kernel: CPU    4: Hot: hi:  186, btch:  31 usd:  16   Cold: hi:   62, btch:  15 usd:  52
Dec 16 02:55:05 mailserver-1 kernel: CPU    5: Hot: hi:  186, btch:  31 usd:  24   Cold: hi:   62, btch:  15 usd:  57
Dec 16 02:55:05 mailserver-1 kernel: CPU    6: Hot: hi:  186, btch:  31 usd:  21   Cold: hi:   62, btch:  15 usd:  55
Dec 16 02:55:05 mailserver-1 kernel: CPU    7: Hot: hi:  186, btch:  31 usd:  24   Cold: hi:   62, btch:  15 usd:  50
Dec 16 02:55:05 mailserver-1 kernel: Swap cache: add 28, delete 28, find 0/0, race 0+0
Dec 16 02:55:05 mailserver-1 kernel: Free swap  = 1441668kB
Dec 16 02:55:05 mailserver-1 kernel: [<c015e6d7>] HighMem per-cpu:
Dec 16 02:55:05 mailserver-1 kernel: CPU    0: Hot: hi:  186, btch:  31 usd:  26   Cold: hi:   62, btch:  15 usd:   1
Dec 16 02:55:05 mailserver-1 kernel: CPU    1: Hot: hi:  186, btch:  31 usd:  58   Cold: hi:   62, btch:  15 usd:  14
Dec 16 02:55:05 mailserver-1 kernel: CPU    2: Hot: hi:  186, btch:  31 usd:  13   Cold: hi:   62, btch:  15 usd:   9
Dec 16 02:55:05 mailserver-1 kernel: CPU    3: Hot: hi:  186, btch:  31 usd:  83   Cold: hi:   62, btch:  15 usd:   4
Dec 16 02:55:05 mailserver-1 kernel: vma_link+0x54/0xc7
Dec 16 02:55:05 mailserver-1 kernel: Total swap = 1441776kB
Dec 16 02:55:05 mailserver-1 kernel: Free swap:       1441668kB
Dec 16 02:55:05 mailserver-1 kernel: CPU    4: Hot: hi:  186, btch:  31 usd:   4   Cold: hi:   62, btch:  15 usd:   4
Dec 16 02:55:05 mailserver-1 kernel: CPU    5: Hot: hi:  186, btch:  31 usd: 121   Cold: hi:   62, btch:  15 usd:  11
Dec 16 02:55:05 mailserver-1 kernel: CPU    6: Hot: hi:  186, btch:  31 usd:  79   Cold: hi:   62, btch:  15 usd:  11
Dec 16 02:55:05 mailserver-1 kernel: CPU    7: Hot: hi:  186, btch:  31 usd:  38   Cold: hi:   62, btch:  15 usd:   8
Dec 16 02:55:05 mailserver-1 kernel: Active:506772 inactive:7276 dirty:18 writeback:0 unstable:0
Dec 16 02:55:05 mailserver-1 kernel: free:2395747 slab:23425 mapped:6651 pagetables:1663 bounce:0
Dec 16 02:55:05 mailserver-1 kernel: DMA free:3556kB min:68kB low:84kB high:100kB active:0kB inactive:0kB present:16256kB pages_scanned:0 all_unreclaimable? yes
Dec 16 02:55:05 mailserver-1 kernel: lowmem_reserve[]: 0 873 12938 12938
Dec 16 02:55:05 mailserver-1 kernel: Normal free:3652kB min:3744kB low:4680kB high:5616kB active:104kB inactive:176kB present:894080kB pages_scanned:765 all_unreclaimable? yes
Dec 16 02:55:05 mailserver-1 kernel: lowmem_reserve[]: 0 0 96520 96520
Dec 16 02:55:05 mailserver-1 kernel: HighMem free:9575780kB min:512kB low:13456kB high:26404kB active:2026984kB inactive:28928kB present:12354560kB pages_scanned:0 all_unreclaimable? no
Dec 16 02:55:05 mailserver-1 kernel: lowmem_reserve[]: 0 0 0 0
Dec 16 02:55:05 mailserver-1 kernel: DMA: 17*4kB 10*8kB 9*16kB 2*32kB 2*64kB 0*128kB 0*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3556kB
Dec 16 02:55:05 mailserver-1 kernel: Normal: 138*4kB 48*8kB 38*16kB 8*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 3848kB
Dec 16 02:55:05 mailserver-1 kernel: HighMem: 29918*4kB 106008*8kB 97484*16kB 62058*32kB 34230*64kB 13152*128kB 3490*256kB 502*512kB 24*1024kB 2*2048kB 2*4096kB = 9574840kB
Dec 16 02:55:05 mailserver-1 kernel: Swap cache: add 28, delete 28, find 0/0, race 0+0
Dec 16 02:55:05 mailserver-1 kernel: Free swap  = 1441668kB
Dec 16 02:55:05 mailserver-1 kernel: Total swap = 1441776kB
Dec 16 02:55:05 mailserver-1 kernel: Free swap:       1441668kB
Dec 16 02:55:05 mailserver-1 kernel: [<c011b51a>] do_page_fault+0x0/0x876
Dec 16 02:55:05 mailserver-1 kernel: [<c033153a>] error_code+0x72/0x78
Dec 16 02:55:05 mailserver-1 kernel: [<c02599a9>] clear_user+0x27/0x32
Dec 16 02:55:05 mailserver-1 kernel: [<c0192015>] padzero+0x16/0x24
Dec 16 02:55:05 mailserver-1 kernel: [<c0192a06>] load_elf_binary+0x7d4/0x142b
Dec 16 02:55:05 mailserver-1 kernel: [<c0157fe8>] kmap_high+0x2e/0x1e2
Dec 16 02:55:05 mailserver-1 kernel: [<c0157e52>] page_address+0x78/0x98
Dec 16 02:55:05 mailserver-1 kernel: [<c016fe32>] copy_strings+0x169/0x173
Dec 16 02:55:05 mailserver-1 kernel: [<c016fee7>] search_binary_handler+0x84/0x19c
Dec 16 02:55:05 mailserver-1 kernel: [<c0171170>] do_execve+0x13b/0x1a4
Dec 16 02:55:05 mailserver-1 kernel: [<c01026ed>] sys_execve+0x2f/0x7b
Dec 16 02:55:05 mailserver-1 kernel: [<c0103e0e>] sysenter_past_esp+0x6b/0xa1
Dec 16 02:55:05 mailserver-1 kernel: [<c0330000>] wait_for_completion_timeout+0x7f/0xd6
Dec 16 02:55:05 mailserver-1 kernel: =======================
Dec 16 02:55:05 mailserver-1 kernel: Mem-info:
Dec 16 02:55:05 mailserver-1 kernel: DMA per-cpu:
Dec 16 02:55:05 mailserver-1 kernel: CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 02:55:05 mailserver-1 kernel: CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 02:55:05 mailserver-1 kernel: CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 02:55:05 mailserver-1 kernel: CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 02:55:05 mailserver-1 kernel: CPU    4: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 02:55:05 mailserver-1 kernel: CPU    5: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 02:55:05 mailserver-1 kernel: CPU    6: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 02:55:05 mailserver-1 kernel: CPU    7: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 02:55:05 mailserver-1 kernel: Normal per-cpu:
Dec 16 02:55:05 mailserver-1 kernel: CPU    0: Hot: hi:  186, btch:  31 usd:  30   Cold: hi:   62, btch:  15 usd:  51
Dec 16 02:55:05 mailserver-1 kernel: CPU    1: Hot: hi:  186, btch:  31 usd:  29   Cold: hi:   62, btch:  15 usd:  58
Dec 16 02:55:05 mailserver-1 kernel: CPU    2: Hot: hi:  186, btch:  31 usd:  30   Cold: hi:   62, btch:  15 usd:  54
Dec 16 02:55:05 mailserver-1 kernel: CPU    3: Hot: hi:  186, btch:  31 usd:  25   Cold: hi:   62, btch:  15 usd:  48
Dec 16 02:55:05 mailserver-1 kernel: CPU    4: Hot: hi:  186, btch:  31 usd:  16   Cold: hi:   62, btch:  15 usd:  52
Dec 16 02:55:05 mailserver-1 kernel: CPU    5: Hot: hi:  186, btch:  31 usd:  24   Cold: hi:   62, btch:  15 usd:  57
Dec 16 02:55:05 mailserver-1 kernel: CPU    6: Hot: hi:  186, btch:  31 usd:  21   Cold: hi:   62, btch:  15 usd:  55
Dec 16 02:55:05 mailserver-1 kernel: CPU    7: Hot: hi:  186, btch:  31 usd:  24   Cold: hi:   62, btch:  15 usd:  50
Dec 16 02:55:05 mailserver-1 kernel: HighMem per-cpu:
Dec 16 02:55:05 mailserver-1 kernel: CPU    0: Hot: hi:  186, btch:  31 usd:  26   Cold: hi:   62, btch:  15 usd:   1
Dec 16 02:55:05 mailserver-1 kernel: CPU    1: Hot: hi:  186, btch:  31 usd:  58   Cold: hi:   62, btch:  15 usd:  14
Dec 16 02:55:05 mailserver-1 kernel: CPU    2: Hot: hi:  186, btch:  31 usd:  13   Cold: hi:   62, btch:  15 usd:   9
Dec 16 02:55:05 mailserver-1 kernel: CPU    3: Hot: hi:  186, btch:  31 usd:  83   Cold: hi:   62, btch:  15 usd:   4
Dec 16 02:55:05 mailserver-1 kernel: CPU    4: Hot: hi:  186, btch:  31 usd:   4   Cold: hi:   62, btch:  15 usd:   4
Dec 16 02:55:05 mailserver-1 kernel: CPU    5: Hot: hi:  186, btch:  31 usd: 121   Cold: hi:   62, btch:  15 usd:  11
Dec 16 02:55:05 mailserver-1 kernel: CPU    6: Hot: hi:  186, btch:  31 usd:  79   Cold: hi:   62, btch:  15 usd:  11
Dec 16 02:55:05 mailserver-1 kernel: CPU    7: Hot: hi:  186, btch:  31 usd:  38   Cold: hi:   62, btch:  15 usd:   8
Dec 16 02:55:05 mailserver-1 kernel: Active:506772 inactive:7276 dirty:18 writeback:0 unstable:0
Dec 16 02:55:05 mailserver-1 kernel: free:2395747 slab:23425 mapped:6651 pagetables:1663 bounce:0
Dec 16 02:55:05 mailserver-1 kernel: DMA free:3556kB min:68kB low:84kB high:100kB active:0kB inactive:0kB present:16256kB pages_scanned:0 all_unreclaimable? yes
Dec 16 02:55:05 mailserver-1 kernel: lowmem_reserve[]: 0 873 12938 12938
Dec 16 02:55:05 mailserver-1 kernel: Normal free:3652kB min:3744kB low:4680kB high:5616kB active:104kB inactive:176kB present:894080kB pages_scanned:765 all_unreclaimable? yes
Dec 16 02:55:05 mailserver-1 kernel: lowmem_reserve[]: 0 0 96520 96520
Dec 16 02:55:05 mailserver-1 kernel: HighMem free:9575780kB min:512kB low:13456kB high:26404kB active:2026984kB inactive:28928kB present:12354560kB pages_scanned:0 all_unreclaimable? no
Dec 16 02:55:05 mailserver-1 kernel: lowmem_reserve[]: 0 0 0 0
Dec 16 02:55:05 mailserver-1 kernel: DMA: 17*4kB 10*8kB 9*16kB 2*32kB 2*64kB 0*128kB 0*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3556kB
Dec 16 02:55:05 mailserver-1 kernel: Normal: 138*4kB 48*8kB 38*16kB 8*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 3848kB
Dec 16 02:55:05 mailserver-1 kernel: HighMem: 29918*4kB 106008*8kB 97484*16kB 62058*32kB 34230*64kB 13152*128kB 3490*256kB 502*512kB 24*1024kB 2*2048kB 2*4096kB = 9574840kB
Dec 16 02:55:05 mailserver-1 kernel: Swap cache: add 28, delete 28, find 0/0, race 0+0
Dec 16 02:55:05 mailserver-1 kernel: Free swap  = 1441668kB
Dec 16 02:55:05 mailserver-1 kernel: Total swap = 1441776kB
Dec 16 02:55:05 mailserver-1 kernel: Free swap:       1441668kB
Dec 16 02:55:05 mailserver-1 kernel: out_of_memory+0x69/0x1a4
Dec 16 02:55:05 mailserver-1 kernel: [<c01528d7>] __alloc_pages+0x20a/0x291
Dec 16 02:55:05 mailserver-1 kernel: [<c01696c3>] cache_alloc_refill+0x31b/0x5d2
Dec 16 02:55:05 mailserver-1 kernel: [<c011af2c>] pgd_alloc+0xd7/0x1d7
Dec 16 02:55:05 mailserver-1 kernel: [<c0169bda>] kmem_cache_alloc+0x66/0xbc
Dec 16 02:55:05 mailserver-1 kernel: [<c011af2c>] pgd_alloc+0xd7/0x1d7
Dec 16 02:55:05 mailserver-1 kernel: [<c011af2c>] pgd_alloc+0xd7/0x1d7
Dec 16 02:55:05 mailserver-1 kernel: [<c012364d>] mm_init+0xa1/0xc3
Dec 16 02:55:05 mailserver-1 kernel: [<c0124075>] copy_process+0x8ae/0x109c
Dec 16 02:55:05 mailserver-1 kernel: [<c0133996>] alloc_pid+0x16/0x240
Dec 16 02:55:05 mailserver-1 kernel: [<c0169bf4>] kmem_cache_alloc+0x80/0xbc
Dec 16 02:55:05 mailserver-1 kernel: [<c0133996>] alloc_pid+0x16/0x240
Dec 16 02:55:05 mailserver-1 kernel: [<c0124aaa>] do_fork+0x9a/0x1c2
Dec 16 02:55:05 mailserver-1 kernel: [<c012dad3>] recalc_sigpending+0xb/0x1d
Dec 16 02:55:05 mailserver-1 kernel: [<c012db86>] sigprocmask+0xa1/0xc5
Dec 16 02:55:05 mailserver-1 kernel: [<c01021d1>] sys_clone+0x36/0x3b
Dec 16 02:55:05 mailserver-1 kernel: [<c0103e0e>] sysenter_past_esp+0x6b/0xa1
Dec 16 02:55:05 mailserver-1 kernel: [<c0330000>] wait_for_completion_timeout+0x7f/0xd6
Dec 16 02:55:05 mailserver-1 kernel: =======================
.......................
