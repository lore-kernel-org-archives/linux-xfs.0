Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:61960 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726228AbeHUIH4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Aug 2018 04:07:56 -0400
Date: Tue, 21 Aug 2018 14:49:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [patch] file dedupe (and maybe clone) data corruption (was Re:
 [PATCH] generic: test for deduplication between different files)
Message-ID: <20180821044921.GX2234@dastard>
References: <20180817083924.16916-1-fdmanana@kernel.org>
 <20180819231126.GU2234@dastard>
 <20180820010932.GV2234@dastard>
 <20180820153349.GA4334@magnolia>
 <20180821004907.GW2234@dastard>
 <a48d51e8-52c7-b9af-a6e6-f840b893c843@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a48d51e8-52c7-b9af-a6e6-f840b893c843@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, fdmanana@kernel.org, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Mon, Aug 20, 2018 at 08:17:18PM -0500, Eric Sandeen wrote:
> 
> 
> On 8/20/18 7:49 PM, Dave Chinner wrote:
> > 	Upon successful completion of this ioctl, the number of
> > 	bytes successfully deduplicated is returned in bytes_deduped
> > 	and a status code for the deduplication operation is
> > 	returned in status.  If even a single byte in the range does
> > 	not match, the deduplication request will be ignored  and
> > 	status set  to FILE_DEDUPE_RANGE_DIFFERS.
> > 
> > This implies we can dedupe less than the entire range as long as the
> > entire range matches. If the entire range does not match, we have
> > to return FILE_DEDUPE_RANGE_DIFFERS, but in this case it does match
> > so we can pick and choose how much we deduplicate. How much we
> > dedupe is then returned as a byte count. In this case, it will be a
> > few bytes short of the entire length requested because we aligned
> > the dedupe inwards....
> > 
> > Does that sound reasonable?
> 
> I had hoped that dedupe was advisory as Darrick wished for, but TBH my
> reading of that is no, if you ask for a range to be deduped and any of
> it differs, "even a single byte," you fail it all.

Yes, if the data differs, then it fails.  But that's not what I'm
questioning nor what I care about in this case. I'm asking whether
the filesystem gets to choose how much of the range of same data is
deduped when the file data is apparently the same.

> Why else would that last part be present, if the interface is free to
> ignore later parts that don't match and truncate the range to the
> matching portion?

I think there is a clear differentiation in the man page text
between "all the bytes are the same" and "how much of that range the
filesystem deduped". i.e. the man page does not say that the
filesystem *must* dedupe the entire range if all the data is the
same - it says the filesystem will return /how many bytes it
successfully deduplicated/. IOWs, "do nothing and return zero" is a
valid ->dedupe_file_range implementation.

AFAIC, it's the fact that we do data comparison from the page cache
before calling into the filesystem to check on-disk formats that is
the problem here. Having identical data in the page cache is not the
same thing as "the blocks on disk containing the user data are
identical". i.e. Filesystems deduplicate disk blocks, but they often
perform transformations on the data as it passes between the page
cache and disk blocks or have constraints on the format of the data
on disk. For example:

	- encrypted files. unencrypted data in the page cache is the
	  same, therefore we can't return FILE_DEDUPE_RANGE_DIFFERS
	  because the user will be able to see that they are the
	  same. But they will different on disk after encryption
	  (e.g. because different nonce/seed or completely different
	  keys) and so the filesystem should not dedupe them.

	- the two files differ in on-disk format e.g. compressed
	  vs encrypted.

	- data might be inline with metadata

	- tail packing

	- dedupe request might be block aligned at file offsets, but
	  file offsets are not aligned to disk blocks due to, say,
	  multi-block data compression.

	- on disk extent tracking granularity might be larger than
	  filesystem block size (e.g. ext4's bigalloc mode) so can't
	  be deduped on filesystem block size alignment.

	- the source or destination inode is marked "NODATACOW" so
	  can't contain shared extents

I'm sure there's others, but I think this is enough to demonstrate
that "user visible file data is the same" does not mean the
filesystem can dedupe it. The wording in the man page appears to
understand these limitations and hence it allows us to silently
ignore the partial EOF block when it comes to dedupe....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
