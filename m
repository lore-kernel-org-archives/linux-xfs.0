Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8683C47080
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Jun 2021 00:47:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B74CF6128A
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Jun 2021 00:47:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232356AbhFAAtX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 May 2021 20:49:23 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:37528 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232183AbhFAAtX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 May 2021 20:49:23 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 6735A6764A;
        Tue,  1 Jun 2021 10:47:40 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lnsZH-007WTo-SU; Tue, 01 Jun 2021 10:47:39 +1000
Date:   Tue, 1 Jun 2021 10:47:39 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 5/5] xfs: move xfs_inew_wait call into xfs_dqrele_inode
Message-ID: <20210601004739.GA664593@dread.disaster.area>
References: <162250085103.490412.4291071116538386696.stgit@locust>
 <162250087868.490412.809961177992047138.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162250087868.490412.809961177992047138.stgit@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=F6fRWN01BkR3Eer-cnYA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 31, 2021 at 03:41:18PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Move the INEW wait into xfs_dqrele_inode so that we can drop the
> iter_flags parameter in the next patch.

What next patch? :/

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_icache.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 5501318b5db0..859ab1279d8d 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -981,6 +981,9 @@ xfs_dqrele_inode(
>  {
>  	struct xfs_eofblocks	*eofb = priv;
>  
> +	if (xfs_iflags_test(ip, XFS_INEW))
> +		xfs_inew_wait(ip);
> +
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	if (eofb->eof_flags & XFS_EOFB_DROP_UDQUOT) {
>  		xfs_qm_dqrele(ip->i_udquot);
> @@ -1019,8 +1022,8 @@ xfs_dqrele_all_inodes(
>  	if (qflags & XFS_PQUOTA_ACCT)
>  		eofb.eof_flags |= XFS_EOFB_DROP_PDQUOT;
>  
> -	return xfs_inode_walk(mp, XFS_INODE_WALK_INEW_WAIT, xfs_dqrele_inode,
> -			&eofb, XFS_ICI_DQRELE_NONTAG);
> +	return xfs_inode_walk(mp, 0, xfs_dqrele_inode, &eofb,
> +			XFS_ICI_DQRELE_NONTAG);
>  }

In isolation, this doesn't mean a whole lot. It seems somewhat
related to the earlier patch that kinda duplicated
xfs_inode_walk_ag_grab(), and it looks like this removes the only
user of XFS_INODE_WALK_INEW_WAIT, so does the missing next patch
remove XFS_INODE_WALK_INEW_WAIT and the rest of the that machinery?

If so, this seems like it should follow up the earlier patch or even
precede it, because getting rid of XFS_INODE_WALK_INEW_WAIT first
means that xfs_inode_walk_ag_grab() and xfs_inode_walk_dquot_grab()
are then identical....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
