Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1BLD8dR155324 for <xfs@oss.sgi.com>; Wed, 11 Feb 2009 15:13:09 -0600
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 85A8B10DF6B
	for <xfs@oss.sgi.com>; Wed, 11 Feb 2009 13:12:30 -0800 (PST)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id mMngAvGyJfQPTQST for
	<xfs@oss.sgi.com>; Wed, 11 Feb 2009 13:12:30 -0800 (PST)
Received: from mailsrv2.i.zmi.at (h081217054243.dyn.cm.kabsi.at
	[81.217.54.243])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id 7964E3F7A
	for <xfs@oss.sgi.com>; Wed, 11 Feb 2009 22:12:28 +0100 (CET)
Received: from saturn.localnet (saturn.i.zmi.at [10.0.0.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv2.i.zmi.at (Postfix) with ESMTPSA id DAE7B400160
	for <xfs@oss.sgi.com>; Wed, 11 Feb 2009 22:12:28 +0100 (CET)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: sunit & swidth on RAID-1?
Date: Wed, 11 Feb 2009 22:12:28 +0100
References: <20090211155638.GA3864@dentifrice>
	<alpine.DEB.1.10.0902111141560.18885@p34.internal.lan>
	<20090211165316.GA4430@dentifrice>
In-Reply-To: <20090211165316.GA4430@dentifrice>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200902112212.28571@zmi.at>
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

On Mittwoch 11 Februar 2009 mike dentifrice wrote:
> =A0 =A0 =A0 =A0 sunit=3D0 =A0 =A0 =A0swidth=3D0 blks, unwritten=3D1
> =A0 =A0 =A0 =A0 sectsz=3D512 =A0 sunit=3D0 blks
>
> What's the consequence of 0 values in this case?

XFS then knows that 512 byte (aka sector) alignment is sufficient, as =

RAID-1 will only write 512b to each disk and does not need full stripe =

unit writes like RAID-4/5/6 need. Therefore performance is better with =

the values you have.

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
