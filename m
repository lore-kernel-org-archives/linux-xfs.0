Return-Path: <SRS0=J8xT=CE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA4BEC433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 22:06:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83AE6207BC
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 22:06:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726790AbgHZWGC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Aug 2020 18:06:02 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:50774 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726753AbgHZWGB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Aug 2020 18:06:01 -0400
Received: from dread.disaster.area (pa49-181-146-199.pa.nsw.optusnet.com.au [49.181.146.199])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 64E246AD4C9;
        Thu, 27 Aug 2020 08:05:59 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kB3YM-0003r9-Dt; Thu, 27 Aug 2020 08:05:58 +1000
Date:   Thu, 27 Aug 2020 08:05:58 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] build: add support for libinih for mkfs
Message-ID: <20200826220558.GX12131@dread.disaster.area>
References: <20200826015634.3974785-1-david@fromorbit.com>
 <20200826015634.3974785-2-david@fromorbit.com>
 <18ce951d-c209-9c60-3f6c-0c7989c587ae@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18ce951d-c209-9c60-3f6c-0c7989c587ae@sandeen.net>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=KcmsTjQD c=1 sm=1 tr=0 cx=a_idp_d
        a=GorAHYkI+xOargNMzM6qxQ==:117 a=GorAHYkI+xOargNMzM6qxQ==:17
        a=kj9zAlcOel0A:10 a=y4yBn9ojGxQA:10 a=20KFwNOVAAAA:8 a=NHsjDDs8AAAA:20
        a=7-415B0cAAAA:8 a=lW4MfNZ0gOILfn9SGHoA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 26, 2020 at 04:51:50PM -0500, Eric Sandeen wrote:
> On 8/25/20 8:56 PM, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Need to make sure the library is present so we can build mkfs with
> > config file support.
> 
> Can you add https://github.com/benhoyt/inih to doc/INSTALL as a
> dependency?

Distros should be shipping that library, and configure asks you to
install it if it isn't present, just like it does for all the other
libraries xfsprogs depends on. We want users to install distro
libraries, not have to build dependencies from source and install
them...

> (that's probably pretty out of date now anyway but it seems worth
> documenting any new requirement)

Yeah, we need a lot more than just e2fsprogs-devel and UUIDs these
days. I'd prefer that doc/INSTALL just says "the configure script
will prompt you to install missing build dependencies" rather than
iterate them here and have the list be perpetually incomplete....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
