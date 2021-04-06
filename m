Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1D65C433B4
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Apr 2021 13:54:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC5E2613BD
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Apr 2021 13:54:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234151AbhDFNyt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Apr 2021 09:54:49 -0400
Received: from verein.lst.de ([213.95.11.211]:54590 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344778AbhDFNyt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Apr 2021 09:54:49 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id DC95268B02; Tue,  6 Apr 2021 15:54:39 +0200 (CEST)
Date:   Tue, 6 Apr 2021 15:54:39 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] xfs: move the XFS_IFEXTENTS check into
 xfs_iread_extents
Message-ID: <20210406135439.GA3569@lst.de>
References: <20210402142409.372050-1-hch@lst.de> <20210402142409.372050-2-hch@lst.de> <20210406135106.GE3957620@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210406135106.GE3957620@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 06, 2021 at 06:51:06AM -0700, Darrick J. Wong wrote:
> > index 5574d345d066ed..b8cab14ca8ce8d 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -1223,6 +1223,9 @@ xfs_iread_extents(
> >  
> >  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> 
> Since we now call xfs_iread_extents unconditionally, this assert will
> trip every time someone wants to bmapi_read the extent data after the
> extent data has been loaded in, because xfs_ilock_data_map_shared tells
> callers they only need to take ILOCK_SHARED... right?

Yes.  I've already moved this down in my local tree, as xfstests
generic/001 hits this once XFS_DEBUG is enabled.  I also had to fix
the inode variable name in a few places to even make that config compile.
As said this was _very_ lightly tested - I only did a quick run on a
non-debug config, but that passed with flying colors :)
