Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A44E0C4338F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 21:52:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8482C60F9D
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 21:52:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233056AbhGZVL6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Jul 2021 17:11:58 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:51080 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231959AbhGZVLz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Jul 2021 17:11:55 -0400
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id A953C1045A4F;
        Tue, 27 Jul 2021 07:52:21 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m88WL-00B8vi-46; Tue, 27 Jul 2021 07:52:21 +1000
Date:   Tue, 27 Jul 2021 07:52:21 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/10] xfs: Enforce attr3 buffer recovery order
Message-ID: <20210726215221.GT664593@dread.disaster.area>
References: <20210726060716.3295008-1-david@fromorbit.com>
 <20210726060716.3295008-10-david@fromorbit.com>
 <20210726175701.GY559212@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726175701.GY559212@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
        a=kj9zAlcOel0A:10 a=e_q4qTt1xDgA:10 a=7-415B0cAAAA:8
        a=TKx9lbWQu-ixmEMxBA8A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 26, 2021 at 10:57:01AM -0700, Darrick J. Wong wrote:
> On Mon, Jul 26, 2021 at 04:07:15PM +1000, Dave Chinner wrote:
> > IOWs, attr3 leaf buffers fall through the magic number checks
> > unrecognised, so trigger the "recover immediately" behaviour instead
> > of undergoing an LSN check. IOWs, we incorrectly replay ATTR3 leaf
> > buffers and that causes silent on disk corruption of inode attribute
> > forks and potentially other things....
> > 
> > Git history shows this is *another* zero day bug, this time
> > introduced in commit 50d5c8d8e938 ("xfs: check LSN ordering for v5
> > superblocks during recovery") which failed to handle the attr3 leaf
> > buffers in recovery. And we've failed to handle them ever since...
> 
> I wonder, what happens if we happen to have a rt bitmap block where a
> sparse allocation pattern at the start of the rt device just happens to
> match one of these magic numbers + fs UUID?  Does that imply that log
> recovery can be tricked into forgetting to replay rtbitmap blocks?

Possibly. RT bitmap/summary buffers are marked by type in the
xfs_buf_log_format type field so log recovery can recognise these
and do the right thing with them. So it really comes down to whether
log recovery handles XFS_BLFT_RTBITMAP_BUF types differently to any
other buffers. Which, without looking at the code, I doubt it does,
so there's probably fixes needed there, too...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
