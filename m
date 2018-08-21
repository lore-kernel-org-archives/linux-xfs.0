Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56346 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725733AbeHUEfQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 21 Aug 2018 00:35:16 -0400
Subject: Re: [patch] file dedupe (and maybe clone) data corruption (was Re:
 [PATCH] generic: test for deduplication between different files)
References: <20180817083924.16916-1-fdmanana@kernel.org>
 <20180819231126.GU2234@dastard> <20180820010932.GV2234@dastard>
 <20180820153349.GA4334@magnolia> <20180821004907.GW2234@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <a48d51e8-52c7-b9af-a6e6-f840b893c843@sandeen.net>
Date: Mon, 20 Aug 2018 20:17:18 -0500
MIME-Version: 1.0
In-Reply-To: <20180821004907.GW2234@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: fdmanana@kernel.org, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org



On 8/20/18 7:49 PM, Dave Chinner wrote:
> 	Upon successful completion of this ioctl, the number of
> 	bytes successfully deduplicated is returned in bytes_deduped
> 	and a status code for the deduplication operation is
> 	returned in status.  If even a single byte in the range does
> 	not match, the deduplication request will be ignored  and
> 	status set  to FILE_DEDUPE_RANGE_DIFFERS.
> 
> This implies we can dedupe less than the entire range as long as the
> entire range matches. If the entire range does not match, we have
> to return FILE_DEDUPE_RANGE_DIFFERS, but in this case it does match
> so we can pick and choose how much we deduplicate. How much we
> dedupe is then returned as a byte count. In this case, it will be a
> few bytes short of the entire length requested because we aligned
> the dedupe inwards....
> 
> Does that sound reasonable?

I had hoped that dedupe was advisory as Darrick wished for, but TBH my
reading of that is no, if you ask for a range to be deduped and any of
it differs, "even a single byte," you fail it all.

Why else would that last part be present, if the interface is free to
ignore later parts that don't match and truncate the range to the
matching portion?

-Eric
