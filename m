Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4L0Eefg118674 for <xfs@oss.sgi.com>; Fri, 20 May 2011 19:14:41 -0500
Date: Sat, 21 May 2011 10:14:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 2.6.39-rc3, 2.6.39-rc4: XFS lockup - regression since 2.6.38
Message-ID: <20110521001431.GS32466@dastard>
References: <20110423224403.5fd1136a@neptune.home>
	<20110427050850.GG12436@dastard>
	<20110427182622.05a068a2@neptune.home>
	<20110428194528.GA1627@x4.trippels.de>
	<20110429011929.GA13542@dastard>
	<20110520112018.GB3867@belkar.wrar.name>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110520112018.GB3867@belkar.wrar.name>
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
To: Andrey Rahmatullin <wrar@altlinux.org>
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, xfs-masters@oss.sgi.com, Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>, Alex Elder <aelder@sgi.com>, Markus Trippelsdorf <markus@trippelsdorf.de>

On Fri, May 20, 2011 at 05:20:18PM +0600, Andrey Rahmatullin wrote:
> On Fri, Apr 29, 2011 at 11:19:29AM +1000, Dave Chinner wrote:
> > > x4 ~ # xfs_info /
> > > meta-data=/dev/root              isize=256    agcount=4, agsize=1949824 blks
> > >          =                       sectsz=512   attr=2
> > > data     =                       bsize=4096   blocks=7799296, imaxpct=25
> > >          =                       sunit=128    swidth=128 blks
> > > naming   =version 2              bsize=4096   ascii-ci=0
> > > log      =internal               bsize=4096   blocks=3808, version=2
> > >          =                       sectsz=512   sunit=8 blks, lazy-count=1
> > > realtime =none                   extsz=4096   blocks=0, rtextents=0
> > OK, so the common elements here appears to be root filesystems
> > with small log sizes, which means they are tail pushing all the
> > time metadata operations are in progress. 
> Does that mean that such filesystems are not optimal in terms of
> performance and/or reliability and should have larger log sizes?

Performance. Larger logs generally result in faster metadata
performance, but it's really dependent on your workload and storage
as to whether it makes any difference.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
