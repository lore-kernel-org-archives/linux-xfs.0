Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6QA4BkJ112986 for <xfs@oss.sgi.com>; Mon, 26 Jul 2010 05:04:11 -0500
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 07AC8471319
	for <xfs@oss.sgi.com>; Mon, 26 Jul 2010 03:07:13 -0700 (PDT)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id 4hZwepoj7TfD4286 for
	<xfs@oss.sgi.com>; Mon, 26 Jul 2010 03:07:13 -0700 (PDT)
Date: Mon, 26 Jul 2010 12:07:08 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: 4k drives: benefits and models?
Message-ID: <20100726120708.53ac63e3@harpe.intellique.com>
In-Reply-To: <19533.22251.225560.835077@tree.ty.sabi.co.uk>
References: <20100726082141.GA8239@apartia.fr>
	<19533.22251.225560.835077@tree.ty.sabi.co.uk>
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
To: Peter Grandi <pg_xf2@xf2.for.sabi.co.UK>
Cc: Linux XFS <xfs@oss.sgi.com>

Le Mon, 26 Jul 2010 10:35:39 +0100
pg_xf2@xf2.for.sabi.co.UK (Peter Grandi) =E9crivait:

> It is purely higher density. A longer physical sector means less
> percentage of the disk is "wasted" on metadata. This benefits
> the manufacturer mostly, so they can claim more capacity with
> less cost (but more credibly than the far more slimy trick of
> LCD manufacturers who are going to ever more extreme landscape
> ratios to claim a longer diagonal with less pixels).
> =


It isn't actually that simple. By keeping the same metadata ratio, the
largest correctable error goes up from 10 bytes to 80 bytes. That means
taht the new drives should be much less prone to uncorrectable ECC
errors, which are the real culprit with the previous generation of big
drives (Seagate barracuda 1, 1.5 and 2TB are particularly terrible IMO).

> From the user/filesystem point iof view it is not a positive
> thing, but since the 4BSD FFS introduced 4KiB blocks (a very bad
> idea) and intel and others followed throught with alrge 4KiB
> pages that has been largely irrelevant.

This was eons ago, I'm pretty sure we managed to live with it :) What
was problematic back when disks drives were in the hundreds of
megabytes isn't so much a problem when the smallest drives available
(146 GB) are 1000 times bigger. Many filesystems use much bigger blocks
on bigger filesystems, too (NTFS anyone? WS2003 can use 16, 32 or even
64 KB).

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
