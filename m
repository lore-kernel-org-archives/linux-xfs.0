Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA9A8J7n096649 for <xfs@oss.sgi.com>; Fri, 9 Nov 2012 04:08:19 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	9iV5doGJqkS1Q3Z9 for <xfs@oss.sgi.com>;
	Fri, 09 Nov 2012 02:10:17 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TWlXV-0006UQ-0z
	for xfs@oss.sgi.com; Fri, 09 Nov 2012 21:10:17 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TWlXK-0004SC-Ss
	for xfs@oss.sgi.com; Fri, 09 Nov 2012 21:10:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/4] xfs: fs/xfs/xfs_fs_subr.c die die die
Date: Fri,  9 Nov 2012 21:10:00 +1100
Message-Id: <1352455804-17045-1-git-send-email-david@fromorbit.com>
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

Hi folks,

This patch series replaces all the functions in fs/xfs/xfs_fs_subr.c
with direct calls to their VFS equivalents. This fixes bugs and
removes code at the same time.

I haven't bothered to change the ranges passed to the functions -
that requires a lot more scrutiny and testing - the ranges have now
may not be optimal but they are a known factor. The changes have
passed smoke testing on several different configurations and about 6
hours of continuous fsx testing, which is what I'd expect seeing as
I have changed the ranges at all.

The diffstat is as follows:

 fs/xfs/Makefile       |    1 -
 fs/xfs/xfs_aops.c     |    2 +-
 fs/xfs/xfs_bmap.c     |    2 +-
 fs/xfs/xfs_dfrag.c    |   13 +++----
 fs/xfs/xfs_file.c     |   23 ++++++------
 fs/xfs/xfs_fs_subr.c  |   96 ---------------------------------------------------
 fs/xfs/xfs_iops.c     |    4 +--
 fs/xfs/xfs_vnodeops.c |   46 +++++++++++++++++-------
 fs/xfs/xfs_vnodeops.h |    7 ----
 9 files changed, 54 insertions(+), 140 deletions(-)

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
