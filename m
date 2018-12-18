Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:57714 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726614AbeLRUjV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Dec 2018 15:39:21 -0500
Subject: [PATCH v2 0/6] xfs: ftrace cleanups
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 18 Dec 2018 12:39:15 -0800
Message-ID: <154516555511.31776.9868161112615886200.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, sandeen@sandeen.net

Hi all,

This series fixes symbolic decoding in ftrace tracepoints in xfs, and
introduces decoding of xfs_btnum_t and scrub types.

The first four patches fix some problems with the current ftrace usage
so that symbolic decoding of enum -> string mappings works again, and
fixes function pointer printing.

The two patches after that add symbolic decoding to btree cursor types
and scrub types.

If you're going to start using this mess, you probably ought to just
pull from my git trees.  The kernel patches[1] should apply against
4.20-rc6.  There's little change since the last version except for
improving comments about TRACE_DEFINE_ENUM.

Comments and questions are, as always, welcome.

--D
