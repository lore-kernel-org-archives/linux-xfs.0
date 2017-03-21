Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from fieldses.org ([173.255.197.46]:42262 "EHLO fieldses.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757714AbdCUSev (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 21 Mar 2017 14:34:51 -0400
Date: Tue, 21 Mar 2017 14:30:06 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [RFC PATCH v1 00/30] fs: inode->i_version rework and optimization
Message-ID: <20170321183006.GD17872@fieldses.org>
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
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

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

So you think the filesystem can provide the atomicity?  In more detail:

	- if I write to a file, a simultaneous reader should see either
	  (old data, old i_version) or (new data, new i_version), not a
	  combination of the two.
	- ditto for metadata modifications.
	- the same should be true if there's a crash.

(If that's not possible, then I think we could live with a brief window
of (new data, old i_version) as long as it doesn't persist beyond sync?)

> That said, I suppose it is possible for us to bump the counter, hand
> that new counter value out to a NFS client and then the box crashes
> before it makes it to the journal.
> 
> Not sure how big a problem that really is.

The other case I was wondering about may have been unclear.  Represent
the state of a file by a (data, i_version) pair.  Say:

	- file is modified from (F, V) to (F', V+1).
	- client reads and caches (F', V+1).
	- server crashes before writeback, so disk still has (F, V).
	- after restart, someone else modifies file to (F'', V+1).
	- original client revalidates its cache, sees V+1, concludes
	  file data is still F'.

This may not cause a real problem for clients depending only on
traditional NFS close-to-open semantics.

--b.
