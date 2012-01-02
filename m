Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q02KZmxo236447 for <xfs@oss.sgi.com>; Mon, 2 Jan 2012 14:35:49 -0600
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	wkjkc0wCxpFCSSR1 for <xfs@oss.sgi.com>;
	Mon, 02 Jan 2012 12:35:46 -0800 (PST)
Date: Tue, 3 Jan 2012 07:35:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Bad performance with XFS + 2.6.38 / 2.6.39
Message-ID: <20120102203543.GP23662@dastard>
References: <CACaf2aYTsxOBXEJEbQu7gwAminBc3R2usDHvypJW0AqOfnz0Pg@mail.gmail.com>
	<20111212010053.GM14273@dastard>
	<CACaf2ab-YjXAFm767MmRU5iuOmvkqQW3ZTfQewD5SGvF-opgYQ@mail.gmail.com>
	<4EF1A224.2070508@univ-nantes.fr>
	<4EF1F6DD.8020603@hardwarefreak.com>
	<4EF21DD2.3060004@univ-nantes.fr> <20111221222623.GF23662@dastard>
	<4EF2F702.4050902@univ-nantes.fr> <4EF30E5D.7060608@univ-nantes.fr>
	<4F0181A2.5010505@univ-nantes.fr>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F0181A2.5010505@univ-nantes.fr>
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
To: Yann Dupont <Yann.Dupont@univ-nantes.fr>
Cc: stan@hardwarefreak.com, xfs@oss.sgi.com

On Mon, Jan 02, 2012 at 11:06:26AM +0100, Yann Dupont wrote:
> Le 22/12/2011 12:02, Yann Dupont a =E9crit :
> >Le 22/12/2011 10:23, Yann Dupont a =E9crit :
> >>
> >>>Can you run a block trace on both kernels (for say five minutes)
> >>>when the load differential is showing up and provide that to us so
> >>>we can see how the IO patterns are differing?
> >
> >
> >here we go.
> >
> =

> Hello, happy new year everybody ,
> =

> Did someone had time to examine the 2 blktrace ? (and, by chance,
> can see the root cause of the increased load ?)

I've had a bit of a look, but most peopl ehave been on holidays.

As it is, I can't see any material difference between the traces.
both reads and writes are taking the same amount of time to service,
so I don't think there's any problem here.

I do recall that some years ago that we changed one of the ways we
slept in XFS which meant those blocked IOs contributed to load
average (as tehy are supposed to). That meant that more IO
contributed to the load average (it might have been read related),
so load averages were then higher for exactly the same workloads.

Indeed:

load average: 0.64, 0.15, 0.09

(start 40 concurrent directory traversals w/ unlinks)

(wait a bit)

load average: 39.96, 23.75, 10.06

Yup, that is spot on - 40 processes doing blocking IO.....

So absent any measurable performance problem, I don't think the
change in load average is something to be concerned about.

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
