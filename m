Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D15BBC433E6
	for <linux-xfs@archiver.kernel.org>; Sun, 17 Jan 2021 23:19:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 955942075A
	for <linux-xfs@archiver.kernel.org>; Sun, 17 Jan 2021 23:19:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729936AbhAQXTd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 17 Jan 2021 18:19:33 -0500
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:59905 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729349AbhAQXTd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Jan 2021 18:19:33 -0500
Received: from dread.disaster.area (pa49-181-54-82.pa.nsw.optusnet.com.au [49.181.54.82])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id C02198E56;
        Mon, 18 Jan 2021 10:18:50 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1l1HJo-0013AE-FF; Mon, 18 Jan 2021 10:18:48 +1100
Date:   Mon, 18 Jan 2021 10:18:48 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: test mkfs.xfs config files
Message-ID: <20210117231848.GB78965@dread.disaster.area>
References: <20201027205450.2824888-1-david@fromorbit.com>
 <20201029212713.GF1061260@magnolia>
 <20210116014607.GE3134581@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210116014607.GE3134581@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=NAd5MxazP4FGoF8nXO8esw==:117 a=NAd5MxazP4FGoF8nXO8esw==:17
        a=kj9zAlcOel0A:10 a=EmqxpYm9HcoA:10 a=NHsjDDs8AAAA:20 a=7-415B0cAAAA:8
        a=yABiCH9rjB4m46n2Nk8A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 15, 2021 at 05:46:07PM -0800, Darrick J. Wong wrote:
> On Thu, Oct 29, 2020 at 02:27:13PM -0700, Darrick J. Wong wrote:
> > On Wed, Oct 28, 2020 at 07:54:50AM +1100, Dave Chinner wrote:
> > > +echo End of line comment
> > > +test_mkfs_config << ENDL
> > > +[metadata]
> > > +crc = 0 ; This is an eol comment.
> > 
> > Hey, wait a minute, the manpage didn't say I could use semicolon
> > comments! :)
> > 
> > The libinih page https://github.com/benhoyt/inih says you can though.
> > 
> > Would you mind making a note of that in patch 5 above, please?
> 
> Ping?  The mkfs code has been merged upstream; we ought to land the
> functionality tests.

Nothing in this patch needs to change, AFAIA, because you were
referring to the xfsprogs mkfs patchset in your comment. So this
is really only waiting on review, right? Do I need to repost it?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
