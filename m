Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4P0Tq7c105885 for <xfs@oss.sgi.com>; Tue, 24 May 2011 19:29:52 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 41D9447CBAF
	for <xfs@oss.sgi.com>; Tue, 24 May 2011 17:29:50 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	V1C5cVXEqQOfmXOh for <xfs@oss.sgi.com>;
	Tue, 24 May 2011 17:29:50 -0700 (PDT)
Date: Wed, 25 May 2011 10:29:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS umount issue
Message-ID: <20110525002947.GK32466@dastard>
References: <BANLkTikNMrFzxJF4a86ZM55r3D=ThPFmOw@mail.gmail.com>
	<BANLkTin26bRHiaCxc15ZwjX__NR3QHaSFA@mail.gmail.com>
	<BANLkTimOA3W2V+0uPsjpPt=MqrbeGcfs5g@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <BANLkTimOA3W2V+0uPsjpPt=MqrbeGcfs5g@mail.gmail.com>
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
To: Nuno Subtil <subtil@gmail.com>
Cc: Paul Anderson <pha@umich.edu>, xfs-oss <xfs@oss.sgi.com>

On Tue, May 24, 2011 at 12:10:44PM -0700, Nuno Subtil wrote:
> On Tue, May 24, 2011 at 06:33, Paul Anderson <pha@umich.edu> wrote:
> > Hi Nuno - can you elaborate on the ARM hardware? =A0I noticed that my
> > XFS on ARM was mildly unstable, but felt it wasn't XFS code, but
> > rather the ARM port of Linux. =A0My test case is a Seagate Dockstar
> > hacked to run Linux.
> =

> Mine is a Netgear Stora. The interesting bit is that the stock
> firmware runs kernel 2.6.22.18 and uses XFS as well, but I don't know
> how stable it was to begin with.

Have you checked to see whether there are extra patches added to
that kernel by Netgear? It's not uncommon for these embedded systems
to run a kernel that has been patched to fix problems that you are
seeing.

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
