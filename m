Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81E51C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Sep 2021 18:25:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AB8D60F46
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Sep 2021 18:25:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234183AbhIMS1A (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Sep 2021 14:27:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:59470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233133AbhIMS07 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Sep 2021 14:26:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91AC160F9F;
        Mon, 13 Sep 2021 18:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631557543;
        bh=cMreMlcDw4dhk9EeHwbWFjFlDxXyialBeVOgp519kLM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m4V28Hj4+1qU69VHNCRK8e/aY+JX5vUZLqqpVuoFft6CP7Qp2T3zLOFmneyWGRFQt
         OBfmi8501+40qlnbkr75xPA3RQVy+FM+xZPWEdjsrGYB4tenF+39kZS5KVavoncsHR
         PlWgkZqfefIJPHVHCrS0gM7ArDRj6fmB1Nk64veOYVH3u5FndGlHsp8nq2Dki3TFLY
         ndk/8MFuDNmfvBUPVJqKqKgFOhRkcdHgZxkS/pqwMdKjF6bG5as7lU9GlgMHMAC8/H
         VoW61j6QwQzpU0RIqfO2vwWJX/wtFDoOOZ/IuY56pKgdzpWfoA2s/fWUCKMo7w5W4A
         tFQKdHBxZ8nHg==
Date:   Mon, 13 Sep 2021 11:25:43 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eryu Guan <guan@eryu.me>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCHSET v2 0/3] fstests: exercise code refactored in 5.14
Message-ID: <20210913182543.GF638503@magnolia>
References: <163045510470.770026.14067376159951420121.stgit@magnolia>
 <YTTcgUw8/EwxYxU1@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTTcgUw8/EwxYxU1@desktop>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Sep 05, 2021 at 11:04:33PM +0800, Eryu Guan wrote:
> On Tue, Aug 31, 2021 at 05:11:44PM -0700, Darrick J. Wong wrote:
> > Hi all,
> > 
> > Add new tests to exercise code that got refactored in 5.14.  The
> > nested shutdown test simulates the process of recovering after a VM host
> > filesystem goes down and the guests have to recover.
> > 
> > v2: fix some bugs pointed out by the maintainer, add cpu offlining stress test
> 
> Thanks for the revision! I've applied patch 2 and 3 for the update.

Cool, thanks!

--D

> Thanks,
> Eryu
> 
> > 
> > If you're going to start using this mess, you probably ought to just
> > pull from my git trees, which are linked below.
> > 
> > This is an extraordinary way to destroy everything.  Enjoy!
> > Comments and questions are, as always, welcome.
> > 
> > --D
> > 
> > fstests git tree:
> > https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=new-tests-for-5.14
> > ---
> >  common/rc             |   24 +++++++++
> >  tests/generic/725     |  136 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/725.out |    2 +
> >  tests/generic/726     |   69 +++++++++++++++++++++++++
> >  tests/generic/726.out |    2 +
> >  tests/xfs/449         |    2 -
> >  6 files changed, 234 insertions(+), 1 deletion(-)
> >  create mode 100755 tests/generic/725
> >  create mode 100644 tests/generic/725.out
> >  create mode 100755 tests/generic/726
> >  create mode 100644 tests/generic/726.out
