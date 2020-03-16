Return-Path: <SRS0=1m5L=5B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2541FC0044D
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 14:48:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 084CD20719
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 14:48:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731579AbgCPOso (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Mar 2020 10:48:44 -0400
Received: from verein.lst.de ([213.95.11.211]:54751 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731549AbgCPOso (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 16 Mar 2020 10:48:44 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 5BA0D68BFE; Mon, 16 Mar 2020 15:48:42 +0100 (CET)
Date:   Mon, 16 Mar 2020 15:48:42 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: only check the superblock version for dinode
 size calculation
Message-ID: <20200316144842.GB19966@lst.de>
References: <20200312142235.550766-1-hch@lst.de> <20200312142235.550766-3-hch@lst.de> <20200316131707.GF12313@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316131707.GF12313@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 16, 2020 at 09:17:07AM -0400, Brian Foster wrote:
> > diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> > index ad2b9c313fd2..518c6f0ec3a6 100644
> > --- a/fs/xfs/libxfs/xfs_inode_fork.c
> > +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> > @@ -183,7 +183,7 @@ xfs_iformat_local(
> >  	 */
> >  	if (unlikely(size > XFS_DFORK_SIZE(dip, ip->i_mount, whichfork))) {
> >  		xfs_warn(ip->i_mount,
> > -	"corrupt inode %Lu (bad size %d for local fork, size = %d).",
> > +	"corrupt inode %Lu (bad size %d for local fork, size = %zd).",
> 
> Is this here intentionally? Otherwise seems fine:

Yes.  XFS_DFORK_SIZE now returns a size_t, so the format strings needs
to match.
