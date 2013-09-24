Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C1DD97F3F
	for <xfs@oss.sgi.com>; Tue, 24 Sep 2013 18:45:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9367D304043
	for <xfs@oss.sgi.com>; Tue, 24 Sep 2013 16:45:40 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	lfh6qLR4QciFtQgm for <xfs@oss.sgi.com>;
	Tue, 24 Sep 2013 16:45:39 -0700 (PDT)
Date: Wed, 25 Sep 2013 09:45:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: improve xfs_iext_destroy() by freeing extent
	indirection array directly
Message-ID: <20130924234537.GE26872@dastard>
References: <52419C4B.2020603@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52419C4B.2020603@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, Sep 24, 2013 at 10:06:03PM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> To free the incore file extents stores at an indirection array, we
> call the common routine xfs_iext_irec_remove() to remove a record
> from the array one at a time in reverse order, which will resize an
> extent indirection array repeatedly according to the array size.
> 
> This is inefficient for dealing with a file with thousands of incore
> extent records stores at indirection arrays.
> 
> This patch improve this kind of things by freeing the extent records
> from the indirection array directly so that we can get benefits for
> reducing the overhead of alloc/free buffers which is depending on the
> number of extents records.
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
