Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:44318 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751302AbdH3HxW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Aug 2017 03:53:22 -0400
Date: Wed, 30 Aug 2017 00:53:21 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/4] xfs: test rmapbt updates are correct with
 insert/collapse range
Message-ID: <20170830075321.GC4711@infradead.org>
References: <150406805060.31349.16766271336969357123.stgit@magnolia>
 <150406806291.31349.16354828502139354709.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150406806291.31349.16354828502139354709.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: eguan@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Tue, Aug 29, 2017 at 09:41:02PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Make sure that we update the rmapbt correctly when we collapse-range a
> file and the extents on both sides of the hole can be merged.  We can
> construct this pretty trivially with insert-range and write, so test
> that too.

Does this break on the current tree?  From code inspection I suspect
the current code is doing the wrong thing there.

> +./src/punch-alternating -o $((16 * blksz / file_blksz)) \

Shouldn't we always use $here/src/progname ?
