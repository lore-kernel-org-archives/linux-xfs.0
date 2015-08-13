Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 98C7A7F3F
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2015 18:35:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 86CB030404E
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2015 16:35:39 -0700 (PDT)
Received: from mail-ob0-f181.google.com (mail-ob0-f181.google.com
	[209.85.214.181]) by cuda.sgi.com with ESMTP id
	DaAohlEFXJsdlb8v (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 13 Aug 2015 16:35:31 -0700 (PDT)
Received: by obbop1 with SMTP id op1so49812359obb.2
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2015 16:35:31 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 13 Aug 2015 17:35:31 -0600
Message-ID: <CA+muJ0thea8xOJB8c2CJj1GAVa48EUvRYf7-3oS_zYc+T5R6yg@mail.gmail.com>
Subject: Looking to confirm issue and seek advice on fix for inode btree
	fragmentation
From: Pippin Wallace <nippip@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3371121499484158490=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============3371121499484158490==
Content-Type: multipart/alternative; boundary=089e01634d6a80efcf051d39cafe

--089e01634d6a80efcf051d39cafe
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

I am writing to confirm the issue I think I have and get advice on the best
short term and long term =E2=80=9Cfixes=E2=80=9D.



In reading the following threads and others I am pretty sure I have inode
btree fragmentation and I have included detailed output below to help
confirm this.



Is XFS suitable for 350 million files on 20TB storage?

http://oss.sgi.com/archives/xfs/2014-09/msg00046.html



Bad performance on touch/cp file on XFS system

http://oss.sgi.com/archives/xfs/2014-08/msg00348.html



Extremely slow file creation/deletion after xfs ran full

http://oss.sgi.com/archives/xfs/2015-01/msg00203.html





In addition to diagnosis I want to insure I take the right steps to improve
performance in the short term and fix it correctly and thoroughly for the
long term.



Our workload is heavy write/delete and light reads.  Most files are
smallish and we cannot mount xfs with inode64 as our primary app is 32
bit.  Our hosts are running as VM=E2=80=99s on a KVM hypervisor.



Suggestion from Dave in post
http://oss.sgi.com/archives/xfs/2014-08/msg00349.html

If this is still the best short term fix would you please direct me to the
=E2=80=9CHow To=E2=80=9D for doing this?

*=E2=80=9Cfilling in all the holes (by creating a bunch of zero length file=
s in the*

*appropriate AGs) might take some time, but it should make the*

*problem go away until you remove more filesystem and create random*

*free inode holes again...=E2=80=9D*



Is this also a possible short term fix?
http://osvault.blogspot.com/2011/03/fixing-1tbyte-inode-problem-in-xfs-file=
.html





Long term fix is upgrade kernel to >=3D 3.16, xfsprogs >=3D3.2.1 and rebuil=
d fs
with new finobt structure.

        # mkfs.xfs -m crc=3D1,finobt=3D1 <dev>







Here is info others have asked for in previous threads and further below
that is data collected based on =E2=80=9CWhat information should I include =
when
reporting a problem?=E2=80=9D from your FAQ.



If a command line in bold below starts with a VM then this command was run
on the Virtual Machine or guest OS and if it starts with a HV then it was
run on the physical HyperVisor machine that is hosting the guest OS.





*VM# perf top*

Samples: 378K of event 'cpu-clock', Event count (approx.): 188377

14.10%  [kernel]                    [k] xfs_inobt_get_rec

  9.58%  [kernel]                    [k] xfs_btree_increment

  9.08%  [kernel]                    [k] xfs_btree_get_rec

  8.83%  [kernel]                    [k] _xfs_buf_find

  5.84%  [kernel]                    [k] xfs_btree_get_block

  3.91%  [kernel]                    [k] xfs_btree_rec_offset

  3.85%  [kernel]                    [k] xfs_dialloc_ag

  3.64%  [kernel]                    [k] xfs_btree_readahead

  3.15%  [kernel]                    [k] _raw_spin_unlock_irqrestore

  2.97%  [kernel]                    [k] xfs_btree_rec_addr

  2.31%  [kernel]                    [k] xfs_trans_buf_item_match

  1.67%  [kernel]                    [k] xfs_btree_setbuf





*VM# time xfs_db -r -c "frag" /dev/vdc1   *

actual 80103457, ideal 79500897, fragmentation factor 0.75%

real    53m19.167s

user    0m35.050s

sys     3m35.390s





*VM# xfs_db -r -c "frag -d" /dev/vdc1*

actual 8947229, ideal 8406330, fragmentation factor 6.05%





*VM# df -i /dev/vdc1*

Filesystem         Inodes     IUsed      IFree IUse% Mounted on

/dev/vdc1      6,442,426,368 152,347,297 6,290,079,071    3% /exports





*VM# for i in `seq 0 $((16-1))`; do echo "freespace in ag$i"; xfs_db -r -c
"freesp -s -a $i" /dev/vdc1 | grep "total free" | sed 's/^/ /g'; done*

freespace in ag0

total free extents 611688

total free blocks 45590165

freespace in ag1

total free extents 606085

total free blocks 45576240

freespace in ag2

total free extents 606482

total free blocks 45571903

freespace in ag3

total free extents 604576

total free blocks 45572111

freespace in ag4

total free extents 74367

total free blocks 15129234

freespace in ag5

total free extents 172955

total free blocks 17015698

freespace in ag6

total free extents 176759

total free blocks 14716774

freespace in ag7

total free extents 170481

total free blocks 15031152

freespace in ag8

total free extents 173346

total free blocks 15677354

freespace in ag9

total free extents 177170

total free blocks 14914037

freespace in ag10

total free extents 169536

total free blocks 16267638

freespace in ag11

total free extents 173325

total free blocks 14618827

freespace in ag12

total free extents 174743

total free blocks 14634872

freespace in ag13

total free extents 173378

total free blocks 16412626

freespace in ag14

total free extents 171388

total free blocks 15198251

freespace in ag15

total free extents 170986

total free blocks 13790690





*=E2=80=9CWhat information should I include when reporting a problem?=E2=80=
=9D*





*VM# uname -a  *

Linux 3.8.13-55.1.2.el6uek.x86_64 #2 SMP Thu Dec 18 00:15:51 PST 2014
x86_64 x86_64 x86_64 GNU/Linux



*HV# uname -a*

Linux 2.6.32-431.el6.x86_64 #1 SMP Wed Nov 20 23:56:07 PST 2013 x86_64
x86_64 x86_64 GNU/Linux





*VM# xfs_repair -V *

xfs_repair version 3.1.11





*VM# dmidecode |grep -A3 Product*

        Product Name: KVM

        Version: RHEL 6.5.0 PC





*HV# dmidecode |egrep -A4 "Product|Processor"*

        Product Name: SUN SERVER X4-2L

Processor Information

        Socket Designation: P0

        Family: Xeon

        Signature: Type 0, Family 6, Model 62, Stepping 4

Processor Information

        Socket Designation: P1

        Family: Xeon

        Signature: Type 0, Family 6, Model 62, Stepping 4





*VM# cat /proc/cpuinfo (Total of 16 virtual cpu=E2=80=99s all with the same
settings as cpu 0 below.)*

processor       : 0

vendor_id       : GenuineIntel

cpu family      : 6

model           : 13

model name      : QEMU Virtual CPU version (cpu64-rhel6)

stepping        : 3

microcode       : 0x1

cpu MHz         : 2693.508

cache size      : 4096 KB

fpu             : yes

fpu_exception   : yes

cpuid level     : 4

wp              : yes

flags           : fpu de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pse36 clflush mmx fxsr sse sse2 syscall nx lm nopl pni cx16 hypervisor
lahf_lm

bogomips        : 5387.01

clflush size    : 64

cache_alignment : 64

address sizes   : 46 bits physical, 48 bits virtual

power management:





*VM# cat /proc/meminfo *

MemTotal:       49463428 kB

MemFree:          931832 kB

Buffers:           81504 kB

Cached:         16499856 kB

SwapCached:            0 kB

Active:         21534272 kB

Inactive:       10518940 kB

Active(anon):   13615056 kB

Inactive(anon):  1859060 kB

Active(file):    7919216 kB

Inactive(file):  8659880 kB

Unevictable:           0 kB

Mlocked:               0 kB

SwapTotal:       2096124 kB

SwapFree:        2096124 kB

Dirty:            117192 kB

Writeback:             0 kB

AnonPages:      15468324 kB

Mapped:            39484 kB

Shmem:              3888 kB

Slab:            7883016 kB

SReclaimable:    6149288 kB

SUnreclaim:      1733728 kB

KernelStack:       11000 kB

PageTables:       180756 kB

NFS_Unstable:          0 kB

Bounce:                0 kB

WritebackTmp:          0 kB

CommitLimit:    26827836 kB

Committed_AS:   21133332 kB

VmallocTotal:   34359738367 kB

VmallocUsed:      112668 kB

VmallocChunk:   34359623568 kB

HardwareCorrupted:     0 kB

HugePages_Total:       0

HugePages_Free:        0

HugePages_Rsvd:        0

HugePages_Surp:        0

Hugepagesize:       2048 kB

DirectMap4k:       10224 kB

DirectMap2M:    50321408 kB





*VM# cat /proc/mounts *

rootfs / rootfs rw 0 0

proc /proc proc rw,relatime 0 0

sysfs /sys sysfs rw,relatime 0 0

devtmpfs /dev devtmpfs
rw,relatime,size=3D24719668k,nr_inodes=3D6179917,mode=3D755 0 0

devpts /dev/pts devpts rw,relatime,gid=3D5,mode=3D620,ptmxmode=3D000 0 0

tmpfs /dev/shm tmpfs rw,relatime 0 0

/dev/vda3 / ext3
rw,relatime,errors=3Dcontinue,user_xattr,acl,barrier=3D1,data=3Dordered 0 0

proc /rhel3/proc proc rw,relatime 0 0

/dev/vda5 /tmp ext3
rw,relatime,errors=3Dcontinue,user_xattr,acl,barrier=3D1,data=3Dordered 0 0

/dev/vda1 /boot ext3
rw,relatime,errors=3Dcontinue,user_xattr,acl,barrier=3D1,data=3Dordered 0 0

*/dev/vdc1 /exports xfs
rw,noatime,attr2,inode32,nobarrier,logbsize=3D256k,sunit=3D512,swidth=3D112=
64,noquota
0 0*

/dev/vdb1 /mnt xfs
rw,noatime,attr2,inode32,nobarrier,logbsize=3D256k,sunit=3D512,swidth=3D112=
64,noquota
0 0

/dev/vdc1 /www xfs
rw,noatime,attr2,inode32,nobarrier,logbsize=3D256k,sunit=3D512,swidth=3D112=
64,noquota
0 0

/dev/vdc1 /rhel3/www xfs
rw,noatime,attr2,inode32,nobarrier,logbsize=3D256k,sunit=3D512,swidth=3D112=
64,noquota
0 0

/dev/vdc1 /chroot xfs
rw,noatime,attr2,inode32,nobarrier,logbsize=3D256k,sunit=3D512,swidth=3D112=
64,noquota
0 0

/dev/vdc1 /home xfs
rw,noatime,attr2,inode32,nobarrier,logbsize=3D256k,sunit=3D512,swidth=3D112=
64,noquota
0 0

/dev/vdc1 /nfscommon xfs
rw,noatime,attr2,inode32,nobarrier,logbsize=3D256k,sunit=3D512,swidth=3D112=
64,noquota
0 0

/dev/vdc1 /opt xfs
rw,noatime,attr2,inode32,nobarrier,logbsize=3D256k,sunit=3D512,swidth=3D112=
64,noquota
0 0

/dev/vdc1 /scratch xfs
rw,noatime,attr2,inode32,nobarrier,logbsize=3D256k,sunit=3D512,swidth=3D112=
64,noquota
0 0

none /proc/sys/fs/binfmt_misc binfmt_misc rw,relatime 0 0

sunrpc /var/lib/nfs/rpc_pipefs rpc_pipefs rw,relatime 0 0

nfsd /proc/fs/nfsd nfsd rw,relatime 0 0

10.140.110.106:/export/nfs/qa /nfs/qa nfs
rw,noatime,nodiratime,vers=3D3,rsize=3D32768,wsize=3D32768,namlen=3D255,har=
d,nocto,noacl,proto=3Dtcp,timeo=3D600,retrans=3D2,sec=3Dsys,mountaddr=3D10.=
140.110.106,mountvers=3D3,mountport=3D36653,mountproto=3Dudp,local_lock=3Dn=
one,addr=3D10.140.110.106
0 0

10.140.110.106:/export/nfs/install /nfs/install nfs
rw,noatime,nodiratime,vers=3D3,rsize=3D32768,wsize=3D32768,namlen=3D255,har=
d,nocto,noacl,proto=3Dtcp,timeo=3D600,retrans=3D2,sec=3Dsys,mountaddr=3D10.=
140.110.106,mountvers=3D3,mountport=3D36653,mountproto=3Dudp,local_lock=3Dn=
one,addr=3D10.140.110.106
0 0

10.140.110.105:/export/home /nfs/users nfs
rw,noatime,nodiratime,vers=3D3,rsize=3D32768,wsize=3D32768,namlen=3D255,har=
d,nocto,noacl,proto=3Dtcp,timeo=3D600,retrans=3D2,sec=3Dsys,mountaddr=3D10.=
140.110.105,mountvers=3D3,mountport=3D37692,mountproto=3Dudp,local_lock=3Dn=
one,addr=3D10.140.110.105
0 0

10.140.110.105:/export/nfs/project /nfs/project nfs
rw,noatime,nodiratime,vers=3D3,rsize=3D32768,wsize=3D32768,namlen=3D255,har=
d,nocto,noacl,proto=3Dtcp,timeo=3D600,retrans=3D2,sec=3Dsys,mountaddr=3D10.=
140.110.105,mountvers=3D3,mountport=3D37692,mountproto=3Dudp,local_lock=3Dn=
one,addr=3D10.140.110.105
0 0

10.140.110.105:/export/nfs/data /nfs/data nfs
rw,noatime,nodiratime,vers=3D3,rsize=3D32768,wsize=3D32768,namlen=3D255,har=
d,nocto,noacl,proto=3Dtcp,timeo=3D600,retrans=3D2,sec=3Dsys,mountaddr=3D10.=
140.110.105,mountvers=3D3,mountport=3D37692,mountproto=3Dudp,local_lock=3Dn=
one,addr=3D10.140.110.105
0 0

none /sys/kernel/debug debugfs rw,relatime 0 0





*VM# cat /proc/partitions *

major minor  #blocks  name



251        0  104857600 vda

251        1     204800 vda1

251        2    2096128 vda2

251        3   16595968 vda3

251        4          1 vda4

251        5   85958656 vda5

251       16 6442450944 vdb

251       17 6442434560 vdb1

251       32 6442450944 vdc

251       33 6442426368 vdc1





*VM# xfs_info /dev/vdc1*

meta-data=3D/dev/vdc1              isize=3D256    agcount=3D32, agsize=3D50=
331456
blks

         =3D                       sectsz=3D512   attr=3D2, projid32bit=3D1

         =3D                       crc=3D0

data     =3D                       bsize=3D4096   blocks=3D1610606592, imax=
pct=3D25

         =3D                       sunit=3D64     swidth=3D1408 blks

naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0

log      =3Dinternal               bsize=3D4096   blocks=3D521728, version=
=3D2

         =3D                       sectsz=3D512   sunit=3D64 blks, lazy-cou=
nt=3D1

realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0





*VM# iostat -x -d -m 5*

Linux 3.8.13-55.1.2.el6uek.x86_64 (hmswebdv01.int.dv.lan)
08/13/2015      _x86_64_



Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz
avgqu-sz   await  svctm  %util

vda               0.13    23.96    4.69    9.77     0.08     0.13
29.83     0.17   11.64   2.64   3.81

vda1              0.00     0.01    0.00    0.00     0.00     0.00
86.76     0.00    7.73   4.22   0.00

vda2              0.00     0.00    0.00    0.00     0.00     0.00
14.68     0.00    2.08   1.81   0.00

vda3              0.13    19.58    4.65    8.29     0.08     0.11
29.68     0.15   11.36   2.79   3.60

vda4              0.00     0.00    0.00    0.00     0.00     0.00
7.67     0.00   29.50  29.50   0.00

vda5              0.01     4.37    0.04    1.44     0.00     0.02
32.06     0.02   14.22   2.41   0.35

vdb               0.00     0.00   36.47    0.13     0.28     0.04
17.96     0.11    3.09   2.87  10.50

vdb1              0.00     0.00   36.47    0.13     0.28     0.04
17.96     0.11    3.09   2.87  10.50

vdc              56.10    85.36  447.04  461.48     9.21    10.85
45.20     1.29    1.42   0.99  89.77

vdc1             56.10    85.36  447.04  461.48     9.21    10.85
45.20     1.28    1.42   0.99  89.77



Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz
avgqu-sz   await  svctm  %util

vda               0.00    13.20    1.40    3.00     0.01     0.06
33.45     0.01    2.91   2.32   1.02

vda1              0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00

vda2              0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00

vda3              0.00    10.00    1.40    2.60     0.01     0.05
29.60     0.01    3.20   2.55   1.02

vda4              0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00

vda5              0.00     3.20    0.00    0.40     0.00     0.01
72.00     0.00    0.00   0.00   0.00

vdb               0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00

vdb1              0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00

vdc               0.00     0.00 1222.80   60.60    45.01     5.81
81.10     7.49    5.79   0.78 100.00

vdc1              0.00     0.00 1222.80   60.60    45.01     5.81
81.10     7.49    5.79   0.78 100.00



Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz
avgqu-sz   await  svctm  %util

vda               0.00    10.20    1.20   17.60     0.04     0.11
16.51     0.06    2.96   0.66   1.24

vda1              0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00

vda2              0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00

vda3              0.00     9.40    1.20   13.20     0.04     0.09
18.78     0.05    3.57   0.86   1.24

vda4              0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00

vda5              0.00     0.80    0.00    4.20     0.00     0.02
9.52     0.00    1.00   0.05   0.02

vdb               0.00     0.00    0.00    0.00     0.00     0.00
  0.00     0.00    0.00   0.00   0.00

vdb1              0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00

vdc               0.00     0.40  928.00  432.40    23.05    13.05
54.35     9.65    7.14   0.74 100.00

vdc1              0.00     0.40  928.00  432.40    23.05    13.05
54.35     9.65    7.14   0.74 100.00



Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz
avgqu-sz   await  svctm  %util

vda               0.00     7.60    0.00    2.40     0.00     0.04
32.00     0.10   41.67  16.33   3.92

vda1              0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00

vda2              0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00

vda3              0.00     7.60    0.00    2.00     0.00     0.04
38.40     0.09   46.60  16.20   3.24

vda4              0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00

vda5              0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00

vdb               0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00

vdb1              0.00     0.00    0.00    0.00     0.00     0.00     0.00
    0.00    0.00   0.00   0.00

vdc               0.00   293.20  352.20 1753.00     8.38    43.34
50.32    71.98   33.91   0.48 100.00

vdc1              0.00   293.20  352.20 1753.00     8.38    43.34
50.32    71.98   33.91   0.48 100.00



Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz
avgqu-sz   await  svctm  %util

vda               0.00    15.00    1.20    6.40     0.04     0.08
32.00     0.42   55.29  23.24  17.66

vda1              0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00

vda2              0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00

vda3              0.00    14.40    1.20    5.80     0.04     0.08
33.60     0.39   55.77  20.97  14.68

vda4              0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00

vda5              0.00     0.60    0.00    0.40     0.00     0.00
20.00     0.02   60.50  60.50   2.42

vdb               0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00

vdb1              0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00

vdc               0.20   676.20   20.40 3131.60     0.20    26.83
17.56   144.45   45.74   0.32 100.00

vdc1              0.20   676.20   20.40 3131.60     0.20    26.83
17.56   144.45   45.74   0.32 100.00



Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz
avgqu-sz   await  svctm  %util

vda               0.00     3.60    2.80    2.60     0.02     0.02
17.78     0.48   89.63  52.41  28.30

vda1              0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00

vda2              0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00

vda3              0.00     3.60    2.80    2.60     0.02     0.02
17.78     0.48   89.63  52.41  28.30

vda4              0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00

vda5              0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00

vdb               0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00

vdb1              0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00

vdc               1.40   518.00   51.80 3012.00     0.62    25.65
17.56   149.01   48.58   0.33 100.00

vdc1              1.40   518.00   51.80 3012.00     0.62    25.65
17.56   149.01   48.58   0.33 100.00



Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz
avgqu-sz   await  svctm  %util

vda               0.00     2.60    0.00    2.20     0.00     0.02
16.73     0.05   22.73  19.91   4.38

vda1              0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00

vda2              0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00

vda3              0.00     2.60    0.00    2.00     0.00     0.02
18.40     0.02    9.60   6.50   1.30

vda4              0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00

vda5              0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00

vdb               0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00

vdb1              0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00

vdc               3.40    62.00   65.40 1936.20     1.84     9.35
11.45   153.92   76.42   0.50 100.00

vdc1              3.40    62.00   65.40 1936.20     1.84     9.35
11.45   153.92   76.42   0.50 100.00



Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz
avgqu-sz   await  svctm  %util

vda               0.00     3.80    0.20    2.80     0.00     0.02
17.07     0.17   55.47  30.87   9.26

vda1              0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00

vda2              0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00

vda3              0.00     3.80    0.20    2.40     0.00     0.02
19.69     0.15   58.69  30.31   7.88

vda4              0.00     0.00    0.00    0.00     0.00     0.00     0.00
   0.00    0.00   0.00   0.00

vda5              0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00

vdb               0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00

vdb1              0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00

vdc               1.00   224.20  379.20 1752.60     5.32    14.94
19.46   100.70   47.71   0.47 100.00

vdc1              1.00   224.20  379.20 1752.60     5.32    14.94
19.46   100.70   47.71   0.47 100.00



Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz
avgqu-sz   await  svctm  %util

vda               0.00    15.00    3.20    7.00     0.04     0.09
25.25     0.04    4.29   2.49   2.54

vda1              0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00

vda2              0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00

vda3              0.00    15.00    3.20    6.80     0.04     0.09
25.76     0.04    4.38   2.54   2.54

vda4              0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00

vda5              0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00

vdb               0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00

vdb1              0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00

vdc               0.40    45.00  390.60 1060.60     8.16     8.61
23.66    80.59   56.24   0.68  99.20

vdc1              0.40    45.00  390.60 1060.60     8.16     8.61
23.66    80.59   56.24   0.68  99.20



Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz
avgqu-sz   await  svctm  %util

vda               0.00    91.40    3.00   48.20     0.03     0.55
23.00     0.11    2.20   0.33   1.70

vda1              0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00

vda2              0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00

vda3              0.00    66.00    3.00   38.40     0.03     0.41
21.64     0.10    2.34   0.41   1.68

vda4              0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00

vda5              0.00    25.40    0.00    9.80     0.00     0.14
28.73     0.02    1.61   0.08   0.08

vdb               0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00

vdb1              0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00

vdc               0.00     0.20  863.60  191.60    30.72    13.77
86.35     6.17    5.85   0.95  99.86

vdc1              0.00     0.20  863.60  191.60    30.72    13.77
86.35     6.17    5.85   0.95  99.86



Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz
avgqu-sz   await  svctm  %util

vda               0.00    32.20    0.00   13.80     0.00     0.18
 26.55     1.20   86.84   6.93   9.56

vda1              0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00

vda2              0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00

vda3              0.00    32.20    0.00   13.60     0.00     0.18
26.94     1.20   88.10   7.01   9.54

vda4              0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00

vda5              0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00

vdb               0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00

vdb1              0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00

vdc               0.00     0.60  791.00  359.00    16.53    36.44
94.34    25.17   21.87   0.87 100.00

vdc1              0.00     0.60  791.00  359.00    16.53    36.44
94.34    25.17   21.87   0.87 100.00



Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz
avgqu-sz   await  svctm  %util

vda               0.00    16.80    0.80   23.00     0.00     0.15
13.58     0.03    1.08   0.24   0.58

vda1              0.00     0.00    0.00    0.00     0.00     0.00     0.00
    0.00    0.00   0.00   0.00

vda2              0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00

vda3              0.00    11.00    0.80   17.20     0.00     0.11
12.98     0.02    1.26   0.31   0.56

vda4              0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00

vda5              0.00     5.80    0.00    5.40     0.00     0.04
16.59     0.00    0.59   0.07   0.04

vdb               0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00

vdb1              0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00

vdc               0.00     0.00 1143.40   12.40    40.78     3.05
77.67     6.23    5.39   0.87 100.02

vdc1              0.00     0.00 1143.40   12.40    40.78     3.05
77.67     6.23    5.39   0.87 100.02





*VM# vmstat 5 12 *

procs -----------memory---------- ---swap-- -----io---- --system--
-----cpu-----

r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id
wa st

6  3      0 1022148  77808 16266636    0    0   618   712    0    0  4 10
80  6  0

4  1      0 1086272  77384 16232348    0    0 24294 39514 19557 15659  2 24
54 20  0

0  4      0 1079320  77324 16239100    0    0  4667 25202 8772 11317  1  5
74 20  0

3  3      0 1094136  77308 16234064    0    0  1102 27323 8101 12963  3  4
79 14  0

5 10      0 1178908  77296 16156332    0    0  1370 18625 9776 11009  1  8
64 27  0

4  5      0 1387024  77020 15991676    0    0 10094  3260 19037 14185  1 23
61 14  0

4  3      0 1300224  77028 15920712    0    0  3219 20062 17265 14902  7 18
63 12  0

1 11      0 1522772  77064 15796712    0    0  1095 23720 13740 15666  7 11
50 32  0

6  1      0 1557288  77172 15810492    0    0  4626 31199 16900 14040  6 18
53 23  0

5  2      0 1529284  77204 15850112    0    0  9396  6547 17183 13949  2 21
57 20  0

3  1      0 1480028  77212 15881516    0    0 10033  3002 20339 14766  1 26
64  9  0

6  2      0 1447844  77228 15915300    0    0 10855  4226 19170 14180  3 23
65  9  0





*HV# /opt/MegaRAID/MegaCli/MegaCli64  -LdPdInfo -a0 *



Adapter #0



Number of Virtual Disks: 2

Virtual Drive: 0 (Target Id: 0)

Name                :

RAID Level          : Primary-6, Secondary-0, RAID Level Qualifier-3

Size                : 45.998 GB

Parity Size         : 4.181 GB

State               : Optimal

Strip Size          : 256 KB

Number Of Drives    : 24

Span Depth          : 1

Default Cache Policy: WriteBack, ReadAhead, Direct, No Write Cache if Bad
BBU

Current Cache Policy: WriteBack, ReadAhead, Direct, No Write Cache if Bad
BBU

Default Access Policy: Read/Write

Current Access Policy: Read/Write

Disk Cache Policy   : Disabled

Encryption Type     : None

Is VD Cached: No

Number of Spans: 1

Span: 0 - Number of PDs: 24



PD: 0 Information

Enclosure Device ID: 34

Slot Number: 0

Drive's postion: DiskGroup: 0, Span: 0, Arm: 0

Enclosure position: 0

Device Id: 35

WWN: 5000CCA01D350CC3

Sequence Number: 2

Media Error Count: 0

Other Error Count: 0

Predictive Failure Count: 0

Last Predictive Failure Event Seq Number: 0

PD Type: SAS

Raw Size: 1.090 TB [0x8bba0cb0 Sectors]

Non Coerced Size: 1.090 TB [0x8baa0cb0 Sectors]

Coerced Size: 1.089 TB [0x8b94f800 Sectors]

Firmware state: Online, Spun Up

Is Commissioned Spare : NO

Device Firmware Level: A600

Shield Counter: 0

Successful diagnostics completion on :  N/A

SAS Address(0): 0x5000cca01d350cc1

SAS Address(1): 0x0

Connected Port Number: 0(path0)

Inquiry Data: HGST    H101212SESUN1.2TA6001404DY5EPE

FDE Enable: Disable

Secured: Unsecured

Locked: Unlocked

Needs EKM Attention: No

Foreign State: None

Device Speed: 6.0Gb/s

Link Speed: 6.0Gb/s

Media Type: Hard Disk Device

Drive Temperature :26C (78.80 F)

PI Eligibility:  No

Drive is formatted for PI information:  No

PI: No PI

Drive's write cache : Disabled

Port-0 :

Port status: Active

Port's Linkspeed: 6.0Gb/s

Port-1 :

Port status: Active

Port's Linkspeed: Unknown

Drive has flagged a S.M.A.R.T alert : No





*KERNEL OPTIONS: Which of these kernels should I choose for the best XFS
support for this issue?*



     kernel-3.16.7-3.16.y.20141114.ol6.x86_64.rpm     14-Nov-2014 17:55
27.7 M

     kernel-3.17.3-3.17.y.20141114.ol6.x86_64.rpm     14-Nov-2014 23:55
26.6 M

     kernel-3.17.3-3.17.y.20141118.ol6.x86_64.rpm     18-Nov-2014 09:13
26.6 M

     kernel-3.17.8-3.17.y.20150113.ol6.x86_64.rpm     14-Jan-2015 06:50
27.9 M

     kernel-3.18.6-3.18.y.20150210.ol6.x86_64.rpm     10-Feb-2015 09:52
30.9 M

     kernel-3.18.7-3.18.y.20150217.ol6.x86_64.rpm     17-Feb-2015 09:53
30.9 M

     kernel-3.18.8-3.18.y.20150303.ol6.x86_64.rpm     03-Mar-2015 09:55
30.9 M

     kernel-3.19.5-3.19.y.20150421.ol6.x86_64.rpm     22-Apr-2015 05:42
31.1 M

     kernel-3.19.6-3.19.y.20150505.ol6.x86_64.rpm     06-May-2015 05:41
29.8 M

     kernel-3.19.8-3.19.y.20150512.ol6.x86_64.rpm     13-May-2015 05:42
29.8 M




Thank you for your time and comments.


Regards,


Pippin Wallace

Bozeman Montana

--089e01634d6a80efcf051d39cafe
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_quote"><div lang=3D"EN-US" link=3D"blu=
e" vlink=3D"purple"><p class=3D"MsoNormal"><span style=3D"font-family:&quot=
;Courier New&quot;">=C2=A0<u></u></span></p><p class=3D"MsoNormal"><span st=
yle=3D"font-family:&quot;Courier New&quot;">I am writing to confirm the iss=
ue I think I have and get advice on the best short term and long term =E2=
=80=9Cfixes=E2=80=9D.<u></u><u></u></span></p><p class=3D"MsoNormal"><span =
style=3D"font-family:&quot;Courier New&quot;"><u></u>=C2=A0<u></u></span></=
p><p class=3D"MsoNormal"><font face=3D"Courier New">In reading the followin=
g threads and others I am pretty sure I have inode btree fragmentation and =
I have included=C2=A0detailed=C2=A0output=C2=A0below to help confirm this.=
=C2=A0 <u></u><u></u></font></p><p class=3D"MsoNormal"><span style=3D"font-=
family:&quot;Courier New&quot;"><u></u>=C2=A0<u></u></span></p><p>Is XFS su=
itable for 350 million files on 20TB storage?<u></u><u></u></p><p><a href=
=3D"http://oss.sgi.com/archives/xfs/2014-09/msg00046.html" target=3D"_blank=
"><span style=3D"color:windowtext;text-decoration:none">http://oss.sgi.com/=
archives/xfs/2014-09/msg00046.html</span></a><u></u><u></u></p><p><u></u>=
=C2=A0<u></u></p><p>Bad performance on touch/cp file on XFS system <u></u><=
u></u></p><p><a href=3D"http://oss.sgi.com/archives/xfs/2014-08/msg00348.ht=
ml" target=3D"_blank"><span style=3D"color:windowtext;text-decoration:none"=
>http://oss.sgi.com/archives/xfs/2014-08/msg00348.html</span></a><u></u><u>=
</u></p><p><u></u>=C2=A0<u></u></p><p>Extremely slow file creation/deletion=
 after xfs ran full <u></u><u></u></p><p><a href=3D"http://oss.sgi.com/arch=
ives/xfs/2015-01/msg00203.html" target=3D"_blank"><span style=3D"color:wind=
owtext;text-decoration:none">http://oss.sgi.com/archives/xfs/2015-01/msg002=
03.html</span></a><u></u><u></u></p><p class=3D"MsoNormal"><span style=3D"f=
ont-family:&quot;Courier New&quot;"><u></u>=C2=A0<u></u></span></p><p class=
=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;"><u></u>=
=C2=A0<u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&=
quot;Courier New&quot;">In addition to diagnosis I want to insure I take th=
e right steps to improve performance in the short term and fix it correctly=
 and thoroughly for the long term.<u></u><u></u></span></p><p class=3D"MsoN=
ormal"><span style=3D"font-family:&quot;Courier New&quot;"><u></u>=C2=A0<u>=
</u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Cour=
ier New&quot;">Our workload is heavy write/delete and light reads.=C2=A0 Mo=
st files are smallish and we cannot mount xfs with inode64 as our primary a=
pp is 32 bit.=C2=A0 Our hosts are running as VM=E2=80=99s on a KVM hypervis=
or.<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-fami=
ly:&quot;Courier New&quot;"><u></u>=C2=A0<u></u></span></p><p class=3D"MsoN=
ormal"><span style=3D"font-family:&quot;Courier New&quot;">Suggestion from =
Dave in post </span>=C2=A0<span style=3D"font-family:&quot;Courier New&quot=
;"><a href=3D"http://oss.sgi.com/archives/xfs/2014-08/msg00349.html" target=
=3D"_blank">http://oss.sgi.com/archives/xfs/2014-08/msg00349.html</a><u></u=
><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;=
Courier New&quot;">If this is still the best short term fix would you pleas=
e direct me to the =E2=80=9CHow To=E2=80=9D for doing this?<u></u><u></u></=
span></p><p class=3D"MsoNormal" style=3D"margin-left:.5in;background:#eeeee=
e"><i><span style=3D"font-size:10.0pt;font-family:&quot;Courier New&quot;;c=
olor:black">=E2=80=9Cfilling in all the holes (by creating a bunch of zero =
length files in the<u></u><u></u></span></i></p><p class=3D"MsoNormal" styl=
e=3D"margin-left:.5in;background:#eeeeee"><i><span style=3D"font-size:10.0p=
t;font-family:&quot;Courier New&quot;;color:black">appropriate AGs) might t=
ake some time, but it should make the<u></u><u></u></span></i></p><p class=
=3D"MsoNormal" style=3D"margin-left:.5in;background:#eeeeee"><i><span style=
=3D"font-size:10.0pt;font-family:&quot;Courier New&quot;;color:black">probl=
em go away until you remove more filesystem and create random<u></u><u></u>=
</span></i></p><p class=3D"MsoNormal" style=3D"margin-left:.5in;background:=
#eeeeee"><i><span style=3D"font-size:10.0pt;font-family:&quot;Courier New&q=
uot;;color:black">free inode holes again...=E2=80=9D<u></u><u></u></span></=
i></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&q=
uot;"><u></u>=C2=A0<u></u></span></p><p class=3D"MsoNormal"><span style=3D"=
font-family:&quot;Courier New&quot;">Is this also a possible short term fix=
?=C2=A0 <a href=3D"http://osvault.blogspot.com/2011/03/fixing-1tbyte-inode-=
problem-in-xfs-file.html" target=3D"_blank">http://osvault.blogspot.com/201=
1/03/fixing-1tbyte-inode-problem-in-xfs-file.html</a><u></u><u></u></span><=
/p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot=
;"><u></u>=C2=A0<u></u></span></p><p class=3D"MsoNormal"><span style=3D"fon=
t-family:&quot;Courier New&quot;"><u></u>=C2=A0<u></u></span></p><p class=
=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">Long ter=
m fix is upgrade kernel to &gt;=3D 3.16, xfsprogs &gt;=3D3.2.1 and rebuild =
fs with new finobt structure.</span><span style=3D"color:black"><u></u><u><=
/u></span></p><pre style=3D"background:#eeeeee"><span style=3D"color:#1f497=
d">=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 </span><span style=3D"color:b=
lack"># mkfs.xfs -m crc=3D1,finobt=3D1 &lt;dev&gt;<u></u><u></u></span></pr=
e><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;=
;color:#1f497d"><u></u>=C2=A0<u></u></span></p><p class=3D"MsoNormal"><span=
 style=3D"font-family:&quot;Courier New&quot;;color:#1f497d"><u></u>=C2=A0<=
u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Co=
urier New&quot;;color:#1f497d"><u></u>=C2=A0<u></u></span></p><p class=3D"M=
soNormal"><span style=3D"font-family:&quot;Courier New&quot;;color:#1f497d"=
>Here is info others have asked for in previous threads and further below t=
hat is data collected based on =E2=80=9CWhat information should I include w=
hen reporting a problem?=E2=80=9D from your FAQ.<u></u><u></u></span></p><p=
 class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;;col=
or:#1f497d"><u></u>=C2=A0<u></u></span></p><p class=3D"MsoNormal"><span sty=
le=3D"font-family:&quot;Courier New&quot;;color:#1f497d">If a command line =
in bold below starts with a VM then this command was run on the Virtual Mac=
hine or guest OS and if it starts with a HV then it was run on the physical=
 HyperVisor machine that is hosting the guest OS.<u></u><u></u></span></p><=
p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;"><=
u></u>=C2=A0<u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-fa=
mily:&quot;Courier New&quot;"><u></u>=C2=A0<u></u></span></p><p class=3D"Ms=
oNormal"><b><u><span style=3D"font-family:&quot;Courier New&quot;">VM# perf=
 top<u></u><u></u></span></u></b></p><p class=3D"MsoNormal"><span style=3D"=
font-family:&quot;Courier New&quot;">Samples: 378K of event &#39;cpu-clock&=
#39;, Event count (approx.): 188377<u></u><u></u></span></p><p class=3D"Mso=
Normal"><span style=3D"font-family:&quot;Courier New&quot;">14.10%=C2=A0 [k=
ernel]=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 [k] xfs_inobt_get_rec<u></u><=
u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Co=
urier New&quot;">=C2=A0 9.58%=C2=A0 [kernel]=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 [k] xfs_btree_increment<u></u><u></u></span></p><p class=3D"MsoNo=
rmal"><span style=3D"font-family:&quot;Courier New&quot;">=C2=A0 9.08%=C2=
=A0 [kernel]=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 [k] xfs_btree_get_rec<u=
></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&q=
uot;Courier New&quot;">=C2=A0 8.83%=C2=A0 [kernel]=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0[k] _xfs_buf_find<u></u><u></u></span></p><p class=3D"Mso=
Normal"><span style=3D"font-family:&quot;Courier New&quot;">=C2=A0 5.84%=C2=
=A0 [kernel]=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 [k] xfs_btree_get_block=
<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:=
&quot;Courier New&quot;">=C2=A0 3.91%=C2=A0 [kernel]=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 [k] xfs_btree_rec_offset<u></u><u></u></span></p><p clas=
s=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=C2=A0 =
3.85%=C2=A0 [kernel]=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 [k] xfs_diallo=
c_ag<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-fam=
ily:&quot;Courier New&quot;">=C2=A0 3.64%=C2=A0 [kernel]=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 [k] xfs_btree_readahead<u></u><u></u></span></p><p cl=
ass=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=C2=
=A0 3.15%=C2=A0 [kernel]=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 [k] _raw_sp=
in_unlock_irqrestore<u></u><u></u></span></p><p class=3D"MsoNormal"><span s=
tyle=3D"font-family:&quot;Courier New&quot;">=C2=A0 2.97%=C2=A0 [kernel]=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 [k] xfs_btree_rec_addr<u></u><u></u></=
span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier Ne=
w&quot;">=C2=A0 2.31%=C2=A0 [kernel]=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 [k] xfs_trans_buf_item_match<u></u><u></u></span></p><p class=3D"MsoNormal=
"><span style=3D"font-family:&quot;Courier New&quot;">=C2=A0 1.67%=C2=A0 [k=
ernel]=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 [k] xfs_btree_setbuf<u></u><u=
></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Cou=
rier New&quot;"><u></u>=C2=A0<u></u></span></p><p class=3D"MsoNormal"><span=
 style=3D"font-family:&quot;Courier New&quot;;color:#1f497d"><u></u>=C2=A0<=
u></u></span></p><p class=3D"MsoNormal"><b><u><span style=3D"font-family:&q=
uot;Courier New&quot;;color:#1f497d">VM# time xfs_db -r -c &quot;frag&quot;=
 /dev/vdc1=C2=A0=C2=A0 <u></u><u></u></span></u></b></p><p class=3D"MsoNorm=
al"><span style=3D"font-family:&quot;Courier New&quot;;color:#1f497d">actua=
l 80103457, ideal 79500897, fragmentation factor 0.75%<u></u><u></u></span>=
</p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quo=
t;;color:#1f497d">real=C2=A0=C2=A0=C2=A0 53m19.167s<u></u><u></u></span></p=
><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;;=
color:#1f497d">user=C2=A0=C2=A0=C2=A0 0m35.050s<u></u><u></u></span></p><p =
class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;;colo=
r:#1f497d">sys=C2=A0=C2=A0=C2=A0=C2=A0 3m35.390s<u></u><u></u></span></p><p=
 class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;;col=
or:#1f497d"><u></u>=C2=A0<u></u></span></p><p class=3D"MsoNormal"><span sty=
le=3D"font-family:&quot;Courier New&quot;;color:#1f497d"><u></u>=C2=A0<u></=
u></span></p><p class=3D"MsoNormal"><b><u><span style=3D"font-family:&quot;=
Courier New&quot;;color:#1f497d">VM# xfs_db -r -c &quot;frag -d&quot; /dev/=
vdc1<u></u><u></u></span></u></b></p><p class=3D"MsoNormal"><span style=3D"=
font-family:&quot;Courier New&quot;;color:#1f497d">actual 8947229, ideal 84=
06330, fragmentation factor 6.05%<u></u><u></u></span></p><p class=3D"MsoNo=
rmal"><span style=3D"font-family:&quot;Courier New&quot;;color:#1f497d"><u>=
</u>=C2=A0<u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-fami=
ly:&quot;Courier New&quot;"><u></u>=C2=A0<u></u></span></p><p class=3D"MsoN=
ormal"><b><u><span style=3D"font-family:&quot;Courier New&quot;">VM# df -i =
/dev/vdc1<u></u><u></u></span></u></b></p><p class=3D"MsoNormal"><span styl=
e=3D"font-family:&quot;Courier New&quot;">Filesystem=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 Inodes=C2=A0=C2=A0=C2=A0=C2=A0 IUsed=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 IFree IUse% Mounted on<u></u><u></u></span></p><p cla=
ss=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">/dev/v=
dc1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 6,442,426,368 152,347,297 6,290,079,071=
=C2=A0=C2=A0=C2=A0 3% /exports<u></u><u></u></span></p><p class=3D"MsoNorma=
l"><span style=3D"font-family:&quot;Courier New&quot;"><u></u>=C2=A0<u></u>=
</span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier =
New&quot;;color:#1f497d"><u></u>=C2=A0<u></u></span></p><p class=3D"MsoNorm=
al"><b><u><span style=3D"font-family:&quot;Courier New&quot;;color:#1f497d"=
>VM# for i in `seq 0 $((16-1))`; do echo &quot;freespace in ag$i&quot;; xfs=
_db -r -c &quot;freesp -s -a $i&quot; /dev/vdc1 | grep &quot;total free&quo=
t; | sed &#39;s/^/ /g&#39;; done<u></u><u></u></span></u></b></p><p class=
=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;;color:#1f=
497d">freespace in ag0<u></u><u></u></span></p><p class=3D"MsoNormal"><span=
 style=3D"font-family:&quot;Courier New&quot;;color:#1f497d">total free ext=
ents 611688<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"f=
ont-family:&quot;Courier New&quot;;color:#1f497d">total free blocks 4559016=
5<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family=
:&quot;Courier New&quot;;color:#1f497d">freespace in ag1<u></u><u></u></spa=
n></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&q=
uot;;color:#1f497d">total free extents 606085<u></u><u></u></span></p><p cl=
ass=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;;color:=
#1f497d">total free blocks 45576240<u></u><u></u></span></p><p class=3D"Mso=
Normal"><span style=3D"font-family:&quot;Courier New&quot;;color:#1f497d">f=
reespace in ag2<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=
=3D"font-family:&quot;Courier New&quot;;color:#1f497d">total free extents 6=
06482<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-fa=
mily:&quot;Courier New&quot;;color:#1f497d">total free blocks 45571903<u></=
u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot=
;Courier New&quot;;color:#1f497d">freespace in ag3<u></u><u></u></span></p>=
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;;c=
olor:#1f497d">total free extents 604576<u></u><u></u></span></p><p class=3D=
"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;;color:#1f497=
d">total free blocks 45572111<u></u><u></u></span></p><p class=3D"MsoNormal=
"><span style=3D"font-family:&quot;Courier New&quot;;color:#1f497d">freespa=
ce in ag4<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"fon=
t-family:&quot;Courier New&quot;;color:#1f497d">total free extents 74367<u>=
</u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&qu=
ot;Courier New&quot;;color:#1f497d">total free blocks 15129234<u></u><u></u=
></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier=
 New&quot;;color:#1f497d">freespace in ag5<u></u><u></u></span></p><p class=
=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;;color:#1f=
497d">total free extents 172955<u></u><u></u></span></p><p class=3D"MsoNorm=
al"><span style=3D"font-family:&quot;Courier New&quot;;color:#1f497d">total=
 free blocks 17015698<u></u><u></u></span></p><p class=3D"MsoNormal"><span =
style=3D"font-family:&quot;Courier New&quot;;color:#1f497d">freespace in ag=
6<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family=
:&quot;Courier New&quot;;color:#1f497d">total free extents 176759<u></u><u>=
</u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Cour=
ier New&quot;;color:#1f497d">total free blocks 14716774<u></u><u></u></span=
></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&qu=
ot;;color:#1f497d">freespace in ag7<u></u><u></u></span></p><p class=3D"Mso=
Normal"><span style=3D"font-family:&quot;Courier New&quot;;color:#1f497d">t=
otal free extents 170481<u></u><u></u></span></p><p class=3D"MsoNormal"><sp=
an style=3D"font-family:&quot;Courier New&quot;;color:#1f497d">total free b=
locks 15031152<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=
=3D"font-family:&quot;Courier New&quot;;color:#1f497d">freespace in ag8<u><=
/u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quo=
t;Courier New&quot;;color:#1f497d">total free extents 173346<u></u><u></u><=
/span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier N=
ew&quot;;color:#1f497d">total free blocks 15677354<u></u><u></u></span></p>=
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;;c=
olor:#1f497d">freespace in ag9<u></u><u></u></span></p><p class=3D"MsoNorma=
l"><span style=3D"font-family:&quot;Courier New&quot;;color:#1f497d">total =
free extents 177170<u></u><u></u></span></p><p class=3D"MsoNormal"><span st=
yle=3D"font-family:&quot;Courier New&quot;;color:#1f497d">total free blocks=
 14914037<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"fon=
t-family:&quot;Courier New&quot;;color:#1f497d">freespace in ag10<u></u><u>=
</u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Cour=
ier New&quot;;color:#1f497d">total free extents 169536<u></u><u></u></span>=
</p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quo=
t;;color:#1f497d">total free blocks 16267638<u></u><u></u></span></p><p cla=
ss=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;;color:#=
1f497d">freespace in ag11<u></u><u></u></span></p><p class=3D"MsoNormal"><s=
pan style=3D"font-family:&quot;Courier New&quot;;color:#1f497d">total free =
extents 173325<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=
=3D"font-family:&quot;Courier New&quot;;color:#1f497d">total free blocks 14=
618827<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-f=
amily:&quot;Courier New&quot;;color:#1f497d">freespace in ag12<u></u><u></u=
></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier=
 New&quot;;color:#1f497d">total free extents 174743<u></u><u></u></span></p=
><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;;=
color:#1f497d">total free blocks 14634872<u></u><u></u></span></p><p class=
=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;;color:#1f=
497d">freespace in ag13<u></u><u></u></span></p><p class=3D"MsoNormal"><spa=
n style=3D"font-family:&quot;Courier New&quot;;color:#1f497d">total free ex=
tents 173378<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"=
font-family:&quot;Courier New&quot;;color:#1f497d">total free blocks 164126=
26<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-famil=
y:&quot;Courier New&quot;;color:#1f497d">freespace in ag14<u></u><u></u></s=
pan></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New=
&quot;;color:#1f497d">total free extents 171388<u></u><u></u></span></p><p =
class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;;colo=
r:#1f497d">total free blocks 15198251<u></u><u></u></span></p><p class=3D"M=
soNormal"><span style=3D"font-family:&quot;Courier New&quot;;color:#1f497d"=
>freespace in ag15<u></u><u></u></span></p><p class=3D"MsoNormal"><span sty=
le=3D"font-family:&quot;Courier New&quot;;color:#1f497d">total free extents=
 170986<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-=
family:&quot;Courier New&quot;;color:#1f497d">total free blocks 13790690<u>=
</u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&qu=
ot;Courier New&quot;;color:#1f497d"><u></u>=C2=A0<u></u></span></p><p class=
=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;;color:#1f=
497d"><u></u>=C2=A0<u></u></span></p><p class=3D"MsoNormal"><b><u><span sty=
le=3D"font-family:&quot;Courier New&quot;;color:#1f497d">=E2=80=9CWhat info=
rmation should I include when reporting a problem?=E2=80=9D<u></u><u></u></=
span></u></b></p><p class=3D"MsoNormal"><b><u><span style=3D"font-family:&q=
uot;Courier New&quot;"><u></u><span style=3D"text-decoration:none">=C2=A0</=
span><u></u></span></u></b></p><p class=3D"MsoNormal"><b><u><span style=3D"=
font-family:&quot;Courier New&quot;"><u></u><span style=3D"text-decoration:=
none">=C2=A0</span><u></u></span></u></b></p><p class=3D"MsoNormal"><b><u><=
span style=3D"font-family:&quot;Courier New&quot;">VM# uname -a=C2=A0 <u></=
u><u></u></span></u></b></p><p class=3D"MsoNormal"><span style=3D"font-fami=
ly:&quot;Courier New&quot;">Linux 3.8.13-55.1.2.el6uek.x86_64 #2 SMP Thu De=
c 18 00:15:51 PST 2014 x86_64 x86_64 x86_64 GNU/Linux<u></u><u></u></span><=
/p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot=
;"><u></u>=C2=A0<u></u></span></p><p class=3D"MsoNormal"><b><u><span style=
=3D"font-family:&quot;Courier New&quot;">HV# uname -a<u></u><u></u></span><=
/u></b></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier =
New&quot;">Linux 2.6.32-431.el6.x86_64 #1 SMP Wed Nov 20 23:56:07 PST 2013 =
x86_64 x86_64 x86_64 GNU/Linux<u></u><u></u></span></p><p class=3D"MsoNorma=
l"><b><u><span style=3D"font-family:&quot;Courier New&quot;"><u></u><span s=
tyle=3D"text-decoration:none">=C2=A0</span><u></u></span></u></b></p><p cla=
ss=3D"MsoNormal"><b><u><span style=3D"font-family:&quot;Courier New&quot;">=
<u></u><span style=3D"text-decoration:none">=C2=A0</span><u></u></span></u>=
</b></p><p class=3D"MsoNormal"><b><u><span style=3D"font-family:&quot;Couri=
er New&quot;">VM# xfs_repair -V <u></u><u></u></span></u></b></p><p class=
=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">xfs_repa=
ir version 3.1.11<u></u><u></u></span></p><p class=3D"MsoNormal"><span styl=
e=3D"font-family:&quot;Courier New&quot;"><u></u>=C2=A0<u></u></span></p><p=
 class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;"><u=
></u>=C2=A0<u></u></span></p><p class=3D"MsoNormal"><b><u><span style=3D"fo=
nt-family:&quot;Courier New&quot;">VM# dmidecode |grep -A3 Product<u></u><u=
></u></span></u></b></p><p class=3D"MsoNormal"><span style=3D"font-family:&=
quot;Courier New&quot;">=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Product =
Name: KVM<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"fon=
t-family:&quot;Courier New&quot;">=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 Version: RHEL 6.5.0 PC<u></u><u></u></span></p><p class=3D"MsoNormal"><=
span style=3D"font-family:&quot;Courier New&quot;"><u></u>=C2=A0<u></u></sp=
an></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&=
quot;"><u></u>=C2=A0<u></u></span></p><p class=3D"MsoNormal"><b><u><span st=
yle=3D"font-family:&quot;Courier New&quot;">HV# dmidecode |egrep -A4 &quot;=
Product|Processor&quot;<u></u><u></u></span></u></b></p><p class=3D"MsoNorm=
al"><span style=3D"font-family:&quot;Courier New&quot;">=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 Product Name: SUN SERVER X4-2L=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 <u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D=
"font-family:&quot;Courier New&quot;">Processor Information<u></u><u></u></=
span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier Ne=
w&quot;">=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Socket Designation: P0<=
u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&=
quot;Courier New&quot;">=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Family: =
Xeon<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-fam=
ily:&quot;Courier New&quot;">=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Sig=
nature: Type 0, Family 6, Model 62, Stepping 4<u></u><u></u></span></p><p c=
lass=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">Proc=
essor Information<u></u><u></u></span></p><p class=3D"MsoNormal"><span styl=
e=3D"font-family:&quot;Courier New&quot;">=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 Socket Designation: P1<u></u><u></u></span></p><p class=3D"MsoNor=
mal"><span style=3D"font-family:&quot;Courier New&quot;">=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 Family: Xeon<u></u><u></u></span></p><p class=3D"M=
soNormal"><span style=3D"font-family:&quot;Courier New&quot;">=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Signature: Type 0, Family 6, Model 62, Stepp=
ing 4<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-fa=
mily:&quot;Courier New&quot;"><u></u>=C2=A0<u></u></span></p><p class=3D"Ms=
oNormal"><span style=3D"font-family:&quot;Courier New&quot;"><u></u>=C2=A0<=
u></u></span></p><p class=3D"MsoNormal"><b><u><span style=3D"font-family:&q=
uot;Courier New&quot;">VM# cat /proc/cpuinfo (Total of 16 virtual cpu=E2=80=
=99s all with the same settings as cpu 0 below.)<u></u><u></u></span></u></=
b></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&q=
uot;">processor=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 0<u></u><u></u></span=
></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&qu=
ot;">vendor_id=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : GenuineIntel<u></u><u>=
</u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Cour=
ier New&quot;">cpu family=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 6<u></u><u></u></=
span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier Ne=
w&quot;">model=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
: 13<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-fam=
ily:&quot;Courier New&quot;">model name=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : QEM=
U Virtual CPU version (cpu64-rhel6)<u></u><u></u></span></p><p class=3D"Mso=
Normal"><span style=3D"font-family:&quot;Courier New&quot;">stepping=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 3<u></u><u></u></span></p><p class=
=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">microcod=
e=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 0x1<u></u><u></u></span></p><p clas=
s=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">cpu MHz=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 2693.508<u></u><u></u></=
span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier Ne=
w&quot;">cache size=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 4096 KB<u></u><u></u></=
span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier Ne=
w&quot;">fpu=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 : yes<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=
=3D"font-family:&quot;Courier New&quot;">fpu_exception=C2=A0=C2=A0 : yes<u>=
</u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&qu=
ot;Courier New&quot;">cpuid level=C2=A0=C2=A0=C2=A0=C2=A0 : 4<u></u><u></u>=
</span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier =
New&quot;">wp=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 : yes<u></u><u></u></span></p><p class=3D"MsoNormal"><sp=
an style=3D"font-family:&quot;Courier New&quot;">flags=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : fpu de pse tsc msr pae mce cx8 ap=
ic sep mtrr pge mca cmov pse36 clflush mmx fxsr sse sse2 syscall nx lm nopl=
 pni cx16 hypervisor lahf_lm<u></u><u></u></span></p><p class=3D"MsoNormal"=
><span style=3D"font-family:&quot;Courier New&quot;">bogomips=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 5387.01<u></u><u></u></span></p><p class=
=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">clflush =
size=C2=A0=C2=A0=C2=A0 : 64<u></u><u></u></span></p><p class=3D"MsoNormal">=
<span style=3D"font-family:&quot;Courier New&quot;">cache_alignment : 64<u>=
</u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&qu=
ot;Courier New&quot;">address sizes=C2=A0=C2=A0 : 46 bits physical, 48 bits=
 virtual<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font=
-family:&quot;Courier New&quot;">power management:<u></u><u></u></span></p>=
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
<u></u>=C2=A0<u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-f=
amily:&quot;Courier New&quot;"><u></u>=C2=A0<u></u></span></p><p class=3D"M=
soNormal"><b><u><span style=3D"font-family:&quot;Courier New&quot;">VM# cat=
 /proc/meminfo <u></u><u></u></span></u></b></p><p class=3D"MsoNormal"><spa=
n style=3D"font-family:&quot;Courier New&quot;">MemTotal:=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 49463428 kB<u></u><u></u></span></p><p class=3D"MsoNorma=
l"><span style=3D"font-family:&quot;Courier New&quot;">MemFree:=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 931832 kB<u></u><u></u></span></=
p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;=
">Buffers:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 8150=
4 kB<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-fam=
ily:&quot;Courier New&quot;">Cached:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 16499856 kB<u></u><u></u></span></p><p class=3D"MsoNormal"><span =
style=3D"font-family:&quot;Courier New&quot;">SwapCached:=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0 kB<u></u><u></u></span><=
/p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot=
;">Active:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 21534272 kB<u></=
u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot=
;Courier New&quot;">Inactive:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 10518940 =
kB<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-famil=
y:&quot;Courier New&quot;">Active(anon):=C2=A0=C2=A0 13615056 kB<u></u><u><=
/u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Couri=
er New&quot;">Inactive(anon):=C2=A0 1859060 kB<u></u><u></u></span></p><p c=
lass=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">Acti=
ve(file):=C2=A0=C2=A0=C2=A0 7919216 kB<u></u><u></u></span></p><p class=3D"=
MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">Inactive(fil=
e):=C2=A0 8659880 kB<u></u><u></u></span></p><p class=3D"MsoNormal"><span s=
tyle=3D"font-family:&quot;Courier New&quot;">Unevictable:=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0 kB<u></u><u></u></span></p><p =
class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">Mlo=
cked:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 0 kB<u></u><u></u></span></p><p class=3D"MsoNormal"><span s=
tyle=3D"font-family:&quot;Courier New&quot;">SwapTotal:=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 2096124 kB<u></u><u></u></span></p><p class=3D"MsoNormal=
"><span style=3D"font-family:&quot;Courier New&quot;">SwapFree:=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 2096124 kB<u></u><u></u></span></p><p class=
=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">Dirty:=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 117192 k=
B<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family=
:&quot;Courier New&quot;">Writeback:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0 kB<u></u><u></u></span></p><p class=3D"=
MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">AnonPages:=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 15468324 kB<u></u><u></u></span></p><p class=
=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">Mapped:=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 39484 kB=
<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:=
&quot;Courier New&quot;">Shmem:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 3888 kB<u></u><u></u></span></p><p cla=
ss=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">Slab:=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 7883016 =
kB<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-famil=
y:&quot;Courier New&quot;">SReclaimable:=C2=A0=C2=A0=C2=A0 6149288 kB<u></u=
><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;=
Courier New&quot;">SUnreclaim:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1733728 kB<u><=
/u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quo=
t;Courier New&quot;">KernelStack:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 11000=
 kB<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-fami=
ly:&quot;Courier New&quot;">PageTables:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 180756 kB<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"fo=
nt-family:&quot;Courier New&quot;">NFS_Unstable:=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 0 kB<u></u><u></u></span></p><p class=3D"MsoNor=
mal"><span style=3D"font-family:&quot;Courier New&quot;">Bounce:=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 0 kB<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"f=
ont-family:&quot;Courier New&quot;">WritebackTmp:=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0 kB<u></u><u></u></span></p><p class=3D"Mso=
Normal"><span style=3D"font-family:&quot;Courier New&quot;">CommitLimit:=C2=
=A0=C2=A0=C2=A0 26827836 kB<u></u><u></u></span></p><p class=3D"MsoNormal">=
<span style=3D"font-family:&quot;Courier New&quot;">Committed_AS:=C2=A0=C2=
=A0 21133332 kB<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=
=3D"font-family:&quot;Courier New&quot;">VmallocTotal:=C2=A0=C2=A0 34359738=
367 kB<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-f=
amily:&quot;Courier New&quot;">VmallocUsed:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1=
12668 kB<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font=
-family:&quot;Courier New&quot;">VmallocChunk:=C2=A0=C2=A0 34359623568 kB<u=
></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&q=
uot;Courier New&quot;">HardwareCorrupted:=C2=A0=C2=A0=C2=A0=C2=A0 0 kB<u></=
u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot=
;Courier New&quot;">HugePages_Total:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0<=
u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&=
quot;Courier New&quot;">HugePages_Free:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 0<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font=
-family:&quot;Courier New&quot;">HugePages_Rsvd:=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 0<u></u><u></u></span></p><p class=3D"MsoNormal"><span styl=
e=3D"font-family:&quot;Courier New&quot;">HugePages_Surp:=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 0<u></u><u></u></span></p><p class=3D"MsoNormal"><=
span style=3D"font-family:&quot;Courier New&quot;">Hugepagesize:=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 2048 kB<u></u><u></u></span></p><p class=3D"Mso=
Normal"><span style=3D"font-family:&quot;Courier New&quot;">DirectMap4k:=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 10224 kB<u></u><u></u></span></p><p class=
=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">DirectMa=
p2M:=C2=A0=C2=A0=C2=A0 50321408 kB<u></u><u></u></span></p><p class=3D"MsoN=
ormal"><b><span style=3D"font-family:&quot;Courier New&quot;"><u></u>=C2=A0=
<u></u></span></b></p><p class=3D"MsoNormal"><b><span style=3D"font-family:=
&quot;Courier New&quot;"><u></u>=C2=A0<u></u></span></b></p><p class=3D"Mso=
Normal"><b><u><span style=3D"font-family:&quot;Courier New&quot;">VM# cat /=
proc/mounts <u></u><u></u></span></u></b></p><p class=3D"MsoNormal"><span s=
tyle=3D"font-family:&quot;Courier New&quot;">rootfs / rootfs rw 0 0<u></u><=
u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Co=
urier New&quot;">proc /proc proc rw,relatime 0 0<u></u><u></u></span></p><p=
 class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">sy=
sfs /sys sysfs rw,relatime 0 0<u></u><u></u></span></p><p class=3D"MsoNorma=
l"><span style=3D"font-family:&quot;Courier New&quot;">devtmpfs /dev devtmp=
fs rw,relatime,size=3D24719668k,nr_inodes=3D6179917,mode=3D755 0 0<u></u><u=
></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Cou=
rier New&quot;">devpts /dev/pts devpts rw,relatime,gid=3D5,mode=3D620,ptmxm=
ode=3D000 0 0<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D=
"font-family:&quot;Courier New&quot;">tmpfs /dev/shm tmpfs rw,relatime 0 0<=
u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&=
quot;Courier New&quot;">/dev/vda3 / ext3 rw,relatime,errors=3Dcontinue,user=
_xattr,acl,barrier=3D1,data=3Dordered 0 0<u></u><u></u></span></p><p class=
=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">proc /rh=
el3/proc proc rw,relatime 0 0<u></u><u></u></span></p><p class=3D"MsoNormal=
"><span style=3D"font-family:&quot;Courier New&quot;">/dev/vda5 /tmp ext3 r=
w,relatime,errors=3Dcontinue,user_xattr,acl,barrier=3D1,data=3Dordered 0 0<=
u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&=
quot;Courier New&quot;">/dev/vda1 /boot ext3 rw,relatime,errors=3Dcontinue,=
user_xattr,acl,barrier=3D1,data=3Dordered 0 0<u></u><u></u></span></p><p cl=
ass=3D"MsoNormal"><b><span style=3D"font-family:&quot;Courier New&quot;">/d=
ev/vdc1 /exports xfs rw,noatime,attr2,inode32,nobarrier,logbsize=3D256k,sun=
it=3D512,swidth=3D11264,noquota 0 0<u></u><u></u></span></b></p><p class=3D=
"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">/dev/vdb1 /=
mnt xfs rw,noatime,attr2,inode32,nobarrier,logbsize=3D256k,sunit=3D512,swid=
th=3D11264,noquota 0 0<u></u><u></u></span></p><p class=3D"MsoNormal"><span=
 style=3D"font-family:&quot;Courier New&quot;">/dev/vdc1 /www xfs rw,noatim=
e,attr2,inode32,nobarrier,logbsize=3D256k,sunit=3D512,swidth=3D11264,noquot=
a 0 0<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">/dev/vdc1 /rhel3/www xfs rw,noatime,attr2,ino=
de32,nobarrier,logbsize=3D256k,sunit=3D512,swidth=3D11264,noquota 0 0<u></u=
><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;=
Courier New&quot;">/dev/vdc1 /chroot xfs rw,noatime,attr2,inode32,nobarrier=
,logbsize=3D256k,sunit=3D512,swidth=3D11264,noquota 0 0<u></u><u></u></span=
></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&qu=
ot;">/dev/vdc1 /home xfs rw,noatime,attr2,inode32,nobarrier,logbsize=3D256k=
,sunit=3D512,swidth=3D11264,noquota 0 0<u></u><u></u></span></p><p class=3D=
"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">/dev/vdc1 /=
nfscommon xfs rw,noatime,attr2,inode32,nobarrier,logbsize=3D256k,sunit=3D51=
2,swidth=3D11264,noquota 0 0<u></u><u></u></span></p><p class=3D"MsoNormal"=
><span style=3D"font-family:&quot;Courier New&quot;">/dev/vdc1 /opt xfs rw,=
noatime,attr2,inode32,nobarrier,logbsize=3D256k,sunit=3D512,swidth=3D11264,=
noquota 0 0<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"f=
ont-family:&quot;Courier New&quot;">/dev/vdc1 /scratch xfs rw,noatime,attr2=
,inode32,nobarrier,logbsize=3D256k,sunit=3D512,swidth=3D11264,noquota 0 0<u=
></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&q=
uot;Courier New&quot;">none /proc/sys/fs/binfmt_misc binfmt_misc rw,relatim=
e 0 0<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">sunrpc /var/lib/nfs/rpc_pipefs rpc_pipefs rw,=
relatime 0 0<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"=
font-family:&quot;Courier New&quot;">nfsd /proc/fs/nfsd nfsd rw,relatime 0 =
0<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family=
:&quot;Courier New&quot;">10.140.110.106:/export/nfs/qa /nfs/qa nfs rw,noat=
ime,nodiratime,vers=3D3,rsize=3D32768,wsize=3D32768,namlen=3D255,hard,nocto=
,noacl,proto=3Dtcp,timeo=3D600,retrans=3D2,sec=3Dsys,mountaddr=3D10.140.110=
.106,mountvers=3D3,mountport=3D36653,mountproto=3Dudp,local_lock=3Dnone,add=
r=3D10.140.110.106 0 0<u></u><u></u></span></p><p class=3D"MsoNormal"><span=
 style=3D"font-family:&quot;Courier New&quot;">10.140.110.106:/export/nfs/i=
nstall /nfs/install nfs rw,noatime,nodiratime,vers=3D3,rsize=3D32768,wsize=
=3D32768,namlen=3D255,hard,nocto,noacl,proto=3Dtcp,timeo=3D600,retrans=3D2,=
sec=3Dsys,mountaddr=3D10.140.110.106,mountvers=3D3,mountport=3D36653,mountp=
roto=3Dudp,local_lock=3Dnone,addr=3D10.140.110.106 0 0<u></u><u></u></span>=
</p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quo=
t;">10.140.110.105:/export/home /nfs/users nfs rw,noatime,nodiratime,vers=
=3D3,rsize=3D32768,wsize=3D32768,namlen=3D255,hard,nocto,noacl,proto=3Dtcp,=
timeo=3D600,retrans=3D2,sec=3Dsys,mountaddr=3D10.140.110.105,mountvers=3D3,=
mountport=3D37692,mountproto=3Dudp,local_lock=3Dnone,addr=3D10.140.110.105 =
0 0<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-fami=
ly:&quot;Courier New&quot;">10.140.110.105:/export/nfs/project /nfs/project=
 nfs rw,noatime,nodiratime,vers=3D3,rsize=3D32768,wsize=3D32768,namlen=3D25=
5,hard,nocto,noacl,proto=3Dtcp,timeo=3D600,retrans=3D2,sec=3Dsys,mountaddr=
=3D10.140.110.105,mountvers=3D3,mountport=3D37692,mountproto=3Dudp,local_lo=
ck=3Dnone,addr=3D10.140.110.105 0 0<u></u><u></u></span></p><p class=3D"Mso=
Normal"><span style=3D"font-family:&quot;Courier New&quot;">10.140.110.105:=
/export/nfs/data /nfs/data nfs rw,noatime,nodiratime,vers=3D3,rsize=3D32768=
,wsize=3D32768,namlen=3D255,hard,nocto,noacl,proto=3Dtcp,timeo=3D600,retran=
s=3D2,sec=3Dsys,mountaddr=3D10.140.110.105,mountvers=3D3,mountport=3D37692,=
mountproto=3Dudp,local_lock=3Dnone,addr=3D10.140.110.105 0 0<u></u><u></u><=
/span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier N=
ew&quot;">none /sys/kernel/debug debugfs rw,relatime 0 0<u></u><u></u></spa=
n></p><p class=3D"MsoNormal"><b><span style=3D"font-family:&quot;Courier Ne=
w&quot;"><u></u>=C2=A0<u></u></span></b></p><p class=3D"MsoNormal"><b><span=
 style=3D"font-family:&quot;Courier New&quot;"><u></u>=C2=A0<u></u></span><=
/b></p><p class=3D"MsoNormal"><b><u><span style=3D"font-family:&quot;Courie=
r New&quot;">VM# cat /proc/partitions <u></u><u></u></span></u></b></p><p c=
lass=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">majo=
r minor=C2=A0 #blocks=C2=A0 name<u></u><u></u></span></p><p class=3D"MsoNor=
mal"><span style=3D"font-family:&quot;Courier New&quot;"><u></u>=C2=A0<u></=
u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courie=
r New&quot;">251=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0=C2=A0 10485760=
0 vda<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">251=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 1=C2=A0=C2=A0=C2=A0=C2=A0 204800 vda1<u></u><u></u></span></p><p class=3D"=
MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">251=C2=A0=C2=
=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A02=C2=A0=C2=A0=C2=A0 2096128 vda2<u></u><u=
></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Cou=
rier New&quot;">251=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 3=C2=A0=C2=A0=
 16595968 vda3<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=
=3D"font-family:&quot;Courier New&quot;">251=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 4=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1 vda4=
<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:=
&quot;Courier New&quot;">251=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 5=C2=
=A0=C2=A0 85958656 vda5<u></u><u></u></span></p><p class=3D"MsoNormal"><spa=
n style=3D"font-family:&quot;Courier New&quot;">251=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 16 6442450944 vdb<u></u><u></u></span></p><p class=3D"MsoNorma=
l"><span style=3D"font-family:&quot;Courier New&quot;">251=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 17 6442434560 vdb1<u></u><u></u></span></p><p class=
=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">251=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 32 6442450944 vdc<u></u><u></u></span></p=
><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;"=
>251=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 33 6442426368 vdc1<u></u><u></u></=
span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier Ne=
w&quot;"><u></u>=C2=A0<u></u></span></p><p class=3D"MsoNormal"><span style=
=3D"font-family:&quot;Courier New&quot;"><u></u>=C2=A0<u></u></span></p><p =
class=3D"MsoNormal"><b><u><span style=3D"font-family:&quot;Courier New&quot=
;">VM# xfs_info /dev/vdc1<u></u><u></u></span></u></b></p><p class=3D"MsoNo=
rmal"><span style=3D"font-family:&quot;Courier New&quot;">meta-data=3D/dev/=
vdc1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 isize=3D256=C2=A0=C2=A0=C2=A0 agcount=3D32, agsize=3D50331456 blk=
s<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family=
:&quot;Courier New&quot;">=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
=3D=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sectsz=3D512=
=C2=A0=C2=A0 attr=3D2, projid32bit=3D1<u></u><u></u></span></p><p class=3D"=
MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 crc=3D0<u></u><u></u></span></p><p class=3D"MsoNor=
mal"><span style=3D"font-family:&quot;Courier New&quot;">data=C2=A0=C2=A0=
=C2=A0=C2=A0 =3D=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 bsize=3D4096=C2=A0=C2=A0 blocks=3D1610606592, imaxpct=3D25<u></u><u></u></=
span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier Ne=
w&quot;">=C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=3D=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sunit=3D64=C2=A0=C2=A0=C2=A0=
=C2=A0 swidth=3D1408 blks<u></u><u></u></span></p><p class=3D"MsoNormal"><s=
pan style=3D"font-family:&quot;Courier New&quot;">naming=C2=A0=C2=A0 =3Dver=
sion 2=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 bsize=3D4096=C2=A0=C2=A0 ascii-ci=3D0<u></u><u></u></span></p><p =
class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">log=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3Dinternal=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bsize=3D4096=C2=A0=C2=
=A0 blocks=3D521728, version=3D2<u></u><u></u></span></p><p class=3D"MsoNor=
mal"><span style=3D"font-family:&quot;Courier New&quot;">=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 sectsz=3D512=C2=A0=C2=A0 sunit=3D64 blks, lazy-count=3D1=
<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:=
&quot;Courier New&quot;">realtime =3Dnone=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 extsz=3D4096=C2=A0=C2=A0 blocks=3D0, rtextents=3D0<u></u><u></u></span></p=
><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;"=
><u></u>=C2=A0<u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-=
family:&quot;Courier New&quot;"><u></u>=C2=A0<u></u></span></p><p class=3D"=
MsoNormal"><b><u><span style=3D"font-family:&quot;Courier New&quot;">VM# io=
stat -x -d -m 5<u></u><u></u></span></u></b></p><p class=3D"MsoNormal"><spa=
n style=3D"font-family:&quot;Courier New&quot;">Linux 3.8.13-55.1.2.el6uek.=
x86_64 (hmswebdv01.int.dv.lan)=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 08/13/20=
15=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 _x86_64_<u></u><u></u></span></p><p class=
=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;"><u></u>=
=C2=A0<u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&=
quot;Courier New&quot;">Device:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 rrqm/s=C2=A0=C2=A0 wrqm/s=C2=A0=C2=A0=C2=A0=C2=A0 r/s=C2=A0=C2=A0=C2=
=A0=C2=A0 w/s=C2=A0=C2=A0=C2=A0 rMB/s=C2=A0=C2=A0=C2=A0 wMB/s avgrq-sz avgq=
u-sz=C2=A0=C2=A0 await=C2=A0 svctm=C2=A0 %util<u></u><u></u></span></p><p c=
lass=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">vda=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 0.13=C2=A0=C2=A0=C2=A0 23.96=C2=A0=C2=A0=C2=A0 4.69=C2=A0=C2=A0=
=C2=A0 9.77=C2=A0=C2=A0=C2=A0=C2=A0 0.08=C2=A0=C2=A0=C2=A0=C2=A0 0.13=C2=A0=
=C2=A0=C2=A0 29.83=C2=A0=C2=A0=C2=A0=C2=A0 0.17=C2=A0=C2=A0 11.64=C2=A0=C2=
=A0 2.64=C2=A0=C2=A0 3.81<u></u><u></u></span></p><p class=3D"MsoNormal"><s=
pan style=3D"font-family:&quot;Courier New&quot;">vda1=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=
=C2=A0=C2=A0 0.01=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=
=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 86.76=C2=
=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 7.73=C2=A0=C2=A0 4.22=C2=A0=C2=
=A0 0.00<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font=
-family:&quot;Courier New&quot;">vda2=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A00.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=
=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=
=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 14.68=C2=A0=C2=A0=C2=A0=C2=
=A0 0.00=C2=A0=C2=A0=C2=A0 2.08=C2=A0=C2=A0 1.81=C2=A0=C2=A0 0.00<u></u><u>=
</u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Cour=
ier New&quot;">vda3=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 0.13=C2=A0=C2=A0=C2=A0 19.58=C2=A0=C2=A0=C2=A0 4.6=
5=C2=A0=C2=A0=C2=A0 8.29=C2=A0=C2=A0=C2=A0=C2=A0 0.08=C2=A0=C2=A0=C2=A0=C2=
=A0 0.11=C2=A0=C2=A0=C2=A0 29.68=C2=A0=C2=A0=C2=A0=C2=A0 0.15=C2=A0=C2=A0 1=
1.36=C2=A0=C2=A0 2.79=C2=A0=C2=A0 3.60<u></u><u></u></span></p><p class=3D"=
MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">vda4=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.=
00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.=
00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=
=A0=C2=A0 7.67=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0 29.50=C2=A0 29.50=
=C2=A0=C2=A0 0.00<u></u><u></u></span></p><p class=3D"MsoNormal"><span styl=
e=3D"font-family:&quot;Courier New&quot;">vda5=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.01=C2=A0=C2=A0=C2=A0=
=C2=A0 4.37=C2=A0=C2=A0=C2=A0 0.04=C2=A0=C2=A0=C2=A0 1.44=C2=A0=C2=A0=C2=A0=
=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.02=C2=A0=C2=A0=C2=A0 32.06=C2=A0=C2=
=A0=C2=A0=C2=A0 0.02=C2=A0=C2=A0 14.22=C2=A0=C2=A0 2.41=C2=A0=C2=A0 0.35<u>=
</u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&qu=
ot;Courier New&quot;">vdb=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=
=A0=C2=A0 36.47=C2=A0=C2=A0=C2=A0 0.13=C2=A0=C2=A0=C2=A0=C2=A0 0.28=C2=A0=
=C2=A0=C2=A0=C2=A0 0.04=C2=A0=C2=A0=C2=A0 17.96=C2=A0=C2=A0=C2=A0=C2=A0 0.1=
1=C2=A0=C2=A0=C2=A0 3.09=C2=A0=C2=A0 2.87=C2=A0 10.50<u></u><u></u></span><=
/p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot=
;">vdb1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0 36.47=C2=A0=C2=
=A0=C2=A0 0.13=C2=A0=C2=A0=C2=A0=C2=A0 0.28=C2=A0=C2=A0=C2=A0=C2=A0 0.04=C2=
=A0=C2=A0=C2=A0 17.96=C2=A0=C2=A0=C2=A0=C2=A0 0.11=C2=A0=C2=A0=C2=A0 3.09=
=C2=A0=C2=A0 2.87=C2=A0 10.50<u></u><u></u></span></p><p class=3D"MsoNormal=
"><span style=3D"font-family:&quot;Courier New&quot;">vdc=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 56.10=C2=A0=C2=
=A0=C2=A0 85.36=C2=A0 447.04=C2=A0 461.48=C2=A0=C2=A0=C2=A0=C2=A0 9.21=C2=
=A0=C2=A0=C2=A0 10.85=C2=A0=C2=A0=C2=A0 45.20=C2=A0=C2=A0=C2=A0=C2=A0 1.29=
=C2=A0=C2=A0=C2=A0 1.42=C2=A0=C2=A0 0.99=C2=A0 89.77<u></u><u></u></span></=
p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;=
">vdc1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 56.10=C2=A0=C2=A0=C2=A0 85.36=C2=A0 447.04=C2=A0 461.48=C2=A0=C2=A0=C2=
=A0=C2=A0 9.21=C2=A0=C2=A0=C2=A0 10.85=C2=A0=C2=A0=C2=A0 45.20=C2=A0=C2=A0=
=C2=A0=C2=A0 1.28=C2=A0=C2=A0=C2=A0 1.42=C2=A0=C2=A0 0.99=C2=A0 89.77<u></u=
><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;=
Courier New&quot;"><u></u>=C2=A0<u></u></span></p><p class=3D"MsoNormal"><s=
pan style=3D"font-family:&quot;Courier New&quot;">Device:=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rrqm/s=C2=A0=C2=A0 wrqm/s=C2=A0=C2=A0=C2=A0=
=C2=A0 r/s=C2=A0=C2=A0=C2=A0=C2=A0 w/s=C2=A0=C2=A0=C2=A0 rMB/s=C2=A0=C2=A0=
=C2=A0 wMB/s avgrq-sz avgqu-sz=C2=A0=C2=A0 await=C2=A0 svctm=C2=A0 %util<u>=
</u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&qu=
ot;Courier New&quot;">vda=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 13.20=C2=A0=C2=
=A0=C2=A0 1.40=C2=A0=C2=A0=C2=A0 3.00=C2=A0=C2=A0=C2=A0=C2=A0 0.01=C2=A0=C2=
=A0=C2=A0=C2=A0 0.06=C2=A0=C2=A0=C2=A0 33.45=C2=A0=C2=A0=C2=A0=C2=A0 0.01=
=C2=A0=C2=A0=C2=A0 2.91=C2=A0=C2=A0 2.32=C2=A0=C2=A0 1.02<u></u><u></u></sp=
an></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&=
quot;">vda1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=
=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0=
.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=
=C2=A0 0.00=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00<u></u><u></u></span></p><p cl=
ass=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">vda2=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=
=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=
=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=
=A0=C2=A0 0.00=C2=A0=C2=A0 0.00<u></u><u></u></span></p><p class=3D"MsoNorm=
al"><span style=3D"font-family:&quot;Courier New&quot;">vda3=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =C2=A00.00=C2=A0=
=C2=A0=C2=A0 10.00=C2=A0=C2=A0=C2=A0 1.40=C2=A0=C2=A0=C2=A0 2.60=C2=A0=C2=
=A0=C2=A0=C2=A0 0.01=C2=A0=C2=A0=C2=A0=C2=A0 0.05=C2=A0=C2=A0=C2=A0 29.60=
=C2=A0=C2=A0=C2=A0=C2=A0 0.01=C2=A0=C2=A0=C2=A0 3.20=C2=A0=C2=A0 2.55=C2=A0=
=C2=A0 1.02<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"f=
ont-family:&quot;Courier New&quot;">vda4=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 =
0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 =
0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=
=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00<=
u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&=
quot;Courier New&quot;">vda5=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 3.20=C2=A0=
=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.40=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=
=C2=A0=C2=A0=C2=A0 0.01=C2=A0=C2=A0=C2=A0 72.00=C2=A0=C2=A0=C2=A0=C2=A0 0.0=
0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00<u></u><u></u></s=
pan></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New=
&quot;">vdb=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0=
.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=
=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=
=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00<u></u><u></u></span></p=
><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;"=
>vdb1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=
=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=
=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0=
.00=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00<u></u><u></u></span></p><p class=3D"M=
soNormal"><span style=3D"font-family:&quot;Courier New&quot;">vdc=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00 1222.80=C2=A0=C2=A0 60.60=C2=A0=C2=A0=C2=
=A0 45.01=C2=A0=C2=A0=C2=A0=C2=A0 5.81=C2=A0=C2=A0=C2=A0 81.10=C2=A0=C2=A0=
=C2=A0=C2=A0 7.49=C2=A0=C2=A0=C2=A0 5.79=C2=A0=C2=A0 0.78 100.00<u></u><u><=
/u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Couri=
er New&quot;">vdc1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00 1222.80=C2=A0=C2=A0=
 60.60=C2=A0=C2=A0=C2=A0 45.01=C2=A0=C2=A0=C2=A0=C2=A0 5.81=C2=A0=C2=A0=C2=
=A0 81.10=C2=A0=C2=A0=C2=A0=C2=A0 7.49=C2=A0=C2=A0=C2=A0 5.79=C2=A0=C2=A0 0=
.78 100.00<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"fo=
nt-family:&quot;Courier New&quot;"><u></u>=C2=A0<u></u></span></p><p class=
=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">Device:=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rrqm/s=C2=A0=C2=A0 wrqm/s=
=C2=A0=C2=A0=C2=A0=C2=A0 r/s=C2=A0=C2=A0 =C2=A0=C2=A0w/s=C2=A0=C2=A0=C2=A0 =
rMB/s=C2=A0=C2=A0=C2=A0 wMB/s avgrq-sz avgqu-sz=C2=A0=C2=A0 await=C2=A0 svc=
tm=C2=A0 %util<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=
=3D"font-family:&quot;Courier New&quot;">vda=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=
=A0 10.20=C2=A0=C2=A0=C2=A0 1.20=C2=A0=C2=A0 17.60=C2=A0=C2=A0=C2=A0=C2=A0 =
0.04=C2=A0=C2=A0=C2=A0=C2=A0 0.11=C2=A0=C2=A0=C2=A0 16.51=C2=A0=C2=A0=C2=A0=
=C2=A0 0.06=C2=A0=C2=A0=C2=A0 2.96=C2=A0=C2=A0 0.66=C2=A0=C2=A0 1.24<u></u>=
<u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;C=
ourier New&quot;">vda1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=
=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=
=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=
=C2=A0=C2=A0 =C2=A00.00=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00<u></u><u></u></sp=
an></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&=
quot;">vda2=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=
=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0=
.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=
=C2=A0 0.00=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00<u></u><u></u></span></p><p cl=
ass=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">vda3=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 9.40=C2=A0=C2=A0=C2=A0 1.20=C2=A0=C2=A0 13=
.20=C2=A0=C2=A0=C2=A0=C2=A0 0.04=C2=A0=C2=A0=C2=A0=C2=A0 0.09=C2=A0=C2=A0=
=C2=A0 18.78=C2=A0=C2=A0=C2=A0=C2=A0 0.05=C2=A0=C2=A0=C2=A0 3.57=C2=A0=C2=
=A0 0.86=C2=A0=C2=A0 1.24<u></u><u></u></span></p><p class=3D"MsoNormal"><s=
pan style=3D"font-family:&quot;Courier New&quot;">vda4=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0 =C2=A0=
=C2=A0=C2=A00.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=
=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=
=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00=C2=A0=
=C2=A0 0.00<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"f=
ont-family:&quot;Courier New&quot;">vda5=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 =
0.80=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 4.20=C2=A0=C2=A0=C2=A0=C2=A0 =
0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.02=C2=A0=C2=A0=C2=A0=C2=A0 9.52=C2=A0=C2=A0=
=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 1.00=C2=A0=C2=A0 0.05=C2=A0=C2=A0 0.02<=
u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&=
quot;Courier New&quot;">vdb=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=
=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=
=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0 =C2=A0=C2=A00.00=C2=A0=C2=A0=C2=A0=
=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00<u></u>=
<u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;C=
ourier New&quot;">vdb1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=
=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=
=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=
=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00<u></u><u></u></sp=
an></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&=
quot;">vdc=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.40=C2=A0 928.00=C2=A0 =
432.40=C2=A0=C2=A0=C2=A0 23.05=C2=A0=C2=A0=C2=A0 13.05=C2=A0=C2=A0=C2=A0 54=
.35=C2=A0=C2=A0=C2=A0=C2=A0 9.65=C2=A0=C2=A0=C2=A0 7.14=C2=A0=C2=A0 0.74 10=
0.00<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-fam=
ily:&quot;Courier New&quot;">vdc1=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A00.00=C2=A0=C2=A0=C2=A0=C2=A0 0.40=C2=
=A0 928.00=C2=A0 432.40=C2=A0=C2=A0=C2=A0 23.05=C2=A0=C2=A0=C2=A0 13.05=C2=
=A0=C2=A0=C2=A0 54.35=C2=A0=C2=A0=C2=A0=C2=A0 9.65=C2=A0=C2=A0=C2=A0 7.14=
=C2=A0=C2=A0 0.74 100.00<u></u><u></u></span></p><p class=3D"MsoNormal"><sp=
an style=3D"font-family:&quot;Courier New&quot;"><u></u>=C2=A0<u></u></span=
></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&qu=
ot;">Device:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rrqm/s=C2=A0=
=C2=A0 wrqm/s=C2=A0=C2=A0=C2=A0=C2=A0 r/s=C2=A0=C2=A0=C2=A0=C2=A0 w/s=C2=A0=
=C2=A0=C2=A0 rMB/s=C2=A0=C2=A0=C2=A0 wMB/s avgrq-sz avgqu-sz=C2=A0=C2=A0 aw=
ait=C2=A0 svctm=C2=A0 %util<u></u><u></u></span></p><p class=3D"MsoNormal">=
<span style=3D"font-family:&quot;Courier New&quot;">vda=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=
=A0=C2=A0=C2=A0=C2=A0 7.60=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 2.40=C2=
=A0 =C2=A0=C2=A0=C2=A00.00=C2=A0=C2=A0=C2=A0=C2=A0 0.04=C2=A0=C2=A0=C2=A0 3=
2.00=C2=A0=C2=A0=C2=A0=C2=A0 0.10=C2=A0=C2=A0 41.67=C2=A0 16.33=C2=A0=C2=A0=
 3.92<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">vda1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=
=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=
=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=
=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00<u><=
/u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quo=
t;Courier New&quot;">vda2=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=
=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=
=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0=
.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0 =C2=A00.00=C2=A0=C2=A0 0.00<u></u><u></u><=
/span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier N=
ew&quot;">vda3=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 7.60=C2=A0=C2=A0=C2=A0 0.00=
=C2=A0=C2=A0=C2=A0 2.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=
=A0 0.04=C2=A0=C2=A0=C2=A0 38.40=C2=A0=C2=A0=C2=A0=C2=A0 0.09=C2=A0=C2=A0 4=
6.60=C2=A0 16.20=C2=A0=C2=A0 3.24<u></u><u></u></span></p><p class=3D"MsoNo=
rmal"><span style=3D"font-family:&quot;Courier New&quot;">vda4=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=
=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=
=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=
=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=
 0.00=C2=A0=C2=A0 0.00<u></u><u></u></span></p><p class=3D"MsoNormal"><span=
 style=3D"font-family:&quot;Courier New&quot;">vda5=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=
=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=
=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=
=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00=C2=A0=C2=
=A0 0.00<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font=
-family:&quot;Courier New&quot;">vdb=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 =
0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 =
0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=
=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00<=
u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&=
quot;Courier New&quot;">vdb1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=
=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=
=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00 =C2=A0=C2=A0=C2=A0=C2=
=A00.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00<u></u><u><=
/u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Couri=
er New&quot;">vdc=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0 293.20=C2=A0 352.20 1753.00=C2=
=A0=C2=A0=C2=A0=C2=A0 8.38=C2=A0=C2=A0=C2=A0 43.34=C2=A0=C2=A0=C2=A0 50.32=
=C2=A0=C2=A0=C2=A0 71.98=C2=A0=C2=A0 33.91=C2=A0=C2=A0 0.48 100.00<u></u><u=
></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Cou=
rier New&quot;">vdc1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0 293.20=C2=A0 352.20 1753.00=C2=A0=
=C2=A0=C2=A0=C2=A0 8.38=C2=A0=C2=A0=C2=A0 43.34=C2=A0=C2=A0=C2=A0 50.32=C2=
=A0=C2=A0=C2=A0 71.98=C2=A0=C2=A0 33.91=C2=A0=C2=A0 0.48 100.00<u></u><u></=
u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courie=
r New&quot;"><u></u>=C2=A0<u></u></span></p><p class=3D"MsoNormal"><span st=
yle=3D"font-family:&quot;Courier New&quot;">Device:=C2=A0=C2=A0=C2=A0=C2=A0=
 =C2=A0=C2=A0=C2=A0=C2=A0rrqm/s=C2=A0=C2=A0 wrqm/s=C2=A0=C2=A0=C2=A0=C2=A0 =
r/s=C2=A0=C2=A0=C2=A0=C2=A0 w/s=C2=A0=C2=A0=C2=A0 rMB/s=C2=A0=C2=A0=C2=A0 w=
MB/s avgrq-sz avgqu-sz=C2=A0=C2=A0 await=C2=A0 svctm=C2=A0 %util<u></u><u><=
/u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Couri=
er New&quot;">vda=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 15.00=C2=A0=C2=A0=C2=A0 =
1.20=C2=A0=C2=A0=C2=A0 6.40=C2=A0=C2=A0=C2=A0=C2=A0 0.04=C2=A0=C2=A0=C2=A0=
=C2=A0 0.08=C2=A0=C2=A0=C2=A0 32.00=C2=A0=C2=A0=C2=A0=C2=A0 0.42=C2=A0=C2=
=A0 55.29=C2=A0 23.24=C2=A0 17.66<u></u><u></u></span></p><p class=3D"MsoNo=
rmal"><span style=3D"font-family:&quot;Courier New&quot;">vda1=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=
=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=
=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=
=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=
 0.00=C2=A0=C2=A0 0.00<u></u><u></u></span></p><p class=3D"MsoNormal"><span=
 style=3D"font-family:&quot;Courier New&quot;">vda2=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=
=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=
=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=
=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00=C2=A0=C2=
=A0 0.00<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font=
-family:&quot;Courier New&quot;">vda3=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 14.40=C2=
=A0=C2=A0=C2=A0 1.20=C2=A0=C2=A0=C2=A0 5.80=C2=A0=C2=A0=C2=A0=C2=A0 0.04=C2=
=A0=C2=A0=C2=A0=C2=A0 0.08=C2=A0=C2=A0=C2=A0 33.60=C2=A0=C2=A0=C2=A0=C2=A0 =
0.39=C2=A0=C2=A0 55.77=C2=A0 20.97=C2=A0 14.68<u></u><u></u></span></p><p c=
lass=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">vda4=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=
=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=
=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=
=A0=C2=A0 0.00=C2=A0=C2=A0 0.00<u></u><u></u></span></p><p class=3D"MsoNorm=
al"><span style=3D"font-family:&quot;Courier New&quot;">vda5=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=
=C2=A0=C2=A0=C2=A0 0.60=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.40=C2=A0=
=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 20.0=
0=C2=A0=C2=A0=C2=A0=C2=A0 0.02=C2=A0=C2=A0 60.50=C2=A0 60.50=C2=A0=C2=A0 2.=
42<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-famil=
y:&quot;Courier New&quot;">vdb=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=
=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=
=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=
=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00<u><=
/u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quo=
t;Courier New&quot;">vdb1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=
=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=
=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0=
.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00<u></u><u></u><=
/span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier N=
ew&quot;">vdc=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 0.20=C2=A0=C2=A0 676.20=C2=A0=C2=A0 20.40 3131.60=
=C2=A0=C2=A0=C2=A0=C2=A0 0.20=C2=A0=C2=A0=C2=A0 26.83=C2=A0=C2=A0=C2=A0 17.=
56=C2=A0=C2=A0 144.45=C2=A0=C2=A0 45.74=C2=A0=C2=A0 0.32 100.00<u></u><u></=
u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courie=
r New&quot;">vdc1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 0.20=C2=A0=C2=A0 676.20=C2=A0=C2=A0 20.40 3131.60=C2=
=A0=C2=A0=C2=A0=C2=A0 0.20=C2=A0=C2=A0=C2=A0 26.83=C2=A0=C2=A0=C2=A0 17.56=
=C2=A0=C2=A0 144.45=C2=A0=C2=A0 45.74=C2=A0=C2=A0 0.32 100.00<u></u><u></u>=
</span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier =
New&quot;"><u></u>=C2=A0<u></u></span></p><p class=3D"MsoNormal"><span styl=
e=3D"font-family:&quot;Courier New&quot;">Device:=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 rrqm/s=C2=A0=C2=A0 wrqm/s=C2=A0=C2=A0=C2=A0=C2=A0 =
r/s=C2=A0=C2=A0=C2=A0=C2=A0 w/s=C2=A0=C2=A0=C2=A0 rMB/s=C2=A0=C2=A0=C2=A0 w=
MB/s avgrq-sz avgqu-sz=C2=A0=C2=A0 await=C2=A0 svctm=C2=A0 %util<u></u><u><=
/u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Couri=
er New&quot;">vda=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 3.60=C2=A0=C2=A0=
=C2=A0 2.80=C2=A0=C2=A0=C2=A0 2.60=C2=A0=C2=A0=C2=A0=C2=A0 0.02=C2=A0=C2=A0=
=C2=A0=C2=A0 0.02=C2=A0=C2=A0=C2=A0 17.78=C2=A0=C2=A0=C2=A0=C2=A0 0.48=C2=
=A0=C2=A0 89.63=C2=A0 52.41=C2=A0 28.30<u></u><u></u></span></p><p class=3D=
"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">vda1=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.=
00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.=
00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=
=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=
=A0 0.00=C2=A0=C2=A0 0.00<u></u><u></u></span></p><p class=3D"MsoNormal"><s=
pan style=3D"font-family:&quot;Courier New&quot;">vda2=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=
=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=
=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=
=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00=C2=A0=
=C2=A0 0.00<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"f=
ont-family:&quot;Courier New&quot;">vda3=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 =
3.60=C2=A0=C2=A0=C2=A0 2.80=C2=A0=C2=A0=C2=A0 2.60=C2=A0=C2=A0=C2=A0=C2=A0 =
0.02=C2=A0=C2=A0=C2=A0=C2=A0 0.02=C2=A0=C2=A0=C2=A0 17.78=C2=A0=C2=A0=C2=A0=
=C2=A0 0.48=C2=A0=C2=A0 89.63=C2=A0 52.41=C2=A0 28.30<u></u><u></u></span><=
/p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot=
;">vda4=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=
=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=
=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=
=A0 0.00=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00<u></u><u></u></span></p><p class=
=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">vda5=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=
 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=
=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=
=C2=A0 0.00=C2=A0=C2=A0 0.00<u></u><u></u></span></p><p class=3D"MsoNormal"=
><span style=3D"font-family:&quot;Courier New&quot;">vdb=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=
=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=
=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=
=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=
 0.00=C2=A0=C2=A0 0.00<u></u><u></u></span></p><p class=3D"MsoNormal"><span=
 style=3D"font-family:&quot;Courier New&quot;">vdb1=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=
=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=
=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=
=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00=C2=A0=C2=
=A0 0.00<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font=
-family:&quot;Courier New&quot;">vdc=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1.40=C2=A0=C2=A0 518.00=C2=A0=
=C2=A0 51.80 3012.00=C2=A0=C2=A0=C2=A0=C2=A0 0.62=C2=A0=C2=A0=C2=A0 25.65=
=C2=A0=C2=A0=C2=A0 17.56=C2=A0=C2=A0 149.01=C2=A0=C2=A0 48.58=C2=A0=C2=A0 0=
.33 100.00<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"fo=
nt-family:&quot;Courier New&quot;">vdc1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1.40=C2=A0=C2=A0 518.00=C2=A0=C2=
=A0 51.80 3012.00=C2=A0=C2=A0=C2=A0=C2=A0 0.62=C2=A0=C2=A0=C2=A0 25.65=C2=
=A0=C2=A0=C2=A0 17.56=C2=A0=C2=A0 149.01=C2=A0=C2=A0 48.58=C2=A0=C2=A0 0.33=
 100.00<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-=
family:&quot;Courier New&quot;"><u></u>=C2=A0<u></u></span></p><p class=3D"=
MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">Device:=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rrqm/s=C2=A0=C2=A0 wrqm/s=C2=
=A0=C2=A0=C2=A0=C2=A0 r/s=C2=A0=C2=A0=C2=A0=C2=A0 w/s=C2=A0=C2=A0=C2=A0 rMB=
/s=C2=A0=C2=A0=C2=A0 wMB/s avgrq-sz avgqu-sz=C2=A0=C2=A0 await=C2=A0 svctm=
=C2=A0 %util<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"=
font-family:&quot;Courier New&quot;">vda=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=
=C2=A0 2.60=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 2.20=C2=A0=C2=A0=C2=A0=
=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.02=C2=A0=C2=A0=C2=A0 16.73=C2=A0=C2=
=A0=C2=A0=C2=A0 0.05=C2=A0=C2=A0 22.73=C2=A0 19.91=C2=A0=C2=A0 4.38<u></u><=
u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Co=
urier New&quot;">vda1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 =C2=A00.00=C2=A0=C2=A0=C2=
=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=
=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=
=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00<u></u><u></u></span>=
</p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quo=
t;">vda2=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=
=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=
=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=
=A0 0.00=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00<u></u><u></u></span></p><p class=
=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">vda3=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 0.00=C2=A0=C2=A0=C2=A0=C2=A0 2.60=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=
 2.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.02=C2=A0=C2=A0=
=C2=A0 18.40=C2=A0=C2=A0=C2=A0=C2=A0 0.02=C2=A0=C2=A0=C2=A0 9.60=C2=A0=C2=
=A0 6.50=C2=A0=C2=A0 1.30<u></u><u></u></span></p><p class=3D"MsoNormal"><s=
pan style=3D"font-family:&quot;Courier New&quot;">vda4=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=
=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=
=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=
=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00=C2=A0=
=C2=A0 0.00<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"f=
ont-family:&quot;Courier New&quot;">vda5=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 =
0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 =
0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=
=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00<=
u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&=
quot;Courier New&quot;">vdb=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A00.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=
=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=
=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=
=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00<u></u>=
<u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;C=
ourier New&quot;">vdb1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=
=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=
=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=
=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00<u></u><u></u></sp=
an></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&=
quot;">vdc=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 3.40=C2=A0=C2=A0=C2=A0 62.00=C2=A0=C2=A0 65.40 1936.2=
0=C2=A0=C2=A0=C2=A0 =C2=A01.84=C2=A0=C2=A0=C2=A0=C2=A0 9.35=C2=A0=C2=A0=C2=
=A0 11.45=C2=A0=C2=A0 153.92=C2=A0=C2=A0 76.42=C2=A0=C2=A0 0.50 100.00<u></=
u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot=
;Courier New&quot;">vdc1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 3.40=C2=A0=C2=A0=C2=A0 62.00=C2=A0=C2=A0 65.40 =
1936.20=C2=A0=C2=A0=C2=A0=C2=A0 1.84=C2=A0=C2=A0=C2=A0=C2=A0 9.35=C2=A0=C2=
=A0=C2=A0 11.45=C2=A0=C2=A0 153.92=C2=A0=C2=A0 76.42=C2=A0=C2=A0 0.50 100.0=
0<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family=
:&quot;Courier New&quot;"><u></u>=C2=A0<u></u></span></p><p class=3D"MsoNor=
mal"><span style=3D"font-family:&quot;Courier New&quot;">Device:=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rrqm/s=C2=A0=C2=A0 wrqm/s=C2=A0=C2=
=A0=C2=A0=C2=A0 r/s=C2=A0=C2=A0=C2=A0=C2=A0 w/s=C2=A0=C2=A0=C2=A0 rMB/s=C2=
=A0=C2=A0=C2=A0 wMB/s avgrq-sz avgqu-sz=C2=A0=C2=A0 await=C2=A0 svctm=C2=A0=
 %util<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-f=
amily:&quot;Courier New&quot;">vda=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 =
3.80=C2=A0=C2=A0=C2=A0 0.20=C2=A0=C2=A0=C2=A0 2.80=C2=A0=C2=A0=C2=A0=C2=A0 =
0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.02=C2=A0=C2=A0=C2=A0 17.07=C2=A0=C2=A0=C2=A0=
=C2=A0 0.17=C2=A0=C2=A0 55.47=C2=A0 30.87=C2=A0=C2=A0 9.26<u></u><u></u></s=
pan></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New=
&quot;">vda1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=
=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0=
.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=
=C2=A0 0.00=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00<u></u><u></u></span></p><p cl=
ass=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">vda2=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00 =C2=A0=C2=A0=C2=A00.00=C2=A0=C2=A0=C2=
=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=
=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=
=A0=C2=A0 0.00=C2=A0=C2=A0 0.00<u></u><u></u></span></p><p class=3D"MsoNorm=
al"><span style=3D"font-family:&quot;Courier New&quot;">vda3=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=
=C2=A0=C2=A0=C2=A0 3.80=C2=A0=C2=A0=C2=A0 0.20=C2=A0=C2=A0=C2=A0 2.40=C2=A0=
=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.02=C2=A0=C2=A0=C2=A0 19.6=
9=C2=A0=C2=A0=C2=A0=C2=A0 0.15=C2=A0=C2=A0 58.69=C2=A0 30.31=C2=A0=C2=A0 7.=
88<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-famil=
y:&quot;Courier New&quot;">vda4=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=
=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=
=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0 =C2=A0=C2=A0=
=C2=A00.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00<u></u><=
u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Co=
urier New&quot;">vda5=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=
=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=
=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=
=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00<u></u><u></u></span>=
</p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quo=
t;">vdb=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=
=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=
=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=
=A0=C2=A0 0.00=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00<u></u><u></u></span></p><p=
 class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">vd=
b1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=
=C2=A00.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=
=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=
=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=
=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00<u></u><u></u></span></p><p class=3D"MsoN=
ormal"><span style=3D"font-family:&quot;Courier New&quot;">vdc=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1.=
00=C2=A0=C2=A0 224.20=C2=A0 379.20 1752.60=C2=A0=C2=A0=C2=A0=C2=A0 5.32=C2=
=A0=C2=A0=C2=A0 14.94=C2=A0=C2=A0=C2=A0 19.46=C2=A0=C2=A0 100.70=C2=A0=C2=
=A0 47.71=C2=A0=C2=A0 0.47 100.00<u></u><u></u></span></p><p class=3D"MsoNo=
rmal"><span style=3D"font-family:&quot;Courier New&quot;">vdc1=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1.00=C2=
=A0=C2=A0 224.20=C2=A0 379.20 1752.60=C2=A0=C2=A0=C2=A0=C2=A0 5.32=C2=A0 =
=C2=A0=C2=A014.94=C2=A0=C2=A0=C2=A0 19.46=C2=A0=C2=A0 100.70=C2=A0=C2=A0 47=
.71=C2=A0=C2=A0 0.47 100.00<u></u><u></u></span></p><p class=3D"MsoNormal">=
<span style=3D"font-family:&quot;Courier New&quot;"><u></u>=C2=A0<u></u></s=
pan></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New=
&quot;">Device:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rrqm/s=C2=
=A0=C2=A0 wrqm/s=C2=A0=C2=A0=C2=A0=C2=A0 r/s=C2=A0=C2=A0=C2=A0=C2=A0 w/s=C2=
=A0=C2=A0=C2=A0 rMB/s=C2=A0=C2=A0=C2=A0 wMB/s avgrq-sz avgqu-sz=C2=A0=C2=A0=
 await=C2=A0 svctm=C2=A0 %util<u></u><u></u></span></p><p class=3D"MsoNorma=
l"><span style=3D"font-family:&quot;Courier New&quot;">vda=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=
=C2=A0=C2=A0=C2=A0 15.00=C2=A0=C2=A0=C2=A0 3.20=C2=A0=C2=A0=C2=A0 7.00=C2=
=A0=C2=A0=C2=A0=C2=A0 0.04=C2=A0=C2=A0=C2=A0=C2=A0 0.09=C2=A0=C2=A0=C2=A0 2=
5.25=C2=A0=C2=A0=C2=A0=C2=A0 0.04=C2=A0=C2=A0=C2=A0 4.29=C2=A0=C2=A0 2.49=
=C2=A0=C2=A0 2.54<u></u><u></u></span></p><p class=3D"MsoNormal"><span styl=
e=3D"font-family:&quot;Courier New&quot;">vda1=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=
=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=
=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=
=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00=C2=A0=C2=A0=
 0.00<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">vda2=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=
=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=
=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=
=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00<u><=
/u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quo=
t;Courier New&quot;">vda3=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 15.00=C2=A0=C2=A0=C2=
=A0 3.20=C2=A0=C2=A0=C2=A0 6.80=C2=A0=C2=A0=C2=A0=C2=A0 0.04=C2=A0=C2=A0=C2=
=A0=C2=A0 0.09=C2=A0=C2=A0=C2=A0 25.76=C2=A0=C2=A0=C2=A0=C2=A0 0.04=C2=A0=
=C2=A0=C2=A0 4.38=C2=A0=C2=A0 2.54=C2=A0=C2=A0 2.54<u></u><u></u></span></p=
><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;"=
>vda4=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=
=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=
=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0=
.00=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00<u></u><u></u></span></p><p class=3D"M=
soNormal"><span style=3D"font-family:&quot;Courier New&quot;">vda5=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=
=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=
=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=
=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=
=A0 0.00=C2=A0=C2=A0 0.00<u></u><u></u></span></p><p class=3D"MsoNormal"><s=
pan style=3D"font-family:&quot;Courier New&quot;">vdb=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=
=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=
=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=
=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.=
00=C2=A0=C2=A0 0.00<u></u><u></u></span></p><p class=3D"MsoNormal"><span st=
yle=3D"font-family:&quot;Courier New&quot;">vdb1=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=
=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=
=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=
=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00=C2=A0=C2=A0=
 0.00<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">vdc=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.40=C2=A0=C2=A0=C2=A0 45.00=C2=
=A0 390.60 1060.60=C2=A0=C2=A0=C2=A0=C2=A0 8.16=C2=A0=C2=A0=C2=A0=C2=A0 8.6=
1=C2=A0=C2=A0=C2=A0 23.66=C2=A0=C2=A0=C2=A0 80.59=C2=A0=C2=A0 56.24=C2=A0=
=C2=A0 0.68=C2=A0 99.20<u></u><u></u></span></p><p class=3D"MsoNormal"><spa=
n style=3D"font-family:&quot;Courier New&quot;">vdc1=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.40=C2=A0=C2=A0=
=C2=A0 45.00=C2=A0 390.60 1060.60=C2=A0=C2=A0=C2=A0=C2=A0 8.16=C2=A0=C2=A0=
=C2=A0=C2=A0 8.61=C2=A0=C2=A0=C2=A0 23.66=C2=A0=C2=A0=C2=A0 80.59=C2=A0=C2=
=A0 56.24=C2=A0=C2=A0 0.68=C2=A0 99.20<u></u><u></u></span></p><p class=3D"=
MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;"><u></u>=C2=
=A0<u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quo=
t;Courier New&quot;">Device:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 rrqm/s=C2=A0=C2=A0 wrqm/s=C2=A0=C2=A0=C2=A0=C2=A0 r/s=C2=A0=C2=A0=C2=A0=
=C2=A0 w/s=C2=A0=C2=A0=C2=A0 rMB/s=C2=A0=C2=A0=C2=A0 wMB/s avgrq-sz avgqu-s=
z=C2=A0=C2=A0 await=C2=A0 svctm=C2=A0 %util<u></u><u></u></span></p><p clas=
s=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">vda=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 0.00=C2=A0=C2=A0=C2=A0 91.40=C2=A0=C2=A0=C2=A0 3.00=C2=A0=C2=A0 48.2=
0=C2=A0=C2=A0=C2=A0=C2=A0 0.03=C2=A0=C2=A0=C2=A0=C2=A0 0.55=C2=A0=C2=A0=C2=
=A0 23.00=C2=A0=C2=A0=C2=A0=C2=A0 0.11=C2=A0=C2=A0=C2=A0 2.20=C2=A0=C2=A0 0=
.33=C2=A0=C2=A0 1.70<u></u><u></u></span></p><p class=3D"MsoNormal"><span s=
tyle=3D"font-family:&quot;Courier New&quot;">vda1=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=
=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=
=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=
=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00=C2=A0=C2=
=A0 0.00<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font=
-family:&quot;Courier New&quot;">vda2=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.0=
0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.0=
0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=
=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00<u><=
/u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quo=
t;Courier New&quot;">vda3=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 66.00=C2=A0=C2=A0=C2=
=A0 3.00=C2=A0=C2=A0 38.40=C2=A0=C2=A0=C2=A0=C2=A0 0.03=C2=A0=C2=A0=C2=A0=
=C2=A0 0.41=C2=A0=C2=A0=C2=A0 21.64=C2=A0=C2=A0=C2=A0=C2=A0 0.10=C2=A0=C2=
=A0=C2=A0 2.34=C2=A0=C2=A0 0.41=C2=A0=C2=A0 1.68<u></u><u></u></span></p><p=
 class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">vd=
a4=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=
=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=
=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=
=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00<u></u><u></u></span></p><p class=3D"MsoN=
ormal"><span style=3D"font-family:&quot;Courier New&quot;">vda5=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=
=A0=C2=A0=C2=A0 25.40=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 9.80=C2=A0=
=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.14=C2=A0=C2=A0=C2=A0 28.7=
3=C2=A0=C2=A0=C2=A0=C2=A0 0.02=C2=A0=C2=A0=C2=A0 1.61=C2=A0=C2=A0 0.08=C2=
=A0=C2=A0 0.08<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=
=3D"font-family:&quot;Courier New&quot;">vdb=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=
=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=
=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=
=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00=C2=A0=C2=
=A0 0.00<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font=
-family:&quot;Courier New&quot;">vdb1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.0=
0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.0=
0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=
=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00<u><=
/u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quo=
t;Courier New&quot;">vdc=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.20=C2=A0 8=
63.60=C2=A0 191.60=C2=A0=C2=A0=C2=A0 30.72=C2=A0=C2=A0=C2=A0 13.77=C2=A0=C2=
=A0=C2=A0 86.35=C2=A0=C2=A0=C2=A0=C2=A0 6.17=C2=A0=C2=A0=C2=A0 5.85=C2=A0=
=C2=A0 0.95=C2=A0 99.86<u></u><u></u></span></p><p class=3D"MsoNormal"><spa=
n style=3D"font-family:&quot;Courier New&quot;">vdc1=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0 =
=C2=A0=C2=A00.20=C2=A0 863.60=C2=A0 191.60=C2=A0=C2=A0=C2=A0 30.72=C2=A0=C2=
=A0=C2=A0 13.77=C2=A0=C2=A0=C2=A0 86.35=C2=A0=C2=A0=C2=A0=C2=A0 6.17=C2=A0=
=C2=A0=C2=A0 5.85=C2=A0=C2=A0 0.95=C2=A0 99.86<u></u><u></u></span></p><p c=
lass=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;"><u><=
/u>=C2=A0<u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-famil=
y:&quot;Courier New&quot;">Device:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 rrqm/s=C2=A0=C2=A0 wrqm/s=C2=A0=C2=A0=C2=A0=C2=A0 r/s=C2=A0=C2=A0=
=C2=A0=C2=A0 w/s=C2=A0=C2=A0=C2=A0 rMB/s=C2=A0=C2=A0=C2=A0 wMB/s avgrq-sz a=
vgqu-sz=C2=A0=C2=A0 await=C2=A0 svctm=C2=A0 %util<u></u><u></u></span></p><=
p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">v=
da=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 32.20=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=
=A0 13.80=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.18=C2=A0=
=C2=A0 =C2=A026.55=C2=A0=C2=A0=C2=A0=C2=A0 1.20=C2=A0=C2=A0 86.84=C2=A0=C2=
=A0 6.93=C2=A0=C2=A0 9.56<u></u><u></u></span></p><p class=3D"MsoNormal"><s=
pan style=3D"font-family:&quot;Courier New&quot;">vda1=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=
=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=
=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=
=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00=C2=A0=
=C2=A0 0.00<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"f=
ont-family:&quot;Courier New&quot;">vda2=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 =
0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 =
0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=
=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00<=
u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&=
quot;Courier New&quot;">vda3=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A00.00=C2=A0=C2=A0=C2=A0 32.20=C2=A0=C2=A0=
=C2=A0 0.00=C2=A0=C2=A0 13.60=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=
=A0=C2=A0 0.18=C2=A0=C2=A0=C2=A0 26.94=C2=A0=C2=A0=C2=A0=C2=A0 1.20=C2=A0=
=C2=A0 88.10=C2=A0=C2=A0 7.01=C2=A0=C2=A0 9.54<u></u><u></u></span></p><p c=
lass=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">vda4=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=
=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=
=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=
=A0=C2=A0 0.00=C2=A0=C2=A0 0.00<u></u><u></u></span></p><p class=3D"MsoNorm=
al"><span style=3D"font-family:&quot;Courier New&quot;">vda5=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=
=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=
=C2=A0 =C2=A0=C2=A00.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=
=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.=
00=C2=A0=C2=A0 0.00<u></u><u></u></span></p><p class=3D"MsoNormal"><span st=
yle=3D"font-family:&quot;Courier New&quot;">vdb=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=
=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=
=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=
=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00=C2=A0=
=C2=A0 0.00<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"f=
ont-family:&quot;Courier New&quot;">vdb1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 =
0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 =
0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=
=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00<=
u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&=
quot;Courier New&quot;">vdc=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.60=C2=
=A0 791.00=C2=A0 359.00=C2=A0=C2=A0=C2=A0 16.53=C2=A0=C2=A0=C2=A0 36.44=C2=
=A0=C2=A0=C2=A0 94.34=C2=A0=C2=A0=C2=A0 25.17=C2=A0=C2=A0 21.87=C2=A0=C2=A0=
 0.87 100.00<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"=
font-family:&quot;Courier New&quot;">vdc1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 =
0.60=C2=A0 791.00=C2=A0 359.00=C2=A0=C2=A0=C2=A0 16.53=C2=A0=C2=A0=C2=A0 36=
.44=C2=A0=C2=A0=C2=A0 94.34=C2=A0=C2=A0=C2=A0 25.17=C2=A0=C2=A0 21.87=C2=A0=
=C2=A0 0.87 100.00<u></u><u></u></span></p><p class=3D"MsoNormal"><span sty=
le=3D"font-family:&quot;Courier New&quot;"><u></u>=C2=A0<u></u></span></p><=
p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">D=
evice:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rrqm/s=C2=A0=C2=A0 w=
rqm/s=C2=A0=C2=A0=C2=A0=C2=A0 r/s=C2=A0=C2=A0=C2=A0=C2=A0 w/s=C2=A0=C2=A0=
=C2=A0 rMB/s=C2=A0=C2=A0=C2=A0 wMB/s avgrq-sz avgqu-sz=C2=A0=C2=A0 await=C2=
=A0 svctm=C2=A0 %util<u></u><u></u></span></p><p class=3D"MsoNormal"><span =
style=3D"font-family:&quot;Courier New&quot;">vda=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=
=A0=C2=A0 16.80=C2=A0=C2=A0=C2=A0 0.80=C2=A0=C2=A0 23.00=C2=A0=C2=A0=C2=A0=
=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.15=C2=A0=C2=A0=C2=A0 13.58=C2=A0=C2=
=A0=C2=A0=C2=A0 0.03=C2=A0=C2=A0=C2=A0 1.08=C2=A0=C2=A0 0.24=C2=A0=C2=A0 0.=
58<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-famil=
y:&quot;Courier New&quot;">vda1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=
=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=
=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00 =C2=A0=C2=A0=C2=A0=
=C2=A00.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00<u></u><=
u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Co=
urier New&quot;">vda2=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=
=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=
=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=
=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00<u></u><u></u></span>=
</p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quo=
t;">vda3=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 11.00=C2=A0=C2=A0=C2=A0 0.80=C2=A0=C2=
=A0 17.20=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.11=C2=A0=
=C2=A0=C2=A0 12.98=C2=A0=C2=A0=C2=A0=C2=A0 0.02=C2=A0=C2=A0=C2=A0 1.26=C2=
=A0=C2=A0 0.31=C2=A0=C2=A0 0.56<u></u><u></u></span></p><p class=3D"MsoNorm=
al"><span style=3D"font-family:&quot;Courier New&quot;">vda4=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A00.00=C2=A0=
=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=
=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=
=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.=
00=C2=A0=C2=A0 0.00<u></u><u></u></span></p><p class=3D"MsoNormal"><span st=
yle=3D"font-family:&quot;Courier New&quot;">vda5=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=
=C2=A0 5.80=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 5.40=C2=A0=C2=A0=C2=A0=
=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.04=C2=A0=C2=A0=C2=A0 16.59=C2=A0=C2=
=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.59=C2=A0=C2=A0 0.07=C2=A0=C2=A0 0.=
04<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-famil=
y:&quot;Courier New&quot;">vdb=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=
=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=
 =C2=A0=C2=A0=C2=A0=C2=A00.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=
=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00<u><=
/u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quo=
t;Courier New&quot;">vdb1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=
=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=
=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0=
.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00<u></u><u></u><=
/span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier N=
ew&quot;">vdc=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00 1143.40=C2=A0=C2=
=A0 12.40=C2=A0=C2=A0=C2=A0 40.78=C2=A0=C2=A0=C2=A0=C2=A0 3.05=C2=A0=C2=A0=
=C2=A0 77.67=C2=A0=C2=A0=C2=A0=C2=A0 6.23=C2=A0=C2=A0=C2=A0 5.39=C2=A0=C2=
=A0 0.87 100.02<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=
=3D"font-family:&quot;Courier New&quot;">vdc1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=C2=
=A0 0.00 1143.40=C2=A0=C2=A0 12.40=C2=A0=C2=A0=C2=A0 40.78=C2=A0=C2=A0=C2=
=A0=C2=A0 3.05=C2=A0=C2=A0=C2=A0 77.67=C2=A0=C2=A0=C2=A0=C2=A0 6.23=C2=A0=
=C2=A0=C2=A0 5.39=C2=A0=C2=A0 0.87 100.02<u></u><u></u></span></p><p class=
=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;"><u></u>=
=C2=A0<u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&=
quot;Courier New&quot;"><u></u>=C2=A0<u></u></span></p><p class=3D"MsoNorma=
l"><b><u><span style=3D"font-family:&quot;Courier New&quot;">VM# vmstat 5 1=
2 <u></u><u></u></span></u></b></p><p class=3D"MsoNormal"><span style=3D"fo=
nt-family:&quot;Courier New&quot;">procs -----------memory---------- ---swa=
p-- -----io---- --system-- -----cpu-----<u></u><u></u></span></p><p class=
=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">r=C2=A0 =
b=C2=A0=C2=A0 swpd=C2=A0=C2=A0 free=C2=A0=C2=A0 buff=C2=A0 cache=C2=A0=C2=
=A0 si=C2=A0=C2=A0 so=C2=A0=C2=A0=C2=A0 bi=C2=A0=C2=A0=C2=A0 bo=C2=A0=C2=A0=
 in=C2=A0=C2=A0 cs us sy id wa st<u></u><u></u></span></p><p class=3D"MsoNo=
rmal"><span style=3D"font-family:&quot;Courier New&quot;">6=C2=A0 3=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 0 1022148=C2=A0 77808 16266636=C2=A0=C2=A0=C2=A0 0=
=C2=A0=C2=A0=C2=A0 0=C2=A0=C2=A0 618=C2=A0=C2=A0 712=C2=A0=C2=A0=C2=A0 0=C2=
=A0=C2=A0=C2=A0 0=C2=A0 4 10 80=C2=A0 6=C2=A0 0<u></u><u></u></span></p><p =
class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">4=
=C2=A0 1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0 1086272=C2=A0 77384 16232348=C2=A0=
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0 0 24294 39514 19557 15659=C2=A0 2 24 54 20=
=C2=A0 0<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font=
-family:&quot;Courier New&quot;">0=C2=A0 4=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0 =
1079320=C2=A0 77324 16239100=C2=A0=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0 0=C2=A0 =
4667 25202 8772 11317=C2=A0 1=C2=A0 5 74 20=C2=A0 0<u></u><u></u></span></p=
><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;"=
>3=C2=A0 3=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0 1094136=C2=A0 77308 16234064=C2=
=A0=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0 0=C2=A0 1102 27323 8101 12963=C2=A0 3=
=C2=A0 4 79 14=C2=A0 0<u></u><u></u></span></p><p class=3D"MsoNormal"><span=
 style=3D"font-family:&quot;Courier New&quot;">5 10=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 0 1178908=C2=A0 77296 16156332=C2=A0=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=
 0=C2=A0 1370 18625 9776 11009=C2=A0 1=C2=A0 8 64 27=C2=A0 0<u></u><u></u><=
/span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier N=
ew&quot;">4=C2=A0 5=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0 1387024=C2=A0 77020 159=
91676=C2=A0=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0 0 10094=C2=A0 3260 19037 14185=
=C2=A0 1 23 61 14=C2=A0 0<u></u><u></u></span></p><p class=3D"MsoNormal"><s=
pan style=3D"font-family:&quot;Courier New&quot;">4=C2=A0 3=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 0 1300224=C2=A0 77028 15920712=C2=A0=C2=A0=C2=A0 0=C2=A0=C2=
=A0=C2=A0 0=C2=A0 3219 20062 17265 14902=C2=A0 7 18 63 12=C2=A0 0<u></u><u>=
</u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Cour=
ier New&quot;">1 11=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0 1522772=C2=A0 77064 157=
96712=C2=A0=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0 0=C2=A0 1095 23720 13740 15666=
=C2=A0 7 11 50 32=C2=A0 0<u></u><u></u></span></p><p class=3D"MsoNormal"><s=
pan style=3D"font-family:&quot;Courier New&quot;">6=C2=A0 1=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 0 1557288=C2=A0 77172 15810492=C2=A0=C2=A0=C2=A0 0=C2=A0=C2=
=A0=C2=A0 0=C2=A0 4626 31199 16900 14040=C2=A0 6 18 53 23=C2=A0 0<u></u><u>=
</u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Cour=
ier New&quot;">5=C2=A0 2=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0 1529284=C2=A0 7720=
4 15850112=C2=A0=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0 0=C2=A0 9396=C2=A0 6547 17=
183 13949=C2=A0 2 21 57 20=C2=A0 0<u></u><u></u></span></p><p class=3D"MsoN=
ormal"><span style=3D"font-family:&quot;Courier New&quot;">3=C2=A0 1=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 0 1480028=C2=A0 77212 15881516=C2=A0=C2=A0=C2=A0 0=
=C2=A0=C2=A0=C2=A0 0 10033=C2=A0 3002 20339 14766=C2=A0 1 26 64=C2=A0 9=C2=
=A0 0<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">6=C2=A0 2=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0 144=
7844=C2=A0 77228 15915300=C2=A0=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0 0 10855=C2=
=A0 4226 19170 14180=C2=A0 3 23 65=C2=A0 9=C2=A0 0<u></u><u></u></span></p>=
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
<u></u>=C2=A0<u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-f=
amily:&quot;Courier New&quot;"><u></u>=C2=A0<u></u></span></p><p class=3D"M=
soNormal"><b><u><span style=3D"font-family:&quot;Courier New&quot;">HV# /op=
t/MegaRAID/MegaCli/MegaCli64=C2=A0 -LdPdInfo -a0 <u></u><u></u></span></u><=
/b></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&=
quot;">=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:=
&quot;Courier New&quot;">Adapter #0<u></u><u></u></span></p><p class=3D"Mso=
Normal"><span style=3D"font-family:&quot;Courier New&quot;"><u></u>=C2=A0<u=
></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Cou=
rier New&quot;">Number of Virtual Disks: 2<u></u><u></u></span></p><p class=
=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">Virtual =
Drive: 0 (Target Id: 0)<u></u><u></u></span></p><p class=3D"MsoNormal"><spa=
n style=3D"font-family:&quot;Courier New&quot;">Name=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 :<u><=
/u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quo=
t;Courier New&quot;">RAID Level=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 : Primary-6, Secondary-0, RAID Level Qualifier-3<u></u><u></u>=
</span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier =
New&quot;">Size=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 45.998 GB<u></u><u></u></span></p><p class=
=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">Parity S=
ize=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 4.181 GB<u></u><u></u=
></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier=
 New&quot;">State=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 : Optimal<u></u><u></u></span></p><p class=3D"M=
soNormal"><span style=3D"font-family:&quot;Courier New&quot;">Strip Size=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 256 KB<u></u><u></u><=
/span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier N=
ew&quot;">Number Of Drives=C2=A0=C2=A0=C2=A0 : 24<u></u><u></u></span></p><=
p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">S=
pan Depth=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 1<u></u><=
u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Co=
urier New&quot;">Default Cache Policy: WriteBack, ReadAhead, Direct, No Wri=
te Cache if Bad BBU<u></u><u></u></span></p><p class=3D"MsoNormal"><span st=
yle=3D"font-family:&quot;Courier New&quot;">Current Cache Policy: WriteBack=
, ReadAhead, Direct, No Write Cache if Bad BBU<u></u><u></u></span></p><p c=
lass=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">Defa=
ult Access Policy: Read/Write<u></u><u></u></span></p><p class=3D"MsoNormal=
"><span style=3D"font-family:&quot;Courier New&quot;">Current Access Policy=
: Read/Write<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"=
font-family:&quot;Courier New&quot;">Disk Cache Policy=C2=A0=C2=A0 : Disabl=
ed<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-famil=
y:&quot;Courier New&quot;">Encryption Type=C2=A0=C2=A0=C2=A0=C2=A0 : None<u=
></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&q=
uot;Courier New&quot;">Is VD Cached: No<u></u><u></u></span></p><p class=3D=
"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">Number of S=
pans: 1<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-=
family:&quot;Courier New&quot;">Span: 0 - Number of PDs: 24<u></u><u></u></=
span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier Ne=
w&quot;"><u></u>=C2=A0<u></u></span></p><p class=3D"MsoNormal"><span style=
=3D"font-family:&quot;Courier New&quot;">PD: 0 Information<u></u><u></u></s=
pan></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New=
&quot;">Enclosure Device ID: 34<u></u><u></u></span></p><p class=3D"MsoNorm=
al"><span style=3D"font-family:&quot;Courier New&quot;">Slot Number: 0<u></=
u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot=
;Courier New&quot;">Drive&#39;s postion: DiskGroup: 0, Span: 0, Arm: 0<u></=
u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot=
;Courier New&quot;">Enclosure position: 0<u></u><u></u></span></p><p class=
=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">Device I=
d: 35<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">WWN: 5000CCA01D350CC3<u></u><u></u></span></p=
><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;"=
>Sequence Number: 2<u></u><u></u></span></p><p class=3D"MsoNormal"><span st=
yle=3D"font-family:&quot;Courier New&quot;">Media Error Count: 0<u></u><u><=
/u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Couri=
er New&quot;">Other Error Count: 0<u></u><u></u></span></p><p class=3D"MsoN=
ormal"><span style=3D"font-family:&quot;Courier New&quot;">Predictive Failu=
re Count: 0<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"f=
ont-family:&quot;Courier New&quot;">Last Predictive Failure Event Seq Numbe=
r: 0<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-fam=
ily:&quot;Courier New&quot;">PD Type: SAS<u></u><u></u></span></p><p class=
=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">Raw Size=
: 1.090 TB [0x8bba0cb0 Sectors]<u></u><u></u></span></p><p class=3D"MsoNorm=
al"><span style=3D"font-family:&quot;Courier New&quot;">Non Coerced Size: 1=
.090 TB [0x8baa0cb0 Sectors]<u></u><u></u></span></p><p class=3D"MsoNormal"=
><span style=3D"font-family:&quot;Courier New&quot;">Coerced Size: 1.089 TB=
 [0x8b94f800 Sectors]<u></u><u></u></span></p><p class=3D"MsoNormal"><span =
style=3D"font-family:&quot;Courier New&quot;">Firmware state: Online, Spun =
Up<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-famil=
y:&quot;Courier New&quot;">Is Commissioned Spare : NO<u></u><u></u></span><=
/p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot=
;">Device Firmware Level: A600<u></u><u></u></span></p><p class=3D"MsoNorma=
l"><span style=3D"font-family:&quot;Courier New&quot;">Shield Counter: 0<u>=
</u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&qu=
ot;Courier New&quot;">Successful diagnostics completion on :=C2=A0 N/A<u></=
u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot=
;Courier New&quot;">SAS Address(0): 0x5000cca01d350cc1<u></u><u></u></span>=
</p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quo=
t;">SAS Address(1): 0x0<u></u><u></u></span></p><p class=3D"MsoNormal"><spa=
n style=3D"font-family:&quot;Courier New&quot;">Connected Port Number: 0(pa=
th0) <u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">Inquiry Data: HGST=C2=A0=C2=A0=C2=A0 H101212S=
ESUN1.2TA6001404DY5EPE=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 <u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-fam=
ily:&quot;Courier New&quot;">FDE Enable: Disable<u></u><u></u></span></p><p=
 class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">Se=
cured: Unsecured<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=
=3D"font-family:&quot;Courier New&quot;">Locked: Unlocked<u></u><u></u></sp=
an></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&=
quot;">Needs EKM Attention: No<u></u><u></u></span></p><p class=3D"MsoNorma=
l"><span style=3D"font-family:&quot;Courier New&quot;">Foreign State: None =
<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:=
&quot;Courier New&quot;">Device Speed: 6.0Gb/s <u></u><u></u></span></p><p =
class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">Lin=
k Speed: 6.0Gb/s <u></u><u></u></span></p><p class=3D"MsoNormal"><span styl=
e=3D"font-family:&quot;Courier New&quot;">Media Type: Hard Disk Device<u></=
u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot=
;Courier New&quot;">Drive Temperature :26C (78.80 F)<u></u><u></u></span></=
p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;=
">PI Eligibility:=C2=A0 No <u></u><u></u></span></p><p class=3D"MsoNormal">=
<span style=3D"font-family:&quot;Courier New&quot;">Drive is formatted for =
PI information:=C2=A0 No<u></u><u></u></span></p><p class=3D"MsoNormal"><sp=
an style=3D"font-family:&quot;Courier New&quot;">PI: No PI<u></u><u></u></s=
pan></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New=
&quot;">Drive&#39;s write cache : Disabled<u></u><u></u></span></p><p class=
=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">Port-0 :=
<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:=
&quot;Courier New&quot;">Port status: Active<u></u><u></u></span></p><p cla=
ss=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">Port&#=
39;s Linkspeed: 6.0Gb/s <u></u><u></u></span></p><p class=3D"MsoNormal"><sp=
an style=3D"font-family:&quot;Courier New&quot;">Port-1 :<u></u><u></u></sp=
an></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&=
quot;">Port status: Active<u></u><u></u></span></p><p class=3D"MsoNormal"><=
span style=3D"font-family:&quot;Courier New&quot;">Port&#39;s Linkspeed: Un=
known <u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-f=
amily:&quot;Courier New&quot;">Drive has flagged a S.M.A.R.T alert : No<u><=
/u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quo=
t;Courier New&quot;"><u></u>=C2=A0<u></u></span></p><p class=3D"MsoNormal">=
<span style=3D"font-family:&quot;Courier New&quot;"><u></u>=C2=A0<u></u></s=
pan></p><p class=3D"MsoNormal"><b><u><span style=3D"font-family:&quot;Couri=
er New&quot;">KERNEL OPTIONS: Which of these kernels should I choose for th=
e best XFS support for this issue?<u></u><u></u></span></u></b></p><p class=
=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;"><u></u>=
=C2=A0<u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&=
quot;Courier New&quot;">=C2=A0=C2=A0=C2=A0=C2=A0 kernel-3.16.7-3.16.y.20141=
114.ol6.x86_64.rpm=C2=A0=C2=A0=C2=A0=C2=A0 14-Nov-2014 17:55 27.7 M<u></u><=
u></u></span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Co=
urier New&quot;">=C2=A0=C2=A0=C2=A0=C2=A0 kernel-3.17.3-3.17.y.20141114.ol6=
.x86_64.rpm=C2=A0=C2=A0=C2=A0=C2=A0 14-Nov-2014 23:55 26.6 M<u></u><u></u><=
/span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier N=
ew&quot;">=C2=A0=C2=A0=C2=A0=C2=A0 kernel-3.17.3-3.17.y.20141118.ol6.x86_64=
.rpm=C2=A0=C2=A0=C2=A0=C2=A0 18-Nov-2014 09:13 26.6 M<u></u><u></u></span><=
/p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot=
;">=C2=A0=C2=A0=C2=A0=C2=A0 kernel-3.17.8-3.17.y.20150113.ol6.x86_64.rpm=C2=
=A0=C2=A0=C2=A0=C2=A0 14-Jan-2015 06:50 27.9 M<u></u><u></u></span></p><p c=
lass=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=C2=
=A0=C2=A0=C2=A0=C2=A0 kernel-3.18.6-3.18.y.20150210.ol6.x86_64.rpm=C2=A0=C2=
=A0=C2=A0=C2=A0 10-Feb-2015 09:52 30.9 M<u></u><u></u></span></p><p class=
=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=C2=A0=
=C2=A0=C2=A0=C2=A0 kernel-3.18.7-3.18.y.20150217.ol6.x86_64.rpm=C2=A0=C2=A0=
=C2=A0=C2=A0 17-Feb-2015 09:53 30.9 M<u></u><u></u></span></p><p class=3D"M=
soNormal"><span style=3D"font-family:&quot;Courier New&quot;">=C2=A0=C2=A0=
=C2=A0=C2=A0 kernel-3.18.8-3.18.y.20150303.ol6.x86_64.rpm=C2=A0=C2=A0=C2=A0=
=C2=A0 03-Mar-2015 09:55 30.9 M<u></u><u></u></span></p><p class=3D"MsoNorm=
al"><span style=3D"font-family:&quot;Courier New&quot;">=C2=A0=C2=A0=C2=A0=
=C2=A0 kernel-3.19.5-3.19.y.20150421.ol6.x86_64.rpm=C2=A0=C2=A0=C2=A0=C2=A0=
 22-Apr-2015 05:42 31.1 M<u></u><u></u></span></p><p class=3D"MsoNormal"><s=
pan style=3D"font-family:&quot;Courier New&quot;">=C2=A0=C2=A0=C2=A0=C2=A0 =
kernel-3.19.6-3.19.y.20150505.ol6.x86_64.rpm=C2=A0=C2=A0=C2=A0=C2=A0 06-May=
-2015 05:41 29.8 M<u></u><u></u></span></p><p class=3D"MsoNormal"><span sty=
le=3D"font-family:&quot;Courier New&quot;">=C2=A0=C2=A0=C2=A0=C2=A0 kernel-=
3.19.8-3.19.y.20150512.ol6.x86_64.rpm=C2=A0=C2=A0=C2=A0=C2=A0 13-May-2015 0=
5:42 29.8 M<u></u><u></u></span></p><p class=3D"MsoNormal"><span style=3D"f=
ont-family:&quot;Courier New&quot;"><u></u>=C2=A0<u></u></span></p><p class=
=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;"><br></sp=
an></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&=
quot;">Thank you for your time and comments.</span></p><p class=3D"MsoNorma=
l"><span style=3D"font-family:&quot;Courier New&quot;"><br></span></p><p cl=
ass=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">Regar=
ds,</span></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Couri=
er New&quot;"><br></span></p><p class=3D"MsoNormal"><span style=3D"font-fam=
ily:&quot;Courier New&quot;">Pippin Wallace</span></p><p class=3D"MsoNormal=
"><span style=3D"font-family:&quot;Courier New&quot;">Bozeman Montana</span=
></p><p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&qu=
ot;"><u></u>=C2=A0<u></u></span></p><p class=3D"MsoNormal"><span style=3D"f=
ont-family:&quot;Courier New&quot;"><u></u>=C2=A0<u></u></span></p><p class=
=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;"><u></u>=
=C2=A0<u></u></span></p></div></div><br></div>

--089e01634d6a80efcf051d39cafe--


--===============3371121499484158490==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3371121499484158490==--
