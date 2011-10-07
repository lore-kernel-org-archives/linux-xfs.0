Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p97NVNQt008221 for <xfs@oss.sgi.com>; Fri, 7 Oct 2011 18:31:23 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EBF7B1B846D
	for <xfs@oss.sgi.com>; Fri,  7 Oct 2011 16:31:22 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	46u6ah91R2nGR63o for <xfs@oss.sgi.com>;
	Fri, 07 Oct 2011 16:31:22 -0700 (PDT)
Date: Sat, 8 Oct 2011 10:31:19 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Premature "No Space left on device" on XFS
Message-ID: <20111007233119.GJ3159@dastard>
References: <4E8E079B.4040103@birkenwald.de> <20111007013711.GW3159@dastard>
	<1317995933.17433.YahooMailNeo@web122515.mail.ne1.yahoo.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1317995933.17433.YahooMailNeo@web122515.mail.ne1.yahoo.com>
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
To: Bryan J Smith <b.j.smith@ieee.org>
Cc: Bernhard Schmidt <berni@birkenwald.de>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, Oct 07, 2011 at 06:58:53AM -0700, Bryan J Smith wrote:
> [ Not really adding any technical meat, but just some past
> experience with XFS, plus Ext3 experience ]
> =

> I remember running into this a long time ago when I was first
> playing with XFS for /tmp and /var (I was still a Linux/XFS noob
> at the time, not that I'm an expert today).=A0 I ran into the same
> case where both free block and inodes were still available
> (although similarly well utilized), and the median file size was
> around 1KiB.=A0 It was also in the case of many small files being
> written out in a short period.
> =

> In my case, I didn't use the XFS debugger to get into the
> allocation of the extents (would have if I wasn't such a noob,
> good, discrete command to know, thanx!).
> =

> Extents are outstanding for data and similar directories, ordering
> and placing large and small files to mitigate fragmentation.=A0 But
> in this case, and correct me if I'm wrong, it's really just a
> wasteful use for the extents approach, as the files typically fit
> in a single data block or two.=A0

And single blocks still an extent, so there's nothing "wasted" by
having a single block extent.

....

> I've used Ext3 with around 8 million files with a median size well
> under 4KiB (under 32GiB total).=A0 It works "well enough."=A0 I'm
> curious how Ext4 would do though.=A0 I think Ric Wheeler's team (at
> Red Hat) has done some benchmarks on 7+ figure file counts on Ext3
> and Ext4.

And against XFS, too. In case you didn't realise, you're talking to
the person who ran a large number of those tests. ;)

The results were ext4 is good for create/delete workloads up to 2-4
threads and about 100k files per directory on a decent disk
subsystem (4000 iops). It's much better than ext3, and for those
workloads about 2x as fast as XFS at 1-2 threads. This pattern held
true as long as the disk subsystem could handle the number of iops
that ext4 threw at it. XFS performance came at a much, much lower
iops cost (think order of magnitude), so shoul dbe more consistent
on a wider range of storage hardware than ext4.

However, XFS was about 3x faster on cold cache lookups than ext4, so
if you're workload is dominated by lookups, XFS is definitely the
faster filesystem to use even if creates/unlinks on ext4 are
faster..

As soon as you have more parallelism than 2-4 threads or large
directories, XFS create/unlink speed surpasses ext4 by a large
amount - the best I got out of ext4 was ~80k creates a second, while
XFS topped 130k creates/s at 8 threads. And the lookup speed
differential increase in XFS's favour at larger thread counts as
well.

So it really depends on your workload as to which filesystem will
handle your small files best. Mail spools tend to have lots of
parallelism, which is why XFS works pretty well, even though it is
a small file workload.

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
