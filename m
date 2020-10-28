Return-Path: <SRS0=iKFT=ED=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DATE_IN_PAST_12_24,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FDDDC388F7
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Oct 2020 21:52:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AAA4E208C3
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Oct 2020 21:52:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vIClhMh2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728342AbgJ1Vw3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Oct 2020 17:52:29 -0400
Received: from casper.infradead.org ([90.155.50.34]:44310 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728332AbgJ1Vw2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Oct 2020 17:52:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=oFM+UfK7LtkPTsRFcQZZrVqh1rI2Q9j1nyRWtTnQqNQ=; b=vIClhMh2YTfWz/JfFNI3/P5KYH
        k2FVWJseZR4xLFpBlyMfQWFaJufyuMUYJIodLYIlYo45u+THjFfBqLh1oA+4EftWqyUCf5DfiKvxy
        McARV6KBkhdssHgnrFcqFNKuyzO8Ty8tq3B7d+T0BlD7T3d0ZIJaqOBO3JwY+rBpclGuZRcrtLz8c
        qSHPhkjXeIQfkuDp+ki0jFgIsRwZptY+1hzcPkX0vDWHaN1y/eXLgRsvTtvDzKei/IGQD7B6cFCY/
        odwb2KaBlAFzc2+BtcwKP7MXO+gqdziGHrGWftjtYy2JdQ2kPQ6tKyFR6XRwC53KUWbUO8xO/685q
        0jkfEicw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kXfyE-0000Ks-TR; Wed, 28 Oct 2020 07:34:10 +0000
Date:   Wed, 28 Oct 2020 07:34:10 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs_repair: skip the rmap and refcount btree checks
 when the levels are garbage
Message-ID: <20201028073410.GF32068@infradead.org>
References: <160375511371.879169.3659553317719857738.stgit@magnolia>
 <160375513815.879169.8550751453198927018.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160375513815.879169.8550751453198927018.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 26, 2020 at 04:32:18PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In validate_ag[fi], we should check that the levels of the rmap and
> refcount btrees are valid.  If they aren't, we need to tell phase4 to
> skip the comparison between the existing and incore rmap and refcount
> data.  The comparison routines use libxfs btree cursors, which assume
> that the caller validated bc_nlevels and will corrupt memory if we load
> a btree cursor with a garbage level count.
> 
> This was found by examing a core dump from a failed xfs/086 invocation.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
