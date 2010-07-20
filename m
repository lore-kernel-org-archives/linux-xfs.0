Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6KKaXXV039922 for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 15:36:33 -0500
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0C64245D69C
	for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 13:39:32 -0700 (PDT)
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id mVs23uWYqGwZ4A9i for
	<xfs@oss.sgi.com>; Tue, 20 Jul 2010 13:39:32 -0700 (PDT)
Date: Tue, 20 Jul 2010 22:39:05 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: 4k sector drives
Message-ID: <20100720223905.296a780a@galadriel.home>
In-Reply-To: <201007202058.35141@zmi.at>
References: <201007202058.35141@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

Le Tue, 20 Jul 2010 20:58:27 +0200 vous =E9criviez:

> I recently bought 2 new 4k sector drives (WD Caviar Green 2TB, =

> WD20EARS), but Linux kernel 2.6.34.1 still says:
> =

> # blockdev --getss /dev/sdd
> 512
> =

> Shouldn't that be 4096? Where is the problem?

They come in emulation mode (like many SATA-II drives came in SATA-I
mode). You must set them to 4K blocks manually, for WD IIRC with a DOS
software. And you need a controller that supports 4K blocks, too
(probably anything older than a year won't).

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
