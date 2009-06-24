Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5OBu6cS078026 for <xfs@oss.sgi.com>; Wed, 24 Jun 2009 06:56:06 -0500
MIME-Version: 1.0
Date: Wed, 24 Jun 2009 17:26:32 +0530
Message-ID: <409bd82b0906240456m44d95343vdd62f0c3ad7bcdac@mail.gmail.com>
Subject: XFS internal error XFS_WANT_CORRUPTED_GOTO
From: Nitin Arora <nitin.arora.del@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3115329654356858782=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: felixb@sgi.com, xfs-masters@oss.sgi.com, xfs@oss.sgi.com

--===============3115329654356858782==
Content-Type: multipart/alternative; boundary=0016369891d5605f85046d16cca3

--0016369891d5605f85046d16cca3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi,

I am using linux kernel 2.6.18 with XFS support.
I have formatted USB hard drive with XFS. When I try to copy
(i.e. cp 1.avi 2.avi) a big file (size : 1.3 GB) from one
location to another on the same hard drive It corrupts the
hard drive with the following back trace.

*XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1588 of file
fs/xfs/xfs_alloc.c.  Caller 0xc0131a70
[<c0024618>] (dump_stack+0x0/0x14) from [<c0158ae0>]
(xfs_error_report+0x54/0x64)
[<c0158a8c>] (xfs_error_report+0x0/0x64) from [<c012fcf0>]
(xfs_free_ag_extent+0xec/0x768)
[<c012fc04>] (xfs_free_ag_extent+0x0/0x768) from [<c0131a70>]
(xfs_free_extent+0xa0/0xbc)
[<c01319d0>] (xfs_free_extent+0x0/0xbc) from [<c0140dd0>]
(xfs_bmap_finish+0xec/0x184)
r7 = CBF826F8  r6 = 00000000  r5 = 000357B8  r4 = CB7CF708
[<c0140ce4>] (xfs_bmap_finish+0x0/0x184) from [<c01633b8>]
(xfs_itruncate_finish+0x1c8/0x2fc)
[<c01631f0>] (xfs_itruncate_finish+0x0/0x2fc) from [<c01814b0>]
(xfs_inactive+0x278/0x89c)*

I have searched on the internet about and found that many people are facing
the same problem,
But no solution is found.

Can you guide me Or answer the following questions.
*
1. Is there any patch available which solves this problem.
2. If there is no patch available so far then can you give me
  some pointers which will help in solving the problem.*

Thanks in advance

--0016369891d5605f85046d16cca3
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,<br><br>I am using linux kernel 2.6.18 with XFS support.<br>I have forma=
tted USB hard drive with XFS. When I try to copy<br>(i.e. cp 1.avi 2.avi) a=
 big file (size : 1.3 GB) from one<br>location to another on the same hard =
drive It corrupts the<br>
hard drive with the following back trace.<br><br><i>XFS internal error XFS_=
WANT_CORRUPTED_GOTO at line 1588 of file fs/xfs/xfs_alloc.c. =A0Caller 0xc0=
131a70<br>[&lt;c0024618&gt;] (dump_stack+0x0/0x14) from [&lt;c0158ae0&gt;] =
(xfs_error_report+0x54/0x64)<br>
[&lt;c0158a8c&gt;] (xfs_error_report+0x0/0x64) from [&lt;c012fcf0&gt;] (xfs=
_free_ag_extent+0xec/0x768)<br>[&lt;c012fc04&gt;] (xfs_free_ag_extent+0x0/0=
x768) from [&lt;c0131a70&gt;] (xfs_free_extent+0xa0/0xbc)<br>[&lt;c01319d0&=
gt;] (xfs_free_extent+0x0/0xbc) from [&lt;c0140dd0&gt;] (xfs_bmap_finish+0x=
ec/0x184)<br>
 r7 =3D CBF826F8 =A0r6 =3D 00000000 =A0r5 =3D 000357B8 =A0r4 =3D CB7CF708<b=
r>[&lt;c0140ce4&gt;] (xfs_bmap_finish+0x0/0x184) from [&lt;c01633b8&gt;] (x=
fs_itruncate_finish+0x1c8/0x2fc)<br>[&lt;c01631f0&gt;] (xfs_itruncate_finis=
h+0x0/0x2fc) from [&lt;c01814b0&gt;] (xfs_inactive+0x278/0x89c)</i><br>
<br>I have searched on the internet about and found that many people are fa=
cing the same problem,<br>But no solution is found.<br><br>Can you guide me=
 Or answer the following questions.<br><b><br>1. Is there any patch availab=
le which solves this problem.<br>
2. If there is no patch available so far then can you give me<br> =A0 some =
pointers which will help in solving the problem.</b><br><br>Thanks in advan=
ce<br><br><br>

--0016369891d5605f85046d16cca3--


--===============3115329654356858782==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3115329654356858782==--
