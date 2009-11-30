Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAU5HCwb188578 for <xfs@oss.sgi.com>; Sun, 29 Nov 2009 23:17:12 -0600
Received: from mail-pw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C304EBE3DD
	for <xfs@oss.sgi.com>; Sun, 29 Nov 2009 21:17:41 -0800 (PST)
Received: from mail-pw0-f53.google.com (mail-pw0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id IJM4P6uTC3lJJdHJ
	for <xfs@oss.sgi.com>; Sun, 29 Nov 2009 21:17:41 -0800 (PST)
Received: by pwj11 with SMTP id 11so1969607pwj.12
	for <xfs@oss.sgi.com>; Sun, 29 Nov 2009 21:17:41 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 30 Nov 2009 10:47:41 +0530
Message-ID: <409bd82b0911292117n5aa11961u86e787d20acbd2b3@mail.gmail.com>
Subject: Writing journal only in Big Endian format
From: Nitin Arora <nitin.arora.del@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3764827057090968491=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, "sandeen-xfs@sandeen.net" <sandeen-xfs@sandeen.net>, "p.mironchik@velesys.com" <p.mironchik@velesys.com>, "hch@xfs.org" <hch@xfs.org>

--===============3764827057090968491==
Content-Type: multipart/alternative; boundary=0016e64b073eba9e5604798fc23f

--0016e64b073eba9e5604798fc23f
Content-Type: text/plain; charset=ISO-8859-1

Hello,

We are using XFS (Kernel 2.6.18) and facing a problem.
When any XFS partition is plugged out from a little endian machine and
plugged in to a big endian machine,
it cannot be mounted and gives the following error.

FAT: utf8 is not a recommended IO charset for FAT filesystems, filesystem
will be case sensitive!

FAT: bogus number of FAT structure

VFS: Can't find a valid FAT filesystem on dev sda1.

VFS: Can't find ext3 filesystem on dev sda1.

XFS mounting filesystem sda1

Starting XFS recovery on filesystem: sda1 (logdev: internal)

XFS: dirty log written in incompatible format - can't recover

XFS: log mount/recovery failed: error 5

XFS: log mount failed


Mounting problem goes away after doing *"xfs_repair -L /dev/sdb2"

*The problem is that big endian machine cannot recognize the journal which
was written in
little endian format by the little endian machine and once the journal is
zerod out it can be mouted.

Now the solution to above problem seems writing journal always in big endian
format.

Please suggest me, Is there any design limitation in XFS for this.
Is it okay and feasible to implement it if yes then please give some
pointers so that it can be implemented, under some
suitable compile time switch.

Thanks in advance...

Regards
Nitin Arora

--0016e64b073eba9e5604798fc23f
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello,<br><br>We are using XFS (Kernel 2.6.18) and facing a problem.<br>Whe=
n any XFS partition is plugged out from a little endian machine and plugged=
 in to a big endian machine,<br>it cannot be mounted and gives the followin=
g error.<br>
<br><p><span lang=3D"EN-US">FAT: utf8 is not a recommended IO charset for F=
AT=20
filesystems, filesystem will be case sensitive!</span></p>
<p><span lang=3D"EN-US">FAT: bogus number of FAT structure</span></p>
<p><span lang=3D"EN-US">VFS: Can&#39;t find a valid FAT filesystem on dev=
=20
sda1.</span></p>
<p><span lang=3D"EN-US">VFS: Can&#39;t find ext3 filesystem on dev=20
sda1.</span></p>
<p><span lang=3D"EN-US">XFS mounting filesystem sda1</span></p>
<p><span lang=3D"EN-US">Starting XFS recovery on filesystem: sda1 (logdev:=
=20
internal)</span></p>
<p><span style=3D"color: red;" lang=3D"EN-US">XFS: dirty log written in inc=
ompatible=20
format - can&#39;t recover</span></p>
<p><span lang=3D"EN-US">XFS: log mount/recovery failed: error=20
5</span></p>
<p><span lang=3D"EN-US">XFS: log mount failed</span></p><br><br>Mounting pr=
oblem goes away after doing <i>&quot;xfs_repair -L /dev/sdb2&quot;<br><br><=
/i>The problem is that big endian machine cannot recognize the journal whic=
h was written in <br>
little endian format by the little endian machine and once the journal is z=
erod out it can be mouted.<br><br>Now the solution to above problem seems w=
riting journal always in big endian format.<br><br>Please suggest me, Is th=
ere any design limitation in XFS for this.<br>
Is it okay and feasible to implement it if yes then please give some pointe=
rs so that it can be implemented, under some <br>suitable compile time swit=
ch.<br><br>Thanks in advance...<br><br>Regards<br>Nitin Arora<br>

--0016e64b073eba9e5604798fc23f--


--===============3764827057090968491==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3764827057090968491==--
