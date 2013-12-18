Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4691B7F3F
	for <xfs@oss.sgi.com>; Wed, 18 Dec 2013 09:01:17 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A9BF3AC003
	for <xfs@oss.sgi.com>; Wed, 18 Dec 2013 07:01:13 -0800 (PST)
Received: from dakara.d-tor.org (dakara.d-tor.org [88.198.161.242]) by
	cuda.sgi.com with ESMTP id oVSvLq4pgUBw2GPR for
	<xfs@oss.sgi.com>; Wed, 18 Dec 2013 07:01:11 -0800 (PST)
Message-ID: <52B1B89A.8030401@disconnect.de>
Date: Wed, 18 Dec 2013 16:00:42 +0100
From: arno <arno@disconnect.de>
MIME-Version: 1.0
Subject: [XFS BUG] xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed: Structure
	needs cleaning
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
To: xfs@oss.sgi.com, linux-kernel@vger.kernel.org

Hello,

(Please keep me in CC, I'm not subscribed)

Just got "xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed: Structure
needs cleaning" when trying to grow a logical Volume. Sorry, I lost the
xfs_growfs output.

After collecting some info, I ran xfs_repair, and that seemed to fix it,
so no harm done. After fixing, the FS had the new, increased size, if
that matters.

Setup:
1. RAID5 with 4 disks
~~
$ cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md1 : active raid5 sdh[4] sde[0] sdf[1] sdg[2]
      8790405120 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/4]
[UUUU]

md127 : active raid5 sda2[2] sdb2[0] sdd2[3] sdc2[1]
      1464862656 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]
~~

2. A Volume group on md127 with the logical volume in question. The LV
is crypted with LUKS:
~~
am@hadante ~ $ sudo cryptsetup status /dev/mapper/mp3-c
/dev/mapper/mp3-c is active and is in use.
  type:    LUKS1
  cipher:  aes-cbc-essiv:sha256
  keysize: 256 bits
  device:  /dev/mapper/raid-mp3
  offset:  2056 sectors
  size:    209713144 sectors
  mode:    read/write
~~

3. XFS on the crypted LV

What I did:
1. extend the LV: lvextend -L +10G /dev/mapper/raid-mp3
2. resize the mapped device: cryptsetup resize /dev/mapper/mp3-c
3. grow the filesystem: xfs_growfs /dev/mapper/mp3-c

dmesg (The kernel is tainted because of the nvidia proprietary module):
~~
[1498234.705668] ffff8804069f3a00: 58 46 53 42 00 00 10 00 00 00 00 00
01 67 fe ff  XFSB.........g..
[1498234.705673] ffff8804069f3a10: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00  ................
[1498234.705675] ffff8804069f3a20: f3 01 07 26 71 bc 48 5f bf 86 66 c8
2c ca 2d 21  ...&q.H_..f.,.-!
[1498234.705676] ffff8804069f3a30: 00 00 00 00 00 80 00 04 00 00 00 00
00 00 00 80  ................
[1498234.705679] XFS (dm-19): Internal error xfs_sb_read_verify at line
628 of file fs/xfs/xfs_sb.c.  Caller 0xffffffffa04b4e05

[1498234.705682] CPU: 5 PID: 123 Comm: kworker/5:1H Tainted: P
 O 3.12.1-3-ARCH #1
[1498234.705684] Hardware name: System manufacturer System Product
Name/M5A87, BIOS 0404    04/19/2011
[1498234.705713] Workqueue: xfslogd xfs_buf_iodone_work [xfs]
[1498234.705714]  0000000000000001 ffff88041ff73d70 ffffffff814ed7ab
ffff880420f3a800
[1498234.705717]  ffff88041ff73d88 ffffffffa04b80db ffffffffa04b4e05
ffff88041ff73dc0
[1498234.705719]  ffffffffa04b8135 000002741fb2c500 ffff8803000cd080
0000000000000075
[1498234.705721] Call Trace:
[1498234.705727]  [<ffffffff814ed7ab>] dump_stack+0x54/0x8d
[1498234.705736]  [<ffffffffa04b80db>] xfs_error_report+0x3b/0x40 [xfs]
[1498234.705744]  [<ffffffffa04b4e05>] ? xfs_buf_iodone_work+0x75/0xa0 [xfs]
[1498234.705752]  [<ffffffffa04b8135>] xfs_corruption_error+0x55/0x80 [xfs]
[1498234.705763]  [<ffffffffa0510a23>] xfs_sb_read_verify+0x113/0x130 [xfs]
[1498234.705772]  [<ffffffffa04b4e05>] ? xfs_buf_iodone_work+0x75/0xa0 [xfs]
[1498234.705779]  [<ffffffffa04b4e05>] xfs_buf_iodone_work+0x75/0xa0 [xfs]
[1498234.705782]  [<ffffffff8107dae7>] process_one_work+0x167/0x450
[1498234.705784]  [<ffffffff8107e4f1>] worker_thread+0x121/0x3a0
[1498234.705786]  [<ffffffff8107e3d0>] ? manage_workers.isra.23+0x2b0/0x2b0
[1498234.705789]  [<ffffffff81084e80>] kthread+0xc0/0xd0
[1498234.705791]  [<ffffffff81084dc0>] ? kthread_create_on_node+0x120/0x120
[1498234.705793]  [<ffffffff814fc27c>] ret_from_fork+0x7c/0xb0
[1498234.705795]  [<ffffffff81084dc0>] ? kthread_create_on_node+0x120/0x120
[1498234.705797] XFS (dm-19): Corruption detected. Unmount and run
xfs_repair
[1498234.705819] XFS (dm-19): metadata I/O error: block 0x7cff600
("xfs_trans_read_buf_map") error 117 numblks 1
[1498234.705826] XFS (dm-19): error 117 reading secondary superblock for
ag 5
[1498687.134755] XFS (dm-19): Mounting Filesystem
[1498687.308207] XFS (dm-19): Ending clean mount
~~

xfs_db -r -c "sb 0" -c p -c "sb 5" -c p /dev/mapper/mp3-c output
_before_ repair:
~~
magicnum = 0x58465342
blocksize = 4096
dblocks = 26214143
rblocks = 0
rextents = 0
uuid = f3010726-71bc-485f-bf86-66c82cca2d21
logstart = 8388612
rootino = 128
rbmino = 129
rsumino = 130
rextsize = 1
agblocks = 3276736
agcount = 9
rbmblocks = 0
logblocks = 6399
versionnum = 0xb4b4
sectsize = 512
inodesize = 256
inopblock = 16
fname = "\000\000\000\000\000\000\000\000\000\000\000\000"
blocklog = 12
sectlog = 9
inodelog = 8
inopblog = 4
agblklog = 22
rextslog = 0
inprogress = 0
imax_pct = 25
icount = 16064
ifree = 92
fdblocks = 3807868
frextents = 0
uquotino = 0
gquotino = 0
qflags = 0
flags = 0
shared_vn = 0
inoalignmt = 2
unit = 0
width = 0
dirblklog = 0
logsectlog = 0
logsectsize = 0
logsunit = 1
features2 = 0x8
bad_features2 = 0x8
magicnum = 0x58465342
blocksize = 4096
dblocks = 23592703
rblocks = 0
rextents = 0
uuid = f3010726-71bc-485f-bf86-66c82cca2d21
logstart = 8388612
rootino = 128
rbmino = 129
rsumino = 130
rextsize = 1
agblocks = 3276736
agcount = 8
rbmblocks = 0
logblocks = 6399
versionnum = 0xb4b4
sectsize = 512
inodesize = 256
inopblock = 16
fname = "\000\000\000\000\000\000\000\000\000\000\000\000"
blocklog = 12
sectlog = 9
inodelog = 8
inopblog = 4
agblklog = 22
rextslog = 0
inprogress = 0
imax_pct = 25
icount = 14912
ifree = 90
fdblocks = 769394
frextents = 0
uquotino = 0
gquotino = 0
qflags = 0
flags = 0
shared_vn = 0
inoalignmt = 2
unit = 0
width = 0
dirblklog = 0
logsectlog = 0
logsectsize = 0
logsunit = 1
features2 = 0x8
bad_features2 = 0x8
~~

xfs_repair output:
~~
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
primary/secondary superblock 5 conflict - AG superblock geometry info
conflicts with filesystem geometry
reset bad sb for ag 5
primary/secondary superblock 6 conflict - AG superblock geometry info
conflicts with filesystem geometry
reset bad sb for ag 6
primary/secondary superblock 7 conflict - AG superblock geometry info
conflicts with filesystem geometry
reset bad sb for ag 7
bad on-disk superblock 8 - bad magic number
primary/secondary superblock 8 conflict - AG superblock geometry info
conflicts with filesystem geometry
reset bad sb for ag 8
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - agno = 8
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
        - agno = 5
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 6
        - agno = 7
        - agno = 8
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
done
~~

kernel version:
~~
am@hadante ~ $ uname -a
Linux hadante 3.12.1-3-ARCH #1 SMP PREEMPT Tue Nov 26 11:17:02 CET 2013
x86_64 GNU/Linux
~~

lsmod:
~~
Module                  Size  Used by
nls_cp437               5961  0
vfat                   10063  0
fat                    51827  1 vfat
usb_storage            48007  0
lp                      9234  0
fuse                   74768  3
vhost_net              10194  1
vhost                  18526  1 vhost_net
macvtap                10673  1 vhost_net
macvlan                 9645  1 macvtap
nf_conntrack_netlink    28650  0
nfnetlink               4301  1 nf_conntrack_netlink
xts                     3015  2
gf128mul                5866  1 xts
nfsd                  267349  11
auth_rpcgss            48892  1 nfsd
oid_registry            2307  1 auth_rpcgss
nfs_acl                 2623  1 nfsd
sha256_generic         10244  16
cbc                     2744  8
dm_crypt               15247  10
nf_conntrack_ipv6       9809  2
nf_defrag_ipv6         25699  1 nf_conntrack_ipv6
ip6table_filter         1436  1
ip6_tables             17056  1 ip6table_filter
iptable_mangle          1592  0
ipt_REJECT              2449  3
ebt_ip                  1646  2
xt_tcpudp               3151  9
ebtable_filter          1807  1
xt_comment               971  4
ebtables               24210  1 ebtable_filter
xt_conntrack            3273  4
iptable_filter          1496  1
tun                    19599  7 vhost_net
ipt_MASQUERADE          2162  1
iptable_nat             3366  1
nf_conntrack_ipv4       9206  3
nf_defrag_ipv4          1411  1 nf_conntrack_ipv4
nf_nat_ipv4             3576  1 iptable_nat
nf_nat                 12343  3 ipt_MASQUERADE,nf_nat_ipv4,iptable_nat
nf_conntrack           73690  8
ipt_MASQUERADE,nf_nat,nf_nat_ipv4,xt_conntrack,nf_conntrack_netlink,iptable_nat,nf_conntrack_ipv4,
nf_conntrack_ipv6
iptable_raw             1388  0
ip_tables              17282  4
iptable_filter,iptable_mangle,iptable_nat,iptable_raw
x_tables               17359  13
ip6table_filter,xt_comment,ip_tables,xt_tcpudp,ipt_MASQUERADE,ebt_ip,xt_conntrack,iptable_filter,
ebtables,ipt_REJECT,iptable_mangle,ip6_tables,iptable_raw
hwmon_vid               3268  0
bridge                 97030  0
stp                     1661  1 bridge
llc                     3761  2 stp,bridge
kvm_amd                52575  4
nvidia              10573185  41
kvm                   389093  1 kvm_amd
snd_hda_codec_hdmi     30162  4
ext4                  474187  1
ppdev                   7126  0
crc16                   1367  1 ext4
mbcache                 6082  1 ext4
jbd2                   83504  1 ext4
microcode              15024  0
snd_hda_codec_realtek    39515  1
psmouse                85428  0
snd_hda_intel          36904  3
serio_raw               5049  0
snd_hda_codec         149569  3
snd_hda_codec_realtek,snd_hda_codec_hdmi,snd_hda_intel
pcspkr                  2035  0
e100                   30960  0
snd_hwdep               6340  1 snd_hda_codec
drm                   238206  2 nvidia
snd_pcm                77709  4
snd_hda_codec_hdmi,snd_hda_codec,snd_hda_intel
evdev                  10989  7
sp5100_tco              5824  0
joydev                  9671  0
r8169                  58399  0
parport_pc             19543  1
i2c_piix4              10592  0
parport                30549  3 lp,ppdev,parport_pc
k10temp                 3058  0
mii                     4035  2 e100,r8169
snd_page_alloc          7242  2 snd_pcm,snd_hda_intel
snd_timer              18726  2 snd_pcm
shpchp                 25465  0
acpi_cpufreq           10779  1
snd                    59173  11
snd_hda_codec_realtek,snd_hwdep,snd_timer,snd_hda_codec_hdmi,snd_pcm,snd_hda_codec,snd_hda_intel
asus_atk0110           12008  0
wmi                     8419  0
soundcore               5450  1 snd
i2c_core               24164  3 drm,i2c_piix4,nvidia
edac_core              44681  0
edac_mce_amd           13094  0
processor              24999  7 acpi_cpufreq
button                  4677  0
nfs                   191701  0
lockd                  76942  2 nfs,nfsd
sunrpc                231063  78 nfs,nfsd,auth_rpcgss,lockd,nfs_acl
fscache                47028  1 nfs
sg                     25657  0
xfs                   808699  9
crc32c                  1744  1
libcrc32c               1010  1 xfs
dm_mod                 82469  69 dm_crypt
raid456                69677  2
async_raid6_recov       5638  1 raid456
async_memcpy            1822  2 raid456,async_raid6_recov
async_pq                4452  2 raid456,async_raid6_recov
async_xor               3457  3 async_pq,raid456,async_raid6_recov
xor                    11832  1 async_xor
async_tx                2134  5
async_pq,raid456,async_xor,async_memcpy,async_raid6_recov
raid6_pq               91142  2 async_pq,async_raid6_recov
hid_generic             1161  0
md_mod                105996  3 raid456
hid_microsoft           3114  0
usbhid                 40577  0
hid                    90678  3 hid_generic,hid_microsoft,usbhid
sr_mod                 14898  0
cdrom                  34848  1 sr_mod
sd_mod                 30789  13
ahci                   22896  9
libahci                21401  1 ahci
ohci_pci                4072  0
libata                170792  2 ahci,libahci
ehci_pci                4000  0
ohci_hcd               23937  1 ohci_pci
xhci_hcd              146970  0
ehci_hcd               59220  1 ehci_pci
scsi_mod              130669  5 sg,usb_storage,libata,sd_mod,sr_mod
usbcore               179880  7
usb_storage,ohci_hcd,ohci_pci,ehci_hcd,ehci_pci,usbhid,xhci_hcd
usb_common              1656  1 usbcore
~~

-- 
Regards,
Arno.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
