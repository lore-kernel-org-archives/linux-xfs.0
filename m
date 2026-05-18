Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1322B3E51EC
	for <linux-xfs@vger.kernel.org>; Mon, 18 May 2026 09:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779097487; cv=none; b=KfGoIfzuZMh9FQup3GLPOWSO/LLpRrdXy9n61FQPGr6+JehTib7oPKcxImYiQg4GzW9n5+Cox9FClFQPhfgmAOp/LXGaPlC/aGj29YuDw7S64EmaZvrbCb2fQTzjzR9moezNV5Q0QVmrPPzHeffwA2+Ou9YGn25wBHt04eYe9SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779097487; c=relaxed/simple;
	bh=6HWX4Ir/TmpnL1SilKkvrWby1KMnMOVifGVHSk/TTE8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BeFyiVvqrnxptiaXT4Visvlh9snU/oQty1MVvDzlwgv/1S7dicvyqWuym6XxQ/CRVpnyDCEAA/lOmiYMLX3xI13bLuhx33nQ4Am2nXg1eaw1ujSgSUz3yMDJGNI07D3StGuE8VOUGkuBoM8BqX9TqV2YDmX7G2Dz9kTVTQojSwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OSGWR7oR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OSGWR7oR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A65AC2BCB7;
	Mon, 18 May 2026 09:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779097486;
	bh=6HWX4Ir/TmpnL1SilKkvrWby1KMnMOVifGVHSk/TTE8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OSGWR7oRPXUFomiGwgn/LLfHCKMEbSQt8VjQuooeYAFtjaewdfPPxaB84LBHbyQwV
	 y8nXwIwJOrWl1ABZEt5jKlodeicKvAm+XGO3BLsfSO82oNjq6E6f3G64dfLdZykpLr
	 6PaueR9cYnfddx4YHYvP9hUkKXwNJyUDuZA4aMigqcGzZQ77NTOqnNHRa1DFCTXrWH
	 ihH5zTtqhAcZYygWR089bvl6FY3XRsG3JSozb1783uOwiflWAjvLLnbs/1mHX1KKto
	 TP/Y5sQacmHtxWEe91s9h4vMHL6zc9xwJVqRBm+FJrvHKdC3SRePRO8u5udjVNDLuI
	 07vMarJhOs6Kw==
Date: Mon, 18 May 2026 19:44:36 +1000
From: Dave Chinner <dgc@kernel.org>
To: Hans Holmberg <Hans.Holmberg@wdc.com>
Cc: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v2] xfs: handle racing deletions in xfs_zone_gc_iter_irec
Message-ID: <agrfhOT9ZremS605@dread>
References: <20260518065224.9066-1-hans.holmberg@wdc.com>
 <agrERjRq10bm0rrY@dread>
 <42149407-5702-4f8f-8973-28f3e705bdc5@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42149407-5702-4f8f-8973-28f3e705bdc5@wdc.com>

On Mon, May 18, 2026 at 08:55:58AM +0000, Hans Holmberg wrote:
> On 18/05/2026 09:48, Dave Chinner wrote:
> > On Mon, May 18, 2026 at 08:52:24AM +0200, Hans Holmberg wrote:
> >> Under heavy garbage collection pressure from RocksDB workloads,
> >> filesystem shutdowns can occur in xfs_zone_gc_iter_irec when
> >> xfs_iget() returns -EINVAL for deleted files.
> >>
> >> Fix this by handling -EINVAL just like we handle -ENOENT, allowing
> >> zone GC to safely ignore stale mappings.
> >>
> >> Fixes: 080d01c41d44 ("xfs: implement zoned garbage collection")
> >> Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
> >> ---
> >>
> >> v2:
> >> - handle -EINVAL in the the caller in stead of switching error code
> >>   in xfs_imap_lookup
> >>
> >> v1:
> >> https://lore.kernel.org/linux-xfs/20260513063745.8067-1-hans.holmberg@wdc.com/
> >>
> >>
> >>  fs/xfs/xfs_zone_gc.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
> >> index fedcc47048af..96f14d811db2 100644
> >> --- a/fs/xfs/xfs_zone_gc.c
> >> +++ b/fs/xfs/xfs_zone_gc.c
> >> @@ -400,7 +400,7 @@ xfs_zone_gc_iter_irec(
> >>  		/*
> >>  		 * If the inode was already deleted, skip over it.
> >>  		 */
> >> -		if (error == -ENOENT) {
> >> +		if (error == -ENOENT || error == -EINVAL) {
> >>  			iter->rec_idx++;
> >>  			goto retry;
> >>  		}
> > 
> > Why did you choose to do this? I was expecting the updated fix to be
> > dropping XFS_IGET_UNTRUSTED from the xfs_iget() call because the
> > inode numbers are coming from a trusted source (i.e. the rmapbt) and
> > this would then return the expected -ENOENT on unlink races instead
> > of -EINVAL....
> 
> I kept the XFS_IGET_UNTRUSTED because the xfs_rmap_query_range lookup
> that we do in xfs_zone_gc_query may not be valid by the time we call
> xfs_iget in xfs_zone_gc_iter_irec.

I'll repeat this once more: XFS_IGET_UNTRUSTED tells xfs_iget where
the inode number came from, not whether it *might* be valid or not.
xfs_iget() will detect races with unlink and do the right thing
regardless of whether IGET_UNTRUSTED is set.

IGET_UNTRUSTED is intended to be used when the inode number comes
from an an external source. That may be userspace or the network
with file handle decoding, bulkstat (user supplied inode number),
corrupt metadata (e.g during online repair when the inode clusters
cannot be fully trusted), etc.

In these situations, we should not be doing expensive validity
checks before attempting to read the inode from disk, and we should
not be giving any information back to the caller as
to whether the inode cluster is allocated or not on failure (e.g.
potentially giving away other valid inode numbers nearby). IOWs, we
don't want to be giving any indication of why the inode number is
considered invalid - it is just a bad inode number that was
provided, and because we don't trust the provider of the inode
number, that's all we will tell it.

However, inode numbers that come from internal metadata (i.e.
trusted sources) are -known to be valid-. They don't get placed into
the internal metadata if they are invalid inode numbers. Hence the
fact that is was in the rmapbt means it is, or very recently was, a
valid inode number, and we can trust it.

If xfs_iget then races with unlink on lookup, that is -just fine-
and it will return -ENOENT. In this case, xfs_iget() is telling the
caller that the inode is no longer allocated, because it is expected
that the caller can use and will do the right thing with this
information.

i.e. XFS_IGET_UNTRUSTED defines whether the inode number source
could be trusted to provide a valid inode number, not whether the
inode number can be guaranteed to be allocated at this specific
lookup instance.

-Dave.
-- 
Dave Chinner
dgc@kernel.org
