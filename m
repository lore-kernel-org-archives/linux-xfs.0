Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 082A47F5E
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2014 02:40:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E88A88F8039
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2014 00:40:18 -0700 (PDT)
Received: from login.slnx.de (login.slnx.de [144.76.43.250]) by cuda.sgi.com
	with ESMTP id OOk5uNkGBLEbfUkF for <xfs@oss.sgi.com>;
	Mon, 21 Jul 2014 00:40:13 -0700 (PDT)
Date: Mon, 21 Jul 2014 09:40:21 +0200
From: Andre Noll <maan@systemlinux.org>
Subject: Re: assert in xfs_log_commit_cil
Message-ID: <20140721074021.GM17283@slnx.de>
References: <20140124193702.GM26064@sgi.com> <20140124222017.GB26397@dastard>
	<20140719210245.GL17283@slnx.de> <20140721000415.GI20518@dastard>
MIME-Version: 1.0
In-Reply-To: <20140721000415.GI20518@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3922079482686045278=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com


--===============3922079482686045278==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6Mt39TZj+HFMr11E"
Content-Disposition: inline


--6Mt39TZj+HFMr11E
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 21, 10:04, Dave Chinner wrote:
> > FWIW, I'm also seeing this on an untainted 3.14.11 kernel:
> >=20
> > [95004.073063] XFS: Assertion failed: !list_empty(&cil->xc_cil), file: =
fs/xfs/xfs_log_cil.c, line: 647
> > [95004.073068] ------------[ cut here ]------------
> > [95004.073079] WARNING: CPU: 5 PID: 13368 at fs/xfs/xfs_message.c:99 xf=
s_log_commit_cil+0x371/0x5a0()
> > [95004.073081] Modules linked in: af_packet
> > [95004.073087] CPU: 5 PID: 13368 Comm: kworker/5:4 Not tainted 3.14.11 =
#18
> > [95004.073088] Hardware name: Supermicro H8DG6/H8DGi/H8DG6/H8DGi, BIOS =
2.0b       03/01/2012
> > [95004.073094] Workqueue: xfs-data/dm-1 xfs_end_io
> > [95004.073096]  0000000000000000 ffffffff81760b6c ffffffff815b37a1 0000=
000000000000
> > [95004.073098]  ffffffff8103c3f2 ffff880fe098b900 ffff881e6fcb0d00 ffff=
880fe098b900
> > [95004.073100]  ffff881e6fcb0dd8 ffff8823bc512600 ffffffff81262db1 0000=
000000000000
> > [95004.073103] Call Trace:
> > [95004.073110]  [<ffffffff815b37a1>] ? dump_stack+0x41/0x51
> > [95004.073114]  [<ffffffff8103c3f2>] ? warn_slowpath_common+0x82/0xb0
> > [95004.073117]  [<ffffffff81262db1>] ? xfs_log_commit_cil+0x371/0x5a0
> > [95004.073120]  [<ffffffff8121687b>] ? xfs_trans_commit+0xcb/0x2c0
> > [95004.073123]  [<ffffffff811f8c9c>] ? xfs_end_io+0x6c/0xe0
> > [95004.073126]  [<ffffffff8105138e>] ? process_one_work+0x13e/0x3b0
> > [95004.073129]  [<ffffffff81051e39>] ? worker_thread+0x109/0x350
> > [95004.073131]  [<ffffffff81051d30>] ? manage_workers.isra.28+0x2c0/0x2=
c0
> > [95004.073134]  [<ffffffff81057f0c>] ? kthread+0xbc/0xe0
> > [95004.073136]  [<ffffffff81057e50>] ? kthread_freezable_should_stop+0x=
60/0x60
> > [95004.073139]  [<ffffffff815b92fc>] ? ret_from_fork+0x7c/0xb0
> > [95004.073141]  [<ffffffff81057e50>] ? kthread_freezable_should_stop+0x=
60/0x60
> > [95004.073142] ---[ end trace b591fe6842af909e ]---
> >=20
> > Any hints?
>=20
> More information required.

Sure.

* xfsprogs version 3.1.7 from Ubuntu Precise
* x86_64, 2-way system, 16 AMD CPUs
* 256G RAM, /proc/meminfo is below
* ~250T storage on three XFS file systems, contents of /proc/mounts
  and /proc/partitions below
* 7 x LSI HW Raid over 12x4T SATA disks
* 3 + 3 + 1 of these HW Raid arrays are combined with LVM into 3 VGs,
  see pvs, vgs output below
*=C2=A0Hitachi/HGST 4T SATA HDS
*=C2=A0write cache enabled, even with bad BBU (system is connected
  to UPS and Diesel emergency power)
* above backtrace indicates the problem is related to the LV dm-1,
  xfsinfo of this 105T fs below
* the machine is an NFS server, connected are ~15 clients via 10GBit
  ethernet (using sync mounts). These clients were heavily writing
  to the fs when the problem occurred.
* no drive failures
* fs was grown twice
* user and project quotas enabled

Thanks
Andre
---
cat /proc/meminfo
~~~~~~~~~~~~~~~~~
MemTotal:       264144968 kB
MemFree:         1839520 kB
MemAvailable:   261512400 kB
Buffers:          241684 kB
Cached:         250252204 kB
SwapCached:            0 kB
Active:         96525128 kB
Inactive:       153982780 kB
Active(anon):      10140 kB
Inactive(anon):    14564 kB
Active(file):   96514988 kB
Inactive(file): 153968216 kB
Unevictable:        8052 kB
Mlocked:               0 kB
SwapTotal:      10485756 kB
SwapFree:       10485756 kB
Dirty:             31688 kB
Writeback:            16 kB
AnonPages:         24692 kB
Mapped:             7156 kB
Shmem:                12 kB
Slab:            9951456 kB
SReclaimable:    9433372 kB
SUnreclaim:       518084 kB
KernelStack:        2600 kB
PageTables:         3032 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    142558240 kB
Committed_AS:     199388 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      692260 kB
VmallocChunk:   34156662148 kB
DirectMap4k:        8704 kB
DirectMap2M:     2070528 kB
DirectMap1G:    266338304 kB
cat /proc/meminfo /proc/mounts
MemTotal:       264144968 kB
MemFree:         1521196 kB
MemAvailable:   261519256 kB
Buffers:          241696 kB
Cached:         250576284 kB
SwapCached:            0 kB
Active:         96549616 kB
Inactive:       154283584 kB
Active(anon):      10140 kB
Inactive(anon):    14564 kB
Active(file):   96539476 kB
Inactive(file): 154269020 kB
Unevictable:        8052 kB
Mlocked:               0 kB
SwapTotal:      10485756 kB
SwapFree:       10485756 kB
Dirty:                 4 kB
Writeback:             0 kB
AnonPages:         24692 kB
Mapped:             7156 kB
Shmem:                12 kB
Slab:            9954412 kB
SReclaimable:    9433260 kB
SUnreclaim:       521152 kB
KernelStack:        2552 kB
PageTables:         3032 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    142558240 kB
Committed_AS:     199388 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      692260 kB
VmallocChunk:   34156662148 kB
DirectMap4k:        8704 kB
DirectMap2M:     2070528 kB
DirectMap1G:    266338304 kB

cat /proc/mounts
~~~~~~~~~~~~~~~~
rootfs / rootfs rw 0 0
proc /proc proc rw,relatime 0 0
sysfs /sys sysfs rw,relatime 0 0
/dev/mapper/toto-root / ext4 rw,relatime,data=3Dordered 0 0
devpts /dev/pts devpts rw,relatime,mode=3D600 0 0
nfsd /proc/fs/nfsd nfsd rw,relatime 0 0
none /dev/shm tmpfs rw,relatime 0 0
/dev/md0 /boot ext3 rw,relatime,data=3Dordered 0 0
/dev/mapper/toto-tmp /tmp ext4 rw,noatime,data=3Dwriteback 0 0
/dev/mapper/wizo-abt6_projects7 /ebio/abt6_projects7 xfs rw,noatime,attr2,i=
node64,usrquota,prjquota 0 0
/dev/mapper/zoff-abt6_projects8 /ebio/abt6_projects8 xfs rw,noatime,attr2,i=
node64,usrquota,prjquota 0 0
/dev/mapper/styx-abt6_sra /ebio/abt6_sra xfs rw,noatime,attr2,inode64,usrqu=
ota,prjquota 0 0
abt6-zserve.eb.local:/ebio/abt6/Users /ebio/abt6 nfs rw,relatime,vers=3D3,r=
size=3D65536,wsize=3D65536,namlen=3D255,hard,proto=3Dtcp,timeo=3D600,retran=
s=3D2,sec=3Dsys,mountaddr=3D172.18.3.229,mountvers=3D3,mountport=3D683,moun=
tproto=3Dtcp,local_lock=3Dnone,addr=3D172.18.3.229 0 0
ohm:/ebio/abt6_ga2 /ebio/abt6_ga2 nfs rw,sync,relatime,vers=3D3,rsize=3D104=
8576,wsize=3D1048576,namlen=3D255,hard,proto=3Dtcp,timeo=3D600,retrans=3D2,=
sec=3Dsys,mountaddr=3D172.18.3.247,mountvers=3D3,mountport=3D52911,mountpro=
to=3Dtcp,local_lock=3Dnone,addr=3D172.18.3.247 0 0

cat /proc/partitions
~~~~~~~~~~~~~~~~~~~~
major minor  #blocks  name

   8        0 39062497280 sda
   8       32 39062497280 sdc
   8       16 39062497280 sdb
   8       48 39062497280 sdd
   8       64 39062497280 sde
   8       80 39062497280 sdf
   8       96 39062497280 sdg
   8      112  146523384 sdh
   8      113    1959898 sdh1
   8      114  144560902 sdh2
   8      128  146523384 sdi
   8      129    1959898 sdi1
   8      130  144560902 sdi2
   9        0    1959808 md0
   9        1  144560832 md1
 253        0 39062495232 dm-0
 253        1 112742891520 dm-1
 253        2   31457280 dm-2
 253        3   10485760 dm-3
 253        4   31457280 dm-4
 253        5 112742891520 dm-5

pvs
~~~
  PV         VG   Fmt  Attr PSize   PFree=20
  /dev/md1   toto lvm2 a-   137.86g 67.86g
  /dev/sda   wizo lvm2 a-    36.38t     0=20
  /dev/sdb   zoff lvm2 a-    36.38t     0=20
  /dev/sdc   wizo lvm2 a-    36.38t  4.14t
  /dev/sdd   zoff lvm2 a-    36.38t     0=20
  /dev/sde   styx lvm2 a-    36.38t     0=20
  /dev/sdf   zoff lvm2 a-    36.38t  4.14t
  /dev/sdg   wizo lvm2 a-    36.38t     0=20

vgs
~~~
  VG   #PV #LV #SN Attr   VSize   VFree=20
  styx   1   1   0 wz--n-  36.38t     0=20
  toto   1   3   0 wz--n- 137.86g 67.86g
  wizo   3   1   0 wz--n- 109.14t  4.14t
  zoff   3   1   0 wz--n- 109.14t  4.14t

xfs_info /ebio/abt6_projects8
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
meta-data=3D/dev/mapper/zoff-abt6_projects8 isize=3D256    agcount=3D106, a=
gsize=3D268435455 blks
         =3D                       sectsz=3D512   attr=3D2
data     =3D                       bsize=3D4096   blocks=3D28185722880, ima=
xpct=3D5
         =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
log      =3Dinternal               bsize=3D4096   blocks=3D521728, version=
=3D2
         =3D                       sectsz=3D512   sunit=3D0 blks, lazy-coun=
t=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--6Mt39TZj+HFMr11E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlPMw+UACgkQWto1QDEAkw+IpQCcD4RPM9HavkXh9aMfrYgwqyF7
R/8AnjVMwKepKzRNRl1cHbyK6mpFeZ9N
=7J+H
-----END PGP SIGNATURE-----

--6Mt39TZj+HFMr11E--


--===============3922079482686045278==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3922079482686045278==--
