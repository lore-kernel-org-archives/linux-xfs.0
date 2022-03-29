Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 615D5C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Mar 2022 03:08:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231463AbiC2DKZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Mar 2022 23:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231468AbiC2DKY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Mar 2022 23:10:24 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9EDC22B24B
        for <linux-xfs@vger.kernel.org>; Mon, 28 Mar 2022 20:08:40 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-43-123.pa.nsw.optusnet.com.au [49.180.43.123])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 1B98410E52D3;
        Tue, 29 Mar 2022 14:08:39 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nZ2Dl-00B8ua-Kp; Tue, 29 Mar 2022 14:08:37 +1100
Date:   Tue, 29 Mar 2022 14:08:37 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: xfs_trans_commit() path must check for log
 shutdown
Message-ID: <20220329030837.GX1544202@dread.disaster.area>
References: <20220324002103.710477-1-david@fromorbit.com>
 <20220324002103.710477-7-david@fromorbit.com>
 <20220329003650.GD27690@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220329003650.GD27690@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62427838
        a=MV6E7+DvwtTitA3W+3A2Lw==:117 a=MV6E7+DvwtTitA3W+3A2Lw==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=7-415B0cAAAA:8 a=mFiqSrmSwyZbHVdORawA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 28, 2022 at 05:36:50PM -0700, Darrick J. Wong wrote:
> On Thu, Mar 24, 2022 at 11:21:03AM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > If a shut races with xfs_trans_commit() and we have shut down the
> > filesystem but not the log, we will still cancel the transaction.
> > This can result in aborting dirty log items instead of committing and
> > pinning them whilst the log is still running. Hence we can end up
> > with dirty, unlogged metadata that isn't in the AIL in memory that
> > can be flushed to disk via writeback clustering.
> 
> ...because we cancelled the transaction, leaving (say) an inode with
> dirty uncommited changes?  And now iflush for an adjacent inode comes
> along and writes it to disk, because we haven't yet told the log to
> stop?  And blammo?

.....

> If the answers are {yes, yes, yes} then yikes and:

Yes: yes, yes, yes and yes, yikes!

> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Thanks!

-Dave.
-- 
Dave Chinner
david@fromorbit.com
