Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DB07C433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 22:18:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EF142085B
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 22:18:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726235AbgGAWSn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 18:18:43 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:47314 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725771AbgGAWSn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 18:18:43 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 2D1E01A9FA6;
        Thu,  2 Jul 2020 08:18:40 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jql3v-0000gU-O3; Thu, 02 Jul 2020 08:18:39 +1000
Date:   Thu, 2 Jul 2020 08:18:39 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: track unlinked inodes in core inode
Message-ID: <20200701221839.GW2005@dread.disaster.area>
References: <20200623095015.1934171-1-david@fromorbit.com>
 <20200623095015.1934171-4-david@fromorbit.com>
 <20200701143121.GB1087@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200701143121.GB1087@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=euhQDdvNJW1EMnAY0uEA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 01, 2020 at 10:31:21AM -0400, Brian Foster wrote:
> On Tue, Jun 23, 2020 at 07:50:14PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Currently we cache unlinked inode list backrefs through a separate
> > cache which has to be maintained via memory allocation and a hash
> > table. When the inode is on the unlinked list, we have an existence
> > guarantee for the inode in memory.
> > 
> > That is, if the inode is on the unlinked list, there must be a
> > reference to the inode from the core VFS because dropping the last
> > reference to the inode causes it to be removed from the unlinked
> > list. Hence if we hold the AGI locked, we guarantee that any inode
> > on the unlinked list is pinned in memory. That means we can actually
> > track the entire unlinked list on the inode itself and use
> > unreferenced inode cache lookups to update the list pointers as
> > needed.
> > 
> > However, we don't use this relationship because log recovery has
> > no in memory state and so has to work directly from buffers.
> > However, because unlink recovery only removes from the head of the
> > list, we can easily fake this in memory state as the inode we read
> > in from the AGI bucket has a pointer to the next inode. Hence we can
> > play reference leapfrog in the recovery loop always reading the
> > second inode on the list and updating pointers before dropping the
> > reference to the first inode. Hence the in-memory state is always
> > valid for recovery, too.
> > 
> > This means we can tear out the old inode unlinked list cache and
> > update mechanisms and replace it with a much simpler "insert" and
> > "remove" functions that use in-memory inode state rather than on
> > buffer state to track the list. The diffstat speaks for itself.
> > 
> > Food for thought: This obliviates the need for the on-disk AGI
> > unlinked hash - we because we track as a double linked list in
> > memory, we don't need to keep hash chains on disk short to minimise
> > previous inode lookup overhead on list removal. Hence we probably
> > should just convert the unlinked list code to use a single list
> > on disk...
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> 
> Looks interesting, but are you planning to break this up into smaller
> pieces? E.g., perhaps add the new inode pointers and set them in one
> patch, then replace the whole backref thing with the in-core pointers,
> then update the insert/remove, then log recovery, etc.

Likely, yes.

> I'm sure there's
> various ways it can or cannot be split, but regardless this patch looks
> like it could be a series in and of itself.

This RFC series is largely centered around this single patch, so
splitting it out into a separate series makes no sense.

FWIW, This is basically the same sort of thing that the inode
flushing patchset started out as - a single patch that I wrote in
few hours and got working as a whole. It does need to be split up,
but given that the inode flushing rework took several months to turn
a few hours of coding into a mergable patchset, I haven't bothered
to do that for this patch set yet.

I'd kinda like to avoid having this explode into 30 patches as that
previous patchset did - this is a very self-contained change, so
there's really only 4-5 pieces it can be split up into. Trying to
split it more finely than that is going to make it quite hard to
find clean places to split it...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
