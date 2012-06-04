Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q55LxAKa130731 for <xfs@oss.sgi.com>; Tue, 5 Jun 2012 16:59:10 -0500
Received: from smtprelay05.ispgateway.de (smtprelay05.ispgateway.de
	[80.67.31.97]) by cuda.sgi.com with ESMTP id 4BXK0IKO11sgqh8k
	for <xfs@oss.sgi.com>; Mon, 04 Jun 2012 01:54:59 -0700 (PDT)
Received: from [62.43.225.238] (helo=localhost)
	by smtprelay05.ispgateway.de with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.68) (envelope-from <richard.ems@cape-horn-eng.com>)
	id 1SbT3x-00081z-Vi
	for xfs@oss.sgi.com; Mon, 04 Jun 2012 10:54:58 +0200
Message-ID: <4FCC77E1.4030600@cape-horn-eng.com>
Date: Mon, 04 Jun 2012 10:54:57 +0200
From: Richard Ems <richard.ems@cape-horn-eng.com>
MIME-Version: 1.0
Subject: Segmentation fault in xfs_db frag, xfsprogs-3.1.8
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi list,

I have a cron script running all weekends reporting me the fragmentation
of one of our backup systems.
It ran fine up to last weekend when it started reporting "Segmentation
fault".

This is on an openSUSE 12.1 64bit, running kernel 3.3.6.

I tried with xfsprogs3.1.6 and the self compiled 3.1.8 version. Both end
with segmentation fault.

# df -h /dev/sdc
Filesystem      Size  Used Avail Use% Mounted on
/dev/sdc         80T   57T   23T  72% /backup/ES-6664

# mount | grep sdc
/dev/sdc on /backup/ES-6664 type xfs
(rw,noatime,attr2,nobarrier,inode64,logbufs=3D8,logbsize=3D256k,sunit=3D128=
,swidth=3D3712,noquota,_netdev)
/dev/sdc on /backup/ES-6664 type xfs
(ro,relatime,attr2,nobarrier,inode64,logbufs=3D8,logbsize=3D256k,sunit=3D12=
8,swidth=3D3712,noquota,_netdev)

The FS gets first mounted rw and then bind mounted ro on top of it.

# xfs_info /dev/sdc
meta-data=3D/dev/sdc               isize=3D512    agcount=3D80,
agsize=3D268435440 blks
         =3D                       sectsz=3D512   attr=3D2
data     =3D                       bsize=3D4096   blocks=3D21240231040, ima=
xpct=3D1
         =3D                       sunit=3D16     swidth=3D464 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
log      =3Dinternal               bsize=3D4096   blocks=3D521728, version=
=3D2
         =3D                       sectsz=3D512   sunit=3D16 blks, lazy-cou=
nt=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0

# echo frag | xfs_db -r /dev/sdc
Segmentation fault

# echo frag | /opt/xfsprogs-3.1.8/sbin/xfs_db -r /dev/sdc
Segmentation fault


Any clues?

Thanks,
Richard


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
