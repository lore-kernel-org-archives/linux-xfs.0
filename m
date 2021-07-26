Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 658EFC432BE
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 22:34:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4668660F6C
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 22:34:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233643AbhGZVyF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Jul 2021 17:54:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:58130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232876AbhGZVyE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Jul 2021 17:54:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0667060F58;
        Mon, 26 Jul 2021 22:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627338873;
        bh=KJgOQ5/38jNECQmXUAcN/EXM7LvaLOqtbOaIWil4FjY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RvHggZZmdrUsOnzCYp9CcmAXeAR+PJVSPS9Yb7huwgVKDQGnsw8tcOlpUs3zUmmLh
         PqhYOW1vTHDkN90ZIu9gfT/aT2veo2HteqFCg6crAqp7ZTivSdBvvVDeknbg4dwvjv
         T7xt7/E1yS/0iZg9LblcEhPdC5ybTw44qvm+8xxJ51RqrEyD3oHc7Hx9hi/Qeo7qxV
         yXAqAbjiB8RLLH1ZAtk00PaUU2B9DMcpEP+AzcWFSj5ae9N8Ux11FyDI+MlmVi7nNr
         YcrzUBqYz9719nY58nwMawnCo4PGI5uAbH9xslJZBrEESrFr9TOnvyFFBmH7LTQ0iL
         f1RcqUGFF17QQ==
Date:   Mon, 26 Jul 2021 15:34:32 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/10] xfs: Enforce attr3 buffer recovery order
Message-ID: <20210726223432.GD559212@magnolia>
References: <20210726060716.3295008-1-david@fromorbit.com>
 <20210726060716.3295008-10-david@fromorbit.com>
 <20210726175701.GY559212@magnolia>
 <20210726215221.GT664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726215221.GT664593@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 27, 2021 at 07:52:21AM +1000, Dave Chinner wrote:
> On Mon, Jul 26, 2021 at 10:57:01AM -0700, Darrick J. Wong wrote:
> > On Mon, Jul 26, 2021 at 04:07:15PM +1000, Dave Chinner wrote:
> > > IOWs, attr3 leaf buffers fall through the magic number checks
> > > unrecognised, so trigger the "recover immediately" behaviour instead
> > > of undergoing an LSN check. IOWs, we incorrectly replay ATTR3 leaf
> > > buffers and that causes silent on disk corruption of inode attribute
> > > forks and potentially other things....
> > > 
> > > Git history shows this is *another* zero day bug, this time
> > > introduced in commit 50d5c8d8e938 ("xfs: check LSN ordering for v5
> > > superblocks during recovery") which failed to handle the attr3 leaf
> > > buffers in recovery. And we've failed to handle them ever since...
> > 
> > I wonder, what happens if we happen to have a rt bitmap block where a
> > sparse allocation pattern at the start of the rt device just happens to
> > match one of these magic numbers + fs UUID?  Does that imply that log
> > recovery can be tricked into forgetting to replay rtbitmap blocks?
> 
> Possibly. RT bitmap/summary buffers are marked by type in the
> xfs_buf_log_format type field so log recovery can recognise these
> and do the right thing with them. So it really comes down to whether
> log recovery handles XFS_BLFT_RTBITMAP_BUF types differently to any
> other buffers. Which, without looking at the code, I doubt it does,
> so there's probably fixes needed there, too...

It handles them the same as every other buffer, which is to say that I
think we've found another recovery zeroday.

xlog_recover_buf_commit_pass2 reads the ondisk buffer, and then calls
xlog_recover_get_buf_lsn to fish the LSN out of the ondisk buffer.  That
second function doesn't corroborate the ondisk magic with the XFS_BLFT_*
flags recovered from the buffer item, so if the log item was for an rt
bitmap block and the user controls the rt layout as I describe above,
they can totally screw up log recovery.

Only after we return a garbage LSN do we call xlog_recover_do_reg_buffer
-> xlog_recover_validate_buf_type and look at the buf_f flags to attach
verifier ops, but by then it's too late to undo the damage.

I think the answer is to combine the two functions so that we check the
BLFT and the ondisk magic.  If they match, we can set b_ops and return
the ondisk LSN and then decide if we're really going to replay the bli
contents.  If they don't match, I guess we recover the whole bli?  Or
abort?  I'll try to get to that after $meetings.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
