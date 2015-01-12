Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EA1127F51
	for <xfs@oss.sgi.com>; Mon, 12 Jan 2015 02:37:02 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AB3808F8035
	for <xfs@oss.sgi.com>; Mon, 12 Jan 2015 00:36:59 -0800 (PST)
Received: from smtp.welcomes-you.com (welcomes-you.com [144.76.218.113]) by
	cuda.sgi.com with ESMTP id ggmQ4AglzlQpgvqp for
	<xfs@oss.sgi.com>; Mon, 12 Jan 2015 00:36:53 -0800 (PST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by smtp.welcomes-you.com (Postfix) with ESMTP id 2837331A2C2F
	for <xfs@oss.sgi.com>; Mon, 12 Jan 2015 09:36:52 +0100 (CET)
Message-ID: <54B387A1.6000807@aei.mpg.de>
Date: Mon, 12 Jan 2015 09:36:49 +0100
From: Carsten Aulbert <Carsten.Aulbert@aei.mpg.de>
MIME-Version: 1.0
Subject: extremely slow file creation/deletion after xfs ran full
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
To: xfs@oss.sgi.com

Hi

a couple of days ago, one of our XFS pools ran full which did not
realize due to some bogged monitoring.

After deleting files, the FS is not filled to about 80-85% and file
creation as well as deletion is extremely slow:

$ cd /srv
$ time touch test
touch test  0.00s user 0.17s system 5% cpu 2.993 total
$ time touch test
touch test  0.00s user 0.00s system 0% cpu 0.002 total
$ time rm test
rm test  0.00s user 0.00s system 0% cpu 4.954 total

As we had seen some XFS error messages like XFS: Internal error
XFS_WANT_CORRUPTED_GOTO[1] shortly before the file system was completely
filled, we umounted it and ran successfully xfs_repair on it[2].

We started to dig into fragmentation levels, but to be honest, I'm not
too sure how to interpret the numbers. All seem pretty innocent to me
except the very high directory fragmentation:

# mount
[...]
/dev/sdb1 on /srv type xfs (rw,relatime,attr2,inode64,noquota)

# uname -a
Linux einstein4 3.14.24-atlas #1 SMP Wed Nov 19 08:29:23 UTC 2014 x86_64
GNU/Linux

(after the reboot to add more RAM, before 3.14.11)
# df -h /dev/sdb1
Filesystem      Size  Used Avail Use% Mounted on
/dev/sdb1        15T   12T  2.7T  82% /srv

# df -i /dev/sdb1
Filesystem         Inodes     IUsed      IFree IUse% Mounted on
/dev/sdb1      3105468352 554441361 2551026991   18% /srv

# xfs_info /dev/sdb1
meta-data=/dev/sdb1              isize=256    agcount=15,
agsize=268435455 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=3881835478, imaxpct=5
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=521728, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

(underneath is a Areca backed 16 disk raid 10 and yes, possibly we
should have gone to more AGs, hindsight is great ;))

# xfs_db -r -c "frag" /dev/sdb1
actual 562488447, ideal 553668062, fragmentation factor 1.57%
# xfs_db -r -c "freesp" /dev/sdb1
   from      to extents  blocks    pct
      1       1 9669664 9669664   1.36
      2       3 5634086 12956862   1.83
      4       7 1720988 8320694   1.17
      8      15  314377 3088702   0.44
     16      31  231279 4941737   0.70
     32      63 10501367 372068430  52.45
     64     127 2604359 204737946  28.86
    128     255  377595 63623350   8.97
    256     511   58744 20198673   2.85
    512    1023    8843 5759074   0.81
   1024    2047    1044 1418464   0.20
   2048    4095     255  685540   0.10
   4096    8191      81  453953   0.06
   8192   16383      14  126863   0.02
  16384   32767      18  373876   0.05
  32768   65535      11  435041   0.06
  65536  131071       6  458767   0.06

# xfs_db -r -c "frag -d" /dev/sdb1
actual 7987218, ideal 67532, fragmentation factor 99.15%
# xfs_db -r -c "frag -f" /dev/sdb1
actual 555079796, ideal 554171759, fragmentation factor 0.16%

Finally, we still xfs error messages in the kernel logs[3].

Questions:
  * Would xfs_fsr be able to cure this problem?
  * Would moving to xfsprogs 3.2 and kernel > 3.15 with on disk format 5
plus crc help to protect against this "wear"?

Cheers

Carsten

PS: Please Cc me, as I'm not subscribed ATM.


[1]Jan  7 20:58:47 einstein4 kernel: [14029681.124548] XFS: Internal
error XFS_WANT_CORRUPTED_GOTO at line 1419 of file fs/xfs/xfs_alloc.c.
Caller 0xffffffffa023594d
Jan  7 20:58:47 einstein4 kernel: [14029681.124657] CPU: 5 PID: 13437
Comm: kworker/5:1 Not tainted 3.14.11-atlas #1
Jan  7 20:58:47 einstein4 kernel: [14029681.124745] Hardware name:
Supermicro X7DVL/X7DVL, BIOS 6.00 11/02/2007
Jan  7 20:58:47 einstein4 kernel: [14029681.124860] Workqueue: xfsalloc
xfs_bmapi_allocate_worker [xfs]
Jan  7 20:58:47 einstein4 kernel: [14029681.124977]  0000000000000000
ffff88013b7ebc80 ffffffff814e9555 ffff88017022bd30
Jan  7 20:58:47 einstein4 kernel: [14029681.125247]  ffffffffa0234aed
ffff88041877c380 0000000000000000 000000000000000c
Jan  7 20:58:47 einstein4 kernel: [14029681.125514]  0000000000000000
0000000100000000 0ff0b98800000000 0000000100000002
Jan  7 20:58:47 einstein4 kernel: [14029681.125783] Call Trace:
Jan  7 20:58:47 einstein4 kernel: [14029681.125856]
[<ffffffff814e9555>] ? dump_stack+0x41/0x51
Jan  7 20:58:47 einstein4 kernel: [14029681.125937]
[<ffffffffa0234aed>] ? xfs_alloc_ag_vextent_size+0x33d/0x650 [xfs]
Jan  7 20:58:47 einstein4 kernel: [14029681.126035]
[<ffffffffa023594d>] ? xfs_alloc_ag_vextent+0x9d/0x100 [xfs]
Jan  7 20:58:47 einstein4 kernel: [14029681.126118]
[<ffffffffa02366c5>] ? xfs_alloc_vextent+0x485/0x610 [xfs]
Jan  7 20:58:47 einstein4 kernel: [14029681.126202]
[<ffffffffa0245ff4>] ? xfs_bmap_btalloc+0x2d4/0x790 [xfs]
Jan  7 20:58:47 einstein4 kernel: [14029681.126286]
[<ffffffffa0246ab1>] ? __xfs_bmapi_allocate+0xd1/0x2e0 [xfs]
Jan  7 20:58:47 einstein4 kernel: [14029681.126366]
[<ffffffffa0216375>] ? xfs_bmapi_allocate_worker+0x35/0x70 [xfs]
Jan  7 20:58:47 einstein4 kernel: [14029681.126456]
[<ffffffff8107d5db>] ? process_one_work+0x16b/0x400
Jan  7 20:58:47 einstein4 kernel: [14029681.126529]
[<ffffffff8107e9c6>] ? worker_thread+0x116/0x380
Jan  7 20:58:47 einstein4 kernel: [14029681.126601]
[<ffffffff8107e8b0>] ? manage_workers.isra.21+0x290/0x290
Jan  7 20:58:47 einstein4 kernel: [14029681.126675]
[<ffffffff81084bcc>] ? kthread+0xbc/0xe0
Jan  7 20:58:47 einstein4 kernel: [14029681.126745]
[<ffffffff81084b10>] ? flush_kthread_worker+0x80/0x80
Jan  7 20:58:47 einstein4 kernel: [14029681.126819]
[<ffffffff814f724c>] ? ret_from_fork+0x7c/0xb0
Jan  7 20:58:47 einstein4 kernel: [14029681.126890]
[<ffffffff81084b10>] ? flush_kthread_worker+0x80/0x80
Jan  7 20:58:47 einstein4 kernel: [14029681.126973] XFS (sdb1): page
discard on page ffffea000b973650, inode 0x8e56233bd, offset 172167168.

[2] multiple times until we had enough RAM installed into the machine
(24GB+swap space finally made the difference)

[3] e.g.
[170369.029932] ------------[ cut here ]------------
[170369.029940] WARNING: CPU: 4 PID: 65 at fs/xfs/xfs_aops.c:1184
xfs_vm_releasepage+0xb5/0xc0 [xfs]()
[170369.029942] Modules linked in: dm_mod nfsv3 tun xt_nat autofs4
ipt_REJECT ipt_MASQUERADE xt_state iptable_nat nf_nat_ipv4 nf_nat
nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack iptable_filter ip_tables
xt_tcpudp x_tables nfsd auth_rpcgss oid_registry nfs_acl nfs lockd
fscache sunrpc ext4 crc16 mbcache jbd2 ipmi_poweroff ipmi_watchdog
ipmi_devintf ipmi_si ipmi_msghandler iTCO_wdt iTCO_vendor_support ttm
drm_kms_helper drm coretemp i5000_edac edac_core lpc_ich i5k_amb
mfd_core ioatdma sr_mod cdrom i2c_algo_bit i2c_i801 rng_core i2c_core
joydev dca psmouse ehci_pci snd_pcm snd_timer snd soundcore pcspkr
serio_raw shpchp processor parport_pc parport evdev kvm thermal_sys
button xfs crc32c libcrc32c md_mod usb_storage hid_generic usbhid hid
sd_mod sg crc_t10dif crct10dif_common floppy ahci libahci libata
uhci_hcd e1000 ehci_hcd arcmsr usbcore usb_common scsi_mod e1000e ptp
pps_core
[170369.029986] CPU: 4 PID: 65 Comm: kswapd0 Tainted: G        W
3.14.24-atlas #1
[170369.029986] Hardware name: Supermicro X7DVL/X7DVL, BIOS 6.00 11/02/2007
[170369.029987]  0000000000000009 ffff88060d461a18 ffffffff81529af8
0000000000000000
[170369.029989]  0000000000000000 ffff88060d461a58 ffffffff8106a37c
ffff880610389d40
[170369.029991]  ffff88060d461b28 ffffea000f39f8a0 ffff8805f722dd98
ffffea000f39f8c0
[170369.029994] Call Trace:
[170369.029994]  [<ffffffff81529af8>] dump_stack+0x46/0x58
[170369.029996]  [<ffffffff8106a37c>] warn_slowpath_common+0x8c/0xc0
[170369.029998]  [<ffffffff8106a3ca>] warn_slowpath_null+0x1a/0x20
[170369.030000]  [<ffffffffa0212225>] xfs_vm_releasepage+0xb5/0xc0 [xfs]
[170369.030009]  [<ffffffff81182a10>] ? anon_vma_prepare+0x140/0x140
[170369.030011]  [<ffffffff81149902>] try_to_release_page+0x32/0x50
[170369.030014]  [<ffffffff8115ed7a>] shrink_active_list+0x3aa/0x3b0
[170369.030016]  [<ffffffff8115f154>] shrink_lruvec+0x3d4/0x6a0
[170369.030017]  [<ffffffff811aa001>] ?
__mem_cgroup_largest_soft_limit_node+0x21/0xd0
[170369.030019]  [<ffffffff811aa001>] ?
__mem_cgroup_largest_soft_limit_node+0x21/0xd0
[170369.030021]  [<ffffffff8115f486>] shrink_zone+0x66/0x1a0
[170369.030023]  [<ffffffff8116065c>] balance_pgdat+0x3ac/0x600
[170369.030025]  [<ffffffff81160a34>] kswapd+0x184/0x470
[170369.030027]  [<ffffffff810ae460>] ? finish_wait+0x80/0x80
[170369.030028]  [<ffffffff811608b0>] ? balance_pgdat+0x600/0x600
[170369.030030]  [<ffffffff8108da79>] kthread+0xc9/0xe0
[170369.030032]  [<ffffffff8108d9b0>] ? flush_kthread_worker+0x80/0x80
[170369.030034]  [<ffffffff81538cfc>] ret_from_fork+0x7c/0xb0
[170369.030035]  [<ffffffff8108d9b0>] ? flush_kthread_worker+0x80/0x80
[170369.030038] ---[ end trace 9f4d705dbe4e039c ]---

-- 
Dr. Carsten Aulbert - Max Planck Institute for Gravitational Physics
Callinstrasse 38, 30167 Hannover, Germany
phone/fax: +49 511 762-17185 / -17193
https://wiki.atlas.aei.uni-hannover.de/foswiki/bin/view/ATLAS/WebHome

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
