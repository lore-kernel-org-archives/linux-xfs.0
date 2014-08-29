Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C2E517FCD
	for <xfs@oss.sgi.com>; Fri, 29 Aug 2014 15:29:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B1AA630406B
	for <xfs@oss.sgi.com>; Fri, 29 Aug 2014 13:29:44 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id BVyjX0vYkTOqr2D9 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 29 Aug 2014 13:29:40 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s7TKTekr013508
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Fri, 29 Aug 2014 16:29:40 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s7TKTdvs010221
	for <xfs@oss.sgi.com>; Fri, 29 Aug 2014 16:29:39 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [RFC PATCH 0/4] clean up collapse range and handle post-eof delalloc
Date: Fri, 29 Aug 2014 16:29:34 -0400
Message-Id: <1409344178-44817-1-git-send-email-bfoster@redhat.com>
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

Here's a drop of what I'm testing over the weekend. It passes some quick
tests, but only lightly tested so far.

My biggest question at this point is whether there is any risk to the
shift of the post-eof extent if the subsequent truncate happens to fail.
If it's not worth dealing with that, we could just drop patch 3 and
leave the eofblocks trim permanently.

In fact, it might even be a good idea to go back to the original
[start,-1] writeback in collapse range given that the free file space
helper could change at some point to only write and punch out the range
being freed... and then we're left shifting a bunch of extents after the
freed range that could have dirty data in pagecache, which sounds bad.
Thoughts?

Brian

Brian Foster (4):
  xfs: track collapse via file offset rather than extent index
  xfs: refactor xfs_bmap_shift_extents() into multiple functions
  xfs: allow collapse to handle delalloc extents
  xfs: remove file writeback and eofblocks trim from collapse range

 fs/xfs/libxfs/xfs_bmap.c | 302 ++++++++++++++++++++++++++++++++---------------
 fs/xfs/libxfs/xfs_bmap.h |   7 +-
 fs/xfs/xfs_bmap_util.c   |  32 +----
 3 files changed, 214 insertions(+), 127 deletions(-)

-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
