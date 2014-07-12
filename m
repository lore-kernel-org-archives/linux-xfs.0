Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 23FB87F53
	for <xfs@oss.sgi.com>; Fri, 11 Jul 2014 20:30:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0F5B58F804C
	for <xfs@oss.sgi.com>; Fri, 11 Jul 2014 18:30:22 -0700 (PDT)
Received: from mail-wi0-f182.google.com (mail-wi0-f182.google.com
	[209.85.212.182]) by cuda.sgi.com with ESMTP id
	iGbpojgetDp1RyYQ (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 11 Jul 2014 18:30:21 -0700 (PDT)
Received: by mail-wi0-f182.google.com with SMTP id d1so69979wiv.9
	for <xfs@oss.sgi.com>; Fri, 11 Jul 2014 18:30:20 -0700 (PDT)
Received: from Telcontar.valinor (90.Red-79-150-228.dynamicIP.rima-tde.net.
	[79.150.228.90])
	by mx.google.com with ESMTPSA id ev9sm964788wic.24.2014.07.11.18.30.18
	for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Fri, 11 Jul 2014 18:30:19 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by Telcontar.valinor (Postfix) with ESMTP id 29EB560685
	for <xfs@oss.sgi.com>; Sat, 12 Jul 2014 03:30:18 +0200 (CEST)
Received: from Telcontar.valinor ([127.0.0.1])
	by localhost (Telcontar.valinor [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id GqY636tFh2Sy for <xfs@oss.sgi.com>;
	Sat, 12 Jul 2014 03:30:18 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by Telcontar.valinor (Postfix) with ESMTP id E707C60679
	for <xfs@oss.sgi.com>; Sat, 12 Jul 2014 03:30:17 +0200 (CEST)
Date: Sat, 12 Jul 2014 03:30:17 +0200 (CEST)
From: "Carlos E. R." <carlos.e.r@opensuse.org>
Subject: Re: Got "Internal error XFS_WANT_CORRUPTED_GOTO". Filesystem needs
	reformatting to correct issue.
In-Reply-To: <alpine.LSU.2.11.1407120150220.15907@Telcontar.valinor>
Message-ID: <alpine.LSU.2.11.1407120318100.15907@Telcontar.valinor>
References: <alpine.LSU.2.11.1407021104480.9881@Telcontar.valinor>
	<20140702120441.GA51757@bfoster.bfoster>
	<alpine.LSU.2.11.1407030057310.9881@Telcontar.valinor>
	<20140703173916.GB3452@laptop.bfoster>
	<alpine.LSU.2.11.1407040135140.9881@Telcontar.valinor>
	<20140705122833.GA3573@bfoster.bfoster>
	<alpine.LSU.2.11.1407120150220.15907@Telcontar.valinor>
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



On Saturday, 2014-07-12 at 02:30 +0200, Carlos E. R. wrote:
> On Saturday, 2014-07-05 at 08:28 -0400, Brian Foster wrote:

[xfs_metadump]

> It's here:
>
> <https://drive.google.com/file/d/0Bx2OgfTa-XC9UDBnQzZIMTVyN0k/edit?usp=sharing>
>
> Whoever wants to read it, has to tell me the address to add to it, access
> is not public.

Wait.

I just found out that I did something very wrong. That xfs_metadump file 
is very wrong, it is not look to be the correct one.


The info on it says:


Telcontar:/data/storage_d/old_backup # xfs_info tgtfile
meta-data=/dev/sdf2              isize=256    agcount=4, agsize=122341568 
blks
          =                       sectsz=512   attr=2, projid32bit=0
          =                       crc=0
data     =                       bsize=4096   blocks=489366272, imaxpct=5
          =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
log      =internal               bsize=4096   blocks=238948, version=2
          =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0


while the currently mounted home says:


elcontar:~ # mount | grep home
/dev/sde5 on /home type xfs (rw,noatime,attr2,inode64,noquota)

Telcontar:~ # xfs_info /dev/sde5
meta-data=/dev/sde5              isize=256    agcount=4, agsize=32000000 
blks
          =                       sectsz=512   attr=2, projid32bit=1
          =                       crc=0
data     =                       bsize=4096   blocks=128000000, imaxpct=25
          =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
log      =internal               bsize=4096   blocks=62500, version=2
          =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
Telcontar:~ # mount | grep /home




So, please wait till I verify things again. Tomorrow, it is 3 AM here. 
Sorry :-(


Unless "xfs_info tgtfile" gives the information about the device where 
"tgtfile" is stored (/dev/sdf2), not on the image file itself :-?


I'm very confused.


- -- 
Cheers,
        Carlos E. R.
        (from 13.1 x86_64 "Bottle" at Telcontar)

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlPAj6kACgkQtTMYHG2NR9X+IwCeJtpsS6XJJ1xNeLPmb6PlXA8D
C9IAn1hn1g/ty/41dG5h4ijQoXqs1N7G
=Xtcq
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
