Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 25 Jul 2006 03:51:44 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6PAp7DX001440
	for <xfs@oss.sgi.com>; Tue, 25 Jul 2006 03:51:10 -0700
Date: Tue, 25 Jul 2006 10:38:42 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: review: rework bulkstat readahead
Message-ID: <20060725093842.GA29615@infradead.org>
References: <20060725134651.D2116482@wobbly.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060725134651.D2116482@wobbly.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nathans@sgi.com>
Cc: vapo@melbourne.sgi.com, xfs@oss.sgi.com

On Tue, Jul 25, 2006 at 01:46:51PM +1000, Nathan Scott wrote:
> Hi all,
>     
> This patch rearranges the logic inside xfs_bulkstat to issue
> readahead in a way that performs alot better.  The most critical 
> piece is moving the readahead out of the final read-and-format
> loop into the earlier build-up-irbuf-array loop.  This means:
>     
> - buffer readaheads are all issued at once, up front, before we 
> start to issue the blocking reads waiting on each inode cluster;
>     
> - as a by-product, the readahead which is done for the internal
> nodes of the AGI btree (from within xfs_inobt_increment) is now 
> issued in the correct order relative to all the leaf readahead. 
> 
> I've also removed the incorrect endian swapping on the irbuf array
> elements, that was always unnecessary as they're only ever held in
> memory here.

looks good and sorry for not noticing the unessecary swapping when doing
the sparse annotations.
