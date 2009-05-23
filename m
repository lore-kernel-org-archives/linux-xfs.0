Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4NHjgRK013405 for <xfs@oss.sgi.com>; Sat, 23 May 2009 12:45:42 -0500
Received: from smtprelay08.ispgateway.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6D9211A130EA
	for <xfs@oss.sgi.com>; Sat, 23 May 2009 10:45:53 -0700 (PDT)
Received: from smtprelay08.ispgateway.de (smtprelay08.ispgateway.de
	[80.67.31.31]) by cuda.sgi.com with ESMTP id fvzrPKw9TCE33WoJ
	for <xfs@oss.sgi.com>; Sat, 23 May 2009 10:45:53 -0700 (PDT)
Message-ID: <20090523194552.66062w3zquwvms00@webmail.df.eu>
Date: Sat, 23 May 2009 19:45:52 +0200
From: richard.ems@cape-horn-eng.com
Subject: Re: xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed: Invalid argument
References: <4A180FCD.9080905@cape-horn-eng.com> <4A181B40.9080608@sandeen.net>
	<20090523180721.94212hyfjppuupmo@webmail.df.eu>
	<4A1833D7.30608@sandeen.net>
In-Reply-To: <4A1833D7.30608@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"; DelSp="Yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com


Quoting Eric Sandeen <sandeen@sandeen.net>:
> Not sure ... how big is the current fs and how big is the device?  Can
> you provide:
>
> # xfs_info /mnt
> # grep sda1 /proc/partitions

It is a 16TB FS, and I add 4 x 1 TB HDDs to the RAID 6 array, so the  =

device went from 16 TB to 20 TB.

c3m:~ # xfs_info /backup/IFT
meta-data=3D/dev/sda1              isize=3D256    agcount=3D52, agsize=3D76=
288719 blks
          =3D                       sectsz=3D512   attr=3D1
data     =3D                       bsize=3D4096   blocks=3D3905982455, imax=
pct=3D25
          =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
log      =3Dinternal               bsize=3D4096   blocks=3D32768, version=
=3D1
          =3D                       sectsz=3D512   sunit=3D0 blks, lazy-cou=
nt=3D0
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0


c3m:~ # grep sda1 /proc/partitions
    8     1 19529912286 sda1


c3m:~ # parted /dev/sda print
Model: IFT A24U-G2421 (scsi)
Disk /dev/sda: 20.0TB
Sector size (logical/physical): 512B/512B
Partition Table: gpt

Number  Start   End     Size    File system  Name  Flags
  1      17.4kB  20.0TB  20.0TB  xfs          LD01  , , , , , , , , , , ,



thanks, Richard




-- =

Richard Ems       mail: Richard.Ems@Cape-Horn-Eng.com

Cape Horn Engineering S.L.
C/ Dr. J.J. D=F3mine 1, 5=BA piso
46011 Valencia
Tel : +34 96 3242923 / Fax 924
http://www.cape-horn-eng.com


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
