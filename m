Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:58155 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753575AbeDSWuF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Apr 2018 18:50:05 -0400
Date: Fri, 20 Apr 2018 08:50:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: Add a helper to retrieve xfs_inode from the
 address_space
Message-ID: <20180419225002.GQ23861@dastard>
References: <20180419143511.16924-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180419143511.16924-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Apr 19, 2018 at 04:35:11PM +0200, Carlos Maiolino wrote:
> Reduce some code and local variable allocation on file operations by
> using a new helper.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
> 
> Hi, I though this could be useful instead of keeping allocating file,
> address_space and inode structs in several places, just to retrieve the
> xfs_inode, what you guys think?
> 
> XFS_FTOINO() isn't really a good name, that's the first one which came to my
> mind, if this is useful at all I can change the name to something else, like
> XFS_AS_TO_INO() maybe, or something else?!

I'd prefer that we don't add more "vfs to xfs structure" macros like
this. It doesn't make the code any more readable or correct,
especially for non-XFS developers.

> Although I think some vfs_wide helper like file_inode() would be more useful,
> but, well, it's just an idea that came to my mind.

XFS_I(file_inode(file)) would be my preferred solution here, as it
uses the correct VFS accessor function to get the VFS inode from
the struct file and it's obvious what it does to anyone familiar
with typical VFS and filesystem coding conventions.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
