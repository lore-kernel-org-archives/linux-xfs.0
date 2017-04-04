Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from fieldses.org ([173.255.197.46]:39542 "EHLO fieldses.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754630AbdDDSit (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 4 Apr 2017 14:38:49 -0400
Date: Tue, 4 Apr 2017 14:38:43 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [RFC PATCH v1 00/30] fs: inode->i_version rework and optimization
Message-ID: <20170404183843.GD14303@fieldses.org>
References: <1482417724.3924.39.camel@redhat.com>
 <20170320214327.GA5098@fieldses.org>
 <20170321134500.GA1318@infradead.org>
 <20170321163011.GA16666@fieldses.org>
 <1490117004.2542.1.camel@redhat.com>
 <20170321183006.GD17872@fieldses.org>
 <1490122013.2593.1.camel@redhat.com>
 <20170329111507.GA18467@quack2.suse.cz>
 <1490810071.2678.6.camel@redhat.com>
 <20170329234137.GN17542@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170329234137.GN17542@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Jeff Layton <jlayton@redhat.com>, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

On Thu, Mar 30, 2017 at 10:41:37AM +1100, Dave Chinner wrote:
> On Wed, Mar 29, 2017 at 01:54:31PM -0400, Jeff Layton wrote:
> > On Wed, 2017-03-29 at 13:15 +0200, Jan Kara wrote:
> > > On Tue 21-03-17 14:46:53, Jeff Layton wrote:
> > > > On Tue, 2017-03-21 at 14:30 -0400, J. Bruce Fields wrote:
> > > > > On Tue, Mar 21, 2017 at 01:23:24PM -0400, Jeff Layton wrote:
> > > > > > On Tue, 2017-03-21 at 12:30 -0400, J. Bruce Fields wrote:
> > > > > > > - It's durable; the above comparison still works if there were reboots
> > > > > > >   between the two i_version checks.
> > > > > > > 	- I don't know how realistic this is--we may need to figure out
> > > > > > > 	  if there's a weaker guarantee that's still useful.  Do
> > > > > > > 	  filesystems actually make ctime/mtime/i_version changes
> > > > > > > 	  atomically with the changes that caused them?  What if a
> > > > > > > 	  change attribute is exposed to an NFS client but doesn't make
> > > > > > > 	  it to disk, and then that value is reused after reboot?
> > > > > > > 
> > > > > > 
> > > > > > Yeah, there could be atomicity there. If we bump i_version, we'll mark
> > > > > > the inode dirty and I think that will end up with the new i_version at
> > > > > > least being journalled before __mark_inode_dirty returns.
> > > > > 
> > > > > So you think the filesystem can provide the atomicity?  In more detail:
> > > > > 
> > > > 
> > > > Sorry, I hit send too quickly. That should have read:
> > > > 
> > > > "Yeah, there could be atomicity issues there."
> > > > 
> > > > I think providing that level of atomicity may be difficult, though
> > > > maybe there's some way to make the querying of i_version block until
> > > > the inode update has been journalled?
> > > 
> > > Just to complement what Dave said from ext4 side - similarly as with XFS
> > > ext4 doesn't guarantee atomicity unless fsync() has completed on the file.
> > > Until that you can see arbitrary combination of data & i_version after the
> > > crash. We do take care to keep data and metadata in sync only when there
> > > are security implications to that (like exposing uninitialized disk blocks)
> > > and if not, we are as lazy as we can to improve performance...
> > > 
> > > 
> > 
> > Yeah, I think what we'll have to do here is ensure that those
> > filesystems do an fsync prior to reporting the i_version getattr
> > codepath. It's not pretty, but I don't see a real alternative.
> 
> I think that's even more problematic. ->getattr currently runs
> completely unlocked for performance reasons - it's racy w.r.t. to
> ongoing modifications to begin with, so /nothing/ that is returned
> to userspace via stat/statx can be guaranteed to be "coherent".
> Linus will be very unhappy if you make his git workload (which is
> /very/ stat heavy) run slower by adding any sort of locking in this
> hot path.
> 
> Even if we did put an fsync() into ->getattr() (and dealt with all
> the locking issues that entails), by the time the statx syscall
> returns to userspace the i_version value may not match the
> data/metadata in the inode(*).  IOWs, by the time i_version gets
> to userspace, it is out of date and any use of it for data
> versioning from userspace is going to be prone to race conditions.

A slightly out-of-date i_version is fine, I think.  It's just the
reverse we want to avoid.  E.g., assuming an i_version-supporting
statux, if somebody could called statx then read, and got the new
i_version followed by the old data, that would cause problems.

--b.
