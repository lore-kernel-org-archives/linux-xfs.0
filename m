Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BDCD47F5A
	for <xfs@oss.sgi.com>; Tue,  2 Sep 2014 09:08:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5D426AC004
	for <xfs@oss.sgi.com>; Tue,  2 Sep 2014 07:08:19 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 3GprteEyIBxb6u9z (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Sep 2014 07:08:18 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s82E8GCj027856
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Tue, 2 Sep 2014 10:08:17 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s82E8GRX001634
	for <xfs@oss.sgi.com>; Tue, 2 Sep 2014 10:08:16 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 0/2] xfs log recovery delay instrumentation
Date: Tue,  2 Sep 2014 10:08:13 -0400
Message-Id: <1409666895-49799-1-git-send-email-bfoster@redhat.com>
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

Here's v2 of the log recovery delay instrumentation set. v1 is available
here:

http://oss.sgi.com/archives/xfs/2014-08/msg00276.html

After a brief conversation with Dave, we thought it best to tie in this
functionality with DEBUG mode to express/ensure that these attributes
are for debugging/hacking purposes only. Everything else should be
equivalent to v1.

Brian

v2:
- Enable /sys/fs/xfs/debug for DEBUG mode kernels only.
v1: http://oss.sgi.com/archives/xfs/2014-08/msg00276.html

Brian Foster (2):
  xfs: add debug sysfs attribute set
  xfs: export log_recovery_delay to delay mount time log recovery

 fs/xfs/xfs_globals.c     |  4 +++
 fs/xfs/xfs_log_recover.c | 12 ++++++++
 fs/xfs/xfs_super.c       | 23 +++++++++++++--
 fs/xfs/xfs_sysctl.h      |  5 ++++
 fs/xfs/xfs_sysfs.c       | 74 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_sysfs.h       |  1 +
 6 files changed, 117 insertions(+), 2 deletions(-)

-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
