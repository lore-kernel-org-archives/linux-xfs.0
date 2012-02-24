Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1OE8Bcd050143 for <xfs@oss.sgi.com>; Fri, 24 Feb 2012 08:08:11 -0600
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id 3pojCCaCajPzvgaR for
	<xfs@oss.sgi.com>; Fri, 24 Feb 2012 06:08:08 -0800 (PST)
Received: from harpe.intellique.com (unknown [82.225.196.72])
	by smtp4-g21.free.fr (Postfix) with ESMTP id DE6B84C801D
	for <xfs@oss.sgi.com>; Fri, 24 Feb 2012 15:08:03 +0100 (CET)
Date: Fri, 24 Feb 2012 15:08:05 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: creating a new 80 TB XFS
Message-ID: <20120224150805.243e4906@harpe.intellique.com>
In-Reply-To: <4F478818.4050803@cape-horn-eng.com>
References: <4F478818.4050803@cape-horn-eng.com>
Mime-Version: 1.0
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

Le Fri, 24 Feb 2012 13:52:40 +0100
Richard Ems <richard.ems@cape-horn-eng.com> =E9crivait:

> Hi list,
> =

> We are getting now 32 x 3 TB Hitachi SATA HDDs.
> I plan to configure them in a single RAID 6 set with one or two
> hot-standby discs. The raw storage space will then be 28 x 3 TB =3D 84
> TB. On this one RAID set I will create only one volume.
> Any thoughts on this?

If you'd rather go for more safety you could build 2 16 drives RAID-6
arrays instead. I'd be somewhat reluctant to make a 30 drives array
--though current drives are quite safe apparently.

> =

> *MKFS*
> We also heavily use ACLs for almost all of our files. Christoph
> Hellwig suggested in a previous mail to use "-i size=3D512" on XFS
> creation, so my mkfs.xfs would look something like:
> =

> mkfs.xfs -i size=3D512 -d su=3Dstripe_size,sw=3D28 -L Backup_2 /dev/sdX1

Looks OK to me.
 =

> =

> *MOUNT*
> On mount I will use the options
> =

> mount -o noatime,nobarrier,nofail,logbufs=3D8,logbsize=3D256k,inode64
> /dev/sdX1 /mount_point

I think that the logbufs/logbsize option matches the default here. Use
delaylog if applicable. See the xfs FAQ.
 =

> What about the largeio mount option? In which cases would it be
> useful?
> =


If you're mostly writing/reading large files. Like really large
(several megabytes and more).

-- =

------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
