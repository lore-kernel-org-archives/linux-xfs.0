Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8RKjtXf204355 for <xfs@oss.sgi.com>; Mon, 27 Sep 2010 15:45:55 -0500
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EDBE01D95A17
	for <xfs@oss.sgi.com>; Mon, 27 Sep 2010 13:46:49 -0700 (PDT)
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id BEqFFjnZ0Uhoa7FH for
	<xfs@oss.sgi.com>; Mon, 27 Sep 2010 13:46:49 -0700 (PDT)
Date: Mon, 27 Sep 2010 22:46:39 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: XFS on SSD, log/metadat on spindle?
Message-ID: <20100927224639.21d74f83@galadriel.home>
In-Reply-To: <CFFC47E79E870F4EBAD0CA24D8CD7652ECD04ECD67@CRW-EXM01.int.cggveritas.com>
References: <CFFC47E79E870F4EBAD0CA24D8CD7652ECD04ECD67@CRW-EXM01.int.cggveritas.com>
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
To: Tore =?ISO-8859-1?Q?H=F8ivaag?= <tore.hoivaag.larsen@cggveritas.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Le Mon, 27 Sep 2010 19:46:54 +0100 vous =E9criviez:

>    anyone have experience with (c)xfs on SSD enabled raid?    LSI
> 7900 (aka IS4600 aka IBM DS5300) with mixed SSD and FC drives.  LSI
> FC4600 enclosure.
> =


Yes, it works well, and about 50% faster on small IO (tested with
Adaptec 52445 though). Actually it largely depends upon the way you
distribute IO on the array, but it's basically comparable to a huge
read cache.

I also tried putting the XFS log on an SSD a couple of years ago, it's
really fast (but quite a waste of a good SSD).

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
