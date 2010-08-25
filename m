Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7PEtNv2242864 for <xfs@oss.sgi.com>; Wed, 25 Aug 2010 09:55:23 -0500
Received: from mail-qy0-f174.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 34FA51D7B23E
	for <xfs@oss.sgi.com>; Wed, 25 Aug 2010 07:55:57 -0700 (PDT)
Received: from mail-qy0-f174.google.com (mail-qy0-f174.google.com
	[209.85.216.174]) by cuda.sgi.com with ESMTP id
	shtiWpAwmY8DqyEj for <xfs@oss.sgi.com>;
	Wed, 25 Aug 2010 07:55:57 -0700 (PDT)
Received: by qyk9 with SMTP id 9so4927177qyk.5
	for <xfs@oss.sgi.com>; Wed, 25 Aug 2010 07:55:57 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 25 Aug 2010 09:55:56 -0500
Message-ID: <AANLkTin9BzMOwRy_=6MU-5h-EaEqDWEByxymHUW5jEYS@mail.gmail.com>
Subject: Issue: try to release page which still has unwritten blocks?
From: Mike Gao <ygao.linux@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1951219482701713697=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Christoph Hellwig <hch@infradead.org>

--===============1951219482701713697==
Content-Type: multipart/alternative; boundary=0015175cdf6a398ab4048ea714de

--0015175cdf6a398ab4048ea714de
Content-Type: text/plain; charset=ISO-8859-1

Hi, there,

It seems that the block should be flushed out somewhere before we come to
xfs_aops.c:1295.
This happens when I run xfstest 013. Can anybody take a look at this?

Thanks very much,
Mike

Filesystem "xxx": Disabling barriers, trial barrier write failed
XFS mounting filesystem xxx
BUG: warning at fs/xfs/linux-2.6/xfs_aops.c:1295/xfs_vm_releasepage()
2632fc40:  [<08059358>] dump_stack+0x1c/0x20
2632fc58:  [<08168ba5>] xfs_vm_releasepage+0x51/0x64
2632fc7c:  [<0808e568>] try_to_release_page+0x50/0x60
2632fc90:  [<080bfbdf>] block_invalidatepage+0xb8/0xc2
2632fcb4:  [<08168318>] xfs_vm_invalidatepage+0xe/0x12
2632fcc4:  [<08091e6b>] do_invalidatepage+0x1f/0x23
2632fcd4:  [<08091e89>] truncate_complete_page+0x1a/0x3e
2632fce8:  [<08091f5f>] truncate_inode_pages_range+0xb2/0x245
2632fd4c:  [<08092107>] truncate_inode_pages+0x15/0x1a
2632fd68:  [<080960e5>] vmtruncate+0x64/0xf4
2632fdb0:  [<081633e7>] xfs_setattr+0x387/0x8ac
2632fe24:  [<0816eb42>] xfs_vn_setattr+0x19/0x1d
2632fe38:  [<080b56bc>] notify_change+0xfc/0x27c
2632fe64:  [<080a31bc>] do_truncate+0x53/0x6c
2632feb4:  [<080a336b>] do_sys_truncate+0x196/0x1b7
2632ff38:  [<080a350d>] sys_truncate64+0x11/0x13
2632ff40:  [<0805b045>] handle_syscall+0x81/0x9c
2632ff8c:  [<0806937f>] userspace+0x210/0x267
2632ffdc:  [<0805ad8e>] fork_handler+0x74/0x7c
2632fffc:  [<a55a5a5a>] 0xa55a5a5a

--0015175cdf6a398ab4048ea714de
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>Hi, there,</div><div><br></div><div>It seems that the block should be =
flushed out somewhere before we come to xfs_aops.c:1295.</div><div>This hap=
pens when I run xfstest 013. Can anybody take a look at this?</div><div>
<br></div><div>Thanks very much,</div><div>Mike</div><div><br></div><div>Fi=
lesystem &quot;xxx&quot;: Disabling barriers, trial barrier write failed</d=
iv><div>XFS mounting filesystem xxx</div><div>BUG: warning at fs/xfs/linux-=
2.6/xfs_aops.c:1295/xfs_vm_releasepage()</div>
<div>2632fc40: =A0[&lt;08059358&gt;] dump_stack+0x1c/0x20</div><div>2632fc5=
8: =A0[&lt;08168ba5&gt;] xfs_vm_releasepage+0x51/0x64</div><div>2632fc7c: =
=A0[&lt;0808e568&gt;] try_to_release_page+0x50/0x60</div><div>2632fc90: =A0=
[&lt;080bfbdf&gt;] block_invalidatepage+0xb8/0xc2</div>
<div>2632fcb4: =A0[&lt;08168318&gt;] xfs_vm_invalidatepage+0xe/0x12</div><d=
iv>2632fcc4: =A0[&lt;08091e6b&gt;] do_invalidatepage+0x1f/0x23</div><div>26=
32fcd4: =A0[&lt;08091e89&gt;] truncate_complete_page+0x1a/0x3e</div><div>26=
32fce8: =A0[&lt;08091f5f&gt;] truncate_inode_pages_range+0xb2/0x245</div>
<div>2632fd4c: =A0[&lt;08092107&gt;] truncate_inode_pages+0x15/0x1a</div><d=
iv>2632fd68: =A0[&lt;080960e5&gt;] vmtruncate+0x64/0xf4</div><div>2632fdb0:=
 =A0[&lt;081633e7&gt;] xfs_setattr+0x387/0x8ac</div><div>2632fe24: =A0[&lt;=
0816eb42&gt;] xfs_vn_setattr+0x19/0x1d</div>
<div>2632fe38: =A0[&lt;080b56bc&gt;] notify_change+0xfc/0x27c</div><div>263=
2fe64: =A0[&lt;080a31bc&gt;] do_truncate+0x53/0x6c</div><div>2632feb4: =A0[=
&lt;080a336b&gt;] do_sys_truncate+0x196/0x1b7</div><div>2632ff38: =A0[&lt;0=
80a350d&gt;] sys_truncate64+0x11/0x13</div>
<div>2632ff40: =A0[&lt;0805b045&gt;] handle_syscall+0x81/0x9c</div><div>263=
2ff8c: =A0[&lt;0806937f&gt;] userspace+0x210/0x267</div><div>2632ffdc: =A0[=
&lt;0805ad8e&gt;] fork_handler+0x74/0x7c</div><div>2632fffc: =A0[&lt;a55a5a=
5a&gt;] 0xa55a5a5a</div>
<div><br></div>

--0015175cdf6a398ab4048ea714de--


--===============1951219482701713697==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1951219482701713697==--
