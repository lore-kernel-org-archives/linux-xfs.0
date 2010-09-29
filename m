Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8TNNokB098479 for <xfs@oss.sgi.com>; Wed, 29 Sep 2010 18:23:51 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EF672188AF7E
	for <xfs@oss.sgi.com>; Wed, 29 Sep 2010 16:24:48 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	ozSEy06ej7epOjR4 for <xfs@oss.sgi.com>;
	Wed, 29 Sep 2010 16:24:48 -0700 (PDT)
Date: Thu, 30 Sep 2010 09:24:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfstests: Use $MKFS_OPTIONS in _scratch_mkfs_*()
Message-ID: <20100929232445.GR5665@dastard>
References: <1285770951-27000-1-git-send-email-lczerner@redhat.com>
	<1285770951-27000-2-git-send-email-lczerner@redhat.com>
	<201009291954.32292.arekm@maven.pl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201009291954.32292.arekm@maven.pl>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Arkadiusz Miskiewicz <arekm@maven.pl>
Cc: xfs@oss.sgi.com

On Wed, Sep 29, 2010 at 07:54:32PM +0200, Arkadiusz Miskiewicz wrote:
> On Wednesday 29 of September 2010, Lukas Czerner wrote:
> > Pass MKFS_OPTIONS to mkfs.$FSTYP in _scratch_mkfs_sized().
> > Preserve user defined MKFS_OPTIONS in _scratch_mkfs_geom().
> > ---
> >  common.rc |    6 +++---
> >  1 files changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/common.rc b/common.rc
> [...]
> >      case $FSTYP in
> >      xfs)
> > -	MKFS_OPTIONS="-b size=$blocksize, -d su=$sunit_bytes,sw=$swidth_mult"
> > +	MKFS_OPTIONS+="-b size=$blocksize, -d su=$sunit_bytes,sw=$swidth_mult"
> 
> common.rc uses /bin/sh and += notation is a bashizm. Won't work on strict 
> posix shells.

We've converted all of xfstests to use bash rather than bin/sh because of
all the bashisms in the code, so this is fine.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
