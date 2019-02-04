Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:37434 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727057AbfBDUxM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Feb 2019 15:53:12 -0500
Date: Mon, 4 Feb 2019 12:53:10 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/10] xfs: track unlinked inode counts in per-ag data
Message-ID: <20190204205310.GB30334@infradead.org>
References: <154930313674.31814.17994684613232167921.stgit@magnolia>
 <154930315478.31814.9792968910867944759.stgit@magnolia>
 <20190204192451.GB47560@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190204192451.GB47560@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Mon, Feb 04, 2019 at 02:24:51PM -0500, Brian Foster wrote:
> I'm a little confused where we're at with this one given the discussion
> on the previous version. We've dropped the locking, but left the
> tracking in place. Are we just relying on holding the agi in the
> iunlink/iunlink_remove cases? If so, that seems reasonable to me but the
> commit log should probably have a sentence or two on the serialization
> rules. The commit log could also use an update to describe how this
> value is actually used in this patch (as an unmount time check) as
> opposed to some apparent throttling functionality that isn't a part of
> this series.

I thought we Darrick was going to drop this tracking from the series,
as it isn't very useful (at least yet), but maybe I misunderstood the
previous thread.
