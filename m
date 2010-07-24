Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6O0pR3W232536 for <xfs@oss.sgi.com>; Fri, 23 Jul 2010 19:51:27 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 02E1046E0EE
	for <xfs@oss.sgi.com>; Fri, 23 Jul 2010 17:54:28 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	rpoNrVqVT2OhI5WZ for <xfs@oss.sgi.com>;
	Fri, 23 Jul 2010 17:54:28 -0700 (PDT)
Date: Sat, 24 Jul 2010 10:54:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: filesystem shrinks after using xfs_repair
Message-ID: <20100724005426.GN32635@dastard>
References: <DFB2DB04-A3BA-4272-A12A-4F28A7D51491@ucsc.edu>
	<20100712134743.624249b2@harpe.intellique.com>
	<274A8D0C-4C31-4FB9-AB2D-BA3C31D497E0@ucsc.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <274A8D0C-4C31-4FB9-AB2D-BA3C31D497E0@ucsc.edu>
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
To: Eli Morris <ermorris@ucsc.edu>
Cc: xfs@oss.sgi.com

On Fri, Jul 23, 2010 at 01:30:40AM -0700, Eli Morris wrote:
> On Jul 12, 2010, at 4:47 AM, Emmanuel Florac wrote:
> =

> > Le Sun, 11 Jul 2010 18:10:41 -0700
> > Eli Morris <ermorris@ucsc.edu> =E9crivait:
> > =

> >> Here are some of the log files from my XFS problem. Yes, I think this
> >> all started with a hardware failure of some sort. My storage is RAID
> >> 6, a an Astra SecureStor ES.
> >> =

> > =

> > There are IO errors on sdc, sdd and sdg. Aren't these jbods connected
> > through the same cable, for instance? You must correct the hardware
> > problems before attempting any repair or it will do more harm than good.
> > =

> > -- =

> > ------------------------------------------------------------------------
> > Emmanuel Florac     |   Direction technique
> >                    |   Intellique
> >                    |	<eflorac@intellique.com>
> >                    |   +33 1 78 94 84 02
> > ------------------------------------------------------------------------
> =

> Hi Emmanuel,
> =

> I think the raid tech support and me found and corrected the
> hardware problems associated with the RAID. I'm still having the
> same problem though. I expanded the filesystem to use the space of
> the now corrected RAID and that seems to work OK. I can write
> files to the new space OK. But then, if I run xfs_repair on the
> volume, the newly added space disappears and there are tons of
> error messages from xfs_repair (listed below).

Can you post the full output of the xfs_repair? The superblock is
the first thing that is checked and repaired, so if it is being
"repaired" to reduce the size of the volume then all the other errors
are just a result of that. e.g. the grow could be leaving stale
secndary superblocks around and repair is seeing a primary/secondary
mismatch and restoring the secondary which has the size parameter
prior to the grow....

Also, the output of 'cat /proc/partitions' would be interesting
from before the grow, after the grow (when everything is working),
and again after the xfs_repair when everything goes bad....

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
