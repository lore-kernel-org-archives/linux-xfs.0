Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74C01C4338F
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Aug 2021 07:22:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C0516101E
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Aug 2021 07:22:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237270AbhHNHXC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 14 Aug 2021 03:23:02 -0400
Received: from verein.lst.de ([213.95.11.211]:49460 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237404AbhHNHW6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 14 Aug 2021 03:22:58 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 91EC967373; Sat, 14 Aug 2021 09:22:28 +0200 (CEST)
Date:   Sat, 14 Aug 2021 09:22:28 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] xfs: remove support for untagged lookups in xfs_icwalk*
Message-ID: <20210814072228.GA21175@lst.de>
References: <20210813081623.83323-1-hch@lst.de> <20210813162636.GX3601443@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210813162636.GX3601443@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 13, 2021 at 09:26:36AM -0700, Darrick J. Wong wrote:
> On Fri, Aug 13, 2021 at 10:16:23AM +0200, Christoph Hellwig wrote:
> > With quotaoff not allowing disabling of accounting there is no need
> > for untagged lookups in this code, so remove the dead leftovers.
> > 
> > Repoted-by: Dan Carpenter <dan.carpenter@oracle.com>
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/xfs_icache.c | 39 ++++-----------------------------------
> >  1 file changed, 4 insertions(+), 35 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > index e7e69e55b7680a..f5a52ec084842d 100644
> > --- a/fs/xfs/xfs_icache.c
> > +++ b/fs/xfs/xfs_icache.c
> > @@ -43,15 +43,6 @@ enum xfs_icwalk_goal {
> 
> The patch itself looks fine, so
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
> But you might as well convert the ag walk to use the foreach macros
> like everywhere else:

True, this makes sense for consistency.  That being said, comparing the
two, I find the one without the extra layer of macro sugar way easier
to read.
