Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 46C3E7F6B
	for <xfs@oss.sgi.com>; Tue,  1 Jul 2014 01:44:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 36C798F8039
	for <xfs@oss.sgi.com>; Mon, 30 Jun 2014 23:44:49 -0700 (PDT)
Received: from mail-we0-f172.google.com (mail-we0-f172.google.com
	[74.125.82.172]) by cuda.sgi.com with ESMTP id LUJpkxJWsgdnWJBj
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 30 Jun 2014 23:44:47 -0700 (PDT)
Received: by mail-we0-f172.google.com with SMTP id u57so9197765wes.31
	for <xfs@oss.sgi.com>; Mon, 30 Jun 2014 23:44:45 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 30 Jun 2014 23:44:45 -0700
Message-ID: <CALkk6gqiwyC7HD3QvzUgecVgdr55=zW=bEA-0bqHFR4y28koxA@mail.gmail.com>
Subject: corruption of in-memory data detected
From: Alexandru Cardaniuc <cardaniuc@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3386200763849333618=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Alexandru Cardaniuc <cardaniuc@gmail.com>

--===============3386200763849333618==
Content-Type: multipart/alternative; boundary=047d7b3a81767ce45804fd1c1ccd

--047d7b3a81767ce45804fd1c1ccd
Content-Type: text/plain; charset=UTF-8

Hi All,

I am having an issue with an XFS filesystem shutting down under high load
with very many small files.
Basically, I have around 3.5 - 4 million files on this filesystem. New
files are being written to the FS all the time, until I get to 9-11 mln
small files (35k on average).

at some point I get the following in dmesg:

[2870477.695512] Filesystem "sda5": XFS internal error xfs_trans_cancel at
line 1138 of file fs/xfs/xfs_trans.c.  Caller 0xffffffff8826bb7d
[2870477.695558]
[2870477.695559] Call Trace:
[2870477.695611]  [<ffffffff88262c28>] :xfs:xfs_trans_cancel+0x5b/0xfe
[2870477.695643]  [<ffffffff8826bb7d>] :xfs:xfs_mkdir+0x57c/0x5d7
[2870477.695673]  [<ffffffff8822f3f8>] :xfs:xfs_attr_get+0xbf/0xd2
[2870477.695707]  [<ffffffff88273326>] :xfs:xfs_vn_mknod+0x1e1/0x3bb
[2870477.695726]  [<ffffffff80264929>] _spin_lock_irqsave+0x9/0x14
[2870477.695736]  [<ffffffff802230e6>] __up_read+0x19/0x7f
[2870477.695764]  [<ffffffff8824f8f4>] :xfs:xfs_iunlock+0x57/0x79
[2870477.695776]  [<ffffffff80264929>] _spin_lock_irqsave+0x9/0x14
[2870477.695784]  [<ffffffff802230e6>] __up_read+0x19/0x7f
[2870477.695791]  [<ffffffff80209f4c>] __d_lookup+0xb0/0xff
[2870477.695803]  [<ffffffff8020cd4a>] _atomic_dec_and_lock+0x39/0x57
[2870477.695814]  [<ffffffff8022d6db>] mntput_no_expire+0x19/0x89
[2870477.695829]  [<ffffffff80264929>] _spin_lock_irqsave+0x9/0x14
[2870477.695837]  [<ffffffff802230e6>] __up_read+0x19/0x7f
[2870477.695861]  [<ffffffff8824f8f4>] :xfs:xfs_iunlock+0x57/0x79
[2870477.695887]  [<ffffffff882680af>] :xfs:xfs_access+0x3d/0x46
[2870477.695899]  [<ffffffff80264929>] _spin_lock_irqsave+0x9/0x14
[2870477.695923]  [<ffffffff802df4a3>] vfs_mkdir+0xe3/0x152
[2870477.695933]  [<ffffffff802dfa79>] sys_mkdirat+0xa3/0xe4
[2870477.695953]  [<ffffffff80260295>] tracesys+0x47/0xb6
[2870477.695963]  [<ffffffff802602f9>] tracesys+0xab/0xb6
[2870477.695977]
[2870477.695985] xfs_force_shutdown(sda5,0x8) called from line 1139 of file
fs/xfs/xfs_trans.c.  Return address = 0xffffffff88262c46
[2870477.696452] Filesystem "sda5": Corruption of in-memory data detected.
Shutting down filesystem: sda5
[2870477.696464] Please umount the filesystem, and rectify the problem(s)

# ls -l /store
ls: /store: Input/output error
?--------- 0 root root 0 Jan  1  1970 /store

Filesystems is ~1T in size
# df -hT /store
Filesystem    Type    Size  Used Avail Use% Mounted on
/dev/sda5      xfs    910G  142G  769G  16% /store


Using CentOS 5.9 with kernel 2.6.18-348.el5xen

The filesystem is in a virtual machine (Xen) and on top of LVM.

Filesystem was created using mkfs.xfs defaults with
xfsprogs-2.9.4-1.el5.centos (that's the one that comes with CentOS 5.x by
default.)

These are the defaults with which the filesystem was created:
# xfs_info /store
meta-data=/dev/sda5              isize=256    agcount=32, agsize=7454720
blks
         =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=238551040, imaxpct=25
         =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=32768, version=1
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0


The problem is reproducible and I don't think it's hardware related. The
problem was reproduced on multiple servers of the same type. So, I doubt
it's a memory issue or something like that.


Is that a known issue? If it is then what's the fix? I went through the
kernel updates for CentOS 5.10 (newer kernel), but didn't see any xfs
related fixes since CentOS 5.9

Any help will be greatly appreciated...

-- 
Sincerely yours,
Alexandru Cardaniuc

--047d7b3a81767ce45804fd1c1ccd
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div><div><div>Hi All,<br><br></div>I am having an is=
sue with an XFS filesystem shutting down under high load with very many sma=
ll files.<br></div>Basically, I have around 3.5 - 4 million files on this f=
ilesystem. New files are being written to the FS all the time, until I get =
to 9-11 mln small files (35k on average).<br>
<br></div>at some point I get the following in dmesg:<br><br>[2870477.69551=
2] Filesystem &quot;sda5&quot;: XFS internal error xfs_trans_cancel at line=
 1138 of file fs/xfs/xfs_trans.c.=C2=A0 Caller 0xffffffff8826bb7d<br>[28704=
77.695558]<br>
[2870477.695559] Call Trace:<br>[2870477.695611]=C2=A0 [&lt;ffffffff88262c2=
8&gt;] :xfs:xfs_trans_cancel+0x5b/0xfe<br>[2870477.695643]=C2=A0 [&lt;fffff=
fff8826bb7d&gt;] :xfs:xfs_mkdir+0x57c/0x5d7<br>[2870477.695673]=C2=A0 [&lt;=
ffffffff8822f3f8&gt;] :xfs:xfs_attr_get+0xbf/0xd2<br>
[2870477.695707]=C2=A0 [&lt;ffffffff88273326&gt;] :xfs:xfs_vn_mknod+0x1e1/0=
x3bb<br>[2870477.695726]=C2=A0 [&lt;ffffffff80264929&gt;] _spin_lock_irqsav=
e+0x9/0x14<br>[2870477.695736]=C2=A0 [&lt;ffffffff802230e6&gt;] __up_read+0=
x19/0x7f<br>
[2870477.695764]=C2=A0 [&lt;ffffffff8824f8f4&gt;] :xfs:xfs_iunlock+0x57/0x7=
9<br>[2870477.695776]=C2=A0 [&lt;ffffffff80264929&gt;] _spin_lock_irqsave+0=
x9/0x14<br>[2870477.695784]=C2=A0 [&lt;ffffffff802230e6&gt;] __up_read+0x19=
/0x7f<br>[2870477.695791]=C2=A0 [&lt;ffffffff80209f4c&gt;] __d_lookup+0xb0/=
0xff<br>
[2870477.695803]=C2=A0 [&lt;ffffffff8020cd4a&gt;] _atomic_dec_and_lock+0x39=
/0x57<br>[2870477.695814]=C2=A0 [&lt;ffffffff8022d6db&gt;] mntput_no_expire=
+0x19/0x89<br>[2870477.695829]=C2=A0 [&lt;ffffffff80264929&gt;] _spin_lock_=
irqsave+0x9/0x14<br>
[2870477.695837]=C2=A0 [&lt;ffffffff802230e6&gt;] __up_read+0x19/0x7f<br>[2=
870477.695861]=C2=A0 [&lt;ffffffff8824f8f4&gt;] :xfs:xfs_iunlock+0x57/0x79<=
br>[2870477.695887]=C2=A0 [&lt;ffffffff882680af&gt;] :xfs:xfs_access+0x3d/0=
x46<br>[2870477.695899]=C2=A0 [&lt;ffffffff80264929&gt;] _spin_lock_irqsave=
+0x9/0x14<br>
[2870477.695923]=C2=A0 [&lt;ffffffff802df4a3&gt;] vfs_mkdir+0xe3/0x152<br>[=
2870477.695933]=C2=A0 [&lt;ffffffff802dfa79&gt;] sys_mkdirat+0xa3/0xe4<br>[=
2870477.695953]=C2=A0 [&lt;ffffffff80260295&gt;] tracesys+0x47/0xb6<br>[287=
0477.695963]=C2=A0 [&lt;ffffffff802602f9&gt;] tracesys+0xab/0xb6<br>
[2870477.695977]<br>[2870477.695985] xfs_force_shutdown(sda5,0x8) called fr=
om line 1139 of file fs/xfs/xfs_trans.c.=C2=A0 Return address =3D 0xfffffff=
f88262c46<br>[2870477.696452] Filesystem &quot;sda5&quot;: Corruption of in=
-memory data detected.=C2=A0 Shutting down filesystem: sda5<br>
[2870477.696464] Please umount the filesystem, and rectify the problem(s)<b=
r><br># ls -l /store<br>ls: /store: Input/output error<br>?--------- 0 root=
 root 0 Jan=C2=A0 1=C2=A0 1970 /store<br><br></div><div>Filesystems is ~1T =
in size<br>
</div># df -hT /store<br>Filesystem=C2=A0=C2=A0=C2=A0 Type=C2=A0=C2=A0=C2=
=A0 Size=C2=A0 Used Avail Use% Mounted on<br>/dev/sda5=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 xfs=C2=A0=C2=A0=C2=A0 910G=C2=A0 142G=C2=A0 769G=C2=A0 16% /store=
<br><br><div><br><div><div><div><div>Using CentOS 5.9 with kernel 2.6.18-34=
8.el5xen<br><br>
</div><div>The filesystem is in a virtual machine (Xen) and on top of LVM.<=
br><br></div><div>Filesystem was created using mkfs.xfs defaults with xfspr=
ogs-2.9.4-1.el5.centos (that&#39;s the one that comes with CentOS 5.x by de=
fault.)<br>
<br></div><div>These are the defaults with which the filesystem was created=
:<br># xfs_info /store<br>meta-data=3D/dev/sda5=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 isize=3D256=C2=A0=C2=A0=
=C2=A0 agcount=3D32, agsize=3D7454720 blks<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 =3D=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 sectsz=3D512=C2=A0=C2=A0 attr=3D0<br>
data=C2=A0=C2=A0=C2=A0=C2=A0 =3D=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 bsize=3D4096=C2=A0=C2=A0 blocks=3D238551040, imaxpct=3D25<b=
r>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sunit=3D0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 swidth=3D0 blks, unwritten=3D1<br>naming=C2=A0=C2=A0 =3Dversion 2=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bs=
ize=3D4096<br>log=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3Dinternal=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bsize=
=3D4096=C2=A0=C2=A0 blocks=3D32768, version=3D1<br>
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sectsz=3D512=C2=A0=C2=A0 sunit=3D0 blk=
s, lazy-count=3D0<br>realtime =3Dnone=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ex=
tsz=3D4096=C2=A0=C2=A0 blocks=3D0, rtextents=3D0<br clear=3D"all"></div><di=
v><div><div><br><br></div><div>The problem is reproducible and I don&#39;t =
think it&#39;s hardware related. The problem was reproduced on multiple ser=
vers of the same type. So, I doubt it&#39;s a memory issue or something lik=
e that.<br>
<br><br></div><div>Is that a known issue? If it is then what&#39;s the fix?=
 I went through the kernel updates for CentOS 5.10 (newer kernel), but didn=
&#39;t see any xfs related fixes since CentOS 5.9<br></div><div><br></div>
<div>Any help will be greatly appreciated...<br></div><div><br>-- <br>Since=
rely yours,<br>Alexandru Cardaniuc
</div></div></div></div></div></div></div></div>

--047d7b3a81767ce45804fd1c1ccd--


--===============3386200763849333618==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3386200763849333618==--
