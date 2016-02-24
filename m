Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3087629E05
	for <xfs@oss.sgi.com>; Wed, 24 Feb 2016 00:28:50 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EB26D304051
	for <xfs@oss.sgi.com>; Tue, 23 Feb 2016 22:28:43 -0800 (PST)
Received: from mail-wm0-f46.google.com (mail-wm0-f46.google.com
	[74.125.82.46]) by cuda.sgi.com with ESMTP id J4JtiOzf6DtsPb6J
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 23 Feb 2016 22:12:36 -0800 (PST)
Received: by mail-wm0-f46.google.com with SMTP id b205so20696932wmb.1
	for <xfs@oss.sgi.com>; Tue, 23 Feb 2016 22:12:36 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 24 Feb 2016 14:12:34 +0800
Message-ID: <CACepTxgki0HxCv4MwBRbtP0k2hv8Qguq-UO_BA3U0eeAsN_8Fw@mail.gmail.com>
Subject: XFS Corruption
From: fangchen sun <sunspot0105@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0218299671113620830=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============0218299671113620830==
Content-Type: multipart/alternative; boundary=001a114b3054b72322052c7df3c6

--001a114b3054b72322052c7df3c6
Content-Type: text/plain; charset=UTF-8

Dear all:

I have a ceph object storage cluster, and choose XFS as the underlying file
system.
I recently ran into a problem that sometimes the function "setxattr()"
 failed,
I can only umount the disk and repair it with "xfs_repair".

os: centos 6.5
kernel version: 2.6.32

the log for dmesg command:
[41796028.532225] Pid: 1438740, comm: ceph-osd Not tainted
2.6.32-925.431.23.3.letv.el6.x86_64 #1
[41796028.532227] Call Trace:
[41796028.532255]  [<ffffffffa01e1e5f>] ? xfs_error_report+0x3f/0x50 [xfs]
[41796028.532276]  [<ffffffffa01d506a>] ? xfs_da_read_buf+0x2a/0x30 [xfs]
[41796028.532296]  [<ffffffffa01e1ece>] ? xfs_corruption_error+0x5e/0x90
[xfs]
[41796028.532316]  [<ffffffffa01d4f4c>] ? xfs_da_do_buf+0x6cc/0x770 [xfs]
[41796028.532335]  [<ffffffffa01d506a>] ? xfs_da_read_buf+0x2a/0x30 [xfs]
[41796028.532359]  [<ffffffffa0206fc7>] ? kmem_zone_alloc+0x77/0xf0 [xfs]
[41796028.532380]  [<ffffffffa01d506a>] ? xfs_da_read_buf+0x2a/0x30 [xfs]
[41796028.532399]  [<ffffffffa01bc481>] ? xfs_attr_leaf_addname+0x61/0x3d0
[xfs]
[41796028.532426]  [<ffffffffa01bc481>] ? xfs_attr_leaf_addname+0x61/0x3d0
[xfs]
[41796028.532455]  [<ffffffffa01ff187>] ? xfs_trans_add_item+0x57/0x70 [xfs]
[41796028.532476]  [<ffffffffa01cc208>] ? xfs_bmbt_get_all+0x18/0x20 [xfs]
[41796028.532495]  [<ffffffffa01bcbb4>] ? xfs_attr_set_int+0x3c4/0x510 [xfs]
[41796028.532517]  [<ffffffffa01d4f5b>] ? xfs_da_do_buf+0x6db/0x770 [xfs]
[41796028.532536]  [<ffffffffa01bcd81>] ? xfs_attr_set+0x81/0x90 [xfs]
[41796028.532560]  [<ffffffffa0216cc3>] ? __xfs_xattr_set+0x43/0x60 [xfs]
[41796028.532584]  [<ffffffffa0216d31>] ? xfs_xattr_user_set+0x11/0x20 [xfs]
[41796028.532592]  [<ffffffff811aee92>] ? generic_setxattr+0xa2/0xb0
[41796028.532596]  [<ffffffff811b134e>] ? __vfs_setxattr_noperm+0x4e/0x160
[41796028.532600]  [<ffffffff81196b77>] ? inode_permission+0xa7/0x100
[41796028.532604]  [<ffffffff811b151c>] ? vfs_setxattr+0xbc/0xc0
[41796028.532607]  [<ffffffff811b15f0>] ? setxattr+0xd0/0x150
[41796028.532612]  [<ffffffff8105af80>] ? __dequeue_entity+0x30/0x50
[41796028.532617]  [<ffffffff8100988e>] ? __switch_to+0x26e/0x320
[41796028.532621]  [<ffffffff8118aec0>] ? __sb_start_write+0x80/0x120
[41796028.532626]  [<ffffffff8152912e>] ? thread_return+0x4e/0x760
[41796028.532630]  [<ffffffff811b171d>] ? sys_fsetxattr+0xad/0xd0
[41796028.532633]  [<ffffffff8100b072>] ? system_call_fastpath+0x16/0x1b
[41796028.532636] XFS (sdi1): Corruption detected. Unmount and run
xfs_repair

Any comments will be much appreciated!

Best Regards!
sunspot

--001a114b3054b72322052c7df3c6
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><span style=3D"font-size:14px">Dear all:</span><div style=
=3D"font-size:14px"><br></div><div style=3D"font-size:14px">I have a ceph o=
bject storage cluster, and choose XFS as the underlying file system.</div><=
div style=3D"font-size:14px">I recently ran into a problem that sometimes t=
he function &quot;setxattr()&quot; =C2=A0failed,=C2=A0</div><div style=3D"f=
ont-size:14px">I can only umount the disk and repair it with &quot;xfs_repa=
ir&quot;.</div><div style=3D"font-size:14px"><br></div><div style=3D"font-s=
ize:14px">os: centos 6.5</div><div style=3D"font-size:14px">kernel version:=
 2.6.32</div><div style=3D"font-size:14px"><br></div><div style=3D"font-siz=
e:14px">the log for dmesg command:</div><div style=3D"font-size:14px"><div>=
[41796028.532225] Pid: 1438740, comm: ceph-osd Not tainted 2.6.32-925.431.2=
3.3.letv.el6.x86_64 #1</div><div>[41796028.532227] Call Trace:</div><div>[4=
1796028.532255] =C2=A0[&lt;ffffffffa01e1e5f&gt;] ? xfs_error_report+0x3f/0x=
50 [xfs]</div><div>[41796028.532276] =C2=A0[&lt;ffffffffa01d506a&gt;] ? xfs=
_da_read_buf+0x2a/0x30 [xfs]</div><div>[41796028.532296] =C2=A0[&lt;fffffff=
fa01e1ece&gt;] ? xfs_corruption_error+0x5e/0x90 [xfs]</div><div>[41796028.5=
32316] =C2=A0[&lt;ffffffffa01d4f4c&gt;] ? xfs_da_do_buf+0x6cc/0x770 [xfs]</=
div><div>[41796028.532335] =C2=A0[&lt;ffffffffa01d506a&gt;] ? xfs_da_read_b=
uf+0x2a/0x30 [xfs]</div><div>[41796028.532359] =C2=A0[&lt;ffffffffa0206fc7&=
gt;] ? kmem_zone_alloc+0x77/0xf0 [xfs]</div><div>[41796028.532380] =C2=A0[&=
lt;ffffffffa01d506a&gt;] ? xfs_da_read_buf+0x2a/0x30 [xfs]</div><div>[41796=
028.532399] =C2=A0[&lt;ffffffffa01bc481&gt;] ? xfs_attr_leaf_addname+0x61/0=
x3d0 [xfs]</div><div>[41796028.532426] =C2=A0[&lt;ffffffffa01bc481&gt;] ? x=
fs_attr_leaf_addname+0x61/0x3d0 [xfs]</div><div>[41796028.532455] =C2=A0[&l=
t;ffffffffa01ff187&gt;] ? xfs_trans_add_item+0x57/0x70 [xfs]</div><div>[417=
96028.532476] =C2=A0[&lt;ffffffffa01cc208&gt;] ? xfs_bmbt_get_all+0x18/0x20=
 [xfs]</div><div>[41796028.532495] =C2=A0[&lt;ffffffffa01bcbb4&gt;] ? xfs_a=
ttr_set_int+0x3c4/0x510 [xfs]</div><div>[41796028.532517] =C2=A0[&lt;ffffff=
ffa01d4f5b&gt;] ? xfs_da_do_buf+0x6db/0x770 [xfs]</div><div>[41796028.53253=
6] =C2=A0[&lt;ffffffffa01bcd81&gt;] ? xfs_attr_set+0x81/0x90 [xfs]</div><di=
v>[41796028.532560] =C2=A0[&lt;ffffffffa0216cc3&gt;] ? __xfs_xattr_set+0x43=
/0x60 [xfs]</div><div>[41796028.532584] =C2=A0[&lt;ffffffffa0216d31&gt;] ? =
xfs_xattr_user_set+0x11/0x20 [xfs]</div><div>[41796028.532592] =C2=A0[&lt;f=
fffffff811aee92&gt;] ? generic_setxattr+0xa2/0xb0</div><div>[41796028.53259=
6] =C2=A0[&lt;ffffffff811b134e&gt;] ? __vfs_setxattr_noperm+0x4e/0x160</div=
><div>[41796028.532600] =C2=A0[&lt;ffffffff81196b77&gt;] ? inode_permission=
+0xa7/0x100</div><div>[41796028.532604] =C2=A0[&lt;ffffffff811b151c&gt;] ? =
vfs_setxattr+0xbc/0xc0</div><div>[41796028.532607] =C2=A0[&lt;ffffffff811b1=
5f0&gt;] ? setxattr+0xd0/0x150</div><div>[41796028.532612] =C2=A0[&lt;fffff=
fff8105af80&gt;] ? __dequeue_entity+0x30/0x50</div><div>[41796028.532617] =
=C2=A0[&lt;ffffffff8100988e&gt;] ? __switch_to+0x26e/0x320</div><div>[41796=
028.532621] =C2=A0[&lt;ffffffff8118aec0&gt;] ? __sb_start_write+0x80/0x120<=
/div><div>[41796028.532626] =C2=A0[&lt;ffffffff8152912e&gt;] ? thread_retur=
n+0x4e/0x760</div><div>[41796028.532630] =C2=A0[&lt;ffffffff811b171d&gt;] ?=
 sys_fsetxattr+0xad/0xd0</div><div>[41796028.532633] =C2=A0[&lt;ffffffff810=
0b072&gt;] ? system_call_fastpath+0x16/0x1b</div><div>[41796028.532636] XFS=
 (sdi1): Corruption detected. Unmount and run xfs_repair</div></div><div st=
yle=3D"font-size:14px"><br></div><div style=3D"font-size:14px">Any comments=
 will be much appreciated!</div><div style=3D"font-size:14px"><br></div><di=
v style=3D"font-size:14px">Best Regards!</div><div style=3D"font-size:14px"=
>sunspot</div></div>

--001a114b3054b72322052c7df3c6--


--===============0218299671113620830==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0218299671113620830==--
