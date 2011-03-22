Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2MCt61L020200 for <xfs@oss.sgi.com>; Tue, 22 Mar 2011 07:55:12 -0500
Received: from zene.cmpxchg.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5B86B1638598
	for <xfs@oss.sgi.com>; Tue, 22 Mar 2011 05:58:05 -0700 (PDT)
Received: from zene.cmpxchg.org (zene.cmpxchg.org [85.214.230.12]) by
	cuda.sgi.com with ESMTP id 54OqMQuJjCpiJOan for
	<xfs@oss.sgi.com>; Tue, 22 Mar 2011 05:58:05 -0700 (PDT)
Date: Tue, 22 Mar 2011 13:57:36 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] xfs: flush vmap aliases when mapping fails
Message-ID: <20110322125736.GZ2140@cmpxchg.org>
References: <1299713876-7747-1-git-send-email-david@fromorbit.com>
	<20110310073751.GB25374@infradead.org>
	<20110310224945.GA15097@dastard>
	<20110321122526.GX2140@cmpxchg.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110321122526.GX2140@cmpxchg.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Nick Piggin <npiggin@kernel.dk>, Hugh Dickins <hughd@google.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>

On Mon, Mar 21, 2011 at 01:25:26PM +0100, Johannes Weiner wrote:
> On Fri, Mar 11, 2011 at 09:49:45AM +1100, Dave Chinner wrote:
> > FWIW, while the VM folk might be paying attention about vmap realted
> > stuff, this vmap BUG() also needs triage:
> > 
> > https://bugzilla.kernel.org/show_bug.cgi?id=27002
> 
> I stared at this bug and the XFS code for a while over the weekend.
> What you are doing in there is really scary!
> 
> So xfs_buf_free() does vm_unmap_ram if the buffer has the XBF_MAPPED
> flag set and spans multiple pages (b_page_count > 1).
> 
> In xlog_sync() you have that split case where you do XFS_BUF_SET_PTR
> on that in-core log's l_xbuf which changes that buffer to, as far as I
> could understand, linear kernel memory.  Later in xlog_dealloc_log you
> call xfs_buf_free() on that buffer.
> 
> I was unable to determine if this can ever be more than one page in
> the buffer for the split case.  But if this is the case, you end up
> invoking vm_unmap_ram() on something you never vm_map_ram'd, which
> could explain why this triggers the BUG_ON() for the dirty area map.

Blech, that's bogus, please pardon my rashness.

I looked over the vmalloc side several times but could not spot
anything that would explain this crash.

However, when you switched from vunmap to vm_unmap_ram you had to add
the area size parameter.

I am guessing that the base address was always correct, vunmap would
have caught an error with it.  But the new size argument could be too
large and crash the kernel when it would reach into the next area that
had already been freed (and marked in the dirty bitmap).

I have given up on verifying that what xlog_sync() does to l_xbuf is
okay.  It would be good if you could confirm that it leaves the buffer
in a state so that its b_addr - b_offset, b_page_count are correctly
describing the exact vmap area.

	Hannes

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
