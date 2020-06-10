Return-Path: <SRS0=2CQE=7X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D74CDC433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Jun 2020 06:24:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA3E220760
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Jun 2020 06:24:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hdidln+R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726081AbgFJGY2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Jun 2020 02:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgFJGY2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Jun 2020 02:24:28 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEE47C03E96B
        for <linux-xfs@vger.kernel.org>; Tue,  9 Jun 2020 23:24:27 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id j1so664715pfe.4
        for <linux-xfs@vger.kernel.org>; Tue, 09 Jun 2020 23:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=As5DYQ6SHOw1wjwTJoWa7310GGCu5VSjCa+ORD94Zwc=;
        b=hdidln+R4i8hAzeBAkU3YImRmtjAtJan4XsJ28Ljqh2G3hhSFbbVDNwY/waGLC3o6v
         RaHdVwtZl0xfPISLkDEd1+4gzHDU6dkkyFo5g1IbhS/Hu380knTL+ugjFs7rApCMp+Du
         kClLcpA0PRTJPWYrq1Vls51CytGarVK4CRSW2CtPYrBiXB5uEBwPDrOOvrb2hbDGGqaW
         GLUnnOVjUJJfhKzgbuh9p9sV0ADGtcDcl/aUjrn4MMB2cmqfOPMaIyYl9cOgcyVw8FrA
         nuBowepRg/X2mOpN+7EXsoBRTyhuMD9tjwtY250EiwhenfPGQvq37pxFtL1Pr3wiaMHX
         7uEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=As5DYQ6SHOw1wjwTJoWa7310GGCu5VSjCa+ORD94Zwc=;
        b=gxKDP0HmJJuExtbStwG6YMGLdeJ1NJAkeCFyYeY+oRtionWa8Vm39ypG25HJgNalcu
         plZ2JWWbFmLueP3H3lO0CKyp6p55JDgirkFDj2oN2ZSZkGTEjcPPQsoYFgi9dqECqCWZ
         yPDNmWoi8sV75765fCPcnJNeU+FGTDpBkKC9N2GKQASUe03FLPfBRgc3eY0HxZW/PxEu
         gLdBrBYEjuqvXomKuaswbOISnvCCqt6/DSpaMMlP2G+ZA2tbgCVrDcv7mRI9dlmsrrqX
         pC4NthxLccPU33n1fRU0eKokOZvzjvRgO+iKQoarPhe2pAbZlE1rbqvi3vI5b4dlrfaL
         wBpA==
X-Gm-Message-State: AOAM53109UadvxRqqXRSqhwase20umbOWAyRMXkpgfaYywFEvqdLriHq
        s3EAWgE/hTSMyY8a4IKuLg0=
X-Google-Smtp-Source: ABdhPJxp+1Q0FJ5dZMLEFghMVmONGtlSn0yjV4LnewhE6TgR9zAzcMkbwsJoGMTy77GZrLn96eTZ1w==
X-Received: by 2002:a63:d70f:: with SMTP id d15mr1478382pgg.322.1591770267114;
        Tue, 09 Jun 2020 23:24:27 -0700 (PDT)
Received: from garuda.localnet ([122.171.171.148])
        by smtp.gmail.com with ESMTPSA id s197sm11978126pfc.188.2020.06.09.23.24.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2020 23:24:26 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, bfoster@redhat.com,
        hch@infradead.org
Subject: Re: [PATCH 2/7] xfs: Check for per-inode extent count overflow
Date:   Wed, 10 Jun 2020 11:54:13 +0530
Message-ID: <1739746.qGurkL4Txz@garuda>
In-Reply-To: <20200609170734.GA11245@magnolia>
References: <20200606082745.15174-1-chandanrlinux@gmail.com> <6293256.TnI8RiW99x@garuda> <20200609170734.GA11245@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tuesday 9 June 2020 10:37:34 PM IST Darrick J. Wong wrote:
> On Tue, Jun 09, 2020 at 07:52:48PM +0530, Chandan Babu R wrote:
> > On Monday 8 June 2020 10:02:16 PM IST Darrick J. Wong wrote:
> > > On Mon, Jun 08, 2020 at 09:24:25AM -0700, Darrick J. Wong wrote:
> > > > On Sat, Jun 06, 2020 at 01:57:40PM +0530, Chandan Babu R wrote:
> > > > > The following error message was noticed when a workload added one
> > > > > million xattrs, deleted 50% of them and then inserted 400,000 new
> > > > > xattrs.
> > > > > 
> > > > > XFS (loop0): xfs_iflush_int: detected corrupt incore inode 131, total extents = -19916, nblocks = 102937, ptr ffff9ce33b098c00
> > > > > 
> > > > > The error message was printed during unmounting the filesystem. The
> > > > > value printed under "total extents" indicates that we overflowed the
> > > > > per-inode signed 16-bit xattr extent counter.
> > > > > 
> > > > > Instead of letting this silent corruption occur, this patch checks for
> > > > > extent counter (both data and xattr) overflow before we assign the
> > > > > new value to the corresponding in-memory extent counter.
> > > > > 
> > > > > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> > > > > ---
> > > > >  fs/xfs/libxfs/xfs_bmap.c       | 92 +++++++++++++++++++++++++++-------
> > > > >  fs/xfs/libxfs/xfs_inode_fork.c | 29 +++++++++++
> > > > >  fs/xfs/libxfs/xfs_inode_fork.h |  1 +
> > > > >  3 files changed, 104 insertions(+), 18 deletions(-)
> > > > > 
> > > > > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > > > > index edc63dba007f..798fca5c52af 100644
> > > > > --- a/fs/xfs/libxfs/xfs_bmap.c
> > > > > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > > > > @@ -906,7 +906,10 @@ xfs_bmap_local_to_extents(
> > > > >  	xfs_iext_first(ifp, &icur);
> > > > >  	xfs_iext_insert(ip, &icur, &rec, 0);
> > > > >  
> > > > > -	ifp->if_nextents = 1;
> > > > > +	error = xfs_next_set(ip, whichfork, 1);
> > > > > +	if (error)
> > > > > +		goto done;
> > > > 
> > > > Are you sure that if_nextents == 0 is a precondition here?  Technically
> > > > speaking, this turns an assignment into an increment operation.
> > > > 
> > > > > +
> > > > >  	ip->i_d.di_nblocks = 1;
> > > > >  	xfs_trans_mod_dquot_byino(tp, ip,
> > > > >  		XFS_TRANS_DQ_BCOUNT, 1L);
> > > > > @@ -1594,7 +1597,10 @@ xfs_bmap_add_extent_delay_real(
> > > > >  		xfs_iext_remove(bma->ip, &bma->icur, state);
> > > > >  		xfs_iext_prev(ifp, &bma->icur);
> > > > >  		xfs_iext_update_extent(bma->ip, state, &bma->icur, &LEFT);
> > > > > -		ifp->if_nextents--;
> > > > > +
> > > > > +		error = xfs_next_set(bma->ip, whichfork, -1);
> > > > > +		if (error)
> > > > > +			goto done;
> > > > >  
> > > > >  		if (bma->cur == NULL)
> > > > >  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
> > > > > @@ -1698,7 +1704,10 @@ xfs_bmap_add_extent_delay_real(
> > > > >  		PREV.br_startblock = new->br_startblock;
> > > > >  		PREV.br_state = new->br_state;
> > > > >  		xfs_iext_update_extent(bma->ip, state, &bma->icur, &PREV);
> > > > > -		ifp->if_nextents++;
> > > > > +
> > > > > +		error = xfs_next_set(bma->ip, whichfork, 1);
> > > > > +		if (error)
> > > > > +			goto done;
> > > > >  
> > > > >  		if (bma->cur == NULL)
> > > > >  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
> > > > > @@ -1764,7 +1773,10 @@ xfs_bmap_add_extent_delay_real(
> > > > >  		 * The left neighbor is not contiguous.
> > > > >  		 */
> > > > >  		xfs_iext_update_extent(bma->ip, state, &bma->icur, new);
> > > > > -		ifp->if_nextents++;
> > > > > +
> > > > > +		error = xfs_next_set(bma->ip, whichfork, 1);
> > > > > +		if (error)
> > > > > +			goto done;
> > > > >  
> > > > >  		if (bma->cur == NULL)
> > > > >  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
> > > > > @@ -1851,7 +1863,10 @@ xfs_bmap_add_extent_delay_real(
> > > > >  		 * The right neighbor is not contiguous.
> > > > >  		 */
> > > > >  		xfs_iext_update_extent(bma->ip, state, &bma->icur, new);
> > > > > -		ifp->if_nextents++;
> > > > > +
> > > > > +		error = xfs_next_set(bma->ip, whichfork, 1);
> > > > > +		if (error)
> > > > > +			goto done;
> > > > >  
> > > > >  		if (bma->cur == NULL)
> > > > >  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
> > > > > @@ -1937,7 +1952,10 @@ xfs_bmap_add_extent_delay_real(
> > > > >  		xfs_iext_next(ifp, &bma->icur);
> > > > >  		xfs_iext_insert(bma->ip, &bma->icur, &RIGHT, state);
> > > > >  		xfs_iext_insert(bma->ip, &bma->icur, &LEFT, state);
> > > > > -		ifp->if_nextents++;
> > > > > +
> > > > > +		error = xfs_next_set(bma->ip, whichfork, 1);
> > > > > +		if (error)
> > > > > +			goto done;
> > > > >  
> > > > >  		if (bma->cur == NULL)
> > > > >  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
> > > > > @@ -2141,7 +2159,11 @@ xfs_bmap_add_extent_unwritten_real(
> > > > >  		xfs_iext_remove(ip, icur, state);
> > > > >  		xfs_iext_prev(ifp, icur);
> > > > >  		xfs_iext_update_extent(ip, state, icur, &LEFT);
> > > > > -		ifp->if_nextents -= 2;
> > > > > +
> > > > > +		error = xfs_next_set(ip, whichfork, -2);
> > > > > +		if (error)
> > > > > +			goto done;
> > > > > +
> > > > >  		if (cur == NULL)
> > > > >  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
> > > > >  		else {
> > > > > @@ -2193,7 +2215,11 @@ xfs_bmap_add_extent_unwritten_real(
> > > > >  		xfs_iext_remove(ip, icur, state);
> > > > >  		xfs_iext_prev(ifp, icur);
> > > > >  		xfs_iext_update_extent(ip, state, icur, &LEFT);
> > > > > -		ifp->if_nextents--;
> > > > > +
> > > > > +		error = xfs_next_set(ip, whichfork, -1);
> > > > > +		if (error)
> > > > > +			goto done;
> > > > > +
> > > > >  		if (cur == NULL)
> > > > >  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
> > > > >  		else {
> > > > > @@ -2235,7 +2261,10 @@ xfs_bmap_add_extent_unwritten_real(
> > > > >  		xfs_iext_remove(ip, icur, state);
> > > > >  		xfs_iext_prev(ifp, icur);
> > > > >  		xfs_iext_update_extent(ip, state, icur, &PREV);
> > > > > -		ifp->if_nextents--;
> > > > > +
> > > > > +		error = xfs_next_set(ip, whichfork, -1);
> > > > > +		if (error)
> > > > > +			goto done;
> > > > >  
> > > > >  		if (cur == NULL)
> > > > >  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
> > > > > @@ -2343,7 +2372,10 @@ xfs_bmap_add_extent_unwritten_real(
> > > > >  
> > > > >  		xfs_iext_update_extent(ip, state, icur, &PREV);
> > > > >  		xfs_iext_insert(ip, icur, new, state);
> > > > > -		ifp->if_nextents++;
> > > > > +
> > > > > +		error = xfs_next_set(ip, whichfork, 1);
> > > > > +		if (error)
> > > > > +			goto done;
> > > > >  
> > > > >  		if (cur == NULL)
> > > > >  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
> > > > > @@ -2419,7 +2451,10 @@ xfs_bmap_add_extent_unwritten_real(
> > > > >  		xfs_iext_update_extent(ip, state, icur, &PREV);
> > > > >  		xfs_iext_next(ifp, icur);
> > > > >  		xfs_iext_insert(ip, icur, new, state);
> > > > > -		ifp->if_nextents++;
> > > > > +
> > > > > +		error = xfs_next_set(ip, whichfork, 1);
> > > > > +		if (error)
> > > > > +			goto done;
> > > > >  
> > > > >  		if (cur == NULL)
> > > > >  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
> > > > > @@ -2471,7 +2506,10 @@ xfs_bmap_add_extent_unwritten_real(
> > > > >  		xfs_iext_next(ifp, icur);
> > > > >  		xfs_iext_insert(ip, icur, &r[1], state);
> > > > >  		xfs_iext_insert(ip, icur, &r[0], state);
> > > > > -		ifp->if_nextents += 2;
> > > > > +
> > > > > +		error = xfs_next_set(ip, whichfork, 2);
> > > > > +		if (error)
> > > > > +			goto done;
> > > > >  
> > > > >  		if (cur == NULL)
> > > > >  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
> > > > > @@ -2787,7 +2825,10 @@ xfs_bmap_add_extent_hole_real(
> > > > >  		xfs_iext_remove(ip, icur, state);
> > > > >  		xfs_iext_prev(ifp, icur);
> > > > >  		xfs_iext_update_extent(ip, state, icur, &left);
> > > > > -		ifp->if_nextents--;
> > > > > +
> > > > > +		error = xfs_next_set(ip, whichfork, -1);
> > > > > +		if (error)
> > > > > +			goto done;
> > > > >  
> > > > >  		if (cur == NULL) {
> > > > >  			rval = XFS_ILOG_CORE | xfs_ilog_fext(whichfork);
> > > > > @@ -2886,7 +2927,10 @@ xfs_bmap_add_extent_hole_real(
> > > > >  		 * Insert a new entry.
> > > > >  		 */
> > > > >  		xfs_iext_insert(ip, icur, new, state);
> > > > > -		ifp->if_nextents++;
> > > > > +
> > > > > +		error = xfs_next_set(ip, whichfork, 1);
> > > > > +		if (error)
> > > > > +			goto done;
> > > > >  
> > > > >  		if (cur == NULL) {
> > > > >  			rval = XFS_ILOG_CORE | xfs_ilog_fext(whichfork);
> > > > > @@ -5083,7 +5127,10 @@ xfs_bmap_del_extent_real(
> > > > >  		 */
> > > > >  		xfs_iext_remove(ip, icur, state);
> > > > >  		xfs_iext_prev(ifp, icur);
> > > > > -		ifp->if_nextents--;
> > > > > +
> > > > > +		error = xfs_next_set(ip, whichfork, -1);
> > > > > +		if (error)
> > > > > +			goto done;
> > > > >  
> > > > >  		flags |= XFS_ILOG_CORE;
> > > > >  		if (!cur) {
> > > > > @@ -5193,7 +5240,10 @@ xfs_bmap_del_extent_real(
> > > > >  		} else
> > > > >  			flags |= xfs_ilog_fext(whichfork);
> > > > >  
> > > > > -		ifp->if_nextents++;
> > > > > +		error = xfs_next_set(ip, whichfork, 1);
> > > > > +		if (error)
> > > > > +			goto done;
> > > > > +
> > > > >  		xfs_iext_next(ifp, icur);
> > > > >  		xfs_iext_insert(ip, icur, &new, state);
> > > > >  		break;
> > > > > @@ -5660,7 +5710,10 @@ xfs_bmse_merge(
> > > > >  	 * Update the on-disk extent count, the btree if necessary and log the
> > > > >  	 * inode.
> > > > >  	 */
> > > > > -	ifp->if_nextents--;
> > > > > +	error = xfs_next_set(ip, whichfork, -1);
> > > > > +	if (error)
> > > > > +		goto done;
> > > > > +
> > > > >  	*logflags |= XFS_ILOG_CORE;
> > > > >  	if (!cur) {
> > > > >  		*logflags |= XFS_ILOG_DEXT;
> > > > > @@ -6047,7 +6100,10 @@ xfs_bmap_split_extent(
> > > > >  	/* Add new extent */
> > > > >  	xfs_iext_next(ifp, &icur);
> > > > >  	xfs_iext_insert(ip, &icur, &new, 0);
> > > > > -	ifp->if_nextents++;
> > > > > +
> > > > > +	error = xfs_next_set(ip, whichfork, 1);
> > > > > +	if (error)
> > > > > +		goto del_cursor;
> > > > >  
> > > > >  	if (cur) {
> > > > >  		error = xfs_bmbt_lookup_eq(cur, &new, &i);
> > > > > diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> > > > > index 28b366275ae0..3bf5a2c391bd 100644
> > > > > --- a/fs/xfs/libxfs/xfs_inode_fork.c
> > > > > +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> > > > > @@ -728,3 +728,32 @@ xfs_ifork_verify_local_attr(
> > > > >  
> > > > >  	return 0;
> > > > >  }
> > > > > +
> > > > > +int
> > > > > +xfs_next_set(
> > > > 
> > > > "next"... please choose an abbreviation that doesn't collide with a
> > > > common English word.
> > > > 
> > > > > +	struct xfs_inode	*ip,
> > > > > +	int			whichfork,
> > > > > +	int			delta)
> > > > 
> > > > Delta?  I thought this was a setter function?
> > > > 
> > > > > +{
> > > > > +	struct xfs_ifork	*ifp;
> > > > > +	int64_t			nr_exts;
> > > > > +	int64_t			max_exts;
> > > > > +
> > > > > +	ifp = XFS_IFORK_PTR(ip, whichfork);
> > > > > +
> > > > > +	if (whichfork == XFS_DATA_FORK || whichfork == XFS_COW_FORK)
> > > > > +		max_exts = MAXEXTNUM;
> > > > > +	else if (whichfork == XFS_ATTR_FORK)
> > > > > +		max_exts = MAXAEXTNUM;
> > > > > +	else
> > > > > +		ASSERT(0);
> > > > > +
> > > > > +	nr_exts = ifp->if_nextents + delta;
> > > > 
> > > > Nope, it's a modify function all right.  Then it should be named:
> > > > 
> > > > xfs_nextents_mod(ip, whichfork, delta)
> > > > 
> > > > > +	if ((delta > 0 && nr_exts > max_exts)
> > > > > +		|| (delta < 0 && nr_exts < 0))
> > > > 
> > > > Line these up, please.  e.g.,
> > > > 
> > > > 	if ((delta > 0 && nr_exts > max_exts) ||
> > > >             (delta < 0 && nr_exts < 0))
> 
> HA even the maintainer gets it wrong. :(
> 
> > > > 
> > > > --D
> > > > 
> > > > > +		return -EOVERFLOW;
> > > 
> > > Oh, also, shouldn't this be EFBIG ("File too big")?
> > 
> > True, EFBIG is more appropriate than EOVERFLOW in this case.
> > 
> > Darrick, I have one question. The purpose of this patch is to fix the zero day
> > bug where we overflow extent counter silently and get to know about it only
> > when flushing the incore inode to disk. Patches that come later in the series
> > modify the extent count limits to 2^32 (for xattr fork) and 2^47 (for data
> > fork). If this patch is not required to be sent to stable release, I will drop
> > it from the series.
> 
> I would leave it in the series, unless you mean to send this as a
> separate cleanup ahead of everything else?
> 
> Now that I think about it, this probably should become its own cleanup
> series.  I just realized that if we error out EFBIG in the middle of a
> bmap function, we're probably going to end up cancelling a dirty
> transaction, which will cause an fs shutdown.  Since xfs cannot undo the
> effects of a dirty transaction, we have to be able to error out earlier
> in the transaction sequence so that we can back out to userspace without
> affecting the filesystem.
> 
> IOWs, this means that any code path that could increase an inode's
> extent count will have to check the the inode (after we take the ILOCK)
> to make sure that it can accomodate however many more extents we're
> adding.
> 
> static int
> xfs_trans_inode_reserve_extent_count(ip, whichfork, nrtoadd)
> {
> 	if (MAX{,A}EXTNUM - XFS_IFORK_PTR(ip, whichfork)->if_nextents < nrtoadd)
> 		return -EFBIG;
> 	return 0;
> }
> 
> 	error = xfs_trans_alloc(..., &tp);
> 	if (error)
> 		goto out;
> 
> 	xfs_ilock(ip, XFS_ILOCK_EXCL);
> 	xfs_trans_ijoin(ip, 0);
> 
> 	error = xfs_trans_inode_reserve_extent_count(ip, whichfork, nrtoadd)
> 	if (error)
> 		goto out;
> 
> 	error = xfs_trans_reserve_quota_nblks(tp, ip, ...);
> 	if (error)
> 		goto out;
> 
> ...or something like that.  And now suddenly this grows into its own
> cleanup series. :/


Ok. I will work on the cleanup series while we are reaching consensus on the
log reservation changes.

Thanks once again for the suggestions.

> 
> > Also, I can't have a "fixes" tag because this is a zero
> > day bug.
> 
> Everything is a zero day now... but establishing a base for this one is
> probably not going to be easy since I bet the overflow has existed since
> the beginning.
> 
> --D
> 
> > 
> > > 
> > > --D
> > > 
> > > > > +
> > > > > +	ifp->if_nextents = nr_exts;
> > > > > +
> > > > > +	return 0;
> > > > > +}
> > > > > diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> > > > > index a4953e95c4f3..a84ae42ace79 100644
> > > > > --- a/fs/xfs/libxfs/xfs_inode_fork.h
> > > > > +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> > > > > @@ -173,4 +173,5 @@ extern void xfs_ifork_init_cow(struct xfs_inode *ip);
> > > > >  int xfs_ifork_verify_local_data(struct xfs_inode *ip);
> > > > >  int xfs_ifork_verify_local_attr(struct xfs_inode *ip);
> > > > >  
> > > > > +int xfs_next_set(struct xfs_inode *ip, int whichfork, int delta);
> > > > >  #endif	/* __XFS_INODE_FORK_H__ */
> > > 
> > 
> > 
> 

-- 
chandan



