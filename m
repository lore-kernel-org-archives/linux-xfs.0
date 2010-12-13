Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBD1LvNv147874 for <xfs@oss.sgi.com>; Sun, 12 Dec 2010 19:21:57 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3B0481CBC2F5
	for <xfs@oss.sgi.com>; Sun, 12 Dec 2010 17:23:48 -0800 (PST)
Received: from mail.internode.on.net (bld-mail20.adl6.internode.on.net
	[150.101.137.105]) by cuda.sgi.com with ESMTP id
	g3kgvHDXRNQCwYvA for <xfs@oss.sgi.com>;
	Sun, 12 Dec 2010 17:23:48 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/3] Use generic percpu counters in XFS V2
Date: Mon, 13 Dec 2010 12:21:50 +1100
Message-Id: <1292203313-15570-1-git-send-email-david@fromorbit.com>
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
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl

This series replaces the XFS per-cpu superblock counters with
generic per-cpu counters. It adds a specialised operation to the
generic counter implementation and then switches the XFS percpu
superblock counters over to use the generic percpu counter
implementation. The result is several hundred lines of complex code
removed from XFS.

Version 2:
- use wrappers for percpu_counter_add_unless_lt() to allow custom
  batch sizes to be used.
- removed xfs_icsb_*() wrappers from percpu counters.
- cleaned up split of xfs_icsb_modify_counters().

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
