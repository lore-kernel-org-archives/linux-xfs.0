Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p06DnLGb070284 for <xfs@oss.sgi.com>; Thu, 6 Jan 2011 07:49:21 -0600
Received: from mail-fx0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 717694F55C9
	for <xfs@oss.sgi.com>; Thu,  6 Jan 2011 05:51:29 -0800 (PST)
Received: from mail-fx0-f53.google.com (mail-fx0-f53.google.com
	[209.85.161.53]) by cuda.sgi.com with ESMTP id 5PFV2LEtIfuuBFZH
	for <xfs@oss.sgi.com>; Thu, 06 Jan 2011 05:51:29 -0800 (PST)
Received: by fxm11 with SMTP id 11so10684435fxm.26
	for <xfs@oss.sgi.com>; Thu, 06 Jan 2011 05:51:29 -0800 (PST)
MIME-Version: 1.0
From: Phil Karn <karn@philkarn.net>
Date: Thu, 6 Jan 2011 05:51:08 -0800
Message-ID: <AANLkTikSZVTR0qkhewedk1oSeMn1e_fJeB4i_NGLzZ6P@mail.gmail.com>
Subject: changing from internal to external log?
Reply-To: karn@ka9q.net
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1550624021826121566=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============1550624021826121566==
Content-Type: multipart/alternative; boundary=00248c11dcc96bff5904992dcc6a

--00248c11dcc96bff5904992dcc6a
Content-Type: text/plain; charset=UTF-8

Is there any way to reconfigure an existing XFS file system, originally set
up with an internal log, to use an external log device? I have an existing
XFS file system on a 4x2 TB RAID-5 array, and I'd really rather not have to
take a week to load it all over again.

I have since added a SSD to that system and would like to try using a
partition on it as an external logfile for the RAID-5 filesystem. I've been
playing with various test XFS filesystems and have discovered, as I'm sure
many others have before me, that the journal is a big bottleneck when
creating or deleting lots of files.

I've even tried fallocating a couple of gig from my XFS file system to a
loopback device with reiserfs. Extracting and building the Linux kernel tree
goes quite a bit faster than using the XFS file system directly, even after
playing with all the usual mount options. The only way I've found to make
native XFS equally fast seems to be an external journal on a fast device.

--00248c11dcc96bff5904992dcc6a
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Is there any way to reconfigure an existing XFS file system, originally set=
 up with an internal log, to use an external log device? I have an existing=
 XFS file system on a 4x2 TB RAID-5 array, and I&#39;d really rather not ha=
ve to take a week to load it all over again.<br>

<br>I have since added a SSD to that system and would like to try using a p=
artition on it as an external logfile for the RAID-5 filesystem. I&#39;ve b=
een playing with various test XFS filesystems and have discovered, as I&#39=
;m sure many others have before me, that the journal is a big bottleneck wh=
en creating or deleting lots of files.<br>

<br>I&#39;ve even tried fallocating a couple of gig from my XFS file system=
 to a loopback device with reiserfs. Extracting and building the Linux kern=
el tree goes quite a bit faster than using the XFS file system directly, ev=
en after playing with all the usual mount options. The only way I&#39;ve fo=
und to make native XFS equally fast seems to be an external journal on a fa=
st device.<br>

<br><br><br>

--00248c11dcc96bff5904992dcc6a--


--===============1550624021826121566==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1550624021826121566==--
