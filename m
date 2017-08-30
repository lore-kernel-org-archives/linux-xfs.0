Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47841 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750895AbdH3W6w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Aug 2017 18:58:52 -0400
Date: Wed, 30 Aug 2017 15:58:25 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/4] xfs: test rmapbt updates are correct with
 insert/collapse range
Message-ID: <20170830225825.GD4754@magnolia>
References: <150406805060.31349.16766271336969357123.stgit@magnolia>
 <150406806291.31349.16354828502139354709.stgit@magnolia>
 <20170830075321.GC4711@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170830075321.GC4711@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: eguan@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Wed, Aug 30, 2017 at 12:53:21AM -0700, Christoph Hellwig wrote:
> On Tue, Aug 29, 2017 at 09:41:02PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Make sure that we update the rmapbt correctly when we collapse-range a
> > file and the extents on both sides of the hole can be merged.  We can
> > construct this pretty trivially with insert-range and write, so test
> > that too.
> 
> Does this break on the current tree?  From code inspection I suspect
> the current code is doing the wrong thing there.

AFAICR the existing rmap code in bmse_shift_one /does/ work, though only
due to the subtlety that xfs_rmap_{,un}map_extent is smart enough to
automatically merge and unmerge rmap extents for you.

Hence if you have the following:

AAAAABBBAAAAAAAA

Where both A's could be merged after BBB goes away:

AAAAAAAAAAAAA---

The deferred rmap code will merge the two A regions into a single rmap
extent record automatically.

Hmm, so I guess that means that in the patch "xfs: use xfs_iext_*_extent
helpers in xfs_bmap_shift_extents" you can replace the three xfs_rmap
calls in xfs_bmse_merge with:

	/* update reverse mapping */
	error = xfs_rmap_unmap_extent(mp, dfops, ip, whichfork, got);
	if (error)
		return error;
	memcpy(&new, got, sizeof(new));
	new.br_startoff = left->br_startoff + left->br_blockcount;
	return xfs_rmap_map_extent(mp, dfops, ip, whichfork, &new);

...which saves us a deferred op.  Ok, will propose that in the actual
thread.

> > +./src/punch-alternating -o $((16 * blksz / file_blksz)) \
> 
> Shouldn't we always use $here/src/progname ?

Ok, I didn't realize that.  There are a lot of programs that still use ./src....

--D

> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
