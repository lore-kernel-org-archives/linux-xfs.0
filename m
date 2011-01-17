Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0HCAe9p015779 for <xfs@oss.sgi.com>; Mon, 17 Jan 2011 06:10:41 -0600
Received: from mail-qw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8AA731D32A38
	for <xfs@oss.sgi.com>; Mon, 17 Jan 2011 04:12:57 -0800 (PST)
Received: from mail-qw0-f53.google.com (mail-qw0-f53.google.com
	[209.85.216.53]) by cuda.sgi.com with ESMTP id nnQpp3tpo8lSVTIG
	for <xfs@oss.sgi.com>; Mon, 17 Jan 2011 04:12:57 -0800 (PST)
Received: by qwe5 with SMTP id 5so5013508qwe.26
	for <xfs@oss.sgi.com>; Mon, 17 Jan 2011 04:12:56 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 17 Jan 2011 21:12:54 +0900
Message-ID: <AANLkTin=nqXCVJRgqBuTDx6nxMx1GLiG2DortJG+pz2L@mail.gmail.com>
Subject: XFS internal error xfs_iformat(realtime) even after xfs_repair.
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0630656116095199353=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============0630656116095199353==
Content-Type: multipart/alternative; boundary=0015175ca85a284322049a09b436

--0015175ca85a284322049a09b436
Content-Type: text/plain; charset=ISO-8859-1

Kernel: 2.6.30.9, XFS backported from 2.6.34, xfsprogs-3.0.5

I used a script
1. create some file, directories, symlinks
2. unmount the file system
3. run xfs_bd with blocktrash
4. xfs_xfsrepair -L
5. list "ls -lR"
6. remove all file and directory "rm -rf *

Often during testing I get the below backtrace from kernel during ls, rm
even though I already run xfs_repair on it.
Is it related to xfsrepair or xfs ?. I think xfs_repair must have detected
this problem and corrected it.

There is similar problem already reported by
http://oss.sgi.com/archives/xfs/2010-06/msg00349.html

xfs_repair log
-------------------
xfs_repair -L /dev/sda1
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
done


xfs log duing ls operation
------------------------------------

drwxr-xr-x 2 root 0 6 Jan 1 00:00 9.dir1

drwxr-xr-xFilesystem "sda1": corrupt dinode 8053, has realtime flag set.
Unmount and run xfs_repair.

c803e500: 49 4e a1 ff 02 01 00 00 00 00 00 00 00 00 00 00 IN..............

Filesystem "sda1": XFS internal error xfs_iformat(realtime) at line 356 of
file fs/xfs/xfs_inode.c. Caller 0xc019b328

Backtrace:

[<c00279b0>] (dump_backtrace+0x0/0x110) from [<c02f2bd0>]
(dump_stack+0x18/0x1c)

r6:c8962400 r5:c039db13 r4:00000001 r3:c89d1be8

[<c02f2bb8>] (dump_stack+0x0/0x1c) from [<c018fa54>]
(xfs_error_report+0x4c/0x5c)

[<c018fa08>] (xfs_error_report+0x0/0x5c) from [<c018fac0>]
(xfs_corruption_error+0x5c/0x68)

[<c018fa64>] (xfs_corruption_error+0x0/0x68) from [<c019ae38>]
(xfs_iformat+0x1b4/0x5dc)

r6:c019b328 r5:c8cf0be0 r4:c803e500

[<c019ac84>] (xfs_iformat+0x0/0x5dc) from [<c019b328>]
(xfs_iread+0xc8/0x198)

r9:00001f75 r8:c8962400 r7:00000000 r6:00000000 r5:c803e500

r4:c8cf0be0

[<c019b260>] (xfs_iread+0x0/0x198) from [<c0195294>] (xfs_iget+0x558/0x8c4)

[<c0194d3c>] (xfs_iget+0x0/0x8c4) from [<c01b4b28>] (xfs_lookup+0x128/0x15c)

[<c01b4a00>] (xfs_lookup+0x0/0x15c) from [<c01c1ab4>]
(xfs_vn_lookup+0x48/0x90)

[<c01c1a6c>] (xfs_vn_lookup+0x0/0x90) from [<c00c7da8>]
(do_lookup+0xcc/0x194)

r6:c8c66d6c r5:c89d1e08 r4:c89d1e90

[<c00c7cdc>] (do_lookup+0x0/0x194) from [<c00c9a30>]
(__link_path_walk+0x9b8/0xe68)

[<c00c9078>] (__link_path_walk+0x0/0xe68) from [<c00ca08c>]
(path_walk+0x50/0x9c)

[<c00ca03c>] (path_walk+0x0/0x9c) from [<c00ca258>]
(do_path_lookup+0x138/0x160)

r7:00000001 r6:c89d1e90 r5:c89d0000 r4:c89f2000

[<c00ca120>] (do_path_lookup+0x0/0x160) from [<c00cac64>]
(user_path_at+0x60/0x94)

r7:c89d1f08 r6:ffffff9c r5:c89d1e90 r4:c89f2000

[<c00cac04>] (user_path_at+0x0/0x94) from [<c00c2bb8>]
(vfs_fstatat+0x34/0x64)

r8:c0023528 r7:000000c4 r6:00182320 r5:c89d1f40 r4:c89d1f08

[<c00c2b84>] (vfs_fstatat+0x0/0x64) from [<c00c2c48>] (vfs_lstat+0x24/0x28)

r6:00182320 r5:beb476b8 r4:c89d1f40

[<c00c2c24>] (vfs_lstat+0x0/0x28) from [<c00c2c6c>] (sys_lstat64+0x20/0x3c)

[<c00c2c4c>] (sys_lstat64+0x0/0x3c) from [<c0023380>]
(ret_fast_syscall+0x0/0x2c)

r5:001895a0 r4:00000000

2 root 0 6 Jan 1 00:00 9.dir2

drwxr-xr-x 2 root 0 6 Jan 1 00:00 9.dir3

--0015175ca85a284322049a09b436
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>Kernel: 2.6.30.9, XFS backported from 2.6.34, xfsprogs-3.0.5</div>
<div>=A0</div>
<div>I used a script</div>
<div>1. create some file, directories, symlinks</div>
<div>2. unmount the file system</div>
<div>3. run xfs_bd with blocktrash</div>
<div>4. xfs_xfsrepair -L</div>
<div>5. list &quot;ls -lR&quot;</div>
<div>6. remove all file and directory &quot;rm -rf *</div>
<div>=A0</div>
<div>Often during testing I get the below backtrace from kernel during ls, =
rm even though I already run xfs_repair on it.</div>
<div>Is it related to xfsrepair or xfs ?. I think xfs_repair must have dete=
cted this problem and corrected it.</div>
<div>=A0</div>
<div>There is similar problem already reported by</div>
<div><a href=3D"http://oss.sgi.com/archives/xfs/2010-06/msg00349.html">http=
://oss.sgi.com/archives/xfs/2010-06/msg00349.html</a></div>
<div>=A0</div>
<div>xfs_repair log</div>
<div>-------------------</div>
<div>xfs_repair -L /dev/sda1<br>Phase 1 - find and verify superblock...<br>=
Phase 2 - using internal log<br>=A0=A0=A0=A0=A0=A0=A0 - zero log...<br>=A0=
=A0=A0=A0=A0=A0=A0 - scan filesystem freespace and inode maps...<br>=A0=A0=
=A0=A0=A0=A0=A0 - found root inode chunk<br>
Phase 3 - for each AG...<br>=A0=A0=A0=A0=A0=A0=A0 - scan and clear agi unli=
nked lists...<br>=A0=A0=A0=A0=A0=A0=A0 - process known inodes and perform i=
node discovery...<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 0<br>=A0=A0=A0=A0=A0=
=A0=A0 - agno =3D 1<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 2<br>=A0=A0=A0=A0=
=A0=A0=A0 - agno =3D 3<br>
=A0=A0=A0=A0=A0=A0=A0 - process newly discovered inodes...<br>Phase 4 - che=
ck for duplicate blocks...<br>=A0=A0=A0=A0=A0=A0=A0 - setting up duplicate =
extent list...<br>=A0=A0=A0=A0=A0=A0=A0 - check for inodes claiming duplica=
te blocks...<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 0<br>
=A0=A0=A0=A0=A0=A0=A0 - agno =3D 1<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 2<br=
>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 3<br>Phase 5 - rebuild AG headers and tre=
es...<br>=A0=A0=A0=A0=A0=A0=A0 - reset superblock...<br>Phase 6 - check ino=
de connectivity...<br>=A0=A0=A0=A0=A0=A0=A0 - resetting contents of realtim=
e bitmap and summary inodes<br>
=A0=A0=A0=A0=A0=A0=A0 - traversing filesystem ...<br>=A0=A0=A0=A0=A0=A0=A0 =
- traversal finished ...<br>=A0=A0=A0=A0=A0=A0=A0 - moving disconnected ino=
des to lost+found ...<br>Phase 7 - verify and correct link counts...<br>don=
e</div>
<div>=A0</div>
<div>=A0</div>
<div>xfs log duing ls operation</div>
<div>------------------------------------</div>
<div>=A0</div>
<div><span lang=3D"">drwxr-xr-x 2 root 0 6 Jan 1 00:00 9.dir1</span></div>
<div>
<p>drwxr-xr-xFilesystem &quot;sda1&quot;: corrupt dinode 8053, has realtime=
 flag set. Unmount and run xfs_repair.</p>
<p>c803e500: 49 4e a1 ff 02 01 00 00 00 00 00 00 00 00 00 00 IN............=
..</p>
<p>Filesystem &quot;sda1&quot;: XFS internal error xfs_iformat(realtime) at=
 line 356 of file fs/xfs/xfs_inode.c. Caller 0xc019b328</p>
<p>Backtrace: </p>
<p>[&lt;c00279b0&gt;] (dump_backtrace+0x0/0x110) from [&lt;c02f2bd0&gt;] (d=
ump_stack+0x18/0x1c)</p>
<p>r6:c8962400 r5:c039db13 r4:00000001 r3:c89d1be8</p>
<p>[&lt;c02f2bb8&gt;] (dump_stack+0x0/0x1c) from [&lt;c018fa54&gt;] (xfs_er=
ror_report+0x4c/0x5c)</p>
<p>[&lt;c018fa08&gt;] (xfs_error_report+0x0/0x5c) from [&lt;c018fac0&gt;] (=
xfs_corruption_error+0x5c/0x68)</p>
<p>[&lt;c018fa64&gt;] (xfs_corruption_error+0x0/0x68) from [&lt;c019ae38&gt=
;] (xfs_iformat+0x1b4/0x5dc)</p>
<p>r6:c019b328 r5:c8cf0be0 r4:c803e500</p>
<p>[&lt;c019ac84&gt;] (xfs_iformat+0x0/0x5dc) from [&lt;c019b328&gt;] (xfs_=
iread+0xc8/0x198)</p>
<p>r9:00001f75 r8:c8962400 r7:00000000 r6:00000000 r5:c803e500</p>
<p>r4:c8cf0be0</p>
<p>[&lt;c019b260&gt;] (xfs_iread+0x0/0x198) from [&lt;c0195294&gt;] (xfs_ig=
et+0x558/0x8c4)</p>
<p>[&lt;c0194d3c&gt;] (xfs_iget+0x0/0x8c4) from [&lt;c01b4b28&gt;] (xfs_loo=
kup+0x128/0x15c)</p>
<p>[&lt;c01b4a00&gt;] (xfs_lookup+0x0/0x15c) from [&lt;c01c1ab4&gt;] (xfs_v=
n_lookup+0x48/0x90)</p>
<p>[&lt;c01c1a6c&gt;] (xfs_vn_lookup+0x0/0x90) from [&lt;c00c7da8&gt;] (do_=
lookup+0xcc/0x194)</p>
<p>r6:c8c66d6c r5:c89d1e08 r4:c89d1e90</p>
<p>[&lt;c00c7cdc&gt;] (do_lookup+0x0/0x194) from [&lt;c00c9a30&gt;] (__link=
_path_walk+0x9b8/0xe68)</p>
<p>[&lt;c00c9078&gt;] (__link_path_walk+0x0/0xe68) from [&lt;c00ca08c&gt;] =
(path_walk+0x50/0x9c)</p>
<p>[&lt;c00ca03c&gt;] (path_walk+0x0/0x9c) from [&lt;c00ca258&gt;] (do_path=
_lookup+0x138/0x160)</p>
<p>r7:00000001 r6:c89d1e90 r5:c89d0000 r4:c89f2000</p>
<p>[&lt;c00ca120&gt;] (do_path_lookup+0x0/0x160) from [&lt;c00cac64&gt;] (u=
ser_path_at+0x60/0x94)</p>
<p>r7:c89d1f08 r6:ffffff9c r5:c89d1e90 r4:c89f2000</p>
<p>[&lt;c00cac04&gt;] (user_path_at+0x0/0x94) from [&lt;c00c2bb8&gt;] (vfs_=
fstatat+0x34/0x64)</p>
<p>r8:c0023528 r7:000000c4 r6:00182320 r5:c89d1f40 r4:c89d1f08</p>
<p>[&lt;c00c2b84&gt;] (vfs_fstatat+0x0/0x64) from [&lt;c00c2c48&gt;] (vfs_l=
stat+0x24/0x28)</p>
<p>r6:00182320 r5:beb476b8 r4:c89d1f40</p>
<p>[&lt;c00c2c24&gt;] (vfs_lstat+0x0/0x28) from [&lt;c00c2c6c&gt;] (sys_lst=
at64+0x20/0x3c)</p>
<p>[&lt;c00c2c4c&gt;] (sys_lstat64+0x0/0x3c) from [&lt;c0023380&gt;] (ret_f=
ast_syscall+0x0/0x2c)</p>
<p>r5:001895a0 r4:00000000</p>
<p>2 root 0 6 Jan 1 00:00 9.dir2</p>
<p>drwxr-xr-x 2 root 0 6 Jan 1 00:00 9.dir3</p></div>

--0015175ca85a284322049a09b436--


--===============0630656116095199353==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0630656116095199353==--
