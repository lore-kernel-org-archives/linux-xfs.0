Return-Path: <SRS0=K1zF=AH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37581C433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Jun 2020 23:08:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B19B20885
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Jun 2020 23:08:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgFZXI6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 Jun 2020 19:08:58 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:58755 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725883AbgFZXI6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Jun 2020 19:08:58 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id E630E1A8BB7;
        Sat, 27 Jun 2020 09:08:54 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1joxSh-0001Ar-Mw; Sat, 27 Jun 2020 09:08:47 +1000
Date:   Sat, 27 Jun 2020 09:08:47 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Mikulas Patocka <mpatocka@redhat.com>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, dm-devel@redhat.com,
        Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/6] Overhaul memalloc_no*
Message-ID: <20200626230847.GI2005@dread.disaster.area>
References: <20200625113122.7540-1-willy@infradead.org>
 <alpine.LRH.2.02.2006261058250.11899@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.2006261058250.11899@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=nTHF0DUjJn0A:10 a=7-415B0cAAAA:8
        a=FVrTFY9nI9_O9HWt5mYA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 26, 2020 at 11:02:19AM -0400, Mikulas Patocka wrote:
> Hi
> 
> I suggest to join memalloc_noio and memalloc_nofs into just one flag that 
> prevents both filesystem recursion and i/o recursion.
> 
> Note that any I/O can recurse into a filesystem via the loop device, thus 
> it doesn't make much sense to have a context where PF_MEMALLOC_NOFS is set 
> and PF_MEMALLOC_NOIO is not set.

Correct me if I'm wrong, but I think that will prevent swapping from
GFP_NOFS memory reclaim contexts. IOWs, this will substantially
change the behaviour of the memory reclaim system under sustained
GFP_NOFS memory pressure. Sustained GFP_NOFS memory pressure is
quite common, so I really don't think we want to telling memory
reclaim "you can't do IO at all" when all we are trying to do is
prevent recursion back into the same filesystem.

Given that the loop device IO path already operates under
memalloc_noio context, (i.e. the recursion restriction is applied in
only the context that needs is) I see no reason for making that a
global reclaim limitation....

In reality, we need to be moving the other way with GFP_NOFS - to
fine grained anti-recursion contexts, not more broad contexts.

That is, GFP_NOFS prevents recursion into any filesystem, not just
the one that we are actively operating on and needing to prevent
recursion back into. We can safely have reclaim do relcaim work on
other filesysetms without fear of recursion deadlocks, but the
memory reclaim infrastructure does not provide that capability.(*)

e.g. if memalloc_nofs_save() took a reclaim context structure that
the filesystem put the superblock, the superblock's nesting depth
(because layering on loop devices can create cross-filesystem
recursion dependencies), and any other filesyetm private data the
fs wanted to add, we could actually have reclaim only avoid reclaim
from filesytsems where there is a deadlock possiblity. e.g:

	- superblock nesting depth is different, apply GFP_NOFS
	  reclaim unconditionally
	- superblock different apply GFP_KERNEL reclaim
	- superblock the same, pass context to filesystem to
	  decide if reclaim from the sueprblock is safe.

At this point, we get memory reclaim able to always be able to
reclaim from filesystems that are not at risk of recursion
deadlocks. Direct reclaim is much more likely to be able to make
progress now because it is much less restricted in what it can
reclaim. That's going to make direct relcaim faster and more
efficient, and taht's the ultimate goal we are aiming to acheive
here...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
