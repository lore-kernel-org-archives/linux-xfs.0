Return-Path: <SRS0=1kUG=AT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 745AAC433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jul 2020 06:55:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 522B92075B
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jul 2020 06:55:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729535AbgGHGzR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jul 2020 02:55:17 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:58095 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726194AbgGHGzR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jul 2020 02:55:17 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 799B3D59974;
        Wed,  8 Jul 2020 16:55:13 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jt3z6-0003hJ-1d; Wed, 08 Jul 2020 16:55:12 +1000
Date:   Wed, 8 Jul 2020 16:55:12 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Joe Perches <joe@perches.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: Use fallthrough pseudo-keyword
Message-ID: <20200708065512.GN2005@dread.disaster.area>
References: <20200707200504.GA4796@embeddedor>
 <20200707205036.GL7606@magnolia>
 <96f58df8a489093fb239cea8d36768b921269056.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96f58df8a489093fb239cea8d36768b921269056.camel@perches.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=7-415B0cAAAA:8
        a=AdeI-h9QSvwSZK6rD4QA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 07, 2020 at 06:48:29PM -0700, Joe Perches wrote:
> On Tue, 2020-07-07 at 13:50 -0700, Darrick J. Wong wrote:
> > On Tue, Jul 07, 2020 at 03:05:04PM -0500, Gustavo A. R. Silva wrote:
> > > Replace the existing /* fall through */ comments and its variants with
> > > the new pseudo-keyword macro fallthrough[1]. Also, remove unnecessary
> > > fall-through markings when it is the case.
> []
> > I don't get it, what's the point?  Are gcc/clang
> > refusing to support -Wimplicit-fallthrough=[1-4] past a certain date?
> 
> clang doesn't support comments

So fix the damn compiler.

-Dave
-- 
Dave Chinner
david@fromorbit.com
