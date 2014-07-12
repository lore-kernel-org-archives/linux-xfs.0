Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D125D7F66
	for <xfs@oss.sgi.com>; Fri, 11 Jul 2014 20:45:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B3951304039
	for <xfs@oss.sgi.com>; Fri, 11 Jul 2014 18:45:12 -0700 (PDT)
Received: from mail-wg0-f50.google.com (mail-wg0-f50.google.com
	[74.125.82.50]) by cuda.sgi.com with ESMTP id XQ99J5R0t9vyuFMj
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 11 Jul 2014 18:45:11 -0700 (PDT)
Received: by mail-wg0-f50.google.com with SMTP id n12so1843056wgh.9
	for <xfs@oss.sgi.com>; Fri, 11 Jul 2014 18:45:10 -0700 (PDT)
Received: from Telcontar.valinor (90.Red-79-150-228.dynamicIP.rima-tde.net.
	[79.150.228.90])
	by mx.google.com with ESMTPSA id 10sm8636998wjx.26.2014.07.11.18.45.08
	for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Fri, 11 Jul 2014 18:45:09 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by Telcontar.valinor (Postfix) with ESMTP id D9E4D60685
	for <xfs@oss.sgi.com>; Sat, 12 Jul 2014 03:45:07 +0200 (CEST)
Received: from Telcontar.valinor ([127.0.0.1])
	by localhost (Telcontar.valinor [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id u6bYkCWvp-El for <xfs@oss.sgi.com>;
	Sat, 12 Jul 2014 03:45:07 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by Telcontar.valinor (Postfix) with ESMTP id B4D8C60679
	for <xfs@oss.sgi.com>; Sat, 12 Jul 2014 03:45:07 +0200 (CEST)
Date: Sat, 12 Jul 2014 03:45:07 +0200 (CEST)
From: "Carlos E. R." <carlos.e.r@opensuse.org>
Subject: Re: Got "Internal error XFS_WANT_CORRUPTED_GOTO". Filesystem needs
	reformatting to correct issue.
In-Reply-To: <alpine.LSU.2.11.1407120318100.15907@Telcontar.valinor>
Message-ID: <alpine.LSU.2.11.1407120340330.15907@Telcontar.valinor>
References: <alpine.LSU.2.11.1407021104480.9881@Telcontar.valinor>
	<20140702120441.GA51757@bfoster.bfoster>
	<alpine.LSU.2.11.1407030057310.9881@Telcontar.valinor>
	<20140703173916.GB3452@laptop.bfoster>
	<alpine.LSU.2.11.1407040135140.9881@Telcontar.valinor>
	<20140705122833.GA3573@bfoster.bfoster>
	<alpine.LSU.2.11.1407120150220.15907@Telcontar.valinor>
	<alpine.LSU.2.11.1407120318100.15907@Telcontar.valinor>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: XFS mailing list <xfs@oss.sgi.com>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1



On Saturday, 2014-07-12 at 03:30 +0200, Carlos E. R. wrote:

> So, please wait till I verify things again. Tomorrow, it is 3 AM here.
> Sorry :-(
>
> Unless "xfs_info tgtfile" gives the information about the device where
> "tgtfile" is stored (/dev/sdf2), not on the image file itself :-?
>
> I'm very confused.

False alarm. See:


Telcontar:/data/storage_c/tmp_borrar # xfs_info tgtfile
meta-data=/dev/sde18             isize=256    agcount=4, agsize=35770496 blks
          =                       sectsz=512   attr=2, projid32bit=0
          =                       crc=0
data     =                       bsize=4096   blocks=143081984, imaxpct=25
          =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
log      =internal               bsize=4096   blocks=69864, version=2
          =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
Telcontar:/data/storage_c/tmp_borrar #

Telcontar:/data/storage_d/old_backup # xfs_info tgtfile
meta-data=/dev/sdf2              isize=256    agcount=4, agsize=122341568 blks
          =                       sectsz=512   attr=2, projid32bit=0
          =                       crc=0
data     =                       bsize=4096   blocks=489366272, imaxpct=5
          =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
log      =internal               bsize=4096   blocks=238948, version=2
          =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
Telcontar:/data/storage_d/old_backup #

Telcontar:/data/storage_d/old_backup # file tgtfile
tgtfile: XFS filesystem metadump image
Telcontar:/data/storage_d/old_backup #


It appears that the command "xfs_info" analyzes the current, underlying, 
filesystem, not the one given on the command line. Or something in that 
line, I'm too sleepy. I hope you can understand my meaning better than my 
words...


So the uploaded file is the correct one.


- -- 
Cheers,
        Carlos E. R.
        (from 13.1 x86_64 "Bottle" at Telcontar)

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlPAkyMACgkQtTMYHG2NR9U2uACfTdPx8DGCkBzLGiSVGn3XCcSV
7ukAnAvR1CjR9Jx3rPosLYNceBtQjJjf
=/odv
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
