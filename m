Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 82D757F7C
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2015 18:12:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2C898AC002
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2015 16:12:09 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	K9EmeYEo3t7AC1PD for <xfs@oss.sgi.com>;
	Mon, 29 Jun 2015 16:12:06 -0700 (PDT)
Date: Tue, 30 Jun 2015 09:11:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: remote attribute headers contain an invalid LSN
Message-ID: <20150629231140.GH7943@dastard>
References: <1434948369-13931-1-git-send-email-david@fromorbit.com>
	<20150624131228.GC1888@bfoster.bfoster>
	<20150624212643.GJ22807@dastard>
	<20150625124643.GA36162@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150625124643.GA36162@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Jun 25, 2015 at 08:46:44AM -0400, Brian Foster wrote:
> So as noted above, were this treated as a typical metadata block, the
> corresponding buffer would be logged and thus everything would be
> ordered appropriately with respect to the log. It is not a logged buffer
> in this case, so we drop XFS_BMAPI_METADATA flag from the allocation
> which would cause any previous frees of this block to be flushed to the
> ail.

Yes.

> I don't see anything explicit that "handles" the case of being written
> before the allocation transaction is committed. By "handles," do you
> simply mean the aforementioned log force? In other words, we're
> implicitly saying it's fine that the block is written out of order from
> the allocation, so long as the block is marked free on-disk.

Yes and yes.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
