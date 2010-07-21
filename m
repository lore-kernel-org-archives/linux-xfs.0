Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6L6piQX065840 for <xfs@oss.sgi.com>; Wed, 21 Jul 2010 01:51:44 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3FF4ABF7158
	for <xfs@oss.sgi.com>; Wed, 21 Jul 2010 00:01:28 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	QoLOFQF5yr38A29H for <xfs@oss.sgi.com>;
	Wed, 21 Jul 2010 00:01:28 -0700 (PDT)
Date: Wed, 21 Jul 2010 16:54:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Calculating swidth On A RAID6 Volume
Message-ID: <20100721065429.GX32635@dastard>
References: <3C5E029826A0704DB5998577FCFF46F0094DA1AD69@dagobah>
	<4C45AF09.5090901@dermichi.com>
	<20100720164444.4c1cef88@harpe.intellique.com>
	<201007201700.51977@zmi.at>
	<20100720172704.609477f4@harpe.intellique.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100720172704.609477f4@harpe.intellique.com>
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

On Tue, Jul 20, 2010 at 05:27:04PM +0200, Emmanuel Florac wrote:
> Le Tue, 20 Jul 2010 17:00:51 +0200
> Michael Monnerie <michael.monnerie@is.it-management.at> =E9crivait:
> =

> > I'd say using su+sw is more future proof than swidth+sunit, as 4K
> > sector drives will become standard, and then using 512B units will be
> > outdated anyway, right?
> =

> Absolutely, and furthermore I'm wondering what's happening in the
> case where the drives have 4096 bytes blocks; I suppose then sunit
> should be expressed as a number of 4096 bytes blocks, and what about
> swidth ? the hell if I know :) This is also probably a nice little nest
> of coming filesystem bugs to be hatched :=3D)

No, the sky is not going to fall. ;)

The stripe unit is not related to sector size except for the fact
that sector size defines the minimum filesystem block size and the
stripe unit is an integer mutliple of the filesystem block size.
i.e.

mkfs.xfs -s size=3D512 -b size=3D512 -d sunit=3D1,swidth=3D1

is a valid configuration that gives single sector sunit/swidth
alignment. Hence sunit needs to be able to express sizes in
multiples of 512 bytes.

For a 4k sector size drive, the equivalent is:

mkfs.xfs -s size=3D4096 -b size=3D4096 -d sunit=3D8,swidth=3D8

and mkfs.xfs will ensure that any value of sunit that is not
a multiple of 8 (4k) will be rejected.....

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
