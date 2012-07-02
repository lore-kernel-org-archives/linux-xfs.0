Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q623UKWx154419 for <xfs@oss.sgi.com>; Sun, 1 Jul 2012 22:30:20 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	h61FhUIa1YKM0fSt for <xfs@oss.sgi.com>;
	Sun, 01 Jul 2012 20:30:17 -0700 (PDT)
Date: Mon, 2 Jul 2012 13:30:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Strange case of deleting lots of files and "df" not recognizing
	it....(unless I umount/mount) the disk...
Message-ID: <20120702033014.GP19223@dastard>
References: <4FE7FDF4.6080506@tlinx.org> <20120626023302.GD19223@dastard>
	<20120626093323.3cb0cc18@galadriel.home>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120626093323.3cb0cc18@galadriel.home>
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
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, Jun 26, 2012 at 09:33:23AM +0200, Emmanuel Florac wrote:
> Le Tue, 26 Jun 2012 12:33:02 +1000 vous =E9criviez:
> =

> > As ben said, the last reference has to go away before the space is
> > freed. lsof is your friend.
> =

> I just had the same problem recently, but lsof reported zero open files
> on the volume. umount/mount worked though, I didn't thought the cache
> trick would be enough.

I think that we need a reproducable test case for this issue before
we'll be able to make any progress on it, then....

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
