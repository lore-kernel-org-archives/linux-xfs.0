Return-Path: <SRS0=e/GO=67=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 367A3C433DF
	for <linux-xfs@archiver.kernel.org>; Sun, 17 May 2020 08:12:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 140EC2065F
	for <linux-xfs@archiver.kernel.org>; Sun, 17 May 2020 08:12:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbgEQIMx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 17 May 2020 04:12:53 -0400
Received: from verein.lst.de ([213.95.11.211]:34305 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727021AbgEQIMx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 17 May 2020 04:12:53 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 00A2068C4E; Sun, 17 May 2020 10:12:50 +0200 (CEST)
Date:   Sun, 17 May 2020 10:12:50 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs: move the per-fork nextents fields into struct
 xfs_ifork
Message-ID: <20200517081250.GA30912@lst.de>
References: <20200510072404.986627-1-hch@lst.de> <20200510072404.986627-5-hch@lst.de> <20200512161053.GH37029@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512161053.GH37029@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 12, 2020 at 12:10:53PM -0400, Brian Foster wrote:
> >  	ip->i_d.di_forkoff = 0;
> >  	ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
> >  
> > -	ASSERT(ip->i_d.di_anextents == 0);
> 
> Perhaps we could create an analogous assert in xfs_idestroy_fork()?

Added for the next version.

> > @@ -229,6 +228,8 @@ xfs_iformat_data_fork(
> >  	struct inode		*inode = VFS_I(ip);
> >  	int			error;
> >  
> > +	ip->i_df.if_nextents = be32_to_cpu(dip->di_nextents);
> > +
> 
> Could use a comment here that the format calls below might depend on
> this being set (i.e. xfs_iformat_btree() just above).

> >  	ip->i_afp = kmem_zone_zalloc(xfs_ifork_zone, KM_NOFS);
> > +	ip->i_afp->if_nextents = be16_to_cpu(dip->di_anextents);
> > +
> 
> Same here. Otherwise LGTM:

Sure.

