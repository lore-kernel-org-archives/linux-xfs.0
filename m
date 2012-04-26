Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3QK09nk091314 for <xfs@oss.sgi.com>; Thu, 26 Apr 2012 15:00:09 -0500
Received: from mail-ob0-f181.google.com (mail-ob0-f181.google.com
	[209.85.214.181]) by cuda.sgi.com with ESMTP id
	xfWsHJVPkJjNfT9Q (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 26 Apr 2012 13:00:07 -0700 (PDT)
Received: by obbun3 with SMTP id un3so4325168obb.26
	for <xfs@oss.sgi.com>; Thu, 26 Apr 2012 13:00:07 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 26 Apr 2012 13:00:06 -0700
Message-ID: <CAK6JqP3ze2pocsgoKUTZx_J6w-Zc9V=StqDnqG0Gx0v5hw=FGQ@mail.gmail.com>
Subject: Problem recovering XFS filesystem
From: Aaron Williams <aaron.w2@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0613317223432422320=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============0613317223432422320==
Content-Type: multipart/alternative; boundary=f46d04478bdd38aed604be9a6fae

--f46d04478bdd38aed604be9a6fae
Content-Type: text/plain; charset=ISO-8859-1

Hi,

I had an issue with my RAID system and am having problems trying to recover
my XFS filesystem.

First of all, I made a copy of it to another device (using dd) and I was
able to recover that image with some data loss by blowing away the log. I
would like to try and recover it properly, however.

I currently have extracted all of the files from the recovered version and
now am trying to recover again without blowing away the log.

When I attempt to mount the filesystem I get the error: mount: Structure
needs cleaning

The kernel reports:
Apr 26 12:53:41 flash kernel: [388563.491665] XFS (sdd1): Mounting
Filesystem
Apr 26 12:53:41 flash kernel: [388563.503667] XFS (sdd1): Starting recovery
(logdev: internal)
Apr 26 12:53:41 flash kernel: [388563.509539] XFS: Internal error
XFS_WANT_CORRUPTED_GOTO at line 1530 of file
/home/abuild/rpmbuild/BUILD/kernel-default-3.1.10/linux-3.1/fs/xfs/xfs_alloc.c.
Caller 0xffffffffa005da7c
Apr 26 12:53:41 flash kernel: [388563.509540]
Apr 26 12:53:41 flash kernel: [388563.509542] Pid: 29146, comm: mount
Tainted: P            3.1.10-22-default #1
Apr 26 12:53:41 flash kernel: [388563.509544] Call Trace:
Apr 26 12:53:41 flash kernel: [388563.509554]  [<ffffffff810042fa>]
dump_trace+0x9a/0x270
Apr 26 12:53:41 flash kernel: [388563.509558]  [<ffffffff815266c3>]
dump_stack+0x69/0x6f
Apr 26 12:53:41 flash kernel: [388563.509589]  [<ffffffffa005b304>]
xfs_free_ag_extent+0x564/0x7c0 [xfs]
Apr 26 12:53:41 flash kernel: [388563.509629]  [<ffffffffa005da7c>]
xfs_free_extent+0xec/0x130 [xfs]
Apr 26 12:53:41 flash kernel: [388563.509670]  [<ffffffffa008b900>]
xlog_recover_process_efi+0x160/0x1b0 [xfs]
Apr 26 12:53:41 flash kernel: [388563.509733]  [<ffffffffa008cbf1>]
xlog_recover_process_efis.isra.8+0x61/0xb0 [xfs]
Apr 26 12:53:41 flash kernel: [388563.509795]  [<ffffffffa00907f0>]
xlog_recover_finish+0x20/0xb0 [xfs]
Apr 26 12:53:41 flash kernel: [388563.509859]  [<ffffffffa009337e>]
xfs_mountfs+0x43e/0x6b0 [xfs]
Apr 26 12:53:41 flash kernel: [388563.509923]  [<ffffffffa00536cd>]
xfs_fs_fill_super+0x1bd/0x270 [xfs]
Apr 26 12:53:41 flash kernel: [388563.509948]  [<ffffffff8114e6a4>]
mount_bdev+0x1b4/0x1f0
Apr 26 12:53:41 flash kernel: [388563.509951]  [<ffffffff8114ef55>]
mount_fs+0x45/0x1d0
Apr 26 12:53:41 flash kernel: [388563.509955]  [<ffffffff81167656>]
vfs_kern_mount+0x66/0xd0
Apr 26 12:53:41 flash kernel: [388563.509958]  [<ffffffff81168a33>]
do_kern_mount+0x53/0x120
Apr 26 12:53:41 flash kernel: [388563.509961]  [<ffffffff8116a4e5>]
do_mount+0x1a5/0x260
Apr 26 12:53:41 flash kernel: [388563.509964]  [<ffffffff8116a98a>]
sys_mount+0x9a/0xf0
Apr 26 12:53:41 flash kernel: [388563.509968]  [<ffffffff81546712>]
system_call_fastpath+0x16/0x1b
Apr 26 12:53:41 flash kernel: [388563.509972]  [<00007f8e22dd397a>]
0x7f8e22dd3979
Apr 26 12:53:41 flash kernel: [388563.509977] XFS (sdd1): Failed to recover
EFIs
Apr 26 12:53:41 flash kernel: [388563.509979] XFS (sdd1): log mount finish
failed

If I run xfs_repair I get the following:

./xfs_repair -v /dev/sdd1
Phase 1 - find and verify superblock...
        - block cache size set to 2282936 entries
Phase 2 - using internal log
        - zero log...
zero_log: head block 6784 tail block 6528
ERROR: The filesystem has valuable metadata changes in a log which needs to
be replayed.  Mount the filesystem to replay the log, and unmount it before
re-running xfs_repair.  If you are unable to mount the filesystem, then use
the -L option to destroy the log and attempt a repair.
Note that destroying the log may cause corruption -- please attempt a mount
of the filesystem before doing this.

I am running the Linux kernel 3.1.10-22 (openSUSE) and xfsprogs 3.1.8.

When I did the repair I had to blow away the log and I had to use xfs_db to
fix some cases where blocks were claimed by multiple files. There was a
brief period where the corruption was occurring and the files were
generally things that are not important. I used xfs_db to identify the
files and deleted the files. After several passes using xfs_repair, xfs_db
and deleting the files I was able to recover the filesystem.

-Aaron

--f46d04478bdd38aed604be9a6fae
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,<br><br>I had an issue with my RAID system and am having problems trying=
 to recover my XFS filesystem.<br><br>First of all, I made a copy of it to =
another device (using dd) and I was able to recover that image with some da=
ta loss by blowing away the log. I would like to try and recover it properl=
y, however.<br>
<br>I currently have extracted all of the files from the recovered version =
and now am trying to recover again without blowing away the log.<br><br>Whe=
n I attempt to mount the filesystem I get the error: mount: Structure needs=
 cleaning<br>
<br>The kernel reports:<br>Apr 26 12:53:41 flash kernel: [388563.491665] XF=
S (sdd1): Mounting Filesystem<br>Apr 26 12:53:41 flash kernel: [388563.5036=
67] XFS (sdd1): Starting recovery (logdev: internal)<br>Apr 26 12:53:41 fla=
sh kernel: [388563.509539] XFS: Internal error XFS_WANT_CORRUPTED_GOTO at l=
ine 1530 of file /home/abuild/rpmbuild/BUILD/kernel-default-3.1.10/linux-3.=
1/fs/xfs/xfs_alloc.c.=A0 Caller 0xffffffffa005da7c<br>
Apr 26 12:53:41 flash kernel: [388563.509540] <br>Apr 26 12:53:41 flash ker=
nel: [388563.509542] Pid: 29146, comm: mount Tainted: P=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 3.1.10-22-default #1<br>Apr 26 12:53:41 flash kernel: [3885=
63.509544] Call Trace:<br>
Apr 26 12:53:41 flash kernel: [388563.509554]=A0 [&lt;ffffffff810042fa&gt;]=
 dump_trace+0x9a/0x270<br>Apr 26 12:53:41 flash kernel: [388563.509558]=A0 =
[&lt;ffffffff815266c3&gt;] dump_stack+0x69/0x6f<br>Apr 26 12:53:41 flash ke=
rnel: [388563.509589]=A0 [&lt;ffffffffa005b304&gt;] xfs_free_ag_extent+0x56=
4/0x7c0 [xfs]<br>
Apr 26 12:53:41 flash kernel: [388563.509629]=A0 [&lt;ffffffffa005da7c&gt;]=
 xfs_free_extent+0xec/0x130 [xfs]<br>Apr 26 12:53:41 flash kernel: [388563.=
509670]=A0 [&lt;ffffffffa008b900&gt;] xlog_recover_process_efi+0x160/0x1b0 =
[xfs]<br>
Apr 26 12:53:41 flash kernel: [388563.509733]=A0 [&lt;ffffffffa008cbf1&gt;]=
 xlog_recover_process_efis.isra.8+0x61/0xb0 [xfs]<br>Apr 26 12:53:41 flash =
kernel: [388563.509795]=A0 [&lt;ffffffffa00907f0&gt;] xlog_recover_finish+0=
x20/0xb0 [xfs]<br>
Apr 26 12:53:41 flash kernel: [388563.509859]=A0 [&lt;ffffffffa009337e&gt;]=
 xfs_mountfs+0x43e/0x6b0 [xfs]<br>Apr 26 12:53:41 flash kernel: [388563.509=
923]=A0 [&lt;ffffffffa00536cd&gt;] xfs_fs_fill_super+0x1bd/0x270 [xfs]<br>A=
pr 26 12:53:41 flash kernel: [388563.509948]=A0 [&lt;ffffffff8114e6a4&gt;] =
mount_bdev+0x1b4/0x1f0<br>
Apr 26 12:53:41 flash kernel: [388563.509951]=A0 [&lt;ffffffff8114ef55&gt;]=
 mount_fs+0x45/0x1d0<br>Apr 26 12:53:41 flash kernel: [388563.509955]=A0 [&=
lt;ffffffff81167656&gt;] vfs_kern_mount+0x66/0xd0<br>Apr 26 12:53:41 flash =
kernel: [388563.509958]=A0 [&lt;ffffffff81168a33&gt;] do_kern_mount+0x53/0x=
120<br>
Apr 26 12:53:41 flash kernel: [388563.509961]=A0 [&lt;ffffffff8116a4e5&gt;]=
 do_mount+0x1a5/0x260<br>Apr 26 12:53:41 flash kernel: [388563.509964]=A0 [=
&lt;ffffffff8116a98a&gt;] sys_mount+0x9a/0xf0<br>Apr 26 12:53:41 flash kern=
el: [388563.509968]=A0 [&lt;ffffffff81546712&gt;] system_call_fastpath+0x16=
/0x1b<br>
Apr 26 12:53:41 flash kernel: [388563.509972]=A0 [&lt;00007f8e22dd397a&gt;]=
 0x7f8e22dd3979<br>Apr 26 12:53:41 flash kernel: [388563.509977] XFS (sdd1)=
: Failed to recover EFIs<br>Apr 26 12:53:41 flash kernel: [388563.509979] X=
FS (sdd1): log mount finish failed<br>
<br>If I run xfs_repair I get the following:<br><br>./xfs_repair -v /dev/sd=
d1 <br>Phase 1 - find and verify superblock...<br>=A0=A0=A0=A0=A0=A0=A0 - b=
lock cache size set to 2282936 entries<br>Phase 2 - using internal log<br>=
=A0=A0=A0=A0=A0=A0=A0 - zero log...<br>
zero_log: head block 6784 tail block 6528<br>ERROR: The filesystem has valu=
able metadata changes in a log which needs to<br>be replayed.=A0 Mount the =
filesystem to replay the log, and unmount it before<br>re-running xfs_repai=
r.=A0 If you are unable to mount the filesystem, then use<br>
the -L option to destroy the log and attempt a repair.<br>Note that destroy=
ing the log may cause corruption -- please attempt a mount<br>of the filesy=
stem before doing this.<br><br>I am running the Linux kernel 3.1.10-22 (ope=
nSUSE) and xfsprogs 3.1.8.<br>
<br>When I did the repair I had to blow away the log and I had to use xfs_d=
b to fix some cases where blocks were claimed by multiple files. There was =
a brief period where the corruption was occurring and the files were genera=
lly things that are not important. I used xfs_db to identify the files and =
deleted the files. After several passes using xfs_repair, xfs_db and deleti=
ng the files I was able to recover the filesystem.<br>
<br>-Aaron<br>

--f46d04478bdd38aed604be9a6fae--


--===============0613317223432422320==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0613317223432422320==--
