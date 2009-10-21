Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9L667jZ216958 for <xfs@oss.sgi.com>; Wed, 21 Oct 2009 01:06:07 -0500
Received: from mail-px0-f193.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B24E824648
	for <xfs@oss.sgi.com>; Tue, 20 Oct 2009 23:07:41 -0700 (PDT)
Received: from mail-px0-f193.google.com (mail-px0-f193.google.com
	[209.85.216.193]) by cuda.sgi.com with ESMTP id
	9JNaRRI4kmKYNUB9 for <xfs@oss.sgi.com>;
	Tue, 20 Oct 2009 23:07:41 -0700 (PDT)
Received: by pxi31 with SMTP id 31so346284pxi.20
	for <xfs@oss.sgi.com>; Tue, 20 Oct 2009 23:07:40 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 21 Oct 2009 11:37:38 +0530
Message-ID: <c2dcdfa40910202307m77a9d7c5lf18e278a9ebae08e@mail.gmail.com>
Subject: XFS internal error xfs_da_do_buf(1) at line 1992 of file
	fs/xfs/xfs_da_btree.c
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3611969978805709389=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, "sandeen-xfs@sandeen.net" <sandeen-xfs@sandeen.net>, "p.mironchik@velesys.com" <p.mironchik@velesys.com>, "hch@xfs.org" <hch@xfs.org>

--===============3611969978805709389==
Content-Type: multipart/alternative; boundary=000e0cd24d9edbc11a04766bcb11

--000e0cd24d9edbc11a04766bcb11
Content-Type: text/plain; charset=ISO-8859-1

Dear Eric,


I am facing an issue with file deletion in XFS. Every time, I perform a
remove operation the kernel crashes with the following prints.


# rm -rf 1* 2* 3* 4*
xfs_da_do_buf: bno 16777216
dir: inode 128
Filesystem "sda1": XFS internal error xfs_da_do_buf(1) at line 1992 of file
fs/xfs/xfs_da_btree.c.  Caller 0xc011d2e4
[<c0022618>] (dump_stack+0x0/0x14) from [<c0129b2c>]
(xfs_error_report+0x54/0x64)
[<c0129ad8>] (xfs_error_report+0x0/0x64) from [<c011cea0>]
(xfs_da_do_buf+0x334/0x6ec)
[<c011cb6c>] (xfs_da_do_buf+0x0/0x6ec) from [<c011d2e4>]
(xfs_da_read_buf+0x34/0x3c)
[<c011d2b0>] (xfs_da_read_buf+0x0/0x3c) from [<c0126030>]
(xfs_dir2_node_removename+0x278/0x500)
[<c0125db8>] (xfs_dir2_node_removename+0x0/0x500) from [<c0120760>]
(xfs_dir_removename+0x100/0x10c)
[<c0120660>] (xfs_dir_removename+0x0/0x10c) from [<c0151be0>]
(xfs_remove+0x280/0x424)
 r6 = 00000000  r5 = 00000000  r4 = 0000357C
[<c0151960>] (xfs_remove+0x0/0x424) from [<c015c3a0>]
(xfs_vn_unlink+0x30/0x60)
[<c015c370>] (xfs_vn_unlink+0x0/0x60) from [<c0091c58>]
(vfs_unlink+0x70/0xac)
 r7 = C3E79000  r6 = C3E5AE58  r5 = C4122EB8  r4 = 00000000
[<c0091be8>] (vfs_unlink+0x0/0xac) from [<c0093fbc>]
(do_unlinkat+0xcc/0x14c)
 r6 = C4123D78  r5 = C4122EB8  r4 = 00000000
[<c0093ef0>] (do_unlinkat+0x0/0x14c) from [<c0094054>]
(sys_unlink+0x18/0x1c)
 r7 = 0000000A  r6 = 0000000C  r5 = 00000008  r4 = BECE6A2B
[<c009403c>] (sys_unlink+0x0/0x1c) from [<c001de40>]
(ret_fast_syscall+0x0/0x2c)

*I am using kernel version - 2.6.18.1
Platform - ARM
*
I have searched a lot on this issue, but no solution is available. In the
FAQS it is mentioned that it's been fixed 2.6.17.7 onwards.
But, i keep getting this issue frequently almost every time I do this
operation .

Please provide me any help to sort this issue.

Thanks & Regards,
Amit Sahrawat

--000e0cd24d9edbc11a04766bcb11
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Dear Eric,<br><br><br>I am facing an issue with file deletion in XFS. Every=
 time, I perform a remove operation the kernel crashes with the following p=
rints.<br><br><br># rm -rf 1* 2* 3* 4*<br>xfs_da_do_buf: bno 16777216<br>
dir: inode 128<br>Filesystem &quot;sda1&quot;: XFS internal error xfs_da_do=
_buf(1) at line 1992 of file fs/xfs/xfs_da_btree.c.=A0 Caller 0xc011d2e4<br=
>[&lt;c0022618&gt;] (dump_stack+0x0/0x14) from [&lt;c0129b2c&gt;] (xfs_erro=
r_report+0x54/0x64)<br>
[&lt;c0129ad8&gt;] (xfs_error_report+0x0/0x64) from [&lt;c011cea0&gt;] (xfs=
_da_do_buf+0x334/0x6ec)<br>[&lt;c011cb6c&gt;] (xfs_da_do_buf+0x0/0x6ec) fro=
m [&lt;c011d2e4&gt;] (xfs_da_read_buf+0x34/0x3c)<br>[&lt;c011d2b0&gt;] (xfs=
_da_read_buf+0x0/0x3c) from [&lt;c0126030&gt;] (xfs_dir2_node_removename+0x=
278/0x500)<br>
[&lt;c0125db8&gt;] (xfs_dir2_node_removename+0x0/0x500) from [&lt;c0120760&=
gt;] (xfs_dir_removename+0x100/0x10c)<br>[&lt;c0120660&gt;] (xfs_dir_remove=
name+0x0/0x10c) from [&lt;c0151be0&gt;] (xfs_remove+0x280/0x424)<br>=A0r6 =
=3D 00000000=A0 r5 =3D 00000000=A0 r4 =3D 0000357C <br>
[&lt;c0151960&gt;] (xfs_remove+0x0/0x424) from [&lt;c015c3a0&gt;] (xfs_vn_u=
nlink+0x30/0x60)<br>[&lt;c015c370&gt;] (xfs_vn_unlink+0x0/0x60) from [&lt;c=
0091c58&gt;] (vfs_unlink+0x70/0xac)<br>=A0r7 =3D C3E79000=A0 r6 =3D C3E5AE5=
8=A0 r5 =3D C4122EB8=A0 r4 =3D 00000000<br>
[&lt;c0091be8&gt;] (vfs_unlink+0x0/0xac) from [&lt;c0093fbc&gt;] (do_unlink=
at+0xcc/0x14c)<br>=A0r6 =3D C4123D78=A0 r5 =3D C4122EB8=A0 r4 =3D 00000000 =
<br>[&lt;c0093ef0&gt;] (do_unlinkat+0x0/0x14c) from [&lt;c0094054&gt;] (sys=
_unlink+0x18/0x1c)<br>
=A0r7 =3D 0000000A=A0 r6 =3D 0000000C=A0 r5 =3D 00000008=A0 r4 =3D BECE6A2B=
<br>[&lt;c009403c&gt;] (sys_unlink+0x0/0x1c) from [&lt;c001de40&gt;] (ret_f=
ast_syscall+0x0/0x2c)<br><br><b>I am using kernel version - 2.6.18.1<br>Pla=
tform - ARM<br>
</b><br>I have searched a lot on this issue, but no solution is available. =
In the FAQS it is mentioned that it&#39;s been fixed 2.6.17.7 onwards. <br>=
But, i keep getting this issue frequently almost every time I do this opera=
tion .<br>
<br>Please provide me any help to sort this issue.<br><br>Thanks &amp; Rega=
rds,<br>Amit Sahrawat<br><br>

--000e0cd24d9edbc11a04766bcb11--


--===============3611969978805709389==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3611969978805709389==--
