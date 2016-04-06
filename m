Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5DD997CA1
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 15:58:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1F49B304039
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 13:58:07 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	HRhGxE2nNtVxi3AG for <xfs@oss.sgi.com>;
	Wed, 06 Apr 2016 13:58:05 -0700 (PDT)
Date: Thu, 7 Apr 2016 06:57:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_iext_realloc_indirect and "XFS: possible memory allocation
	deadlock"
Message-ID: <20160406205736.GB13574@dastard>
References: <20150629222651.GG7943@dastard>
	<F1A27B6A9FB048488A388EC4D9FD71F7@alyakaslap>
	<20150707000911.GT7943@dastard>
	<20150707090511.GA21863@infradead.org>
	<7792DA2A464640B1BC7220973CED41AE@alyakaslap>
	<20150723230912.GE3902@dastard>
	<77693FFEB62A474DA7F039FD92CC5304@alyakaslap>
	<20160405204106.GF11238@dastard>
	<A01B206564694781A7BE74415E4C6D1E@alyakaslap>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <A01B206564694781A7BE74415E4C6D1E@alyakaslap>
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

On Wed, Apr 06, 2016 at 07:39:21PM +0300, Alex Lyakas wrote:
> Hello Dave,
> 
> Thank you for your response. We understand your concerns and will do
> further testing with the vmalloc alternative.
> 
> Meanwhile, I found another issue happening when files have many
> extents. When unmounting XFS, we call
> xfs_inode_free => xfs_idestroy_fork => xfs_iext_destroy
> This goes over the whole indirection array and calls
> xfs_iext_irec_remove for each one of the erps (from the last one to
> the first one). As a result, we keep shrinking (reallocating
> actually) the indirection array until we shrink out all of its
> elements. When we have files with huge numbers of extents, umount
> takes 30-80 sec, depending on the amount of files that XFS loaded
> and the amount of indirection entries of each file. The unmount
> stack looks like [1].
> 
> That patch in [2] seems to address the issue. Do you think it is
> reasonable? It was tested only on kernel 3.18.19.

Looks like a good optimisation to make. Can you send it as proper
patch (separate thread) with this description and your signed-off-by
on it?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
