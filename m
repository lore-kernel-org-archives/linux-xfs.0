Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54878 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752863AbdJNLzw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 14 Oct 2017 07:55:52 -0400
Date: Sat, 14 Oct 2017 07:55:51 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Question about 67dc288c ("xfs: ensure verifiers are attached to
 recovered buffers")
Message-ID: <20171014115550.GB50635@bfoster.bfoster>
References: <20171013184916.GS7122@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171013184916.GS7122@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>

On Fri, Oct 13, 2017 at 11:49:16AM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> I have a question about 67dc288c ("xfs: ensure verifiers are attached to
> recovered buffers").  I was analyzing a scrub failure on generic/392
> with a v4 filesystem which stems from xfs_scrub_buffer_recheck (it's in
> scrub part 4) being unable to find a b_ops attached to the AGF buffer
> and signalling error.
> 
> The pattern I observe is that when log recovery runs on a v4 filesystem,
> we call some variant of xfs_buf_read with a NULL ops parameter.  The
> buffer therefore gets created and read without any verifiers.
> Eventually, xlog_recover_validate_buf_type gets called, and on a v5
> filesystem we come back and attach verifiers and all is well.  However,
> on a v4 filesystem the function returns without doing anything, so the
> xfs_buf just sits around in memory with no verifier.  Subsequent
> read/log/relse patterns can write anything they want without write
> verifiers to check that.
> 
> If the v4 fs didn't need log recovery, the buffers get created with
> b_ops as you'd expect.
> 
> My question is, shouldn't xlog_recover_validate_buf_type unconditionally
> set b_ops and save the "if (hascrc)" bits for the part that ensures the
> LSN is up to date?
> 

Seems reasonable, but I notice that the has_crc() check around
_validate_buf_type() comes in sometime after the the original commit
referenced below (d75afeb3) and commit 67dc288c. It appears to be due to
commit 9222a9cf86 ("xfs: don't shutdown log recovery on validation
errors").

IIRC, the problem there is that log recovery had traditionally always
unconditionally replayed everything in the log over whatever resides in
the fs. This actually meant that recovery could transiently corrupt
buffers in certain cases if the target buffer happened to be relogged
more than once and was already up to date, which leads to verification
failures. This was addressed for v5 filesystems with LSN ordering rules,
but the challenge for v4 filesystems was that there is no metadata LSN
and thus no means to detect whether a buffer is already up to date with
regard to a transaction in the log.

Dave might have more historical context to confirm that... If that is
still an open issue, a couple initial ideas come to mind:

1.) Do something simple/crude like reclaim all buffers after log
recovery on v4 filesystems to provide a clean slate going forward.

2.) Unconditionally attach verifiers during recovery as originally done
and wire up something generic that short circuits verifier invocations
on v4 filesystems when log recovery is in progress.

Brian

> It seems like a bad idea to let buffers sit around with no verifier.
> The original patch adding this function is d75afeb3 ("xfs: add buffer
> types to directory and attribute buffers") and looks like it was
> supposed to do this for any filesystem, but I wasn't around to know the
> evolution of that part of xlog.
> 
> --D
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
