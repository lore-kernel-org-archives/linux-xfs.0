Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8NKSGHi033954 for <xfs@oss.sgi.com>; Wed, 23 Sep 2009 15:28:17 -0500
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BC45D477969
	for <xfs@oss.sgi.com>; Wed, 23 Sep 2009 13:29:33 -0700 (PDT)
Received: from mailsrv1.zmi.at (mailsrv5.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id LUMays0WIMhzYjaF for
	<xfs@oss.sgi.com>; Wed, 23 Sep 2009 13:29:33 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id 498C4689
	for <xfs@oss.sgi.com>; Wed, 23 Sep 2009 22:29:07 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id BEB0B40016C
	for <xfs@oss.sgi.com>; Wed, 23 Sep 2009 22:29:31 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: [PATCH] fix readahead calculations in xfs_dir2_leaf_getdents()
Date: Wed, 23 Sep 2009 22:29:03 +0200
References: <4ABA5192.80509@sandeen.net> <4ABA6C2E.2080104@sandeen.net>
In-Reply-To: <4ABA6C2E.2080104@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200909232229.03395@zmi.at>
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

On Mittwoch 23 September 2009 Eric Sandeen wrote:
> so that's slowed down a bit. =A0Weird that more calls, originally, made
> it faster overall...?

You wrote in the patch description that bufsize went very large when it =

got below zero. Could it mean that a that times a big readahead appeared =

and that's why the speed improved?

Why have there been more calls before that patch?

> But one thing I noticed is that we choose readahead based on a guess
> at the readdir buffer size, and at least for glibc's readdir it has
> this:
>
> const size_t default_allocation =3D
> =A0 (4 * BUFSIZ < sizeof (struct dirent64) ?
> =A0=A0=A0=A0=A0=A0=A0=A0sizeof (struct dirent64) : 4 * BUFSIZ);
>
> where BUFSIZ is a magical 8192.
>
> But we do at max PAGE_SIZE which gives us almost no readahead ...
>
> So bumping our "bufsize" up to 32k, things speed up nicely. =A0Wonder
> if the stock broken bufsize method led to more inadvertent
> readahead....

Is it possible to increase it more, to see if things still improve? =

Maybe that made the difference in the old version?

In general, I'd opt for at least 64KB buffers, that's the smallest I/O =

size to keep hard disks busy, and RAIDs usually have 64KB stripe sets or =

bigger. But I don't know how scattered dirs in XFS are, or if you can =

expect them to be sequential.

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
