Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB17eqs0185491 for <xfs@oss.sgi.com>; Wed, 1 Dec 2010 01:40:52 -0600
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6E5BB1C85510
	for <xfs@oss.sgi.com>; Tue, 30 Nov 2010 23:42:33 -0800 (PST)
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id 1aYLDzNT5Ll8140k for
	<xfs@oss.sgi.com>; Tue, 30 Nov 2010 23:42:33 -0800 (PST)
Date: Wed, 1 Dec 2010 08:42:25 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: issue with unmount of XFS partation
Message-ID: <20101201084225.7e47a2ff@galadriel.home>
In-Reply-To: <AANLkTinsLNNbzDoTUpPsss6HL7YjPf3uZ9ivu5VDVpqz@mail.gmail.com>
References: <AANLkTinsLNNbzDoTUpPsss6HL7YjPf3uZ9ivu5VDVpqz@mail.gmail.com>
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
To: naveen yadav <yad.naveen@gmail.com>
Cc: xfs@oss.sgi.com

Le Wed, 1 Dec 2010 10:13:57 +0530 vous =E9criviez:

> FAT got unmounted every time, but XFS does not,
> =

> /dev/sda2 on /dtv/usb/sda2 type xfs (rw,relatime,nouuid,attr2,noquota)
> /dev/sdb2 on /dtv/usb/sdb2 type xfs (rw,relatime,nouuid,attr2,noquota)
> =

> If I do sync on Shell I got below error.

I don't get it, do you unmount the FS before unplugging USB? It looks
like you simply pulled the cable. FAT is an extremely primitive
filesystem that remains coherent when there isn't any data in cache or
disk activity; xfs (and all other modern filesystems) simply doesn't
work that way. You must "umount" it before unplugging, else you'll
break it.

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
