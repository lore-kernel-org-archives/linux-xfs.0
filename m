Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 476277CA0
	for <xfs@oss.sgi.com>; Sat,  4 Jun 2016 21:17:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 01D25304048
	for <xfs@oss.sgi.com>; Sat,  4 Jun 2016 19:17:15 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	ZgBEcOKdJttX0cqB for <xfs@oss.sgi.com>;
	Sat, 04 Jun 2016 19:17:13 -0700 (PDT)
Date: Sun, 5 Jun 2016 12:16:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS hole punch races
Message-ID: <20160605021654.GX26977@dastard>
References: <20160322155740.GB28772@quack.suse.cz>
	<1465060270.2847.149.camel@decadent.org.uk>
	<20160604232800.GW26977@dastard>
	<1465089572.2847.180.camel@decadent.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1465089572.2847.180.camel@decadent.org.uk>
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
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Jan Kara <jack@suse.cz>, stable@vger.kernel.org, xfs@oss.sgi.com

On Sun, Jun 05, 2016 at 02:19:32AM +0100, Ben Hutchings wrote:
> On Sun, 2016-06-05 at 09:28 +1000, Dave Chinner wrote:
> > On Sat, Jun 04, 2016 at 06:11:10PM +0100, Ben Hutchings wrote:
> > > On Tue, 2016-03-22 at 16:57 +0100, Jan Kara wrote:
> > > =

> > > Hi,
> > > =

> > > similarly to ext4 also XFS had races between hole punching and page f=
aults
> > > which could result in data corruption. The fixes were merged in 4.1-r=
c1 but
> > > it might make sense to backport them to older stable releases given t=
he
> > > nature of the issue.
> > > =

> > > Relevant fixes are:
> > > =

> > > de0e8c20ba3a65b0f15040aabbefdc1999876e6b
> > > 075a924d45cc69c75a35f20b4912b85aa98b180a
> > > e8e9ad42c1f1e1bfbe0e8c32c8cac02e9ebfb7ef
> > > 0f9160b444e4de33b65dfcd3b901358a3129461a
> > > 723cac48473358939759885a18e8df113ea96138
> > > ec56b1f1fdc69599963574ce94cc5693d535dd64
> > > =

> > > =

> > > You missed the first in that sequence:
> > > =

> > > 653c60b633a9 xfs: introduce mmap/truncate lock
> > > =

> > > For 3.16, I've queued up all=A0those fixes with one further=A0prerequ=
isite:
> > > =

> > > 812176832169 xfs: fix swapext ilock deadlock
> > > =

> > > For 3.2, I've queued up all but 723cac484733, with these additional
> > > prerequisites:
> > > =

> > > f38996f57687 xfs: reduce ilock hold times in xfs_setattr_size
> > > bc4010ecb8f4 xfs: use iolock on XFS_IOC_ALLOCSP calls
> > > 76ca4c238cf5 xfs: always take the iolock around xfs_setattr_size
> > > 5f8aca8b43f4 xfs: always hold the iolock when calling xfs_change_file=
_space
> > > I realise I'll need to check for regressions with xfstests.
> > =

> > Hi Ben,
> > =

> > You do realise that this sort of backport effectively makes the
> > stable kernels unsupportable by the upstream XFS developers? You're
> > taking random changes from the upstream kernel until the kernel
> > compiles, and then mostly hoping that it works.
> =

> I'm applying slightly more intelligence than that, but of course I'm
> not an XFS developer.

Sorry, Ben, I didn't mean to imply you hadn't done your due diligence
properly. It's more a case of lots of things around these patches
also changed, and from that perspective the changes are effective a
random selection of changes spread across several years of
development.

It's subtle things, like changes to how IO completion is processed
(especially for AIO), etc that the backported code might depend on
for correct behaviour but aren't in the older kernels. These sorts
of subtle problems are typically only discovered by users with
uncommon applications and/or load....

> > Stable kernels are supposed to be stable, and backports like this
> > are riskier than the original changes in the upstream kernels. if a
> > user is hitting a mmap/hole-punch race on an XFS filesytem (I can't
> > remember any reports to the upstream list for any kernel) on a 3.2
> > kernel, then correct answer is "upgrade to a newer upstream kernel",
> > not "do a risky backport that exposes the entire user base to the
> > potential of new data corruption bugs"....
> =

> OK, then I'll drop them for 3.2.

Probably for the best - these mmap/holepunch races had been in the
code since XFS was first ported, so it's not like it's a new
problem. :/

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
