Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79696C7618E
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Apr 2023 20:54:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232891AbjDUUy4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Apr 2023 16:54:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233018AbjDUUyq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Apr 2023 16:54:46 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ABC52D5F
        for <linux-xfs@vger.kernel.org>; Fri, 21 Apr 2023 13:54:27 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1a6762fd23cso23792315ad.3
        for <linux-xfs@vger.kernel.org>; Fri, 21 Apr 2023 13:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1682110467; x=1684702467;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hgtax5k0SZtqbDKx0lq8MlqQEIC2GHIqKIDab9U6GZ8=;
        b=bdQ3WfBSc4RqPWakTFj8wclIRZSHqoZnTduKgjPmYLSyg4Wed4FwhsNkNo2nF+rvcs
         tZotfmIPwkHNjETAs6pdvQ6iYRM2h2uCG5QA80hy7CkTklkb97UW6mNlAm4OaYw1fQno
         EaqBPohoPeX6p4I/bYkGo0+YxPo712U1G0WdHDzNC33/Peuwo0OS78bw9s+0TwZfOozK
         NH1oO56CgBxDEOy2rSTjPInI/xRBOmSVDsVJOVrA2gfhwbbxGcjWhIFbjlrvRMt6qaPj
         CFeyzAyANe3GZB2aHBfOk5HbhLrX3/Q7JzqanySzsriz8hHVi8gQxt/Fhyl95THXFGpS
         WsYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682110467; x=1684702467;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hgtax5k0SZtqbDKx0lq8MlqQEIC2GHIqKIDab9U6GZ8=;
        b=lcHuASVNycKmYdVpIyTRGArgerNgC27oyS3/8O8bpU0Q3K0LBQyqPj/Mk0sj19m/cF
         8TTYCL0cDe9oOxcUX+6XHsGlp6ZsuYveeDRRWC4cfdc8Z5KXlngJpIKQIFvD8Qb69X8W
         VwmpbNQpxhYURi7j0yVmS6CEEtQBujmsIQA8j7g+X+QufBXA4k8J3aKTphOS8cXAIsHn
         By64vDkH4Vht3/IEvBIOiMtSGyjVVXVMCE8jaqIOrewbPsFunSBuGsUmlEC15tPLRJjr
         Dz4xXknQg0WH8oTlycmuancyuMx24ehIulT175ht4mvFO3KXfmLpe95s4md6PrCb6eam
         zSrw==
X-Gm-Message-State: AAQBX9fSgqLB3mn7oRKwNKDRGYUW//dKaXLDA3k86EPv2KJbQ+9nu43M
        Bn6zOYUHYgo2SEwqaEIIEL01tA==
X-Google-Smtp-Source: AKy350Y7A/6FIG7xSo/VNEtsKoRLgSJ+Ea9aqjmBg+gxkg/6aZwq+ZTq/tlR9epMC4giR+DjwMLAlg==
X-Received: by 2002:a17:902:ced0:b0:1a2:8866:e8a4 with SMTP id d16-20020a170902ced000b001a28866e8a4mr7675275plg.1.1682110466778;
        Fri, 21 Apr 2023 13:54:26 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-41-174.pa.nsw.optusnet.com.au. [49.180.41.174])
        by smtp.gmail.com with ESMTPSA id b17-20020a170902ed1100b001a804b16e38sm3101272pld.150.2023.04.21.13.54.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 13:54:26 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ppxlv-006C3C-9u; Sat, 22 Apr 2023 06:54:23 +1000
Date:   Sat, 22 Apr 2023 06:54:23 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Guo Xuenan <guoxuenan@huawei.com>, dchinner@redhat.com,
        linux-xfs@vger.kernel.org, sandeen@redhat.com,
        guoxuenan@huaweicloud.com, houtao1@huawei.com, fangwei1@huawei.com,
        jack.qiu@huawei.com, yi.zhang@huawei.com
Subject: Re: [PATCH 1/3] xfs: fix leak memory when xfs_attr_inactive fails
Message-ID: <20230421205423.GF3223426@dread.disaster.area>
References: <20230421033142.1656296-1-guoxuenan@huawei.com>
 <20230421033142.1656296-2-guoxuenan@huawei.com>
 <20230421074932.GD3223426@dread.disaster.area>
 <20230421153216.GI360889@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230421153216.GI360889@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 21, 2023 at 08:32:16AM -0700, Darrick J. Wong wrote:
> On Fri, Apr 21, 2023 at 05:49:32PM +1000, Dave Chinner wrote:
> > Yes, I agree the way xfs_inactive() and inodegc handles errors and
> > cleanup needs improvement, but we've known this for a while now. But
> > this doesn't change the fact that we currently need to be able to
> > leak resources we can't access so we can continue to operate. It's
> > fine for ASSERTs to fire on debug kernels in these situations - as
> > developers we need to understand when these situations occur - but
> > that doesn't mean the behaviour they are warning about needs to be
> > fixed. It's just telling us that we are leaking stuff, it just
> > doesn't know why.
> 
> ...and should probably be logging the fact that the bad inode was
> dropped on the floor and the sysadmin should go run a fsck tool of some
> kind to fix the problems.

Runtime corruption detection at the point of error injection already
warns via the XFS_IS_CORRUPT() macro:

	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ifp)) ||
	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT))
		return -EFSCORRUPTED;

> > We have be waiting on having fine grained health infomration for
> > inodes to be able to handle situations like this more gracefully.
> > That code is being merged in 6.4, and it means that we know the
> 
> It is?
> 
> I didn't send you a pull request for
> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=indirect-health-reporting
> 
> for 6.4.  At some point I want to talk to you about the rest of online
> fsck, but I'm taking a breather for the last week or two until LSFMM.

Oops, I'm getting ahead of myself, aren't I? I was looking at a
local review branch that has everything merged in, not the for-next
branch I thought I was looking at...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
