Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CCDC07F37
	for <xfs@oss.sgi.com>; Mon, 24 Jun 2013 11:36:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A803E8F8033
	for <xfs@oss.sgi.com>; Mon, 24 Jun 2013 09:36:09 -0700 (PDT)
Received: from buxtehude.debian.org (buxtehude.debian.org [140.211.166.26]) by
	cuda.sgi.com with ESMTP id 5xBBiTaqnmvwtdCw (version=TLSv1
	cipher=AES128-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 24 Jun 2013 09:36:07 -0700 (PDT)
Subject: Bug#713994: xfsprogs: Failure to allocate new space,
	potentially after an xfs_grow, to existing files
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.713994.B.137209158314365@bugs.debian.org>
MIME-Version: 1.0
Date: Mon, 24 Jun 2013 12:32:56 -0400
Message-ID: <CAMjbrKpGsyWCca_VX5yXpen5V6zbT_QxS2JpcR6B=XNUaHipZw@mail.gmail.com>
From: Wes Deviers <yhetti@gmail.com>
Reply-To: Wes Deviers <yhetti@gmail.com>, 713994@bugs.debian.org
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7185512024681961300=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: submit@bugs.debian.org

--===============7185512024681961300==
Content-Type: multipart/alternative; boundary=bcaec529a017064b8904dfe8f7d7

--bcaec529a017064b8904dfe8f7d7
Content-Type: text/plain; charset=ISO-8859-1

Package: xfsprogs
Version: 3.1.4
Justification: breaks unrelated software
Severity: critical
Tags: upstream

*** Please type your report below this line ***

As part of my standard virtual machine template for MySQL, I created an LVM
setup as follows:
pvcreate /dev/sdb
vgcreate vg0 /dev/sdb
lvcreate -n mysql -L 10G vg0
lvcreate -n mysqlbinlog -L 5G vg0
lvcreate -n mysqllog -L 5G vg0

Then, after I deploy the template, I resize the LVs and xfs_growfs them,
apt-get upgrade, and restart.

I also frequently (multiple times per week) extend MySQL data volumes on
the fly using
echo 1 > /sys/block/sdb/device/rescane
pvresize /dev/sdb
lvresize -l +100%FREE /dev/vg0/mysql
xfs_growfs /mysql

This has worked hundreds of times.  Twice, though, on Debian 6.x (I don't
have enough 7.x boxes in production yet) I've had something happen with
XFS.  Once, after an extend, it was unmountable. I assumed this was an
error on my part, created the FS, and moved on.

Today, I got an SQL error on a MySQL replication box:

 Error 'The table 'XXXXX' is full' on query. Default database: XXXXXYYYYYY

Normally this would be a configuration issue in MySQL related to a setting
called "innodb_data_file_path".  Mine is configured correctly; otherwise
all of my templates would have died years ago.  On this particular host, I
extended /mysql (the data volume) to 120G before reboot.  Today, when it
hit what appears to be the *original* size:

/dev/mapper/vg0-mysql
            125814784  10473148 115341636   9% /mysql

XFS threw allocation errors.

[4051547.986869] ffff880638219200: 58 41 47 46 00 00 00 01 00 00 00 0c 00
05 00 00  XAGF............
[4051547.987636] Filesystem "dm-2": XFS internal error xfs_alloc_read_agf
at line 2293 of file
/build/buildd-linux-2.6_2.6.32-48squeeze1-amd64-qu4MIV/linux-2.6-2.6.32/debian/build/source_amd64_none/fs/xfs/xfs_alloc.c.
Caller 0xffffffffa021fcb0
[4051547.987639]
[4051547.988226] Pid: 3367, comm: mysqld Not tainted 2.6.32-5-amd64 #1
[4051547.988228] Call Trace:
[4051547.988287]  [<ffffffffa021fcb0>] ? xfs_alloc_read_agf+0x22/0xa4 [xfs]
[4051547.988298]  [<ffffffffa021fc73>] ? xfs_read_agf+0x12e/0x149 [xfs]
[4051547.988307]  [<ffffffffa021fcb0>] ? xfs_alloc_read_agf+0x22/0xa4 [xfs]
[4051547.988317]  [<ffffffffa021fcb0>] ? xfs_alloc_read_agf+0x22/0xa4 [xfs]
[4051547.988331]  [<ffffffffa021fd45>] ? xfs_alloc_pagf_init+0x13/0x34 [xfs]
[4051547.988342]  [<ffffffffa022c3f1>] ? xfs_inode_is_filestream+0x24/0x51
[xfs]
[4051547.988353]  [<ffffffffa022c67d>] ? xfs_bmap_btalloc+0x25f/0x732 [xfs]
[4051547.988368]  [<ffffffffa0228b70>] ? xfs_bmap_search_extents+0x57/0xd1
[xfs]
[4051547.988379]  [<ffffffffa022ee83>] ? xfs_bmapi+0x876/0x104d [xfs]
[4051547.988386]  [<ffffffff8118eec3>] ? _atomic_dec_and_lock+0x33/0x50
[4051547.988406]  [<ffffffffa0257217>] ? xfs_trans_reserve+0xc8/0x19d [xfs]
[4051547.988419]  [<ffffffffa024a51f>] ? xfs_iomap_write_direct+0x305/0x3f5
[xfs]
[4051547.988432]  [<ffffffffa024a7bc>] ? xfs_iomap+0x1ad/0x285 [xfs]
[4051547.988444]  [<ffffffffa025db53>] ? __xfs_get_blocks+0x6c/0x15c [xfs]
[4051547.988450]  [<ffffffff81062311>] ? queue_work_on+0x45/0x4f
[4051547.988455]  [<ffffffff8111442a>] ? __blockdev_direct_IO+0x575/0xa60
[4051547.988461]  [<ffffffff810482ef>] ? finish_task_switch+0x3a/0xaf
[4051547.988472]  [<ffffffffa025d983>] ? xfs_vm_direct_IO+0xd4/0x102 [xfs]
[4051547.988483]  [<ffffffffa025dc43>] ? xfs_get_blocks_direct+0x0/0x11
[xfs]
[4051547.988494]  [<ffffffffa025d791>] ? xfs_end_io_direct+0x0/0x5f [xfs]
[4051547.988499]  [<ffffffff810b55d6>] ?
generic_file_direct_write+0xdd/0x152
[4051547.988510]  [<ffffffffa0264532>] ? xfs_write+0x44f/0x6ea [xfs]
[4051547.988523]  [<ffffffffa02442ca>] ? xfs_iunlock+0x31/0x7c [xfs]
[4051547.988528]  [<ffffffff810ef21e>] ? do_sync_write+0xce/0x113
[4051547.988532]  [<ffffffff810652b2>] ? autoremove_wake_function+0x0/0x2e
[4051547.988535]  [<ffffffff810482ef>] ? finish_task_switch+0x3a/0xaf
[4051547.988538]  [<ffffffff810efb70>] ? vfs_write+0xa9/0x102
[4051547.988541]  [<ffffffff810efc20>] ? sys_pwrite64+0x57/0x77
[4051547.988545]  [<ffffffff81010b42>] ? system_call_fastpath+0x16/0x1b
[4053278.621482] ffff880638219200: 58 41 47 46 00 00 00 01 00 00 00 0c 00
05 00 00  XAGF............
[4053278.621761] Filesystem "dm-2": XFS internal error xfs_alloc_read_agf
at line 2293 of file
/build/buildd-linux-2.6_2.6.32-48squeeze1-amd64-qu4MIV/linux-2.6-2.6.32/debian/build/source_amd64_none/fs/xfs/xfs_alloc.c.
Caller 0xffffffffa021fcb0
[4053278.621764]
[4053278.622352] Pid: 3367, comm: mysqld Not tainted 2.6.32-5-amd64 #1
[4053278.622354] Call Trace:
[4053278.622381]  [<ffffffffa021fcb0>] ? xfs_alloc_read_agf+0x22/0xa4 [xfs]
[4053278.622392]  [<ffffffffa021fc73>] ? xfs_read_agf+0x12e/0x149 [xfs]
[4053278.622401]  [<ffffffffa021fcb0>] ? xfs_alloc_read_agf+0x22/0xa4 [xfs]
[4053278.622411]  [<ffffffffa021fcb0>] ? xfs_alloc_read_agf+0x22/0xa4 [xfs]
[4053278.622421]  [<ffffffffa021fd45>] ? xfs_alloc_pagf_init+0x13/0x34 [xfs]
[4053278.622432]  [<ffffffffa022c3f1>] ? xfs_inode_is_filestream+0x24/0x51
[xfs]
[4053278.622442]  [<ffffffffa022c67d>] ? xfs_bmap_btalloc+0x25f/0x732 [xfs]
[4053278.622453]  [<ffffffffa0228b70>] ? xfs_bmap_search_extents+0x57/0xd1
[xfs]
[4053278.622465]  [<ffffffffa022ee83>] ? xfs_bmapi+0x876/0x104d [xfs]
[4053278.622486]  [<ffffffff8118eec3>] ? _atomic_dec_and_lock+0x33/0x50
[4053278.622501]  [<ffffffffa0257217>] ? xfs_trans_reserve+0xc8/0x19d [xfs]
[4053278.622514]  [<ffffffffa024a51f>] ? xfs_iomap_write_direct+0x305/0x3f5
[xfs]
[4053278.622527]  [<ffffffffa024a7bc>] ? xfs_iomap+0x1ad/0x285 [xfs]
[4053278.622538]  [<ffffffffa025db53>] ? __xfs_get_blocks+0x6c/0x15c [xfs]
[4053278.622551]  [<ffffffff8111442a>] ? __blockdev_direct_IO+0x575/0xa60
[4053278.622563]  [<ffffffffa025d983>] ? xfs_vm_direct_IO+0xd4/0x102 [xfs]
[4053278.622574]  [<ffffffffa025dc43>] ? xfs_get_blocks_direct+0x0/0x11
[xfs]
[4053278.622585]  [<ffffffffa025d791>] ? xfs_end_io_direct+0x0/0x5f [xfs]
[4053278.622593]  [<ffffffff810b55d6>] ?
generic_file_direct_write+0xdd/0x152
[4053278.622605]  [<ffffffffa0264532>] ? xfs_write+0x44f/0x6ea [xfs]
[4053278.622618]  [<ffffffffa02442ca>] ? xfs_iunlock+0x31/0x7c [xfs]
[4053278.622625]  [<ffffffff810ef21e>] ? do_sync_write+0xce/0x113
[4053278.622637]  [<ffffffff810652b2>] ? autoremove_wake_function+0x0/0x2e
[4053278.622646]  [<ffffffff810482ef>] ? finish_task_switch+0x3a/0xaf
[4053278.622650]  [<ffffffff810efb70>] ? vfs_write+0xa9/0x102
[4053278.622652]  [<ffffffff810efc20>] ? sys_pwrite64+0x57/0x77
[4053278.622660]  [<ffffffff81010b42>] ? system_call_fastpath+0x16/0x1b
[4055487.227132] ffff880638219200: 58 41 47 46 00 00 00 01 00 00 00 0c 00
05 00 00  XAGF............
[4055487.227678] Filesystem "dm-2": XFS internal error xfs_alloc_read_agf
at line 2293 of file
/build/buildd-linux-2.6_2.6.32-48squeeze1-amd64-qu4MIV/linux-2.6-2.6.32/debian/build/source_amd64_none/fs/xfs/xfs_alloc.c.
Caller 0xffffffffa021fcb0
[4055487.227681]
[4055487.228267] Pid: 32572, comm: mysqld Not tainted 2.6.32-5-amd64 #1
[4055487.228269] Call Trace:
[4055487.228292]  [<ffffffffa021fcb0>] ? xfs_alloc_read_agf+0x22/0xa4 [xfs]
[4055487.228302]  [<ffffffffa021fc73>] ? xfs_read_agf+0x12e/0x149 [xfs]
[4055487.228311]  [<ffffffffa021fcb0>] ? xfs_alloc_read_agf+0x22/0xa4 [xfs]
[4055487.228321]  [<ffffffffa021fcb0>] ? xfs_alloc_read_agf+0x22/0xa4 [xfs]
[4055487.228330]  [<ffffffffa021fd45>] ? xfs_alloc_pagf_init+0x13/0x34 [xfs]
[4055487.228341]  [<ffffffffa022c3f1>] ? xfs_inode_is_filestream+0x24/0x51
[xfs]
[4055487.228352]  [<ffffffffa022c67d>] ? xfs_bmap_btalloc+0x25f/0x732 [xfs]
[4055487.228363]  [<ffffffffa0228b70>] ? xfs_bmap_search_extents+0x57/0xd1
[xfs]
[4055487.228374]  [<ffffffffa022ee83>] ? xfs_bmapi+0x876/0x104d [xfs]
[4055487.228388]  [<ffffffffa0257217>] ? xfs_trans_reserve+0xc8/0x19d [xfs]
[4055487.228400]  [<ffffffffa024a51f>] ? xfs_iomap_write_direct+0x305/0x3f5
[xfs]
[4055487.228413]  [<ffffffffa024a7bc>] ? xfs_iomap+0x1ad/0x285 [xfs]
[4055487.228425]  [<ffffffffa025db53>] ? __xfs_get_blocks+0x6c/0x15c [xfs]
[4055487.228431]  [<ffffffff8111442a>] ? __blockdev_direct_IO+0x575/0xa60
[4055487.228442]  [<ffffffffa025d983>] ? xfs_vm_direct_IO+0xd4/0x102 [xfs]
[4055487.228453]  [<ffffffffa025dc43>] ? xfs_get_blocks_direct+0x0/0x11
[xfs]
[4055487.228464]  [<ffffffffa025d791>] ? xfs_end_io_direct+0x0/0x5f [xfs]
[4055487.228468]  [<ffffffff810b55d6>] ?
generic_file_direct_write+0xdd/0x152
[4055487.228479]  [<ffffffffa0264532>] ? xfs_write+0x44f/0x6ea [xfs]
[4055487.228492]  [<ffffffffa02442ca>] ? xfs_iunlock+0x31/0x7c [xfs]
[4055487.228496]  [<ffffffff810ef21e>] ? do_sync_write+0xce/0x113
[4055487.228500]  [<ffffffff810652b2>] ? autoremove_wake_function+0x0/0x2e
[4055487.228503]  [<ffffffff810efb70>] ? vfs_write+0xa9/0x102
[4055487.228505]  [<ffffffff810efc20>] ? sys_pwrite64+0x57/0x77
[4055487.228509]  [<ffffffff81010b42>] ? system_call_fastpath+0x16/0x1b

Throwing a dd at the FS works fine:

dd if=/dev/urandom of=/mysql/data/somefile.out bs=1M count=512

Two things might be going on here that are special

1) I'm using a pretty customized MySQL configuration, including a setting
called O_DIRECT, which turns on direct IO for InnoDB flushes.  Therefore,
the code path for some InnoDB writes is going to be different from what dd
does.
2) This is SAN-backed storage; it shouldn't matter, but it does introduce
IO latency.


I've been trying to find a way to fix this "hot"; these are production
systems.  Luckily it was just a read-only replica. If this had happened to
the master, there would probably have been data corruption (hence the sev 1
ticket).  Couldn't find a hot fix, so I'm going to unmount/repair and then
reboot. I'll keep track of what happens so I can attach it to this report
later if possible.

Thanks!

Wes

-- System Information:
Debian Release: 6.0.7
  APT prefers oldstable-updates
  APT policy: (500, 'oldstable-updates'), (500, 'oldstable')
Architecture: amd64 (x86_64)

Kernel: Linux 2.6.32-5-amd64 (SMP w/4 CPU cores)
Locale: LANG=en_US.UTF-8, LC_CTYPE=en_US.UTF-8 (charmap=UTF-8)
Shell: /bin/sh linked to /bin/bash

Versions of packages xfsprogs depends on:
ii  libblkid1                     2.17.2-9   block device id library
ii  libc6                         2.11.3-4   Embedded GNU C Library: Shared
lib
ii  libreadline5                  5.2-7      GNU readline and history
libraries
ii  libuuid1                      2.17.2-9   Universally Unique ID library

xfsprogs recommends no packages.

Versions of packages xfsprogs suggests:
pn  acl                           <none>     (no description available)
pn  attr                          <none>     (no description available)
pn  quota                         <none>     (no description available)
pn  xfsdump                       <none>     (no description available)

-- no debconf information

--bcaec529a017064b8904dfe8f7d7
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Package: xfsprogs<br>Version: 3.1.4<br>Justification: brea=
ks unrelated software<br>Severity: critical<br>
Tags: upstream<br><br>*** Please type your report below this line ***<br><b=
r>As part of my standard virtual machine template for MySQL, I created an L=
VM setup as follows:<br>pvcreate /dev/sdb<br>vgcreate vg0 /dev/sdb<br>
lvcreate -n mysql -L 10G vg0<br>
lvcreate -n mysqlbinlog -L 5G vg0<br>lvcreate -n mysqllog -L 5G vg0<br><br>=
Then, after I deploy the template, I resize the LVs and xfs_growfs them, ap=
t-get upgrade, and restart.<br><br>I also frequently (multiple times per we=
ek) extend MySQL data volumes on the fly using<br>

echo 1 &gt; /sys/block/sdb/device/rescane<br>pvresize /dev/sdb<br>lvresize =
-l +100%FREE /dev/vg0/mysql<br>xfs_growfs /mysql<br><br>This
 has worked hundreds of times.=A0 Twice, though, on Debian 6.x (I don&#39;t=
=20
have enough 7.x boxes in production yet) I&#39;ve had something happen with=
=20
XFS.=A0 Once, after an extend, it was unmountable. I assumed this was an=20
error on my part, created the FS, and moved on. <br>
<br>Today, I got an SQL error on a MySQL replication box:<br><br>=A0Error &=
#39;The table &#39;XXXXX&#39; is full&#39; on query. Default database: XXXX=
XYYYYYY<br><br>Normally
 this would be a configuration issue in MySQL related to a setting=20
called &quot;innodb_data_file_path&quot;.=A0 Mine is configured correctly; =
otherwise
 all of my templates would have died years ago.=A0 On this particular=20
host, I extended /mysql (the data volume) to 120G before reboot.=A0 Today,
 when it hit what appears to be the *original* size:<br>
<br>/dev/mapper/vg0-mysql=A0=A0=A0=A0=A0=A0=A0=A0=A0<div dir=3D"ltr">=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 125814784=A0 10473148 115341636=A0=A0 9% /mysql=
<br><br>XFS threw allocation errors.<br><br>[4051547.986869] ffff8806382192=
00: 58 41 47 46 00 00 00 01 00 00 00 0c 00 05 00 00=A0 XAGF............<br>

[4051547.987636] Filesystem &quot;dm-2&quot;: XFS internal error xfs_alloc_=
read_agf at line 2293 of file /build/buildd-linux-2.6_2.6.32-48squeeze1-amd=
64-qu4MIV/linux-2.6-2.6.32/debian/build/source_amd64_none/fs/xfs/xfs_alloc.=
c.=A0 Caller 0xffffffffa021fcb0<br>

[4051547.987639] <br>[4051547.988226] Pid: 3367, comm: mysqld Not tainted 2=
.6.32-5-amd64 #1<br>[4051547.988228] Call Trace:<br>[4051547.988287]=A0 [&l=
t;ffffffffa021fcb0&gt;] ? xfs_alloc_read_agf+0x22/0xa4 [xfs]<br>[4051547.98=
8298]=A0 [&lt;ffffffffa021fc73&gt;] ? xfs_read_agf+0x12e/0x149 [xfs]<br>

[4051547.988307]=A0 [&lt;ffffffffa021fcb0&gt;] ? xfs_alloc_read_agf+0x22/0x=
a4 [xfs]<br>[4051547.988317]=A0 [&lt;ffffffffa021fcb0&gt;] ? xfs_alloc_read=
_agf+0x22/0xa4 [xfs]<br>[4051547.988331]=A0 [&lt;ffffffffa021fd45&gt;] ? xf=
s_alloc_pagf_init+0x13/0x34 [xfs]<br>

[4051547.988342]=A0 [&lt;ffffffffa022c3f1&gt;] ? xfs_inode_is_filestream+0x=
24/0x51 [xfs]<br>[4051547.988353]=A0 [&lt;ffffffffa022c67d&gt;] ? xfs_bmap_=
btalloc+0x25f/0x732 [xfs]<br>[4051547.988368]=A0 [&lt;ffffffffa0228b70&gt;]=
 ? xfs_bmap_search_extents+0x57/0xd1 [xfs]<br>

[4051547.988379]=A0 [&lt;ffffffffa022ee83&gt;] ? xfs_bmapi+0x876/0x104d [xf=
s]<br>[4051547.988386]=A0 [&lt;ffffffff8118eec3&gt;] ? _atomic_dec_and_lock=
+0x33/0x50<br>[4051547.988406]=A0 [&lt;ffffffffa0257217&gt;] ? xfs_trans_re=
serve+0xc8/0x19d [xfs]<br>

[4051547.988419]=A0 [&lt;ffffffffa024a51f&gt;] ? xfs_iomap_write_direct+0x3=
05/0x3f5 [xfs]<br>[4051547.988432]=A0 [&lt;ffffffffa024a7bc&gt;] ? xfs_ioma=
p+0x1ad/0x285 [xfs]<br>[4051547.988444]=A0 [&lt;ffffffffa025db53&gt;] ? __x=
fs_get_blocks+0x6c/0x15c [xfs]<br>

[4051547.988450]=A0 [&lt;ffffffff81062311&gt;] ? queue_work_on+0x45/0x4f<br=
>[4051547.988455]=A0 [&lt;ffffffff8111442a&gt;] ? __blockdev_direct_IO+0x57=
5/0xa60<br>[4051547.988461]=A0 [&lt;ffffffff810482ef&gt;] ? finish_task_swi=
tch+0x3a/0xaf<br>

[4051547.988472]=A0 [&lt;ffffffffa025d983&gt;] ? xfs_vm_direct_IO+0xd4/0x10=
2 [xfs]<br>[4051547.988483]=A0 [&lt;ffffffffa025dc43&gt;] ? xfs_get_blocks_=
direct+0x0/0x11 [xfs]<br>[4051547.988494]=A0 [&lt;ffffffffa025d791&gt;] ? x=
fs_end_io_direct+0x0/0x5f [xfs]<br>

[4051547.988499]=A0 [&lt;ffffffff810b55d6&gt;] ? generic_file_direct_write+=
0xdd/0x152<br>[4051547.988510]=A0 [&lt;ffffffffa0264532&gt;] ? xfs_write+0x=
44f/0x6ea [xfs]<br>[4051547.988523]=A0 [&lt;ffffffffa02442ca&gt;] ? xfs_iun=
lock+0x31/0x7c [xfs]<br>

[4051547.988528]=A0 [&lt;ffffffff810ef21e&gt;] ? do_sync_write+0xce/0x113<b=
r>[4051547.988532]=A0 [&lt;ffffffff810652b2&gt;] ? autoremove_wake_function=
+0x0/0x2e<br>[4051547.988535]=A0 [&lt;ffffffff810482ef&gt;] ? finish_task_s=
witch+0x3a/0xaf<br>

[4051547.988538]=A0 [&lt;ffffffff810efb70&gt;] ? vfs_write+0xa9/0x102<br>[4=
051547.988541]=A0 [&lt;ffffffff810efc20&gt;] ? sys_pwrite64+0x57/0x77<br>[4=
051547.988545]=A0 [&lt;ffffffff81010b42&gt;] ? system_call_fastpath+0x16/0x=
1b<br>

[4053278.621482] ffff880638219200: 58 41 47 46 00 00 00 01 00 00 00 0c 00 0=
5 00 00=A0 XAGF............<br>[4053278.621761] Filesystem &quot;dm-2&quot;=
: XFS internal error xfs_alloc_read_agf at line 2293 of file /build/buildd-=
linux-2.6_2.6.32-48squeeze1-amd64-qu4MIV/linux-2.6-2.6.32/debian/build/sour=
ce_amd64_none/fs/xfs/xfs_alloc.c.=A0 Caller 0xffffffffa021fcb0<br>

[4053278.621764] <br>[4053278.622352] Pid: 3367, comm: mysqld Not tainted 2=
.6.32-5-amd64 #1<br>[4053278.622354] Call Trace:<br>[4053278.622381]=A0 [&l=
t;ffffffffa021fcb0&gt;] ? xfs_alloc_read_agf+0x22/0xa4 [xfs]<br>[4053278.62=
2392]=A0 [&lt;ffffffffa021fc73&gt;] ? xfs_read_agf+0x12e/0x149 [xfs]<br>

[4053278.622401]=A0 [&lt;ffffffffa021fcb0&gt;] ? xfs_alloc_read_agf+0x22/0x=
a4 [xfs]<br>[4053278.622411]=A0 [&lt;ffffffffa021fcb0&gt;] ? xfs_alloc_read=
_agf+0x22/0xa4 [xfs]<br>[4053278.622421]=A0 [&lt;ffffffffa021fd45&gt;] ? xf=
s_alloc_pagf_init+0x13/0x34 [xfs]<br>

[4053278.622432]=A0 [&lt;ffffffffa022c3f1&gt;] ? xfs_inode_is_filestream+0x=
24/0x51 [xfs]<br>[4053278.622442]=A0 [&lt;ffffffffa022c67d&gt;] ? xfs_bmap_=
btalloc+0x25f/0x732 [xfs]<br>[4053278.622453]=A0 [&lt;ffffffffa0228b70&gt;]=
 ? xfs_bmap_search_extents+0x57/0xd1 [xfs]<br>

[4053278.622465]=A0 [&lt;ffffffffa022ee83&gt;] ? xfs_bmapi+0x876/0x104d [xf=
s]<br>[4053278.622486]=A0 [&lt;ffffffff8118eec3&gt;] ? _atomic_dec_and_lock=
+0x33/0x50<br>[4053278.622501]=A0 [&lt;ffffffffa0257217&gt;] ? xfs_trans_re=
serve+0xc8/0x19d [xfs]<br>

[4053278.622514]=A0 [&lt;ffffffffa024a51f&gt;] ? xfs_iomap_write_direct+0x3=
05/0x3f5 [xfs]<br>[4053278.622527]=A0 [&lt;ffffffffa024a7bc&gt;] ? xfs_ioma=
p+0x1ad/0x285 [xfs]<br>[4053278.622538]=A0 [&lt;ffffffffa025db53&gt;] ? __x=
fs_get_blocks+0x6c/0x15c [xfs]<br>

[4053278.622551]=A0 [&lt;ffffffff8111442a&gt;] ? __blockdev_direct_IO+0x575=
/0xa60<br>[4053278.622563]=A0 [&lt;ffffffffa025d983&gt;] ? xfs_vm_direct_IO=
+0xd4/0x102 [xfs]<br>[4053278.622574]=A0 [&lt;ffffffffa025dc43&gt;] ? xfs_g=
et_blocks_direct+0x0/0x11 [xfs]<br>

[4053278.622585]=A0 [&lt;ffffffffa025d791&gt;] ? xfs_end_io_direct+0x0/0x5f=
 [xfs]<br>[4053278.622593]=A0 [&lt;ffffffff810b55d6&gt;] ? generic_file_dir=
ect_write+0xdd/0x152<br>[4053278.622605]=A0 [&lt;ffffffffa0264532&gt;] ? xf=
s_write+0x44f/0x6ea [xfs]<br>

[4053278.622618]=A0 [&lt;ffffffffa02442ca&gt;] ? xfs_iunlock+0x31/0x7c [xfs=
]<br>[4053278.622625]=A0 [&lt;ffffffff810ef21e&gt;] ? do_sync_write+0xce/0x=
113<br>[4053278.622637]=A0 [&lt;ffffffff810652b2&gt;] ? autoremove_wake_fun=
ction+0x0/0x2e<br>

[4053278.622646]=A0 [&lt;ffffffff810482ef&gt;] ? finish_task_switch+0x3a/0x=
af<br>[4053278.622650]=A0 [&lt;ffffffff810efb70&gt;] ? vfs_write+0xa9/0x102=
<br>[4053278.622652]=A0 [&lt;ffffffff810efc20&gt;] ? sys_pwrite64+0x57/0x77=
<br>

[4053278.622660]=A0 [&lt;ffffffff81010b42&gt;] ? system_call_fastpath+0x16/=
0x1b<br>[4055487.227132] ffff880638219200: 58 41 47 46 00 00 00 01 00 00 00=
 0c 00 05 00 00=A0 XAGF............<br>[4055487.227678] Filesystem &quot;dm=
-2&quot;: XFS internal error xfs_alloc_read_agf at line 2293 of file /build=
/buildd-linux-2.6_2.6.32-48squeeze1-amd64-qu4MIV/linux-2.6-2.6.32/debian/bu=
ild/source_amd64_none/fs/xfs/xfs_alloc.c.=A0 Caller 0xffffffffa021fcb0<br>

[4055487.227681] <br>[4055487.228267] Pid: 32572, comm: mysqld Not tainted =
2.6.32-5-amd64 #1<br>[4055487.228269] Call Trace:<br>[4055487.228292]=A0 [&=
lt;ffffffffa021fcb0&gt;] ? xfs_alloc_read_agf+0x22/0xa4 [xfs]<br>[4055487.2=
28302]=A0 [&lt;ffffffffa021fc73&gt;] ? xfs_read_agf+0x12e/0x149 [xfs]<br>

[4055487.228311]=A0 [&lt;ffffffffa021fcb0&gt;] ? xfs_alloc_read_agf+0x22/0x=
a4 [xfs]<br>[4055487.228321]=A0 [&lt;ffffffffa021fcb0&gt;] ? xfs_alloc_read=
_agf+0x22/0xa4 [xfs]<br>[4055487.228330]=A0 [&lt;ffffffffa021fd45&gt;] ? xf=
s_alloc_pagf_init+0x13/0x34 [xfs]<br>

[4055487.228341]=A0 [&lt;ffffffffa022c3f1&gt;] ? xfs_inode_is_filestream+0x=
24/0x51 [xfs]<br>[4055487.228352]=A0 [&lt;ffffffffa022c67d&gt;] ? xfs_bmap_=
btalloc+0x25f/0x732 [xfs]<br>[4055487.228363]=A0 [&lt;ffffffffa0228b70&gt;]=
 ? xfs_bmap_search_extents+0x57/0xd1 [xfs]<br>

[4055487.228374]=A0 [&lt;ffffffffa022ee83&gt;] ? xfs_bmapi+0x876/0x104d [xf=
s]<br>[4055487.228388]=A0 [&lt;ffffffffa0257217&gt;] ? xfs_trans_reserve+0x=
c8/0x19d [xfs]<br>[4055487.228400]=A0 [&lt;ffffffffa024a51f&gt;] ? xfs_ioma=
p_write_direct+0x305/0x3f5 [xfs]<br>

[4055487.228413]=A0 [&lt;ffffffffa024a7bc&gt;] ? xfs_iomap+0x1ad/0x285 [xfs=
]<br>[4055487.228425]=A0 [&lt;ffffffffa025db53&gt;] ? __xfs_get_blocks+0x6c=
/0x15c [xfs]<br>[4055487.228431]=A0 [&lt;ffffffff8111442a&gt;] ? __blockdev=
_direct_IO+0x575/0xa60<br>

[4055487.228442]=A0 [&lt;ffffffffa025d983&gt;] ? xfs_vm_direct_IO+0xd4/0x10=
2 [xfs]<br>[4055487.228453]=A0 [&lt;ffffffffa025dc43&gt;] ? xfs_get_blocks_=
direct+0x0/0x11 [xfs]<br>[4055487.228464]=A0 [&lt;ffffffffa025d791&gt;] ? x=
fs_end_io_direct+0x0/0x5f [xfs]<br>

[4055487.228468]=A0 [&lt;ffffffff810b55d6&gt;] ? generic_file_direct_write+=
0xdd/0x152<br>[4055487.228479]=A0 [&lt;ffffffffa0264532&gt;] ? xfs_write+0x=
44f/0x6ea [xfs]<br>[4055487.228492]=A0 [&lt;ffffffffa02442ca&gt;] ? xfs_iun=
lock+0x31/0x7c [xfs]<br>

[4055487.228496]=A0 [&lt;ffffffff810ef21e&gt;] ? do_sync_write+0xce/0x113<b=
r>[4055487.228500]=A0 [&lt;ffffffff810652b2&gt;] ? autoremove_wake_function=
+0x0/0x2e<br>[4055487.228503]=A0 [&lt;ffffffff810efb70&gt;] ? vfs_write+0xa=
9/0x102<br>

[4055487.228505]=A0 [&lt;ffffffff810efc20&gt;] ? sys_pwrite64+0x57/0x77<br>=
[4055487.228509]=A0 [&lt;ffffffff81010b42&gt;] ? system_call_fastpath+0x16/=
0x1b<br><br>Throwing a dd at the FS works fine:<br><br>dd if=3D/dev/urandom=
 of=3D/mysql/data/somefile.out bs=3D1M count=3D512<br>

<br>Two things might be going on here that are special<br><br>1) I&#39;m=20
using a pretty customized MySQL configuration, including a setting=20
called O_DIRECT, which turns on direct IO for InnoDB flushes.=A0=20
Therefore, the code path for some InnoDB writes is going to be different
 from what dd does.<br>
2) This is SAN-backed storage; it shouldn&#39;t matter, but it does introdu=
ce IO latency.<br><br><br>I&#39;ve
 been trying to find a way to fix this &quot;hot&quot;; these are productio=
n=20
systems.=A0 Luckily it was just a read-only replica. If this had happened=
=20
to the master, there would probably have been data corruption (hence the
 sev 1 ticket).=A0 Couldn&#39;t find a hot fix, so I&#39;m going to unmount=
/repair
 and then reboot. I&#39;ll keep track of what happens so I can attach it to=
=20
this report later if possible.<br>
<br>Thanks!<br><br>Wes<br><br>-- System Information:<br>Debian Release: 6.0=
.7<br>=A0 APT prefers oldstable-updates<br>=A0 APT policy: (500, &#39;oldst=
able-updates&#39;), (500, &#39;oldstable&#39;)<br>Architecture: amd64 (x86_=
64)<br>

<br>Kernel: Linux 2.6.32-5-amd64 (SMP w/4 CPU cores)<br>Locale: LANG=3Den_U=
S.UTF-8, LC_CTYPE=3Den_US.UTF-8 (charmap=3DUTF-8)<br>Shell: /bin/sh linked =
to /bin/bash<br><br>Versions of packages xfsprogs depends on:<br>ii=A0 libb=
lkid1=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 2.17.2-9=
=A0=A0 block device id library<br>

ii=A0 libc6=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 2.11.3-4=A0=A0 Embedded GNU C Library: Shared lib<br>ii=A0 librea=
dline5=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 5.2-7=A0=A0=A0=A0=
=A0 GNU readline and history libraries<br>ii=A0 libuuid1=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 2.17.2-9=A0=A0 Universally Un=
ique ID library<br>

<br>xfsprogs recommends no packages.<br><br>Versions of packages xfsprogs s=
uggests:<br>pn=A0 acl=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 &lt;none&gt;=A0=A0=A0=A0 (no description available=
)<br>pn=A0 attr=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 &lt;none&gt;=A0=A0=A0=A0 (no description available)<br>

pn=A0 quota=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 &lt;none&gt;=A0=A0=A0=A0 (no description available)<br>pn=A0 xfsd=
ump=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 &lt;n=
one&gt;=A0=A0=A0=A0 (no description available)<br><br>-- no debconf informa=
tion</div></div>

--bcaec529a017064b8904dfe8f7d7--


--===============7185512024681961300==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7185512024681961300==--
