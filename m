Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B7D857F37
	for <xfs@oss.sgi.com>; Tue,  7 Jul 2015 04:05:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A49C5304066
	for <xfs@oss.sgi.com>; Tue,  7 Jul 2015 02:05:14 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id ZSlDOAO01n0VwUaJ (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 07 Jul 2015 02:05:13 -0700 (PDT)
Date: Tue, 7 Jul 2015 02:05:11 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs_iext_realloc_indirect and "XFS: possible memory allocation
	deadlock"
Message-ID: <20150707090511.GA21863@infradead.org>
References: <20150629222651.GG7943@dastard>
	<F1A27B6A9FB048488A388EC4D9FD71F7@alyakaslap>
	<20150707000911.GT7943@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150707000911.GT7943@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Shyam Kaushik <shyam@zadarastorage.com>, bfoster@redhat.com, Yair Hershko <yair@zadarastorage.com>, xfs@oss.sgi.com, Danny Shavit <danny@zadarastorage.com>, Alex Lyakas <alex@zadarastorage.com>

On Tue, Jul 07, 2015 at 10:09:11AM +1000, Dave Chinner wrote:
> server crash. i.e. the client side commit is an "fsync" to the
> server, and until the server responds with a success to the client
> commit RPC the client side will continue to retry sending the data
> to the server.
> 
> For the persepctive of metadata (i.e. directory entries) the use of
> the "dirsync" mount option is sufficient for HA failover servers to
> work correctly as it ensures that directory structure changes are always
> committed to disk before the RPC response is sent back to the
> client.
> 
> i.e. the "sync" mount option doesn't actually improve data integrity
> of an NFS server when you look at the end-to-end NFS protocol
> handling of async write data....


You don't need dirsync either.  NFS does the right sync usin the
commit_metadata export operation without using that big hammer.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
