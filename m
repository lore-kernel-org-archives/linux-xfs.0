Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nA77bAe3012370 for <xfs@oss.sgi.com>; Sat, 7 Nov 2009 01:37:13 -0600
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AAB046AF0F
	for <xfs@oss.sgi.com>; Fri,  6 Nov 2009 23:37:24 -0800 (PST)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id cmYy1Npw2CFkAHNw for
	<xfs@oss.sgi.com>; Fri, 06 Nov 2009 23:37:24 -0800 (PST)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id D8E01C02730
	for <xfs@oss.sgi.com>; Sat,  7 Nov 2009 08:37:21 +0100 (CET)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 9F06B40016C
	for <xfs@oss.sgi.com>; Sat,  7 Nov 2009 08:37:21 +0100 (CET)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: kernel crash with damaged XFS
Date: Sat, 7 Nov 2009 08:37:20 +0100
References: <200911061017.12200@zmi.at>
	<88ED0857-A754-4E3C-BA26-FC5EE85D7394@sandeen.net>
In-Reply-To: <88ED0857-A754-4E3C-BA26-FC5EE85D7394@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200911070837.21003@zmi.at>
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

On Freitag 06 November 2009 Eric Sandeen wrote:
> > I had that during the last days on my system. It kept on running =A0
> > despite
> > this error. I xfs_repair'ed the fs again and now it's working.
> > This is the same server I talked about with Eric last time, where
> > he improved xfs_repair and that repaired my fs. I had to run
> > xfs_repair several times again until all errors were solved,
> > and now nothing is reported anymore.
> > The server had no crash or whatever since the last repair, so I
> > wonder where these corruptions come from.
> >
> > Nov =A02 00:01:12 orion.i.zmi.at kernel: Filesystem "dm-0": corrupt =A0
> > inode 3858839593 ((a)extents =3D 7). =A0Unmount and run xfs_repair.
>
> Just FWIW this is not a crash, it is XFS properly handling
> corrruption =A0 it encountered. =A0The corruption could be due to a bug
> in XFS or other code, or a hardware problem. =A0Does repair fix it this
> time?

Yes Eric, that's what I wrote but I see it can be misinterpreted as =

belonging to the old case. I meant the actual problem when saying:

I had to run xfs_repair several times again until all errors were =

solved, and now nothing is reported anymore. The server had no crash or =

whatever since the last repair, so I wonder where these corruptions come =

from.

Seems to be time to make a memory check. I have no other idea where the =

problem could come from.

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
