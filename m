Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5E6407F50
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2014 16:32:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 338A38F8037
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2014 14:32:16 -0700 (PDT)
Received: from mail-wg0-f50.google.com (mail-wg0-f50.google.com
	[74.125.82.50]) by cuda.sgi.com with ESMTP id gA7mabcdz7a9oiY5
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 11 Aug 2014 14:32:14 -0700 (PDT)
Received: by mail-wg0-f50.google.com with SMTP id n12so8904048wgh.21
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2014 14:32:13 -0700 (PDT)
Received: from minas-tirith.valinor (177.Red-79-159-63.staticIP.rima-tde.net.
	[79.159.63.177])
	by mx.google.com with ESMTPSA id a4sm48194434wie.21.2014.08.11.14.32.11
	for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Mon, 11 Aug 2014 14:32:12 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by minas-tirith.valinor (Postfix) with ESMTP id 62866183EEA
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2014 23:32:10 +0200 (CEST)
Date: Mon, 11 Aug 2014 23:31:44 +0200 (CEST)
From: "Carlos E. R." <carlos.e.r@opensuse.org>
Subject: Re: Subject : Happened again, 20140811 -- Got "Internal error
	XFS_WANT_CORRUPTED_GOTO". Filesystem needs reformatting to correct
	issue.
In-Reply-To: <alpine.LSU.2.11.1408111843150.7326@minas-tirith.valinor>
Message-ID: <alpine.LSU.2.11.1408112320040.17839@minas-tirith.valinor>
References: <alpine.LSU.2.11.1407021104480.9881@Telcontar.valinor>
	<alpine.LSU.2.11.1408111559280.2447@minas-tirith.valinor>
	<20140811144359.GA10217@laptop.bfoster>
	<alpine.LSU.2.11.1408111657160.7326@minas-tirith.valinor>
	<alpine.LSU.2.11.1408111843150.7326@minas-tirith.valinor>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-1463779071-1142169509-1407792730=:17839"
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

---1463779071-1142169509-1407792730=:17839
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256



El 2014-08-11 a las 19:05 +0200, Carlos E. R. escribió:

> linux:/run/media/linux/d_storage/xfs_disaster_home/20140811 # xfs_repair -V
> xfs_repair version 3.1.11
>
> It is a live system, so I acan't update it. If I boot from the main

...

> Now I'm going to create an xfsdump of it, and reboot, without rebuilding.
> Then I'll upload the metadata to google drive.


I have just booted the main system, in text mode, logged as root. Look:

Telcontar:/data/storage_d/xfs_disaster_home/20140811 # time xfs_metadump -g -w /dev/sdc5 tgtfile_20140811_obfus_after_repair_bis
Copied 231552 of 231552 inodes (3 of 4 AGs)
xfs_metadump: invalid dqblk inode number (-1)
Copying log

real    0m20.044s
user    0m1.527s
sys     0m1.174s
Telcontar:/data/storage_d/xfs_disaster_home/20140811 #
Telcontar:/data/storage_d/xfs_disaster_home/20140811 # xfs_metadump -V
xfs_metadump version 3.2.1


And that was after running xfs_repair 3.2.1, which found nothing...


Does that give any ideas?


- -- 
Cheers
        Carlos E. R.

        (from 13.1 x86_64 "Bottle" (Minas Tirith))
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iF4EAREIAAYFAlPpNloACgkQja8UbcUWM1xa/wD/XzXCXoTni1LL13iBgD7XzTrv
1D6PLaMyIYsLiE9K0PYA/j7sXcWkvZV27fpfIdlU4ECyid6iULLdlQN4oSE56O2C
=rZOy
-----END PGP SIGNATURE-----
---1463779071-1142169509-1407792730=:17839
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

---1463779071-1142169509-1407792730=:17839--
