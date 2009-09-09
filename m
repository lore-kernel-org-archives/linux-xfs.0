Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n89MEVIr184023 for <xfs@oss.sgi.com>; Wed, 9 Sep 2009 17:14:41 -0500
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BB9A543C20B
	for <xfs@oss.sgi.com>; Wed,  9 Sep 2009 15:14:52 -0700 (PDT)
Received: from mailsrv1.zmi.at (mailsrv5.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id VppKRglF8wGfNoTb for
	<xfs@oss.sgi.com>; Wed, 09 Sep 2009 15:14:52 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id C55F0687
	for <xfs@oss.sgi.com>; Thu, 10 Sep 2009 00:14:11 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 95F7B400169
	for <xfs@oss.sgi.com>; Thu, 10 Sep 2009 00:14:18 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: fsetxattr() fails on a writable descriptor?
Date: Thu, 10 Sep 2009 00:14:10 +0200
References: <1251987642.3855.36.camel@dhcp-lab-219.englab.brq.redhat.com>
	<20090908184049.GA22050@infradead.org>
	<4AA81CDB.8070509@draigBrady.com>
In-Reply-To: <4AA81CDB.8070509@draigBrady.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200909100014.10833@zmi.at>
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

On Mittwoch 09 September 2009 P=E1draig Brady wrote:
> The specific issue we have is that `cp --preserve=3Dxattr` gets an
> error when copying xattrs from a read only file. Since this has been
> an xattr issue since the start, we'll have to work around it.

In that context I would call it a bug - shouldn't it be fixed? When you =

copy and want xattrs, and it fails sometimes, that's not what's =

expected. So if xattr is broken from day one and it should stay like =

this, should a bug report to "cp" be opened?
Do you get the same error when "rsync -aHAX"? I always use that to make =

a 1:1 copy, but if said problem exists that would be troublesome.

> [ch writes:]
> It seems a bit unusual, but I'm not sure changing it now
> is a good idea - the xattr support has been around for a long time.

I don't understand the inner depths, and didn't from the OP code, =

but a failing "cp" is not nice, too. Why shouldn't the behaviour be =

fixed?

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
