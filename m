Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAS0vqd9117388 for <xfs@oss.sgi.com>; Tue, 27 Nov 2012 18:57:52 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	6BWYc8E2NjMD1GRn for <xfs@oss.sgi.com>;
	Tue, 27 Nov 2012 17:00:07 -0800 (PST)
Date: Wed, 28 Nov 2012 12:00:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [xfs:for-next 72/74] fs/xfs/xfs_log.c:1709:32: sparse: incorrect
	type in assignment (different base types)
Message-ID: <20121128010005.GQ6434@dastard>
References: <50b45f45.SLR36oqX9vHupAe2%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50b45f45.SLR36oqX9vHupAe2%fengguang.wu@intel.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: kbuild test robot <fengguang.wu@intel.com>
Cc: Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>

On Tue, Nov 27, 2012 at 02:35:49PM +0800, kbuild test robot wrote:
> tree:   git://oss.sgi.com/xfs/xfs for-next
> head:   7c4cebe8e02dd0b0e655605442bbe9268db9ed4f
> commit: 0e446be44806240c779666591bb9e8cb0e86a50d [72/74] xfs: add CRC checks to the log
> 
> 
> sparse warnings:
> 
> + fs/xfs/xfs_log.c:1709:32: sparse: incorrect type in assignment (different base types)
> fs/xfs/xfs_log.c:1709:32:    expected restricted __le32 [usertype] h_crc
> fs/xfs/xfs_log.c:1709:32:    got restricted __be32
> + fs/xfs/xfs_log.c:1568:29: sparse: incorrect type in return expression (different base types)
> fs/xfs/xfs_log.c:1568:29:    expected restricted __be32
> fs/xfs/xfs_log.c:1568:29:    got restricted __le32
> fs/xfs/xfs_log.c:267:17: sparse: context imbalance in 'xlog_grant_head_wait' - unexpected unlock
> --
> + fs/xfs/xfs_log_recover.c:3239:13: sparse: restricted __be32 degrades to integer
> + fs/xfs/xfs_log_recover.c:3239:25: sparse: restricted __le32 degrades to integer
> + fs/xfs/xfs_log_recover.c:3243:41: sparse: cast to restricted __be32
> + fs/xfs/xfs_log_recover.c:3243:41: sparse: cast from restricted __le32
> + fs/xfs/xfs_log_recover.c:3243:41: sparse: cast to restricted __be32
> + fs/xfs/xfs_log_recover.c:3243:41: sparse: cast from restricted __le32
> + fs/xfs/xfs_log_recover.c:3243:41: sparse: cast to restricted __be32
> + fs/xfs/xfs_log_recover.c:3243:41: sparse: cast from restricted __le32
> + fs/xfs/xfs_log_recover.c:3243:41: sparse: cast to restricted __be32
> + fs/xfs/xfs_log_recover.c:3243:41: sparse: cast from restricted __le32
> + fs/xfs/xfs_log_recover.c:3243:41: sparse: cast to restricted __be32
> + fs/xfs/xfs_log_recover.c:3243:41: sparse: cast from restricted __le32
> + fs/xfs/xfs_log_recover.c:3243:41: sparse: cast to restricted __be32
> + fs/xfs/xfs_log_recover.c:3243:41: sparse: cast from restricted __le32

Hmmm, why wasn't my sparse runs picking this up?

/me upgrades sparse from current git

Oh, look, they show up now. I'll get them fixed.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
