Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF6EFC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 00:46:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4F256112E
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 00:46:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233367AbhIPAsK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 20:48:10 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:35402 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233237AbhIPAsJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Sep 2021 20:48:09 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 64D4E104F27C;
        Thu, 16 Sep 2021 10:46:46 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mQfY6-00CxTt-CJ; Thu, 16 Sep 2021 10:46:46 +1000
Date:   Thu, 16 Sep 2021 10:46:46 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/61] libfrog: create header file for mocked-up kernel
 data structures
Message-ID: <20210916004646.GO2361455@dread.disaster.area>
References: <163174719429.350433.8562606396437219220.stgit@magnolia>
 <163174721123.350433.6338166230233894732.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163174721123.350433.6338166230233894732.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=kj9zAlcOel0A:10 a=7QKq2e-ADPsA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=kZs-T9uRJFqMC8aELcwA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 15, 2021 at 04:06:51PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create a mockups.h for mocked-up versions of kernel data structures to
> ease porting of libxfs code.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  include/libxfs.h     |    1 +
>  libfrog/Makefile     |    1 +
>  libfrog/mockups.h    |   19 +++++++++++++++++++
>  libxfs/libxfs_priv.h |    4 +---
>  4 files changed, 22 insertions(+), 3 deletions(-)

I don't really like moving this stuff to libfrog. The whole point of
libxfs/libxfs_priv.h is to define the kernel wrapper stuff that
libxfs needs to compile and should never be seen by anything outside
libxfs/...

Indeed, we -cannot- use spinlocks in userspace code, so I really
don't see why we'd want to make them more widely visible to the
userspace xfsprogs code...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
