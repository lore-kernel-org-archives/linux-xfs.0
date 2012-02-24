Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1OCqkFR040624 for <xfs@oss.sgi.com>; Fri, 24 Feb 2012 06:52:46 -0600
Received: from smtprelay04.ispgateway.de (smtprelay04.ispgateway.de
	[80.67.18.16]) by cuda.sgi.com with ESMTP id 5uMH3vSldmYpbQOa
	for <xfs@oss.sgi.com>; Fri, 24 Feb 2012 04:52:41 -0800 (PST)
Received: from [62.43.225.238] (helo=[192.168.30.191])
	by smtprelay04.ispgateway.de with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.68) (envelope-from <richard.ems@cape-horn-eng.com>)
	id 1S0udd-0007DV-0N
	for xfs@oss.sgi.com; Fri, 24 Feb 2012 13:52:41 +0100
Message-ID: <4F478818.4050803@cape-horn-eng.com>
Date: Fri, 24 Feb 2012 13:52:40 +0100
From: Richard Ems <richard.ems@cape-horn-eng.com>
MIME-Version: 1.0
Subject: creating a new 80 TB XFS
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

I am not a storage expert, so sorry in advance for probably some *naive*
questions or proposals from me. 8)

*INTRO*
We are getting new hardware soon and I wanted to check with you my plans
for creating and mounting this XFS.

The storage system is from EUROstor,
http://eurostor.com/en/products/raid-sas-host/es-6600-sassas-toploader.html
.

We are getting now 32 x 3 TB Hitachi SATA HDDs.
I plan to configure them in a single RAID 6 set with one or two
hot-standby discs. The raw storage space will then be 28 x 3 TB =3D 84 TB.
On this one RAID set I will create only one volume.
Any thoughts on this?

This storage will be used as secondary storage for backups. We use
dirvish (www.dirvish.org, which uses rsync) to run our daily backups.
dirvish heavily uses hard links. It compares all files, one by one, and
synchronizes all new or changed files with rsync to the current daily
dir YYYY-MM-DD, and creates hard links for all not changed files from
the last previous backup on YYYY-MM-(DD-1) to the current YYYY-MM-DD
directory.


*MKFS*
We also heavily use ACLs for almost all of our files. Christoph Hellwig
suggested in a previous mail to use "-i size=3D512" on XFS creation, so my
mkfs.xfs would look something like:

mkfs.xfs -i size=3D512 -d su=3Dstripe_size,sw=3D28 -L Backup_2 /dev/sdX1


*MOUNT*
On mount I will use the options

mount -o noatime,nobarrier,nofail,logbufs=3D8,logbsize=3D256k,inode64
/dev/sdX1 /mount_point

What about the largeio mount option? In which cases would it be useful?


Do you have any other/better suggestions or comments?


Many thanks,
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
