Return-Path: <SRS0=ZxTw=CK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA102C433E2
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 14:19:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4ACC2078B
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 14:19:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XtxIE56Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728204AbgIAOTo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 10:19:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728313AbgIAOTY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 10:19:24 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75AB8C06124F
        for <linux-xfs@vger.kernel.org>; Tue,  1 Sep 2020 07:19:02 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id y6so597305plk.10
        for <linux-xfs@vger.kernel.org>; Tue, 01 Sep 2020 07:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v11SjyOsuI/B6VQH0Mb3spC9mABv57EZFh+BrgGZcoA=;
        b=XtxIE56Yug/MNivc566j2wvKbxgIT/9loqDjsMWVEzghxg8TuiKjgRo/YcY0lNAaEw
         BOb1hLfCZxevTwKuX3+it5QFtoubcWYcDbWqktGLC5JWUFFPhlv/YoquStGCMtowI/Ud
         MoaI9QFGQVwtPp7XlH0eWdTngKiXeUDjCc9DrJBVoeNGyiQ952cttHzwBKqDSEcgwY8y
         EXbkESG2NEq2/IaD7DljDrO1hNLkosx2dCFrEhiIuq2eWtT2lemTWHX+m/7Q59tsGgm8
         f0FdrgulAUCjOKF4RdTJQ4TUWE3RZis5u0g9EVTInFigWGdXK4yff2Suj2GGX3OxAHPj
         xeOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v11SjyOsuI/B6VQH0Mb3spC9mABv57EZFh+BrgGZcoA=;
        b=lcBEOEGr/OBFKlIj58ir4Qh0SPvBXas/wK2bbgVCjnUE/Hs0bVnt3Dp56k+q5BhINr
         9aR/s1lWcola/HvuBVgmlFiBh0untzTIW35CgNu8/riGI+smL8pUmJXefL0SrjJcgpjt
         l2PGysrWn/XDPm4OjW5Spf09RLhaKPQvZSEWi6NxZVobj+Xfpc2wurl/0I6kb1lWqMV7
         15XDpbTA5x9zW0ijgB1bCkBveCPcQplJxj9gPRAk5hd6yuFOEZf1+SvEi746xdwXBT9g
         GJT/dWkWiS8Etqx934Sec0p+jrmtQ4PFI9ynJxZ0WGgOcExBi4m8wpoVfODB1j1rAtxe
         vf7Q==
X-Gm-Message-State: AOAM531OSOAm9guaj4ePD31OM6zOWpNehLfX4WDdBY87C7eOoRljDI3V
        iVCQwf4KTGRybqjxcLDvVw0=
X-Google-Smtp-Source: ABdhPJwGLO337z94l5hIfxXWKu7uFRV4zruQBs4NYOpeYJdwVlKleA+YQDPCbw06dE+/Tfep8er2HQ==
X-Received: by 2002:a17:902:7606:: with SMTP id k6mr1626300pll.171.1598969942058;
        Tue, 01 Sep 2020 07:19:02 -0700 (PDT)
Received: from garuda.localnet ([122.171.183.205])
        by smtp.gmail.com with ESMTPSA id gb19sm1699244pjb.38.2020.09.01.07.18.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 07:19:01 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, bfoster@redhat.com
Subject: Re: [PATCH 1/3] xfs: Introduce xfs_iext_max() helper
Date:   Tue, 01 Sep 2020 19:48:03 +0530
Message-ID: <11106167.P8SlRhgUvP@garuda>
In-Reply-To: <20200831204340.GV6096@magnolia>
References: <20200831130010.454-1-chandanrlinux@gmail.com> <20200831130010.454-2-chandanrlinux@gmail.com> <20200831204340.GV6096@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tuesday 1 September 2020 2:13:40 AM IST Darrick J. Wong wrote:
> On Mon, Aug 31, 2020 at 06:30:08PM +0530, Chandan Babu R wrote:
> > xfs_iext_max() returns the maximum number of extents possible for either
> > data fork or attribute fork. This helper will be extended further in a
> > future commit when maximum extent counts associated with data/attribute
> > forks are increased.
> > 
> > No functional changes have been made.
> 
> Hmm....
> 
> > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> > ---
> >  fs/xfs/libxfs/xfs_bmap.c       |  9 ++++-----
> >  fs/xfs/libxfs/xfs_inode_buf.c  |  8 +++-----
> >  fs/xfs/libxfs/xfs_inode_fork.h | 10 ++++++++++
> >  3 files changed, 17 insertions(+), 10 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index dcc8eeecd571..16b983b8977d 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -74,13 +74,12 @@ xfs_bmap_compute_maxlevels(
> >  	 * for both ATTR1 and ATTR2 we have to assume the worst case scenario
> >  	 * of a minimum size available.
> >  	 */
> > -	if (whichfork == XFS_DATA_FORK) {
> > -		maxleafents = MAXEXTNUM;
> > +	maxleafents = xfs_iext_max(&mp->m_sb, whichfork);
> > +	if (whichfork == XFS_DATA_FORK)
> >  		sz = XFS_BMDR_SPACE_CALC(MINDBTPTRS);
> > -	} else {
> > -		maxleafents = MAXAEXTNUM;
> > +	else
> >  		sz = XFS_BMDR_SPACE_CALC(MINABTPTRS);
> > -	}
> > +
> >  	maxrootrecs = xfs_bmdr_maxrecs(sz, 0);
> >  	minleafrecs = mp->m_bmap_dmnr[0];
> >  	minnoderecs = mp->m_bmap_dmnr[1];
> > diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> > index 8d5dd08eab75..5dcd71bfab2e 100644
> > --- a/fs/xfs/libxfs/xfs_inode_buf.c
> > +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> > @@ -369,6 +369,7 @@ xfs_dinode_verify_fork(
> >  	int			whichfork)
> >  {
> >  	uint32_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
> > +	xfs_extnum_t		max_extents;
> >  
> >  	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
> >  	case XFS_DINODE_FMT_LOCAL:
> > @@ -390,12 +391,9 @@ xfs_dinode_verify_fork(
> >  			return __this_address;
> >  		break;
> >  	case XFS_DINODE_FMT_BTREE:
> > -		if (whichfork == XFS_ATTR_FORK) {
> > -			if (di_nextents > MAXAEXTNUM)
> > -				return __this_address;
> > -		} else if (di_nextents > MAXEXTNUM) {
> > +		max_extents = xfs_iext_max(&mp->m_sb, whichfork);
> > +		if (di_nextents > max_extents)
> >  			return __this_address;
> > -		}
> >  		break;
> >  	default:
> >  		return __this_address;
> > diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> > index 4219b01f1034..75e07078967e 100644
> > --- a/fs/xfs/libxfs/xfs_inode_fork.h
> > +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> > @@ -153,6 +153,16 @@ static inline int8_t xfs_ifork_format(struct xfs_ifork *ifp)
> >  	return ifp->if_format;
> >  }
> >  
> > +static inline xfs_extnum_t xfs_iext_max(struct xfs_sb *sbp, int whichfork)
> > +{
> > +	ASSERT(whichfork == XFS_DATA_FORK || whichfork == XFS_ATTR_FORK);
> > +
> > +	if (whichfork == XFS_DATA_FORK)
> > +		return MAXEXTNUM;
> > +	else
> > +		return MAXAEXTNUM;
> 
> ...I kinda wish you /had/ made the functional change to make this return
> MAXEXTNUM for cow forks, even if none of the callers actually care. :)

Ok. I will include that change in the next version.

> 
> --D
> 
> > +}
> > +
> >  struct xfs_ifork *xfs_iext_state_to_fork(struct xfs_inode *ip, int state);
> >  
> >  int		xfs_iformat_data_fork(struct xfs_inode *, struct xfs_dinode *);
> 


-- 
chandan



