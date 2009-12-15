Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBFMaUNr002297 for <xfs@oss.sgi.com>; Tue, 15 Dec 2009 16:36:31 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D1743198784E
	for <xfs@oss.sgi.com>; Tue, 15 Dec 2009 14:37:07 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	Q1ZS2b3J1aQCiaYk for <xfs@oss.sgi.com>;
	Tue, 15 Dec 2009 14:37:07 -0800 (PST)
Date: Wed, 16 Dec 2009 09:36:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] XFS: Free buffer pages array unconditionally
Message-ID: <20091215223658.GD4850@discord.disaster>
References: <1260832317-14977-1-git-send-email-david@fromorbit.com>
	<1AB9A794DBDDF54A8A81BE2296F7BDFE012A6866@cf--amer001e--3.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A6866@cf--amer001e--3.americas.sgi.com>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Dec 15, 2009 at 01:21:36PM -0600, Alex Elder wrote:
> Dave Chinner wrote:
> > The code in xfs_free_buf() only attempts to free the b_pages array if the
> > buffer is a page cache backed or page allocated buffer. The extra log buffer
> > that is used when the log wraps uses pages that are allocated to a different
> > log buffer, but it still has a b_pages array allocated when those pages
> > are associated to with the extra buffer in xfs_buf_associate_memory.
> > 
> > Hence we need to always attempt to free the b_pages array when tearing
> > down a buffer, not just on buffers that are explicitly marked as page bearing
> > buffers. This fixes a leak detected by the kernel memory leak code.
> 
> Three places call xfs_buf_get_pages();
> - _xfs_buf_lookup_pages(), which sets the _XBF_PAGE_CACHE flag in the
>   buffer after the call
> - xfs_buf_associate_memory(), which sets no flag bit
> - xfs_buf_get_noaddr(), which sets the _XBF_PAGES flag.
> 
> The only place that checks for _XBF_PAGES is xfs_buf_free().
> 
> Given that, I have two comments:
> - You could just as easily have set the _XBF_PAGES flag in
>   xfs_buf_associate_memory, thereby making that flag indicate
>   consistently that the buffer has allocated pages

_XBF_PAGES is used to indicate that the buffer owns the
pages and must free them when the buffer is freed.

_XBF_PAGE_CACHE indicates pages are allocated out of the buftarg
page cache and need to be released when the buffer is freed.

In both cases, xfs_buf_free() has to free the pages
associated with these buffers.

In the case of xfs_buf_associate_memory(), the memory attached to
the buffer is owned by an external entity and hence we are not
allowed to free it when we free the buffer. Therefore we can't set
_XBF_PAGES on the buffer.

> - Or, since you are proposing unconditionally freeing the
>   pages,

This change doesn't unconditionally free the pages attached
to the buffer - it unconditionally frees the array used to
index the pages on the buffer when the buffer is torn down.
i.e:

   +------+         +------+
   |  bp  |         |      |-------> page
   |      | b_pages |      |-------> page
   |      |-------->|      |.............
   |      |         |      |-------> page
   |      |         |      |-------> page
   +------+         +------+
                     ^^^^^^
		This array is what we are
		freeing unconditionally.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
