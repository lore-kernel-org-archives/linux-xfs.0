Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 25 Sep 2008 22:20:54 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8Q5KqaE019270
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 22:20:52 -0700
Message-ID: <48DC73AB.4050309@sgi.com>
Date: Fri, 26 Sep 2008 15:31:23 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Running out of reserved data blocks
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

A while back I posted a patch to re-dirty pages on I/O error to handle errors from
xfs_trans_reserve() that was failing with ENOSPC when trying to convert delayed
allocations.  I'm now seeing xfs_trans_reserve() fail when converting unwritten
extents and in that case we silently ignore the error and leave the extent as
unwritten which effectively causes data corruption.  I can also get failures when
trying to unreserve disk space.

I've tried increasing the size of the reserved data blocks pool but that only
delays the inevitable.  Increasing the size to 65536 blocks seems to avoid failures
but that's getting to be a lot of disk space.

All of these ENOSPC errors should be transient and if we retried the operation - or
waited for the reserved pool to refill - we could proceed with the transaction.  I
was thinking about adding a retry loop in xfs_trans_reserve() so if XFS_TRANS_RESERVE
is set and we fail to get space we just keep trying.  It's not very elegant but saves
having to address the ENOSPC failure in many code paths.

Does anyone have any other suggestions?


Lachlan
