Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:46444 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726376AbeJLHqC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Oct 2018 03:46:02 -0400
Date: Fri, 12 Oct 2018 11:16:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/25] vfs: avoid problematic remapping requests into
 partial EOF block
Message-ID: <20181012001615.GR6311@dastard>
References: <153923113649.5546.9840926895953408273.stgit@magnolia>
 <153923117420.5546.13317703807467393934.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153923117420.5546.13317703807467393934.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: sandeen@redhat.com, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Wed, Oct 10, 2018 at 09:12:54PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> A deduplication data corruption is exposed by fstests generic/505 on
> XFS. It is caused by extending the block match range to include the
> partial EOF block, but then allowing unknown data beyond EOF to be
> considered a "match" to data in the destination file because the
> comparison is only made to the end of the source file. This corrupts the
> destination file when the source extent is shared with it.
> 
> The VFS remapping prep functions only support whole block dedupe, but
> we still need to appear to support whole file dedupe correctly.  Hence
> if the dedupe request includes the last block of the souce file, don't
> include it in the actual dedupe operation. If the rest of the range
> dedupes successfully, then reject the entire request.  A subsequent
> patch will enable us to shorten dedupe requests correctly.

Ok, so this patch rejects whole file dedupe requests, and then a
later patch adds support back in for it?

Doesn't that leave a bisect landmine behind? Why separate the
functionality like this?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
