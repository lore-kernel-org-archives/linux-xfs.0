Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7212C7F77
	for <xfs@oss.sgi.com>; Fri,  8 Aug 2014 13:49:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 51B74304032
	for <xfs@oss.sgi.com>; Fri,  8 Aug 2014 11:49:34 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id KsdcCZlK7IC8N2R8 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 08 Aug 2014 11:49:29 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s78InR3o017678
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Fri, 8 Aug 2014 14:49:28 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s78InRZU019225
	for <xfs@oss.sgi.com>; Fri, 8 Aug 2014 14:49:27 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 0/2] xfs: for-next file collapse bug fixes
Date: Fri,  8 Aug 2014 14:49:24 -0400
Message-Id: <1407523766-62233-1-git-send-email-bfoster@redhat.com>
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

I've seen collapse range fall over during some recent stress testing.
I'm running fsx and 16 fsstress threads in parallel to reproduce. Note
that the fsstress workload doesn't need to be on the same fs (I suspect
a sync() is a trigger). These patches are what has fallen out so far...

The first patch stems from the fact that the error caused an fs shutdown
that appeared to be unnecessary. I was initially going to skip the inode
log on any error, but on closer inspection it seems like we expect to
abort/shutdown if something has in fact been changed, so this modifies
the code to reduce that shutdown window. The second patch deals with the
actual collapse failure by fixing up the locking.

Note that I still reproduced at least one collapse failure even with
these fixes, so there could be more at play here with the
implementation:

XFS: Internal error XFS_WANT_CORRUPTED_GOTO at line 5535 of file fs/xfs/libxfs/xfs_bmap.c.  Caller xfs_collapse_file_space+0x1af/0x280 [xfs]

This took significantly longer to reproduce and I don't yet have a feel
for how reproducible it is in general. In the meantime, these two seemed
relatively straightforward and incremental...

Brian

Brian Foster (2):
  xfs: don't log inode unless extent shift makes extent modifications
  xfs: hole the inode lock across a full file collapse

 fs/xfs/libxfs/xfs_bmap.c | 18 ++++++++++--------
 fs/xfs/xfs_bmap_util.c   |  5 +++--
 2 files changed, 13 insertions(+), 10 deletions(-)

-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
