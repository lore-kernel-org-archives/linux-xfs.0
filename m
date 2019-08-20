Return-Path: <SRS0=kQBn=WQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C33C1C3A589
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 10:51:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E1C3206DF
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 10:51:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729341AbfHTKvF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Aug 2019 06:51:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43942 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728842AbfHTKvF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Aug 2019 06:51:05 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4284711A2F;
        Tue, 20 Aug 2019 10:51:04 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4A49727CA8;
        Tue, 20 Aug 2019 10:51:03 +0000 (UTC)
Date:   Tue, 20 Aug 2019 06:51:01 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     kaixuxia <xiakaixu1987@gmail.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>, newtongao@tencent.com,
        jasperwang@tencent.com
Subject: Re: [PATCH V2] xfs: Fix agi&agf ABBA deadlock when performing rename
 with RENAME_WHITEOUT flag
Message-ID: <20190820105101.GA14307@bfoster>
References: <8eda2397-b7fb-6dd4-a448-a81628b48edc@gmail.com>
 <20190819151335.GB2875@bfoster>
 <718fa074-2c33-280e-c664-6afcc3bfe777@gmail.com>
 <20190820080741.GE1119@dread.disaster.area>
 <62649c5f-5390-8887-fe95-4f873af62804@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62649c5f-5390-8887-fe95-4f873af62804@gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Tue, 20 Aug 2019 10:51:04 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 20, 2019 at 04:53:22PM +0800, kaixuxia wrote:
> 
> 
> On 2019/8/20 16:07, Dave Chinner wrote:
> > On Tue, Aug 20, 2019 at 02:45:36PM +0800, kaixuxia wrote:
> > > On 2019/8/19 23:13, Brian Foster wrote:
> > > > 	/* error checks before we dirty the transaction */
> > > > 	if (!target_ip && !spaceres) {
> > > > 		error = xfs_dir_canenter();
> > > > 		...
> > > > 	} else if (S_ISDIR() && !(empty || nlink > 2))
> > > > 		error = -EEXIST;
> > > > 		...
> > > > 	}
> > > > 
> > > > 	if (wip) {
> > > > 		...
> > > > 		xfs_iunlink_remove();
> > > > 	}
> > > > 
> > > > 	if (!target_ip) {
> > > > 		xfs_dir_create();
> > > > 		...
> > > > 	} else {
> > > > 		xfs_dir_replace();
> > > > 		...
> > > > 	}
> > > > 
> > > > ... but that may not be any cleaner..? It could also be done as a
> > > > followup cleanup patch as well.
> > > 
> > > Yep, it is cleaner that making the whole check before the transaction
> > > becomes dirty, just return the error code if check failed and
> > > the filesystem is clean.
> > 
> > *nod*
> > 
> > > Dave gave another solution in the other subthread that using
> > > XFS_DIR3_FT_WHT, it's a bit more work for this bug, include
> > > refactoring the xfs_rename() and xfs_lookup(), not sure whether
> > > it's worth the complex changes for this bug.
> > 

Yeah, I wasn't aware of that option. What Dave describes wrt to
replacing the on-disk whiteout inode with a dirent + in-core variant
sounds like the clear best option to me over the ones previously
discussed.

> > It's not necessary to fix the bug, but it's somethign we should
> > be looking to do because it makes whiteout handling a lot more
> > efficient - it's just dirent modifications at that point, no inodes
> > are necessary.
> > 
> > This is how I always intended to handle whiteouts - it's just
> > another thing on the "we need to fix" list....
> 
> Right, it is more efficient because there is no need to store it on disk,
> and it will improve performance just like the async deferred operations.
> Maybe it is on the roadmap, so I'm not sure whether I should send the V3
> patch to address Brian's comments. Maybe we can choose the V3 patch first,
> and then the whiteout improvement could be done as the followup patch
> in future...
> 

I agree. I think a two step process makes sense because we may want a
backportable fix around for the locking bug that doesn't depend on
replacing the implementation.

FWIW if we do take that approach, then IMO it's worth reconsidering the
1-2 liner I originally proposed to fix the locking. It's slightly hacky,
but really all three options are hacky in slightly different ways. The
flipside is it's trivial to implement, review and backport and now would
be removed shortly thereafter when we replace the on-disk whiteout with
the in-core fake whiteout thing. Just my .02 though..

Brian

> > 
> > Cheers,
> > 
> > Dave.
> > 
> 
> -- 
> kaixuxia
