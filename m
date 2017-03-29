Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35917 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755663AbdC2LPR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 29 Mar 2017 07:15:17 -0400
Date: Wed, 29 Mar 2017 13:15:07 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC PATCH v1 00/30] fs: inode->i_version rework and optimization
Message-ID: <20170329111507.GA18467@quack2.suse.cz>
References: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
 <20161222084549.GA8833@infradead.org>
 <1482417724.3924.39.camel@redhat.com>
 <20170320214327.GA5098@fieldses.org>
 <20170321134500.GA1318@infradead.org>
 <20170321163011.GA16666@fieldses.org>
 <1490117004.2542.1.camel@redhat.com>
 <20170321183006.GD17872@fieldses.org>
 <1490122013.2593.1.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1490122013.2593.1.camel@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@redhat.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

On Tue 21-03-17 14:46:53, Jeff Layton wrote:
> On Tue, 2017-03-21 at 14:30 -0400, J. Bruce Fields wrote:
> > On Tue, Mar 21, 2017 at 01:23:24PM -0400, Jeff Layton wrote:
> > > On Tue, 2017-03-21 at 12:30 -0400, J. Bruce Fields wrote:
> > > > - It's durable; the above comparison still works if there were reboots
> > > >   between the two i_version checks.
> > > > 	- I don't know how realistic this is--we may need to figure out
> > > > 	  if there's a weaker guarantee that's still useful.  Do
> > > > 	  filesystems actually make ctime/mtime/i_version changes
> > > > 	  atomically with the changes that caused them?  What if a
> > > > 	  change attribute is exposed to an NFS client but doesn't make
> > > > 	  it to disk, and then that value is reused after reboot?
> > > > 
> > > 
> > > Yeah, there could be atomicity there. If we bump i_version, we'll mark
> > > the inode dirty and I think that will end up with the new i_version at
> > > least being journalled before __mark_inode_dirty returns.
> > 
> > So you think the filesystem can provide the atomicity?  In more detail:
> > 
> 
> Sorry, I hit send too quickly. That should have read:
> 
> "Yeah, there could be atomicity issues there."
> 
> I think providing that level of atomicity may be difficult, though
> maybe there's some way to make the querying of i_version block until
> the inode update has been journalled?

Just to complement what Dave said from ext4 side - similarly as with XFS
ext4 doesn't guarantee atomicity unless fsync() has completed on the file.
Until that you can see arbitrary combination of data & i_version after the
crash. We do take care to keep data and metadata in sync only when there
are security implications to that (like exposing uninitialized disk blocks)
and if not, we are as lazy as we can to improve performance...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
