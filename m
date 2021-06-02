Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47798C4708F
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 06:16:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F94361027
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 06:16:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbhFBGSb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Jun 2021 02:18:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:53340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230420AbhFBGSb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 2 Jun 2021 02:18:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F16960FDC;
        Wed,  2 Jun 2021 06:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622614609;
        bh=EBEOBGbIZkRUpgDqkNx5KH0tk52idYdGp7FyKLHlANY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jU6mHAjN1nF36PBX4IRUm7wB7TamTq+9a8UbA6QA/P2hDo6ztmiQY6vvgye7ZmAsk
         N95SK0gnZs2jIk5V+s9aOMvtd5p0Qly2BEUOPrk3QbPaw8mMNfVkYrRKASW22kct4k
         drMmexIx3cV+vo7EHaSy/HG1orVPOCiDdrxsk0t/+6rOr+3FxkS/HLNp7m1dO3wtmS
         jEHv4ITFL6IqSsSsM/5DnTryoTu88DkMopPN7ZvSgMib11q6w2Oc2Lfk8uVoYDHd7m
         FqgPNMRm1FblfhLh40ikVkPH2St2Wb1IpzICkpzKn0eGkphWBzb5LaLKILG8w3h8NE
         3twySQFdaTgEg==
Date:   Tue, 1 Jun 2021 23:16:48 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 13/14] xfs: merge xfs_reclaim_inodes_ag into
 xfs_inode_walk_ag
Message-ID: <20210602061648.GI26380@locust>
References: <162259515220.662681.6750744293005850812.stgit@locust>
 <162259522416.662681.8769645421908758261.stgit@locust>
 <20210602021055.GS664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210602021055.GS664593@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 02, 2021 at 12:10:55PM +1000, Dave Chinner wrote:
> On Tue, Jun 01, 2021 at 05:53:44PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Merge these two inode walk loops together, since they're pretty similar
> > now.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_icache.c |  151 +++++++++++++--------------------------------------
> >  fs/xfs/xfs_icache.h |    7 ++
> >  2 files changed, 45 insertions(+), 113 deletions(-)
> 
> At last! Nice work.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> > @@ -1678,6 +1577,14 @@ xfs_blockgc_free_quota(
> >  
> >  /* XFS Incore Inode Walking Code */
> 
> FWIW, if we are using "icwalk" as the namespace, I keep saying
> "inode cache walk" in my head. Perhaps update this comment somewhere
> to match the namespace?

Done.

--D

> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
