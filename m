Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3BEDF7CA0
	for <xfs@oss.sgi.com>; Tue,  5 Apr 2016 15:41:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A0B9CAC004
	for <xfs@oss.sgi.com>; Tue,  5 Apr 2016 13:41:36 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	OOftDpCr8MADI1eh for <xfs@oss.sgi.com>;
	Tue, 05 Apr 2016 13:41:33 -0700 (PDT)
Date: Wed, 6 Apr 2016 06:41:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_iext_realloc_indirect and "XFS: possible memory allocation
	deadlock"
Message-ID: <20160405204106.GF11238@dastard>
References: <20150629222651.GG7943@dastard>
	<F1A27B6A9FB048488A388EC4D9FD71F7@alyakaslap>
	<20150707000911.GT7943@dastard>
	<20150707090511.GA21863@infradead.org>
	<7792DA2A464640B1BC7220973CED41AE@alyakaslap>
	<20150723230912.GE3902@dastard>
	<77693FFEB62A474DA7F039FD92CC5304@alyakaslap>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <77693FFEB62A474DA7F039FD92CC5304@alyakaslap>
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

On Tue, Apr 05, 2016 at 09:10:06PM +0300, Alex Lyakas wrote:
> Hello Dave, Brian, Christoph,
> 
> We are still encountering cases, in which different IO patterns beat
> XFS preallocation schemes, resuling in highly fragmented files,
> having 100s of thousands and sometimes millions of extents. In these
> cases XFS tries to allocate large arrays of xfs_ext_irec_t structure
> with kmalloc, and this often gets into numerous retries, and
> sometimes triggers hung task panic (due to some other thread wanting
> to access the same file).
> 
> We made a change to call kmem_zalloc_large, which resorts to
> __vmalloc in case kmalloc fails. kmem_free is already handling
> vmalloc addresses correctly. The change is only for the allocation
> done in xfs_iext_realloc_indirect, as this is the only place, in
> which we have seen the issue.

As I've said before, vmalloc is not a solution we can use in
general.  32 bit systems have less vmalloc area than normal kernel
memory (e.g. ia32 has 128MB of vmalloc space vs 896MB of kernel
address space by default) and hence if we get large vmap allocation
requests for non-temporary, not directly reclaimable memory then
we'll end up with worse problems than we already have due to vmalloc
area exhaustion.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
