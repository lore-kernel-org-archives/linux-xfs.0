Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3K2egtc256122 for <xfs@oss.sgi.com>; Mon, 19 Apr 2010 21:40:42 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6EF3310398D6
	for <xfs@oss.sgi.com>; Mon, 19 Apr 2010 19:42:39 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	q1bGG1ydIYSJQN0P for <xfs@oss.sgi.com>;
	Mon, 19 Apr 2010 19:42:39 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/4] writeback: tracing and wbc->nr_to_write fixes
Date: Tue, 20 Apr 2010 12:41:50 +1000
Message-Id: <1271731314-5893-1-git-send-email-david@fromorbit.com>
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
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

This series contains the initial writeback tracing patches from
Jens, as well as the extensions I added to provide visibility into
writeback control structures as the are used by the writeback code.
The visibility given is sufficient to understand what is happening
in the writeback path - what path is writing data, what path is
blocking on congestion, etc, and to determine the differences in
behaviour for different sync modes and calling contexts. This
tracing really needs to be integrated into mainline so that anyone
can improve the tracing as they use it to track down problems
in our convoluted writeback paths.

The remaining patches are fixes to problems that the new tracing
highlighted.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
