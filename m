Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45370 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755546AbdC3Grd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 30 Mar 2017 02:47:33 -0400
Date: Thu, 30 Mar 2017 08:47:24 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC PATCH v1 00/30] fs: inode->i_version rework and optimization
Message-ID: <20170330064724.GA21542@quack2.suse.cz>
References: <20161222084549.GA8833@infradead.org>
 <1482417724.3924.39.camel@redhat.com>
 <20170320214327.GA5098@fieldses.org>
 <20170321134500.GA1318@infradead.org>
 <20170321163011.GA16666@fieldses.org>
 <1490117004.2542.1.camel@redhat.com>
 <20170321183006.GD17872@fieldses.org>
 <1490122013.2593.1.camel@redhat.com>
 <20170329111507.GA18467@quack2.suse.cz>
 <1490810071.2678.6.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1490810071.2678.6.camel@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@redhat.com>
Cc: Jan Kara <jack@suse.cz>, "J. Bruce Fields" <bfields@fieldses.org>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

On Wed 29-03-17 13:54:31, Jeff Layton wrote:
> On Wed, 2017-03-29 at 13:15 +0200, Jan Kara wrote:
> > On Tue 21-03-17 14:46:53, Jeff Layton wrote:
> > > On Tue, 2017-03-21 at 14:30 -0400, J. Bruce Fields wrote:
> > > > On Tue, Mar 21, 2017 at 01:23:24PM -0400, Jeff Layton wrote:
> > > > > On Tue, 2017-03-21 at 12:30 -0400, J. Bruce Fields wrote:
> > > > > > - It's durable; the above comparison still works if there were reboots
> > > > > >   between the two i_version checks.
> > > > > > 	- I don't know how realistic this is--we may need to figure out
> > > > > > 	  if there's a weaker guarantee that's still useful.  Do
> > > > > > 	  filesystems actually make ctime/mtime/i_version changes
> > > > > > 	  atomically with the changes that caused them?  What if a
> > > > > > 	  change attribute is exposed to an NFS client but doesn't make
> > > > > > 	  it to disk, and then that value is reused after reboot?
> > > > > > 
> > > > > 
> > > > > Yeah, there could be atomicity there. If we bump i_version, we'll mark
> > > > > the inode dirty and I think that will end up with the new i_version at
> > > > > least being journalled before __mark_inode_dirty returns.
> > > > 
> > > > So you think the filesystem can provide the atomicity?  In more detail:
> > > > 
> > > 
> > > Sorry, I hit send too quickly. That should have read:
> > > 
> > > "Yeah, there could be atomicity issues there."
> > > 
> > > I think providing that level of atomicity may be difficult, though
> > > maybe there's some way to make the querying of i_version block until
> > > the inode update has been journalled?
> > 
> > Just to complement what Dave said from ext4 side - similarly as with XFS
> > ext4 doesn't guarantee atomicity unless fsync() has completed on the file.
> > Until that you can see arbitrary combination of data & i_version after the
> > crash. We do take care to keep data and metadata in sync only when there
> > are security implications to that (like exposing uninitialized disk blocks)
> > and if not, we are as lazy as we can to improve performance...
> > 
> > 
> 
> Yeah, I think what we'll have to do here is ensure that those
> filesystems do an fsync prior to reporting the i_version getattr
> codepath. It's not pretty, but I don't see a real alternative.

Hum, so are we fine if i_version just changes (increases) for all inodes
after a server crash? If I understand its use right, it would mean
invalidation of all client's caches but that is not such a big deal given
how frequent server crashes should be, right?

Because if above is acceptable we could make reported i_version to be a sum
of "superblock crash counter" and "inode i_version". We increment
"superblock crash counter" whenever we detect unclean filesystem shutdown.
That way after a crash we are guaranteed each inode will report new
i_version (the sum would probably have to look like "superblock crash
counter" * 65536 + "inode i_version" so that we avoid reusing possible
i_version numbers we gave away but did not write to disk but still...).
Thoughts?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
