Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 76D497F50
	for <xfs@oss.sgi.com>; Sun,  7 Sep 2014 07:26:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 63A128F8059
	for <xfs@oss.sgi.com>; Sun,  7 Sep 2014 05:26:06 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ZUGku0XNVBL4UNvt (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 07 Sep 2014 05:26:02 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s87CQ1Jh013228
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Sun, 7 Sep 2014 08:26:01 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s87CQ1vk029364
	for <xfs@oss.sgi.com>; Sun, 7 Sep 2014 08:26:01 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 0/4] clean up collapse range and handle post-eof delalloc
Date: Sun,  7 Sep 2014 08:25:56 -0400
Message-Id: <1410092760-3451-1-git-send-email-bfoster@redhat.com>
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

Here's a new drop of the patches that tweak collapse to be fsb based and
organize the code a bit. This has seen ~1.5b fsx ops without a failure
and some light xfstests testing so far.

The primary difference from this version and the rfc is the retention of
the eofblocks trim prior to collapse. Patch 4 is also new. It isolates
the pagecache writeback/truncate in xfs_free_file_space() to the range
affected by the free. Thoughts, reviews, flames appreciated.

Brian

v1:
- Retain the eofblocks trim and writeback/inval. the range of shifted
  data only.
- Added the xfs_free_file_space() patch to no longer writeback the
  entire file.
rfc: http://oss.sgi.com/archives/xfs/2014-08/msg00462.html

Brian Foster (4):
  xfs: track collapse via file offset rather than extent index
  xfs: refactor xfs_bmap_shift_extents() into multiple functions
  xfs: writeback and inval. file range to be shifted by collapse
  xfs: only writeback and truncate pages for the freed range

 fs/xfs/libxfs/xfs_bmap.c | 294 +++++++++++++++++++++++++++++++----------------
 fs/xfs/libxfs/xfs_bmap.h |   7 +-
 fs/xfs/xfs_bmap_util.c   |  54 +++++----
 3 files changed, 230 insertions(+), 125 deletions(-)

-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
