Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 871CF800B
	for <xfs@oss.sgi.com>; Tue, 20 Aug 2013 20:33:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 47C3C3040CA
	for <xfs@oss.sgi.com>; Tue, 20 Aug 2013 18:33:38 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	5NKzbecIoEuk97Kl for <xfs@oss.sgi.com>;
	Tue, 20 Aug 2013 18:33:36 -0700 (PDT)
Date: Wed, 21 Aug 2013 11:33:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 3/5] mm: Notify filesystems when it's time to apply a
	deferred cmtime update
Message-ID: <20130821013332.GQ6023@dastard>
References: <20130820023615.GE6023@dastard>
	<CALCETrV-Toj-NGpmWnmoUbCwrMUXOSbjQdYsSVuTiH+2dEgPTQ@mail.gmail.com>
	<20130820040814.GH6023@dastard>
	<CALCETrWreWBwKdKS2w=fS+MwdaZv1eEsKjYo=P9eeXe7fZS6Jw@mail.gmail.com>
	<20130820160057.GC2862@quack.suse.cz>
	<CALCETrXotDRKV8FtLn3g_9g_yOVceHzKpwXMAH+w7tBZ1P2F7A@mail.gmail.com>
	<20130820214819.GK6023@dastard>
	<CALCETrXU3jm_R2SJbfgsM2COAuX_tRACQmuc7t7z5b2B+=kBgg@mail.gmail.com>
	<20130820224349.GM6023@dastard>
	<CALCETrVY2dhiAO_k9=mCL3_Tuyzr52tnKB57YteO_7PXJBmAHw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CALCETrVY2dhiAO_k9=mCL3_Tuyzr52tnKB57YteO_7PXJBmAHw@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Andy Lutomirski <luto@amacapital.net>
Cc: Theodore Ts'o <tytso@mit.edu>, Dave Hansen <dave.hansen@linux.intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, Tim Chen <tim.c.chen@linux.intel.com>

On Tue, Aug 20, 2013 at 05:47:10PM -0700, Andy Lutomirski wrote:
> On Tue, Aug 20, 2013 at 3:43 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Tue, Aug 20, 2013 at 02:54:01PM -0700, Andy Lutomirski wrote:
> >> On Tue, Aug 20, 2013 at 2:48 PM, Dave Chinner <david@fromorbit.com> wrote:
> >> > On Tue, Aug 20, 2013 at 09:42:34AM -0700, Andy Lutomirski wrote:
> >> >> On Tue, Aug 20, 2013 at 9:00 AM, Jan Kara <jack@suse.cz> wrote:
> >> >> > On Mon 19-08-13 21:14:44, Andy Lutomirski wrote:
> >> >> >> >> I could require ->writepages *and* ->flush_cmtime to handle the time
> >> >> >> >> update, but that would complicate non-transactional filesystems.
> >> >> >> >> Those filesystems should just flush cmtime at the end of writepages.
> >> >> >> >
> >> >> >> > do_writepages() is the wrong place to do such updates - we can get
> >> >> >> > writeback directly through .writepage, so the time updates need to
> >> >> >> > be in .writepage. That first .writepage call will clear the bit on
> >> >> >> > the mapping, so it's only done on the first call to .writepage on
> >> >> >> > the given mapping.
> >> >> >>
> >> >> >> Last time I checked, all the paths that actually needed the timestamp
> >> >> >> update went through .writepages.  I'll double-check.
> >> >> >   kswapd can call just .writepage to do the writeout so timestamp update
> >> >> > should be handled there as well. Otherwise all pages in a mapping can be
> >> >> > cleaned without timestamp being updated.
> >> >>
> >> >> OK, I'll fix that.
> >> >>
> >> >> >
> >> >> > Which btw made me realize that even your scheme doesn't completely make
> >> >> > sure timestamp is updated after mmap write - if you have pages 0 and 1, you
> >> >> > write to both of them - CMTIME flag gets set. Then fsync_range(fd, 0, 4096)
> >> >> > is called. We write the page 0, writeprotect it, update timestamps. But
> >> >> > page 1 is still writeable so writes to it won't set CMTIME flag, neither
> >> >> > update the timestamp... Not that I think this can be reasonably solved but
> >> >> > it is a food for thought.
> >> >>
> >> >> This should already work.  AS_CMTIME is set when the pte goes from
> >> >> dirty to clean, not when the pte goes from wp to writable.  So
> >> >> whenever clear_page_dirty_for_io is called on page 1, AS_CMTIME will
> >> >> be set and a subsequent writepages call will update the timestamp.
> >> >
> >> > Oh, I missed that - I thought you were setting AS_CMTIME during
> >> > .page_mkwrite.
> >> >
> >> > Setting it in clear_page_dirty_for_io() is too late for filesystems
> >> > to include it in their existing transactions during .writepage, (at
> >> > least for XFs and ext4) because they do their delayed allocation
> >> > transactions before changing page state....
> >>
> >> Couldn't it go between mpage_map_and_submit_extent and
> >> ext4_journal_stop in ext4_writepages?
> >
> > Maybe - I'm not an ext4 expert - but even if you can make it work
> > for ext4 in some way, that doesn't mean it is possible for any other
> > filesystem to use the same method. You're adding code to generic,
> > non-filesystem specific code paths and so the solutions need to be
> > generic rather not tied to how a specific filesystem is implemented.
> >
> 
> I don't see the problem for xfs or btrfs either.
> 
> xfs uses generic_writepages, which already does the right thing.  (xfs
> with my updated patches passes my tests.)  xfs_vm_writepage calls
> xfs_start_page_writeback(..., 1, ...), so clear_page_dirty_for_io is
> called.  At that point (I presume), it would still be possible to add
> metadata to a transaction (assuming there's a transaction open -- I
> don't have a clue here). 

That's my point - there isn't a transaction in XFS at this point,
and so if we gather that flag from clear_page_dirty_for_io() we'd
need a second transaction and therefore the optimisation you want
filesystems to use to mitigate the additional overhead can't be done
for all commonly used filesystems.

> Even if this is too late, xfs_vm_writepage
> could call page_mkwrite to for AS_CMTIME to be set if needed.
> page_mkwrite will be fast if the page isn't mmapped.  What am I
> missing?

That it leads to different behaviour for different filesystems.

i.e. page_mkwrite on page A sets the flag. writeback on a range that
doesn't include page A occurs, sees the flag, clears it after
updating the timestamp. Some time later writeback on page A occurs,
no timestamp update occurs.

The behaviour needs to be consistent across filesystems.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
