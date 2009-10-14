Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9E1IHiY164525 for <xfs@oss.sgi.com>; Tue, 13 Oct 2009 20:18:20 -0500
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 777A4178279B
	for <xfs@oss.sgi.com>; Tue, 13 Oct 2009 18:19:18 -0700 (PDT)
Received: from mailsrv1.zmi.at (mailsrv5.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id 8GL7UZbzTSrtDkD6 for
	<xfs@oss.sgi.com>; Tue, 13 Oct 2009 18:19:18 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id 4B54F6DB
	for <xfs@oss.sgi.com>; Wed, 14 Oct 2009 03:19:15 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id BE074400155
	for <xfs@oss.sgi.com>; Wed, 14 Oct 2009 03:19:14 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: fsetxattr() fails on a writable descriptor?
Date: Wed, 14 Oct 2009 03:17:09 +0200
References: <1251987642.3855.36.camel@dhcp-lab-219.englab.brq.redhat.com>
	<200909100014.10833@zmi.at> <20091013235805.GA18467@infradead.org>
In-Reply-To: <20091013235805.GA18467@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200910140317.09839@zmi.at>
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

On Mittwoch 14 Oktober 2009 Christoph Hellwig wrote:
> On Thu, Sep 10, 2009 at 12:14:10AM +0200, Michael Monnerie wrote:
> > On Mittwoch 09 September 2009 P?draig Brady wrote:
> > > The specific issue we have is that `cp --preserve=3Dxattr` gets an
> > > error when copying xattrs from a read only file. Since this has
> > > been an xattr issue since the start, we'll have to work around
> > > it.
> >
> > In that context I would call it a bug - shouldn't it be fixed?
>
> It seems pretty late for change behaviour that has been around
> since 2002. =A0But if this was a new interface I would agree with you
> that the behaviour is illogical.

I didn't restrict to fix xattr behaviour, but "cp" should be fixed. =

After all, the bug exists since 2002, so "cp" should also work around it =

to get it's own parameters right.

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
