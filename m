Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E89A3C64ED8
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Feb 2023 17:09:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbjB0RJj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Feb 2023 12:09:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjB0RJi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Feb 2023 12:09:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0BCB1EBD7
        for <linux-xfs@vger.kernel.org>; Mon, 27 Feb 2023 09:09:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 36AC660EC4
        for <linux-xfs@vger.kernel.org>; Mon, 27 Feb 2023 17:09:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DE21C433D2;
        Mon, 27 Feb 2023 17:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677517776;
        bh=E4P+iVIi1COIgq/2R2oXlBDTofQqjyLYbkK7qxUk4Ho=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Qih87W4boBv2yIWiItvFjwS3JD940FXjzMHICTuIJyZkPC2Wipl3gs8p1OjKiSfv9
         k4XFO0Uw52gOxt7PElbVtKio8aLR8NxTIkTgFMDedtndSsutyrt5E7jPGNSsjF2aY0
         vj/HbMl1DnnVuJ30QtPdDkdsMesXUiBn61p2iEZGAg3fAJCTXNYUDA+3k2aGQqsL80
         wPMaKWoUR4tLC7hyHTViZ/88l7NbH4LWI95grPE7cxifUI5CVB7Lrbv2T5AgMAQ1Rz
         IXoxh0pAcQYK7QfUlCUgTKBcG/SWRduG3pAh2vQyrA9uny2aJ+t5ZbI7UZb4RO3cc5
         B4DNSkxjcMA9w==
Date:   Mon, 27 Feb 2023 09:09:35 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: restore old agirotor behavior
Message-ID: <Y/zjzx/4mQIYh6BC@magnolia>
References: <Y/WoHLYbp82Xj7H8@magnolia>
 <20230226220201.GT360264@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230226220201.GT360264@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 27, 2023 at 09:02:01AM +1100, Dave Chinner wrote:
> On Tue, Feb 21, 2023 at 09:29:00PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Prior to the removal of xfs_ialloc_next_ag, we would increment the agi
> > rotor and return the *old* value.  atomic_inc_return returns the new
> > value, which causes mkfs to allocate the root directory in AG 1.  Put
> > back the old behavior (at least for mkfs) by subtracting 1 here.
> > 
> > Fixes: 20a5eab49d35 ("xfs: convert xfs_ialloc_next_ag() to an atomic")
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/libxfs/xfs_ialloc.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> > index 65832c74e86c..550c6351e9b6 100644
> > --- a/fs/xfs/libxfs/xfs_ialloc.c
> > +++ b/fs/xfs/libxfs/xfs_ialloc.c
> > @@ -1729,7 +1729,7 @@ xfs_dialloc(
> >  	 * an AG has enough space for file creation.
> >  	 */
> >  	if (S_ISDIR(mode))
> > -		start_agno = atomic_inc_return(&mp->m_agirotor) % mp->m_maxagi;
> > +		start_agno = (atomic_inc_return(&mp->m_agirotor) - 1) % mp->m_maxagi;
> >  	else {
> >  		start_agno = XFS_INO_TO_AGNO(mp, parent);
> >  		if (start_agno >= mp->m_maxagi)
> 
> Change is fine, but it pushes the code to 85 columns. If you clean
> it up to:
> 
> 	if (S_ISDIR(mode)) {
> 		start_agno = (atomic_inc_return(&mp->m_agirotor) - 1) %
> 				mp->m_maxagi;
> 	} else {
> 		....
> 
> Then you can add:
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Thanks, merged with tweaks!

--D

> 
> -- 
> Dave Chinner
> david@fromorbit.com
