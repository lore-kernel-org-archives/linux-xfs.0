Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1F4A87F37
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 19:34:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EFAA7304039
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 17:34:57 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	8q56NqyXe9siMjIV for <xfs@oss.sgi.com>;
	Sun, 29 Sep 2013 17:34:56 -0700 (PDT)
Date: Mon, 30 Sep 2013 10:34:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 3/4] xfs: push down inactive transaction mgmt for ifree
Message-ID: <20130930003453.GK26872@dastard>
References: <1379689572-5543-1-git-send-email-bfoster@redhat.com>
	<1379689572-5543-4-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1379689572-5543-4-git-send-email-bfoster@redhat.com>
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

On Fri, Sep 20, 2013 at 11:06:11AM -0400, Brian Foster wrote:
> Push the inode free work performed during xfs_inactive() down into
> a new xfs_inactive_ifree() helper. This clears xfs_inactive() from
> all inode locking and transaction management more directly
> associated with freeing the inode xattrs, extents and the inode
> itself.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks OK to me.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
