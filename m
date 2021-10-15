Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 967B1C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Oct 2021 00:44:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78334610D1
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Oct 2021 00:44:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233814AbhJOAqG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Oct 2021 20:46:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:57070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234622AbhJOAqG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Oct 2021 20:46:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC6AF6108B;
        Fri, 15 Oct 2021 00:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634258640;
        bh=vL/CqdqQ3UzdMQwGJUIpvLwPAaLATob8/3SFMvOb+vo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Rtu2UgdnGGWElaszgXGLZxY8itjd9Vi8Dk0zvaBMpHH0nRLvUhUK4AGSz8QCRWhOD
         De7G1ASQTwgiCLnDVttEKHnEtq0M7YvGQAp3zjR5LPXyhVLoW9b2Gph3kTxcMwX2ru
         kFH1n9ILkdKuLSbQUli6oOZVz4qiB2Py3jcenm6F8IvM53XcTnVRhGBTKCgyt1je9a
         0j+akuWH2zIZhZc6rhBTd92U2MPNGpcq8U0aVDQWb+JqIqFoibu54ZwWd4AM+P1/0m
         6Cz2ErRVbMYotAWu4zUroeIfN1mid+YO8xLyleJgEX1dC0Re3Wnfa71QJg9iJlOO2X
         S+De/M4mrSfuw==
Date:   Thu, 14 Oct 2021 17:44:00 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, chandan.babu@oracle.com, hch@lst.de
Subject: Re: [PATCH 11/17] xfs: rename m_ag_maxlevels to m_allocbt_maxlevels
Message-ID: <20211015004400.GP24307@magnolia>
References: <163424261462.756780.16294781570977242370.stgit@magnolia>
 <163424267542.756780.9763514054029645043.stgit@magnolia>
 <20211014225210.GQ2361455@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211014225210.GQ2361455@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 15, 2021 at 09:52:10AM +1100, Dave Chinner wrote:
> On Thu, Oct 14, 2021 at 01:17:55PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Years ago when XFS was thought to be much more simple, we introduced
> > m_ag_maxlevels to specify the maximum btree height of per-AG btrees for
> > a given filesystem mount.  Then we observed that inode btrees don't
> > actually have the same height and split that off; and now we have rmap
> > and refcount btrees with much different geometries and separate
> > maxlevels variables.
> > 
> > The 'ag' part of the name doesn't make much sense anymore, so rename
> > this to m_allocbt_maxlevels to reinforce that this is the maximum height
>                  ^^
> You named it m_alloc_maxlevels....

Oops, fixed.

--D

> > of the *free space* btrees.  This sets us up for the next patch, which
> > will add a variable to track the maximum height of all AG btrees.
> > 
> > (Also take the opportunity to improve adjacent comments and fix minor
> > style problems.)
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/libxfs/xfs_alloc.c       |   19 +++++++++++--------
> >  fs/xfs/libxfs/xfs_alloc.h       |    2 +-
> >  fs/xfs/libxfs/xfs_alloc_btree.c |    4 ++--
> >  fs/xfs/libxfs/xfs_trans_resv.c  |    2 +-
> >  fs/xfs/libxfs/xfs_trans_space.h |    2 +-
> >  fs/xfs/scrub/agheader.c         |    4 ++--
> >  fs/xfs/scrub/agheader_repair.c  |    4 ++--
> >  fs/xfs/xfs_mount.h              |    4 ++--
> >  8 files changed, 22 insertions(+), 19 deletions(-)
> 
> Other than that minor nit, the change looks good.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> -- 
> Dave Chinner
> david@fromorbit.com
