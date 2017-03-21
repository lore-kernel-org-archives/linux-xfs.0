Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:46025 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756886AbdCUVqD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Mar 2017 17:46:03 -0400
Date: Wed, 22 Mar 2017 08:45:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH v1 00/30] fs: inode->i_version rework and optimization
Message-ID: <20170321214518.GB17542@dastard>
References: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
 <20161222084549.GA8833@infradead.org>
 <1482417724.3924.39.camel@redhat.com>
 <20170320214327.GA5098@fieldses.org>
 <20170321134500.GA1318@infradead.org>
 <20170321163011.GA16666@fieldses.org>
 <1490117004.2542.1.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1490117004.2542.1.camel@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@redhat.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

On Tue, Mar 21, 2017 at 01:23:24PM -0400, Jeff Layton wrote:
> On Tue, 2017-03-21 at 12:30 -0400, J. Bruce Fields wrote:
> > - It's durable; the above comparison still works if there were reboots
> >   between the two i_version checks.
> > 	- I don't know how realistic this is--we may need to figure out
> > 	  if there's a weaker guarantee that's still useful.  Do
> > 	  filesystems actually make ctime/mtime/i_version changes
> > 	  atomically with the changes that caused them?  What if a
> > 	  change attribute is exposed to an NFS client but doesn't make
> > 	  it to disk, and then that value is reused after reboot?
> > 
> 
> Yeah, there could be atomicity there. If we bump i_version, we'll mark
> the inode dirty and I think that will end up with the new i_version at
> least being journalled before __mark_inode_dirty returns.

The change may be journalled, but it isn't guaranteed stable until
fsync is run on the inode.

NFS server operations commit the metadata changed by a modification
through ->commit_metadata or sync_inode_metadata() before the
response is sent back to the client, hence guaranteeing that
i_version changes through the NFS server are stable and durable.

This is not the case for normal operations done through the POSIX
API - the journalling is asynchronous and the only durability
guarantees are provided by fsync()....

> That said, I suppose it is possible for us to bump the counter, hand
> that new counter value out to a NFS client and then the box crashes
> before it makes it to the journal.

Yup, this has aways been a problem when you mix posix applications
running on the NFS server modifying the same files as the NFS
clients are accessing and requiring synchronisation.

> Not sure how big a problem that really is.

This coherency problem has always existed on the server side...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
