Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3EACB7FDF
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 03:45:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 27BE0304032
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 01:45:37 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	RH2m2RAuyhQZOtx4 for <xfs@oss.sgi.com>;
	Tue, 06 May 2014 01:45:36 -0700 (PDT)
Date: Tue, 6 May 2014 18:45:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/5] xfs: don't need dirv2 checks anymore
Message-ID: <20140506084505.GG5421@dastard>
References: <1399348559-19889-1-git-send-email-david@fromorbit.com>
	<1399348559-19889-5-git-send-email-david@fromorbit.com>
	<20140506081652.GC24143@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140506081652.GC24143@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Tue, May 06, 2014 at 01:16:52AM -0700, Christoph Hellwig wrote:
> > -	ASSERT(xfs_sb_version_hasdirv2(&mp->m_sb));
> > +	ASSERT(mp->m_sb.sb_versionnum & XFS_SB_VERSION_DIRV2BIT);
> 
> How is this going to work for v5 filesystems?  Probably better to just
> kill the assert..

mkfs still sets the sb_features bitmask for all the supported v4
features it uses by default on v5 superblocks. There are some
feature bits in the v4 mask that are optional for v5 superblocks,
too (e.g. case insensitivity, sunit/swidth alignment), so we won't
ever stop setting the XFS_SB_VERSION_DIRV2BIT on v5 superblocks...

> Otherwise looks good,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
