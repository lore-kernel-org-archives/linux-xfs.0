Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3PLh2hK037134 for <xfs@oss.sgi.com>; Sun, 25 Apr 2010 16:43:02 -0500
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3B66F2EEFE9
	for <xfs@oss.sgi.com>; Sun, 25 Apr 2010 14:45:02 -0700 (PDT)
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id brLEdgcJdB865DCq for
	<xfs@oss.sgi.com>; Sun, 25 Apr 2010 14:45:02 -0700 (PDT)
Date: Sun, 25 Apr 2010 23:44:42 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: xfs_fsr question for improvement
Message-ID: <20100425234442.319ff069@galadriel.home>
In-Reply-To: <4BD4AE62.9080600@sandeen.net>
References: <201004161043.11243@zmi.at> <20100417012415.GE2493@dastard>
	<20100417091357.4e7ad1e0@galadriel.home>
	<19412.9412.177637.116303@tree.ty.sabi.co.uk>
	<20100425150209.5167fe96@galadriel.home>
	<4BD4AE62.9080600@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Peter Grandi <pg_xf2@xf2.for.sabi.co.UK>, Linux XFS <xfs@oss.sgi.com>

Le Sun, 25 Apr 2010 16:04:34 -0500 vous =E9criviez:

> If it's all large writes, you could mount -o allocsize=3D512m or so:
> =

>   allocsize=3Dsize
>         Sets the buffered I/O end-of-file preallocation size when
>         doing delayed allocation writeout (default size is 64KiB).
>         Valid values for this option are page size (typically 4KiB)
>         through to 1GiB, inclusive, in power-of-2 increments.
> =

> and that might help.

Oh yes, nice idea indeed! I'll try it.

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
