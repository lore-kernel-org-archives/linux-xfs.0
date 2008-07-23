Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jul 2008 15:42:59 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6NMguOR030812
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 15:42:56 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8885116130FF
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 15:44:06 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id yfRfcIo33paSOh3U for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 15:44:06 -0700 (PDT)
Date: Thu, 24 Jul 2008 08:43:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Syncing up libxfs to kernel source
Message-ID: <20080723224359.GN6761@disturbed>
References: <op.ueqitmgv3jf8g2@pc-bnaujok.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.ueqitmgv3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Wed, Jul 23, 2008 at 05:52:24PM +1000, Barry Naujok wrote:
> This one is mainly for Dave...
>
> In xfs_alloc_read_agf() in xfs_alloc.c, the current user-space version
> checks:
>
> agf_ok = ...
> 	be32_to_cpu(agf->agf_btreeblks) <= be32_to_cpu(agf->agf_length) &&
> 	...
>
> but the kernel version doesn't.
>
> Is this an oversight with the lazy-counter code in the kernel, remove from
> user-space or leave them different?

Oversight in the kernel code. Patch below.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com


Check that the number of AGF btree blocks is within a sane bound
when reading the AGF. Noticed by Barry Naujok.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_alloc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index 1956f83..a85bf20 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -2185,6 +2185,7 @@ xfs_alloc_read_agf(
 		be32_to_cpu(agf->agf_magicnum) == XFS_AGF_MAGIC &&
 		XFS_AGF_GOOD_VERSION(be32_to_cpu(agf->agf_versionnum)) &&
 		be32_to_cpu(agf->agf_freeblks) <= be32_to_cpu(agf->agf_length) &&
+		be32_to_cpu(agf->agf_btreeblks) <= be32_to_cpu(agf->agf_length) &&
 		be32_to_cpu(agf->agf_flfirst) < XFS_AGFL_SIZE(mp) &&
 		be32_to_cpu(agf->agf_fllast) < XFS_AGFL_SIZE(mp) &&
 		be32_to_cpu(agf->agf_flcount) <= XFS_AGFL_SIZE(mp);
