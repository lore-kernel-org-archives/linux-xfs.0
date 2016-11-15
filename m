Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56312 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755456AbcKOIz3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Nov 2016 03:55:29 -0500
Date: Tue, 15 Nov 2016 00:55:26 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: About difference in extent sharing in btrfs and xfs
Message-ID: <20161115085526.GA18347@infradead.org>
References: <1de48152-0ec5-1bf0-1ea9-b5ccbe4a3867@cn.fujitsu.com>
 <20161115074715.GA23680@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161115074715.GA23680@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-xfs@vger.kernel.org, fstests@vger.kernel.org, btrfs <linux-btrfs@vger.kernel.org>

On Mon, Nov 14, 2016 at 11:47:15PM -0800, Darrick J. Wong wrote:
> XFS doesn't split the extent either, internally.  The FIEMAP
> implementation cross-references extent data with the refcount records,
> using extra struct fiemap_extent to report precisely which blocks are
> shared and which aren't.  ocfs2 exhibits the same behavior.

And I think exact reporting of already shared extents in FIEMAP is
extremely important - independent of the internal implementation btrfs
should report the extents correctly.
