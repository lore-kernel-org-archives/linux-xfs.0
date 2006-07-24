Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Jul 2006 15:45:20 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6OMigDW002687
	for <xfs@oss.sgi.com>; Mon, 24 Jul 2006 15:44:54 -0700
Date: Tue, 25 Jul 2006 08:43:56 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: XFS setting custom extent size: real-time section only?
Message-ID: <20060725084356.B2090627@wobbly.melbourne.sgi.com>
References: <20060724100030.E2083275@wobbly.melbourne.sgi.com> <20060724110338.62600.qmail@web31709.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060724110338.62600.qmail@web31709.mail.mud.yahoo.com>; from hgheist@yahoo.com on Mon, Jul 24, 2006 at 04:03:38AM -0700
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Heilige Gheist <hgheist@yahoo.com>
Cc: xfs@oss.sgi.com

On Mon, Jul 24, 2006 at 04:03:38AM -0700, Heilige Gheist wrote:
> I've checked source code of 2.6.16.13-4 in SUSE 10.1, it looks like
> this limitation is no longer there.
> However the lack of support for this in SLES9 complicates things a bit,
> for example we're using EMC PowerPath 4.5.1 for MPIO and it doesn't
> support anything but SLES9 SP2. Hardware driver support is shaky as
> well.

OK.  Are you certain you need this feature?  (can you describe your
usage a bit?)  You can get large contiguous chunks of disk space via
large direct writes for example, or preallocation, so maybe you could
attack the issue from a different angle to solve it?

> Provided I have to stick with whatever kernel support there's in SLES9,
> what are the implications of running large volumes (150-300GB) as one
> big real-time section?

I'm not sure off the top of my head (SLES9 SP2 is relatively old now) if
the realtime subvolume support there had support for buffered writes (it
used to be direct IO only), I suspect it predated that change too.

> Do I have to have non-realtime regular section?

Yes.  All metadata is stored there.

> Should I expect a performance hit due to large size of real-time
> section?

It depends. :)  For single disk, I've never seen realtime not outperform
the btree allocator, for RAIDs and multiple writers I suspect you might
find a different picture.  You'd really have to try it and see how your
specific application(s) perform.

cheers.

-- 
Nathan
