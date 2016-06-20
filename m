Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A88AE7CAF
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2016 12:12:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 67FC98F8037
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2016 10:12:07 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 9rIxVUgyCuoR5W3R (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 20 Jun 2016 10:12:06 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id C80332D2F0A
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2016 17:12:05 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-179.bos.redhat.com [10.18.41.179])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u5KHC5UT007093
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2016 13:12:05 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 0/3] xfs: support removal of multi-record inode chunks
Date: Mon, 20 Jun 2016 13:12:01 -0400
Message-Id: <1466442724-13544-1-git-send-email-bfoster@redhat.com>
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

This is an old series I'm dusting off that helps extend XFS' typical
dynamic inode chunk behavior to large block size filesystems. While XFS
currently supports such large block sizes, we don't ever remove inode
records on filesystems with a block size large enough such that a single
block covers more than one inode chunk.

This has been tested on ppc64 with a 64k block size and on other arches
(x86-64, i386) with more standard 4k blocksize configurations.

Brian

v2:
- Rebase to latest for-next.
v1: http://oss.sgi.com/pipermail/xfs/2015-May/041814.html

Brian Foster (3):
  xfs: create helper to delete multiple inobt records
  xfs: remove entire inode chunks when all inodes are free
  xfs: inobt record insert/delete tracepoints

 fs/xfs/libxfs/xfs_ialloc.c | 270 +++++++++++++++++++++++++++++++++++++++++----
 fs/xfs/xfs_trace.h         |  32 ++++++
 2 files changed, 281 insertions(+), 21 deletions(-)

-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
