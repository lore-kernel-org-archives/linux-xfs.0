Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F10F2C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 22:52:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D11BA60FC3
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 22:52:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234030AbhJNWyS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Oct 2021 18:54:18 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:44080 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229818AbhJNWyR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Oct 2021 18:54:17 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 0AE621056973;
        Fri, 15 Oct 2021 09:52:10 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mb9a6-006JJy-GS; Fri, 15 Oct 2021 09:52:10 +1100
Date:   Fri, 15 Oct 2021 09:52:10 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, chandan.babu@oracle.com, hch@lst.de
Subject: Re: [PATCH 11/17] xfs: rename m_ag_maxlevels to m_allocbt_maxlevels
Message-ID: <20211014225210.GQ2361455@dread.disaster.area>
References: <163424261462.756780.16294781570977242370.stgit@magnolia>
 <163424267542.756780.9763514054029645043.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163424267542.756780.9763514054029645043.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6168b49b
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=kj9zAlcOel0A:10 a=8gfv0ekSlNoA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=OIoMw9GURJmODzhGyI8A:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 14, 2021 at 01:17:55PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Years ago when XFS was thought to be much more simple, we introduced
> m_ag_maxlevels to specify the maximum btree height of per-AG btrees for
> a given filesystem mount.  Then we observed that inode btrees don't
> actually have the same height and split that off; and now we have rmap
> and refcount btrees with much different geometries and separate
> maxlevels variables.
> 
> The 'ag' part of the name doesn't make much sense anymore, so rename
> this to m_allocbt_maxlevels to reinforce that this is the maximum height
                 ^^
You named it m_alloc_maxlevels....

> of the *free space* btrees.  This sets us up for the next patch, which
> will add a variable to track the maximum height of all AG btrees.
> 
> (Also take the opportunity to improve adjacent comments and fix minor
> style problems.)
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_alloc.c       |   19 +++++++++++--------
>  fs/xfs/libxfs/xfs_alloc.h       |    2 +-
>  fs/xfs/libxfs/xfs_alloc_btree.c |    4 ++--
>  fs/xfs/libxfs/xfs_trans_resv.c  |    2 +-
>  fs/xfs/libxfs/xfs_trans_space.h |    2 +-
>  fs/xfs/scrub/agheader.c         |    4 ++--
>  fs/xfs/scrub/agheader_repair.c  |    4 ++--
>  fs/xfs/xfs_mount.h              |    4 ++--
>  8 files changed, 22 insertions(+), 19 deletions(-)

Other than that minor nit, the change looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
