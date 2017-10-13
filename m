Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40204 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751138AbdJMStU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Oct 2017 14:49:20 -0400
Date: Fri, 13 Oct 2017 11:49:16 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Question about 67dc288c ("xfs: ensure verifiers are attached to
 recovered buffers")
Message-ID: <20171013184916.GS7122@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>
Cc: Dave Chinner <david@fromorbit.com>

Hi all,

I have a question about 67dc288c ("xfs: ensure verifiers are attached to
recovered buffers").  I was analyzing a scrub failure on generic/392
with a v4 filesystem which stems from xfs_scrub_buffer_recheck (it's in
scrub part 4) being unable to find a b_ops attached to the AGF buffer
and signalling error.

The pattern I observe is that when log recovery runs on a v4 filesystem,
we call some variant of xfs_buf_read with a NULL ops parameter.  The
buffer therefore gets created and read without any verifiers.
Eventually, xlog_recover_validate_buf_type gets called, and on a v5
filesystem we come back and attach verifiers and all is well.  However,
on a v4 filesystem the function returns without doing anything, so the
xfs_buf just sits around in memory with no verifier.  Subsequent
read/log/relse patterns can write anything they want without write
verifiers to check that.

If the v4 fs didn't need log recovery, the buffers get created with
b_ops as you'd expect.

My question is, shouldn't xlog_recover_validate_buf_type unconditionally
set b_ops and save the "if (hascrc)" bits for the part that ensures the
LSN is up to date?

It seems like a bad idea to let buffers sit around with no verifier.
The original patch adding this function is d75afeb3 ("xfs: add buffer
types to directory and attribute buffers") and looks like it was
supposed to do this for any filesystem, but I wasn't around to know the
evolution of that part of xlog.

--D
