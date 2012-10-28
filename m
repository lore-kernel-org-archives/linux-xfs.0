Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9SCIe8l244712 for <xfs@oss.sgi.com>; Sun, 28 Oct 2012 07:18:40 -0500
Received: from two.mjh.name (two.mjh.name [78.47.207.35]) by cuda.sgi.com with
	ESMTP id XHFeuG5gZGcAwDGf (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 28 Oct 2012 05:20:27 -0700 (PDT)
Received: from jamaica.site (p4FEB89A6.dip0.t-ipconnect.de [79.235.137.166])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by two.mjh.name (Postfix) with ESMTPSA id 80439C02C7AA
	for <xfs@oss.sgi.com>; Sun, 28 Oct 2012 12:20:26 +0000 (UTC)
Date: Sun, 28 Oct 2012 13:22:25 +0100
From: Milan =?ISO-8859-1?Q?Holz=E4pfel?= <listen@mjh.name>
Subject: Re: Enabling quota on XFS filesystem with many files hangs
Message-Id: <20121028132225.09020f73d2f3dc69b3f92e77@mjh.name>
In-Reply-To: <508ADE1C.40208@sandeen.net>
References: <20121026191540.ca9ee64db2a51e7166b7fadc@mjh.name>
	<508ADE1C.40208@sandeen.net>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On Fri, 26 Oct 2012 14:01:48 -0500
Eric Sandeen <sandeen@sandeen.net> wrote:

> On 10/26/12 12:15 PM, Milan Holz=E4pfel wrote:
> > Hello all, =

> > =

> > I have an XFS filesystem of size 1.2 TiB with 101 GiB free space and 14
> > million inodes in use. =


Meanwhile, I deleted 200 GiB of data on that filesystem, with 9.9
million inodes still in use. Now, quotacheck just works. =


> > With 3.5.7 and 3.6.3, the OOM does not occur. =


Correction: I couldn't boot 3.6.3 because of a regression [1]. I don't
know whether the problem exists with 3.6.3. =


> > In dmesg, I find
> > =

> > INFO: task mount:8806 blocked for more than 120 seconds.
> =

> And then what?  Probably a backtrace, right?

Yes, of course. Sorry. Here it is:

Oct 24 15:23:39 bombax kernel: [  221.122875] XFS (dm-3): Mounting Filesyst=
em
Oct 24 15:23:39 bombax kernel: [  221.431585] XFS (dm-3): Ending clean mount
Oct 24 15:23:39 bombax kernel: [  221.445026] XFS (dm-3): Quotacheck needed=
: Please wait.
Oct 24 15:28:01 bombax kernel: [  482.960045] INFO: task mount:8806 blocked=
 for more than 120 seconds.
Oct 24 15:28:01 bombax kernel: [  482.966422] "echo 0 > /proc/sys/kernel/hu=
ng_task_timeout_secs" disables this message.
Oct 24 15:28:01 bombax kernel: [  482.974281] mount           D ffffffff818=
0cba0     0  8806   8703 0x00000000
Oct 24 15:28:01 bombax kernel: [  482.974286]  ffff880036be38a8 00000000000=
00086 ffff880036be3878 ffffffffa042b4e9
Oct 24 15:28:01 bombax kernel: [  482.974290]  ffff880036be3fd8 ffff880036b=
e3fd8 ffff880036be3fd8 0000000000013980
Oct 24 15:28:01 bombax kernel: [  482.974293]  ffffffff81c13440 ffff8800790=
8dc00 ffff880036be3898 7fffffffffffffff
Oct 24 15:28:01 bombax kernel: [  482.974297] Call Trace:
Oct 24 15:28:01 bombax kernel: [  482.974338]  [<ffffffffa042b4e9>] ? xfs_b=
uf_iowait+0xa9/0x100 [xfs]
Oct 24 15:28:01 bombax kernel: [  482.974344]  [<ffffffff81698f59>] schedul=
e+0x29/0x70
Oct 24 15:28:01 bombax kernel: [  482.974347]  [<ffffffff81697675>] schedul=
e_timeout+0x2a5/0x320
Oct 24 15:28:01 bombax kernel: [  482.974373]  [<ffffffffa0486c75>] ? xfs_t=
rans_read_buf+0x265/0x480 [xfs]
Oct 24 15:28:01 bombax kernel: [  482.974395]  [<ffffffffa0459ae7>] ? xfs_b=
tree_check_sblock+0xc7/0x130 [xfs]
Oct 24 15:28:01 bombax kernel: [  482.974398]  [<ffffffff81698daf>] wait_fo=
r_common+0xdf/0x180
Oct 24 15:28:01 bombax kernel: [  482.974403]  [<ffffffff8108a280>] ? try_t=
o_wake_up+0x200/0x200
Oct 24 15:28:01 bombax kernel: [  482.974406]  [<ffffffff81698f2d>] wait_fo=
r_completion+0x1d/0x20
Oct 24 15:28:01 bombax kernel: [  482.974430]  [<ffffffffa048c8a4>] xfs_qm_=
flush_one+0x74/0xb0 [xfs]
Oct 24 15:28:01 bombax kernel: [  482.974455]  [<ffffffffa048c830>] ? xfs_q=
m_dqattach_grouphint+0x90/0x90 [xfs]
Oct 24 15:28:01 bombax kernel: [  482.974479]  [<ffffffffa048c3ae>] xfs_qm_=
dquot_walk.isra.5+0xde/0x160 [xfs]
Oct 24 15:28:01 bombax kernel: [  482.974505]  [<ffffffffa048e21c>] xfs_qm_=
quotacheck+0x2bc/0x2e0 [xfs]
Oct 24 15:28:01 bombax kernel: [  482.974529]  [<ffffffffa048e3f4>] xfs_qm_=
mount_quotas+0x124/0x1b0 [xfs]
Oct 24 15:28:01 bombax kernel: [  482.974554]  [<ffffffffa047b8e5>] xfs_mou=
ntfs+0x615/0x6b0 [xfs]
Oct 24 15:28:01 bombax kernel: [  482.974573]  [<ffffffffa043af7d>] xfs_fs_=
fill_super+0x21d/0x2b0 [xfs]
Oct 24 15:28:01 bombax kernel: [  482.974577]  [<ffffffff81189996>] mount_b=
dev+0x1c6/0x210
Oct 24 15:28:01 bombax kernel: [  482.974597]  [<ffffffffa043ad60>] ? xfs_p=
arseargs+0xb80/0xb80 [xfs]
Oct 24 15:28:01 bombax kernel: [  482.974616]  [<ffffffffa0439025>] xfs_fs_=
mount+0x15/0x20 [xfs]
Oct 24 15:28:01 bombax kernel: [  482.974620]  [<ffffffff8118a7d3>] mount_f=
s+0x43/0x1b0
Oct 24 15:28:01 bombax kernel: [  482.974624]  [<ffffffff811a4ab6>] vfs_ker=
n_mount+0x76/0x120
Oct 24 15:28:01 bombax kernel: [  482.974628]  [<ffffffff811a5424>] do_kern=
_mount+0x54/0x110
Oct 24 15:28:01 bombax kernel: [  482.974631]  [<ffffffff811a7114>] do_moun=
t+0x1a4/0x260
Oct 24 15:28:01 bombax kernel: [  482.974634]  [<ffffffff811a75f0>] sys_mou=
nt+0x90/0xe0
Oct 24 15:28:01 bombax kernel: [  482.974637]  [<ffffffff816a26e9>] system_=
call_fastpath+0x16/0x1b

> sysrq-w to get hung tasks or sysrq-t to get all task traces might
> help.
> =

> The sysrqs are one of the things suggested in:
> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_whe=
n_reporting_a_problem.3F

I prepared all the information mentioned here, including the trace-cmd
report, but then I noticed that the problem had disappeared (see
above). =


If you are really interested in the information, I could try to move
the 200 GiB back on the filesystem and see whether the problem
reappears. =



Here is some more information on the system:

Linux bombax 3.5.7-030507-generic #201210130556 SMP Sat Oct 13 09:57:36 UTC=
 2012 x86_64 x86_64 x86_64 GNU/Linux
xfs_repair version 3.1.7
2 CPUs

Storage layers are:
mdadm RAID-5 256 KiB chunk size on sd[abcd]8
Block-device encryption with cryptsetup-luks =

XFS file system with the quotacheck problem

(no LVM below the XFS file system. / is ext4 on LVM on mdadm RAID-1)

disks: 4x SATA, 3.0 Gbps, NCQ enabled
hdparm -W says: "write-caching =3D  1 (on)" on all drives
no battery-backed write cache

mount options: logbsize=3D256k
xfs_info: =


meta-data=3D/dev/mapper/r5a-decrypt isize=3D256    agcount=3D32, agsize=3D9=
827264 blks
         =3D                       sectsz=3D512   attr=3D2
data     =3D                       bsize=3D4096   blocks=3D314472448, imaxp=
ct=3D5
         =3D                       sunit=3D64     swidth=3D192 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
log      =3Dinternal               bsize=3D4096   blocks=3D153600, version=
=3D2
         =3D                       sectsz=3D512   sunit=3D64 blks, lazy-cou=
nt=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0


Regards,
Milan Holz=E4pfel

[1]: https://lkml.org/lkml/2012/10/11/155



-- =

Milan Holz=E4pfel <listen@mjh.name>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
