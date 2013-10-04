Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 660577F53
	for <xfs@oss.sgi.com>; Thu,  3 Oct 2013 19:48:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0469AAC006
	for <xfs@oss.sgi.com>; Thu,  3 Oct 2013 17:48:17 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	N9JFwNrXLrW4CeTB for <xfs@oss.sgi.com>;
	Thu, 03 Oct 2013 17:48:13 -0700 (PDT)
Date: Fri, 4 Oct 2013 10:47:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 02/16] xfs: unify directory/attribute format definitions
Message-ID: <20131004004741.GB4446@dastard>
References: <1380510433-8353-1-git-send-email-david@fromorbit.com>
	<1380510433-8353-3-git-send-email-david@fromorbit.com>
	<20131003145218.GB10316@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131003145218.GB10316@infradead.org>
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
Cc: xfs@oss.sgi.com

On Thu, Oct 03, 2013 at 07:52:18AM -0700, Christoph Hellwig wrote:
> Looks good, but you have some function prototype declarations sneaking
> into the format header again.

Right, there's a few that are copied over that already exist (e.g.
the to/from disk functions). They go away during the vectorisation
of the directory operations as all the externally accessed to/from
disk encoding is accessed through the xfs_dir_ops vector. Hence this
is only a temporary situation through this patchset.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
