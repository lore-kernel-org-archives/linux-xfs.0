Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q282ewQm195438 for <xfs@oss.sgi.com>; Wed, 7 Mar 2012 20:40:59 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	FuVAc6zYay5Vs0fU for <xfs@oss.sgi.com>;
	Wed, 07 Mar 2012 18:40:55 -0800 (PST)
Date: Thu, 8 Mar 2012 13:40:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS filesystem setfacl has limitation?
Message-ID: <20120308024053.GN3592@dastard>
References: <4F56C4D5.1070206@eisoo.com> <20120307044242.GJ3592@dastard>
	<20120307221613.1014ea82@galadriel.home>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120307221613.1014ea82@galadriel.home>
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
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com

On Wed, Mar 07, 2012 at 10:16:13PM +0100, Emmanuel Florac wrote:
> Le Wed, 7 Mar 2012 15:42:42 +1100 vous =E9criviez:
> =

> > It's basically a limitation of the on-disk format definition that
> > has been carried over from Irix. It is an arbitrary limit - the real
> > limit is the maximum size of an attribute (64KB) and we plan to
> > raise it to that limit as part of the upcoming on-disk format
> > changes for metadata checksums...
> > =

> =

> What's the proposed time frame or kernel version for this change?

When it is ready. Think months, not years ;)

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
