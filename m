Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0BCA17CA0
	for <xfs@oss.sgi.com>; Tue,  5 Apr 2016 16:55:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DA272304048
	for <xfs@oss.sgi.com>; Tue,  5 Apr 2016 14:55:12 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	IE065d0Rao0uXOz1 for <xfs@oss.sgi.com>;
	Tue, 05 Apr 2016 14:55:10 -0700 (PDT)
Date: Wed, 6 Apr 2016 07:55:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: support RCU lookups for inline symlinks
Message-ID: <20160405215508.GH11238@dastard>
References: <1458740935-31260-1-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1458740935-31260-1-git-send-email-hch@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Wed, Mar 23, 2016 at 02:48:51PM +0100, Christoph Hellwig wrote:
> Return the inline link body in the inode to support RCU mode lookups.

The series doesn't appear to cause any regressions and the code
looks good, so I've added the missing xfs_setup_iops() call in
xfs_rename_alloc_whiteout() (patch 2), and converted dentry->d_inode
to d_inode(dentry) in patch 3 for consistency withe the rest of the
code and committed this series.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
