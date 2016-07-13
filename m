Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 786167CA4
	for <xfs@oss.sgi.com>; Wed, 13 Jul 2016 11:16:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E78A2AC002
	for <xfs@oss.sgi.com>; Wed, 13 Jul 2016 09:16:38 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id NC9Yo0wUOkHb7qb7 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 13 Jul 2016 09:16:37 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id E57FFCC063
	for <xfs@oss.sgi.com>; Wed, 13 Jul 2016 16:16:36 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-134.bos.redhat.com [10.18.41.134])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u6DGGacC023082
	for <xfs@oss.sgi.com>; Wed, 13 Jul 2016 12:16:36 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 0/3] serialize unmount against new buffer I/O
Date: Wed, 13 Jul 2016 12:16:32 -0400
Message-Id: <1468426595-35032-1-git-send-email-bfoster@redhat.com>
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

This is a rework of the directory readahead panic fix based on a buffer
I/O count mechanism. See [1] for the original patch and subsequent
discussion leading to the solution as constituted.

This is split into multiple patches simply to break out some refactoring
and special buffer exclusion from the accounting mechanism. This
prevents the original problem (xfs/311) as well as passes an initial
xfstests run.

Brian

[1] http://oss.sgi.com/pipermail/xfs/2016-June/049946.html

Brian Foster (3):
  xfs: helper to set flags on uncached buffer reads
  xfs: exclude never-released buffers from buftarg I/O accounting
  xfs: track and serialize in-flight async buffers against unmount

 fs/xfs/xfs_buf.c   | 177 ++++++++++++++++++++++++++++++++++++++++-------------
 fs/xfs/xfs_buf.h   |   8 +++
 fs/xfs/xfs_log.c   |   4 +-
 fs/xfs/xfs_mount.c |  12 ++--
 4 files changed, 151 insertions(+), 50 deletions(-)

-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
