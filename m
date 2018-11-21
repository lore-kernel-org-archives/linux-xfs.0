Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:7031 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390411AbeKVJgc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Nov 2018 04:36:32 -0500
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1gPbTV-0003nh-E1
        for linux-xfs@vger.kernel.org; Thu, 22 Nov 2018 10:00:01 +1100
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1gPbTV-0008FG-Al
        for linux-xfs@vger.kernel.org; Thu, 22 Nov 2018 10:00:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/3] xfs: enums don't work with __print_symbolic
Date: Thu, 22 Nov 2018 09:59:55 +1100
Message-Id: <20181121225958.30947-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi folks,

When trying to read traces from fsx failurs, I kept coming across
fields in the traces that had no output what-so-ever. The common
theme was that they all were tables that were parsed by
__print_symbolic() and the value definitions were enums.

Unfortunately, __print_symbolic() does some crazy stuff involving
stringification of the table that is passed to it, which means
the enums are turned into strings and so their never get treated as
enums after pre-processing. The result is a format string that looks
like:

# cat /sys/kernel/debug/tracing/events/xfs/xfs_iomap_alloc/format
.....
print fmt: ..... __print_symbolic(REC->type, { XFS_IO_INVALID, "invalid" }, { XFS_IO_DELALLOC, "delalloc" }, { XFS_IO_UNWRITTEN, "unwritten" }, { XFS_IO_OVERWRITE, "overwrite" }, { XFS_IO_COW, "CoW" }, { XFS_IO_HOLE, "hole" }), ....
#

And, well, XFS_IO_OVERWRITE is a string, not an integer value of 3.
Hence __print_symbolic never prints out the correct value.

The way to fix this is to turn all the enums into defined macros,
that way the preprocessor still substitutes the value for the
stringified table as the it does string matches. The result is:

__print_symbolic(REC->type, { 0, "hole" }, { 1, "delalloc" }, { 2, "unwritten" }, { 3, "overwrite" }, { 4, "CoW" })

And the trace events now print the type correctly in the trace.

This series fixes the cases I noticed by removing the various enums
that end up in trace format tables.

Cheers,

Dave.
