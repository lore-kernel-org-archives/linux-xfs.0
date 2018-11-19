Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:6069 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726501AbeKTHnU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Nov 2018 02:43:20 -0500
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/5] iomap: data corruption fixes and more
Date: Tue, 20 Nov 2018 08:17:37 +1100
Message-Id: <20181119211742.8824-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org

Hi folks,

Since clone/dedupe/copy_file_range support was added to fsx, I've
found several data corruptions and issues with these functions. The
patchset addresses some of the issues I've found, including a
problem with the FUA optimisation that I found by inspection when
looking at this code.

Several of the problems stem from do_splice_direct() and how it
behaves on files opened O_DIRECT. I'm pretty sure this has never
been tested on XFS because it just doesn't work and has stale data
exposure problems. And it's so slow it's not funny because it can
only shuffle 16 pages at a time through the splice pipe, which means
synchronous 64k IO for large data movement. do_splice_direct() is a
horrible data copying primitive.

The first 3 patches are data integrity/corruption fixes for the
iomap code, patch 4 increases the do_splice_direct() pipe size to
the maximum allowed without privilege to improve performance, and
the last patch fixes an error reporting inconsistency between
dedeupe and the documented errors in the man page.

Cheers,

Dave.
