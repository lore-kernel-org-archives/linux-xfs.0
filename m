Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6J1PBRt138057 for <xfs@oss.sgi.com>; Mon, 18 Jul 2011 20:25:11 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 61BB77C75E
	for <xfs@oss.sgi.com>; Mon, 18 Jul 2011 18:25:09 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	7K8L9QiAMDxwjaVn for <xfs@oss.sgi.com>;
	Mon, 18 Jul 2011 18:25:09 -0700 (PDT)
Date: Tue, 19 Jul 2011 11:25:07 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] xfs: convert xfsbufd to use a workqueue
Message-ID: <20110719012507.GH30254@dastard>
References: <1310960989-10284-1-git-send-email-david@fromorbit.com>
	<1310960989-10284-3-git-send-email-david@fromorbit.com>
	<20110718160129.GB14094@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110718160129.GB14094@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Jul 18, 2011 at 12:01:29PM -0400, Christoph Hellwig wrote:
> On Mon, Jul 18, 2011 at 01:49:48PM +1000, Dave Chinner wrote:
> > control flushing. While there, group all the delayed write list and
> > buffer handling functions into the same section of code to make it
> > easier to find all the relevant code.
> 
> Any chance you could make the re-grouping a separate patch?  It's
> really hard to read it right now as the actual changes are hidden too
> much.

OK.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
