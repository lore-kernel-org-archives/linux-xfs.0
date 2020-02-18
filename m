Return-Path: <SRS0=Vmdp=4G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB3D8C34026
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Feb 2020 15:48:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F0AB22527
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Feb 2020 15:48:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbgBRPs7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Feb 2020 10:48:59 -0500
Received: from verein.lst.de ([213.95.11.211]:38844 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726338AbgBRPs7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Feb 2020 10:48:59 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6ABB668C7B; Tue, 18 Feb 2020 16:48:57 +0100 (CET)
Date:   Tue, 18 Feb 2020 16:48:56 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>
Subject: Re: [PATCH 30/31] xfs: remove XFS_DA_OP_INCOMPLETE
Message-ID: <20200218154856.GD21780@lst.de>
References: <20200217125957.263434-1-hch@lst.de> <20200217125957.263434-31-hch@lst.de> <20200218022334.GD10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218022334.GD10776@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 18, 2020 at 01:23:34PM +1100, Dave Chinner wrote:
> > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > index d5c112b6dcdd..23e0d8ce39f8 100644
> > --- a/fs/xfs/libxfs/xfs_attr.c
> > +++ b/fs/xfs/libxfs/xfs_attr.c
> > @@ -898,7 +898,7 @@ xfs_attr_node_addname(
> >  		 * The INCOMPLETE flag means that we will find the "old"
> >  		 * attr, not the "new" one.
> >  		 */
> > -		args->op_flags |= XFS_DA_OP_INCOMPLETE;
> > +		args->attr_namespace |= XFS_ATTR_INCOMPLETE;
> 
> So args->attr_namespace is no longer an indication of what attribute
> namespace to look up? Unless you are now defining incomplete
> attributes to be in a namespace?

It is the same field on disk.

> If so, I think this needs more explanation than "we can use the
> on-disk format directly instead". That's just telling me what the
> patch is doing and doesn't explain why we are considering this
> specific on disk flag to indicate a new type of "namespace" for
> attributes lookups. Hence I think this needs more documentation in
> both the commit and the code as the definition of
> XFS_ATTR_INCOMPLETE doesn't really make it clear that this is now
> considered a namespace signifier...

Ok.  Also if anyone has a better name for the field, suggestions welcome..
