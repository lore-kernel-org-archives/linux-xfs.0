Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:58638 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752471AbdAaN1E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Jan 2017 08:27:04 -0500
Date: Tue, 31 Jan 2017 05:26:58 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/7] xfs: fix toctou race when locking an inode to access
 the data map
Message-ID: <20170131132658.GA17386@infradead.org>
References: <148582218411.12293.806854574193653038.stgit@birch.djwong.org>
 <148582219035.12293.12084220786527965512.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <148582219035.12293.12084220786527965512.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jan 30, 2017 at 04:23:10PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> We use di_format and if_flags to decide whether we're grabbing the ilock
> in btree mode (btree extents not loaded) or shared mode (anything else),
> but the state of those fields can be changed by other threads that are
> also trying to load the btree extents -- IFEXTENTS gets set before the
> _bmap_read_extents call and cleared if it fails.  Therefore, once we've
> grabbed the shared ilock we have to re-check the fields to see if we
> actually need to upgrade to the exclusive ilock in order to try loading
> the extents.
> 
> Without this patch, we trigger ilock assert failures when a bunch of
> threads try to access a btree format directory with a corrupt bmbt root
> and corrupt the incore data structures, leading to a crash.

I see the problem here, but I really don't like the fix.  Instead
I'd much rather check for a new flag that tells that the extent list
hasn't been read, which can only be cleared under the exclusive
ilock.  That way we shouldn't need any additional relocking or
checks.

