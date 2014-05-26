Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 71C077F4E
	for <xfs@oss.sgi.com>; Mon, 26 May 2014 18:01:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 62496304032
	for <xfs@oss.sgi.com>; Mon, 26 May 2014 16:01:14 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	zHYWvoqqEq2retRn for <xfs@oss.sgi.com>;
	Mon, 26 May 2014 16:01:12 -0700 (PDT)
Date: Tue, 27 May 2014 09:00:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 3/3] xfs: squash prealloc while over quota free space
	as well
Message-ID: <20140526230059.GS18954@dastard>
References: <1400845950-41435-1-git-send-email-bfoster@redhat.com>
	<1400845950-41435-4-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1400845950-41435-4-git-send-email-bfoster@redhat.com>
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

On Fri, May 23, 2014 at 07:52:30AM -0400, Brian Foster wrote:
> Commit 4d559a3b introduced heavy prealloc. squashing to catch the case
> of requesting too large a prealloc on smaller filesystems, leading to
> repeated flush and retry cycles that occur on ENOSPC. Now that we issue
> eofblocks scans on EDQUOT/ENOSPC, squash the prealloc against the
> minimum available free space across all applicable quotas as well to
> avoid a similar problem of repeated eofblocks scans.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Good idea - thrashing is something worth avoiding....

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
