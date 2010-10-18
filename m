Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9IDfDJC233698 for <xfs@oss.sgi.com>; Mon, 18 Oct 2010 08:41:13 -0500
Received: from mail-gw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A9DA21E7C55D
	for <xfs@oss.sgi.com>; Mon, 18 Oct 2010 06:42:25 -0700 (PDT)
Received: from mail-gw0-f53.google.com (mail-gw0-f53.google.com
	[74.125.83.53]) by cuda.sgi.com with ESMTP id haIQQn288MywCs9T
	for <xfs@oss.sgi.com>; Mon, 18 Oct 2010 06:42:25 -0700 (PDT)
Received: by gwaa11 with SMTP id a11so534873gwa.26
	for <xfs@oss.sgi.com>; Mon, 18 Oct 2010 06:42:25 -0700 (PDT)
MIME-Version: 1.0
From: Angelo McComis <angelo@mccomis.com>
Date: Mon, 18 Oct 2010 09:42:04 -0400
Message-ID: <AANLkTi=w1o8EF6-M7o8Qi9VpY-10m+MCR8U+K1_Aze=g@mail.gmail.com>
Subject: XFS use within multi-threaded apps
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2378262911445618830=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============2378262911445618830==
Content-Type: multipart/alternative; boundary=000e0cd6ed4cb202fc0492e45863

--000e0cd6ed4cb202fc0492e45863
Content-Type: text/plain; charset=UTF-8

All:

Apologies but I am new to this list, and somewhat new to XFS.

I have a use case where I'd like to forward the use of XFS. This is for
large (multi-GB, say anywhere from 5GB to 300GB) individual files, such as
what you'd see under a database's data file / tablespace.

My database vendor (who, coincidentally markets their own filesystems and
operating systems) says that there are certain problems under XFS with
specific mention of corruption issues, if a single root or the metadata
become corrupted, the entire filesystem is gone, and it has performance
issues on a multi-threaded workload, caused by the single root filesystem
for metadata becoming a bottleneck.

This feedback from the vendor is surely taken with a grain of salt as they
have marketing motivations of their own product to consider.

Surely, something like corruption and bottlenecks under heavy load /
multi-threaded use would be a bug that would be addressed, right?

And surely, something like a BTree structure, with a root node, journaled
metadata, etc. would be inherent in other filesystem choices as well, right?

The vendor, in the end, did recommend ext4, but ext4 is not in my mainline
Linux kernel as anything beyond "tech preview" at this point.

Thanks in advance for any/all feedback.

Angelo

--000e0cd6ed4cb202fc0492e45863
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<font color=3D"#000066"><font size=3D"2"><font face=3D"trebuchet ms,sans-se=
rif">All:<br><br>Apologies but I am new to this list, and somewhat new to X=
FS.<br><br>I have a use case where I&#39;d like to forward the use of XFS. =
This is for large (multi-GB, say anywhere from 5GB to 300GB) individual fil=
es, such as what you&#39;d see under a database&#39;s data file / tablespac=
e. <br>

<br>My database vendor (who, coincidentally markets their own filesystems a=
nd operating systems) says that there are certain problems under XFS with s=
pecific mention of corruption issues, if a single root or the metadata beco=
me corrupted, the entire filesystem is gone, and it has performance issues =
on a multi-threaded workload, caused by the single root filesystem for meta=
data becoming a bottleneck.<br>

<br>This feedback from the vendor is surely taken with a grain of salt as t=
hey have marketing motivations of their own product to consider. <br><br>Su=
rely, something like corruption and bottlenecks under heavy load / multi-th=
readed use would be a bug that would be addressed, right? <br>

=C2=A0<br>And surely, something like a BTree structure, with a root node, j=
ournaled metadata, etc. would be inherent in other filesystem choices as we=
ll, right?<br><br>The vendor, in the end, did recommend ext4, but ext4 is n=
ot in my mainline Linux kernel as anything beyond &quot;tech preview&quot; =
at this point.=C2=A0 <br>

<br>Thanks in advance for any/all feedback.<br><br>Angelo <br></font></font=
></font>

--000e0cd6ed4cb202fc0492e45863--


--===============2378262911445618830==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2378262911445618830==--
