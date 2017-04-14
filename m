Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:41592 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752239AbdDNHq7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 14 Apr 2017 03:46:59 -0400
Date: Fri, 14 Apr 2017 09:46:58 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 04/10] xfs: remove an unsafe retry in
        xfs_bmbt_alloc_block
Message-ID: <20170414074658.GA24766@lst.de>
References: <20170413080517.12564-1-hch@lst.de> <20170413080517.12564-5-hch@lst.de> <20170413183006.GD25915@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170413183006.GD25915@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Thu, Apr 13, 2017 at 02:30:06PM -0400, Brian Foster wrote:
> I'm not quite following why this retry is unsafe as noted in the patch
> title.. do you mean "unnecessary?" AFAICT, the firstblock == NULLFSBLOCK
> case means we can issue this first allocation from any AG.

Yes.

> If no AG can
> allocate a block while satisfying minleft, then we can still safely
> allocate from any AG provided any subsequent allocations occur in
> increasing AG order (i.e., by setting dop_low), right?

Yes.  But minleft is set exactly because we require this number of
blocks to be left after the current allocation.  If we could only
allocate the current allocation, but not satisfy minleft we risk
shutting the file system during subsequent allocations instead of
just returning ENOSPC now.

> Also, if this is unnecessary, what exactly verifies that all of the
> reserved blocks are available within the same AG?

xfs_alloc_space_available verifies that ->total blocks are available
in the current AG.  Callers of the allocator need to set it to the
correct value currently, although I have more xfs_bmapi changes in
the pipe to get this right automatically - but those aren't 4.12
material.
