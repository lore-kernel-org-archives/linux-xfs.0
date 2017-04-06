Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54688 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756406AbdDFHWJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 6 Apr 2017 03:22:09 -0400
Date: Thu, 6 Apr 2017 09:22:07 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC PATCH v1 00/30] fs: inode->i_version rework and optimization
Message-ID: <20170406072207.GA25500@quack2.suse.cz>
References: <20170329111507.GA18467@quack2.suse.cz>
 <1490810071.2678.6.camel@redhat.com>
 <20170330064724.GA21542@quack2.suse.cz>
 <1490872308.2694.1.camel@redhat.com>
 <20170330161231.GA9824@fieldses.org>
 <1490898932.2667.1.camel@redhat.com>
 <20170404183138.GC14303@fieldses.org>
 <878tnfiq7v.fsf@notabene.neil.brown.name>
 <20170405080551.GC8899@quack2.suse.cz>
 <87k26ygx0d.fsf@notabene.neil.brown.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k26ygx0d.fsf@notabene.neil.brown.name>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: NeilBrown <neil@brown.name>
Cc: Jan Kara <jack@suse.cz>, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

On Thu 06-04-17 11:12:02, NeilBrown wrote:
> On Wed, Apr 05 2017, Jan Kara wrote:
> >> If you want to ensure read-only files can remain cached over a crash,
> >> then you would have to mark a file in some way on stable storage
> >> *before* allowing any change.
> >> e.g. you could use the lsb.  Odd i_versions might have been changed
> >> recently and crash-count*large-number needs to be added.
> >> Even i_versions have not been changed recently and nothing need be
> >> added.
> >> 
> >> If you want to change a file with an even i_version, you subtract
> >>   crash-count*large-number
> >> to the i_version, then set lsb.  This is written to stable storage before
> >> the change.
> >> 
> >> If a file has not been changed for a while, you can add
> >>   crash-count*large-number
> >> and clear lsb.
> >> 
> >> The lsb of the i_version would be for internal use only.  It would not
> >> be visible outside the filesystem.
> >> 
> >> It feels a bit clunky, but I think it would work and is the best
> >> combination of Jan's idea and your requirement.
> >> The biggest cost would be switching to 'odd' before an changes, and the
> >> unknown is when does it make sense to switch to 'even'.
> >
> > Well, there is also a problem that you would need to somehow remember with
> > which 'crash count' the i_version has been previously reported as that is
> > not stored on disk with my scheme. So I don't think we can easily use your
> > scheme.
> 
> I don't think there is a problem here.... maybe I didn't explain
> properly or something.
> 
> I'm assuming there is a crash-count that is stored once per filesystem.
> This might be a disk-format change, or maybe the "Last checked" time
> could be used with ext4 (that is a bit horrible though).
> 
> Every on-disk i_version has a flag to choose between:
>   - use this number as it is, but update it on-disk before any change
>   - add multiple of current crash-count to this number before use.
>       If you crash during an update, the i_version is thus automatically
>       increased.
> 
> To change from the first option to the second option you subtract the
> multiple of the current crash-count (which might make the stored
> i_version negative), and flip the bit.
> To change from the second option to the first, you add the multiple
> of the current crash-count, and flip the bit.
> In each case, the externally visible i_version does not change.
> Nothing needs to be stored except the per-inode i_version and the per-fs
> crash_count. 

Right, I didn't realize you would subtract crash counter when flipping the
bit and then add it back when flipping again. That would work.

> > So the options we have are:
> >
> > 1) Keep i_version as is, make clients also check for i_ctime.
> >    Pro: No on-disk format changes.
> >    Cons: After a crash, i_version can go backwards (but when file changes
> >    i_version, i_ctime pair should be still different) or not, data can be
> >    old or not.
> 
> I like to think of this approach as using the i_version as an extension
> to the i_ctime.
> i_ctime doesn't necessarily change on every file modification, either
> because it is not a modification that is meant to change i_ctime, or
> because i_ctime doesn't have the resolution to show a very small change
> in time, or because the clock that is used to update i_ctime doesn't
> have much resolution.
> So when a change happens, if the stored c_time changes, set i_version to
> zero, otherwise increment i_version.
> Then the externally visible i-version is a combination of the stored
> c_time and the stored i_version.
> If you only used 1-second ctime resolution for versioning purposes, you
> could provide a 64bit i_version as 34 bits of ctime and 30 bits of
> changes-in-one-second.
> It is important that the resolution of ctime used is less that the
> fastest possible restart after a crash.
> 
> I don't think that i_version going backwards should be a problem, as
> long as an old version means exactly the same old data.  Presumably
> journalling would ensure that the data and ctime/version are updated
> atomically.

So as Dave and I wrote earlier in this thread, journalling does not ensure
data vs ctime/version consistency (well, except for ext4 in data=journal
mode but people rarely run that due to performance implications). So you
can get old data and new version as well as new data and old version after
a crash. The only thing filesystems guarantee is that you will not see
uninitialized blocks and that fsync makes both data & ctime/version
persistent. But as Bruce wrote for NFS open-to-close semantics this may be
actually good enough.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
