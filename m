Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CBA9C47094
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Jun 2021 00:14:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AEBE61182
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Jun 2021 00:14:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbhFHAQl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Jun 2021 20:16:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:43424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230239AbhFHAQl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 7 Jun 2021 20:16:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15D6361168;
        Tue,  8 Jun 2021 00:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623111289;
        bh=Q8NwLrIGkXH3BSrE6LTsDO5A/zEUp4rznEz+7ioZi3c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Crvddb8Bsnf+T7EeSzbENb5luXKJLGGq5Hyh11cG3nkrZWhB1iUZAPbbM8cMp26HQ
         ANYukKVjvph5H3wYDVsp3axXl/gBhrtb3R8RKXUBteM2dFYST5lOjLZkvgXA0dNo+7
         u0o5a85svF7HxJ1YdsJ+qtFeUg7nAfuVd13CcRKbAlNT46XhUovdRttqYour86sovF
         M8JJNHxPGgCpTine23h2jQZckn2E7n7PDyTQPwtlFK1xI2raTbr8/IzfMheFI/pm5G
         RloCr4Qk8HH1zc/L/M7vfWIqn0+IltB8Rb/eWeURcK6C6d3pZb09sPJ/jYCg0S/EWc
         kIzPcF0V+akww==
Date:   Mon, 7 Jun 2021 17:14:48 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 1/9] xfs: refactor the inode recycling code
Message-ID: <20210608001448.GO2945738@locust>
References: <162310469340.3465262.504398465311182657.stgit@locust>
 <162310469929.3465262.17904743035514961089.stgit@locust>
 <20210607225906.GF664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210607225906.GF664593@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 08, 2021 at 08:59:06AM +1000, Dave Chinner wrote:
> On Mon, Jun 07, 2021 at 03:24:59PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Hoist the code in xfs_iget_cache_hit that restores the VFS inode state
> > to an xfs_inode that was previously vfs-destroyed.  The next patch will
> > add a new set of state flags, so we need the helper to avoid
> > duplication.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_icache.c |  139 ++++++++++++++++++++++++++++++---------------------
> >  1 file changed, 81 insertions(+), 58 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > index 4e4682879bbd..4d4aa61fbd34 100644
> > --- a/fs/xfs/xfs_icache.c
> > +++ b/fs/xfs/xfs_icache.c
> > @@ -350,19 +350,19 @@ xfs_inew_wait(
> >   * need to retain across reinitialisation, and rewrite them into the VFS inode
> >   * after reinitialisation even if it fails.
> >   */
> > -static int
> > +static inline int
> >  xfs_reinit_inode(
> >  	struct xfs_mount	*mp,
> >  	struct inode		*inode)
> 
> Don't use inline here as it's a pretty big function - it's a static
> function so let the compiler decide if inlining is worth it.

Fixed.

--D

> Otherwise looks ok.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> -- 
> Dave Chinner
> david@fromorbit.com
