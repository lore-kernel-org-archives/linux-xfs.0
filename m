Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E94A0C4707F
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 23:29:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B89376113D
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 23:29:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233941AbhE0Xba (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 May 2021 19:31:30 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:51053 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233689AbhE0Xb3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 May 2021 19:31:29 -0400
Received: from dread.disaster.area (pa49-180-230-185.pa.nsw.optusnet.com.au [49.180.230.185])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id B39B71043985;
        Fri, 28 May 2021 09:29:54 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lmPRp-005zW1-BV; Fri, 28 May 2021 09:29:53 +1000
Date:   Fri, 28 May 2021 09:29:53 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 07/10] xfs: simplify the b_page_count calculation
Message-ID: <20210527232953.GQ664593@dread.disaster.area>
References: <20210526224722.1111377-1-david@fromorbit.com>
 <20210526224722.1111377-8-david@fromorbit.com>
 <20210527231544.GJ2402049@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210527231544.GJ2402049@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=dUIOjvib2kB+GiIc1vUx8g==:117 a=dUIOjvib2kB+GiIc1vUx8g==:17
        a=kj9zAlcOel0A:10 a=5FLXtPjwQuUA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=eFdz1vm4y5HSD0vYKuoA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 27, 2021 at 04:15:44PM -0700, Darrick J. Wong wrote:
> On Thu, May 27, 2021 at 08:47:19AM +1000, Dave Chinner wrote:
> > From: Christoph Hellwig <hch@lst.de>
> > 
> > Ever since we stopped using the Linux page cache
> 
> The premise of /that/ is unsettling.  Um... did b_pages[] point to
> pagecache pages, and that's why all that offset shifting was necessary?

Yes. So things like sector/block size < page size would work
correctly. We could have multiple buffers point at different offsets
in the same page...

> > to back XFS buffes
> 
> s/buffes/buffers/
> 
> > there is no need to take the start sector into account for
> > calculating the number of pages in a buffer, as the data always
> > start from the beginning of the buffer.
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Ta!

-Dave.
-- 
Dave Chinner
david@fromorbit.com
