Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o876pI4R228089 for <xfs@oss.sgi.com>; Tue, 7 Sep 2010 01:51:18 -0500
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DC659D902D6
	for <xfs@oss.sgi.com>; Tue,  7 Sep 2010 00:03:05 -0700 (PDT)
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id cPAN5QvAAkMsHiJz for
	<xfs@oss.sgi.com>; Tue, 07 Sep 2010 00:03:05 -0700 (PDT)
Date: Tue, 7 Sep 2010 08:46:43 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: LWN.net article: creating 1 billion files -> XFS looses
Message-ID: <20100907084643.1f6cfa93@galadriel.home>
In-Reply-To: <20100906220410.GD7362@dastard>
References: <201008191312.49346@zmi.at>
	<20100906154254.5542426c@harpe.intellique.com>
	<20100906220410.GD7362@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Le Tue, 7 Sep 2010 08:04:10 +1000 vous =E9criviez:

> Oh, that's larger than I've ever run before ;)

Excellent :) Still works fine afterwards; mount, umount, etc works
flawlessly. Memory consumption though is huge :)
> =

> Try using:
> =

> # mkfs.xfs -d size=3D64k
> =

> Will speed up large directory operations by at least an order of
> magnitude.

OK, we'll try that too :)
 =

> > Now we're starting afresh with 1000 directories with 1 million files
> > each :)
> =

> Which is exactly the test that was used to generate the numbers that
> were published.
> =

> > (Kernel version used : vanilla 2.6.32.11 x86_64 smp)
> =

> Not much point in testing that kernel - delayed logging is where the
> future is for this sort of workload, which is what I'm testing.

I'll compile a 2.6.36rc for comparison.

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
