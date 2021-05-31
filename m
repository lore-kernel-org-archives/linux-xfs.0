Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AAA2C47082
	for <linux-xfs@archiver.kernel.org>; Mon, 31 May 2021 23:33:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B5D361263
	for <linux-xfs@archiver.kernel.org>; Mon, 31 May 2021 23:33:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231377AbhEaXe6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 May 2021 19:34:58 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:33157 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231240AbhEaXe6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 May 2021 19:34:58 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id E18881AFAEF;
        Tue,  1 Jun 2021 09:33:15 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lnrPH-007VKN-CG; Tue, 01 Jun 2021 09:33:15 +1000
Date:   Tue, 1 Jun 2021 09:33:15 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 1/3] xfs: set ip->i_diflags directly in
 xfs_inode_inherit_flags
Message-ID: <20210531233315.GU664593@dread.disaster.area>
References: <162250083252.490289.17618066691063888710.stgit@locust>
 <162250083819.490289.18171121927859927558.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162250083819.490289.18171121927859927558.stgit@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=f7DJSmP6-BUUW_P8gQQA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 31, 2021 at 03:40:38PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Remove the unnecessary convenience variable.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_inode.c |   25 +++++++++++--------------
>  1 file changed, 11 insertions(+), 14 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index e4c2da4566f1..1e28997c6f78 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -689,47 +689,44 @@ xfs_inode_inherit_flags(
>  	struct xfs_inode	*ip,
>  	const struct xfs_inode	*pip)
>  {
> -	unsigned int		di_flags = 0;
>  	xfs_failaddr_t		failaddr;
>  	umode_t			mode = VFS_I(ip)->i_mode;
>  
>  	if (S_ISDIR(mode)) {
>  		if (pip->i_diflags & XFS_DIFLAG_RTINHERIT)
> -			di_flags |= XFS_DIFLAG_RTINHERIT;
> +			ip->i_diflags |= XFS_DIFLAG_RTINHERIT;
>  		if (pip->i_diflags & XFS_DIFLAG_EXTSZINHERIT) {
> -			di_flags |= XFS_DIFLAG_EXTSZINHERIT;
> +			ip->i_diflags |= XFS_DIFLAG_EXTSZINHERIT;
>  			ip->i_extsize = pip->i_extsize;
>  		}

Hmmmm.

IIRC, these functions were originally written this way because the
compiler generated much better code using a local variable than when
writing directly to the ip->i_d.di_flags. Is this still true now?
I think it's worth checking, because we have changed the structure
of the xfs_inode (removed the i_d structure) so maybe this isn't a
concern anymore?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
