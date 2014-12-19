Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BDB817F3F
	for <xfs@oss.sgi.com>; Fri, 19 Dec 2014 17:06:14 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4CF97AC002
	for <xfs@oss.sgi.com>; Fri, 19 Dec 2014 15:06:11 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	bVT9axREV74LURij for <xfs@oss.sgi.com>;
	Fri, 19 Dec 2014 15:06:08 -0800 (PST)
Date: Sat, 20 Dec 2014 10:06:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: easily reproducible filesystem crash on rebuilding array
Message-ID: <20141219230605.GF24183@dastard>
References: <20141211123936.1f3d713d@harpe.intellique.com>
	<20141215130715.4dfaaa8e@harpe.intellique.com>
	<20141215132500.13210fdb@harpe.intellique.com>
	<20141215201036.GQ24183@dastard>
	<20141216123405.111c7ac0@harpe.intellique.com>
	<20141216195815.GB15665@dastard>
	<20141218164042.15220bf3@harpe.intellique.com>
	<20141218225843.GB24183@dastard>
	<20141219125720.56c5f74d@galadriel.home>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141219125720.56c5f74d@galadriel.home>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com

On Fri, Dec 19, 2014 at 12:57:20PM +0100, Emmanuel Florac wrote:
> Le Fri, 19 Dec 2014 09:58:43 +1100 vous =E9criviez:
> =

> > =

> > Where's the XFS error output? This is just the output from the
> > dump_stack() call in the xfs error message code...
> =

> Where is it supposed to display its errors? I thought it to be
> in /var/log/messages....

Depends on how you system is configured. have you turned down the
dmesg error level?

> > Still, that's implying a write IO error being reporte din IO
> > completion, not a read error, and that's different to the previous
> > issue you've reported. It's also indicative of an error coming from
> > the storage, not XFS...
> >
> > Do these problems *only* happen during or after a RAID rebuild?
> =

> Only while the rebuild process is running. All works fine afterwards.

Which pretty much points to a RAID controller rebuild bug.

> > > Phase 7 - verify and correct link counts...
> > > resetting inode 4294866029 nlinks from 2 to 5
> > > resetting inode 150323855504 nlinks from 13 to 12
> > > Metadata corruption detected at block 0x10809dc640/0x1000
> > > libxfs_writebufr: write verifer failed on bno 0x10809dc640/0x1000
> > > Metadata corruption detected at block 0x10809dc640/0x1000
> > > libxfs_writebufr: write verifer failed on bno 0x10809dc640/0x1000
> > > done
> > =

> > I'd suggest you should be upgrading xfsprogs, because that's an
> > error that shouldn't happen at the end of a repair. If the latest
> > version (3.2.2) doesn't fix this problem, then please send me a
> > compressed metadump so I can work out what corruption xfs_repair
> > isn't fixing properly.
> =

> It was 3.2.2 this time. However it seems to have fixe it anyway;
> running it a second time displays nothing special.
> Is a metadump of a clean filesystem of any use?

Not really.

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
