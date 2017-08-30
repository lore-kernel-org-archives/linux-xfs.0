Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:24755 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751205AbdH3Xou (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Aug 2017 19:44:50 -0400
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1dnCf9-0004LW-OC
        for linux-xfs@vger.kernel.org; Thu, 31 Aug 2017 09:44:47 +1000
Date: Thu, 31 Aug 2017 09:44:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 36/42] mkfs: factor AG alignment
Message-ID: <20170830234447.GF17782@dastard>
References: <20170829235052.21050-1-david@fromorbit.com>
 <20170829235052.21050-37-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170829235052.21050-37-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On Wed, Aug 30, 2017 at 09:50:46AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
....

This patch needs this delta fix, otherwise large filesystems will be
configured wrongly.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com


agcount wrong when at full 1TB sized AGs:
$ sudo ~/packages/mkfs.xfs -f -d size=4t,file,name=/mnt/test/foo
Default configuration sourced from package build definitions
meta-data=/mnt/test/foo          isize=512    agcount=5, agsize=268435455 blks

---
 mkfs/xfs_mkfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index bec12d473099..21394a1ae946 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2707,7 +2707,7 @@ align_ag_geometry(
 	int		dsunit = cfg->dsunit;
 
 	if (!dsunit)
-		return;
+		goto validate;
 
 	/*
 	 * agsize is not a multiple of dsunit
@@ -2791,6 +2791,7 @@ an AG size that is one stripe unit smaller or larger, for example %llu.\n"),
 				(cfg->dblocks % cfg->agsize != 0);
 	}
 
+validate:
 	/*
 	 * If the last AG is too small, reduce the filesystem size
 	 * and drop the blocks.
@@ -2803,7 +2804,6 @@ an AG size that is one stripe unit smaller or larger, for example %llu.\n"),
 		ASSERT(cfg->agcount != 0);
 	}
 
-validate:
 	validate_ag_geometry(cfg->blocklog, cfg->dblocks,
 			     cfg->agsize, cfg->agcount);
 }
