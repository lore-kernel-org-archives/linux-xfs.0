Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o49FvcRv229577 for <xfs@oss.sgi.com>; Sun, 9 May 2010 10:57:39 -0500
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AC0E51395674
	for <xfs@oss.sgi.com>; Sun,  9 May 2010 08:59:48 -0700 (PDT)
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id gMhJV32WBStDBm9A for
	<xfs@oss.sgi.com>; Sun, 09 May 2010 08:59:48 -0700 (PDT)
Date: Sun, 9 May 2010 17:59:35 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: failed to read root inode
Message-ID: <20100509175935.15b6374e@galadriel.home>
In-Reply-To: <4BE6D63F.3070404@purplehaze.ch>
References: <4BE55A63.8070203@purplehaze.ch>
	<4BE5EB5D.5020702@hardwarefreak.com>
	<4BE6D63F.3070404@purplehaze.ch>
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
To: Christian Affolter <christian.affolter@purplehaze.ch>
Cc: xfs@oss.sgi.com

Le Sun, 09 May 2010 17:35:27 +0200 vous =E9criviez:

> kernel: arcmsr0: abort device command of scsi id =3D 1 lun =3D 0
> kernel: arcmsr0: abort device command of scsi id =3D 4 lun =3D 0
> kernel: arcmsr0: abort device command of scsi id =3D 4 lun =3D 0
> kernel: arcmsr0: abort device command of scsi id =3D 4 lun =3D 0
> kernel: arcmsr0: abort device command of scsi id =3D 4 lun =3D 0
> kernel: arcmsr0: abort device command of scsi id =3D 2 lun =3D 0
> kernel: arcmsr0: ccb =3D'0xffff8100bf819080'

Looks like disks 1, 2 and 4 timed out there. What model are those disks?

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
