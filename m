Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from fieldses.org ([173.255.197.46]:42782 "EHLO fieldses.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753096AbdCHRjX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 8 Mar 2017 12:39:23 -0500
Date: Wed, 8 Mar 2017 12:29:32 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [RFC PATCH v1 00/30] fs: inode->i_version rework and optimization
Message-ID: <20170308172932.GB1020@fieldses.org>
References: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
 <20170303230018.GI13877@fieldses.org>
 <1488588837.11672.5.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1488588837.11672.5.camel@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

On Fri, Mar 03, 2017 at 07:53:57PM -0500, Jeff Layton wrote:
> On Fri, 2017-03-03 at 18:00 -0500, J. Bruce Fields wrote:
> > On Wed, Dec 21, 2016 at 12:03:17PM -0500, Jeff Layton wrote:
> > > tl;dr: I think we can greatly reduce the cost of the inode->i_version
> > > counter, by exploiting the fact that we don't need to increment it
> > > if no one is looking at it. We can also clean up the code to prepare
> > > to eventually expose this value via statx().
> > > 
> > > The inode->i_version field is supposed to be a value that changes
> > > whenever there is any data or metadata change to the inode. Some
> > > filesystems use it internally to detect directory changes during
> > > readdir. knfsd will use it if the filesystem has MS_I_VERSION
> > > set. IMA will also use it (though it's not clear to me that that
> > > works 100% -- no check for MS_I_VERSION there).
> > 
> > I'm a little confused about the internal uses for directories.  Is it
> > necessarily kept on disk?
> 
> No, they aren't necessarily stored on disk, and in fact they aren't on
> most (maybe all?) of those filesystems. It's just a convenient place to
> store a dir change value that is subsequently checked in readdir
> operations.
> 
> That's part of the "fun" of untangling this mess. ;)
> 
> > In cases it's not, then there's not the same
> > performance issue, right? 
> 
> Right, I don't think it's really a big deal for most of those and I'm
> not terribly concerned about the i_version counter on directory change
> operations. An extra atomic op on a directory change seems unlikely to
> hurt anything.
> 
> The main purpose of this is to improve the situation with small writes.
> This should also help pave the way for fs' like NFS and Ceph that
> implement a version counter but may not necessarily bump it on every
> change.
> 
> I think once we have things more consistent, we'll be able to consider
> exposing the i_version counter to userland via statx.
> 
> > Is there any risk these patches make
> > performance slightly worse in that case?
> > 
> 
> Maybe, but I think that risk is pretty low. Note that I haven't measured
> that specifically here, so I could be completely wrong.
> 
> If it is a problem, we could consider unioning this thing with a non-
> atomic field for the directory change cases, but that would add some
> complexity and I'm not sure it's worth it. I'd want to measure it first.

Makes sense to me.  I agree that it's unlikely to be a problem, just
wanted to make sure I understood....

Anyway, I'm a great fan of the basic idea, I hope we can get this done.

--b.
