Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 611DAE732F7
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Sep 2023 17:01:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231285AbjI1RBC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Sep 2023 13:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231778AbjI1RBC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Sep 2023 13:01:02 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 358CA99
        for <linux-xfs@vger.kernel.org>; Thu, 28 Sep 2023 10:01:01 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC147C433C8;
        Thu, 28 Sep 2023 17:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695920460;
        bh=C7Lfadnpr4n/YntpxUQDdf4XmNjZ7fNE5sRm0zDNvFY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QXqrf05/YemuCVQaUTnm8J6NaDm025y/UMz3wu1hKTPeJuvl67Ztkdf0rD+87x9XP
         VAAEKBZ6lQx+esQjALVdj6pZIiNXIy7eQQZgCjKNHGEr49dXjsvFooMztnPM+oTDU8
         k8W8kPxkcVt2Cx3ak4UwL+NDjTwqCBGalztKgqtL+IkF07RyKNA0683wlvD7BQnOg2
         twq8BueJZK+7NtYSAPBC3O5lEs4a9KNXfK5RQ77XJJMPL5bIGcIp8VZXNJY3mvEMHZ
         I/9GeIUMVn/dRgnWwLvjzZjl4XzhcVI3VaKN8YS13H5dbu+k+wk+ZDwjRYGH9HNi2m
         iGDBOnW0XJUSA==
Date:   Thu, 28 Sep 2023 10:01:00 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: make xchk_iget safer in the presence of corrupt
 inode btrees
Message-ID: <20230928170100.GI11439@frogsfrogsfrogs>
References: <169577058799.3312834.4066903607681044261.stgit@frogsfrogsfrogs>
 <169577058815.3312834.1762190757505617356.stgit@frogsfrogsfrogs>
 <ZRUVL2okuLfNC6U1@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZRUVL2okuLfNC6U1@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 28, 2023 at 03:54:55PM +1000, Dave Chinner wrote:
> On Tue, Sep 26, 2023 at 04:31:07PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > When scrub is trying to iget na inode, ensure that it won't end up
> > deadlocked on a cycle in the inode btree by using an empty transaction
> > to store all the buffers.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/scrub/common.c |    6 ++++--
> >  fs/xfs/scrub/common.h |   19 +++++++++++++++++++
> >  fs/xfs/scrub/inode.c  |    4 ++--
> >  3 files changed, 25 insertions(+), 4 deletions(-)
> 
> Looks reasonable.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> Further question on loops in btrees because I can't remember if this
> case is handled: if the loop goes round and round the same level,
> how is that detected? i.e. how do we avoid recursion count overflows
> if we keep walking over the same sibling block pattern?

I think regular btree walks are partially vulnerable to loops in a btree
level.  A while back, you patched the self-referential case of a block
that points back to itself, but there isn't any robust checking of
loops such as:

A -> B -> A

Loops involving blocks from multiple levels are caught by checking
whether the btree block level matches what we were expecting given the
direction of travel.

AFAICT nobody's systematically fixed the problem for btree users that
don't attach a transaction to the cursor.  Without a transaction there's
no central place to collect locked buffers, so the buffer cache will try
to re-lock a buffer that the caller already locked.  We've partially
fixed this for GETFSMAP, but I think we're still missing that when
reading the bmbt into memory and for looking things up in dir/attr
btrees.

Scrub, however, protects itself from loops in the btree structure.  The
tree walking in scrub/btree.c finds sibling blocks by looking at the
next pointer in the parent level.  Each block's sibling pointers are
easily checked, so it'll notice things like:

     A
 /   |    \
B -> C -+  D
^-------+

When we load C, xchk_btree_block_check_sibling will notice that
C.rightsib doesn't point at D.  It'll set the CORRUPT flag, and return
from the btree walk.

Scrub will also notice corruption like:
     A
 /   |   \
B    C    B

by computing the keyspace covered by the records in each block and
compares that to corresponding key in the parent.  It also checks that
the records of each level are in increasing order.  Just in case B and
C are both filled with the same record.

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
