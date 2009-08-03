Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n736RaWJ071263 for <xfs@oss.sgi.com>; Mon, 3 Aug 2009 01:27:37 -0500
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5C96739F152
	for <xfs@oss.sgi.com>; Sun,  2 Aug 2009 23:28:23 -0700 (PDT)
Received: from moutng.kundenserver.de (moutng.kundenserver.de [212.227.17.9])
	by cuda.sgi.com with ESMTP id FoGFLyhXVVhTnPMD for
	<xfs@oss.sgi.com>; Sun, 02 Aug 2009 23:28:23 -0700 (PDT)
Received: from localhost ([127.0.0.1])
	by bogon.housecafe.de with esmtp (Exim 4.69)
	(envelope-from <lists@nerdbynature.de>) id 1MXr1x-0000Vk-9C
	for xfs@oss.sgi.com; Mon, 03 Aug 2009 08:28:21 +0200
Date: Sun, 2 Aug 2009 23:28:21 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: kernel BUG at lib/radix-tree.c:464
Message-ID: <alpine.DEB.2.01.0908022321060.5831@bogon.housecafe.de>
MIME-Version: 1.0
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

Hi,

while lots of I/O (read, write) was in progress, this was captured via 
remote syslog:

[33019.357211] ------------[ cut here ]------------
[33019.357269] kernel BUG at lib/radix-tree.c:464!
[33019.357311] invalid opcode: 0000 [#1] SMP 
[33019.357354] last sysfs file: /sys/devices/pci0000:00/0000:00:1f.2/host2/target2:0:0/2:0:0:0/type
[33019.357618] 
[33019.357423] Modules linked in: fuse acpi_cpufreq nfsd lockd nfs_acl auth_rpcgss sunrpc lm75 hwmon usb_storage usb_libusual b43 mac80211 uhci_hcd cfg80211 ehci_hcd tg3 usbcore libphy ssb nls_base
[33019.357722] EIP: 0060:[<c11eaa55>] EFLAGS: 00010246 CPU: 0
[33019.357654] Pid: 225, comm: kswapd0 Tainted: G        W  (2.6.31-rc5 #1) Lenovo          
[33019.357771] EIP is at radix_tree_tag_set+0xc5/0xe0
[33019.357811] EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: 00000001
[33019.357856] ESI: 00000020 EDI: 00000000 EBP: d7ea0dc8 ESP: f70b6e24
[33019.357901]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[33019.357946] Process kswapd0 (pid: 225, ti=f70b6000 task=f710c3d0 task.ti=f70b6000)
[33019.358013] Stack:
[33019.358044]  0beea120 f5d1acc0 00000000 f0baf97c d6624c80 f5d1ac88 0000001e f70b6eac
[33019.358110] <0> c11b946e f0baf97c d6624c80 f70b6eac 00000034 f70b6eac c11a73c5 f0baf97c
[33019.358196] <0> d6624da4 c11b7766 f70b6e68 f0baf97c d6624da4 f0baf97c d6624da4 c10b58e3
[33019.358303] Call Trace:
[33019.358344]  [<c11b946e>] ? xfs_inode_set_reclaim_tag+0x7e/0xc0
[33019.358390]  [<c11a73c5>] ? xfs_reclaim+0x45/0xc0
[33019.358431]  [<c11b7766>] ? xfs_fs_destroy_inode+0x36/0x70
[33019.358475]  [<c10b58e3>] ? destroy_inode+0x73/0xd0
[33019.358517]  [<c10b5fa9>] ? dispose_list+0x79/0xf0
[33019.358558]  [<c10b61ed>] ? shrink_icache_memory+0x1cd/0x2b0
[33019.358603]  [<c107c567>] ? shrink_slab+0x117/0x190
[33019.358645]  [<c107e458>] ? kswapd+0x4a8/0x630
[33019.358688]  [<c107bd50>] ? isolate_pages_global+0x0/0x1f0
[33019.358732]  [<c104ea20>] ? autoremove_wake_function+0x0/0x60
[33019.358776]  [<c107dfb0>] ? kswapd+0x0/0x630
[33019.358815]  [<c104e674>] ? kthread+0x84/0x90
[33019.358854]  [<c104e5f0>] ? kthread+0x0/0x90
[33019.358895]  [<c1003e07>] ? kernel_thread_helper+0x7/0x10
[33019.358933] Code: 00 d3 e2 85 da 75 09 09 da 8b 4c 24 04 89 51 04 8b 54 24 0c 65 33 15 14 00 00 00 75 16 83 c4 10 5b 5e 5f 5d c3 85 c0 74 e7 eb c3 <0f> 0b eb fe 0f 0b eb fe e8 4e c5 e4 ff 8d b4 26 00 00 00 00 8d 
[33019.359221] EIP: [<c11eaa55>] radix_tree_tag_set+0xc5/0xe0 SS:ESP 0068:f70b6e24
[33019.359651] ---[ end trace e312a7d04db27a02 ]---


This looks a lot like #502236 [0] which was reported for 2.6.29 in May. 
The incident above happened just now for 2.6.31-rc5 (today's git), full 
dmesg and .config:

http://nerdbynature.de/bits/2.6.31-rc5/kern.txt
http://nerdbynature.de/bits/2.6.31-rc5/config.gz

# grep xfs /proc/mounts
/dev/mapper/wdc1 /mnt/disk1 xfs rw,nosuid,nodev,noexec,relatime,attr2,noquota 0 0


Note: the kernel was tainted by a WARNING, probably caused by the ext4 
mount[1] on the same box.

Thanks,
Christian.

[0] https://bugzilla.redhat.com/show_bug.cgi?id=502236
[1] http://lkml.org/lkml/2009/8/1/104
-- 
BOFH excuse #66:

bit bucket overflow

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
