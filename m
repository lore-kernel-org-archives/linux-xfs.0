Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6AA4C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 03:29:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89D7B64E4D
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 03:29:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbhBWD31 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Feb 2021 22:29:27 -0500
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:56540 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231274AbhBWD30 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Feb 2021 22:29:26 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 826A8FA5E00;
        Tue, 23 Feb 2021 14:28:39 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lEONJ-0001ML-Ve; Tue, 23 Feb 2021 14:28:37 +1100
Date:   Tue, 23 Feb 2021 14:28:37 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: use current->journal_info for detecting transaction
 recursion
Message-ID: <20210223032837.GS4662@dread.disaster.area>
References: <20210222233107.3233795-1-david@fromorbit.com>
 <20210223021557.GF7272@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223021557.GF7272@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=kj9zAlcOel0A:10 a=qa6Q16uM49sA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=2NSDytHea6jLAqn1QnMA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 22, 2021 at 06:15:57PM -0800, Darrick J. Wong wrote:
> On Tue, Feb 23, 2021 at 10:31:07AM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Because the iomap code using PF_MEMALLOC_NOFS to detect transaction
> > recursion in XFS is just wrong. Remove it from the iomap code and
> > replace it with XFS specific internal checks using
> > current->journal_info instead.
> 
> It might be worth mentioning that this changes the PF_MEMALLOC_NOFS
> behavior very slightly -- it's now bound to the allocation and freeing
> of the transaction, instead of the strange way we used to do this, where
> we'd set it at reservation time but we don't /clear/ it at unreserve time.

They are effectively the same thing, so I think you are splitting
hairs here. The rule is "transaction context is NOFS" so whether it
is set when the transaction context is entered or a few instructions
later when we start the reservation is not significant.

> This doesn't strictly look like a fix patch, but as it is a Dumb
> Developer Detector(tm) I could try to push it for 5.12 ... or just make
> it one of the first 5.13 patches.  Any preference?

Nope. You're going to need to fix the transaction nesting the new gc
code does before applying this, though, because that is detected as
transaction recursion by this patch....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
