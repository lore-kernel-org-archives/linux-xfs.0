Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 61BDC7F4E
	for <xfs@oss.sgi.com>; Wed, 20 Aug 2014 11:56:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4275E8F8039
	for <xfs@oss.sgi.com>; Wed, 20 Aug 2014 09:56:02 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id LSg5kFbROTZ6TYoZ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 20 Aug 2014 09:55:57 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s7KGtv3C020008
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Wed, 20 Aug 2014 12:55:57 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s7KGtuxJ002695
	for <xfs@oss.sgi.com>; Wed, 20 Aug 2014 12:55:57 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 0/2] xfs log recovery delay instrumentation
Date: Wed, 20 Aug 2014 12:55:53 -0400
Message-Id: <1408553755-10255-1-git-send-email-bfoster@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi all,

Here's a couple patches to add the log recovery delay instrumentation
required for reproducing the log recovery buf race problem uncovered by
Alex:

http://oss.sgi.com/archives/xfs/2014-08/msg00155.html

It looked easier to dump this tunable in /proc, but it seems like we
want to move away from adding more things there. This series defines a
generic sys/fs/xfs/debug location to serve a similar purpose and exports
the log recovery delay tunable therein.

The original problem is now easily reproduced with a 10s or so log
recovery delay and the xfstests test I posted the other day:

http://oss.sgi.com/archives/xfs/2014-08/msg00261.html

One thing that comes to mind as I write this is whether it might be a
good idea to only export this debug subdirectory for DEBUG enabled
kernels. Thoughts? Any other thoughts, reviews or flames are appreciated
as well.

Brian

Brian Foster (2):
  xfs: add debug sysfs attribute set
  xfs: export log_recovery_delay to delay mount time log recovery

 fs/xfs/xfs_globals.c     |  4 +++
 fs/xfs/xfs_log_recover.c | 12 ++++++++
 fs/xfs/xfs_super.c       | 15 ++++++++--
 fs/xfs/xfs_sysctl.h      |  5 ++++
 fs/xfs/xfs_sysfs.c       | 71 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_sysfs.h       |  1 +
 6 files changed, 106 insertions(+), 2 deletions(-)

-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
