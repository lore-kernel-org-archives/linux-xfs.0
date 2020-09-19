Return-Path: <SRS0=s1/4=C4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72931C43464
	for <linux-xfs@archiver.kernel.org>; Sat, 19 Sep 2020 09:44:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B67221D43
	for <linux-xfs@archiver.kernel.org>; Sat, 19 Sep 2020 09:44:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gljLecEr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbgISJoV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 19 Sep 2020 05:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726129AbgISJoV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 19 Sep 2020 05:44:21 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 689BFC0613CE
        for <linux-xfs@vger.kernel.org>; Sat, 19 Sep 2020 02:44:21 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id u9so4287897plk.4
        for <linux-xfs@vger.kernel.org>; Sat, 19 Sep 2020 02:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+0GiWb20Fo0ozxgUcRlIuMSyRE39/HRtkIM2Y6azaJE=;
        b=gljLecErFm6Nvki3WPTpQanyE0NCyejLtq0wMMb7M75L24RDhYOTWuaKbCWyQHL3Fn
         QYDxQq2QiiwTaKmu4zfmB3L00h5gBFEB2Qj6Zu9zAwY+ne+WFIH4vb5pbaJXenmPOydn
         LwxsxHIq1FD1SWdWBqrr2tmWBe6qdPSBlmrfgd+gQmegN+jJ7nbLEM/ajUNVXmzOz9Yb
         yWAX2stnfPz5PnmchK1lNc65wB9f8x995/Rc3gR1UGYT2N1YXHY00a9e+n1k8qfEYFrj
         IyPMXhQOVHIC7FhPei3ufqdzLWZr70b2kJtJgjsDYn/9eZvODCLlaLuQPW+EFwPRuQZS
         aWrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+0GiWb20Fo0ozxgUcRlIuMSyRE39/HRtkIM2Y6azaJE=;
        b=fd90elGtqhWAnFf3SDIcV7nvmuWKdmb8uCKMmNjAxqucbCs+Pz6w5dfPRHPSgyruDe
         0ft/eN1HCyRlrBX6iS2xN2ooivS4D67ZdV+weER6WhLAEySu5clTGuf7+dGJFIcny79V
         B02+8AE5vKw/rR6vbuspqo/OSLejf6eB+aVDisMi5lZY+edQ56pH0jmizlYYT7fan+A4
         mEHM2juHV6fqvG9kep2UFVLz4cqkPvgR1eZvwr0NJ8UR7NKCmNhBtIu5lnsAECFZN0J0
         WzxderN+Hve9TcR6DEYtXx097C8o6Z8LpbBLkLPSWyfQ7n0OvuO6QS30hRP81XGUMFDS
         yGZQ==
X-Gm-Message-State: AOAM532TBIm9TZPjRshKPI5jjNvmXY1m8vz+cvUQao7IcT/ZDa+TTA/b
        90FEiebc1PvwoZ+KezXrihw=
X-Google-Smtp-Source: ABdhPJzVPeYsLazEutshV085kxPSfzRsQXpvHEMsVj1DWZi8cMbw1Yh3SgKFpuOib4JEi/hg5kLxiw==
X-Received: by 2002:a17:90a:9403:: with SMTP id r3mr17125720pjo.52.1600508660957;
        Sat, 19 Sep 2020 02:44:20 -0700 (PDT)
Received: from garuda.localnet ([122.171.63.16])
        by smtp.gmail.com with ESMTPSA id x27sm6152745pfp.128.2020.09.19.02.44.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2020 02:44:20 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V4 09/10] xfs: Check for extent overflow when swapping extents
Date:   Sat, 19 Sep 2020 15:14:15 +0530
Message-ID: <3954085.OgdnWmroVg@garuda>
In-Reply-To: <20200918154445.GY7955@magnolia>
References: <20200918094759.2727564-1-chandanrlinux@gmail.com> <20200918094759.2727564-10-chandanrlinux@gmail.com> <20200918154445.GY7955@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Friday 18 September 2020 9:14:45 PM IST Darrick J. Wong wrote:
> On Fri, Sep 18, 2020 at 03:17:58PM +0530, Chandan Babu R wrote:
> > Removing an initial range of source/donor file's extent and adding a new
> > extent (from donor/source file) in its place will cause extent count to
> > increase by 1.
> > 
> > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> > ---
> >  fs/xfs/libxfs/xfs_bmap.c       | 18 +++++++++---------
> >  fs/xfs/libxfs/xfs_bmap.h       |  1 +
> >  fs/xfs/libxfs/xfs_inode_fork.h |  7 +++++++
> >  fs/xfs/xfs_bmap_util.c         | 17 +++++++++++++++++
> >  4 files changed, 34 insertions(+), 9 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index 51c2d2690f05..9c665e379dfc 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -6104,15 +6104,6 @@ xfs_bmap_split_extent(
> >  	return error;
> >  }
> >  
> > -/* Deferred mapping is only for real extents in the data fork. */
> > -static bool
> > -xfs_bmap_is_update_needed(
> > -	struct xfs_bmbt_irec	*bmap)
> > -{
> > -	return  bmap->br_startblock != HOLESTARTBLOCK &&
> > -		bmap->br_startblock != DELAYSTARTBLOCK;
> > -}
> > -
> >  /* Record a bmap intent. */
> >  static int
> >  __xfs_bmap_add(
> > @@ -6144,6 +6135,15 @@ __xfs_bmap_add(
> >  	return 0;
> >  }
> >  
> > +/* Deferred mapping is only for real extents in the data fork. */
> > +bool
> > +xfs_bmap_is_update_needed(
> > +	struct xfs_bmbt_irec	*bmap)
> > +{
> > +	return  bmap->br_startblock != HOLESTARTBLOCK &&
> > +		bmap->br_startblock != DELAYSTARTBLOCK;
> > +}
> 
> I think the predicate you want below is xfs_bmap_is_real_extent().

Yes, that is indeed correct. I will fix this one too.

> 
> (I think that mostly because I'm going to kill this predicate entirely
> in a patch for the next cycle, because it is redundant and
> _is_real_extent is a better name.)
> 
> --D
> 
> > +
> >  /* Map an extent into a file. */
> >  void
> >  xfs_bmap_map_extent(
> > diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> > index e1bd484e5548..60fbe184d5f4 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.h
> > +++ b/fs/xfs/libxfs/xfs_bmap.h
> > @@ -263,6 +263,7 @@ struct xfs_bmap_intent {
> >  	struct xfs_bmbt_irec			bi_bmap;
> >  };
> >  
> > +bool	xfs_bmap_is_update_needed(struct xfs_bmbt_irec *bmap);
> >  int	xfs_bmap_finish_one(struct xfs_trans *tp, struct xfs_inode *ip,
> >  		enum xfs_bmap_intent_type type, int whichfork,
> >  		xfs_fileoff_t startoff, xfs_fsblock_t startblock,
> > diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> > index ded3c1b56c94..837c01595439 100644
> > --- a/fs/xfs/libxfs/xfs_inode_fork.h
> > +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> > @@ -102,6 +102,13 @@ struct xfs_ifork {
> >  #define XFS_IEXT_REFLINK_REMAP_CNT(smap_real, dmap_written) \
> >  	(((smap_real) ? 1 : 0) + ((dmap_written) ? 1 : 0))
> >  
> > +/*
> > + * Removing an initial range of source/donor file's extent and adding a new
> > + * extent (from donor/source file) in its place will cause extent count to
> > + * increase by 1.
> > + */
> > +#define XFS_IEXT_SWAP_RMAP_CNT		(1)
> > +
> >  /*
> >   * Fork handling.
> >   */
> > diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> > index 0776abd0103c..542f990247c4 100644
> > --- a/fs/xfs/xfs_bmap_util.c
> > +++ b/fs/xfs/xfs_bmap_util.c
> > @@ -28,6 +28,7 @@
> >  #include "xfs_icache.h"
> >  #include "xfs_iomap.h"
> >  #include "xfs_reflink.h"
> > +#include "xfs_bmap.h"
> >  
> >  /* Kernel only BMAP related definitions and functions */
> >  
> > @@ -1407,6 +1408,22 @@ xfs_swap_extent_rmap(
> >  					irec.br_blockcount);
> >  			trace_xfs_swap_extent_rmap_remap_piece(tip, &uirec);
> >  
> > +			if (xfs_bmap_is_update_needed(&uirec)) {
> > +				error = xfs_iext_count_may_overflow(ip,
> > +						XFS_DATA_FORK,
> > +						XFS_IEXT_SWAP_RMAP_CNT);
> > +				if (error)
> > +					goto out;
> > +			}
> > +
> > +			if (xfs_bmap_is_update_needed(&irec)) {
> > +				error = xfs_iext_count_may_overflow(tip,
> > +						XFS_DATA_FORK,
> > +						XFS_IEXT_SWAP_RMAP_CNT);
> > +				if (error)
> > +					goto out;
> > +			}
> > +
> >  			/* Remove the mapping from the donor file. */
> >  			xfs_bmap_unmap_extent(tp, tip, &uirec);
> >  
> 


-- 
chandan



