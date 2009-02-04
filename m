Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n148rTi1134020 for <xfs@oss.sgi.com>; Wed, 4 Feb 2009 02:53:29 -0600
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0417F18BA0B3
	for <xfs@oss.sgi.com>; Wed,  4 Feb 2009 00:52:47 -0800 (PST)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id izDzQHcwJNN4F99H for
	<xfs@oss.sgi.com>; Wed, 04 Feb 2009 00:52:47 -0800 (PST)
Received: from mailsrv2.i.zmi.at (h081217054243.dyn.cm.kabsi.at
	[81.217.54.243])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id 73ABC3D2E
	for <xfs@oss.sgi.com>; Wed,  4 Feb 2009 09:52:45 +0100 (CET)
Received: from saturn.localnet (saturn.i.zmi.at [10.0.0.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv2.i.zmi.at (Postfix) with ESMTPSA id D3EDB40016F
	for <xfs@oss.sgi.com>; Wed,  4 Feb 2009 09:52:45 +0100 (CET)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: xfs_force_shutdown after Raid crash
Date: Wed, 4 Feb 2009 09:52:45 +0100
References: <498376CF.8020806@renderforce.de> <200902031140.08576@zmi.at>
	<20090203154907.GA21278@infradead.org>
In-Reply-To: <20090203154907.GA21278@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200902040952.45440@zmi.at>
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

On Dienstag 03 Februar 2009 Christoph Hellwig wrote:
> Yeah, that sounds correct. =A0Do you volunteer for the FAQ entry?
> =A0xfs.org is a wiki so you could add it. =A0I'm happy to proof-read it
> if you want.

I don't know if it's good and correct, I just put this in the wiki, and =

additionally changed 2 sections, please check the wiki log if it's =

correct:

=3D=3D Q. What about the hard disk write cache? =3D=3D

The problem with hard disk write caches is that their contents are lost =

in case of a power outage. With hard disk cache sizes of currently up to =

32MB that can be a lot of valuable information.

With a single hard disk and barriers turned on (on=3Ddefault), a powerfail =

"only" looses data in the cache but at least does not destroy the =

filesystem.

With a RAID controller with battery backed cache, you should turn off =

barriers, as recommended above. But then you *must* disable the hard =

disk write cache in order to ensure to keep the filesystem intact after =

a power failure.

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
