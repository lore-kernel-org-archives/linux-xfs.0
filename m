Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5ICjlVI224381 for <xfs@oss.sgi.com>; Fri, 18 Jun 2010 07:45:47 -0500
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9F6943E4A03
	for <xfs@oss.sgi.com>; Fri, 18 Jun 2010 05:48:23 -0700 (PDT)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id 0XXsmOuH6v4RkwdC for
	<xfs@oss.sgi.com>; Fri, 18 Jun 2010 05:48:23 -0700 (PDT)
Date: Fri, 18 Jun 2010 14:48:21 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Help with XFS
Message-ID: <20100618144821.0cab4bd4@harpe.intellique.com>
In-Reply-To: <OF77BEDC85.715D16D2-ONC1257746.0043A985-C1257746.0044BAFC@bergenofs.no>
References: <OF4967B99D.609CC213-ONC1257745.0048E646-C1257745.004919A3@bergenofs.no>
	<20100618132108.790921cf@harpe.intellique.com>
	<OF450B8187.BD5256B0-ONC1257746.003E79FF-C1257746.003EE62C@bergenofs.no>
	<20100618133458.6640ce96@harpe.intellique.com>
	<OF0E234D8E.F048FF4D-ONC1257746.003FC10E-C1257746.00407333@bergenofs.no>
	<20100618140028.05650928@harpe.intellique.com>
	<OF77BEDC85.715D16D2-ONC1257746.0043A985-C1257746.0044BAFC@bergenofs.no>
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
To: Thomas =?ISO-8859-1?Q?F=F8rde?= <thomas.forde@bergenofs.no>
Cc: xfs@oss.sgi.com

Le Fri, 18 Jun 2010 14:30:43 +0200
Thomas F=F8rde <thomas.forde@bergenofs.no> =E9crivait:

> ill see if we can rebuild a different SAN with mirror functionalityt,
> y have 384x300GB disk in my SAN, so it should be possible.

No, a mirror will corrupt your data as well, a simple copy is better;
unless you break the mirror as soon as the data is on it, to keep a
copy safe. But the copy has another benefit, it's a different
filesystem too.

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
