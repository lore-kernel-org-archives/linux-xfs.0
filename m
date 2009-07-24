Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6OB3MBY123518 for <xfs@oss.sgi.com>; Fri, 24 Jul 2009 06:03:23 -0500
Received: from mail-pz0-f186.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E3A4413ECFD6
	for <xfs@oss.sgi.com>; Fri, 24 Jul 2009 04:04:06 -0700 (PDT)
Received: from mail-pz0-f186.google.com (mail-pz0-f186.google.com
	[209.85.222.186]) by cuda.sgi.com with ESMTP id
	J3QlruoHdhzXDrKH for <xfs@oss.sgi.com>;
	Fri, 24 Jul 2009 04:04:06 -0700 (PDT)
Received: by pzk16 with SMTP id 16so1124252pzk.20
	for <xfs@oss.sgi.com>; Fri, 24 Jul 2009 04:04:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1301281514.948741248423723710.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
References: <1983390176.948321248423442558.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
	<1301281514.948741248423723710.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
Date: Fri, 24 Jul 2009 19:04:05 +0800
Message-ID: <b094161c0907240404rb3676ddp626066127f4f5010@mail.gmail.com>
Subject: Re: BUG REPORT: XFS LOG FORWARD COMPATIBILITY PROBLEM
From: Eddy Zhao <eddy.y.zhao@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3616237145505278123=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Lachlan McIlroy <lmcilroy@redhat.com>
Cc: xfs@oss.sgi.com

--===============3616237145505278123==
Content-Type: multipart/alternative; boundary=0016364c5adf0bc3c9046f71901b

--0016364c5adf0bc3c9046f71901b
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

>
> I don't recommend you pull the usb disk out while the filesystem is still
> mounted (if you can avoid it).
>

Doing that to emulate power loss scenario our device might experience.

>
> I would start by looking through the change history for
fs/xfs/xfs_log_recover.c
> and paying particular attention to anything to do with inode
transactions.
>

Not quite familiar with XFS code :(

>
> Or try some intermediate kernels and see if you can narrow the fix down to
a set of
> changes.
>

I'll try to bisect (It will take some time...)

>
> # mount /dev/sda1 /mnt/
> UDF-fs: No VRS found
> XFS mounting filesystem sda1
> Starting XFS recovery on filesystem: sda1 (dev: sda1)
> Filesystem "sda1": xfs_inode_recover: Bad inode magic number, dino ptr
> = 0xc8266700, dino bp = 0xc8281b40, ino = 0

Because XFS log is OK to 2.6.28 system, which means the log is correct in
itself.
Would it be easy for you to debug the problem by compare 2.6.10 log recovery
code fail point and the corresponding 2.6.28 log record?

Thanks
Eddy

--0016364c5adf0bc3c9046f71901b
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<p>&gt;<br>&gt; I don&#39;t recommend you pull the usb disk out while the f=
ilesystem is still<br>&gt; mounted (if you can avoid it).<br>&gt;</p>
<p>Doing that to emulate power loss scenario our device might experience.</=
p>
<p>&gt;<br>&gt; I would start by looking through the change history for fs/=
xfs/xfs_log_recover.c<br>&gt; and paying particular attention to anything t=
o do with inode transactions.=A0 <br>&gt;</p>
<p>Not quite familiar with XFS code :(</p>
<p>&gt;<br>&gt; Or try some intermediate kernels and see if you can narrow =
the fix down to a set of<br>&gt; changes.<br>&gt;</p>
<p>I&#39;ll try to bisect (It will take some time...)</p>
<p>&gt;<br>&gt; # mount /dev/sda1 /mnt/<br>&gt; UDF-fs: No VRS found<br>&gt=
; XFS mounting filesystem sda1<br>&gt; Starting XFS recovery on filesystem:=
 sda1 (dev: sda1)<br>&gt; Filesystem &quot;sda1&quot;: xfs_inode_recover: B=
ad inode magic number, dino ptr<br>
&gt; =3D 0xc8266700, dino bp =3D 0xc8281b40, ino =3D 0</p>
<p>Because XFS log is OK to 2.6.28 system, which means the log is correct i=
n itself.<br>Would it be easy for you to debug the problem by compare 2.6.1=
0 log recovery code fail point and the corresponding 2.6.28 log record?</p>

<p>Thanks<br>Eddy</p>

--0016364c5adf0bc3c9046f71901b--


--===============3616237145505278123==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3616237145505278123==--
