Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 02FA17F4E
	for <xfs@oss.sgi.com>; Thu, 28 May 2015 15:17:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D77B28F807A
	for <xfs@oss.sgi.com>; Thu, 28 May 2015 13:16:59 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id cO0KLn9hKGPA3vut (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 28 May 2015 13:16:59 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id 4B2C9365078
	for <xfs@oss.sgi.com>; Thu, 28 May 2015 20:16:58 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t4SKGvlj007060
	for <xfs@oss.sgi.com>; Thu, 28 May 2015 16:16:58 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 0/3] xfs: support removal of multi-record inode chunks
Date: Thu, 28 May 2015 16:16:53 -0400
Message-Id: <1432844216-5820-1-git-send-email-bfoster@redhat.com>
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

I had recently started prototyping a mechanism to do inode preallocation
and deferred removal and one of my goals for that work was to also
handle the existing problem where inode chunks are never removed on
filesystems with large block sizes. While hashing the prealloc work out,
it became apparent that the large block size problem could stand on its
own. 

The problem is that for fs' where the number of inodes per block is
larger than 64 (e.g., -bsize=64k -isize=512b), a single inode chunk
requires more than one inobt record. For such fs', we don't currently
have enough context on inode removal to determine whether records other
than those for the particular inode can be removed. As such, inode
chunks are never freed. This series aims to provide enough context so
that inode records can be removed once the entire chunk is free.

Patch 1 introduces a new multi-record deletion helper but does not
change existing behavior. Patch 2 is the bulk of the enhancement. In a
nutshell, it provides a mechanism to determine whether an inode chunk
that spans one or more inobt records is completely free and to remove
the entire chunk if so. Patch 3 introduces some inobt record management
tracepoints.

So far this has seen medium testing on ppc64 with various block sizes up
to 64k (single and multiple inobt record per chunk configurations).
Thoughts, reviews, flames appreciated.

Brian

P.S., Note that this series applies on top of the sparse inode series.

Brian Foster (3):
  xfs: create helper to delete multiple inobt records
  xfs: remove entire inode chunks when all inodes are free
  xfs: inobt record insert/delete tracepoints

 fs/xfs/libxfs/xfs_ialloc.c | 270 +++++++++++++++++++++++++++++++++++++++++----
 fs/xfs/xfs_trace.h         |  32 ++++++
 2 files changed, 281 insertions(+), 21 deletions(-)

-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
