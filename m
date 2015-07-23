Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 93F947F9B
	for <xfs@oss.sgi.com>; Thu, 23 Jul 2015 18:10:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6D2578F8035
	for <xfs@oss.sgi.com>; Thu, 23 Jul 2015 16:10:07 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Yz4jlsFzvy4q4f3S for <xfs@oss.sgi.com>;
	Thu, 23 Jul 2015 16:10:05 -0700 (PDT)
Date: Fri, 24 Jul 2015 09:09:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_iext_realloc_indirect and "XFS: possible memory allocation
	deadlock"
Message-ID: <20150723230912.GE3902@dastard>
References: <20150629222651.GG7943@dastard>
	<F1A27B6A9FB048488A388EC4D9FD71F7@alyakaslap>
	<20150707000911.GT7943@dastard>
	<20150707090511.GA21863@infradead.org>
	<7792DA2A464640B1BC7220973CED41AE@alyakaslap>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <7792DA2A464640B1BC7220973CED41AE@alyakaslap>
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
To: Alex Lyakas <alex@zadarastorage.com>
Cc: Danny Shavit <danny@zadarastorage.com>, Shyam Kaushik <shyam@zadarastorage.com>, bfoster@redhat.com, Yair Hershko <yair@zadarastorage.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>

On Thu, Jul 23, 2015 at 05:39:28PM +0200, Alex Lyakas wrote:
> Hi Dave,
> Just for completeness,  XFS speculative preallocation (that is based
> now upon the size of the last extent) can still grow up to 4Gb-8Gb
> (depending on which patches we are pulling). As a result, xfs_iozero
> can still sometimes trigger 1-2GB writes of zeros in one shot. This
> turns out to be a bit unfriendly to the drives in some
> configurations. So we have applied a custom patch to limit the
> speculative preallocation to 32Mb.

It would be much better to change xfs_zero_eof() to convert extents
beyond EOF to unwritten extents rather than zero them. That way you
still get the benefits of the large speculative prealloc but without
the zeroing overhead that wierd sparse write patterns can trigger.

I just haven't got around to doing this because it hasn't been
reported as a significant problem for anyone until now.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
