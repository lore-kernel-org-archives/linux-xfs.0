Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 346DAC433E6
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 04:28:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0486922472
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 04:28:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbhARE1r (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 17 Jan 2021 23:27:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:55630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725794AbhARE1q (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 17 Jan 2021 23:27:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D5E722460;
        Mon, 18 Jan 2021 04:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610944025;
        bh=peG0aLbqCZ0j7iIducyN4yIz4ANzWdbK60RGNBPEYRs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PQBK+D7iw3awskTVzxhI+GQtnwQuogm610pxurTN88v3XgOWQnRpRf3PAHmWU3WET
         35TPceoGxTjqW9Nmin4nxxMcweR/JyflBiNzEfuuSqnrctcfrp7pB6xNvomoQk9ZT4
         buh0yd0DpitGTj6G5NdCac8kUWoLRickRKli/BoP8iIU71CExGcfGGXwbnftJovCSf
         Ff65JHN6JE4MVkbbz/J1o8f5XVBAJ8oaZiINU6u8Gdn3x55PlEfIr8WMF54JXBhrXr
         ltGGkDiqx2edPJbisJcVL8dOD7Cv9V8GSNP28Y3zoEanZPHGG+V7X9rV/Jk5qp81jI
         BghhGt3zoQjQA==
Date:   Sun, 17 Jan 2021 20:27:04 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: test mkfs.xfs config files
Message-ID: <20210118042704.GG3134581@magnolia>
References: <20201027205450.2824888-1-david@fromorbit.com>
 <20201029212713.GF1061260@magnolia>
 <20210116014607.GE3134581@magnolia>
 <20210117231848.GB78965@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210117231848.GB78965@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 18, 2021 at 10:18:48AM +1100, Dave Chinner wrote:
> On Fri, Jan 15, 2021 at 05:46:07PM -0800, Darrick J. Wong wrote:
> > On Thu, Oct 29, 2020 at 02:27:13PM -0700, Darrick J. Wong wrote:
> > > On Wed, Oct 28, 2020 at 07:54:50AM +1100, Dave Chinner wrote:
> > > > +echo End of line comment
> > > > +test_mkfs_config << ENDL
> > > > +[metadata]
> > > > +crc = 0 ; This is an eol comment.
> > > 
> > > Hey, wait a minute, the manpage didn't say I could use semicolon
> > > comments! :)
> > > 
> > > The libinih page https://github.com/benhoyt/inih says you can though.
> > > 
> > > Would you mind making a note of that in patch 5 above, please?
> > 
> > Ping?  The mkfs code has been merged upstream; we ought to land the
> > functionality tests.
> 
> Nothing in this patch needs to change, AFAIA, because you were
> referring to the xfsprogs mkfs patchset in your comment. So this
> is really only waiting on review, right? Do I need to repost it?

Probably, as it's entirely possible that it's gotten lost in Eryu's mail
stream.

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
