Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756919AbdLQBFb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 16 Dec 2017 20:05:31 -0500
Message-ID: <1513472727.3428.15.camel@kernel.org>
Subject: Re: [PATCH v2 01/19] fs: new API for handling inode->i_version
From: Jeff Layton <jlayton@kernel.org>
Date: Sat, 16 Dec 2017 20:05:27 -0500
In-Reply-To: <20171216223720.GL5858@dastard>
References: <20171216134656.15561-1-jlayton@kernel.org>
         <20171216134656.15561-2-jlayton@kernel.org> <20171216223720.GL5858@dastard>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-nfs@vger.kernel.org, bfields@fieldses.org, neilb@suse.de, jack@suse.de, linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-integrity@vger.kernel.org, zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com, linux-afs@lists.infradead.org, dhowells@redhat.com

On Sun, 2017-12-17 at 09:37 +1100, Dave Chinner wrote:
> On Sat, Dec 16, 2017 at 08:46:38AM -0500, Jeff Layton wrote:
> > From: Jeff Layton <jlayton@redhat.com>
> > 
> > Add a documentation blob that explains what the i_version field is, how
> > it is expected to work, and how it is currently implemented by various
> > filesystems.
> > 
> > We already have inode_inc_iversion. Add several other functions for
> > manipulating and accessing the i_version counter. For now, the
> > implementation is trivial and basically works the way that all of the
> > open-coded i_version accesses work today.
> > 
> > Future patches will convert existing users of i_version to use the new
> > API, and then convert the backend implementation to do things more
> > efficiently.
> > 
> > Signed-off-by: Jeff Layton <jlayton@redhat.com>
> > ---
> >  include/linux/fs.h | 200 ++++++++++++++++++++++++++++++++++++++++++++++++++---
> >  1 file changed, 192 insertions(+), 8 deletions(-)
> 
> Just a random sunday morning coffee musing....
> 
> I was just wondering if it would be better to split this stuff out
> into it's own header file now? include/linux/fs.h is aleady a
> massive header file (~3500 lines) and changes cause tree-wide
> rebuilds, so maybe it would be better to split relatively isolated
> functionality like this out while it's being reworked and you're
> already touching every file that uses it?
> 
> Cheers,
> 
> Dave.

That's a good idea. Let me do that and I'll re-post.

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>
