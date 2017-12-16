Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:65139 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756922AbdLPWhZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 16 Dec 2017 17:37:25 -0500
Date: Sun, 17 Dec 2017 09:37:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 01/19] fs: new API for handling inode->i_version
Message-ID: <20171216223720.GL5858@dastard>
References: <20171216134656.15561-1-jlayton@kernel.org>
 <20171216134656.15561-2-jlayton@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171216134656.15561-2-jlayton@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-nfs@vger.kernel.org, bfields@fieldses.org, neilb@suse.de, jack@suse.de, linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-integrity@vger.kernel.org, zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com, linux-afs@lists.infradead.org, dhowells@redhat.com

On Sat, Dec 16, 2017 at 08:46:38AM -0500, Jeff Layton wrote:
> From: Jeff Layton <jlayton@redhat.com>
> 
> Add a documentation blob that explains what the i_version field is, how
> it is expected to work, and how it is currently implemented by various
> filesystems.
> 
> We already have inode_inc_iversion. Add several other functions for
> manipulating and accessing the i_version counter. For now, the
> implementation is trivial and basically works the way that all of the
> open-coded i_version accesses work today.
> 
> Future patches will convert existing users of i_version to use the new
> API, and then convert the backend implementation to do things more
> efficiently.
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> ---
>  include/linux/fs.h | 200 ++++++++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 192 insertions(+), 8 deletions(-)

Just a random sunday morning coffee musing....

I was just wondering if it would be better to split this stuff out
into it's own header file now? include/linux/fs.h is aleady a
massive header file (~3500 lines) and changes cause tree-wide
rebuilds, so maybe it would be better to split relatively isolated
functionality like this out while it's being reworked and you're
already touching every file that uses it?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
