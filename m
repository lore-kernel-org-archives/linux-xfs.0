Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2CDrCn4079679 for <xfs@oss.sgi.com>; Thu, 12 Mar 2009 08:53:32 -0500
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 91B6318F39F
	for <xfs@oss.sgi.com>; Thu, 12 Mar 2009 06:52:49 -0700 (PDT)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id SLpaypVx46mAR806 for
	<xfs@oss.sgi.com>; Thu, 12 Mar 2009 06:52:49 -0700 (PDT)
Received: from mailsrv2.i.zmi.at (h081217054243.dyn.cm.kabsi.at
	[81.217.54.243])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id EE777450C
	for <xfs@oss.sgi.com>; Thu, 12 Mar 2009 14:52:16 +0100 (CET)
Received: from saturn.localnet (saturn.i.zmi.at [10.0.0.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv2.i.zmi.at (Postfix) with ESMTPSA id E137340017F
	for <xfs@oss.sgi.com>; Thu, 12 Mar 2009 14:52:16 +0100 (CET)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: LWN article: 4K disk sectors
Date: Thu, 12 Mar 2009 14:52:16 +0100
References: <200903121258.51497@zmi.at> <49B909CC.7080402@sandeen.net>
In-Reply-To: <49B909CC.7080402@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903121452.16419@zmi.at>
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

On Donnerstag 12 M=E4rz 2009 Eric Sandeen wrote:
> Take a look at the mkfs.xfs man page:
>
> =A0 =A0 =A0 =A0-s sector_size
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 This option specifies the fundamental =A0sect=
or =A0size =A0of
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 the filesystem. =A0The sector_size is specifi=
ed either as
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 a value in bytes with size=3Dvalue or as a ba=
se two loga-
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rithm value with log=3Dvalue. =A0The default =
sector_size is
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 512 bytes. The minimum value for sector =A0si=
ze =A0is =A0512;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 the =A0maximum is 32768 (32 KiB). The sector_=
size must be
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 a power of 2 size and cannot be made =A0large=
r =A0than =A0the
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 filesystem block size.

Ugh, I felt so good this morning, until you responded ... ;-)

I thought that it's a limitation of the Linux kernel in more parts than =

just the filesystem (like block cache), that sector sizes must be 512B. =

If I had a 4K drive, would that be usable with XFS already?

mfg zmi
-- =

// Michael Monnerie, Ing.BSc    -----      http://it-management.at
// Tel: 0660 / 415 65 31                      .network.your.ideas.
// PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
// Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
// Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
