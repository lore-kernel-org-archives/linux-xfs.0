Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 14A337FC8
	for <xfs@oss.sgi.com>; Thu, 20 Feb 2014 18:03:08 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0AE8C8F804B
	for <xfs@oss.sgi.com>; Thu, 20 Feb 2014 16:03:04 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	1C2wFlhoYJFnNgtV for <xfs@oss.sgi.com>;
	Thu, 20 Feb 2014 16:03:02 -0800 (PST)
Date: Fri, 21 Feb 2014 11:02:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] xfs: always do log forces via the workqueue
Message-ID: <20140221000257.GU4916@dastard>
References: <1392783402-4726-1-git-send-email-david@fromorbit.com>
	<1392783402-4726-2-git-send-email-david@fromorbit.com>
	<5304F6F6.3070007@redhat.com> <20140220002358.GH4916@dastard>
	<5306168B.8080209@sgi.com> <20140220220747.GQ4916@dastard>
	<5306833D.7080600@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5306833D.7080600@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Thu, Feb 20, 2014 at 04:35:41PM -0600, Mark Tinguely wrote:
> On 02/20/14 16:07, Dave Chinner wrote:
> >On Thu, Feb 20, 2014 at 08:51:55AM -0600, Mark Tinguely wrote:
> >>We know the later error paths in xfs_cil_push() will not do a wake,
> >>now is a good time to fix that.
> >
> >I'm not sure what you are talking about here. If there's a problem,
> >please send patches.
> 
> http://oss.sgi.com/archives/xfs/2013-12/msg00870.html

Which resulted in a discussion and discovery of more problems
that also needed fixing, so I'm waiting for patches to be posted
that fix them.

You know what the problems are, you know how they should be fixed
(it's in the discussion thread), and you are capable of writing
the fixes and testing them. So, please send patches.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
