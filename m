Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3844A7F3F
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2014 09:23:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0C12C304062
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2014 07:23:22 -0700 (PDT)
Received: from mail-we0-f177.google.com (mail-we0-f177.google.com
	[74.125.82.177]) by cuda.sgi.com with ESMTP id VYrTUFTDFDFBoj1d
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 11 Aug 2014 07:23:17 -0700 (PDT)
Received: by mail-we0-f177.google.com with SMTP id w62so8468046wes.8
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2014 07:23:16 -0700 (PDT)
Received: from minas-tirith.valinor (177.Red-79-159-63.staticIP.rima-tde.net.
	[79.159.63.177])
	by mx.google.com with ESMTPSA id e3sm2038756wjp.4.2014.08.11.07.23.14
	for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Mon, 11 Aug 2014 07:23:15 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by minas-tirith.valinor (Postfix) with ESMTP id E1C1918245D
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2014 16:23:10 +0200 (CEST)
Date: Mon, 11 Aug 2014 16:23:01 +0200 (CEST)
From: "Carlos E. R." <carlos.e.r@opensuse.org>
Subject: Subject : Happened again, 20140811 -- Got "Internal error
	XFS_WANT_CORRUPTED_GOTO". Filesystem needs reformatting to correct
	issue.
In-Reply-To: <alpine.LSU.2.11.1407021104480.9881@Telcontar.valinor>
Message-ID: <alpine.LSU.2.11.1408111559280.2447@minas-tirith.valinor>
References: <alpine.LSU.2.11.1407021104480.9881@Telcontar.valinor>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-1463779071-1278469637-1407766990=:2447"
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

---1463779071-1278469637-1407766990=:2447
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256



El 2014-07-02 a las 11:57 +0200, Carlos E. R. escribió:

> I got this error:

Happened again, I'm on middle of recovery procedures, and using my laptop 
to post.


The system did not "die", I could still use xterms owned by root. So I 
tried to use xfs_metadump before rebooting, but it refused, said that the 
partition was mounted (and I know from previous times that umounting fails 
or locks the machine). It also said that it could not intialize the XFS 
library.

So I logged out, and issued "reboot" on tty1 as root. No go, it got stuck 
somewhere, and I had to hit the physical reset button on the machine. I 
have not looked at the logs yet.

I am now running the machine off a live usb stick (13.1 XFCE rescue 
system) to avoid the automatics to fsck the home partition, and I already 
obtained a xfs_metadump of it.

I post this in case you have some suggestion before I nuke the partition 
(rsync, reformat, etc). It shold take some hours.

- -- 
Cheers
        Carlos E. R.

        (from 13.1 x86_64 "Bottle" (Minas Tirith))
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iF4EAREIAAYFAlPo0c4ACgkQja8UbcUWM1wIewD/eEwnzZpDjJLuytDOD9bqiypF
ly6QCDckRvc2rVuCbwcA/0IX5tXGhAHr6izQvWol3F4RoxLk0uf74Ayn8lvSlDU0
=WAIZ
-----END PGP SIGNATURE-----
---1463779071-1278469637-1407766990=:2447
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

---1463779071-1278469637-1407766990=:2447--
