Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F431C4338F
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 00:14:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 761B060F6B
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 00:14:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233013AbhG1AOV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 20:14:21 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:47063 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232840AbhG1AOU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 20:14:20 -0400
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id EF12C866471;
        Wed, 28 Jul 2021 10:14:17 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m8XDE-00BYvZ-NP; Wed, 28 Jul 2021 10:14:16 +1000
Date:   Wed, 28 Jul 2021 10:14:16 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: prevent spoofing of rtbitmap blocks when recovering
 buffers
Message-ID: <20210728001416.GZ664593@dread.disaster.area>
References: <20210727235641.GA559212@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727235641.GA559212@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
        a=kj9zAlcOel0A:10 a=e_q4qTt1xDgA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=INUbKBrS-Noq345VPZ0A:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 27, 2021 at 04:56:41PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> While reviewing the buffer item recovery code, the thought occurred to
> me: in V5 filesystems we use log sequence number (LSN) tracking to avoid
> replaying older metadata updates against newer log items.  However, we
> use the magic number of the ondisk buffer to find the LSN of the ondisk
> metadata, which means that if an attacker can control the layout of the
> realtime device precisely enough that the start of an rt bitmap block
> matches the magic and UUID of some other kind of block, they can control
> the purported LSN of that spoofed block and thereby break log replay.
> 
> Since realtime bitmap and summary blocks don't have headers at all, we
> have no way to tell if a block really should be replayed.  The best we
> can do is replay unconditionally and hope for the best.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_buf_item_recover.c |   14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)

Looks good now.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
