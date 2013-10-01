Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A0EF829DFC
	for <xfs@oss.sgi.com>; Tue,  1 Oct 2013 14:57:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8E75F30406B
	for <xfs@oss.sgi.com>; Tue,  1 Oct 2013 12:57:44 -0700 (PDT)
Received: from mail-vb0-f54.google.com (mail-vb0-f54.google.com
	[209.85.212.54]) by cuda.sgi.com with ESMTP id LpPGG9AAKDhYsQFm
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 01 Oct 2013 12:57:43 -0700 (PDT)
Received: by mail-vb0-f54.google.com with SMTP id q14so5246377vbe.13
	for <xfs@oss.sgi.com>; Tue, 01 Oct 2013 12:57:42 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 1 Oct 2013 12:57:42 -0700
Message-ID: <CAGa4098ZKd2KQfWMgNXYgLr9LJF8r-MpFgQAn3G-W+ovDGHTAw@mail.gmail.com>
Subject: xfs_repair segfault
From: Viet Nguyen <vietnguyen@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0148442733801126070=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============0148442733801126070==
Content-Type: multipart/alternative; boundary=089e01176ad99cd01604e7b35d99

--089e01176ad99cd01604e7b35d99
Content-Type: text/plain; charset=ISO-8859-1

Hi,

I have a corrupted xfs partition that segfaults when I run xfs_repair, at
the same place every time.

I'm using the latest version of xfs_repair that I am aware of: xfs_repair
version 3.2.0-alpha1

I simply run it as so: xfs_repair -P /dev/sda1

Here's a sample of the last few lines that are spit out:
correcting nextents for inode 8637985
correcting nblocks for inode 8637985, was 198 - counted 0
correcting nextents for inode 8637985, was 1 - counted 0
data fork in regular inode 8637987 claims used block 7847452695
correcting nextents for inode 8637987
correcting nblocks for inode 8637987, was 198 - counted 0
correcting nextents for inode 8637987, was 1 - counted 0
data fork in regular inode 8637999 claims used block 11068974204
correcting nextents for inode 8637999
correcting nblocks for inode 8637999, was 200 - counted 0
correcting nextents for inode 8637999, was 1 - counted 0
data fork in regular inode 8638002 claims used block 11873152787
correcting nextents for inode 8638002
correcting nblocks for inode 8638002, was 201 - counted 0
correcting nextents for inode 8638002, was 1 - counted 0
imap claims a free inode 8638005 is in use, correcting imap and clearing
inode
cleared inode 8638005
imap claims a free inode 8638011 is in use, correcting imap and clearing
inode
cleared inode 8638011
Segmentation fault (core dumped)

It crashes after attempting to clear that same inode every time.

Any advice you can give me on this?

Thanks,
Viet

--089e01176ad99cd01604e7b35d99
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,<div><br></div><div>I have a corrupted xfs partition th=
at segfaults when I run xfs_repair, at the same place every time.</div><div=
><br></div><div>I&#39;m using the latest version of xfs_repair that I am aw=
are of:=A0xfs_repair version 3.2.0-alpha1</div>
<div><br></div><div>I simply run it as so: xfs_repair -P /dev/sda1</div><di=
v><br></div><div>Here&#39;s a sample of the last few lines that are spit ou=
t:</div><div><div>correcting nextents for inode 8637985</div><div>correctin=
g nblocks for inode 8637985, was 198 - counted 0</div>
<div>correcting nextents for inode 8637985, was 1 - counted 0</div><div>dat=
a fork in regular inode 8637987 claims used block 7847452695</div><div>corr=
ecting nextents for inode 8637987</div><div>correcting nblocks for inode 86=
37987, was 198 - counted 0</div>
<div>correcting nextents for inode 8637987, was 1 - counted 0</div><div>dat=
a fork in regular inode 8637999 claims used block 11068974204</div><div>cor=
recting nextents for inode 8637999</div><div>correcting nblocks for inode 8=
637999, was 200 - counted 0</div>
<div>correcting nextents for inode 8637999, was 1 - counted 0</div><div>dat=
a fork in regular inode 8638002 claims used block 11873152787</div><div>cor=
recting nextents for inode 8638002</div><div>correcting nblocks for inode 8=
638002, was 201 - counted 0</div>
<div>correcting nextents for inode 8638002, was 1 - counted 0</div><div>ima=
p claims a free inode 8638005 is in use, correcting imap and clearing inode=
</div><div>cleared inode 8638005</div><div>imap claims a free inode 8638011=
 is in use, correcting imap and clearing inode</div>
<div>cleared inode 8638011</div><div>Segmentation fault (core dumped)</div>=
</div><div><br></div><div>It crashes after attempting to clear that same in=
ode every time.</div><div><br></div><div>Any advice you can give me on this=
?</div>
<div><br></div><div>Thanks,</div><div>Viet</div></div>

--089e01176ad99cd01604e7b35d99--


--===============0148442733801126070==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0148442733801126070==--
