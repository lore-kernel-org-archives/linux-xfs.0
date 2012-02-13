Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1DGw1YX025636 for <xfs@oss.sgi.com>; Mon, 13 Feb 2012 10:58:01 -0600
Received: from smtprelay06.ispgateway.de (smtprelay06.ispgateway.de
	[80.67.31.103]) by cuda.sgi.com with ESMTP id Fp6Myde4sVPSxF2D
	for <xfs@oss.sgi.com>; Mon, 13 Feb 2012 08:57:59 -0800 (PST)
Received: from [62.43.225.238] (helo=[192.168.30.191])
	by smtprelay06.ispgateway.de with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.68) (envelope-from <richard.ems@cape-horn-eng.com>)
	id 1RwzDy-0001Am-SN
	for xfs@oss.sgi.com; Mon, 13 Feb 2012 17:57:58 +0100
Message-ID: <4F394116.8080200@cape-horn-eng.com>
Date: Mon, 13 Feb 2012 17:57:58 +0100
From: Richard Ems <richard.ems@cape-horn-eng.com>
MIME-Version: 1.0
Subject: XFS unlink still slow on 3.1.9 kernel ?
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

Hello list !

I ran a "find dir" on one directory with 11 million files and dirs in it
and it took 100 minutes. Is this a "normal" run time to be expected?

I am running openSUSE 12.1, kernel 3.1.9-1.4-default. The 20 TB XFS
partition is 100% full and is on an external InforTrend RAID system with
24 x 1 TB SATA HDDs on RAID 6 with one hot-spare HDD, so 21 data discs
plus 2 parity discs plus 1 hot-spare disc. The case is connected through
SCSI.

The system was not running anything else on that discs and the load on
the server was around 1 because of only this one find command running.

I am asking because I am seeing very long times while removing big
directory trees. I thought on kernels above 3.0 removing dirs and files
had improved a lot, but I don't see that improvement.

This is a backup system running dirvish, so most files in the dirs I am
removing are hard links. Almost all of the files do have ACLs set.


# mount | grep xfs
/dev/sda1 on /backup/IFT type xfs
(rw,noatime,nodiratime,attr2,delaylog,nobarrier,logbufs=3D8,logbsize=3D256k=
,sunit=3D256,swidth=3D5376,noquota,_netdev)

Any thoughts?


Thanks, Richard



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
