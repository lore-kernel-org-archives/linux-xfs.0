Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 19C5E7F37
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 19:33:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EE744304032
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 17:32:56 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	8wDWhOzV9MtTNJwA for <xfs@oss.sgi.com>;
	Sun, 29 Sep 2013 17:32:55 -0700 (PDT)
Date: Mon, 30 Sep 2013 10:32:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 2/4] xfs: push down inactive transaction mgmt for
	truncate
Message-ID: <20130930003253.GJ26872@dastard>
References: <1379689572-5543-1-git-send-email-bfoster@redhat.com>
	<1379689572-5543-3-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1379689572-5543-3-git-send-email-bfoster@redhat.com>
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

On Fri, Sep 20, 2013 at 11:06:10AM -0400, Brian Foster wrote:
> Create the new xfs_inactive_truncate() function to handle the
> truncate portion of xfs_inactive(). Push the locking and
> transaction management into the new function.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
