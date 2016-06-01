Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4ABAF7CA4
	for <xfs@oss.sgi.com>; Wed,  1 Jun 2016 09:45:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1DA72304053
	for <xfs@oss.sgi.com>; Wed,  1 Jun 2016 07:45:05 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id R4zCivwIgtNe3fo2 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 01 Jun 2016 07:45:01 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: iomap infrastructure and multipage writes V5
Date: Wed,  1 Jun 2016 16:44:43 +0200
Message-Id: <1464792297-13185-1-git-send-email-hch@lst.de>
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
Cc: rpeterso@redhat.com, linux-fsdevel@vger.kernel.org

This series add a new file system I/O path that uses the iomap structure
introduced for the pNFS support and support multi-page buffered writes.

This was first started by Dave Chinner a long time ago, then I did beat
it into shape for production runs in a very constrained ARM NAS
enviroment for Tuxera almost as long ago, and now half a dozen rewrites
later it's back.

The basic idea is to avoid the per-block get_blocks overhead
and make use of extents in the buffered write path by iterating over
them instead.

Note that patch 1 conflicts with Vishals dax error handling series.
It would be great to have a stable branch with it so that both the
XFS and nvdimm tree could pull it in before the other changes in this
area.


Changes since V4:
 - rebase to Linux 4.7-rc1
 - fixed an incorrect BUG_ON statement

Changes since V3:
 - fix DAX based zeroing
 - Reviews and trivial fixes from Bob

Changes since V2:
 - fix the range for delalloc punches after failed writes
 - updated some changelogs

Chances since V1:
 - add support for fiemap
 - fix a test fail on 1k block sizes
 - prepare for 64-bit length, this will be used in a follow on patchset

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
