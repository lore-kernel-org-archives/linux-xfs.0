Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EB4A47CBF
	for <xfs@oss.sgi.com>; Tue,  4 Jun 2013 11:20:34 -0500 (CDT)
Date: Tue, 4 Jun 2013 11:20:30 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: Debunking myths about metadata CRC overhead
Message-ID: <20130604162030.GJ20932@sgi.com>
References: <20130603074452.GZ29466@dastard>
	<20130603111011.461d10b5@galadriel.home>
	<20130604025307.GB29466@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130604025307.GB29466@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Dave,

On Tue, Jun 04, 2013 at 12:53:07PM +1000, Dave Chinner wrote:
> On Mon, Jun 03, 2013 at 11:10:11AM +0200, Emmanuel Florac wrote:
> > Le Mon, 3 Jun 2013 17:44:52 +1000 vous =E9criviez:
> > =

> > > There has been some assertions made recently that metadata CRCs have
> > > too much overhead to always be enabled.  So I'll run some quick
> > > benchmarks to demonstrate the "too much overhead" assertions are
> > > completely unfounded.
> > =

> > Just a quick question: what is the minimal kernel version and xfsprogs
> > version needed to run xfs with metadata CRC? I'd happily test it on
> > real hardware, I have a couple of storage servers in test in the 40 to
> > 108 TB range.
> =

> If the maintainers merge all the patches I send for the 3.10-rc
> series, then the 3.10 release should be stable enough to use for
> testing with data you don't care if you lose.
> =

> As for the userspace code - that is still just a patchset. I haven't
> had any feedback from the maintainers about it in the past month, so
> I've got no idea what they are doing with it. I'll post out a new
> version in the next couple of days - it's 50-odd patches by now, so
> it'd be nice to have it in the xfsprogs git tree so people could
> just pull it and build it for testing purposes by the time that 3.10
> releases....

When it is reviewed and adequately tested we'll pull it in.  Until then
Emmanuel will need to pull down the patchset.  Right now the focus is on
3.10.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
