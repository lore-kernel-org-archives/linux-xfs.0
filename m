Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C7CF229DF8
	for <xfs@oss.sgi.com>; Wed, 26 Feb 2014 19:28:10 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A57298F8054
	for <xfs@oss.sgi.com>; Wed, 26 Feb 2014 17:28:10 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	E1hxkO3C6m5p45Ob for <xfs@oss.sgi.com>;
	Wed, 26 Feb 2014 17:28:09 -0800 (PST)
Date: Thu, 27 Feb 2014 12:27:55 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfs_logprint: Don't error out after split items lose
	context
Message-ID: <20140227012755.GX13647@dastard>
References: <530E8E17.1090901@redhat.com>
 <530E9135.2020807@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <530E9135.2020807@sandeen.net>
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

On Wed, Feb 26, 2014 at 07:13:25PM -0600, Eric Sandeen wrote:
> xfs_logprint recognizes a "left over region from split log item"
> but then expects the *next* op to be a valid start to a new
> item.  The problem is, we can split i.e. an xfs_inode_log_format
> item, skip over it, and then land on the xfs_icdinode_t
> data which follows it - this doesn't have a valid log item
> magic (XFS_LI_*) and we error out.  This results in something
> like:
> 
>   xfs_logprint: unknown log operation type (494e)
> 
> Fix this by recognizing that we've skipped over an item and
> lost the context we're in, so just continue skipping over
> op headers until we find the next valid start to a log item.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good - fixes the problem and does a good job of explaining it.
:)

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
