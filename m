Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 01 May 2007 07:21:13 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l41EL5fB015382
	for <xfs@oss.sgi.com>; Tue, 1 May 2007 07:21:08 -0700
Date: Wed, 2 May 2007 00:20:49 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [RFC] add FIEMAP ioctl to efficiently map file allocation
Message-ID: <20070501142049.GG77450368@melbourne.sgi.com>
References: <20070412110550.GM5967@schatzie.adilger.int> <20070416112252.GJ48531920@melbourne.sgi.com> <20070419002139.GK5967@schatzie.adilger.int> <20070419015426.GM48531920@melbourne.sgi.com> <20070430224401.GX5967@schatzie.adilger.int> <20070501042254.GD77450368@melbourne.sgi.com> <1177994346.3362.5.camel@entropy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1177994346.3362.5.camel@entropy>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nicholas Miell <nmiell@comcast.net>
Cc: David Chinner <dgc@sgi.com>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org

On Mon, Apr 30, 2007 at 09:39:06PM -0700, Nicholas Miell wrote:
> On Tue, 2007-05-01 at 14:22 +1000, David Chinner wrote:
> > On Mon, Apr 30, 2007 at 04:44:01PM -0600, Andreas Dilger wrote:
> > > This is actually for future use.  Any flags that are added into this
> > > range must be understood by both sides or it should be considered an
> > > error.  Flags outside the FIEMAP_FLAG_INCOMPAT do not necessarily need
> > > to be supported.  If it turns out that 8 bits is too small a range for
> > > INCOMPAT flags, then we can make 0x01000000 an incompat flag that means
> > > e.g. 0x00ff0000 are also incompat flags also.
> > 
> > Ah, ok. So it's not really a set of "compatibility" flags, it's more a
> > "compulsory" set. Under those terms, i don't really see why this is
> > necessary - either the filesystem will understand the flags or it will
> > return EINVAL or ignore them...
> > 
> > > I'm assuming that all flags that will be in the original FIEMAP proposal
> > > will be understood by the implementations.  Most filesystems can safely
> > > ignore FLAG_HSM_READ, for example, since they don't support HSM, and for
> > > that matter FLAG_SYNC is probably moot for most filesystems also because
> > > they do block allocation at preprw time.
> > 
> > Exactly my point - so why do we really need to encode a compulsory set of
> > 
> 
> Because flags have meaning, independent of whether or not the filesystem
> understands them. And if the filesystem chooses to ignore critically
> important flags (instead of returning EINVAL), bad things may happen.
> 
> So, either the filesystem will understand the flag or iff the unknown flag
> is in the incompat set, it will return EINVAL or else the unknown flag will
> be safely ignored.

My point was that there is a difference between specification and
implementation - if the specification says something is compulsory,
then they must be implemented in the filesystem. This is easy
enough to ensure by code review - we don't need additional interface
complexity for this....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
