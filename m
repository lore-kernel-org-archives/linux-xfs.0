Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53009 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752862AbdDEIF6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Apr 2017 04:05:58 -0400
Date: Wed, 5 Apr 2017 10:05:51 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC PATCH v1 00/30] fs: inode->i_version rework and optimization
Message-ID: <20170405080551.GC8899@quack2.suse.cz>
References: <20170321183006.GD17872@fieldses.org>
 <1490122013.2593.1.camel@redhat.com>
 <20170329111507.GA18467@quack2.suse.cz>
 <1490810071.2678.6.camel@redhat.com>
 <20170330064724.GA21542@quack2.suse.cz>
 <1490872308.2694.1.camel@redhat.com>
 <20170330161231.GA9824@fieldses.org>
 <1490898932.2667.1.camel@redhat.com>
 <20170404183138.GC14303@fieldses.org>
 <878tnfiq7v.fsf@notabene.neil.brown.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878tnfiq7v.fsf@notabene.neil.brown.name>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: NeilBrown <neil@brown.name>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@redhat.com>, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

On Wed 05-04-17 11:43:32, NeilBrown wrote:
> On Tue, Apr 04 2017, J. Bruce Fields wrote:
> 
> > On Thu, Mar 30, 2017 at 02:35:32PM -0400, Jeff Layton wrote:
> >> On Thu, 2017-03-30 at 12:12 -0400, J. Bruce Fields wrote:
> >> > On Thu, Mar 30, 2017 at 07:11:48AM -0400, Jeff Layton wrote:
> >> > > On Thu, 2017-03-30 at 08:47 +0200, Jan Kara wrote:
> >> > > > Because if above is acceptable we could make reported i_version to be a sum
> >> > > > of "superblock crash counter" and "inode i_version". We increment
> >> > > > "superblock crash counter" whenever we detect unclean filesystem shutdown.
> >> > > > That way after a crash we are guaranteed each inode will report new
> >> > > > i_version (the sum would probably have to look like "superblock crash
> >> > > > counter" * 65536 + "inode i_version" so that we avoid reusing possible
> >> > > > i_version numbers we gave away but did not write to disk but still...).
> >> > > > Thoughts?
> >> > 
> >> > How hard is this for filesystems to support?  Do they need an on-disk
> >> > format change to keep track of the crash counter?  Maybe not, maybe the
> >> > high bits of the i_version counters are all they need.
> >> > 
> >> 
> >> Yeah, I imagine we'd need a on-disk change for this unless there's
> >> something already present that we could use in place of a crash counter.
> >
> > We could consider using the current time instead.  So, put the current
> > time (or time of last boot, or this inode's ctime, or something) in the
> > high bits of the change attribute, and keep the low bits as a counter.
> 
> This is a very different proposal.
> I don't think Jan was suggesting that the i_version be split into two
> bit fields, one the change-counter and one the crash-counter.
> Rather, the crash-counter was multiplied by a large-number and added to
> the change-counter with the expectation that while not ever
> change-counter landed on disk, at least 1 in every large-number would.
> So after each crash we effectively add large-number to the
> change-counter, and can be sure that number hasn't been used already.

Yes, that was my thinking.

> To store the crash-counter in each inode (which does appeal) you would
> need to be able to remove it before adding the new crash counter, and
> that requires bit-fields.  Maybe there are enough bits.

Furthermore you'd have a potential problem that you need to change
i_version on disk just because you are reading after a crash and such
changes tend to be problematic (think of read-only mounts and stuff like
that).
 
> If you want to ensure read-only files can remain cached over a crash,
> then you would have to mark a file in some way on stable storage
> *before* allowing any change.
> e.g. you could use the lsb.  Odd i_versions might have been changed
> recently and crash-count*large-number needs to be added.
> Even i_versions have not been changed recently and nothing need be
> added.
> 
> If you want to change a file with an even i_version, you subtract
>   crash-count*large-number
> to the i_version, then set lsb.  This is written to stable storage before
> the change.
> 
> If a file has not been changed for a while, you can add
>   crash-count*large-number
> and clear lsb.
> 
> The lsb of the i_version would be for internal use only.  It would not
> be visible outside the filesystem.
> 
> It feels a bit clunky, but I think it would work and is the best
> combination of Jan's idea and your requirement.
> The biggest cost would be switching to 'odd' before an changes, and the
> unknown is when does it make sense to switch to 'even'.

Well, there is also a problem that you would need to somehow remember with
which 'crash count' the i_version has been previously reported as that is
not stored on disk with my scheme. So I don't think we can easily use your
scheme.

So the options we have are:

1) Keep i_version as is, make clients also check for i_ctime.
   Pro: No on-disk format changes.
   Cons: After a crash, i_version can go backwards (but when file changes
   i_version, i_ctime pair should be still different) or not, data can be
   old or not.

2) Fsync when reporting i_version.
   Pro: No on-disk format changes, strong consistency of i_version and
        data.
   Cons: Difficult to implement for filesystems due to locking constrains.
         High performance overhead or i_version reporting.

3) Some variant of crash counter.
   Pro: i_version cannot go backwards.
   Cons: Requires on-disk format changes. After a crash data can be old
         (however i_version increased).

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
