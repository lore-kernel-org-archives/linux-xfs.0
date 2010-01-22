Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0M1enMR104105 for <xfs@oss.sgi.com>; Thu, 21 Jan 2010 19:40:49 -0600
Received: from sj-iport-5.cisco.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2048A181CC3
	for <xfs@oss.sgi.com>; Thu, 21 Jan 2010 17:41:50 -0800 (PST)
Received: from sj-iport-5.cisco.com (sj-iport-5.cisco.com [171.68.10.87]) by
	cuda.sgi.com with ESMTP id EtC9bjxvOqmwXy42 for
	<xfs@oss.sgi.com>; Thu, 21 Jan 2010 17:41:50 -0800 (PST)
Received: from xbh-sjc-231.amer.cisco.com (xbh-sjc-231.cisco.com
	[128.107.191.100])
	by sj-core-4.cisco.com (8.13.8/8.14.3) with ESMTP id o0M1fntU021089
	for <xfs@oss.sgi.com>; Fri, 22 Jan 2010 01:41:49 GMT
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: 2.6.23 kdb in xfs_bmbt_get_block with unwritten extents
Date: Thu, 21 Jan 2010 17:41:48 -0800
Message-ID: <212AA327A3557741A058E787E06188731FA4AA@xmb-sjc-219.amer.cisco.com>
From: "Richard Troxell (rtroxell)" <rtroxell@cisco.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0817199628995247091=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: "Richard Troxell (rtroxell)" <rtroxell@cisco.com>

This is a multi-part message in MIME format.

--===============0817199628995247091==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01CA9B04.105572C5"

This is a multi-part message in MIME format.

------_=_NextPart_001_01CA9B04.105572C5
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hello All,

I am getting random kdbs when creating preallocated files that are =
excessively 'holey' (ex: 500MB+ file with alternating 4K written 4K =
unwritten extents). Creating such files is not my intention, and is =
being addressing in the userspace writer. That said, I am still =
concerned with running into kdb.

I am currently running 2.6.23.9, and have done some digging through the =
changelogs, but cant seem to find a match. Also, 2.6.24 seems to have a =
massive rewrite in this area, which significantly limits the scope that =
I can search.

The cause of the crash is a straigtforward NULL derference in =
xfs_bmap_btree.c:xfs_bmbt_get_block(), but I suspect the root cause is =
going to be some complex condition that corrupts the cursor...

if (level < cur->bc_nlevels - 1) {
	*bpp =3D cur->bc_bufs[level];           <----- cur->bc_bufs[level] =
=3D=3D NULL
	rval =3D XFS_BUF_TO_BMBT_BLOCK(*bpp);   <----- BAM! NULL dereferenced
}

Scanning the source, I see numerous instances of this same unchecked =
dereference from bc_bufs, but so far I have only hit this one condition.

Here is the call trace...

 [<ffffffff8034fec0>] xfs_bmbt_increment+0xb0/0x2c0
 [<ffffffff80346c4b>] xfs_bmap_add_extent_unwritten_real+0x5eb/0xd50
 [<ffffffff80349c72>] xfs_bmap_add_extent+0x152/0x480
 [<ffffffff8038f8d2>] kmem_zone_zalloc+0x32/0x50
 [<ffffffff8034cd40>] xfs_bmapi+0xbe0/0x11f0
 [<ffffffff806ea404>] _spin_unlock+0x14/0x40
 [<ffffffff806ea4cd>] _spin_lock+0x1d/0x90
 [<ffffffff80375e63>] xfs_log_reserve+0xa3/0x100
 [<ffffffff806ea975>] _spin_unlock_irq+0x15/0x40
 [<ffffffff806e9fa6>] __down_write_nested+0x96/0xa0
 [<ffffffff80381ec9>] xfs_trans_reserve+0xa9/0x1f0
 [<ffffffff8037274a>] xfs_iomap_write_unwritten+0x14a/0x230
 [<ffffffff8037166e>] xfs_iomap+0x2fe/0x390
 [<ffffffff806ea3c6>] __lock_text_start+0x16/0x40
 [<ffffffff8038fb20>] xfs_end_bio_unwritten+0x0/0x50
 [<ffffffff8038fb51>] xfs_end_bio_unwritten+0x31/0x50
 [<ffffffff802429a3>] run_workqueue+0x73/0x130
 [<ffffffff80242afc>] worker_thread+0x9c/0xf0
 [<ffffffff80246cd0>] autoremove_wake_function+0x0/0x30
 [<ffffffff80246cd0>] autoremove_wake_function+0x0/0x30
 [<ffffffff80242a60>] worker_thread+0x0/0xf0
 [<ffffffff8024660c>] kthread+0x6c/0xa0
 [<ffffffff8020c9a8>] child_rip+0xa/0x12
 [<ffffffff802465a0>] kthread+0x0/0xa0
 [<ffffffff8020c99e>] child_rip+0x0/0x12

Given the trace, I assume that if I avoid all B+tree managed unwritten =
extents, I can avoid the crash. However avoiding such files completely =
seems a bit unrealistic, as I have the need to store files with a =
reasonable amount of holes...

Thanks,
Richard

------_=_NextPart_001_01CA9B04.105572C5
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">
<HTML>
<HEAD>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; =
charset=3Diso-8859-1">
<META NAME=3D"Generator" CONTENT=3D"MS Exchange Server version =
6.5.7654.12">
<TITLE>2.6.23 kdb in xfs_bmbt_get_block with unwritten extents</TITLE>
</HEAD>
<BODY>
<!-- Converted from text/plain format -->

<P><FONT SIZE=3D2>Hello All,<BR>
<BR>
I am getting random kdbs when creating preallocated files that are =
excessively 'holey' (ex: 500MB+ file with alternating 4K written 4K =
unwritten extents). Creating such files is not my intention, and is =
being addressing in the userspace writer. That said, I am still =
concerned with running into kdb.<BR>
<BR>
I am currently running 2.6.23.9, and have done some digging through the =
changelogs, but cant seem to find a match. Also, 2.6.24 seems to have a =
massive rewrite in this area, which significantly limits the scope that =
I can search.<BR>
<BR>
The cause of the crash is a straigtforward NULL derference in =
xfs_bmap_btree.c:xfs_bmbt_get_block(), but I suspect the root cause is =
going to be some complex condition that corrupts the cursor...<BR>
<BR>
if (level &lt; cur-&gt;bc_nlevels - 1) {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *bpp =3D =
cur-&gt;bc_bufs[level];&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; &lt;----- cur-&gt;bc_bufs[level] =3D=3D NULL<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rval =3D =
XFS_BUF_TO_BMBT_BLOCK(*bpp);&nbsp;&nbsp; &lt;----- BAM! NULL =
dereferenced<BR>
}<BR>
<BR>
Scanning the source, I see numerous instances of this same unchecked =
dereference from bc_bufs, but so far I have only hit this one =
condition.<BR>
<BR>
Here is the call trace...<BR>
<BR>
&nbsp;[&lt;ffffffff8034fec0&gt;] xfs_bmbt_increment+0xb0/0x2c0<BR>
&nbsp;[&lt;ffffffff80346c4b&gt;] =
xfs_bmap_add_extent_unwritten_real+0x5eb/0xd50<BR>
&nbsp;[&lt;ffffffff80349c72&gt;] xfs_bmap_add_extent+0x152/0x480<BR>
&nbsp;[&lt;ffffffff8038f8d2&gt;] kmem_zone_zalloc+0x32/0x50<BR>
&nbsp;[&lt;ffffffff8034cd40&gt;] xfs_bmapi+0xbe0/0x11f0<BR>
&nbsp;[&lt;ffffffff806ea404&gt;] _spin_unlock+0x14/0x40<BR>
&nbsp;[&lt;ffffffff806ea4cd&gt;] _spin_lock+0x1d/0x90<BR>
&nbsp;[&lt;ffffffff80375e63&gt;] xfs_log_reserve+0xa3/0x100<BR>
&nbsp;[&lt;ffffffff806ea975&gt;] _spin_unlock_irq+0x15/0x40<BR>
&nbsp;[&lt;ffffffff806e9fa6&gt;] __down_write_nested+0x96/0xa0<BR>
&nbsp;[&lt;ffffffff80381ec9&gt;] xfs_trans_reserve+0xa9/0x1f0<BR>
&nbsp;[&lt;ffffffff8037274a&gt;] =
xfs_iomap_write_unwritten+0x14a/0x230<BR>
&nbsp;[&lt;ffffffff8037166e&gt;] xfs_iomap+0x2fe/0x390<BR>
&nbsp;[&lt;ffffffff806ea3c6&gt;] __lock_text_start+0x16/0x40<BR>
&nbsp;[&lt;ffffffff8038fb20&gt;] xfs_end_bio_unwritten+0x0/0x50<BR>
&nbsp;[&lt;ffffffff8038fb51&gt;] xfs_end_bio_unwritten+0x31/0x50<BR>
&nbsp;[&lt;ffffffff802429a3&gt;] run_workqueue+0x73/0x130<BR>
&nbsp;[&lt;ffffffff80242afc&gt;] worker_thread+0x9c/0xf0<BR>
&nbsp;[&lt;ffffffff80246cd0&gt;] autoremove_wake_function+0x0/0x30<BR>
&nbsp;[&lt;ffffffff80246cd0&gt;] autoremove_wake_function+0x0/0x30<BR>
&nbsp;[&lt;ffffffff80242a60&gt;] worker_thread+0x0/0xf0<BR>
&nbsp;[&lt;ffffffff8024660c&gt;] kthread+0x6c/0xa0<BR>
&nbsp;[&lt;ffffffff8020c9a8&gt;] child_rip+0xa/0x12<BR>
&nbsp;[&lt;ffffffff802465a0&gt;] kthread+0x0/0xa0<BR>
&nbsp;[&lt;ffffffff8020c99e&gt;] child_rip+0x0/0x12<BR>
<BR>
Given the trace, I assume that if I avoid all B+tree managed unwritten =
extents, I can avoid the crash. However avoiding such files completely =
seems a bit unrealistic, as I have the need to store files with a =
reasonable amount of holes...<BR>
<BR>
Thanks,<BR>
Richard<BR>
</FONT>
</P>

</BODY>
</HTML>
------_=_NextPart_001_01CA9B04.105572C5--


--===============0817199628995247091==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0817199628995247091==--
