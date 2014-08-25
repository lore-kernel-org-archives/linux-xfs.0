Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C9E997F4E
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2014 17:34:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B5AAC8F804B
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2014 15:34:40 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	hwJVf01hvTumwDXr for <xfs@oss.sgi.com>;
	Mon, 25 Aug 2014 15:34:38 -0700 (PDT)
Date: Tue, 26 Aug 2014 08:34:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: trim eofblocks before collapse range
Message-ID: <20140825223431.GG20518@dastard>
References: <1408988250-17772-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1408988250-17772-1-git-send-email-bfoster@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Mon, Aug 25, 2014 at 01:37:30PM -0400, Brian Foster wrote:
> xfs_collapse_file_space() currently writes back the entire file
> undergoing collapse range to settle things down for the extent shift
> algorithm. While this prevents changes to the extent list during the
> collapse operation, the writeback itself is not enough to prevent
> unnecessary collapse failures.
> 
> The current shift algorithm uses the extent index to iterate the in-core
> extent list. If a post-eof delalloc extent persists after the writeback
> (e.g., a prior zero range op where the end of the range aligns with eof
> can separate the post-eof blocks such that they are not written back and
> converted), xfs_bmap_shift_extents() becomes confused over the encoded
> br_startblock value and fails the collapse.
> 
> As with the full writeback, this is a temporary fix until the algorithm
> is improved to cope with a volatile extent list and avoid attempts to
> shift post-eof extents.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> Hi all,
> 
> This addresses the other fsx failure I've observed related to collapse
> range. It should also be addressed by reworking the algorithm as
> discussed in Dave's full file writeback patch. This patch applies on top
> of that and I think this is more suitable for a near-term -rc drop.

Added to my set of patches for testing.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
