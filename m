Return-Path: <SRS0=aNSJ=7F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33EA1C433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 23 May 2020 22:42:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AE8820874
	for <linux-xfs@archiver.kernel.org>; Sat, 23 May 2020 22:42:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388080AbgEWWmN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 23 May 2020 18:42:13 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:60353 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727827AbgEWWmN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 23 May 2020 18:42:13 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 8C4E6D794D2;
        Sun, 24 May 2020 08:42:09 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jccqG-0000rt-2o; Sun, 24 May 2020 08:42:08 +1000
Date:   Sun, 24 May 2020 08:42:08 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 17/24] xfs: remove SYNC_TRYLOCK from inode reclaim
Message-ID: <20200523224208.GK2040@dread.disaster.area>
References: <20200522035029.3022405-1-david@fromorbit.com>
 <20200522035029.3022405-18-david@fromorbit.com>
 <20200522231435.GU8230@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522231435.GU8230@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=FB1yGp_n2KoexmV_UccA:9 a=CjuIK1q_8ugA:10 a=igBNqPyMv6gA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 22, 2020 at 04:14:35PM -0700, Darrick J. Wong wrote:
> On Fri, May 22, 2020 at 01:50:22PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > All background reclaim is SYNC_TRYLOCK already, and even blocking
> > reclaim (SYNC_WAIT) can use trylock mechanisms as
> > xfs_reclaim_inodes_ag() will keep cycling until there are no more
> > reclaimable inodes. Hence we can kill SYNC_TRYLOCK from inode
> > reclaim and make everything unconditionally non-blocking.
> 
> Random question: Does xfs_quiesce_attr need to call xfs_reclaim_inodes
> twice now, or does the second SYNC_WAIT call suffice now?

I have another patch that drops it completely from
xfs_quiesce_attr() because it is largely unnecessary. That got
tangled up in a fixing other bugs in the patchset, so I dropped it
to get this out the door rather than have to rewrite the patch
-again-.

Essentially, xfs_quiesce_attr() used inode reclaim to flush dirty
inodes that the VFS didn't know about before we froze the
filesystem. It's a historical artifact that dates back to before we
logged every change to inodes, as AIL pushing couldn't clean
unlogged inode changes.  We don't actually need to reclaim inodes
here now that xfs_log_quiesce() pushes the AIL and waits for all
metadata writeback to complete.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
