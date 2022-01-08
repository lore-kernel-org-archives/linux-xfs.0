Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3858C433EF
	for <linux-xfs@archiver.kernel.org>; Sat,  8 Jan 2022 18:28:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbiAHS2Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 8 Jan 2022 13:28:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbiAHS2P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 8 Jan 2022 13:28:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D4EAC06173F
        for <linux-xfs@vger.kernel.org>; Sat,  8 Jan 2022 10:28:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 886CF60A5F
        for <linux-xfs@vger.kernel.org>; Sat,  8 Jan 2022 18:28:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1C21C36AE0;
        Sat,  8 Jan 2022 18:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641666493;
        bh=E9ljhlXar2dFLAVDsfFshaZ2YPq0FqmlGzCb8SBGpgM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=twZPRrYynRlXm9fNAoI5JzuU59s5G4Tok9TdPJzBycl3GIK9fH/mo+WBD+CI7lqty
         lHxfP7Gb1FLlJPWU//qIYqBNgrQXTjJ9No7mrSMSj8clCwm4wAqvZTDnmMtSIuoM6q
         wFfuzc7kP1PxZNdarlUai4BICIolJFAGgTO4DYXMnZcgpdBAf8kyu0Y6X9w3HC+n7Q
         m2QxpHss5o5jgLKZDur5nuUndDHHY3vrFwfUwmFDtqCi6rxvPSeCzo3z1ajRMrE/ZY
         t4THlMYbhWfwJTOzzBDER/5w3wxovYIXq4HCrAQ5DhSBC+qLsGrLgh4XXdeNieEhO0
         CKS9kS1nwfV6g==
Date:   Sat, 8 Jan 2022 10:28:13 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V4 19/20] xfsprogs: Add support for upgrading to NREXT64
 feature
Message-ID: <20220108182813.GT656707@magnolia>
References: <20211214084811.764481-1-chandan.babu@oracle.com>
 <20211214084811.764481-20-chandan.babu@oracle.com>
 <20220105011731.GF656707@magnolia>
 <8735lzwmex.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20220107190346.GS656707@magnolia>
 <87sftyursn.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sftyursn.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jan 08, 2022 at 09:46:08PM +0530, Chandan Babu R wrote:
> On 08 Jan 2022 at 00:33, Darrick J. Wong wrote:
> > On Fri, Jan 07, 2022 at 09:47:10PM +0530, Chandan Babu R wrote:
> >> On 05 Jan 2022 at 06:47, Darrick J. Wong wrote:
> >> > On Tue, Dec 14, 2021 at 02:18:10PM +0530, Chandan Babu R wrote:
> >> >> This commit adds support to xfs_repair to allow upgrading an existing
> >> >> filesystem to support per-inode large extent counters.
> >> >> 
> >> >> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> >> >> ---
> >> >>  repair/globals.c    |  1 +
> >> >>  repair/globals.h    |  1 +
> >> >>  repair/phase2.c     | 35 ++++++++++++++++++++++++++++++++++-
> >> >>  repair/xfs_repair.c | 11 +++++++++++
> >> >>  4 files changed, 47 insertions(+), 1 deletion(-)
> >> >> 
> >> >> diff --git a/repair/globals.c b/repair/globals.c
> >> >> index d89507b1..2f29391a 100644
> >> >> --- a/repair/globals.c
> >> >> +++ b/repair/globals.c
> >> >> @@ -53,6 +53,7 @@ bool	add_bigtime;		/* add support for timestamps up to 2486 */
> >> >>  bool	add_finobt;		/* add free inode btrees */
> >> >>  bool	add_reflink;		/* add reference count btrees */
> >> >>  bool	add_rmapbt;		/* add reverse mapping btrees */
> >> >> +bool	add_nrext64;
> >> >>  
> >> >>  /* misc status variables */
> >> >>  
> >> >> diff --git a/repair/globals.h b/repair/globals.h
> >> >> index 53ff2532..af0bcb6b 100644
> >> >> --- a/repair/globals.h
> >> >> +++ b/repair/globals.h
> >> >> @@ -94,6 +94,7 @@ extern bool	add_bigtime;		/* add support for timestamps up to 2486 */
> >> >>  extern bool	add_finobt;		/* add free inode btrees */
> >> >>  extern bool	add_reflink;		/* add reference count btrees */
> >> >>  extern bool	add_rmapbt;		/* add reverse mapping btrees */
> >> >> +extern bool	add_nrext64;
> >> >>  
> >> >>  /* misc status variables */
> >> >>  
> >> >> diff --git a/repair/phase2.c b/repair/phase2.c
> >> >> index c811ed5d..c9db3281 100644
> >> >> --- a/repair/phase2.c
> >> >> +++ b/repair/phase2.c
> >> >> @@ -191,6 +191,7 @@ check_new_v5_geometry(
> >> >>  	struct xfs_perag	*pag;
> >> >>  	xfs_agnumber_t		agno;
> >> >>  	xfs_ino_t		rootino;
> >> >> +	uint			old_bm_maxlevels[2];
> >> >>  	int			min_logblocks;
> >> >>  	int			error;
> >> >>  
> >> >> @@ -201,6 +202,12 @@ check_new_v5_geometry(
> >> >>  	memcpy(&old_sb, &mp->m_sb, sizeof(struct xfs_sb));
> >> >>  	memcpy(&mp->m_sb, new_sb, sizeof(struct xfs_sb));
> >> >>  
> >> >> +	old_bm_maxlevels[0] = mp->m_bm_maxlevels[0];
> >> >> +	old_bm_maxlevels[1] = mp->m_bm_maxlevels[1];
> >> >> +
> >> >> +	xfs_bmap_compute_maxlevels(mp, XFS_DATA_FORK);
> >> >> +	xfs_bmap_compute_maxlevels(mp, XFS_ATTR_FORK);
> >> >
> >> > Ahh... I see why you added my (evil) patch that allows upgrading a
> >> > filesystem to reflink -- you need the check_new_v5_geometry function so
> >> > that you can check if the log size is big enough to handle larger bmbt
> >> > trees.
> >> >
> >> > Hmm, I guess I should work on separating this from the actual
> >> > rmap/reflink/finobt upgrade code, since I have no idea if we /ever/ want
> >> > to support that.
> >> >
> >> 
> >> I can do that. I will include the trimmed down version of the patch before
> >> posting the patchset once again.
> >
> > I separated that megapatch into smaller pieces yesterday, so I'll point
> > you to it once it all goes through QA.
> >
> 
> Ok. I will wait.

Here's one patch to fix a bug I found in the upgrade code, because
apparently we weren't resyncing the secondary superblocks

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/commit/?h=upgrade-older-features&id=e0f4bff35adcae98943ee95701c207c628940d8f

And here's an updated version of xfs_repair infrastructure you need to
add nrext64, without the extraneous code to add other features.  It also
now recomputes m_features and the maxlevels values so you don't have to
do that anymore.

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/commit/?h=upgrade-older-features&id=acaf9c0355ee09da035845f15b4e44ba2ec24a6e

--D

> 
> -- 
> chandan
