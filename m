Return-Path: <SRS0=6RgE=4M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16A59C38BE2
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 19:56:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA30A21556
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 19:56:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbgBXT4S (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 14:56:18 -0500
Received: from verein.lst.de ([213.95.11.211]:40054 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726593AbgBXT4R (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 24 Feb 2020 14:56:17 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id BEB1A68B05; Mon, 24 Feb 2020 20:56:15 +0100 (CET)
Date:   Mon, 24 Feb 2020 20:56:15 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 09/31] xfs: move struct xfs_da_args to xfs_types.h
Message-ID: <20200224195615.GA10432@lst.de>
References: <20200221141154.476496-1-hch@lst.de> <20200221141154.476496-10-hch@lst.de> <20200221225728.GX10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200221225728.GX10776@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Feb 22, 2020 at 09:57:28AM +1100, Dave Chinner wrote:
> On Fri, Feb 21, 2020 at 06:11:32AM -0800, Christoph Hellwig wrote:
> > To allow passing a struct xfs_da_args to the high-level attr helpers
> > it needs to be easily includable by files like xfs_xattr.c.  Move the
> > struct definition to xfs_types.h to allow for that.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_da_btree.h | 64 ------------------------------------
> >  fs/xfs/libxfs/xfs_types.h    | 60 +++++++++++++++++++++++++++++++++
> >  2 files changed, 60 insertions(+), 64 deletions(-)
> 
> This seems way too broad. Stuff in fs/xfs/libxfs/xfs_types.h is
> really for fundamental XFS types, not for complex, subsystem
> specific API structures.
> 
> Why can't the xattr code simply include what it needs to get this
> structure from xfs_da_btree.h like everything else does?  Indeed,
> fs/xfs/xfs_xattr.c already includes xfs_da_format.h, so it should be
> able to directly include xfs_da_btree.h without much extra hassle.
> 
> Hence I don't really see why making this structure globally visible
> is actually necessary, especially as the function prototypes in
> header files can simply use a forward declaration of struct
> xfs_da_args....

Forward declarations aren't the problem, but I wanted to avoid having
to pull xfs_da_btree.h into all users of the external xattr API.  It
turns out that is just three new files, so it probably isn't too bad.

I have a new tree with this move dropped, but I'm going to wait a little
before I resend to see if there are any other comments.
