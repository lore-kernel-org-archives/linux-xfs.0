Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p97BkFiL064505 for <xfs@oss.sgi.com>; Fri, 7 Oct 2011 06:46:15 -0500
Received: from mail-yw0-f53.google.com (mail-yw0-f53.google.com
	[209.85.213.53]) by cuda.sgi.com with ESMTP id EKi5A7YpEOvwQK2H
	for <xfs@oss.sgi.com>; Sun, 15 Jan 2012 16:01:43 -0800 (PST)
Received: by yhjj56 with SMTP id j56so1391005yhj.26
	for <xfs@oss.sgi.com>; Sun, 15 Jan 2012 16:01:42 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 15 Jan 2012 19:01:42 -0500
Message-ID: <CAFLer83FBZG9ZCrT2jUZBcTC2a2tx_CDmykyPF4cTP0dbHGw7Q@mail.gmail.com>
Subject: concurrent direct IO write in xfs
From: Zheng Da <zhengda1936@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3554477044117341373=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============3554477044117341373==
Content-Type: multipart/alternative; boundary=20cf303f6d846bbba104b699ebb0

--20cf303f6d846bbba104b699ebb0
Content-Type: text/plain; charset=ISO-8859-1

Hello,

I surprisedly found that writing data to a file (no appending) with direct
IO and with multiple threads has the same performance as a single thread.
Actually, it seems there is only one core is working at a time. In my case,
each time I write a page to a file and the offset is always aligned to the
page size, so there is no overlapping between writes.

According to lockstat, the lock that causes the most waiting time is
xfs_inode.i_lock.
               &(&ip->i_lock)->mr_lock-W:         31568          36170
      0.24       20048.25     7589157.99         130154        3146848
      0.00         217.70     1238310.72
               &(&ip->i_lock)->mr_lock-R:         11251          11886
      0.24       20043.01     2895595.18          46671         526309
      0.00          63.80      264097.96
               -------------------------
                 &(&ip->i_lock)->mr_lock          36170
 [<ffffffffa03be122>] xfs_ilock+0xb2/0x110 [xfs]
                 &(&ip->i_lock)->mr_lock          11886
 [<ffffffffa03be15a>] xfs_ilock+0xea/0x110 [xfs]
               -------------------------
                 &(&ip->i_lock)->mr_lock          38555
 [<ffffffffa03be122>] xfs_ilock+0xb2/0x110 [xfs]
                 &(&ip->i_lock)->mr_lock           9501
 [<ffffffffa03be15a>] xfs_ilock+0xea/0x110 [xfs]

And systemtap shows me that xfs_inode.i_lock is locked exclusively in the
following functions.
0xffffffff81289235 : xfs_file_aio_write_checks+0x45/0x1d0 [kernel]
 0xffffffff812829f4 : __xfs_get_blocks+0x94/0x4a0 [kernel]
 0xffffffff81288b6a : xfs_aio_write_newsize_update+0x3a/0x90 [kernel]
 0xffffffff8129590a : xfs_log_dirty_inode+0x7a/0xe0 [kernel]
xfs_log_dirty_inode is only invoked 3 times when I write 4G data to the
file, so we can completely ignore it. But I'm not sure which of them is the
major cause of the bad write performance or whether they are the cause of
the bad performance. But it seems none of them are the main operations in
direct io write.

It seems to me that the lock might not be necessary for my case. It'll be
nice if I can disable the lock. Or is there any suggestion of achieving
better write performance with multiple threads in XFS?
I tried ext4 and it doesn't perform better than XFS. Does the problem exist
in all FS?

Thanks,
Da

--20cf303f6d846bbba104b699ebb0
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>Hello,</div><div><br></div><div>I surprisedly found that writing data =
to a file (no appending) with direct IO and with multiple threads has the s=
ame performance as a single thread. Actually, it seems there is only one co=
re is working at a time. In my case, each time I write a page to a file and=
 the offset is always aligned to the page size, so there is no overlapping =
between writes.=A0</div>
<div><br></div><div>According to lockstat, the lock that causes the most wa=
iting time is xfs_inode.i_lock.</div><div><div style>=A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0&amp;(&amp;ip-&gt;i_lock)-&gt;mr_lock-W: =A0 =A0 =A0 =A0 31568 =
=A0 =A0 =A0 =A0 =A036170 =A0 =A0 =A0 =A0 =A0 0.24 =A0 =A0 =A0 20048.25 =A0 =
=A0 7589157.99 =A0 =A0 =A0 =A0 130154 =A0 =A0 =A0 =A03146848 =A0 =A0 =A0 =
=A0 =A0 0.00 =A0 =A0 =A0 =A0 217.70 =A0 =A0 1238310.72</div>
<div style>=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&amp;(&amp;ip-&gt;i_lock)-&gt;mr_=
lock-R: =A0 =A0 =A0 =A0 11251 =A0 =A0 =A0 =A0 =A011886 =A0 =A0 =A0 =A0 =A0 =
0.24 =A0 =A0 =A0 20043.01 =A0 =A0 2895595.18 =A0 =A0 =A0 =A0 =A046671 =A0 =
=A0 =A0 =A0 526309 =A0 =A0 =A0 =A0 =A0 0.00 =A0 =A0 =A0 =A0 =A063.80 =A0 =
=A0 =A0264097.96</div>
<div style>=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0-------------------------</div><d=
iv style>=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&amp;(&amp;ip-&gt;i_lock)-&gt;m=
r_lock =A0 =A0 =A0 =A0 =A036170 =A0 =A0 =A0 =A0 =A0[&lt;ffffffffa03be122&gt=
;] xfs_ilock+0xb2/0x110 [xfs]</div><div style>=A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0&amp;(&amp;ip-&gt;i_lock)-&gt;mr_lock =A0 =A0 =A0 =A0 =A011886 =A0 =
=A0 =A0 =A0 =A0[&lt;ffffffffa03be15a&gt;] xfs_ilock+0xea/0x110 [xfs]</div>
<div style>=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0-------------------------</div><d=
iv style>=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&amp;(&amp;ip-&gt;i_lock)-&gt;m=
r_lock =A0 =A0 =A0 =A0 =A038555 =A0 =A0 =A0 =A0 =A0[&lt;ffffffffa03be122&gt=
;] xfs_ilock+0xb2/0x110 [xfs]</div><div style>=A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0&amp;(&amp;ip-&gt;i_lock)-&gt;mr_lock =A0 =A0 =A0 =A0 =A0 9501 =A0 =
=A0 =A0 =A0 =A0[&lt;ffffffffa03be15a&gt;] xfs_ilock+0xea/0x110 [xfs]</div>
</div><div><br></div><div>And systemtap shows me that xfs_inode.i_lock is l=
ocked exclusively in the following functions.=A0</div><div>0xffffffff812892=
35 : xfs_file_aio_write_checks+0x45/0x1d0 [kernel]</div><div>=A00xffffffff8=
12829f4 : __xfs_get_blocks+0x94/0x4a0 [kernel]</div>
<div>=A00xffffffff81288b6a : xfs_aio_write_newsize_update+0x3a/0x90 [kernel=
]</div><div>=A00xffffffff8129590a : xfs_log_dirty_inode+0x7a/0xe0 [kernel]<=
/div><div>xfs_log_dirty_inode is only invoked 3 times when I write 4G data =
to the file, so we can completely ignore it. But I&#39;m not sure which of =
them is the major cause of the bad write performance or whether they are th=
e cause of the bad performance. But it seems none of them are the main oper=
ations in direct io write.</div>
<div><br></div><div><div>It seems to me that the lock might not be necessar=
y for my case. It&#39;ll be nice if I can disable the lock. Or is there any=
 suggestion of achieving better write performance with multiple threads in =
XFS?=A0</div>
</div><div>I tried ext4 and it doesn&#39;t perform better than XFS. Does th=
e problem exist in all FS?</div><div><br></div><div>Thanks,</div><div>Da</d=
iv>

--20cf303f6d846bbba104b699ebb0--


--===============3554477044117341373==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3554477044117341373==--
