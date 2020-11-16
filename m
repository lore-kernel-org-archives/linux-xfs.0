Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E4D4C6379D
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Nov 2020 21:30:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C324A20DD4
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Nov 2020 21:30:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726357AbgKPVaN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Nov 2020 16:30:13 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:44197 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726035AbgKPVaM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Nov 2020 16:30:12 -0500
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 98FB53CC6EC;
        Tue, 17 Nov 2020 08:30:06 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kem4b-00Bsu7-ER; Tue, 17 Nov 2020 08:30:05 +1100
Date:   Tue, 17 Nov 2020 08:30:05 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Alex Lyakas <alex@zadara.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: RCU stall in xfs_reclaim_inodes_ag
Message-ID: <20201116213005.GM7391@dread.disaster.area>
References: <5582F682900B483C89460123ABE79292@alyakaslap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5582F682900B483C89460123ABE79292@alyakaslap>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=nNwsprhYR40A:10 a=7-415B0cAAAA:8
        a=TYRcA6hzCu4B8dq9IVIA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 16, 2020 at 07:45:46PM +0200, Alex Lyakas wrote:
> Greetings XFS community,
> 
> We had an RCU stall [1]. According to the code, it happened in
> radix_tree_gang_lookup_tag():
> 
> rcu_read_lock();
> nr_found = radix_tree_gang_lookup_tag(
>        &pag->pag_ici_root,
>        (void **)batch, first_index,
>        XFS_LOOKUP_BATCH,
>        XFS_ICI_RECLAIM_TAG);
> 
> 
> This XFS system has over 100M files. So perhaps looping inside the radix
> tree took too long, and it was happening in RCU read-side critical seciton.
> This is one of the possible causes for RCU stall.

Doubt it. According to the trace it was stalled for 60s, and a
radix tree walk of 100M entries only takes a second or two.

Further, unless you are using inode32, the inodes will be spread
across multiple radix trees and that makes the radix trees much
smaller and even less likely to take this long to run a traversal.

This could be made a little more efficient by adding a "last index"
parameter to tell the search where to stop (i.e. if the batch count
has not yet been reached), but in general that makes little
difference to the search because the radix tree walk finds the next
inodes in a few pointer chases...

> This happened in kernel 4.14.99, but looking at latest mainline code, code
> is still the same.

These inode radix trees have been used in XFS since 2008, and this
is the first time anyone has reported a stall like this, so I'm
doubtful that there is actually a general bug. My suspicion for such
a rare occurrence would be memory corruption of some kind or a
leaked atomic/rcu state in some other code on that CPU....

> Can anyone please advise how to address that? It is not possible to put
> cond_resched() inside the radix tree code, because it can be used with
> spinlocks, and perhaps other contexts where sleeping is not allowed.

I don't think there is a solution to this problem - it just
shouldn't happen in when everything is operating normally as it's
just a tag search on an indexed tree.

Hence even if there was a hack to stop stall warnings, it won't fix
whatever problem is leading to the rcu stall. The system will then
just spin burning CPU, and eventually something else will fail.

IOWs, unless you can reproduce this stall and find out what is wrong
in the radix tree that is leading to it looping forever, there's
likely nothing we can do to avoid this.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
