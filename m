Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC41AC433C1
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:25:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9263C619E4
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:25:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbhCZAZ0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 20:25:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:35856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229664AbhCZAZH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Mar 2021 20:25:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30C8D60C41;
        Fri, 26 Mar 2021 00:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616718307;
        bh=omsdZ4vEgaS1dNgsox4MYupdbW7KUfxDm1MzA5ESK1k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=flgzRs10AiY9tQQ8pOGwBWZ0zgpg0vHVRKbwQxq/JCprubo6RrhyKJpZk4uQX+46/
         rI8c8p8Y/9btnavlzf1TpfgXBWwuVev/vlBZ3a0ao4aWpltA+oaTTZSsT/Z1E/oaxS
         i2KvtA6U7+dYVLXPck0L/ixM6HkIYgSEK21yUbcBPFITTPfDmGb/fQNVBdxY+mSu/Y
         8UMio+iC/8zS4/4wKal1We75yBquj15m9OXq2LSYgfcH0mgamig0k5WHEor23zHP5H
         f7/poZYtTdlr0Npvj/TMBMpI03Y2zbkj62O2LASQWBEuZDe1/+TcA6Wwv7qEmP9J/q
         WtWHWEbS9W8Rg==
Date:   Thu, 25 Mar 2021 17:25:06 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/18] xfs: move the di_nblocks field to struct xfs_inode
Message-ID: <20210326002506.GP4090233@magnolia>
References: <20210324142129.1011766-1-hch@lst.de>
 <20210324142129.1011766-10-hch@lst.de>
 <20210324182241.GG22100@magnolia>
 <20210325083952.GB28146@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210325083952.GB28146@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 25, 2021 at 09:39:52AM +0100, Christoph Hellwig wrote:
> > > @@ -194,7 +194,7 @@ xfs_iformat_btree(
> > >  		     nrecs == 0 ||
> > >  		     XFS_BMDR_SPACE_CALC(nrecs) >
> > >  					XFS_DFORK_SIZE(dip, mp, whichfork) ||
> > > -		     ifp->if_nextents > ip->i_d.di_nblocks) ||
> > > +		     ifp->if_nextents > ip->i_nblocks) ||
> > >  		     level == 0 || level > XFS_BTREE_MAXLEVELS) {
> > 
> > Minor merge conflict here with "xfs: validate ag btree levels using the
> > precomputed values", but I can fix that up.  Everything else looks like
> > a straightforward conversion.
> 
> Is that patch queue up somewhere so that I could rebase ontop of it?

I pushed for-next just now. :)

--D
