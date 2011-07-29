Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6TAuiX0040388 for <xfs@oss.sgi.com>; Fri, 29 Jul 2011 05:56:44 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9ACDDA3142
	for <xfs@oss.sgi.com>; Fri, 29 Jul 2011 03:56:42 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	CEn2CY7E3EqzJHCI for <xfs@oss.sgi.com>;
	Fri, 29 Jul 2011 03:56:42 -0700 (PDT)
Date: Fri, 29 Jul 2011 20:56:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: set cursor in xfs_ail_splice() even when AIL was
	empty
Message-ID: <20110729105639.GJ5404@dastard>
References: <201107212205.p6LM5dxF016460@stout.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201107212205.p6LM5dxF016460@stout.americas.sgi.com>
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

On Thu, Jul 21, 2011 at 05:05:39PM -0500, Alex Elder wrote:
> In xfs_ail_splice(), if a cursor is provided it is updated
> to point to the last item on the list to be spliced into
> the AIL.  But if the AIL was found to be empty, the cursor
> (if provided) is just initialized instead.
> 
> There is no reason the null AIL case needs to be any different.
> And treating it the same way allows this code to be rearranged
> a bit, with a somewhat tidier result.
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>

I've tested and reviewed the second version of this patch(*) and I
don't see anything problems at all, so:

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.

(*) In saving the second version, I accidentally marked the mail for
delete and then forgot to undelete it before switching mail folders
and commiting the delete. Hence I'm responding to the first mail :)
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
