Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9QA2F0w219241 for <xfs@oss.sgi.com>; Fri, 26 Oct 2012 05:02:15 -0500
Received: from smtp-tls.univ-nantes.fr (smtptls1-lmb.cpub.univ-nantes.fr
	[193.52.103.110]) by cuda.sgi.com with ESMTP id
	Xxx2kAvWC12tzdgW for <xfs@oss.sgi.com>;
	Fri, 26 Oct 2012 03:04:00 -0700 (PDT)
Message-ID: <508A600C.1020109@univ-nantes.fr>
Date: Fri, 26 Oct 2012 12:03:56 +0200
From: Yann Dupont <Yann.Dupont@univ-nantes.fr>
MIME-Version: 1.0
Subject: Re: Problems with kernel 3.6.x (vm ?) (was : Is kernel 3.6.1 or
	filestreams option toxic ?)
References: <508554AF.5050005@univ-nantes.fr> <50865453.5080708@univ-nantes.fr>
	<508958FF.4000007@univ-nantes.fr> <20121025211047.GD29378@dastard>
In-Reply-To: <20121025211047.GD29378@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Le 25/10/2012 23:10, Dave Chinner a =E9crit :
>
> This time, after 3.6.3 boot, one of my xfs volume refuse to mount :
>
> mount: /dev/mapper/LocalDisk-debug--git: can't read superblock
>
> 276596.189363] XFS (dm-1): Mounting Filesystem
> [276596.270614] XFS (dm-1): Starting recovery (logdev: internal)
> [276596.711295] XFS (dm-1): xlog_recover_process_data: bad clientid 0x0
> [276596.711329] XFS (dm-1): log mount/recovery failed: error 5
> [276596.711516] XFS (dm-1): log mount failed
> That's an indication that zeros are being read from the journal
> rather than valid transaction data. It may well be caused by an XFS
> bug, but from experience it is equally likely to be a lower layer
> storage problem. More information is needed.

Hello dave, did you see the next mail ? The fact is that with 3.4.15, =

journal is OK, and data is, in fact, intact.

> Firstly:
>
> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_whe=
n_reporting_a_problem.3F

OK, sorry I missed it : here are the informations. Not sure all is =

relevant, anyway here we go.
each time I will distinguish between the first reported crash (nodes of =

ceph) and the last one, as the setup is quite different.

--------

kernel version (uname -a) : 3.6.1 then 3.6.2, vanilla, hand compiled, no =

proprietary modules. Not running it at the moment, can't give you the =

exact uname -a

------------
xfs_repair version 3.1.7 on the the third machine,
xfs_repair version 3.1.4 on two first machines (part of ceph)
-----------
cpu : the same for the 3 machines : Dell PowerEdgme M610,
2x Intel(R) Xeon(R) CPU           E5649  @ 2.53GHz , Hyper threading =

activated (12 physical cores, 24 virtual cores)

-------------
meminfo :
for example, on the 3rd machine :

MemTotal:       41198292 kB
MemFree:        28623116 kB
Buffers:            1056 kB
Cached:         10392452 kB
SwapCached:            0 kB
Active:           180528 kB
Inactive:       10227416 kB
Active(anon):      17476 kB
Inactive(anon):      180 kB
Active(file):     163052 kB
Inactive(file): 10227236 kB
Unevictable:        3744 kB
Mlocked:            3744 kB
SwapTotal:        506040 kB
SwapFree:         506040 kB
Dirty:                 0 kB
Writeback:             0 kB
AnonPages:         18228 kB
Mapped:            12688 kB
Shmem:               300 kB
Slab:            1408204 kB
SReclaimable:    1281008 kB
SUnreclaim:       127196 kB
KernelStack:        1976 kB
PageTables:         2736 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    21105184 kB
Committed_AS:     136080 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      398608 kB
VmallocChunk:   34337979376 kB
HardwareCorrupted:     0 kB
AnonHugePages:         0 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:        7652 kB
DirectMap2M:     2076672 kB
DirectMap1G:    39845888 kB

----
/proc/mounts:

root@label5:~# cat /proc/mounts
rootfs / rootfs rw 0 0
sysfs /sys sysfs rw,nosuid,nodev,noexec,relatime 0 0
proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
udev /dev devtmpfs rw,relatime,size=3D20592788k,nr_inodes=3D5148197,mode=3D=
755 0 0
devpts /dev/pts devpts =

rw,nosuid,noexec,relatime,gid=3D5,mode=3D620,ptmxmode=3D000 0 0
tmpfs /run tmpfs rw,nosuid,noexec,relatime,size=3D4119832k,mode=3D755 0 0
/dev/mapper/LocalDisk-root / xfs rw,relatime,attr2,noquota 0 0
tmpfs /run/lock tmpfs rw,nosuid,nodev,noexec,relatime,size=3D5120k 0 0
tmpfs /tmp tmpfs rw,nosuid,nodev,relatime,size=3D8239660k 0 0
proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
sysfs /sys sysfs rw,nosuid,nodev,noexec,relatime 0 0
tmpfs /run/shm tmpfs rw,nosuid,nodev,relatime,size=3D8239660k 0 0
/dev/sda1 /boot ext2 rw,relatime,errors=3Dcontinue 0 0
** /dev/mapper/LocalDisk-debug--git /mnt/debug-git xfs =

rw,relatime,attr2,noquota 0 0 ** this one was the failing on 3.6.xx
configfs /sys/kernel/config configfs rw,relatime 0 0
ocfs2_dlmfs /dlm ocfs2_dlmfs rw,relatime 0 0
rpc_pipefs /var/lib/nfs/rpc_pipefs rpc_pipefs rw,relatime 0 0
fusectl /sys/fs/fuse/connections fusectl rw,relatime 0 0
nfsd /proc/fs/nfsd nfsd rw,relatime 0 0

This volume is on RAID1 localdisk.

on one of the first 2 nodes :

root@hanyu:~# cat /proc/mounts
rootfs / rootfs rw 0 0
none /sys sysfs rw,nosuid,nodev,noexec,relatime 0 0
none /proc proc rw,nosuid,nodev,noexec,relatime 0 0
none /dev devtmpfs rw,relatime,size=3D20592652k,nr_inodes=3D5148163,mode=3D=
755 0 0
none /dev/pts devpts =

rw,nosuid,noexec,relatime,gid=3D5,mode=3D620,ptmxmode=3D000 0 0
/dev/disk/by-uuid/37dd603c-168c-49de-830d-ef1b5c6982f8 / xfs =

rw,relatime,attr2,noquota 0 0
tmpfs /lib/init/rw tmpfs rw,nosuid,relatime,mode=3D755 0 0
tmpfs /dev/shm tmpfs rw,nosuid,nodev,relatime 0 0
/dev/sdk1 /boot ext2 rw,relatime,errors=3Dcontinue 0 0
none /var/local/cgroup cgroup =

rw,relatime,net_cls,freezer,devices,memory,cpuacct,cpu,debug,cpuset 0 0
** /dev/mapper/xceph--hanyu-data /XCEPH-PROD/data xfs =

rw,noatime,attr2,filestreams,nobarrier,inode64,logbsize=3D256k,noquota 0 0 =

** This one was the failed volume
fusectl /sys/fs/fuse/connections fusectl rw,relatime 0 0


Please note that on this server, nobarrier is used because the volume is =

on a battery-backed fibre channel raid array.
--------------
/proc/partitions :
quite complicated on the ceph node :

root@hanyu:~#  cat /proc/partitions
major minor  #blocks  name

   11        0    1048575 sr0
    8       32 6656000000 sdc
    8       48 5063483392 sdd
    8       64 6656000000 sde
    8       80 5063483392 sdf
    8       96 6656000000 sdg
    8      112 5063483392 sdh
    8      128 6656000000 sdi
    8      144 5063483392 sdj
    8      160  292421632 sdk
    8      161     273073 sdk1
    8      162     530145 sdk2
    8      163    2369587 sdk3
    8      164  289242292 sdk4
  254        0 6656000000 dm-0
  254        1 5063483392 dm-1
  254        2    5242880 dm-2
  254        3 11676106752 dm-3


please note that we use multipath here. 4 Paths for the LUN :

root@hanyu:~# multipath -ll
mpath2 (3600d02310006674500000001414d677d) dm-1 IFT,S16F-R1840-4
size=3D4.7T features=3D'1 queue_if_no_path' hwhandler=3D'0' wp=3Drw
|-+- policy=3D'round-robin 0' prio=3D100 status=3Dactive
| |- 0:0:1:96 sdf 8:80  active ready  running
| `- 6:0:1:96 sdj 8:144 active ready  running
`-+- policy=3D'round-robin 0' prio=3D20 status=3Denabled
   |- 0:0:0:96 sdd 8:48  active ready  running
   `- 6:0:0:96 sdh 8:112 active ready  running
mpath1 (3600d02310006674500000000414d677d) dm-0 IFT,S16F-R1840-4
size=3D6.2T features=3D'1 queue_if_no_path' hwhandler=3D'0' wp=3Drw
|-+- policy=3D'round-robin 0' prio=3D100 status=3Dactive
| |- 0:0:1:32 sde 8:64  active ready  running
| `- 6:0:1:32 sdi 8:128 active ready  running
`-+- policy=3D'round-robin 0' prio=3D20 status=3Denabled
   |- 0:0:0:32 sdc 8:32  active ready  running
   `- 6:0:0:32 sdg 8:96  active ready  running

On the 3rd machine, setup is quite simpler

root@label5:~# cat /proc/partitions
major minor  #blocks  name

    8        0  292421632 sda
    8        1     257008 sda1
    8        2     506047 sda2
    8        3    1261102 sda3
    8        4  140705302 sda4
  254        0    2609152 dm-0
  254        1  104857600 dm-1
  254        2   31457280 dm-2

--------------

raid layout :

On the first 2 machines (part of ceph cluster), the data is on Raid5 on =

a fibre channel raid array, accessed by emulex fibre channel =

(lightpulse, lpfc)
On the 3rd, data is on Raid1 accessed by Dell Perc (LSI Logic / Symbios =

Logic SAS1068E PCI-Express Fusion-MPT SAS (rev 08) driver mptsas)

--------------

LVM config :
root@hanyu:~# vgs
   VG          #PV #LV #SN Attr   VSize   VFree
   LocalDisk     1   1   0 wz--n- 275,84g 270,84g
   xceph-hanyu   2   1   0 wz--n-  10,91t  41,36g

root@hanyu:~# lvs
   LV   VG          Attr   LSize  Origin Snap%  Move Log Copy% Convert
   log  LocalDisk   -wi-a- 5,00g
   data xceph-hanyu -wi-ao 10,87t

and

root@label5:~# vgs
   VG        #PV #LV #SN Attr   VSize   VFree
   LocalDisk   1   3   0 wz--n- 134,18g 1,70g

root@label5:~# lvs
   LV        VG        Attr   LSize   Origin Snap%  Move Log Copy% Convert
   1         LocalDisk -wi-a- 30,00g
   debug-git LocalDisk -wi-ao 100,00g
   root      LocalDisk -wi-ao 2,49g
root@label5:~#

-------------------

type of disks :

on the raid array I'd say not very important (SEAGATE ST32000444SS near =

line sas 2TB)
on the 3rd machine : TOSHIBA  MBF2300RC        DA06

---------------------

write cache status :

on the raid array, write cache is activated globally for the raid array =

BUT is explicitely disabled on drives.
on the 3rd machine, it is disabled as far as I know

-------------------

Size of BBWC : 2 or 4 GB on raid arrays. None on the 3rd.


------------------
xfs_info :


root@hanyu:~# xfs_info /dev/xceph-hanyu/data
meta-data=3D/dev/mapper/xceph--hanyu-data isize=3D256    agcount=3D11, =

agsize=3D268435455 blks
          =3D                       sectsz=3D512   attr=3D2
data     =3D                       bsize=3D4096   blocks=3D2919026688, imax=
pct=3D5
          =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
log      =3Dinternal               bsize=3D4096   blocks=3D521728, version=
=3D2
          =3D                       sectsz=3D512   sunit=3D0 blks, lazy-cou=
nt=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0


(no sunit or swidth on this one)


root@label5:~# xfs_info /dev/LocalDisk/debug-git
meta-data=3D/dev/mapper/LocalDisk-debug--git isize=3D256    agcount=3D4, =

agsize=3D6553600 blks
          =3D                       sectsz=3D512   attr=3D2
data     =3D                       bsize=3D4096   blocks=3D26214400, imaxpc=
t=3D25
          =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
log      =3Dinternal               bsize=3D4096   blocks=3D12800, version=
=3D2
          =3D                       sectsz=3D512   sunit=3D0 blks, lazy-cou=
nt=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0

-----

dmesg : you already have the informations.

For iostat, etc, I need to try to reproduce the load.




> Secondly, is the system still in this state? If so, dump the log to

No. The first 2 nodes have been xfs_repaired. One was completed and it =

was a terrible mess.
The second had xfs_repair segfaulting. Will try with a newer xfs_repair =

on a 3.4 kernel.

The 3rd one is now ok, after booting on 3.4 kernel.

> a file using xfs_logprint, zip it up and send it to me so I can have
> a look at where the log is intact (i.e. likely xfs bug) or contains
> zero (likely storage bug).
>
> If the system is not still in this state, then I'm afraid there's
> nothing that can be done to understand the problem.

I'll try to reproduce a similar problem.




> You've had two machines crash with problems in the mm subsystem, and
> one filesystem problem that might be hardware realted. Bit early to
> be blaming XFS for all your problems, I think....

I don't try to blame XFS. I'm very confident in it, and since a long =

time. BUT I see a very different behaviour on those 3 cases. Nothing =

conclusive yet. I think the problem is related with kernel 3.6, maybe in =

dm layer.
I don't think it's hardware related : different disks, differents =

controllers, different machines.

The common point is :
-XFS
-Kernel 3.6.xx
-Device Mapper + LVM

>> xfs_repair -n seems to show volume is quite broken :
> Sure, if the log hasn't been replayed then it will be - the
> filesystem will only be consistent after log recovery has been run.
>

Yes, but I had to use xfs_repair -L in the past (power outage, hardware =

failures) and never had such disastrous repairs.

At least on the 2 first failures, I can understand : There is lots of =

data, Journal is BIG, and I/O transactions in flight are quite high.
on the 3rd failure I'm very septical : low I/O load, little volume.

> You should report the mm problems to linux-mm@kvack.org to make sure
> the right people see them and they don't get lost in the noise of
> lkml....

yes point taken,

I'll try now to reproduce this kind of behaviour on a verry little =

volume (10 GB for exemple) so I can confirm or inform the given scenario .

Thanks for your time,


-- Yann Dupont - Service IRTS, DSI Universit=E9 de Nantes Tel : =

02.53.48.49.20 - Mail/Jabber : Yann.Dupont@univ-nantes.fr

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
