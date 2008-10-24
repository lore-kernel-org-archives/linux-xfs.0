Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Oct 2008 23:08:21 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9O68BfJ011108
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 23:08:13 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 81D19538780
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 23:08:10 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id G39SoEeukCGtC8Ly for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 23:08:10 -0700 (PDT)
Date: Fri, 24 Oct 2008 17:08:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH, RFC] Re: atime not written to disk
Message-ID: <20081024060806.GJ18495@disturbed>
References: <48FD74CC.907@sgi.com> <48FD7B69.3090600@wm.jp.nec.com> <20081022081710.GL18495@disturbed> <ncctzb4nhss.fsf@itchy.melbourne.sgi.com> <20081023042053.GY18495@disturbed> <nccmygumu2w.fsf@itchy.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <nccmygumu2w.fsf@itchy.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Niv Sardi <xaiki@sgi.com>
Cc: Utako Kusaka <u-kusaka@wm.jp.nec.com>, Timothy Shimmin <tes@sgi.com>, xfs <xfs@oss.sgi.com>

On Fri, Oct 24, 2008 at 04:37:59PM +1100, Niv Sardi wrote:
> Dave Chinner <david@fromorbit.com> writes:
> 
> > On Thu, Oct 23, 2008 at 01:53:23PM +1100, Niv Sardi wrote:
> >> Dave Chinner <david@fromorbit.com> writes:
> >> [...]
> >> > As I mentioned on IRC, Tim, the following patch fixes the above test
> >> > case. It will make XFS behave like other filesystems w.r.t. atime,
> >> > instead of defaulting to relatime-like behaviour. This will have
> >> > performance impact unless ppl now add the relatime mount option.
> >>  ^^^^^^^^^^^^^^^^^^^
> >> 
> >> I don't really like it, and don't think there is a real justification to
> >> do it.
> >
> > You probably missed the context of that patch (which I mentioned on
> > IRC to Tim).
> 
> Thank you for the refresh.
> 
> > That was that it is part of a larger patch set that tracks dirty state
> > in the XFS inode radix tree. In that case, the ->dirty_inode callout
> > is used to set a tag in the per-ag inode radix tree. I want to
> > do it this way so there is a single place that the dirty tag
> > is set, whether it is due to an unlogged change (XFS or VFS) or
> > a transaction commit....
> 
> So, to refrase, you have a patchset, that will use that callback better,
> and then we will not need the patch you actually sent ? why not wait for
> that patchset, this is not exactly a critical bug…

No, that patch is part of the patchset. In fact - it's the first
patch in the patchset of 4 patches. The following patches are:

xfs-iradix-set-dirty-tag
xfs-iradix-use-dirty-tag-for-clustering
xfs-iradix-use-dirty-tag-for-sync

i.e. using the radix tree for finding sequential dirty inode
clusters for writeback....

It's not complete yet, because I'm trying to decide if it is better
to avoid inode writeback from ->write_inode altogether and only do
optimised ascending order inode writeback from from
xfs_sync_inodes() and/or AIL tail pushing....

> >> Why not only do:
> […]
> > This doesn't avoid the performance problem - it simply shifts it to
> > the reclaim code.  Think about it - you traverse a million inodes
> > stat()ing them all (the nightly backup). Instead of having the now
> > dirty inodes written back as you go along, you wait until memory
> > reclaim turfs them out to mark them dirty and then write them back.
> > This means memory reclaim goes *much slower* because reclaiming the
> > memory now has to wait for I/O to complete.
> 
> yep, I just read the code, do we have a way to know that we are
> unmounting ? maybe the good way to do it is to only write atime on
> unmount ? the call trace is:

	if (!(sb->s_flags & MS_ACTIVE)) {
		/* we are unmounting */
	}

Even so, we don't want unmount to take hours - especially in the
situation that unmounts that would trigger this problem often occur
in planned maintenance windows that aren't hours long.....

> I'm concerned about the overhead, with your patch, that we'll be
> writting things even if nothing has changed, not sure about how many

We'll won't write an inode if it hasn't changed. The VFS calling
mark_inode_dirty_sync() is not "nothing".

> times ->dirty_inodes is called and such. I don't like the idea to slow
> things down for everyone or force people to use realtime

I didn't suggest we force ppl to use relatime - I suggested that we
default to it behind the covers and then pay attention to all dirty
events coming form the VFS. This should result in practically no
increase in the number of atime-only inode writes....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
