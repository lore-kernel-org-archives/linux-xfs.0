Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p376GqbJ080957 for <xfs@oss.sgi.com>; Thu, 7 Apr 2011 01:16:53 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C2C543B27FD
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2011 23:20:08 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	XcqkUyeQbFc5hP9X for <xfs@oss.sgi.com>;
	Wed, 06 Apr 2011 23:20:08 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfs: write back inodes during reclaim
Date: Thu,  7 Apr 2011 16:19:54 +1000
Message-Id: <1302157196-1988-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org

This series fixes an OOM problem where VFS-only dirty inodes
accumulate on an XFS filesystem due to atime updates causing OOM to
occur.

The first patch fixes a deadlock triggering bdi-flusher writeback
from memory reclaim when a new bdi-flusher thread needs to be forked
and no memory is available.

the second adds a bdi-flusher kick from XFS's inode cache shrinker
so that when memory is low the VFS starts writing back dirty inodes
so they can be reclaimed as they get cleaned rather than remaining
dirty and pinning the inode cache in memory.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
