Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6204CC4708F
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 01:27:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A385613EB
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 01:27:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbhFCB3D (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Jun 2021 21:29:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:47550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229568AbhFCB3C (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 2 Jun 2021 21:29:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00F83613BF;
        Thu,  3 Jun 2021 01:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622683639;
        bh=uj3mY5psUjiCx6Dg04PumYLCPc3KZWQEDbey+W++9nA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g2kA2TM4d0AM0WVeEGJYjBIMtExxq1wAKC9NbAloRT/aghECSuWNg8lq3y3Ar+NGj
         iaglqwhULB+ctv1ZvaMEBxXuNa8Vi9V4nxjvTsRDjgCigpX3ULESg2ejaMvK3arIaD
         ZeRwLAaKnLhLGAJjrAzwMfXoptNejgClUGLOs0g1ZFa4rjEPOkSE84EZW6TFUfk6jS
         KukTBcKrQbKeBFFhWA27wg+atHx9VtcdmDy7oK+pOOh9k5hjhX29DBn9RW5h76QEIs
         aQ7IHL1erDYf5YkEjPcbK1nsPYikWMAPlcFBS7PbfvfRl359qLHU1QneTVt30bgZeq
         rbAa76ovs+BbQ==
Date:   Wed, 2 Jun 2021 18:27:18 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 15/15] xfs: refactor per-AG inode tagging functions
Message-ID: <20210603012718.GR26380@locust>
References: <162267269663.2375284.15885514656776142361.stgit@locust>
 <162267277981.2375284.3555542495306293304.stgit@locust>
 <20210603011616.GK664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210603011616.GK664593@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 03, 2021 at 11:16:16AM +1000, Dave Chinner wrote:
> On Wed, Jun 02, 2021 at 03:26:19PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > In preparation for adding another incore inode tree tag, refactor the
> > code that sets and clears tags from the per-AG inode tree and the tree
> > of per-AG structures, and remove the open-coded versions used by the
> > blockgc code.
> > 
> > Note: For reclaim, we now rely on the radix tree tags instead of the
> > reclaimable inode count more heavily than we used to.  The conversion
> > should be fine, but the logic isn't 100% identical.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_icache.c |  158 +++++++++++++++++++++++++--------------------------
> >  fs/xfs/xfs_icache.h |    2 -
> >  fs/xfs/xfs_super.c  |    2 -
> >  fs/xfs/xfs_trace.h  |    6 +-
> >  4 files changed, 80 insertions(+), 88 deletions(-)
> 
> LGTM.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Woo, thanks for reviewing!

--D

> -- 
> Dave Chinner
> david@fromorbit.com
