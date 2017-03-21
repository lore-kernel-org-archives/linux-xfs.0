Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:35623 "EHLO
        mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757547AbdCURX2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Mar 2017 13:23:28 -0400
Received: by mail-qk0-f176.google.com with SMTP id v127so140430211qkb.2
        for <linux-xfs@vger.kernel.org>; Tue, 21 Mar 2017 10:23:27 -0700 (PDT)
Message-ID: <1490117004.2542.1.camel@redhat.com>
Subject: Re: [RFC PATCH v1 00/30] fs: inode->i_version rework and
 optimization
From: Jeff Layton <jlayton@redhat.com>
Date: Tue, 21 Mar 2017 13:23:24 -0400
In-Reply-To: <20170321163011.GA16666@fieldses.org>
References: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
         <20161222084549.GA8833@infradead.org> <1482417724.3924.39.camel@redhat.com>
         <20170320214327.GA5098@fieldses.org> <20170321134500.GA1318@infradead.org>
         <20170321163011.GA16666@fieldses.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "J. Bruce Fields" <bfields@fieldses.org>, Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

On Tue, 2017-03-21 at 12:30 -0400, J. Bruce Fields wrote:
> On Tue, Mar 21, 2017 at 06:45:00AM -0700, Christoph Hellwig wrote:
> > On Mon, Mar 20, 2017 at 05:43:27PM -0400, J. Bruce Fields wrote:
> > > To me, the interesting question is whether this allows us to turn on
> > > i_version updates by default on xfs and ext4.
> > 
> > XFS v5 file systems have it on by default.
> 
> Great, thanks.
> 
> > Although we'll still need to agree on the exact semantics of i_version
> > before it's going to be useful.
> 
> Once it's figured out maybe we should write it up for a manpage that
> could be used if statx starts exposing it to userspace.
> 
> A first attempt:
> 
> - It's a u64.
> 
> - It works for regular files and directories.  (What about symlinks or
>   other special types?)
> 
> - It changes between two checks if and only if there were intervening
>   data or metadata changes.  The change will always be an increase, but
>   the amount of the increase is meaningless.
> 	- NFS doesn't actually require that it increases, but I think it
> 	  should.  I assume 64 bits means we don't need a discussion of
> 	  wraparound.

I thought NFS spec required that you be able to recognize old change
attributes so that they can be discarded. I could be wrong here though.
I'd have to go back and look through the spec to be sure.

> 	- AFS wants an actual counter: if you get i_version X, then
> 	  write twice, then get i_version X+2, you're allowed to assume
> 	  your writes were the only modifications.  Let's ignore this
> 	  for now.  In the future if someone explains how to count
> 	  operations, then we can extend the interface to tell the
> 	  caller it can get those extra semantics.
> 
> - It's durable; the above comparison still works if there were reboots
>   between the two i_version checks.
> 	- I don't know how realistic this is--we may need to figure out
> 	  if there's a weaker guarantee that's still useful.  Do
> 	  filesystems actually make ctime/mtime/i_version changes
> 	  atomically with the changes that caused them?  What if a
> 	  change attribute is exposed to an NFS client but doesn't make
> 	  it to disk, and then that value is reused after reboot?
> 

Yeah, there could be atomicity there. If we bump i_version, we'll mark
the inode dirty and I think that will end up with the new i_version at
least being journalled before __mark_inode_dirty returns.

That said, I suppose it is possible for us to bump the counter, hand
that new counter value out to a NFS client and then the box crashes
before it makes it to the journal.

Not sure how big a problem that really is.

> Am I missing any issues?
> 

No, I think you have it covered, and that's pretty much exactly what I
had in mind as far as semantics go. Thanks for writing it up!

-- 
Jeff Layton <jlayton@redhat.com>
