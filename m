Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EAE737F47
	for <xfs@oss.sgi.com>; Sat, 12 Jul 2014 09:26:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 45BA2AC001
	for <xfs@oss.sgi.com>; Sat, 12 Jul 2014 07:26:45 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id HCiMHmCUHGLO8fdH (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 12 Jul 2014 07:26:43 -0700 (PDT)
Date: Sat, 12 Jul 2014 10:26:38 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Got "Internal error XFS_WANT_CORRUPTED_GOTO". Filesystem needs
	reformatting to correct issue.
Message-ID: <20140712142637.GB53265@bfoster.bfoster>
References: <alpine.LSU.2.11.1407021104480.9881@Telcontar.valinor>
	<20140702120441.GA51757@bfoster.bfoster>
	<alpine.LSU.2.11.1407030057310.9881@Telcontar.valinor>
	<20140703173916.GB3452@laptop.bfoster>
	<alpine.LSU.2.11.1407040135140.9881@Telcontar.valinor>
	<20140705122833.GA3573@bfoster.bfoster>
	<alpine.LSU.2.11.1407120150220.15907@Telcontar.valinor>
	<alpine.LSU.2.11.1407120318100.15907@Telcontar.valinor>
	<alpine.LSU.2.11.1407120340330.15907@Telcontar.valinor>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1407120340330.15907@Telcontar.valinor>
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
To: "Carlos E. R." <carlos.e.r@opensuse.org>
Cc: XFS mailing list <xfs@oss.sgi.com>

On Sat, Jul 12, 2014 at 03:45:07AM +0200, Carlos E. R. wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> 
> 
> On Saturday, 2014-07-12 at 03:30 +0200, Carlos E. R. wrote:
> 
> >So, please wait till I verify things again. Tomorrow, it is 3 AM here.
> >Sorry :-(
> >
> >Unless "xfs_info tgtfile" gives the information about the device where
> >"tgtfile" is stored (/dev/sdf2), not on the image file itself :-?
> >
> >I'm very confused.
> 
> False alarm. See:
> 
> 
> Telcontar:/data/storage_c/tmp_borrar # xfs_info tgtfile
> meta-data=/dev/sde18             isize=256    agcount=4, agsize=35770496 blks
>          =                       sectsz=512   attr=2, projid32bit=0
>          =                       crc=0
> data     =                       bsize=4096   blocks=143081984, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
> log      =internal               bsize=4096   blocks=69864, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> Telcontar:/data/storage_c/tmp_borrar #
> 
> Telcontar:/data/storage_d/old_backup # xfs_info tgtfile
> meta-data=/dev/sdf2              isize=256    agcount=4, agsize=122341568 blks
>          =                       sectsz=512   attr=2, projid32bit=0
>          =                       crc=0
> data     =                       bsize=4096   blocks=489366272, imaxpct=5
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
> log      =internal               bsize=4096   blocks=238948, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> Telcontar:/data/storage_d/old_backup #
> 
> Telcontar:/data/storage_d/old_backup # file tgtfile
> tgtfile: XFS filesystem metadump image
> Telcontar:/data/storage_d/old_backup #
> 
> 
> It appears that the command "xfs_info" analyzes the current, underlying,
> filesystem, not the one given on the command line. Or something in that
> line, I'm too sleepy. I hope you can understand my meaning better than my
> words...
> 

xfs_info reports on the mounted fs. If you check out 'man xfs_info,'
you'll see it specifies the mountpoint as a parameter but it can query
the fs info from the actual mountpoint or any file therein. E.g., so it
doesn't know anything about a metadump file and pointing it at one will
just report on the fs that contains the file.

If you wanted to test an actual metadump image, restore the metadump to
an fs image, mount and test that:

xfs_mdrestore ./metadump ./mynewfsimage
mount ./mynewfsimage /mnt -o loop
xfs_info /mnt/

Brian

> 
> So the uploaded file is the correct one.
> 
> 
> - -- Cheers,
>        Carlos E. R.
>        (from 13.1 x86_64 "Bottle" at Telcontar)
> 
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v2.0.22 (GNU/Linux)
> 
> iEYEARECAAYFAlPAkyMACgkQtTMYHG2NR9U2uACfTdPx8DGCkBzLGiSVGn3XCcSV
> 7ukAnAvR1CjR9Jx3rPosLYNceBtQjJjf
> =/odv
> -----END PGP SIGNATURE-----
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
