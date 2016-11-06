Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:15894 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750727AbcKFWUa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Nov 2016 17:20:30 -0500
Date: Mon, 7 Nov 2016 09:20:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/11] xfs: set XFS_DA_OP_OKNOENT in xfs_attr_get
Message-ID: <20161106222027.GN14023@dastard>
References: <147828420554.31492.4173929442743951581.stgit@birch.djwong.org>
 <147828423671.31492.10920798285495163593.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147828423671.31492.10920798285495163593.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: darrick.wong@oracle.com, linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

Darrick,

There's something whacky with what you are doing to create these
commit messages. The from address on the email itself is not from
you (how did that get through SPF checks?) and instead there's this:

On Fri, Nov 04, 2016 at 11:30:36AM -0700, Eric Sandeen wrote:
> >From c400ee3ed1b13d45adde68e12254dc6ab6977b59 Mon Sep 17 00:00:00 2001

Which tells me nothing useful about the origin of the patch and it
means I have to mangle the commit message before committing it.

If you look at the libxfs sync commits that I applied for the
4.9-rc1 sync, the libxfs-apply script ends up formating the commits
like this:

ommit ece930fa14a3439e40cd1b43063cab5b85ab9407
Author: Christoph Hellwig <hch@lst.de>
Date:   Tue Oct 25 12:59:46 2016 +1100

    xfs: refactor xfs_bunmapi_cow
    
    Source kernel commit: fa5c836ca8eb5bad6316ddfc066acbc4e2485356
    
    Split out two helpers for deleting delayed or real extents from the COW fork.
    This allows to call them directly from xfs_reflink_cow_end_io once that
    function is refactored to iterate the extent tree.  It will also allow
    to reuse the delalloc deletion from xfs_bunmapi in the future.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>


So there's a clear line where the orginal commit came from. It does
this automatically now (see the fixup_header_format() function) so
that this sort of things doesn't need to be cleaned up after the
fact. If the commit is from xfsprogs and going to the kernel, it
will say "Source xfsprogs commit: ....." instead.  This way it is
clear to the reader that this commit is simply a libxfs sync commit,
and that the sob and rvb tags applied to the commit in the source
repository.

Perhaps you are using an older version of the script to generate
these commits?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
