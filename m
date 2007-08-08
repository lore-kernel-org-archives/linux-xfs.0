Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 08 Aug 2007 16:07:17 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l78N78bm009951
	for <xfs@oss.sgi.com>; Wed, 8 Aug 2007 16:07:12 -0700
Date: Thu, 9 Aug 2007 09:07:07 +1000
From: David Chinner <dgc@sgi.com>
Subject: [PATCH 0 of 4] Radix tree based inode caching
Message-ID: <20070808230706.GO12413810@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

One of the perpetual scaling problems XFS has is indexing
it's incore inodes. We currently uses hashes and the default
hash sizes chosen can only ever be a tradeoff between memory
consumption and the maximum realistic size of the cache.

As a result, anyone who has millions of inodes cached on a
filesystem needs to tunes the size of the cache via the ihashsize
mount option to allow decent scalability with inode cache
operations.

A further problem is the separate inode cluster hash, whose size is
based on the ihashsize but is smaller, and so under certain
conditions (sparse cluster cache population) this can become
a limitation long before the inode hash is causing issues.

The following patchset removes the inode hash and cluster hash
and replaces them with radix trees to avoid the scalability
limitations of the hashes. It also reduces the size of the
inodes by 3 pointers....

-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
