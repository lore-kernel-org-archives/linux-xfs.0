Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1BEDekm132822 for <xfs@oss.sgi.com>; Wed, 11 Feb 2009 08:13:40 -0600
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2520E109A55
	for <xfs@oss.sgi.com>; Wed, 11 Feb 2009 06:13:01 -0800 (PST)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id CBKXKvKENr0VVsWF for
	<xfs@oss.sgi.com>; Wed, 11 Feb 2009 06:13:01 -0800 (PST)
Received: from mailsrv2.i.zmi.at (h081217054243.dyn.cm.kabsi.at
	[81.217.54.243])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id B8B3B3F25
	for <xfs@oss.sgi.com>; Wed, 11 Feb 2009 15:13:00 +0100 (CET)
Received: from saturn.localnet (saturn.i.zmi.at [10.0.0.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv2.i.zmi.at (Postfix) with ESMTPSA id BDE47400160
	for <xfs@oss.sgi.com>; Wed, 11 Feb 2009 15:13:00 +0100 (CET)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: why does mkfs.xfs complain here?
Date: Wed, 11 Feb 2009 15:13:00 +0100
References: <200902111310.53762@zmi.at> <4992D3B7.7060101@sandeen.net>
In-Reply-To: <4992D3B7.7060101@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200902111513.00473@zmi.at>
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

On Mittwoch 11 Februar 2009 Eric Sandeen wrote:
> > # mkfs.xfs -f -L ws1phptmp -b size=3D4096 -d
> > su=3D64k,sw=3D4,agsize=3D65262b -i attr=3D2 -l lazy-count=3D1,su=3D65536
> > /dev/sdf1 log stripe unit specified, using v2 logs
> > agsize rounded to 65264, swidth =3D 64
> > meta-data=3D/dev/sdf1 =A0 =A0 =A0 =A0 =A0 =A0 =A0isize=3D256 =A0 =A0agc=
ount=3D4,
> > agsize=3D65264 blks =3D =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec=
tsz=3D512 =A0 attr=3D2
> > data =A0 =A0 =3D =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bsize=3D40=
96 =A0 blocks=3D261048,
> > imaxpct=3D25 =3D =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sunit=3D16=
 =A0 =A0 swidth=3D64 blks,
> > unwritten=3D1 naming =A0 =3Dversion 2 =A0 =A0 =A0 =A0 =A0 =A0 =A0bsize=
=3D4096
> > log =A0 =A0 =A0=3Dinternal log =A0 =A0 =A0 =A0 =A0 bsize=3D4096 =A0 blo=
cks=3D1200,
> > version=3D2 =3D =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sectsz=3D51=
2 =A0 sunit=3D16 blks,
> > lazy-count=3D1 realtime =3Dnone =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext=
sz=3D4096 =A0
> > blocks=3D0, rtextents=3D0
> >
> > So no problem using agsize instead agcount, where agcount
> > complained about group size =3D 65262, which I then used without
> > problem?
>
> and then it chose 65264 instead.
>
> all this is a little messy in mkfs.xfs, I suppose you've found a
> bug....

Good, I wasn't sure if it's me not understanding it. :-)
Also, the line
agsize rounded to 65264, swidth =3D 64
should be changed to use units:
agsize rounded to 65264b, swidth =3D 64k
and so should all other values also I guess. It would be good at least, =

as the current mixture is confusing:
imaxpct=3D25 =3D                       sunit=3D16     swidth=3D64 blks,
The "pct" is clear, but could have "%", swidth has the units "blks", but =

what is "sunit" is only clear if you read the man page.

Yes, somewhat messy, maybe there can be a full cleanup. :-)

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
