Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 846F37CBF
	for <xfs@oss.sgi.com>; Mon,  3 Jun 2013 21:53:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6D8F2304051
	for <xfs@oss.sgi.com>; Mon,  3 Jun 2013 19:53:10 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	8yeSeK3WInjGM01A for <xfs@oss.sgi.com>;
	Mon, 03 Jun 2013 19:53:09 -0700 (PDT)
Date: Tue, 4 Jun 2013 12:53:07 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Debunking myths about metadata CRC overhead
Message-ID: <20130604025307.GB29466@dastard>
References: <20130603074452.GZ29466@dastard>
	<20130603111011.461d10b5@galadriel.home>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130603111011.461d10b5@galadriel.home>
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

On Mon, Jun 03, 2013 at 11:10:11AM +0200, Emmanuel Florac wrote:
> Le Mon, 3 Jun 2013 17:44:52 +1000 vous =E9criviez:
> =

> > There has been some assertions made recently that metadata CRCs have
> > too much overhead to always be enabled.  So I'll run some quick
> > benchmarks to demonstrate the "too much overhead" assertions are
> > completely unfounded.
> =

> Just a quick question: what is the minimal kernel version and xfsprogs
> version needed to run xfs with metadata CRC? I'd happily test it on
> real hardware, I have a couple of storage servers in test in the 40 to
> 108 TB range.

If the maintainers merge all the patches I send for the 3.10-rc
series, then the 3.10 release should be stable enough to use for
testing with data you don't care if you lose.

As for the userspace code - that is still just a patchset. I haven't
had any feedback from the maintainers about it in the past month, so
I've got no idea what they are doing with it. I'll post out a new
version in the next couple of days - it's 50-odd patches by now, so
it'd be nice to have it in the xfsprogs git tree so people could
just pull it and build it for testing purposes by the time that 3.10
releases....

Cheers,

Dave
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
