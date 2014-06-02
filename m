Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DFEF27F5D
	for <xfs@oss.sgi.com>; Mon,  2 Jun 2014 06:22:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F3A04AC002
	for <xfs@oss.sgi.com>; Mon,  2 Jun 2014 04:22:20 -0700 (PDT)
Received: from mail-wg0-f52.google.com (mail-wg0-f52.google.com
	[74.125.82.52]) by cuda.sgi.com with ESMTP id ITmNtj56A765SqCg
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 02 Jun 2014 04:22:18 -0700 (PDT)
Received: by mail-wg0-f52.google.com with SMTP id l18so4874803wgh.23
	for <xfs@oss.sgi.com>; Mon, 02 Jun 2014 04:22:18 -0700 (PDT)
Message-ID: <538C5E67.6090005@gmail.com>
Date: Mon, 02 Jun 2014 14:22:15 +0300
From: Martin Papik <mp6058@gmail.com>
MIME-Version: 1.0
Subject: Re: XFS filesystem claims to be mounted after a disconnect
References: <5363A1D8.2020402@gmail.com> <5363B4C9.4000900@sandeen.net>
	<5363CB5E.3090008@gmail.com> <5363CD70.3000006@sandeen.net>
	<5363DBD7.4060002@gmail.com> <5363E65C.6010006@sandeen.net>
	<5363ECE8.6030706@gmail.com> <20140502233512.GE26353@dastard>
	<536432A0.6000405@gmail.com> <20140503030221.GJ26353@dastard>
In-Reply-To: <20140503030221.GJ26353@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512


>> How can I detect this situation? I mean I didn't see anything in 
>> /proc/mounts or references to the mount point from /proc/<pid>/*,
>> so I only managed to correct it (chdir elsewhere) by chance on a
>> hunch. Would it not be desirable to know that there's a phantom
>> FS referenced by a number of processes?
> 
> lsof.

No good. It happened again and the only thing showing up in lsof
that's even remotely a match is the kernel process associated with the
filesystem instance. "[xfs-data/sde103]". The mountpoint has been
removed by the automatic mounting facility (udev? systemd?). The
device is no longer id /dev (udev?). There's nothing useful in the
output of "find /proc -ls" either.

Any other suggestions to locate the processes that are holding up XFS?

Martin

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCgAGBQJTjF5dAAoJELsEaSRwbVYrO7IP/016AVgVrdCQ2Vm95hFT5rdu
LH6Sz0mpnZn6mAliNLAa+wFpXArDb6VPyssmomzNLgnpA95qLcfJeBqs1wF88tiA
GO+aFSX3o3npAokbaq1N5c1dKz/g9lpsUPBkmiUEqcPLJMOKdJdSSd4T2nnnKrkD
uDGRmEPZGKXLt75Z0SajnG8oX22bSQdzREn2o4DXZy+RJF9G8wsc490b8TzijDul
AtL/2zlRL45LqbcaNNAOARUiTN4IAxy3xwYRU+xXKhqojPRc0x8K4wrjnGcsiw4x
Cz5HjJ6CdBLmjn69TRf+S5Y/UXtUcyFOIS0XIUwYg6KtwrI1BY+N+GpkSJNG/DcH
0lAN6n7UBTAADw54ZJdYhyw5aUt9OEXdDx2nIuTxq+X/6u4ydEDchJWPvyLG2nv9
Z2vObyh07X9n7h+zknK3yBxlHHNcpi1/d3njxRSa3GKQIPKNbrLNkrFqB4U4+isr
qrcldbcke5d6sUP/VdvjeOGTYWtymx8KqL1MDGPRXruOO1Y6N8DWTbseQCbeoQlS
k0L9md5FsZOPG/aUgXHvD4350sKqYpQk2pgoGW7Ia6F+5nwi1TdSd8R6mlGJ0GyW
hMymVeykhb19mVJzdc7UlmxyAUBUEd2zGEeO0uSenHt19yWc93vfEHG6GCtxFpu6
sxblWr9nRfPi6sOw7oUF
=xn+2
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
