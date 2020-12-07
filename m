Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F5DBC0018C
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 14:17:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21244235F8
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 14:17:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbgLGOQk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Dec 2020 09:16:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:44360 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726487AbgLGOQj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Dec 2020 09:16:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607350512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8TwmAW/PzW2J8h9tFgk7ViHAjTZ6OLnQMYBZuuGZ8u4=;
        b=U119oJk3UAr4PYp8dziU4c/rYvZsrUzV9PXvrNdSbsaMbabO5OnqO/uhLUv8pxBp1GiZqU
        i/AS2JRHdzsYsOJj0tiqLTMwZV+u9yE9e+ato7lLw1ooxsAQ2hAUZW/QbPz+i6VmvklIyg
        YW0OI1UT8dhVPOQgVPKcAniVpQDGUq4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-484-88jhV35dOEKyQ0ZF1HxY8A-1; Mon, 07 Dec 2020 09:15:09 -0500
X-MC-Unique: 88jhV35dOEKyQ0ZF1HxY8A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8082ADF8A4;
        Mon,  7 Dec 2020 14:15:07 +0000 (UTC)
Received: from bfoster (ovpn-112-184.rdu2.redhat.com [10.10.112.184])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 05EAC19C45;
        Mon,  7 Dec 2020 14:15:06 +0000 (UTC)
Date:   Mon, 7 Dec 2020 09:15:05 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Alex Lyakas <alex@zadara.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: RCU stall in xfs_reclaim_inodes_ag
Message-ID: <20201207141505.GC1585352@bfoster>
References: <5582F682900B483C89460123ABE79292@alyakaslap>
 <20201116213005.GM7391@dread.disaster.area>
 <6117EC6AA8F04ECA90EAACF20C4A2A7C@alyakaslap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6117EC6AA8F04ECA90EAACF20C4A2A7C@alyakaslap>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Dec 07, 2020 at 12:18:13PM +0200, Alex Lyakas wrote:
> Hi Dave,
> 
> Thank you for your response.
> 
> We did some more investigations on the issue, and we have the following
> findings:
> 
> 1) We tracked the max amount of inodes per AG radix tree. We found in our
> tests, that the max amount of inodes per AG radix tree was about 1.5M:
> [xfs_reclaim_inodes_ag:1285] XFS(dm-79): AG[1368]: count=1384662
> reclaimable=58
> [xfs_reclaim_inodes_ag:1285] XFS(dm-79): AG[1368]: count=1384630
> reclaimable=46
> [xfs_reclaim_inodes_ag:1285] XFS(dm-79): AG[1368]: count=1384600
> reclaimable=16
> [xfs_reclaim_inodes_ag:1285] XFS(dm-79): AG[1370]: count=1594500
> reclaimable=75
> [xfs_reclaim_inodes_ag:1285] XFS(dm-79): AG[1370]: count=1594468
> reclaimable=55
> [xfs_reclaim_inodes_ag:1285] XFS(dm-79): AG[1370]: count=1594436
> reclaimable=46
> [xfs_reclaim_inodes_ag:1285] XFS(dm-79): AG[1370]: count=1594421
> reclaimable=42
> (but the amount of reclaimable inodes is very small, as you can see).
> 
> Do you think this number is reasonable per radix tree?
> 
> 2) This particular XFS instance is total of 500TB. However, the AG size in
> this case is 100GB. This is the AG size that we use, due to issues that we
> reported in https://www.spinics.net/lists/linux-xfs/msg06501.html,
> where the "near" allocation algorithm was stuck for a long time scanning the
> free-space btrees. With smaller AG size, we don't see such issues.
> But with 500TB filesystem, we now have 5000 AGs. As a result, we suspect
> (due to some instrumentation), that the looping over 5000 AGs in
> xfs_reclaim_inodes_ag() is what is causing the RCU stall for us. Although
> the code has cond_resched() call, but somehow the RCU stall still happens,
> and it always happens in this function, while searching the radix tree.
> 

Just a quick bit on the near more allocation algorithm.. the report at
the provided link refers to a v3.18 kernel, which apparently was old
even at the time of the report. Regardless, the allocation algorithm was
reworked in commit dc8e69bd7218 ("xfs: optimize near mode bnobt scans
with concurrent cntbt lookups") to address this kind of problem. That
patch landed in v5.5. It might be worth trying that to see if it allows
you to unroll the AG size mitigation (which seems to have just
transferred the original inefficiency from the allocation code to
management of excessive AG counts)...

Brian

> Thanks,
> Alex.
> 
> 
> 
> -----Original Message----- From: Dave Chinner
> Sent: Monday, November 16, 2020 11:30 PM
> To: Alex Lyakas
> Cc: linux-xfs@vger.kernel.org
> Subject: Re: RCU stall in xfs_reclaim_inodes_ag
> 
> On Mon, Nov 16, 2020 at 07:45:46PM +0200, Alex Lyakas wrote:
> > Greetings XFS community,
> > 
> > We had an RCU stall [1]. According to the code, it happened in
> > radix_tree_gang_lookup_tag():
> > 
> > rcu_read_lock();
> > nr_found = radix_tree_gang_lookup_tag(
> >        &pag->pag_ici_root,
> >        (void **)batch, first_index,
> >        XFS_LOOKUP_BATCH,
> >        XFS_ICI_RECLAIM_TAG);
> > 
> > 
> > This XFS system has over 100M files. So perhaps looping inside the radix
> > tree took too long, and it was happening in RCU read-side critical
> > seciton.
> > This is one of the possible causes for RCU stall.
> 
> Doubt it. According to the trace it was stalled for 60s, and a
> radix tree walk of 100M entries only takes a second or two.
> 
> Further, unless you are using inode32, the inodes will be spread
> across multiple radix trees and that makes the radix trees much
> smaller and even less likely to take this long to run a traversal.
> 
> This could be made a little more efficient by adding a "last index"
> parameter to tell the search where to stop (i.e. if the batch count
> has not yet been reached), but in general that makes little
> difference to the search because the radix tree walk finds the next
> inodes in a few pointer chases...
> 
> > This happened in kernel 4.14.99, but looking at latest mainline code, code
> > is still the same.
> 
> These inode radix trees have been used in XFS since 2008, and this
> is the first time anyone has reported a stall like this, so I'm
> doubtful that there is actually a general bug. My suspicion for such
> a rare occurrence would be memory corruption of some kind or a
> leaked atomic/rcu state in some other code on that CPU....
> 
> > Can anyone please advise how to address that? It is not possible to put
> > cond_resched() inside the radix tree code, because it can be used with
> > spinlocks, and perhaps other contexts where sleeping is not allowed.
> 
> I don't think there is a solution to this problem - it just
> shouldn't happen in when everything is operating normally as it's
> just a tag search on an indexed tree.
> 
> Hence even if there was a hack to stop stall warnings, it won't fix
> whatever problem is leading to the rcu stall. The system will then
> just spin burning CPU, and eventually something else will fail.
> 
> IOWs, unless you can reproduce this stall and find out what is wrong
> in the radix tree that is leading to it looping forever, there's
> likely nothing we can do to avoid this.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

