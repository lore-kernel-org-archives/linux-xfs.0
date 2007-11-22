Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 21 Nov 2007 16:31:07 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAM0UwIQ010129
	for <xfs@oss.sgi.com>; Wed, 21 Nov 2007 16:31:03 -0800
Date: Thu, 22 Nov 2007 11:31:00 +1100
From: David Chinner <dgc@sgi.com>
Subject: [PATCH 0/9]: Various XFS inode clustering improvements
Message-ID: <20071122003100.GF114266761@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>
Cc: lkml <linux-kernel@vger.kernel.org>


Normally I wouldn't bother cc'ing lkml on XFS changes, however a
couple of these patches touch generic code. The changes to generic
code are introducing a WRITE_META bio type and
radix_tree_gang_lookup_range() and hence the wider ditribution.
This patch set is against the current xfs-dev tree so bits of
it may not apply to current mainline.

Overall, the patch set is focussed on improving the XFS inode
cache and clustering code. It reduces memory usage of the
cache by 5-10% and improves performance on some workloads
by 10-15%.

Comments welcome.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
