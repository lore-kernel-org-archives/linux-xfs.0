Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78FA5C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 22:05:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 315CD60238
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 22:05:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234141AbhBYWFb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 17:05:31 -0500
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:34855 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234153AbhBYWFa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 17:05:30 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 9E2724EC7CA;
        Fri, 26 Feb 2021 09:04:48 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lFOka-004K7y-2q; Fri, 26 Feb 2021 09:04:48 +1100
Date:   Fri, 26 Feb 2021 09:04:48 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: type verification is expensive
Message-ID: <20210225220448.GP4662@dread.disaster.area>
References: <20210223054748.3292734-1-david@fromorbit.com>
 <20210223054748.3292734-2-david@fromorbit.com>
 <YDdn6f+6S/wCJDF+@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YDdn6f+6S/wCJDF+@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=kj9zAlcOel0A:10 a=qa6Q16uM49sA:10 a=7-415B0cAAAA:8
        a=JuDxSlhT3OO6blO4plAA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 25, 2021 at 10:03:37AM +0100, Christoph Hellwig wrote:
> Any reason to not just mark them static inline and move them to
> xfs_types.h?

Circular header file dependencies. xfs_mount.h needs xfs_types.h and
moving these to xfs_types.h means xfs_types.h now depends on
xfs_mount.h and a bunch of other header files...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
