Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9028329DF8
	for <xfs@oss.sgi.com>; Tue,  4 Jun 2013 17:59:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7D1558F8035
	for <xfs@oss.sgi.com>; Tue,  4 Jun 2013 15:59:39 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	DXv6LPKcFWJZia8s for <xfs@oss.sgi.com>;
	Tue, 04 Jun 2013 15:59:37 -0700 (PDT)
Date: Wed, 5 Jun 2013 08:59:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Debunking myths about metadata CRC overhead
Message-ID: <20130604225935.GM29466@dastard>
References: <20130603074452.GZ29466@dastard>
	<20130603111011.461d10b5@galadriel.home>
	<20130604025307.GB29466@dastard>
	<1370371109.3898.10.camel@chandra-dt.ibm.com>
	<20130604220849.GK29466@dastard>
	<1370385616.22504.7.camel@chandra-dt.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1370385616.22504.7.camel@chandra-dt.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: xfs@oss.sgi.com

On Tue, Jun 04, 2013 at 05:40:16PM -0500, Chandra Seetharaman wrote:
> On Wed, 2013-06-05 at 08:08 +1000, Dave Chinner wrote:
> > On Tue, Jun 04, 2013 at 01:38:29PM -0500, Chandra Seetharaman wrote:
> > > On Tue, 2013-06-04 at 12:53 +1000, Dave Chinner wrote:
> > > > On Mon, Jun 03, 2013 at 11:10:11AM +0200, Emmanuel Florac wrote:
> > > > > Le Mon, 3 Jun 2013 17:44:52 +1000 vous =E9criviez:
> > > > > =

> > > > > > There has been some assertions made recently that metadata CRCs=
 have
> > > > > > too much overhead to always be enabled.  So I'll run some quick
> > > > > > benchmarks to demonstrate the "too much overhead" assertions are
> > > > > > completely unfounded.
> > > > > =

> > > > > Just a quick question: what is the minimal kernel version and xfs=
progs
> > > > > version needed to run xfs with metadata CRC? I'd happily test it =
on
> > > > > real hardware, I have a couple of storage servers in test in the =
40 to
> > > > > 108 TB range.
> > > > =

> > > > If the maintainers merge all the patches I send for the 3.10-rc
> > > > series, then the 3.10 release should be stable enough to use for
> > > > testing with data you don't care if you lose.
> > > > =

> > > > As for the userspace code - that is still just a patchset. I haven't
> > > > had any feedback from the maintainers about it in the past month, so
> > > > I've got no idea what they are doing with it. I'll post out a new
> > > > version in the next couple of days - it's 50-odd patches by now, so
> > > > it'd be nice to have it in the xfsprogs git tree so people could
> > > > just pull it and build it for testing purposes by the time that 3.10
> > > > releases....
> > > =

> > > Dave,
> > > =

> > > I was of the impression that the user space changes will be released
> > > sometime later (i.e when CRC comes out of experimental). If we make t=
he
> > > user space changes to create V5 filesystem now, it will be an annoyan=
ce
> > > for people that created V5 super blocks without my changes (getting r=
id
> > > of OQUOTA.* flags). =

> > =

> > People still need access to the code to test it. I'm not talking
> > about an official release here at all, just getting it committed to
> > the git tree to make it easy for people to get the code and for
> > developers to build on top of it and fix bugs.
> > =

> =

> Oh, I see. It is clear now.
> =

> Also, is there a git tree where I can pull your xfsprogs changes from ?
> I tried to apply xfsprogs-kern-sync-patchset-v2.tar.gz on top of
> xfsprogs git tree, it seems to have some problems.
> =

> Or is there a later version ?

I'm cleaning up my current tree right now. I'll post it out as soon
as it is ready to go. Hopefully Ben can get that into a branch in
the xfsprogs git tree and you can pull from there.

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
