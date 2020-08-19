Return-Path: <SRS0=dccG=B5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 267D0C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Aug 2020 04:43:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F21E82078B
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Aug 2020 04:43:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="my+rBe4j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725306AbgHSEnT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Aug 2020 00:43:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725275AbgHSEnS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Aug 2020 00:43:18 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58103C061389
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 21:43:18 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id bh1so10219786plb.12
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 21:43:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iFhoWFvLfCsPbws5HY5HUvfrWWYUi/u04Mt005rUxv4=;
        b=my+rBe4jCW0EGd+uOEIGNCwO+///t+hY7cQ8lvyCF/bdV17ZQehQjocmBuGeYr/7OC
         Uje1JcIq4LGuS85GYAziwmp62KwDPGy0mVIf2SlFaayKuyqY52TGP/1prfESjlMcE2f6
         PfbzIBOIp9i1S2zHpGLzq7rd53JfPG+0fPFYukCKxkZeUoFveF+lculkKgE6rA2vE6nq
         RRh9tCfsL2acjBnd2RYS4V8vTz/efDEEL3x5+mWZBYlm/x5syiKooHWzciD3N2XB9m8v
         xulG8YwpMXmTQBacdcaeeYU89Y9CHmtnUUyB8Jm38AV9a9jKHby8oJZnL88+OZui+Eqq
         paQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iFhoWFvLfCsPbws5HY5HUvfrWWYUi/u04Mt005rUxv4=;
        b=lv+4Mv7hvn876VBtA5DMaGs4ZikkMWZt1HnvygFiU+aAFtj7WkTS3HDI4t+3z2NScq
         o/jBEGfCt1WaUeRj10v/nZRZ8JL6qlDiXC6LyzRRse6arFW73EA8ryGnVJGgl6j7+pn7
         ZqR0p0Up9nRhAI3UyI9FSHZh3fyN4c6lgypeM/zecAg//cWVtsZGIARmWJIjFKmaZnrP
         LpShwmlVTxgxMiwo+HUjuqGdnIYfk9hay0zyIxMp6Kvcal6CrKKj1bXEbieLgFO31xyG
         wNCoWH/SzUrEA/nLnXnzxqQVwqiiFw+aFIzAF3KNZ3pj5fhstAm6SiyUHUvJJJJmn/WH
         ekPQ==
X-Gm-Message-State: AOAM532dovQDolOAi0tECTrt3quitHCwuHweJINDNjJIxnS9hZGMassm
        RfRBtY3Qet8M4iZ1vo5kggroZZhUhg8=
X-Google-Smtp-Source: ABdhPJzWKqejSTrhzHYAZKERJmnomTQeU3F7jACMkbvjclVk3RTmF9bkqGfVAGjqTL+epAyZPPKZkg==
X-Received: by 2002:a17:902:9a43:: with SMTP id x3mr17391918plv.289.1597812197873;
        Tue, 18 Aug 2020 21:43:17 -0700 (PDT)
Received: from garuda.localnet ([122.171.187.105])
        by smtp.gmail.com with ESMTPSA id o15sm27295189pfu.167.2020.08.18.21.43.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2020 21:43:17 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2 02/10] xfs: Check for extent overflow when trivally adding a new extent
Date:   Wed, 19 Aug 2020 10:13:11 +0530
Message-ID: <4229156.vdj4XEOXJJ@garuda>
In-Reply-To: <20200818215746.GZ6096@magnolia>
References: <20200814080833.84760-1-chandanrlinux@gmail.com> <20200818214933.GB21744@dread.disaster.area> <20200818215746.GZ6096@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wednesday 19 August 2020 3:27:46 AM IST Darrick J. Wong wrote:
> On Wed, Aug 19, 2020 at 07:49:33AM +1000, Dave Chinner wrote:
> > On Mon, Aug 17, 2020 at 07:53:07AM +0100, Christoph Hellwig wrote:
> > > On Fri, Aug 14, 2020 at 01:38:25PM +0530, Chandan Babu R wrote:
> > > > When adding a new data extent (without modifying an inode's existing
> > > > extents) the extent count increases only by 1. This commit checks for
> > > > extent count overflow in such cases.
> > > > 
> > > > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> > > > ---
> > > >  fs/xfs/libxfs/xfs_bmap.c       | 8 ++++++++
> > > >  fs/xfs/libxfs/xfs_inode_fork.h | 2 ++
> > > >  fs/xfs/xfs_bmap_util.c         | 5 +++++
> > > >  fs/xfs/xfs_dquot.c             | 8 +++++++-
> > > >  fs/xfs/xfs_iomap.c             | 5 +++++
> > > >  fs/xfs/xfs_rtalloc.c           | 5 +++++
> > > >  6 files changed, 32 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > > > index 9c40d5971035..e64f645415b1 100644
> > > > --- a/fs/xfs/libxfs/xfs_bmap.c
> > > > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > > > @@ -4527,6 +4527,14 @@ xfs_bmapi_convert_delalloc(
> > > >  		return error;
> > > >  
> > > >  	xfs_ilock(ip, XFS_ILOCK_EXCL);
> > > > +
> > > > +	if (whichfork == XFS_DATA_FORK) {
> > > 
> > > Should we add COW fork special casing to xfs_iext_count_may_overflow
> > > instead?
> 
> That seems like a reasonable idea.
> 
> > > 
> > > > +		error = xfs_iext_count_may_overflow(ip, whichfork,
> > > > +				XFS_IEXT_ADD_CNT);
> > > 
> > > I find the XFS_IEXT_ADD_CNT define very confusing.  An explicit 1 passed
> > > for a counter parameter makes a lot more sense to me.
> > 
> > I explicitly asked Chandan to convert all the magic numbers
> > sprinkled in the previous patch to defined values. It was impossible
> > to know whether the intended value was correct when it's just an
> > open coded number because we don't know what the number actually
> > stands for. And, in future, if we change the behaviour of a specific
> > operation, then we only have to change a single value rather than
> > having to track down and determine if every magic "1" is for an
> > extent add operation or something different.
> 
> I prefer named flags over magic numbers too, though this named constant
> doesn't have a comment describing what it does, and "ADD_CNT" doesn't
> really tell me much.  The subsequent patches have comments, so maybe
> this should just become:
> 
> /*
>  * Worst-case increase in the fork extent count when we're adding a
>  * single extent to a fork and there's no possibility of splitting an
>  * existing mapping.
>  */
> #define XFS_IEXT_ADD_NOSPLIT	(1)
>

That is perfect. Thanks for the suggestion. I will add that in the next
version of this patchset.

-- 
chandan



