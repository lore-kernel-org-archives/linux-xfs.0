Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BB5CD7F52
	for <xfs@oss.sgi.com>; Thu, 24 Apr 2014 00:27:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 44000AC007
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2014 22:27:42 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Mjyselrq4GczF79E for <xfs@oss.sgi.com>;
	Wed, 23 Apr 2014 22:27:29 -0700 (PDT)
Date: Thu, 24 Apr 2014 15:27:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v5 03/11] xfs: support the XFS_BTNUM_FINOBT free inode
	btree type
Message-ID: <20140424052722.GZ15995@dastard>
References: <1397146116-42546-1-git-send-email-bfoster@redhat.com>
	<1397146116-42546-4-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1397146116-42546-4-git-send-email-bfoster@redhat.com>
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

On Thu, Apr 10, 2014 at 12:08:28PM -0400, Brian Foster wrote:
> Define the AGI fields for the finobt root/level and add magic
> numbers. Update the btree code to add support for the new
> XFS_BTNUM_FINOBT inode btree.
> 
> The finobt root block is reserved immediately following the inobt
> root block in the AG. Update XFS_PREALLOC_BLOCKS() to determine the
> starting AG data block based on whether finobt support is enabled.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

FWIW, xfstests doesn't give us particularly good coverage of all
the finobt operations:

$ $ grep fibt /proc/fs/xfs/stat 
fibt2 43617 50359 338 336 0 0 0 0 0 0 0 0 0 0 136

So perhaps we want to look at improving that over time.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
