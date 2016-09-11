Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57400 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755569AbcIKM7c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 11 Sep 2016 08:59:32 -0400
Date: Sun, 11 Sep 2016 05:59:31 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 34/71] xfs: support bmapping delalloc extents in the CoW
 fork
Message-ID: <20160911125931.GF1399@infradead.org>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
 <147216814006.867.6404376654574855233.stgit@birch.djwong.org>
 <20160906152553.GA9760@infradead.org>
 <20160906163413.GC16696@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160906163413.GC16696@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, david@fromorbit.com, linux-xfs@vger.kernel.org, xfs@oss.sgi.com

On Tue, Sep 06, 2016 at 09:34:13AM -0700, Darrick J. Wong wrote:
> While we're combining patches, I think it makes sense to modify
> _iomap_write_allocate so that when it's converting a data fork
> delalloc reservation into a real extent that it should look for an
> adjacent (file offset-wise) real extent in the CoW fork and feed that
> to the allocator in the hopes of allocating all the blocks in the same
> part of the disk.  Or better yet as one big(ger) extent record.

That would be nice.  Not sure it's worth doing that for the initial
submission, though.
