Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3B8F57F3F
	for <xfs@oss.sgi.com>; Wed, 10 Sep 2014 08:20:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2A7178F8049
	for <xfs@oss.sgi.com>; Wed, 10 Sep 2014 06:20:34 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id dlzHwzyg3drpMDqF (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 10 Sep 2014 06:20:33 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s8ADKWDw030987
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Wed, 10 Sep 2014 09:20:32 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s8ADKWga009670
	for <xfs@oss.sgi.com>; Wed, 10 Sep 2014 09:20:32 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 0/5] clean up collapse range and handle post-eof delalloc
Date: Wed, 10 Sep 2014 09:20:26 -0400
Message-Id: <1410355231-50495-1-git-send-email-bfoster@redhat.com>
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

Here's v2 of the collapse clean up. We refactor a bit more via the
insertion of patch 3, otherwise it's similar to v1. This will see some
continued testing, but it survived ~500m fsx operations overnight.

Brian

v2:
- Rename helpers to xfs_bmse_*() scheme.
- Rearrange logic and minor cleanups to xfs_bmse[_can]_merge().
- Inserted patch 3 to further refactor xfs_bmap_shift_extents() into
  xfs_bmse_shift_one().
- Return corruption error rather than BUG_ON() in patch 4 and detect
  error in new helper.
v1: http://oss.sgi.com/archives/xfs/2014-09/msg00061.html
- Retain the eofblocks trim and writeback/inval. the range of shifted
  data only.
- Added the xfs_free_file_space() patch to no longer writeback the
  entire file.
rfc: http://oss.sgi.com/archives/xfs/2014-08/msg00462.html

Brian Foster (5):
  xfs: track collapse via file offset rather than extent index
  xfs: refactor shift-by-merge into xfs_bmse_merge() helper
  xfs: refactor single extent shift into xfs_bmse_shift_one() helper
  xfs: writeback and inval. file range to be shifted by collapse
  xfs: only writeback and truncate pages for the freed range

 fs/xfs/libxfs/xfs_bmap.c | 365 +++++++++++++++++++++++++++++++----------------
 fs/xfs/libxfs/xfs_bmap.h |   7 +-
 fs/xfs/xfs_bmap_util.c   |  54 ++++---
 3 files changed, 275 insertions(+), 151 deletions(-)

-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
