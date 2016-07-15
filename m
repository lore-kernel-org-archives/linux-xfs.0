Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A87697CA6
	for <xfs@oss.sgi.com>; Fri, 15 Jul 2016 13:35:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7BE59304051
	for <xfs@oss.sgi.com>; Fri, 15 Jul 2016 11:35:37 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id MmuKURDHufZDSk08 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 15 Jul 2016 11:35:36 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 04AC3D6847
	for <xfs@oss.sgi.com>; Fri, 15 Jul 2016 18:35:36 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-121.bos.redhat.com [10.18.41.121])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u6FIZZvB029249
	for <xfs@oss.sgi.com>; Fri, 15 Jul 2016 14:35:35 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 0/2] serialize unmount against new buffer I/O
Date: Fri, 15 Jul 2016 14:35:32 -0400
Message-Id: <1468607734-3174-1-git-send-email-bfoster@redhat.com>
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

v2:
- Drop patch 1. Use existing flags argument to set NO_IOACCT and fold
  into patch 2.
- Clear IN_FLIGHT status on marking a buffer stale.
- Add IN_FLIGHT to tracepoint flags string list.
v1: http://oss.sgi.com/pipermail/xfs/2016-July/050148.html

Brian Foster (2):
  xfs: exclude never-released buffers from buftarg I/O accounting
  xfs: track and serialize in-flight async buffers against unmount

 fs/xfs/xfs_buf.c   | 168 +++++++++++++++++++++++++++++++++++++++--------------
 fs/xfs/xfs_buf.h   |   7 ++-
 fs/xfs/xfs_log.c   |   5 +-
 fs/xfs/xfs_mount.c |  10 ++--
 4 files changed, 141 insertions(+), 49 deletions(-)

-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
