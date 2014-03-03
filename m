Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4BD7A7F62
	for <xfs@oss.sgi.com>; Mon,  3 Mar 2014 17:14:10 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B92C7AC004
	for <xfs@oss.sgi.com>; Mon,  3 Mar 2014 15:14:06 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	HmiJjnPKBNgmO6CS for <xfs@oss.sgi.com>;
	Mon, 03 Mar 2014 15:14:01 -0800 (PST)
Date: Tue, 4 Mar 2014 10:09:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V2] xfsprogs: fix use after free in inode_item_done()
Message-ID: <20140303230932.GO13647@dastard>
References: <5314E912.9080708@redhat.com>
 <53150924.2000208@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53150924.2000208@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Mar 03, 2014 at 04:58:44PM -0600, Eric Sandeen wrote:
> Commit "3a19fb7 libxfs: stop caching inode structures"
> introduced a use after free.
> 
> libxfs_iput() already does the check for ip->i_itemp, and a
> kmem_zone_free() if it's present, and then frees the ip pointer.
> Re-checking ip->i_itemp after the libxfs_iput call will access
> the freed ip pointer, as will setting ip_>i_itemp to NULL.
> 
> Simply remove the offending code to fix this up.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> V2: Make it prettier based on Dave's comments.

looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
