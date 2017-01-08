Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:57818 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755968AbdAHKab (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 8 Jan 2017 05:30:31 -0500
Date: Sun, 8 Jan 2017 11:30:28 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/5] xfs: bump up reserved blocks in xfs_alloc_set_aside
Message-ID: <20170108103028.GA26451@lst.de>
References: <1482436822-31546-1-git-send-email-hch@lst.de> <1482436822-31546-2-git-send-email-hch@lst.de> <20170104143350.GA41989@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170104143350.GA41989@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, eguan@redhat.com, darrick.wong@oracle.com

On Wed, Jan 04, 2017 at 09:33:51AM -0500, Brian Foster wrote:
> Presumably this patch addresses the potential deadlock issues from the
> previous version, but the commit log description makes no mention of it
> whatsoever. While the code seems fine, I think the commit log
> description needs more information wrt to that situation and the
> relationship/dependency with minleft.

Ok.

> The comment above xfs_alloc_set_aside() already touches on the writeback
> situation, but why 4 blocks per ag? Wasn't the intent to use
> worst_indlen() since that's the base for minleft?

No, I've given up on that.  worst_indlen deals with the fact that
for converting a delayed extent of a given length we might need multiple
real extents, possible in different AGs.

This version of the series keeps the previous minleft that is for just
allocating a single extent in the AG - the callers will handle "short"
returns from xfs_bmapi_write and just start a new allocation.  And
except for a corner case in the large directory block allocation code
these are in a new / rolled over transaction.  Fixing the latter also
is on my todo list, but it's another big issue that so far hasn't
trigger in practive, so I'd like to keep it in a separate series.

> Also, it looks like this causes a regression in xfs/004. On a quick
> look, we might just need a test update however...

Yes.  Hard to do in a series for the kernel, though :)
