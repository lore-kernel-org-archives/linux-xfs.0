Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1EC837F53
	for <xfs@oss.sgi.com>; Tue,  2 Jul 2013 05:30:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EB5A68F80D1
	for <xfs@oss.sgi.com>; Tue,  2 Jul 2013 03:30:50 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	yLCuUgigEvzz4YB1 for <xfs@oss.sgi.com>;
	Tue, 02 Jul 2013 03:30:49 -0700 (PDT)
Date: Tue, 2 Jul 2013 20:30:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: clean up unused codes at xfs_bulkstat()
Message-ID: <20130702103046.GD14996@dastard>
References: <51D18964.2030708@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51D18964.2030708@oracle.com>
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

On Mon, Jul 01, 2013 at 09:51:32PM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> There are some unused codes at xfs_bulkstat():
> 
> - Variable bp is defined to point to the on-disk inode cluster
>   buffer, but it proved to be of no practical help.
> 
> - We process the chunks of good inodes which were fetched by iterating
>   btree records from an AG.  When processing inodes from each chunk,
>   the code recomputing agbno if run into the first inode of a cluster,
>   however, the agbno is not being used thereafter.
> 
> This patch tries to clean up those things.
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
