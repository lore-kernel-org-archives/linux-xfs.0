Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p36AG0LQ029824 for <xfs@oss.sgi.com>; Wed, 6 Apr 2011 05:16:00 -0500
Received: from serv132.fzu.cz (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D18E53A9F91
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2011 03:19:13 -0700 (PDT)
Received: from serv132.fzu.cz (serv132.fzu.cz [147.231.26.132]) by
	cuda.sgi.com with ESMTP id FH0FaF8c6S6QwyVn for
	<xfs@oss.sgi.com>; Wed, 06 Apr 2011 03:19:13 -0700 (PDT)
Message-ID: <4D9C3E14.6030009@fzu.cz>
Date: Wed, 06 Apr 2011 12:19:00 +0200
From: =?UTF-8?B?SmFuIEt1bmRyw6F0?= <kundratj@fzu.cz>
MIME-Version: 1.0
Subject: SL's kickstart corrupting XFS by "repairing" GPT labels?
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0505432338563832184=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: lcg-admin@fzu.cz

This is a cryptographically signed message in MIME format.

--===============0505432338563832184==
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms030200080109060400010804"

This is a cryptographically signed message in MIME format.

--------------ms030200080109060400010804
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Dear XFS developers,
I'd like to ask for some help with troubleshooting the following issue
which occurred almost simultaneously on three systems connected to one
physically isolated island of our FC infrastructure. The machines in
question are all running SL5.4 (a RHEL-5.4 clone), two of them are IBM
x3650 M2, one is a HP DL360 G6. All hosts have a "Fibre Channel: QLogic
Corp. ISP2432-based 4Gb Fibre Channel to PCI Express HBA" FC HBA and are
located in the same physical rack, along with FC switches and the disk
arrays. The machines are connected over a pair of FC switches (IBM
System Storage SAN24B-4, by Brocade) to three disk arrays (Nexsan
SATABeast2). All boxes have run without any issues for more than a year.

The disk arrays are configured to export 16TB block devices to the
hosts. It looks like we set up GPT labeling on the raw block devices
back when we installed the machines, but since that, we've created XFS
filesystems on raw devices, without any partitioning below. There's
still the secondary GPT header at the end of the block device, though,
and a record [1] in RHEL4's Bugzilla mentions that certain tools invoked
by the init scripts could try to "fix" the GPT entry at the beginning of
the partition. Please note that we're running SL 5.4, not 4.x, so this
issue should not affect us.

Anyway, this is how our trouble started on one of the IBM machines,
named dpmpool5:

Mar 30 12:19:33 dpmpool5 kernel: Filesystem "dm-6": XFS internal error
xfs_btree_check_sblock at line 307 of file fs/xfs/xfs_btree.c.  Caller
0xffffffff885281d9
Mar 30 12:19:33 dpmpool5 kernel:
Mar 30 12:19:33 dpmpool5 kernel: Call Trace:
Mar 30 12:19:33 dpmpool5 kernel:  [<ffffffff88518bfa>]
:xfs:xfs_btree_check_sblock+0xaf/0xbe
Mar 30 12:19:33 dpmpool5 kernel:  [<ffffffff885281d9>]
:xfs:xfs_inobt_lookup+0x10c/0x2ac
Mar 30 12:19:33 dpmpool5 kernel:  [<ffffffff88527759>]
:xfs:xfs_dialloc+0x276/0x809
Mar 30 12:19:34 dpmpool5 kernel:  [<ffffffff8852db85>]
:xfs:xfs_ialloc+0x5f/0x57f
Mar 30 12:19:34 dpmpool5 kernel:  [<ffffffff8853f6df>]
:xfs:xfs_dir_ialloc+0x86/0x2b7
Mar 30 12:19:34 dpmpool5 kernel:  [<ffffffff88534080>]
:xfs:xlog_grant_log_space+0x204/0x25c
Mar 30 12:19:34 dpmpool5 kernel:  [<ffffffff885421b4>]
:xfs:xfs_create+0x237/0x45c
Mar 30 12:19:34 dpmpool5 kernel:  [<ffffffff88507d53>]
:xfs:xfs_attr_get+0x8e/0x9f
Mar 30 12:19:34 dpmpool5 kernel:  [<ffffffff8854ba5c>]
:xfs:xfs_vn_mknod+0x144/0x215
Mar 30 12:19:34 dpmpool5 kernel:  [<ffffffff8003a603>] vfs_create+0xe6/0x=
158
Mar 30 12:19:34 dpmpool5 kernel:  [<ffffffff8001b109>]
open_namei+0x19d/0x6d5
Mar 30 12:19:34 dpmpool5 kernel:  [<ffffffff80027563>]
do_filp_open+0x1c/0x38
Mar 30 12:19:34 dpmpool5 kernel:  [<ffffffff80019e8d>] do_sys_open+0x44/0=
xbe
Mar 30 12:19:34 dpmpool5 kernel:  [<ffffffff8005d28d>] tracesys+0xd5/0xe0=


The same issue re-occurs at 12:25:52, 12:56:27 and 13:29:58. After that,
it happened on dm-1 at 14:04:43, and the log then reads:

Mar 30 14:04:44 dpmpool5 kernel: xfs_force_shutdown(dm-1,0x8) called
from line 4269 of file fs/xfs/xfs_bmap.c.  Return address =3D
0xffffffff8850d796
Mar 30 14:04:44 dpmpool5 kernel: Filesystem "dm-1": Corruption of
in-memory data detected.  Shutting down filesystem: dm-1
Mar 30 14:04:44 dpmpool5 kernel: Please umount the filesystem, and
rectify the problem(s)

Then the dm-6 oopsed again:

Mar 30 14:04:46 dpmpool5 kernel: Filesystem "dm-6": XFS internal error
xfs_btree_check_sblock at line 307 of file fs/xfs/xfs_btree.c.  Caller
0xffffffff885281d9
Mar 30 14:04:46 dpmpool5 kernel:
Mar 30 14:04:46 dpmpool5 kernel: Call Trace:
Mar 30 14:04:46 dpmpool5 kernel:  [<ffffffff88518bfa>]
:xfs:xfs_btree_check_sblock+0xaf/0xbe
Mar 30 14:04:46 dpmpool5 kernel:  [<ffffffff885281d9>]
:xfs:xfs_inobt_lookup+0x10c/0x2ac
Mar 30 14:04:46 dpmpool5 kernel:  [<ffffffff88518727>]
:xfs:xfs_btree_init_cursor+0x31/0x1a3
Mar 30 14:04:46 dpmpool5 kernel:  [<ffffffff88526f9c>]
:xfs:xfs_difree+0x17c/0x452
Mar 30 14:04:46 dpmpool5 kernel:  [<ffffffff8852e550>]
:xfs:xfs_ifree+0x3b/0xf8
Mar 30 14:04:46 dpmpool5 kernel:  [<ffffffff88544141>]
:xfs:xfs_inactive+0x312/0x40f
Mar 30 14:04:46 dpmpool5 kernel:  [<ffffffff8854e8cd>]
:xfs:xfs_fs_clear_inode+0xa4/0xeb
Mar 30 14:04:46 dpmpool5 kernel:  [<ffffffff80022f1e>]
clear_inode+0xd2/0x123
Mar 30 14:04:46 dpmpool5 kernel:  [<ffffffff8002f450>]
generic_delete_inode+0xde/0x143
Mar 30 14:04:46 dpmpool5 kernel:  [<ffffffff8003c7a0>]
do_unlinkat+0xd5/0x141
Mar 30 14:04:46 dpmpool5 kernel:  [<ffffffff8005d229>] tracesys+0x71/0xe0=

Mar 30 14:04:46 dpmpool5 kernel:  [<ffffffff8005d28d>] tracesys+0xd5/0xe0=

Mar 30 14:04:46 dpmpool5 kernel:
Mar 30 14:04:46 dpmpool5 kernel: xfs_difree: xfs_inobt_lookup_le
returned()  an error 117 on dm-6.  Returning error.
Mar 30 14:04:46 dpmpool5 kernel: xfs_inactive:  xfs_ifree() returned an
error =3D 117 on dm-6
Mar 30 14:04:46 dpmpool5 kernel: xfs_force_shutdown(dm-6,0x1) called
from line 1406 of file fs/xfs/xfs_vnodeops.c.  Return address =3D
0xffffffff88544183
Mar 30 14:04:46 dpmpool5 kernel: Filesystem "dm-6": I/O Error Detected.
 Shutting down filesystem: dm-6
Mar 30 14:04:46 dpmpool5 kernel: Please umount the filesystem, and
rectify the problem(s)
Mar 30 14:04:49 dpmpool5 kernel: Filesystem "dm-6": xfs_log_force: error
5 returned.
Mar 30 14:04:52 dpmpool5 kernel: Filesystem "dm-1": xfs_log_force: error
5 returned.
Mar 30 14:05:07 dpmpool5 kernel: Filesystem "dm-6": xfs_log_force: error
5 returned.

The error also showed up on other filesystems, I'm not including them
here, as they're the same as what I've already shown.

Then, at 15:59:30, someone (very likely a colleague) tried to mount
filesystem dm-0 (it was umounted as a result of an internal XFS error at
14:08:07). This is what showed up in the kernel's log:

Mar 30 15:59:30 dpmpool5 kernel: Filesystem "dm-0": Disabling barriers,
trial barrier write failed
Mar 30 15:59:30 dpmpool5 kernel: XFS mounting filesystem dm-0
Mar 30 15:59:30 dpmpool5 kernel: Starting XFS recovery on filesystem:
dm-0 (logdev: internal)
Mar 30 15:59:30 dpmpool5 kernel: 00000000: 45 46 49 20 50 41 52 54 00 00
01 00 5c 00 00 00  EFI PART....\...
Mar 30 15:59:30 dpmpool5 kernel: Filesystem "dm-0": XFS internal error
xfs_alloc_read_agf at line 2194 of file fs/xfs/xfs_alloc.c.  Caller
0xffffffff885044ed
Mar 30 15:59:30 dpmpool5 kernel:
Mar 30 15:59:30 dpmpool5 kernel: Call Trace:
Mar 30 15:59:30 dpmpool5 kernel:  [<ffffffff885028b7>]
:xfs:xfs_alloc_read_agf+0x10f/0x192
Mar 30 15:59:30 dpmpool5 kernel:  [<ffffffff885044ed>]
:xfs:xfs_alloc_fix_freelist+0x45/0x418
Mar 30 15:59:30 dpmpool5 kernel:  [<ffffffff885044ed>]
:xfs:xfs_alloc_fix_freelist+0x45/0x418
Mar 30 15:59:30 dpmpool5 kernel:  [<ffffffff8005c1d5>]
cache_alloc_refill+0x106/0x186
Mar 30 15:59:31 dpmpool5 kernel:  [<ffffffff88544ce2>]
:xfs:kmem_zone_alloc+0x56/0xa3
Mar 30 15:59:31 dpmpool5 kernel:  [<ffffffff8005c1d5>]
cache_alloc_refill+0x106/0x186
Mar 30 15:59:31 dpmpool5 kernel:  [<ffffffff80064644>] __down_read+0x12/0=
x92
Mar 30 15:59:31 dpmpool5 kernel:  [<ffffffff88504948>]
:xfs:xfs_free_extent+0x88/0xc9
Mar 30 15:59:31 dpmpool5 kernel:  [<ffffffff88535297>]
:xfs:xlog_recover_process_efi+0x112/0x16c
Mar 30 15:59:31 dpmpool5 kernel:  [<ffffffff8854edb4>]
:xfs:xfs_fs_fill_super+0x0/0x3e4
Mar 30 15:59:31 dpmpool5 kernel:  [<ffffffff8853648a>]
:xfs:xlog_recover_process_efis+0x4f/0x8d
Mar 30 15:59:31 dpmpool5 kernel:  [<ffffffff885364dc>]
:xfs:xlog_recover_finish+0x14/0xad
Mar 30 15:59:31 dpmpool5 kernel:  [<ffffffff8854edb4>]
:xfs:xfs_fs_fill_super+0x0/0x3e4
Mar 30 15:59:31 dpmpool5 kernel:  [<ffffffff8853afe8>]
:xfs:xfs_mountfs+0x498/0x5e2
Mar 30 15:59:31 dpmpool5 kernel:  [<ffffffff8853b70a>]
:xfs:xfs_mru_cache_create+0x113/0x143
Mar 30 15:59:31 dpmpool5 kernel:  [<ffffffff8854efb7>]
:xfs:xfs_fs_fill_super+0x203/0x3e4
Mar 30 15:59:31 dpmpool5 kernel:  [<ffffffff800e4913>]
get_sb_bdev+0x10a/0x16c
Mar 30 15:59:31 dpmpool5 kernel:  [<ffffffff800e42b0>]
vfs_kern_mount+0x93/0x11a
Mar 30 15:59:31 dpmpool5 kernel:  [<ffffffff800e4379>]
do_kern_mount+0x36/0x4d
Mar 30 15:59:31 dpmpool5 kernel:  [<ffffffff800eeab4>] do_mount+0x6a9/0x7=
19
Mar 30 15:59:31 dpmpool5 kernel:  [<ffffffff8000c6be>]
_atomic_dec_and_lock+0x39/0x57
Mar 30 15:59:31 dpmpool5 kernel:  [<ffffffff8002ca97>]
mntput_no_expire+0x19/0x89
Mar 30 15:59:31 dpmpool5 kernel:  [<ffffffff8000a7b5>]
__link_path_walk+0xf1a/0xf5b
Mar 30 15:59:31 dpmpool5 kernel:  [<ffffffff8002ca97>]
mntput_no_expire+0x19/0x89
Mar 30 15:59:31 dpmpool5 kernel:  [<ffffffff8000eaaf>]
link_path_walk+0xa6/0xb2
Mar 30 15:59:31 dpmpool5 kernel:  [<ffffffff800cc3e1>]
zone_statistics+0x3e/0x6d
Mar 30 15:59:31 dpmpool5 kernel:  [<ffffffff8000f339>]
__alloc_pages+0x78/0x308
Mar 30 15:59:31 dpmpool5 kernel:  [<ffffffff8004c503>] sys_mount+0x8a/0xc=
d
Mar 30 15:59:31 dpmpool5 kernel:  [<ffffffff8005d28d>] tracesys+0xd5/0xe0=

Mar 30 15:59:31 dpmpool5 kernel:
Mar 30 15:59:31 dpmpool5 kernel: Failed to recover EFIs on filesystem: dm=
-0
Mar 30 15:59:31 dpmpool5 kernel: XFS: log mount finish failed
Mar 30 15:59:31 dpmpool5 multipathd: dm-0: umount map (uevent)

It looks like the "Failed to recover EFIs on filesystem" is not related
to the EFI GPTs, right? What puzzles me, though, is the hex dump of the
disk contents (is that the XFS superblock?) which clearly shows trace of
the EFI GPT partitioning.

This is how `multipath -ll` for dm-0 looks like:

atlas_fs13 (36000402002fc56806185f26f00000000) dm-0 NEXSAN,SATABeast2
[size=3D16T][features=3D1 queue_if_no_path][hwhandler=3D0][rw]
\_ round-robin 0 [prio=3D8][active]
 \_ 1:0:0:2  sdaa 65:160 [active][ready]
\_ round-robin 0 [prio=3D4][enabled]
 \_ 1:0:2:2  sdai 66:32  [active][ready]
\_ round-robin 0 [prio=3D7][enabled]
 \_ 2:0:0:2  sdau 66:224 [active][ready]
\_ round-robin 0 [prio=3D3][enabled]
 \_ 2:0:3:2  sdbg 67:160 [active][ready]
\_ round-robin 0 [prio=3D6][enabled]
 \_ 3:0:0:2  sdbs 68:96  [active][ready]
\_ round-robin 0 [prio=3D2][enabled]
 \_ 3:0:2:2  sdca 68:224 [active][ready]
\_ round-robin 0 [prio=3D5][enabled]
 \_ 0:0:0:2  sdc  8:32   [active][ready]
\_ round-robin 0 [prio=3D1][enabled]
 \_ 0:0:3:2  sdo  8:224  [active][ready]

=2E..and this is the start of the underlying block device:

[root@dpmpool5 ~]# hexdump -C -n 128 -v /dev/sdo
00000000  58 46 53 42 00 00 10 00  00 00 00 01 05 fa 59 00
|XFSB..........Y.|
00000010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
|................|
00000020  d3 7e ea ba 92 e0 43 14  9c d5 19 42 2f db 1f e2
|.~....C....B/...|
00000030  00 00 00 01 00 00 00 04  00 00 00 00 00 00 00 80
|................|
00000040  00 00 00 00 00 00 00 81  00 00 00 00 00 00 00 82
|................|
00000050  00 00 00 01 08 2f d2 c8  00 00 00 20 00 00 00 00  |...../.....
=2E...|
00000060  00 00 80 00 30 84 02 00  01 00 00 10 00 00 00 00
|....0...........|
00000070  00 00 00 00 00 00 00 00  0c 09 08 04 1c 00 00 19
|................|
00000080

The traces from other two machines are very similar; the first trace of
an error at all is from the HP machine, and occurred at 11:50:24:

Mar 30 11:50:24 storage7 kernel: Filesystem "dm-7": XFS internal error
xfs_btree_check_sblock at line 307 of file fs/xfs/xfs_btree.c.  Caller
0xffffffff885032b0

Sorry for a long introduction, but this is where this starts to get
interesting, and it only occurred to me after I wrote this message.
There's one more machine connected to that FC network, which was not
supposed to be using its FC card at the time our trouble started. A
colleague of mine was re-kickstarting the machine for a different
purpose. The installation was a pretty traditional PXE setup of SL 5.5
with the following KS setup for partitioning:

zerombr yes
clearpart --all --initlabel
part swap --size=3D1024 --asprimary
part / --fstype ext3 --size=3D0 --grow --asprimary

The only source of information for timing of the installation are the
logs from our DHCP server and Apache and timestamps at the reinstalled
box, which suggest that the installation started at 11:43:06 and
finished at 11:49:04.

So, to conclude, what we have here is that XFS filesystems on three
boxes were hosed at roughly the same time when another box connected to
the same FC SAN were undergoing reinstallation which was not supposed to
touch the FC disks at all. What I'd like to ask here is what kind of
corruption must have happened in order to trigger the XFS errors I
showed in this e-mail. Would a "restore" of GPT partition table at the
beginning of a disk from the copy at the end qualify as a possible
candidate?

This is how the hexdump of the end of a partition looks like:

[root@dpmpool5 ~]# hexdump -s$((18002985615360-512)) -C -v /dev/sdas
105fa58ffe00  45 46 49 20 50 41 52 54  00 00 01 00 5c 00 00 00  |EFI
PART....\...|
105fa58ffe10  69 e8 4a 00 00 00 00 00  ff c7 d2 2f 08 00 00 00
|i.J......../....|
105fa58ffe20  01 00 00 00 00 00 00 00  22 00 00 00 00 00 00 00
|........".......|
105fa58ffe30  de c7 d2 2f 08 00 00 00  2f 07 3a 5e 84 8b 4b 41
|.../..../.:^..KA|
105fa58ffe40  aa 2b 70 a1 43 ef 12 64  df c7 d2 2f 08 00 00 00
|.+p.C..d.../....|
105fa58ffe50  80 00 00 00 80 00 00 00  86 d2 54 ab 00 00 00 00
|..........T.....|

=2E..with more zeros till offset 105fa5900000.

I hope this is an appropriate subject for this list, so please accept my
apology if it's off topic here.

With kind regards,
Jan

[1] https://bugzilla.redhat.com/show_bug.cgi?id=3D247278


--------------ms030200080109060400010804
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
HSAEIDAeMAwGCiqGSIb3TAUCAgEwDgYMKwYBBAG+eQECAwADMDgGA1UdHwQxMC8wLaAroCmG
J2h0dHA6Ly9jcmwuY2VzbmV0LWNhLmN6L0NFU05FVF9DQV8zLmNybDAOBgNVHQ8BAf8EBAMC
BaAwHQYDVR0lBBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEME4GA1UdEQRHMEWBD2t1bmRyYXRq
QGZ6dS5jeoESamFuLmt1bmRyYXRAZnp1LmN6gQ5qa3RAZmxhc2thLm5ldIEOamt0QGdlbnRv
by5vcmcwDQYJKoZIhvcNAQEFBQADggEBACegz6Nyqyfw55uRsb5d4pdGG/PExKBzlFdMOs6f
uJwVVQgIOQJfbCffU8uG5Dk5PlhjBh5uMj8t8rmuFBMKNEuqovQIFOTIMOsRSsCuQz3GHd6U
pEH5IzmWwyFnCOUv3WcGQolpH3ByJidGHQf6wEwSagnVrmNC1Au0Q5MVKqcVoCPiuN5jMG5l
jB+jf93IrBTWyHco/eCkyYqiBgl2FR9Sdg+nnnT5lXFLLezyVeH9mDgApYIYf8fx1O1q7iAD
idvk/W1t1IVvpRfldQkmr72V0HPnSeqm6IDAe3JbbnL/lA1ar2s/2KeRLL4qBwxmMBWh8KAC
s97fFWe6CCVU/vgwggSbMIIDg6ADAgECAghfq1s9Se9NUDANBgkqhkiG9w0BAQUFADBZMRIw
EAYKCZImiZPyLGQBGRYCY3oxGTAXBgoJkiaJk/IsZAEZFgljZXNuZXQtY2ExEjAQBgNVBAoM
CUNFU05FVCBDQTEUMBIGA1UEAwwLQ0VTTkVUIENBIDMwHhcNMTEwMTE3MTMwMDIxWhcNMTIw
MjE2MTMwMDIxWjCBiTESMBAGCgmSJomT8ixkARkWAmN6MRkwFwYKCZImiZPyLGQBGRYJY2Vz
bmV0LWNhMUIwQAYDVQQKDDlJbnN0aXR1dGUgb2YgUGh5c2ljcyBvZiB0aGUgQWNhZGVteSBv
ZiBTY2llbmNlcyBvZiB0aGUgQ1IxFDASBgNVBAMMC0phbiBLdW5kcmF0MIIBIjANBgkqhkiG
9w0BAQEFAAOCAQ8AMIIBCgKCAQEA4lX7WVimGgL7ZEr/111vi4MBUNev3Qm+QL2MA3W+p7Kr
lNsFqoACNckXbZ2poskynyDFIoZ8MMoF7gsZEzWPJVguvYpKy46zvLv8BTnXM6dN7f1/P8RO
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
--------------ms030200080109060400010804--


--===============0505432338563832184==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0505432338563832184==--
