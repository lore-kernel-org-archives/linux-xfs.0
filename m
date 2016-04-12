Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DA38F7CA0
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 15:53:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AB384304066
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 13:53:24 -0700 (PDT)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id PTLSCIQNZxIMuFMW (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Apr 2016 13:53:21 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: iomap infrastructure and multipage writes V2
Date: Tue, 12 Apr 2016 13:52:54 -0700
Message-Id: <1460494382-14547-1-git-send-email-hch@lst.de>
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

The basic idea is to avoid the crazy per-block get_blocks overhead
and make use of extents in the buffered write path by iterating over
them instead.

Chances since V1:
 - add support for fiemap
 - fix a test fail on 1k block sizes
 - prepare for 64-bit length, this will be used in a follow on patchset

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
