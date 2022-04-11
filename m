Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AC24C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Apr 2022 01:26:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232600AbiDKB3H (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 Apr 2022 21:29:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbiDKB3H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Apr 2022 21:29:07 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5CC042D1C9
        for <linux-xfs@vger.kernel.org>; Sun, 10 Apr 2022 18:26:55 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-233-190.pa.vic.optusnet.com.au [49.186.233.190])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 6B7E053BC20;
        Mon, 11 Apr 2022 11:26:54 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ndipR-00GFQY-67; Mon, 11 Apr 2022 11:26:53 +1000
Date:   Mon, 11 Apr 2022 11:26:53 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: use a separate frextents counter for rt extent
 reservations
Message-ID: <20220411012653.GS1544202@dread.disaster.area>
References: <164961485474.70555.18228016043917319266.stgit@magnolia>
 <164961487162.70555.13624412630554454462.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164961487162.70555.13624412630554454462.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=625383de
        a=bHAvQTfMiaNt/bo4vVGwyA==:117 a=bHAvQTfMiaNt/bo4vVGwyA==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=AYytZR2idZ_oQYENMx0A:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Apr 10, 2022 at 11:21:11AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> As mentioned in the previous commit, the kernel misuses sb_frextents in
> the incore mount to reflect both incore reservations made by running
> transactions as well as the actual count of free rt extents on disk.
> This results in the superblock being written to the log with an
> underestimate of the number of rt extents that are marked free in the
> rtbitmap.
> 
> Teaching XFS to recompute frextents after log recovery avoids
> operational problems in the current mount, but it doesn't solve the
> problem of us writing undercounted frextents which are then recovered by
> an older kernel that doesn't have that fix.
> 
> Create an incore percpu counter to mirror the ondisk frextents.  This
> new counter will track transaction reservations and the only time we
> will touch the incore super counter (i.e the one that gets logged) is
> when those transactions commit updates to the rt bitmap.  This is in
> contrast to the lazysbcount counters (e.g. fdblocks), where we know that
> log recovery will always fix any incorrect counter that we log.
> As a bonus, we only take m_sb_lock at transaction commit time.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good - much neater than th first version and I really like the
way you did the xfs_mod_freecounter() factoring.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
