Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6C0477F3F
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 00:48:44 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3F645304043
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 22:48:44 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	DvI8yLQ8lXO7gMK7 for <xfs@oss.sgi.com>;
	Mon, 10 Feb 2014 22:48:42 -0800 (PST)
Date: Tue, 11 Feb 2014 17:48:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 05/11] xfs: insert newly allocated inode chunks into
	the finobt
Message-ID: <20140211064839.GF13647@dastard>
References: <1391536182-9048-1-git-send-email-bfoster@redhat.com>
	<1391536182-9048-6-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1391536182-9048-6-git-send-email-bfoster@redhat.com>
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

On Tue, Feb 04, 2014 at 12:49:36PM -0500, Brian Foster wrote:
> A newly allocated inode chunk, by definition, has at least one
> free inode, so a record is always inserted into the finobt.
> 
> Create the xfs_inobt_insert() helper from existing code to insert
> a record in an inobt based on the provided BTNUM. Update
> xfs_ialloc_ag_alloc() to invoke the helper for the existing
> XFS_BTNUM_INO tree and XFS_BTNUM_FINO tree, if enabled.
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
