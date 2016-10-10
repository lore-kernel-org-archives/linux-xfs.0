Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58619 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752020AbcJJKRB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Oct 2016 06:17:01 -0400
Date: Mon, 10 Oct 2016 03:17:00 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/7] xfs: reduce stack usage of _reflink_clear_inode_flag
Message-ID: <20161010101700.GA18359@infradead.org>
References: <147588163396.12127.8356851783027062457.stgit@birch.djwong.org>
 <147588165809.12127.6624984020251009472.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147588165809.12127.6624984020251009472.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

On Fri, Oct 07, 2016 at 04:07:38PM -0700, Darrick J. Wong wrote:
> The loop in _reflink_clear_inode_flag isn't necessary since we
> jump out if any part of any extent is shared.  Remove the loop
> and we no longer need two maps, so we can save some stack use.

I have a patch that gets rid of the xfs_bmapi_read calls entirely
and instead does an initial xfs_bmap_search_extents and then iterates
over the extent index.

It also uses xfs_reflink_trim_around_shared instead of opencoding
it.

It didn't plan to submit it now as it seemed to superficial for 4.9,
I can't dust it off if you want.
