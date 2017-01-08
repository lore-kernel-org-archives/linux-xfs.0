Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59656 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753255AbdAHQIU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 8 Jan 2017 11:08:20 -0500
Date: Sun, 8 Jan 2017 11:08:14 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/5] xfs: fix the alignment fallback in xfs_bmap_btalloc
Message-ID: <20170108160814.GB62847@bfoster.bfoster>
References: <1482436822-31546-1-git-send-email-hch@lst.de>
 <1482436822-31546-3-git-send-email-hch@lst.de>
 <20170104143405.GB41989@bfoster.bfoster>
 <20170108103134.GB26451@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170108103134.GB26451@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, eguan@redhat.com, darrick.wong@oracle.com

On Sun, Jan 08, 2017 at 11:31:34AM +0100, Christoph Hellwig wrote:
> On Wed, Jan 04, 2017 at 09:34:05AM -0500, Brian Foster wrote:
> > Ok, but we have the following near the top of xfs_alloc_vextent():
> > 
> >         if (args->alignment == 0)
> >                 args->alignment = 1;
> > 
> > ... so I'm not sure the commit log description is accurate. That aside:
> > 
> > Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> Well, in that case we might not actually need it.  This was just a
> a drive-by patch from investigating what the alignmnet - 1 mean in
> the allocator.
> 
> Either way this could be cleaned up, but probably shouldn't be in
> a minimal bugfix series.

We could also just replace it with something like ASSERT(args->alignment
> 0) before the use of (alignment - 1), which is kind of
self-documenting (but still probably not worth a patch on its own). But
fair enough either way...

Brian

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
