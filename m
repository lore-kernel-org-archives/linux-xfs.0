Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3D1IfcZ177908 for <xfs@oss.sgi.com>; Mon, 12 Apr 2010 20:18:42 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ACF131269E0B
	for <xfs@oss.sgi.com>; Mon, 12 Apr 2010 18:20:34 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	YiNWwq4XkJ7FQjlr for <xfs@oss.sgi.com>;
	Mon, 12 Apr 2010 18:20:34 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] Context sensitive memory shrinker support
Date: Tue, 13 Apr 2010 10:24:13 +1000
Message-Id: <1271118255-21070-1-git-send-email-david@fromorbit.com>
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
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, xfs@oss.sgi.com

Recently I made the XFS inode reclaim operate entirely in the background for
both clean and dirty inodes as it simplified the code a lot and is somewhat
more efficient. Unfortunately, there are some workloads where the
background reclaim is not freeing memory fast enough, so the reclaim needs an
extra push when memory is low.

The inode caches are per-filesystem on XFS, so to make effective use of the
shrinker callbacks when memory is low, we need a context to be passed through
the shrinker to give us the filesystem context to run the reclaim from. The
two patches introduce the shrinker context and implement the XFS inode reclaim
shrinkers.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
