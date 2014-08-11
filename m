Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1C8E17F55
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2014 17:01:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9BF33AC002
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2014 15:01:33 -0700 (PDT)
Received: from mail-we0-f179.google.com (mail-we0-f179.google.com
	[74.125.82.179]) by cuda.sgi.com with ESMTP id oF9VxXVcUBpGACNG
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 11 Aug 2014 15:01:31 -0700 (PDT)
Received: by mail-we0-f179.google.com with SMTP id u57so9167000wes.38
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2014 15:01:30 -0700 (PDT)
Received: from minas-tirith.valinor (177.Red-79-159-63.staticIP.rima-tde.net.
	[79.159.63.177]) by mx.google.com with ESMTPSA id
	ex2sm48438588wic.24.2014.08.11.15.01.29 for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Mon, 11 Aug 2014 15:01:30 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by minas-tirith.valinor (Postfix) with ESMTP id BF2C5183EEA
	for <xfs@oss.sgi.com>; Tue, 12 Aug 2014 00:01:27 +0200 (CEST)
Date: Tue, 12 Aug 2014 00:01:16 +0200 (CEST)
From: "Carlos E. R." <carlos.e.r@opensuse.org>
Subject: Re: Subject : Happened again, 20140811 -- Got "Internal error
	XFS_WANT_CORRUPTED_GOTO". Filesystem needs reformatting to correct
	issue.
In-Reply-To: <53E938CC.4010103@sgi.com>
Message-ID: <alpine.LSU.2.11.1408112351020.17839@minas-tirith.valinor>
References: <alpine.LSU.2.11.1407021104480.9881@Telcontar.valinor>
	<alpine.LSU.2.11.1408111559280.2447@minas-tirith.valinor>
	<20140811144359.GA10217@laptop.bfoster>
	<alpine.LSU.2.11.1408111657160.7326@minas-tirith.valinor>
	<alpine.LSU.2.11.1408111843150.7326@minas-tirith.valinor>
	<alpine.LSU.2.11.1408112320040.17839@minas-tirith.valinor>
	<53E938CC.4010103@sgi.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-1463779071-1124162502-1407793872=:17839"
Content-ID: <alpine.LSU.2.11.1408112355480.17839@minas-tirith.valinor>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: XFS mailing list <xfs@oss.sgi.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463779071-1124162502-1407793872=:17839
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LSU.2.11.1408112351361.17839@minas-tirith.valinor>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Content-ID: <alpine.LSU.2.11.1408112355480.17839@minas-tirith.valinor>


El 2014-08-11 a las 16:42 -0500, Mark Tinguely escribió:
> On 08/11/14 16:31, Carlos E. R. wrote:


>> Does that give any ideas?


> Which version of Linux?

Telcontar:~ # cat /etc/os-release
NAME=openSUSE
VERSION="13.1 (Bottle)"
VERSION_ID="13.1"
PRETTY_NAME="openSUSE 13.1 (Bottle) (x86_64)"
ID=opensuse
ANSI_COLOR="0;32"
CPE_NAME="cpe:/o:opensuse:opensuse:13.1"
BUG_REPORT_URL="https://bugs.opensuse.org"
HOME_URL="https://opensuse.org/"
ID_LIKE="suse"
Telcontar:~ #
Telcontar:~ # uname -a
Linux Telcontar 3.11.10-17-desktop #1 SMP PREEMPT Mon Jun 16 15:28:13 UTC 2014 (fba7c1f) x86_64 x86_64 x86_64 GNU/Linux
Telcontar:~ # rpm -q xfsprogs
xfsprogs-3.2.1-40.1.x86_64



> Did you get a metadata dump before the xfs_repair?

Yes, sure. I said so on another post. I'm on the process of starting up 
the machine, when I noticed that error:

xfs_metadump: invalid dqblk inode number (-1)


being the first time I see that error, I'm wondering if going ahead with 
mounting and using, as explained on other posts today, or wait for 
different instructions from you people.

I'll try meanwhile to upload the metadata files using another machine.

- -- 
Cheers
        Carlos E. R.

        (from 13.1 x86_64 "Bottle" (Minas Tirith))
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iF4EAREIAAYFAlPpPTcACgkQja8UbcUWM1wm3wD+KTezrh+/SRAFFIVGCeJcHkgE
MeJ5PMzceqDlUDOb4Q0A/jO8O5TkHCS1oDqI3zfdIExTUiel1GAcbMDNkk501Cf+
=6qE9
-----END PGP SIGNATURE-----
---1463779071-1124162502-1407793872=:17839
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

---1463779071-1124162502-1407793872=:17839--
