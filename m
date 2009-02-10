Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1AAwPLU047029 for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 04:58:25 -0600
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C7B4B190EEBB
	for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 02:57:47 -0800 (PST)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net
	[203.16.214.146]) by cuda.sgi.com with ESMTP id
	p9cVcPOEK5W5e62o for <xfs@oss.sgi.com>;
	Tue, 10 Feb 2009 02:57:47 -0800 (PST)
Date: Tue, 10 Feb 2009 21:01:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Re-dirty pages on I/O error
Message-ID: <20090210100129.GN8830@disturbed>
References: <4990DCF6.5000900@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4990DCF6.5000900@sgi.com>
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
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, Feb 10, 2009 at 12:48:38PM +1100, Lachlan McIlroy wrote:
> [This patch seems to have slipped through the proverbial crack.]
>
> If we get an error in xfs_page_state_convert() - and it's not EAGAIN - then
> we throw away the dirty page without converting the delayed allocation.  This
> leaves delayed allocations that can never be removed and confuses code that
> expects a flush of the file to clear them.  We need to re-dirty the page on
> error so we can try again later or report that the flush failed.

As discussed previously, the fix that is needed in the page
invalidation path. i.e.  the page invalidate path clears the
buffer_delay() flag (via discard_buffer) before we get to
->releasepage and so releasepage fails to convert the delalloc
extent before tossing the page....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
