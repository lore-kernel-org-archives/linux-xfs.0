Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AEFDC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 12 May 2022 19:13:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357939AbiELTNf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 May 2022 15:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357938AbiELTNe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 May 2022 15:13:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0338E4B1D4
        for <linux-xfs@vger.kernel.org>; Thu, 12 May 2022 12:13:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2730DB8290E
        for <linux-xfs@vger.kernel.org>; Thu, 12 May 2022 19:13:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8575C385B8;
        Thu, 12 May 2022 19:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652382809;
        bh=olw6jbU1w1etY6b9Sk/1NXjQ8gpD2N5zlj88gWHwRDw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HJtwBhDPWQ8K07FH4Aa/ASFYS7qRQdRnJDkrBZL3xxSZigthDQ5thoceWpMHgRWih
         /I5u3grdBgppshJJsoU5INNNsAl9GkLWPy7GeYNcdcqjjCuyWci1ynTjkmtxcqxNJP
         ++eCCXUj00GzSfF3/gf6nUhRu8qQArf/53kT4F3Ea0i5X7SpkSJ9S50rVHdhHhgbun
         rk9XXfT6cA85ueoGC+pAbctRBG2BIV1L718Sq7x4CeBTTWxsCeh1KEqt5o1z59623V
         VP7oWE1rvuYdMWqSkpc31/jvg0lVxjmGzteh5xc7kvSGJr/Tl8GKIp3Wh48KWsvSXh
         ToFLh4Dbpwzog==
Date:   Thu, 12 May 2022 12:13:29 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs_repair: detect v5 featureset mismatches in
 secondary supers
Message-ID: <20220512191329.GH27195@magnolia>
References: <165176674590.248791.17672675617466150793.stgit@magnolia>
 <165176675148.248791.14783205262181556770.stgit@magnolia>
 <57914c5f-c39a-e3de-14cf-6565ee82f834@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57914c5f-c39a-e3de-14cf-6565ee82f834@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 12, 2022 at 02:02:33PM -0500, Eric Sandeen wrote:
> On 5/5/22 11:05 AM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Make sure we detect and correct mismatches between the V5 features
> > described in the primary and the secondary superblocks.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> 
> 
> > +	if ((mp->m_sb.sb_features_incompat ^ sb->sb_features_incompat) &
> > +			~XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR) {
> 
> I'd like to add a comment about why XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR is special.
> (Why is XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR special? Just because userspace doesn't
> bother to set it on all superblocks in the upgrade paths, right?)

Right -- we only set it on the primary super to force users to run
xfs_repair.  Repair will clear NEEDSREPAIR on the primary and all
secondaries before it exits, so there's no point in complaining about
discrepancies in that particular feature bit.

--D

> -Eric
> 
