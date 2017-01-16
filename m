Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45444 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750863AbdAPQ07 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 16 Jan 2017 11:26:59 -0500
Date: Mon, 16 Jan 2017 11:26:58 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2 0/5] xfs: basic cow fork speculative preallocation
Message-ID: <20170116162658.GC6302@bfoster.bfoster>
References: <1484157249-464-1-git-send-email-bfoster@redhat.com>
 <20170113171342.GC27605@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170113171342.GC27605@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Fri, Jan 13, 2017 at 09:13:42AM -0800, Christoph Hellwig wrote:
> On Wed, Jan 11, 2017 at 12:54:04PM -0500, Brian Foster wrote:
> > Hi all,
> > 
> > Here's v2 of the cow fork speculative prealloc patches. No major changes
> > here, as outlined below. Thoughts on any of this?
> 
> Any results?  Better performance, less extents for certain workloads?

Sorry, I neglected to pull that forward from the rfc. That discussion is
here:

http://www.spinics.net/lists/linux-xfs/msg02152.html

I should probably repeat some of this testing at this point, but the
general result is a reduction in extent count for parallel cow fork
allocator workloads. E.g., attempting to address the same problem of
parallel data fork allocators competing for contiguous space, resolved
by traditional speculative preallocation.

I was also kind of thinking about whether this could work around the
need to have a default cowextsz hint at all, allowing that feature to be
used more like the traditional extent size hint as well. This is
distinctly more aggressive for use cases like large vm image files,
however. At the same time, the idea is to make it transparent enough
that it shouldn't really affect the user (i.e., via throttling,
background and on demand reclaim, also just like normal preallocation).

Brian

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
