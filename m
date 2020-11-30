Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D90EAC63777
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Nov 2020 22:04:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A02620857
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Nov 2020 22:04:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730378AbgK3WEb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Nov 2020 17:04:31 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:43894 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725893AbgK3WEb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Nov 2020 17:04:31 -0500
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id BE2C15855F9;
        Tue,  1 Dec 2020 09:03:48 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kjrGt-00GkEh-QY; Tue, 01 Dec 2020 09:03:47 +1100
Date:   Tue, 1 Dec 2020 09:03:47 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, linux-xfs@vger.kernel.org
Subject: Re: Maximum height of rmapbt when reflink feature is enabled
Message-ID: <20201130220347.GI2842436@dread.disaster.area>
References: <3275346.ciGmp8L3Sz@garuda>
 <20201130192605.GB143049@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201130192605.GB143049@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Ubgvt5aN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=zTNgK-yGK50A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=VXzDNDuzsZRX6bCEoKIA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 30, 2020 at 11:26:05AM -0800, Darrick J. Wong wrote:
> On Mon, Nov 30, 2020 at 02:35:21PM +0530, Chandan Babu R wrote:
> > I have come across a "log reservation" calculation issue when
> > increasing XFS_BTREE_MAXLEVELS to 10 which is in turn required for
> 
> Hmm.  That will increase the size of the btree cursor structure even
> farther.  It's already gotten pretty bad with the realtime rmap and
> reflink patchsets since the realtime volume can have 2^63 blocks, which
> implies a theoretical maximum rtrmapbt height of 21 levels and a maximum
> rtrefcountbt height of 13 levels.

The cursor is dynamically allocated, yes? So what we need to do is
drop the idea that the btree is a fixed size and base it's size on
the actual number of levels iwe calculated for that the btree it is
being allocated for, right?

> (These heights are absurd, since they imply a data device of 2^63
> blocks...)
> 
> I suspect that we need to split MAXLEVELS into two values -- one for
> per-AG btrees, and one for per-file btrees,

We already do that. XFS_BTREE_MAXLEVELS is supposed to only be for
per-AG btrees.  It is not used for BMBTs at all, they use
mp->m_bm_maxlevels[] which have max height calculations done at
mount time.

The problem is the cursor, because right now max mp->m_bm_maxlevels
fits within the XFS_BTREE_MAXLEVELS limit for the per-AG trees as
well, because everything is limited to less than 2^32 records...

> and then refactor the btree
> cursor so that the level data are a single VLA at the end.  I started a
> patchset to do all that[1], but it's incomplete.
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/commit/?h=btree-dynamic-depth&id=692f761838dd821cd8cc5b3d1c66d6b1ac8ec05b

Yeah, this, along with dynamic sizing of the rmapbt based
on the physical AG size when refcount is enabled...

And then we just don't have to care about the 1kB block size case at
all....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
