Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7115F7F3F
	for <xfs@oss.sgi.com>; Tue, 14 Oct 2014 16:59:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F174EAC013
	for <xfs@oss.sgi.com>; Tue, 14 Oct 2014 14:59:19 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id SxBohGwDwLvNaxr8 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 14 Oct 2014 14:59:18 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s9ELxHQl019374
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Tue, 14 Oct 2014 17:59:17 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s9ELxHWv017884
	for <xfs@oss.sgi.com>; Tue, 14 Oct 2014 17:59:17 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 0/2] fix up indlen reservations on extent split
Date: Tue, 14 Oct 2014 17:59:13 -0400
Message-Id: <1413323955-19976-1-git-send-email-bfoster@redhat.com>
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

Here's a couple patches to fix up the indirect block reservation
problem when splitting delalloc extents, described in more detail in the
patch 2 commit log.

This runs through xfstests without any explosions and quiets down
generic/033 when used in combination with the zero range rework (current
for-next includes the writeback on zero range workaround that also
prevents generic/033 asserts).

Brian

v1:
- xfs_bunmapi() code into independent patch.
- Refactor fix into separate helper function.
rfc: http://oss.sgi.com/archives/xfs/2014-09/msg00337.html

Brian Foster (2):
  xfs: update icsb freeblocks counter after extent deletion
  xfs: borrow indirect blocks from freed extent when available

 fs/xfs/libxfs/xfs_bmap.c | 159 ++++++++++++++++++++++++++++++++++-------------
 1 file changed, 116 insertions(+), 43 deletions(-)

-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
