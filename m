Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 25 Jul 2006 16:02:17 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6PN1aDW023806
	for <xfs@oss.sgi.com>; Tue, 25 Jul 2006 16:01:47 -0700
Date: Wed, 26 Jul 2006 09:00:51 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: XFS setting custom extent size: real-time section only?
Message-ID: <20060726090051.C2118045@wobbly.melbourne.sgi.com>
References: <20060725084356.B2090627@wobbly.melbourne.sgi.com> <20060725180807.64194.qmail@web31702.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060725180807.64194.qmail@web31702.mail.mud.yahoo.com>; from hgheist@yahoo.com on Tue, Jul 25, 2006 at 11:08:07AM -0700
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Heilige Gheist <hgheist@yahoo.com>
Cc: xfs@oss.sgi.com

On Tue, Jul 25, 2006 at 11:08:07AM -0700, Heilige Gheist wrote:
> [..]
> > 
> > OK.  Are you certain you need this feature?  (can you describe your
> > usage a bit?)  You can get large contiguous chunks of disk space via
> > large direct writes for example, or preallocation, so maybe you could
> > attack the issue from a different angle to solve it?
> 
> The application is reading and writing sparse file of 0.5-1GB, with
> heavy skew toward read. The data is written in clusters of various
> size, depending on data stream type. The filesystem is constantly being
> updated with new data, older files are removed, the filesystem gets
> fragmented and we're down to the allocation extent size in terms of
> available contiguous disk space.

Hmm.

> When you speak of pre-allocation, do you suggest using XFS_IOC_RESVSP
> ioctl interface to explicitly reserve blocks in advance?

Yes, thats the one.

> Can it guarantee contiguous chunk allocation?

No, but it does the best it can under the circumstances,
which is usually pretty good.

> management, isn't it? Basically you pay for unfragmented contiguous
> block layout with extra disk space reserved for unwritten data.

But its not really "extra" if you know you're going to use it,
right?

> If so, why offer custom extent size in the first place?

Its a different concept, solving different problems really.  One is
at the extent level, the other is at (typically large) ranges of bytes
that can be more than an extent.  One is a "harder" guarantee than the
the other of getting contiguous space, as they call into the allocator
in different ways.

> [..]
> > > Do I have to have non-realtime regular section?
> > Yes.  All metadata is stored there.
> Is there any way I can do sizing of the meta-data? 

I'm not sure what you're asking there...?

cheers.

-- 
Nathan
