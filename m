Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o942ufS6024806 for <xfs@oss.sgi.com>; Sun, 3 Oct 2010 21:56:42 -0500
Received: from mail-ww0-f51.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B34B818A363B
	for <xfs@oss.sgi.com>; Sun,  3 Oct 2010 19:57:42 -0700 (PDT)
Received: from mail-ww0-f51.google.com (mail-ww0-f51.google.com
	[74.125.82.51]) by cuda.sgi.com with ESMTP id BwwSRdCSQXvZGh26
	for <xfs@oss.sgi.com>; Sun, 03 Oct 2010 19:57:42 -0700 (PDT)
Received: by wwb28 with SMTP id 28so5134281wwb.32
	for <xfs@oss.sgi.com>; Sun, 03 Oct 2010 19:57:42 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 4 Oct 2010 02:57:42 +0000
Message-ID: <AANLkTinH93VekNiAEbJbp43xnG2QPgnr+70nvC771ifG@mail.gmail.com>
Subject: xfs_repair never finishes on lvm partition
From: Knowledge Seeker <knoseeker@googlemail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6878192813770383850=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============6878192813770383850==
Content-Type: multipart/alternative; boundary=0016e648d3d63cfee60491c1b5ed

--0016e648d3d63cfee60491c1b5ed
Content-Type: text/plain; charset=UTF-8

Hi,

I've sent the below message to the Debian Users list and they told me to
send it here.

I'm using Debian Lenny box with 2 hds.

The first one is used by the OS and the second one is another system witch
runs in virtual machine (Virtual Box).
This virtual machine also runs Debian Lenny.

The vm's hd has 2 fdisk partitions, one being LVM.

On the last week, due a power failure, there was a corruption in the file
system of my home xfs partition inside the LVM.
When  I tried to access it, my OS answered that it's not a file or a
directory.
Umounting and mounting again, the error persists.
I tried an xfs_check and it said to mount and umount the filesystem and if
it does not work to run xfs_repair with -L.
I tried it a couple of times and it didn't work, so I ran xfs_repair -L
/dev/mapper/storage-home

On Phase 6, it just freezes in:

bad hash table for directory inode 2147483859 (no data entry): rebuilding
rebuilding directory inode 2147483859

And never finish.
I let running for 2 days long.

When I use ps to see the state:

 2359 pts/0    Sl+    0:11 xfs_repair -L /dev/mapper/storage-home

Interruptible sleep (waiting for an event to complete), multi threaded, in
foreground.

It just stoped when I sent an interrupt signal Ctrl+C.

I tried to do the same from the host machine (real machine), since the HD
could be accessed from it.
The funniest thing is that the xfs_repair did not hang, but when I try to
mount the partition it does not mount the  full partition.
An ls in the /mnt mounting /dev/storage/home (from host machine), doesn't
show the /home, it shows a subdirectory from /home.
And if I start again the Virtual Machine, it prints the same error: /home is
not file or directory.

Weird..


Extra information:
The versions:
# xfs_repair -V
xfs_repair version 2.9.8

#fstab entry
/dev/mapper/storage-home /home           xfs     defaults        0       2

Some one have any idea, how to solve it?

Thanks in advance

Regards

-- 
Knoseeker

--0016e648d3d63cfee60491c1b5ed
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,<br><br>I&#39;ve sent the below message to the Debian Users list and the=
y told me to send it here.<br><br>I&#39;m using Debian Lenny box with 2 hds=
.<br><br>The first one is used by the OS and the second one is another syst=
em witch runs in virtual machine (Virtual Box).<br>
This virtual machine also runs Debian Lenny.<br>
<br>The vm&#39;s hd has 2 fdisk partitions, one being LVM.<br><br>On the la=
st week, due a power failure, there was a corruption in the file system of =
my home xfs partition inside the LVM.<br>When=C2=A0 I tried to access it, m=
y OS answered that it&#39;s not a file or a directory.<br>

Umounting and mounting again, the error persists.<br>I tried an xfs_check a=
nd it said to mount and umount the filesystem and if it does not work to ru=
n xfs_repair with -L.<br>I tried it a couple of times and it didn&#39;t wor=
k, so I ran xfs_repair -L /dev/mapper/storage-home<br>

<br>On Phase 6, it just freezes in:<br><br>bad hash table for directory ino=
de 2147483859 (no data entry): rebuilding<br>rebuilding directory inode 214=
7483859<br><br>And never finish.<br>I let running for 2 days long.<br>
<br>
When I use ps to see the state:<br><br>=C2=A02359 pts/0=C2=A0=C2=A0=C2=A0 S=
l+=C2=A0=C2=A0=C2=A0 0:11 xfs_repair -L /dev/mapper/storage-home<br><br>Int=
erruptible sleep (waiting for an event to complete), multi threaded, in for=
eground.<br><br>It just stoped when I sent an interrupt signal Ctrl+C.<br>

<br>I tried to do the same from the host machine (real machine), since the =
HD could be accessed from it.<br>The
 funniest thing is that the xfs_repair did not hang, but when I try to=20
mount the partition it does not mount the=C2=A0 full partition.<br>
An ls in the /mnt mounting /dev/storage/home (from host machine), doesn&#39=
;t show the /home, it shows a subdirectory from /home.<br>And if I start ag=
ain the Virtual Machine, it prints the same error: /home is not file or dir=
ectory.<br>
<br>
Weird..<br>
<br><br>Extra information:<br>The versions:<br># xfs_repair -V<br>xfs_repai=
r version 2.9.8<br><br>#fstab entry<br>/dev/mapper/storage-home /home=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 xfs=C2=A0=C2=A0=C2=
=A0=C2=A0 defaults=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 2<br><br>Some one have any idea, how to solve it?<=
br>
<br>Thanks in advance<br><br>Regards<br clear=3D"all"><br>-- <br>Knoseeker<=
br>

--0016e648d3d63cfee60491c1b5ed--


--===============6878192813770383850==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6878192813770383850==--
