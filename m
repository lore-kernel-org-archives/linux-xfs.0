Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 26 Jun 2007 17:05:31 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5R05MtL015200
	for <xfs@oss.sgi.com>; Tue, 26 Jun 2007 17:05:24 -0700
Date: Wed, 27 Jun 2007 10:04:56 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 7/7][TAKE5] ext4: support new modes
Message-ID: <20070627000456.GT31489@sgi.com>
References: <20070613235217.GS86004887@sgi.com> <20070614091458.GH5181@schatzie.adilger.int> <20070614120413.GD86004887@sgi.com> <20070614193347.GN5181@schatzie.adilger.int> <20070625132810.GA1951@amitarora.in.ibm.com> <20070625135051.GH1951@amitarora.in.ibm.com> <20070625215625.GL5181@schatzie.adilger.int> <20070626120751.GC19870@amitarora.in.ibm.com> <20070626161400.GE6652@schatzie.adilger.int> <20070626192908.GC13324@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070626192908.GC13324@amitarora.in.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, David Chinner <dgc@sgi.com>, suparna@in.ibm.com, cmm@us.ibm.com, xfs@oss.sgi.com

On Wed, Jun 27, 2007 at 12:59:08AM +0530, Amit K. Arora wrote:
> On Tue, Jun 26, 2007 at 12:14:00PM -0400, Andreas Dilger wrote:
> > On Jun 26, 2007  17:37 +0530, Amit K. Arora wrote:
> > > > I also thought another proposed flag was to determine whether mtime (and
> > > > maybe ctime) is changed when doing prealloc/dealloc space?  Default should
> > > > probably be to change mtime/ctime, and have FA_FL_NO_MTIME.  Someone else
> > > > should decide if we want to allow changing the file w/o changing ctime, if
> > > > that is required even though the file is not visibly changing.  Maybe the
> > > > ctime update should be implicit if the size or mtime are changing?
> > > 
> > > Is it really required ? I mean, why should we allow users not to update
> > > ctime/mtime even if the file metadata/data gets updated ? It sounds
> > > a bit "unnatural" to me.
> > > Is there any application scenario in your mind, when you suggest of
> > > giving this flexibility to userspace ?
> > 
> > One reason is that XFS does NOT update the mtime/ctime when doing the
> > XFS_IOC_* allocation ioctls.

Not totally correct.

XFS_IOC_ALLOCSP/FREESP change timestamps if they change
the file size (via the truncate call made to change the file size).
If they don't change the file size, then they are a no-op and should
not change the file size.

XFS_IOC_RESVSP/UNRESVSP don't change timestamps just like they don't
change file size. That is by design AFAICT so these calls can be
used by HSM-type applications that don't want to change timestamps
when punching out data blocks or preallocating new ones.

> Hmm.. I personally will call it a bug in XFS code then. :)

No, I'd call it useful. :)

> > > I think, modifying ctime/mtime should be dependent on the other flags.
> > > E.g., if we do not zero out data blocks on allocation/deallocation,
> > > update only ctime. Otherwise, update ctime and mtime both.
> > 
> > I'm only being the advocate for requirements David Chinner has put
> > forward due to existing behaviour in XFS.  This is one of the reasons
> > why I think the "flags" mechanism we now have - we can encode the
> > various different behaviours in any way we want and leave it to the
> > caller.
> 
> I understand. May be we can confirm once more with David Chinner if this
> is really required. Will it really be a compatibility issue if new XFS
> preallocations (ie. via fallocate) update mtime/ctime?

It should be left up to the filesystem to decide. Only the
filesystem knows whether something changed and the timestamp should
or should not be updated.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
