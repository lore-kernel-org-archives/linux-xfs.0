Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 946CE7F37
	for <xfs@oss.sgi.com>; Thu, 24 Oct 2013 11:41:18 -0500 (CDT)
Date: Thu, 24 Oct 2013 11:41:15 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: prevent stack overflows from page cache allocation
Message-ID: <20131024164115.GU1935@sgi.com>
References: <1382585110-1796-1-git-send-email-david@fromorbit.com>
	<20131024084803.GA28144@infradead.org>
	<20131024103751.GS2797@dastard>
	<20131024154220.GA19055@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131024154220.GA19055@infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

Hey,

On Thu, Oct 24, 2013 at 08:42:20AM -0700, Christoph Hellwig wrote:
> On Thu, Oct 24, 2013 at 09:37:51PM +1100, Dave Chinner wrote:
> > Sure, if you want to. But doing that shouldn't prevent this fix from
> > being committed in the mean time, especially as other filesystems
> > already use this method for avoiding these problems.
> 
> I'd much prefer aiming for the proper fix first.  If for some reason we
> can't get it done in time the workaround can be applied.

Dave probably has a customer waiting on this.  If pulling this in will make a
proper fix more difficult to do I can understand keeping the patch out.
Otherwise, can't we just remove this along with the other filesystems'
equivalent code when the proper fix is committed?

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
