Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87EFBC433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 03:03:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C6D061244
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 03:03:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237478AbhESDEp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 May 2021 23:04:45 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:52738 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237253AbhESDEp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 May 2021 23:04:45 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=eguan@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UZMlKqt_1621393404;
Received: from localhost(mailfrom:eguan@linux.alibaba.com fp:SMTPD_---0UZMlKqt_1621393404)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 19 May 2021 11:03:24 +0800
Date:   Wed, 19 May 2021 11:03:24 +0800
From:   Eryu Guan <eguan@linux.alibaba.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eryu Guan <guan@eryu.me>, guaneryu@gmail.com,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/8] common/xfs: refactor commands to select a particular
 xfs backing device
Message-ID: <20210519030324.GB60846@e18g06458.et15sqa>
References: <162078489963.3302755.9219127595550889655.stgit@magnolia>
 <162078491108.3302755.3627499639796540923.stgit@magnolia>
 <YKE/I0HE+2MNSCCG@desktop>
 <20210516203437.GS9675@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210516203437.GS9675@magnolia>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, May 16, 2021 at 01:34:37PM -0700, Darrick J. Wong wrote:
> On Sun, May 16, 2021 at 11:49:55PM +0800, Eryu Guan wrote:
> > On Tue, May 11, 2021 at 07:01:51PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Refactor all the places where we try to force new file data allocations
> > > to a specific xfs backing device so that we don't end up open-coding the
> > > same xfs_io command lines over and over.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  common/populate   |    2 +-
> > >  common/xfs        |   25 +++++++++++++++++++++++++
> > >  tests/generic/223 |    3 ++-
> > >  tests/generic/449 |    2 +-
> > >  tests/xfs/004     |    2 +-
> > 
> > >  tests/xfs/088     |    1 +
> > >  tests/xfs/089     |    1 +
> > >  tests/xfs/091     |    1 +
> > >  tests/xfs/120     |    1 +
> > >  tests/xfs/130     |    1 +
> > 
> > I think above updates should be in a separate patch.
> 
> Why?

This patch is refactoring open-coded command into a helper, which should
not change the logic. But above changes are adding new users of this
helper and change test behavior. So I think they should be in a separate
patch for review.

Thanks,
Eryu
