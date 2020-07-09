Return-Path: <SRS0=XuOj=AU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9392BC433DF
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 22:38:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DAEA206A5
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 22:38:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726615AbgGIWiJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Jul 2020 18:38:09 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:38032 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726228AbgGIWiI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Jul 2020 18:38:08 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 6C2C3D7B967;
        Fri, 10 Jul 2020 08:38:03 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jtfB4-0000y8-Kh; Fri, 10 Jul 2020 08:38:02 +1000
Date:   Fri, 10 Jul 2020 08:38:02 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Waiman Long <longman@redhat.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Qian Cai <cai@lca.pw>, Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH v6] xfs: Fix false positive lockdep warning with
 sb_internal & fs_reclaim
Message-ID: <20200709223802.GY2005@dread.disaster.area>
References: <20200707191629.13911-1-longman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200707191629.13911-1-longman@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=7-415B0cAAAA:8 a=20KFwNOVAAAA:8
        a=l721tooEcPd6T4aNpT4A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 07, 2020 at 03:16:29PM -0400, Waiman Long wrote:
> One way to avoid this splat is to add GFP_NOFS to the affected allocation
> calls by using the memalloc_nofs_save()/memalloc_nofs_restore() pair.
> This shouldn't matter unless the system is really running out of memory.
> In that particular case, the filesystem freeze operation may fail while
> it was succeeding previously.
> 
> Without this patch, the command sequence below will show that the lock
> dependency chain sb_internal -> fs_reclaim exists.
> 
>  # fsfreeze -f /home
>  # fsfreeze --unfreeze /home
>  # grep -i fs_reclaim -C 3 /proc/lockdep_chains | grep -C 5 sb_internal
> 
> After applying the patch, such sb_internal -> fs_reclaim lock dependency
> chain can no longer be found. Because of that, the locking dependency
> warning will not be shown.
> 
> Suggested-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Waiman Long <longman@redhat.com>

Looks good. Thanks for working through this, Waiman.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
