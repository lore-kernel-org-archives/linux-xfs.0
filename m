Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D3E8C00140
	for <linux-xfs@archiver.kernel.org>; Sun, 31 Jul 2022 16:44:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbiGaQoy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 31 Jul 2022 12:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbiGaQox (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 31 Jul 2022 12:44:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78497A19C
        for <linux-xfs@vger.kernel.org>; Sun, 31 Jul 2022 09:44:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1974760F8C
        for <linux-xfs@vger.kernel.org>; Sun, 31 Jul 2022 16:44:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B0AC433D6;
        Sun, 31 Jul 2022 16:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659285891;
        bh=cB+LZPbSeGgmAcSd+L6itd4dNW6Wx4qdKkf4c/8vEug=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sB3EkpqzucUTW454RJ6W47q/QcozVEMWp8gpLqRy0Hcqv4ndyIQZMq1IJBxsenVih
         PzT9b+Iwl+MtOmAbuXWDK6DXRoTAj5LCqTCzcYaOLSIe6GSwogEuQBzRqE5/Zrl1Hu
         1lGNOkZvuiUw2Hg0Xf2ZtGkPOf7AsM7I24x8CyE28MLT6YU5X/Y7xdFlTDTuDOmvv/
         xOwihTUQzQorQSFsaVZ4jRfOKSdHBe2EgH6r2NaUK3drew7ttDQxZx1cZZEFFyd1uw
         D2WX5byPDJLPlBlkXz5KBq7+EC2H8NIv7NNjjk0l82/fhxPStYear37hMC1V5hUZZ9
         qDejR4JP20pVA==
Date:   Sun, 31 Jul 2022 09:44:51 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Stephen Zhang <starzhangzsd@gmail.com>
Cc:     sandeen@redhat.com, hch@lst.de, zhangshida@kylinos.cn,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH] libfrog: fix the if condition in xfrog_bulk_req_v1_setup
Message-ID: <Yuaxg4Fn4B28AkuQ@magnolia>
References: <20220729075746.1918783-1-zhangshida@kylinos.cn>
 <YuQATS8/CujZV3lh@magnolia>
 <CANubcdVqkeyG5AP56AQ+x3QayRmLZ=zULShhxha-a4N16gPKYg@mail.gmail.com>
 <YuSJuF55dZLsbO8Z@magnolia>
 <CANubcdW2LOgePOCLyE=Q2sbSJ0UGO+2Wt3YjsBd3eD9radOVVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANubcdW2LOgePOCLyE=Q2sbSJ0UGO+2Wt3YjsBd3eD9radOVVQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jul 30, 2022 at 03:51:40PM +0800, Stephen Zhang wrote:
> Darrick J. Wong <djwong@kernel.org> 于2022年7月30日周六 09:30写道：
> >
> > It's probably ok to resend with that change, but ... what were you doing
> > to trip over this error, anyway?
> >
> > --D
> >
> 
> Well, I was running xfs/285, and ran into some other error, which was
> already fixed by the latest xfsprogs.
> But in the process of examining the code logic in xfs_scrub, i still find
> there may exist a flaw here, although it hasn't cause any problem so far.
> Maybe it's still neccessary to submit the fix.Or am I just understanding
> the code in a wrong way?

FSBULKSTAT was always weird.  Look at the current kernel implementation,
which translates the V1 FSBULKSTAT call into a V5 BULKSTAT call:

	if (cmd == XFS_IOC_FSINUMBERS) {
		breq.startino = lastino ? lastino + 1 : 0;
		error = xfs_inumbers(&breq, xfs_fsinumbers_fmt);
		lastino = breq.startino - 1;
	} else if (cmd == XFS_IOC_FSBULKSTAT_SINGLE) {
		breq.startino = lastino;
		breq.icount = 1;
		error = xfs_bulkstat_one(&breq, xfs_fsbulkstat_one_fmt);
	} else {	/* XFS_IOC_FSBULKSTAT */
		breq.startino = lastino ? lastino + 1 : 0;
		error = xfs_bulkstat(&breq, xfs_fsbulkstat_one_fmt);
		lastino = breq.startino - 1;
	}

We always bump lastino by one, except in the case where it's 0, because
0 is the magic signal to start at the first inode in the filesystem.
This "only bump it if nonzero" behavior works solely because the fs
layout prevents there ever from being an inode 0.

Now, why does it behave like that?  Before the creation of v5 bulkstat,
which made the cursor work like a standard cursor (i.e. breq->startino
points to the inode that should be stat'd next), the old bulkstat-v1
xfs_bulkstat_grab_chunk did this to mask off all inumbers before and
including the passed in *lastinop:

	idx = agino - irec->ir_startino + 1;
	if (idx < XFS_INODES_PER_CHUNK &&
	    (xfs_inobt_maskn(idx, XFS_INODES_PER_CHUNK - idx) & ~irec->ir_free)) {
		int	i;

		/* We got a right chunk with some left inodes allocated at it.
		 * Grab the chunk record.  Mark all the uninteresting inodes
		 * free -- because they're before our start point.
		 */
		for (i = 0; i < idx; i++) {
			if (XFS_INOBT_MASK(i) & ~irec->ir_free)
				irec->ir_freecount++;
		}

		irec->ir_free |= xfs_inobt_maskn(0, idx);
		*icount = irec->ir_count - irec->ir_freecount;
	}

Notice the "idx = agino - irec->ir_startino + 1".  That means that to go
from bulkstat v5 back to v1, we have to subtract 1 from the inode number
except in the case of zero, which is what libfrog does.  So I don't
think this patch is correct, though the reasons why are ... obscure and
took me several days to remember.

--D

> Thanks,
> 
> Stephen.
