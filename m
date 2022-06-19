Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAB9EC433EF
	for <linux-xfs@archiver.kernel.org>; Sun, 19 Jun 2022 23:52:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236300AbiFSXwu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 19 Jun 2022 19:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231539AbiFSXwu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 19 Jun 2022 19:52:50 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B69FCA197
        for <linux-xfs@vger.kernel.org>; Sun, 19 Jun 2022 16:52:48 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 9C8435ECA90;
        Mon, 20 Jun 2022 09:52:47 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o34ik-008he8-F8; Mon, 20 Jun 2022 09:52:46 +1000
Date:   Mon, 20 Jun 2022 09:52:46 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        chandan.babu@oracle.com
Subject: Re: [PATCH 1/3] xfs: fix TOCTOU race involving the new logged xattrs
 control knob
Message-ID: <20220619235246.GL227878@dread.disaster.area>
References: <165463578282.417102.208108580175553342.stgit@magnolia>
 <165463578858.417102.15324992106006793982.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165463578858.417102.15324992106006793982.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62afb6cf
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=JPEYwPQDsx4A:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=UNvkAAU_w3NyrChNlTAA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 07, 2022 at 02:03:08PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> I found a race involving the larp control knob, aka the debugging knob
> that lets developers enable logging of extended attribute updates:
> 
> Thread 1			Thread 2
> 
> echo 0 > /sys/fs/xfs/debug/larp
> 				setxattr(REPLACE)
> 				xfs_has_larp (returns false)
> 				xfs_attr_set
> 
> echo 1 > /sys/fs/xfs/debug/larp
> 
> 				xfs_attr_defer_replace
> 				xfs_attr_init_replace_state
> 				xfs_has_larp (returns true)
> 				xfs_attr_init_remove_state
> 
> 				<oops, wrong DAS state!>
> 
> This isn't a particularly severe problem right now because xattr logging
> is only enabled when CONFIG_XFS_DEBUG=y, and developers *should* know
> what they're doing.
> 
> However, the eventual intent is that callers should be able to ask for
> the assistance of the log in persisting xattr updates.  This capability
> might not be required for /all/ callers, which means that dynamic
> control must work correctly.  Once an xattr update has decided whether
> or not to use logged xattrs, it needs to stay in that mode until the end
> of the operation regardless of what subsequent parallel operations might
> do.
> 
> Therefore, it is an error to continue sampling xfs_globals.larp once
> xfs_attr_change has made a decision about larp, and it was not correct
> for me to have told Allison that ->create_intent functions can sample
> the global log incompat feature bitfield to decide to elide a log item.
> 
> Instead, create a new op flag for the xfs_da_args structure, and convert
> all other callers of xfs_has_larp and xfs_sb_version_haslogxattrs within
> the attr update state machine to look for the operations flag.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks fine now.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
