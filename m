Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F23FDC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Jan 2022 23:25:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245447AbiAKXZh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Jan 2022 18:25:37 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:39000 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346804AbiAKXZd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jan 2022 18:25:33 -0500
Received: from dread.disaster.area (pa49-181-243-119.pa.nsw.optusnet.com.au [49.181.243.119])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 9F15010C0BC0;
        Wed, 12 Jan 2022 10:25:31 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1n7QWA-00EBId-35; Wed, 12 Jan 2022 10:25:30 +1100
Date:   Wed, 12 Jan 2022 10:25:30 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix online fsck handling of v5 feature bits on
 secondary supers
Message-ID: <20220111232530.GB3290465@dread.disaster.area>
References: <20220108232203.GU656707@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220108232203.GU656707@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=61de11ec
        a=BEa52nrBdFykVEm6RU8P4g==:117 a=BEa52nrBdFykVEm6RU8P4g==:17
        a=kj9zAlcOel0A:10 a=DghFqjY3_ZEA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=1Axn7BsS3sI0d_-TCuIA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jan 08, 2022 at 03:22:03PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> While I was auditing the code in xfs_repair that adds feature bits to
> existing V5 filesystems, I decided to have a look at how online fsck
> handles feature bits, and I found a few problems:
> 
> 1) ATTR2 is added to the primary super when an xattr is set to a file,
> but that isn't consistently propagated to secondary supers.  This isn't
> a corruption, merely a discrepancy that repair will fix if it ever has
> to restore the primary from a secondary.  Hence, if we find a mismatch
> on a secondary, this is a preen condition, not a corruption.
> 
> 2) There are more compat and ro_compat features now than there used to
> be, but we mask off the newer features from testing.  This means we
> ignore inconsistencies in the INOBTCOUNT and BIGTIME features, which is
> wrong.  Get rid of the masking and compare directly.
> 
> 3) NEEDSREPAIR, when set on a secondary, is ignored by everyone.  Hence
> a mismatch here should also be flagged for preening, and online repair
> should clear the flag.  Right now we ignore it due to (2).
> 
> 4) log_incompat features are ephemeral, since we can clear the feature
> bit as soon as the log no longer contains live records for a particular
> log feature.  As such, the only copy we care about is the one in the
> primary super.  If we find any bits set in the secondary super, we
> should flag that for preening, and clear the bits if the user elects to
> repair it.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

All looks reasonable.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
