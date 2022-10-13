Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C225C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Oct 2022 22:26:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbiJMW0G (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Oct 2022 18:26:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiJMW0F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Oct 2022 18:26:05 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E750F6B65F
        for <linux-xfs@vger.kernel.org>; Thu, 13 Oct 2022 15:25:59 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au [49.181.106.210])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 185068ADB6E;
        Fri, 14 Oct 2022 09:25:56 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oj6eH-001eKF-VJ; Fri, 14 Oct 2022 09:25:54 +1100
Date:   Fri, 14 Oct 2022 09:25:53 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: set the buffer type after holding the AG[IF]
 across trans_roll
Message-ID: <20221013222553.GY3600936@dread.disaster.area>
References: <166473478844.1083155.9238102682926048449.stgit@magnolia>
 <166473478893.1083155.2555785331844801316.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166473478893.1083155.2555785331844801316.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=63489075
        a=j6JUzzrSC7wlfFge/rmVbg==:117 a=j6JUzzrSC7wlfFge/rmVbg==:17
        a=kj9zAlcOel0A:10 a=Qawa6l4ZSaYA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=04XgA2NmIhUV1GchVF0A:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Oct 02, 2022 at 11:19:48AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Currently, the only way to lock an allocation group is to hold the AGI
> and AGF buffers.  If repair needs to roll the transaction while
> repairing some AG metadata, it maintains that lock by holding the two
> buffers across the transaction roll and joins them afterwards.
> 
> However, repair is not the same as the other parts of XFS that employ
> this bhold/bjoin sequence, because it's possible that the AGI or AGF
> buffers are not actually dirty before the roll.  In this case, the
> buffer log item can detach from the buffer, which means that we have to

Doesn't this imply we have a reference counting problem with
XFS_BLI_HOLD buffers? i.e. the bli can only get detached when the
reference count on it goes to zero. If the buffer is clean and
joined to a transaction, then that means the only reference to the
BLI is the current transaction. Hence the only way it can get
detached is for the transaction commit to release the current
transaction's reference to the BLI.

Ah, XFS_BLI_HOLD does not take a reference to the BLI - it just
prevents ->iop_release from releasing the -buffer- after it drops
the transaction reference to the BLI. That's the problem right there
- xfs_buf_item_release() drops the current trans ref to the clean
item via xfs_buf_item_release() regardless of whether BLI_HOLD is
set or not, hence freeing the BLI on clean buffers.

IOWs, it looks to me like XFS_BLI_HOLD should actually hold a
reference to the BLI as well as the buffer so that we don't free the
BLI for a held clean buffer in xfs_buf_item_release(). The reference
we leave behind will then be picked up by the subsequent call to
xfs_trans_bjoin() which finds the clean BLI already attached to the
buffer...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
