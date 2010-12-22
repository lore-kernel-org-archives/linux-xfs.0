Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBMGsESZ259435 for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 10:54:14 -0600
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E8AB31473E1D
	for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 08:56:10 -0800 (PST)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id ZHWu91bBfFb5txxD for
	<xfs@oss.sgi.com>; Wed, 22 Dec 2010 08:56:10 -0800 (PST)
Date: Wed, 22 Dec 2010 17:56:11 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Anyone using XFS in production on > 20TiB volumes?
Message-ID: <20101222175611.1c7d5190@harpe.intellique.com>
In-Reply-To: <alpine.DEB.2.00.1012221128440.5245@p34.internal.lan>
References: <alpine.DEB.2.00.1012221128440.5245@p34.internal.lan>
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
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: xfs@oss.sgi.com

Le Wed, 22 Dec 2010 11:30:05 -0500 (EST)
Justin Piszcz <jpiszcz@lucidpixels.com> =E9crivait:

> Is there anyone currently using this in production?

Yup, lots of people do. Currently supporting 28 such systems (from 20
to 76 TiB, most are 39.7 TiB).

> How much ram is needed when you fsck with a many files on such a
> volume? Dave Chinner reported 5.5g or so is needed for ~43TB with no
> inodes. Any recent issues/bugs one needs to be aware of?

I never had any trouble running xfs_repair on 39.7 TB+ systems with 8 GB
of RAM.

> Is inode64 recommended on a 64-bit system?

Sure, however 32 bits clients may scoff sometimes, though it's limited
to some weird programs.

> Any specific 64-bit tweaks/etc for a large 43TiB FS?
> =


Nothing unusual (inode64,noatime, mkfs with lazy-count enabled, etc). It
should just works.

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
