Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5Q2V3cU046613 for <xfs@oss.sgi.com>; Mon, 25 Jun 2012 21:31:03 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	BzkaKTIkCbUuTGY7 for <xfs@oss.sgi.com>;
	Mon, 25 Jun 2012 19:31:02 -0700 (PDT)
Date: Tue, 26 Jun 2012 12:30:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: mkfs.xfs states log stripe unit is too large
Message-ID: <20120626023059.GC19223@dastard>
References: <D3F781FA-CEB0-4896-9441-772A9E533354@2012.bluespice.org>
	<20120623234445.GZ19223@dastard> <4FE67970.2030008@sandeen.net>
	<4FE710B7.5010704@hardwarefreak.com>
	<d71834a062ffd666ab53a4695eb643e9@muaddib.hro.localnet>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <d71834a062ffd666ab53a4695eb643e9@muaddib.hro.localnet>
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
To: Ingo =?iso-8859-1?Q?J=FCrgensmann?= <ij@2012.bluespice.org>
Cc: xfs@oss.sgi.com

On Sun, Jun 24, 2012 at 05:03:47PM +0200, Ingo J=FCrgensmann wrote:
> On 2012-06-24 15:05, Stan Hoeppner wrote:
> =

> >The the log stripe unit mismatch error is a direct result of Ingo
> >manually choosing a rather large chunk size for his two stripe
> >spindle
> >md array, yielding a 1MB stripe, and using an internal log with it.
> >Maybe there is a good reason for this, but I'm going to challenge it.
> =

> To cite man mdadm:
> =

>        -c, --chunk=3D
>               Specify chunk size of kibibytes.  The  default  when
>               creating an array is 512KB.  To ensure compatibility
>               with earlier versions, the default when Building and
>               array  with no persistent metadata is 64KB.  This is
>               only meaningful for RAID0, RAID4, RAID5, RAID6,  and
>               RAID10.
> =

> So, actually there's a mismatch with the default of mdadm an
> mkfs.xfs. Maybe it's worthwhile to think of raising the log stripe
> maximum size to at least 512 kiB? I don't know what implications
> this could have, though...

You can't, simple as that. The maximum supported is 256k. As it is,
a default chunk size of 512k is probably harmful to most workloads -
large chunk sizes mean that just about every write will trigger a
RMW cycle in the RAID because it is pretty much impossible to issue
full stripe writes. Writeback doesn't do any alignment of IO (the
generic page cache writeback path is the problem here), so we will
lamost always be doing unaligned IO to the RAID, and there will be
little opportunity for sequential IOs to merge and form full stripe
writes (24 disks @ 512k each on RAID6 is a 11MB full stripe write).

IOWs, every time you do a small isolated write, the MD RAID volume
will do a RMW cycle, reading 11MB and writing 12MB of data to disk.
Given that most workloads are not doing lots and lots of large
sequential writes this is, IMO, a pretty bad default given typical
RAID5/6 volume configurations we see....

Without the warning, nobody would have noticed this. I think the
warning has value - even if it is just to indicate MD now uses a
bad default value for common workloads..

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
