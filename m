Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:33867 "EHLO
        mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758663AbdCVTyG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Mar 2017 15:54:06 -0400
Received: by mail-qk0-f176.google.com with SMTP id p64so164651588qke.1
        for <linux-xfs@vger.kernel.org>; Wed, 22 Mar 2017 12:53:45 -0700 (PDT)
Message-ID: <1490212422.3921.1.camel@redhat.com>
Subject: Re: [RFC PATCH v1 00/30] fs: inode->i_version rework and
 optimization
From: Jeff Layton <jlayton@redhat.com>
Date: Wed, 22 Mar 2017 15:53:42 -0400
In-Reply-To: <20170321214518.GB17542@dastard>
References: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
         <20161222084549.GA8833@infradead.org> <1482417724.3924.39.camel@redhat.com>
         <20170320214327.GA5098@fieldses.org> <20170321134500.GA1318@infradead.org>
         <20170321163011.GA16666@fieldses.org> <1490117004.2542.1.camel@redhat.com>
         <20170321214518.GB17542@dastard>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

On Wed, 2017-03-22 at 08:45 +1100, Dave Chinner wrote:
> On Tue, Mar 21, 2017 at 01:23:24PM -0400, Jeff Layton wrote:
> > On Tue, 2017-03-21 at 12:30 -0400, J. Bruce Fields wrote:
> > > - It's durable; the above comparison still works if there were reboots
> > >   between the two i_version checks.
> > > 	- I don't know how realistic this is--we may need to figure out
> > > 	  if there's a weaker guarantee that's still useful.  Do
> > > 	  filesystems actually make ctime/mtime/i_version changes
> > > 	  atomically with the changes that caused them?  What if a
> > > 	  change attribute is exposed to an NFS client but doesn't make
> > > 	  it to disk, and then that value is reused after reboot?
> > > 
> > 
> > Yeah, there could be atomicity there. If we bump i_version, we'll mark
> > the inode dirty and I think that will end up with the new i_version at
> > least being journalled before __mark_inode_dirty returns.
> 
> The change may be journalled, but it isn't guaranteed stable until
> fsync is run on the inode.
> 
> NFS server operations commit the metadata changed by a modification
> through ->commit_metadata or sync_inode_metadata() before the
> response is sent back to the client, hence guaranteeing that
> i_version changes through the NFS server are stable and durable.
> 
> This is not the case for normal operations done through the POSIX
> API - the journalling is asynchronous and the only durability
> guarantees are provided by fsync()....
> 

Ahh ok, I missed that...thanks.

I think we'll have a hard time making this fully atomic. We may end up
having to settle for something less (and doing our best to warn users
of that possibility).

One idea might be to tie the behavior to AT_FORCE/DONT_SYNC. In the
don't sync case, allow the kernel to hand out the i_version without
syncing it to disk. In the FORCE_SYNC case, do an fsync internally
before returning.

> > That said, I suppose it is possible for us to bump the counter, hand
> > that new counter value out to a NFS client and then the box crashes
> > before it makes it to the journal.
> 
> Yup, this has aways been a problem when you mix posix applications
> running on the NFS server modifying the same files as the NFS
> clients are accessing and requiring synchronisation.
> 
> > Not sure how big a problem that really is.
> 
> This coherency problem has always existed on the server side...
> 

Yes. I don't think this patchset makes anything worse in this regard.
We will need well-defined semantics here before i_version can be
exposed to userland via statx however.
-- 
Jeff Layton <jlayton@redhat.com>
