Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC18AC433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 18:00:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 768E9619F9
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 18:00:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236414AbhCXR75 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 13:59:57 -0400
Received: from verein.lst.de ([213.95.11.211]:38134 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236526AbhCXR7k (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Mar 2021 13:59:40 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 1EF6868B05; Wed, 24 Mar 2021 18:59:38 +0100 (CET)
Date:   Wed, 24 Mar 2021 18:59:37 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: simplify the perage inode walk infrastructure
Message-ID: <20210324175937.GA14862@lst.de>
References: <20210324070307.908462-1-hch@lst.de> <20210324070307.908462-3-hch@lst.de> <20210324175735.GX22100@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210324175735.GX22100@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 24, 2021 at 10:57:35AM -0700, Darrick J. Wong wrote:
> On Wed, Mar 24, 2021 at 08:03:06AM +0100, Christoph Hellwig wrote:
> > Remove the generic xfs_inode_walk and just open code the only caller.
> 
> This is going in the wrong direction for me.  Maybe.
> 
> I was planning to combine the reclaim inode walk into this function, and
> later on share it with inactivation.  This made for one switch-happy
> iteration function, but it meant there was only one loop.

Ok, we can skip this for now if this gets in your way.  Or I can resend
a different patch 2 that just removes the no tag case for now.

> OFC maybe the point that you and/or Dave were trying to make is that I
> should be doing the opposite, and combining the inactivation loop into
> what is now the (badly misnamed) xfs_reclaim_inodes_ag?  And leave this
> blockgc loop alone?

That is my gut feeling.  No guarantee it actually works out, and given
that I've lead you down the wrong road a few times I already feel guily
ahead of time..
