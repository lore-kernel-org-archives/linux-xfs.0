Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:61627 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751138AbdJNWI6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 14 Oct 2017 18:08:58 -0400
Date: Sun, 15 Oct 2017 09:08:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: trim writepage mapping to within eof
Message-ID: <20171014220856.GA15067@dastard>
References: <20171013123826.46207-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171013123826.46207-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Oct 13, 2017 at 08:38:26AM -0400, Brian Foster wrote:
> The writeback rework in commit fbcc02561359 ("xfs: Introduce
> writeback context for writepages") introduced a subtle change in
> behavior with regard to the block mapping used across the
> ->writepages() sequence. The previous xfs_cluster_write() code would
> only flush pages up to EOF at the time of the writepage, thus
> ensuring that any pages due to file-extending writes would be
> handled on a separate cycle and with a new, updated block mapping.
> 
> The updated code establishes a block mapping in xfs_writepage_map()
> that could extend beyond EOF if the file has post-eof preallocation.
> Because we now use the generic writeback infrastructure and pass the
> cached mapping to each writepage call, there is no implicit EOF
> limit in place. If eofblocks trimming occurs during ->writepages(),
> any post-eof portion of the cached mapping becomes invalid. The
> eofblocks code has no means to serialize against writeback because
> there are no pages associated with post-eof blocks. Therefore if an
> eofblocks trim occurs and is followed by a file-extending buffered
> write, not only has the mapping become invalid, but we could end up
> writing a page to disk based on the invalid mapping.
> 
> Consider the following sequence of events:
> 
> - A buffered write creates a delalloc extent and post-eof
>   speculative preallocation.
> - Writeback starts and on the first writepage cycle, the delalloc
>   extent is converted to real blocks (including the post-eof blocks)
>   and the mapping is cached.
> - The file is closed and xfs_release() trims post-eof blocks. The
>   cached writeback mapping is now invalid.
> - Another buffered write appends the file with a delalloc extent.
> - The concurrent writeback cycle picks up the just written page
>   because the writeback range end is LLONG_MAX. xfs_writepage_map()
>   attributes it to the (now invalid) cached mapping and writes the
>   data to an incorrect location on disk (and where the file offset is
>   still backed by a delalloc extent).
> 
> This problem is reproduced by xfstests test generic/464, which
> triggers racing writes, appends, open/closes and writeback requests.
> 
> To address this problem, trim the mapping used during writeback to
> within EOF when the mapping is validated. This ensures the mapping
> is revalidated for any pages encountered beyond EOF as of the time
> the current mapping was cached or last validated.
> 
> Reported-by: Eryu Guan <eguan@redhat.com>
> Diagnosed-by: Eryu Guan <eguan@redhat.com>
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good to me.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
