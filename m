Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DBF6C433F5
	for <linux-xfs@archiver.kernel.org>; Fri,  7 Jan 2022 19:03:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbiAGTDt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 7 Jan 2022 14:03:49 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60260 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbiAGTDs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Jan 2022 14:03:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F2B7161F90
        for <linux-xfs@vger.kernel.org>; Fri,  7 Jan 2022 19:03:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 470FBC36AE0;
        Fri,  7 Jan 2022 19:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641582227;
        bh=5tRPNAGeOFvRCd+Mkn4bKm12q/7Wdf5yl0+GVGFwHwM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JoJcflQQdRLM9A1CJ/G30FKaj396qPbU9Mgg1LISvO4X8daVxpEp7LXE+xvRPuPib
         qKNWRY6Z964U4moBZrKxOUmpxa5CaWyfH0Iiyz/u9a8NHimm/CwlVQnxBQAWMtEPyn
         5RBSRbqs6v2nfjdtwduNwEcnyiDFG4yFq3OXX1l1hCHYwKMktb61xSxPWKF3mpo0bD
         wrXyyibW1+IS7R5lKhCIrR8aBHV7GYAbKl285IPfhDAwMzvVrS3RZXq428cEfesM2e
         Oz6vKBqStXJ0cw77lp69Ywab9k2Sgd3o8W+4XEPCfqInLz4B4Ef/oqIdBzhc/joWXZ
         sxxkI9TM8Lfzw==
Date:   Fri, 7 Jan 2022 11:03:46 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V4 19/20] xfsprogs: Add support for upgrading to NREXT64
 feature
Message-ID: <20220107190346.GS656707@magnolia>
References: <20211214084811.764481-1-chandan.babu@oracle.com>
 <20211214084811.764481-20-chandan.babu@oracle.com>
 <20220105011731.GF656707@magnolia>
 <8735lzwmex.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8735lzwmex.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 07, 2022 at 09:47:10PM +0530, Chandan Babu R wrote:
> On 05 Jan 2022 at 06:47, Darrick J. Wong wrote:
> > On Tue, Dec 14, 2021 at 02:18:10PM +0530, Chandan Babu R wrote:
> >> This commit adds support to xfs_repair to allow upgrading an existing
> >> filesystem to support per-inode large extent counters.
> >> 
> >> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> >> ---
> >>  repair/globals.c    |  1 +
> >>  repair/globals.h    |  1 +
> >>  repair/phase2.c     | 35 ++++++++++++++++++++++++++++++++++-
> >>  repair/xfs_repair.c | 11 +++++++++++
> >>  4 files changed, 47 insertions(+), 1 deletion(-)
> >> 
> >> diff --git a/repair/globals.c b/repair/globals.c
> >> index d89507b1..2f29391a 100644
> >> --- a/repair/globals.c
> >> +++ b/repair/globals.c
> >> @@ -53,6 +53,7 @@ bool	add_bigtime;		/* add support for timestamps up to 2486 */
> >>  bool	add_finobt;		/* add free inode btrees */
> >>  bool	add_reflink;		/* add reference count btrees */
> >>  bool	add_rmapbt;		/* add reverse mapping btrees */
> >> +bool	add_nrext64;
> >>  
> >>  /* misc status variables */
> >>  
> >> diff --git a/repair/globals.h b/repair/globals.h
> >> index 53ff2532..af0bcb6b 100644
> >> --- a/repair/globals.h
> >> +++ b/repair/globals.h
> >> @@ -94,6 +94,7 @@ extern bool	add_bigtime;		/* add support for timestamps up to 2486 */
> >>  extern bool	add_finobt;		/* add free inode btrees */
> >>  extern bool	add_reflink;		/* add reference count btrees */
> >>  extern bool	add_rmapbt;		/* add reverse mapping btrees */
> >> +extern bool	add_nrext64;
> >>  
> >>  /* misc status variables */
> >>  
> >> diff --git a/repair/phase2.c b/repair/phase2.c
> >> index c811ed5d..c9db3281 100644
> >> --- a/repair/phase2.c
> >> +++ b/repair/phase2.c
> >> @@ -191,6 +191,7 @@ check_new_v5_geometry(
> >>  	struct xfs_perag	*pag;
> >>  	xfs_agnumber_t		agno;
> >>  	xfs_ino_t		rootino;
> >> +	uint			old_bm_maxlevels[2];
> >>  	int			min_logblocks;
> >>  	int			error;
> >>  
> >> @@ -201,6 +202,12 @@ check_new_v5_geometry(
> >>  	memcpy(&old_sb, &mp->m_sb, sizeof(struct xfs_sb));
> >>  	memcpy(&mp->m_sb, new_sb, sizeof(struct xfs_sb));
> >>  
> >> +	old_bm_maxlevels[0] = mp->m_bm_maxlevels[0];
> >> +	old_bm_maxlevels[1] = mp->m_bm_maxlevels[1];
> >> +
> >> +	xfs_bmap_compute_maxlevels(mp, XFS_DATA_FORK);
> >> +	xfs_bmap_compute_maxlevels(mp, XFS_ATTR_FORK);
> >
> > Ahh... I see why you added my (evil) patch that allows upgrading a
> > filesystem to reflink -- you need the check_new_v5_geometry function so
> > that you can check if the log size is big enough to handle larger bmbt
> > trees.
> >
> > Hmm, I guess I should work on separating this from the actual
> > rmap/reflink/finobt upgrade code, since I have no idea if we /ever/ want
> > to support that.
> >
> 
> I can do that. I will include the trimmed down version of the patch before
> posting the patchset once again.

I separated that megapatch into smaller pieces yesterday, so I'll point
you to it once it all goes through QA.

--D

> > --D
> >
> >> +
> >>  	/* Do we have a big enough log? */
> >>  	min_logblocks = libxfs_log_calc_minimum_size(mp);
> >>  	if (old_sb.sb_logblocks < min_logblocks) {
> >> @@ -288,6 +295,9 @@ check_new_v5_geometry(
> >>  		pag->pagi_init = 0;
> >>  	}
> >>  
> >> +	mp->m_bm_maxlevels[0] = old_bm_maxlevels[0];
> >> +	mp->m_bm_maxlevels[1] = old_bm_maxlevels[1];
> >> +
> >>  	/*
> >>  	 * Put back the old superblock.
> >>  	 */
> >> @@ -366,6 +376,28 @@ set_rmapbt(
> >>  	return true;
> >>  }
> >>  
> >> +static bool
> >> +set_nrext64(
> >> +	struct xfs_mount	*mp,
> >> +	struct xfs_sb		*new_sb)
> >> +{
> >> +	if (!xfs_sb_version_hascrc(&mp->m_sb)) {
> >> +		printf(
> >> +	_("Nrext64 only supported on V5 filesystems.\n"));
> >> +		exit(0);
> >> +	}
> >> +
> >> +	if (xfs_sb_version_hasnrext64(&mp->m_sb)) {
> >> +		printf(_("Filesystem already supports nrext64.\n"));
> >> +		exit(0);
> >> +	}
> >> +
> >> +	printf(_("Adding nrext64 to filesystem.\n"));
> >> +	new_sb->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NREXT64;
> >> +	new_sb->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
> >> +	return true;
> >> +}
> >> +
> >>  /* Perform the user's requested upgrades on filesystem. */
> >>  static void
> >>  upgrade_filesystem(
> >> @@ -388,7 +420,8 @@ upgrade_filesystem(
> >>  		dirty |= set_reflink(mp, &new_sb);
> >>  	if (add_rmapbt)
> >>  		dirty |= set_rmapbt(mp, &new_sb);
> >> -
> >> +	if (add_nrext64)
> >> +		dirty |= set_nrext64(mp, &new_sb);
> >>  	if (!dirty)
> >>  		return;
> >>  
> >> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> >> index e250a5bf..96c9bb56 100644
> >> --- a/repair/xfs_repair.c
> >> +++ b/repair/xfs_repair.c
> >> @@ -70,6 +70,7 @@ enum c_opt_nums {
> >>  	CONVERT_FINOBT,
> >>  	CONVERT_REFLINK,
> >>  	CONVERT_RMAPBT,
> >> +	CONVERT_NREXT64,
> >>  	C_MAX_OPTS,
> >>  };
> >>  
> >> @@ -80,6 +81,7 @@ static char *c_opts[] = {
> >>  	[CONVERT_FINOBT]	= "finobt",
> >>  	[CONVERT_REFLINK]	= "reflink",
> >>  	[CONVERT_RMAPBT]	= "rmapbt",
> >> +	[CONVERT_NREXT64]	= "nrext64",
> >>  	[C_MAX_OPTS]		= NULL,
> >>  };
> >>  
> >> @@ -357,6 +359,15 @@ process_args(int argc, char **argv)
> >>  		_("-c rmapbt only supports upgrades\n"));
> >>  					add_rmapbt = true;
> >>  					break;
> >> +				case CONVERT_NREXT64:
> >> +					if (!val)
> >> +						do_abort(
> >> +		_("-c nrext64 requires a parameter\n"));
> >> +					if (strtol(val, NULL, 0) != 1)
> >> +						do_abort(
> >> +		_("-c nrext64 only supports upgrades\n"));
> >> +					add_nrext64 = true;
> >> +					break;
> >>  				default:
> >>  					unknown('c', val);
> >>  					break;
> >> -- 
> >> 2.30.2
> >> 
> 
> 
> -- 
> chandan
