Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A4C607CBE
	for <xfs@oss.sgi.com>; Fri, 26 Apr 2013 16:33:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2A817AC004
	for <xfs@oss.sgi.com>; Fri, 26 Apr 2013 14:33:19 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	cwcLtJSm27sHWJmI for <xfs@oss.sgi.com>;
	Fri, 26 Apr 2013 14:33:13 -0700 (PDT)
Date: Sat, 27 Apr 2013 07:33:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 2/2] xfs: enhance warning on xfs_imap() failure in
	xfs_iunlink_remove()
Message-ID: <20130426213308.GA30622@dastard>
References: <1366975813-65025-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1366975813-65025-1-git-send-email-bfoster@redhat.com>
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

On Fri, Apr 26, 2013 at 07:30:13AM -0400, Brian Foster wrote:
> From: Eric Sandeen <sandeen@redhat.com>
> 
> Include the global ino, ag number and agino in the warning message
> emitted should xfs_imap() fail in the xfs_iunlink_remove() code
> path.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good now.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
